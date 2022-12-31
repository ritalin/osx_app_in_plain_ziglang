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
fn msgSend_6(self: objc.Class, selector: objc.SEL, arg1: [*c]const u8) objc.id {
    const FnType = fn (@TypeOf(self), objc.SEL, @TypeOf(arg1)) callconv(.C) objc.id;

    var func = @ptrCast(FnType, objc.objc_msgSend);

    return @call(.{}, func, .{ self, selector, arg1 });
}
fn msgSend_7(self: objc.id, selector: objc.SEL, arg1: objc.id, arg2: objc.SEL, arg3: objc.id) objc.id {
    const FnType = fn (@TypeOf(self), objc.SEL, @TypeOf(arg1), @TypeOf(arg2), @TypeOf(arg3)) callconv(.C) objc.id;

    var func = @ptrCast(FnType, objc.objc_msgSend);

    return @call(.{}, func, .{ self, selector, arg1, arg2, arg3 });
}
fn msgSend_8(self: objc.id, selector: objc.SEL, arg1: objc.id) objc.id {
    const FnType = fn (@TypeOf(self), objc.SEL, @TypeOf(arg1)) callconv(.C) objc.id;

    var func = @ptrCast(FnType, objc.objc_msgSend);

    return @call(.{}, func, .{ self, selector, arg1 });
}

fn shareedApp() objc.id {
    var appClass: objc.Class = objc.objc_getClass("NSApplication");
    std.debug.assert(appClass != null);
    var sharedAppSEL: objc.SEL = objc.sel_registerName("sharedApplication");
    std.debug.assert(sharedAppSEL != null);

    var app: objc.id = msgSend_1(appClass, sharedAppSEL);
    std.debug.assert(app != null);

    return app;  
}

fn makeQuitMenuItemName() objc.id {
    var NSProcessInfoClass: objc.Class = objc.objc_getClass("NSProcessInfo");
    std.debug.assert(NSProcessInfoClass != null);

    var processInfoSEL: objc.SEL = objc.sel_registerName("processInfo");
    std.debug.assert(processInfoSEL != null);

    var info: objc.id = msgSend_1(NSProcessInfoClass, processInfoSEL);
    std.debug.assert(info != null);

    var processNameSEL: objc.SEL = objc.sel_registerName("processName");
    std.debug.assert(processNameSEL != null);

    var name: objc.id = msgSend_4(info, processNameSEL);
    std.debug.assert(name != null);

    var NSStringClass: objc.Class = objc.objc_getClass("NSString");
    var stringWithUTF8StringSEL: objc.SEL = objc.sel_registerName("stringWithUTF8String:");
    var stringByAppendingStringSEL: objc.SEL = objc.sel_registerName("stringByAppendingString:");

    var prefix: objc.id = msgSend_6(NSStringClass, stringWithUTF8StringSEL, "Quit ");

    return msgSend_8(prefix, stringByAppendingStringSEL, name);
}

