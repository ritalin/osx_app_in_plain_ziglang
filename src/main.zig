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
fn msgSend_3(self: objc.id, selector: objc.SEL) void {
    const FnType = fn (@TypeOf(self), objc.SEL) callconv(.C) void;

    var func = @ptrCast(FnType, objc.objc_msgSend);

    return @call(.{}, func, .{ self, selector });
}
fn msgSend_4(self: objc.id, selector: objc.SEL) objc.id {
    const FnType = fn (@TypeOf(self), objc.SEL) callconv(.C) objc.id;

    var func = @ptrCast(FnType, objc.objc_msgSend);

    return @call(.{}, func, .{ self, selector });
}
fn msgSend_5(self: objc.id, selector: objc.SEL, arg1: objc.id) void {
    const FnType = fn (@TypeOf(self), objc.SEL, @TypeOf(arg1)) callconv(.C) void;

    var func = @ptrCast(FnType, objc.objc_msgSend);

    return @call(.{}, func, .{ self, selector, arg1 });
}
fn msgSend_6(self: objc.id, selector: objc.SEL, arg1: cg.CGRect, arg2: objc.NSInteger, arg3: objc.NSInteger, arg4: bool) objc.id {
    const FnType = fn (@TypeOf(self), objc.SEL, @TypeOf(arg1), @TypeOf(arg2), @TypeOf(arg3), @TypeOf(arg4)) callconv(.C) objc.id;

    var func = @ptrCast(FnType, objc.objc_msgSend);

    return @call(.{}, func, .{ self, selector, arg1, arg2, arg3, arg4 });
}

pub fn main() anyerror!void {
    var allocSEL: objc.SEL = objc.sel_registerName("alloc");
    std.debug.assert(allocSEL != null);

    var initSEL: objc.SEL = objc.sel_registerName("init");
    std.debug.assert(initSEL != null);

    var appClass: objc.Class = objc.objc_getClass("NSApplication");
    std.debug.assert(appClass != null);
    var sharedAppSEL: objc.SEL = objc.sel_registerName("sharedApplication");
    std.debug.assert(sharedAppSEL != null);

    var app: objc.id = msgSend_1(appClass, sharedAppSEL);
    std.debug.assert(app != null);

    var setActivationPolicySEL: objc.SEL = objc.sel_registerName("setActivationPolicy:");
    std.debug.assert(setActivationPolicySEL != null);

    _ = msgSend_2(app, setActivationPolicySEL, 0);

    var runSEL: objc.SEL = objc.sel_registerName("run");
    std.debug.assert(runSEL != null);

    msgSend_3(app, runSEL);

    var NSObjectClass: objc.Class = objc.objc_getClass("NSObject");
    std.debug.assert(NSObjectClass != null);

    var AppDelegateClass: objc.Class = objc.objc_allocateClassPair(NSObjectClass, "AppDelegate", 0);
    std.debug.assert(AppDelegateClass != null);

    var AppDelegateProtocol: [*c]objc.Protocol = objc.objc_getProtocol("NSApplicationDelegate");
    {
        var res: objc.BOOL = objc.class_addProtocol(AppDelegateClass, AppDelegateProtocol);
        std.debug.assert(res != 0);
    }

    var delegate: objc.id = brk: {
        var alloc: objc.id = msgSend_1(AppDelegateClass, allocSEL);
        std.debug.assert(alloc != null);

        break :brk msgSend_4(alloc, initSEL);
    };
    std.debug.assert(delegate != null);

    var setDelegateSEL: objc.SEL = objc.sel_registerName("setDelegate:");

    msgSend_5(app, setDelegateSEL, delegate);

    std.debug.print("OK\n", .{});
}
