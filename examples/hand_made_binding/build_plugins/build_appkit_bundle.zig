const std = @import("std");

pub const AppKitBundleStep = struct {
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

    pub fn setBundleName(self: *AppKitBundleStep, name: []const u8) void {
        self.bundleName = self.builder.dupe(name);
    }

    pub fn register(self: *Self) void {
        var topLevel = self.builder.step(self.step.name,  "Make MacOS app bundle");

        topLevel.dependOn(&self.artifact.step);
        topLevel.dependOn(&self.step);
    }

    fn makePlist(self: *Self, path: []u8, bundleName: []const u8) !void {
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
            , .{ bundleName });

        var f = try std.fs.createFileAbsolute(path, .{ });

        try f.writeAll(content);
    }

    fn make(step: *std.build.Step) !void {
        var self = @fieldParentPtr(Self, "step", step);

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
            try self.makePlist(plistPath, baseNmae);
        }
    }
};