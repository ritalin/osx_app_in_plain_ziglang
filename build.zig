const std = @import("std");

const AppBundleStep = struct {
    artifact: *std.build.LibExeObjStep,
    step: std.build.Step,
    builder: *std.build.Builder, 
    bundleName: ?[]const u8,

    const Self = @This();

    pub fn init(b: *std.build.Builder, artifact: *std.build.LibExeObjStep) *Self {
        const self = b.allocator.create(Self) catch unreachable;
        self.* =  Self {
            .builder = b,
            .artifact = artifact,
            .bundleName = null,
            .step = std.build.Step.init(std.build.Step.Id.custom, "bundle", b.allocator, make),
        };

        return self;
    }

    pub fn setBundleName(self: *AppBundleStep, name: []const u8) void {
        self.bundleName = self.builder.dupe(name);
    }

    pub fn register(self: *Self) void {
        var topLevel = self.builder.step(self.step.name,  "Make MacOS app bundle");

        topLevel.dependOn(&self.artifact.step);
        topLevel.dependOn(&self.step);
    }

    fn makePlist(self: *Self, path: []u8) !void {
        var content = 
            try std.fmt.allocPrint(self.builder.allocator,
                \\<?xml version="1.0" encoding="UTF-8"?>
                \\<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
                \\<plist version="1.0">
                \\<dict>
                \\    <key>CFBundleExecutable</key>
                \\    <string>{0s}</string>
                \\    <key>CFBundleGetInfoString</key>
                \\    <string>{0s}</string>
                \\    <key>CFBundleIconFile</key>
                \\    <string>{0s}</string>
                \\    <key>CFBundleName</key>
                \\    <string>{0s}</string>
                \\    <key>CFBundlePackageType</key>
                \\    <string>APPL</string>
                \\</dict>
                \\</plist>
            , .{ self.bundleName });

        var f = try std.fs.createFileAbsolute(path, .{ });

        try f.writeAll(content);
    }

    fn make(step: *std.build.Step) !void {
        const self = @fieldParentPtr(Self, "step", step);

        var pathFrom = self.artifact.getOutputSource().getPath(self.builder);
        var pathTo = self.builder.install_path;
        var baseNmae = self.bundleName orelse self.artifact.out_filename;
        var bundleDir = self.builder.pathJoin(&.{ pathTo, self.builder.fmt("{s}.app", .{ baseNmae }) });

        var binDir = self.builder.pathJoin(&.{ bundleDir, "Contents", "MacOS" });
        var resDir = self.builder.pathJoin(&.{ bundleDir, "Contents", "Resources" });

        try std.fs.cwd().makePath(binDir);
        try std.fs.cwd().makePath(resDir);

        try self.builder.updateFile(pathFrom, self.builder.pathJoin(&.{ binDir, baseNmae }));

        var plistPath = self.builder.pathJoin(&.{ bundleDir, "Contents", "info.plist" });

        if (std.fs.cwd().statFile(plistPath)) |_| {
            if (self.builder.verbose) {
                std.debug.print("# up-to-date\n", .{});
            }
        } 
        else |_| {
            try self.makePlist(plistPath);
        }
    }
};

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("osx_app_in_plain_ziglang", "src/main.zig");
    exe.addSystemIncludeDir("/usr/include");
    exe.addFrameworkDir("/System/Library/Frameworks");
    exe.linkFramework("Foundation");
    exe.linkFramework("AppKit");
    exe.setTarget(target);
    exe.setBuildMode(mode);
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
    var bundleStep = AppBundleStep.init(b, exe);
    bundleStep.setBundleName("X");
    bundleStep.register();
}
