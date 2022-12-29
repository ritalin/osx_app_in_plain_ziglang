const std = @import("std");

const objc = @import("objc.zig");

fn msgSend_1(self: objc.Class, selector: objc.SEL) objc.id {
    const FnType = fn (@TypeOf(self), objc.SEL) callconv(.C) objc.id;

    var func = @ptrCast(FnType, objc.objc_msgSend);

    return @call(.{}, func, .{ self, selector });
}
fn msgSend_2(self: objc.id, selector: objc.SEL, arg1: objc.NSInteger) bool {
    const FnType = fn (@TypeOf(self), objc.SEL, @TypeOf(arg1)) callconv(.C) bool;

    var func = @ptrCast(FnType, objc.objc_msgSend);

    return @call(.{}, func, .{ self, selector, arg1 });
}

// extern var NSApp: objc.id;

pub fn main() anyerror!void {
    var allocSEL: objc.SEL = objc.sel_registerName("alloc");
    std.debug.assert(allocSEL != null);

    // var initSEL: objc.SEL = objc.sel_registerName("init");

    var appClass: objc.Class = objc.objc_getClass("NSApplication");
    std.debug.assert(appClass != null);
    var sharedAppSEL: objc.SEL = objc.sel_registerName("sharedApplication");
    std.debug.assert(sharedAppSEL != null);

    var app: objc.id = msgSend_1(appClass, sharedAppSEL);

    var setActivationPolicySEL: objc.SEL = objc.sel_registerName("setActivationPolicy:");
    std.debug.assert(setActivationPolicySEL != null);

    _ = msgSend_2(app, setActivationPolicySEL, 0);

    std.debug.print("OK\n", .{});
}
