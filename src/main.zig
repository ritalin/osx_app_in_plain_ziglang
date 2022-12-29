const std = @import("std");
const objc = @cImport(@cInclude("objc/objc.h"));

pub fn main() anyerror!void {
    var allocSEL: objc.SEL = objc.sel_registerName("alloc");

    std.debug.assert(allocSEL != null);
    std.debug.print("OK\n", .{});
}