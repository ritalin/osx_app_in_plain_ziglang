const std = @import("std");
const objc = @cImport({
    @cInclude("objc/objc.h");
    @cInclude("objc/message.h");
});

fn msgSend_1(self: objc.Class, selector: objc.SEL) objc.id {
    const FnType = fn (objc.Class, objc.SEL) callconv(.C) objc.id;

    var func = @ptrCast(FnType, objc.objc_msgSend);

    return @call(.{}, func, .{ self, selector });
}

pub fn main() anyerror!void {
    var allocSEL: objc.SEL = objc.sel_registerName("alloc");
    // var initSEL: objc.SEL = objc.sel_registerName("init");

    var appClass: objc.Class = objc.objc_getClass("NSApplication");
    var sharedAppSEL: objc.SEL = objc.sel_registerName("sharedApplication");

    _ = msgSend_1(appClass, sharedAppSEL);

    std.debug.assert(allocSEL != null);
    std.debug.print("OK\n", .{});
}