fn applicationWillFinishLaunching(_: objc.id, _: objc.SEL, _: objc.id) void {
    var allocSEL: objc.SEL = objc.sel_registerName("alloc");
    std.debug.assert(allocSEL != null);

    var initSEL: objc.SEL = objc.sel_registerName("init");
    std.debug.assert(initSEL != null);

    var NSMenuClass: objc.Class = objc.objc_getClass("NSMenu");
    std.debug.assert(NSMenuClass != null);

    var NSMenuItemClass: objc.Class = objc.objc_getClass("NSMenuItem");
    std.debug.assert(NSMenuItemClass != null);

    var addItemSEL: objc.SEL = objc.sel_registerName("addItem:");
    std.debug.assert(addItemSEL != null);

    var setSubmenuSEL: objc.SEL = objc.sel_registerName("setSubmenu:");
    std.debug.assert(setSubmenuSEL != null);

    // Menubar
    var mbar: objc.id = brk: {
        var alloc: objc.id = msgSend_1(NSMenuClass, allocSEL);
        std.debug.assert(alloc != null);

        break :brk msgSend_4(alloc, initSEL);
    };
    std.debug.assert(mbar != null);

    // App Menu
    var appMenuItem: objc.id = brk: {
        var alloc: objc.id = msgSend_1(NSMenuItemClass, allocSEL);

        break :brk msgSend_4(alloc, initSEL);
    };
    std.debug.assert(appMenuItem != null);

    msgSend_5(mbar, addItemSEL, appMenuItem);

    var appMenu: objc.id = brk: {
        var alloc: objc.id = msgSend_1(NSMenuClass, allocSEL);
        std.debug.assert(alloc != null);

        break :brk msgSend_4(alloc, initSEL); 
    };     
    std.debug.assert(appMenu != null);

    var quitMenuItem: objc.id = brk: {
        var alloc: objc.id = msgSend_1(NSMenuItemClass, allocSEL);
        std.debug.assert(alloc != null);

        var title: objc.id = makeQuitMenuItemName();
        std.debug.assert(title != null);

        var NSStringClass: objc.Class = objc.objc_getClass("NSString");
        std.debug.assert(NSStringClass != null);

        var stringWithUTF8StringSEL: objc.SEL = objc.sel_registerName("stringWithUTF8String:");
        var itemKey = msgSend_6(NSStringClass, stringWithUTF8StringSEL, "q");
        std.debug.assert(itemKey != null);

        var initWithTitleSEL: objc.SEL = objc.sel_registerName("initWithTitle:action:keyEquivalent:");
        std.debug.assert(initWithTitleSEL != null);

        var terminateSEL: objc.SEL = objc.sel_registerName("terminate:");
        std.debug.assert(terminateSEL != null);

        // break :brk msgSend_4(alloc, initSEL); 
        break :brk msgSend_7(alloc, initWithTitleSEL, title, terminateSEL, itemKey); 
    };
    std.debug.assert(quitMenuItem != null);

    msgSend_5(appMenu, addItemSEL, quitMenuItem);

    msgSend_5(appMenuItem, setSubmenuSEL, appMenu);

    var app: objc.id = shareedApp();

    var setMainMenuSEL: objc.SEL = objc.sel_registerName("setMainMenu:");
    std.debug.assert(setMainMenuSEL != null);

    msgSend_5(app, setMainMenuSEL, mbar);    
}

pub fn main() anyerror!void {
    var allocSEL: objc.SEL = objc.sel_registerName("alloc");
    std.debug.assert(allocSEL != null);

    var initSEL: objc.SEL = objc.sel_registerName("init");
    std.debug.assert(initSEL != null);

    var app: objc.id = shareedApp();

    var setActivationPolicySEL: objc.SEL = objc.sel_registerName("setActivationPolicy:");
    std.debug.assert(setActivationPolicySEL != null);

    _ = msgSend_2(app, setActivationPolicySEL, 0);

    var NSObjectClass: objc.Class = objc.objc_getClass("NSObject");
    std.debug.assert(NSObjectClass != null);

    var AppDelegateClass: objc.Class = objc.objc_allocateClassPair(NSObjectClass, "AppDelegate", 0);
    std.debug.assert(AppDelegateClass != null);

    {
        var AppDelegateProtocol: [*c]objc.Protocol = objc.objc_getProtocol("NSApplicationDelegate");

        var res: objc.BOOL = objc.class_addProtocol(AppDelegateClass, AppDelegateProtocol);
        std.debug.assert(res != 0);
    }

    {
        var willFinishLaunchingSEL: objc.SEL = objc.sel_registerName("applicationWillFinishLaunching:");
        std.debug.assert(willFinishLaunchingSEL != null);

        var res: objc.BOOL = objc.class_addMethod(AppDelegateClass, willFinishLaunchingSEL, @ptrCast(objc.IMP, applicationWillFinishLaunching), "v@:@");
        std.debug.assert(res != 0);
    }

    // App Delegate
    var delegate: objc.id = brk: {
        var alloc: objc.id = msgSend_1(AppDelegateClass, allocSEL);
        std.debug.assert(alloc != null);

        break :brk msgSend_4(alloc, initSEL);
    };
    std.debug.assert(delegate != null);

    var setDelegateSEL: objc.SEL = objc.sel_registerName("setDelegate:");

    msgSend_5(app, setDelegateSEL, delegate);

    // Run
    var runSEL: objc.SEL = objc.sel_registerName("run");
    std.debug.assert(runSEL != null);

    msgSend_3(app, runSEL);

    std.debug.print("OK\n", .{});
}
