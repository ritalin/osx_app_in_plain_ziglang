const std = @import("std");
const AppKitBundleStep = @import("build_plugins/build_appkit_bundle.zig").AppKitBundleStep;

const PathArray = [] const [] const u8;

fn grabFiles(b: *std.build.Builder, parent: []const u8) !PathArray {
    var buf = std.ArrayList([] const u8).init(b.allocator);

    var dir = try std.fs.cwd().openIterableDir(parent, .{});
    defer dir.close();

    var it = try dir.walk(b.allocator);

    while (try it.next()) |entry| {
        try buf.append(b.pathJoin(&.{ parent, entry.path }));
    }

    return buf.items;
}

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("hand_made_binding", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);

    exe.addFrameworkPath("/System/Library/Frameworks");
    exe.addSystemIncludePath("/usr/include");
    exe.linkFramework("Foundation");
    exe.linkFramework("AppKit");

    exe.addCSourceFiles(grabFiles(b, "src/appKit/runtime") catch unreachable, &[0][]const u8{});
    exe.addCSourceFiles(grabFiles(b, "src/foundation/runtime") catch unreachable, &[0][]const u8{});

    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_tests = b.addTest("src/main.zig");
    exe_tests.setTarget(target);
    exe_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);

    // MacOS app bundle Task
    var bundleStep = AppKitBundleStep.init(b, exe);
    bundleStep.setBundleName("XYZ");
    bundleStep.register();
}
