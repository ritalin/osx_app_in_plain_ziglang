const std = @import("std");
const c = @import("objc.zig");

const NSNotification = @import("foundation.zig").NSNotification;

const toolkit = @import("appKit/toolKit.zig");

const appKitTypes = @import("appKit/types/appKitTypes.zig");
const NSRect = appKitTypes.NSRect;

const appKit = @import("appKit.zig");
const NSApplication = appKit.NSApplication;
const NSApplicationDelegate = appKit.NSApplicationDelegate;
const NSActivationPolicy = appKit.NSActivationPolicy;
const NSApplicationActions = appKit.NSApplicationActions;

const NSMenu = appKit.NSMenu;
const NSMenuItem = appKit.NSMenuItem;

const NSWindow = appKit.NSWindow;
const NSWindowStyleMask = appKit.NSWindowStyleMask;
const NSWindowStyleMaskOptions = appKit.NSWindowStyleMaskOptions;
const NSBackingStoreType = appKit.NSBackingStoreType;
const NSWindowDelegate = appKit.NSWindowDelegate;

// fn msgSend_1(self: c.Class, selector: c.SEL) c.id {
//     const FnType = *const fn (@TypeOf(self), c.SEL) callconv(.C) c.id;

//     var func = @ptrCast(FnType, &c.objc_msgSend);

//     return @call(.{}, func, .{ self, selector });
// }
// fn msgSend_2(self: c.id, selector: c.SEL, arg1: c_long) bool {
//     const FnType = *const fn (@TypeOf(self), c.SEL, @TypeOf(arg1)) callconv(.C) bool;

//     var func = @ptrCast(FnType, &c.objc_msgSend);

//     return @call(.{}, func, .{ self, selector, arg1 });
// }
// fn msgSend_3(self: c.id, selector: c.SEL) void {
//     const FnType = *const fn (@TypeOf(self), c.SEL) callconv(.C) void;

//     var func = @ptrCast(FnType, &c.objc_msgSend);

//     return @call(.{}, func, .{ self, selector });
// }
// fn msgSend_4(self: c.id, selector: c.SEL) c.id {
//     const FnType = *const fn (@TypeOf(self), c.SEL) callconv(.C) c.id;

//     var func = @ptrCast(FnType, &c.objc_msgSend);

//     return @call(.{}, func, .{ self, selector });
// }
// fn msgSend_5(self: c.id, selector: c.SEL, arg1: c.id) void {
//     const FnType = *const fn (@TypeOf(self), c.SEL, @TypeOf(arg1)) callconv(.C) void;

//     var func = @ptrCast(FnType, &c.objc_msgSend);

//     return @call(.{}, func, .{ self, selector, arg1 });
// }
// fn msgSend_6(self: c.Class, selector: c.SEL, arg1: [*c]const u8) c.id {
//     const FnType = *const fn (@TypeOf(self), c.SEL, @TypeOf(arg1)) callconv(.C) c.id;

//     var func = @ptrCast(FnType, &c.objc_msgSend);

//     return @call(.{}, func, .{ self, selector, arg1 });
// }
// fn msgSend_7(self: c.id, selector: c.SEL, arg1: c.id, arg2: c.SEL, arg3: c.id) c.id {
//     const FnType = *const fn (@TypeOf(self), c.SEL, @TypeOf(arg1), @TypeOf(arg2), @TypeOf(arg3)) callconv(.C) c.id;

//     var func = @ptrCast(FnType, &c.objc_msgSend);

//     return @call(.{}, func, .{ self, selector, arg1, arg2, arg3 });
// }
// fn msgSend_8(self: c.id, selector: c.SEL, arg1: c.id) c.id {
//     const FnType = *const fn (@TypeOf(self), c.SEL, @TypeOf(arg1)) callconv(.C) c.id;

//     var func = @ptrCast(FnType, &c.objc_msgSend);

//     return @call(.{}, func, .{ self, selector, arg1 });
// }
// fn msgSend_10(self: c.id, selector: c.SEL, arg1: c.BOOL) void {
//     const FnType = *const fn (@TypeOf(self), c.SEL, @TypeOf(arg1)) callconv(.C) void;

//     var func = @ptrCast(FnType, &c.objc_msgSend);

//     return @call(.{}, func, .{ self, selector, arg1 });
// }


// fn makeQuitMenuItemName() c.id {
//     var NSProcessInfoClass: c.Class = c.objc_getClass("NSProcessInfo");
//     std.debug.assert(NSProcessInfoClass != null);

//     var processInfoSEL: c.SEL = c.sel_registerName("processInfo");
//     std.debug.assert(processInfoSEL != null);

//     var info: c.id = msgSend_1(NSProcessInfoClass, processInfoSEL);
//     std.debug.assert(info != null);

//     var processNameSEL: c.SEL = c.sel_registerName("processName");
//     std.debug.assert(processNameSEL != null);

//     var name: c.id = msgSend_4(info, processNameSEL);
//     std.debug.assert(name != null);

//     var NSStringClass: c.Class = c.objc_getClass("NSString");
//     var stringWithUTF8StringSEL: c.SEL = c.sel_registerName("stringWithUTF8String:");
//     var stringByAppendingStringSEL: c.SEL = c.sel_registerName("stringByAppendingString:");

//     var prefix: c.id = msgSend_6(NSStringClass, stringWithUTF8StringSEL, "Quit ");

//     return msgSend_8(prefix, stringByAppendingStringSEL, name);
// }

fn windowWillClose(window: *NSWindow, _: NSNotification) anyerror!void {
    std.debug.print("[window#2] {*}\n", .{window._id});

    NSApplication.sharedApplication().?.terminate(null);
}

fn applicationWillFinishLaunching (app: *NSApplication, _: NSNotification) anyerror!void {
    std.debug.print("In applicationWillFinishLaunching\n", .{});

    std.debug.print("[app#1] {*}\n", .{app._id});
    std.debug.print("[app#1] {*}\n", .{NSApplication.sharedApplication().?._id});

    var menuBar = try NSMenu.init(app.allocator());
    std.debug.assert(menuBar._id != null);
    app.setMainMenu(menuBar);

    // App Menu
    var appMenuItem = try NSMenuItem.init(app.allocator());
    std.debug.assert(appMenuItem._id != null);
    menuBar.addItem(appMenuItem);

    var appMenu = try NSMenu.init(app.allocator());
    std.debug.assert(appMenu._id != null);
    appMenuItem.setSubmenu(appMenu);

    var quitMenuItem = try NSMenuItem.initWithTitle("XYZ", NSApplicationActions.terminate(), "q", app.allocator());
    std.debug.assert(quitMenuItem._id != null);
    appMenu.addItem(quitMenuItem);

    // Window 
    var rect = NSRect {
        .origin = .{ .x = 50, .y = 50 },
        .size = .{ .width = 500, .height = 500 },
    };
    var mask = NSWindowStyleMaskOptions.init(&[_]NSWindowStyleMask{
        NSWindowStyleMask.Titled,
        NSWindowStyleMask.Closable,
        NSWindowStyleMask.Miniaturizable,
        NSWindowStyleMask.Resizable
    });
    var backing = NSBackingStoreType.Buffered;

    var w = try NSWindow.initWithContentRect(rect, mask, backing, false, app.allocator());
    std.debug.assert(w._id != null);
    std.debug.print("[window#1] {*}\n", .{w._id});

    // //// Window delegate

    // var NSObjectClass: objc.Class = objc.objc_getClass("NSObject");
    // std.debug.assert(NSObjectClass != null);

    // var WindowDelegateClass: objc.Class = objc.objc_allocateClassPair(NSObjectClass, "WindowDelegate", 0);
    // std.debug.assert(WindowDelegateClass != null);

    // var NSWindowDelegateProtocol: [*c]objc.Protocol = objc.objc_getProtocol("NSWindowDelegate");

    // {
    //     var res: objc.BOOL = objc.class_addProtocol(WindowDelegateClass, NSWindowDelegateProtocol);
    //     std.debug.assert(res != 0);
    // }

    // var delegate: objc.id = brk: {
    //     var alloc: objc.id = msgSend_1(WindowDelegateClass, allocSEL);
    //     std.debug.assert(alloc != null);

    //     break :brk msgSend_4(alloc, initSEL);
    // };
    // std.debug.assert(delegate != null);

    // {
    //     var windowWillCloseSEL: objc.SEL = objc.sel_registerName("windowWillClose:");
    //     std.debug.assert(windowWillCloseSEL != null);

    //     var res: objc.BOOL = objc.class_addMethod(WindowDelegateClass, windowWillCloseSEL, @ptrCast(objc.IMP, &windowWillClose), "v@:@");
    //     std.debug.assert(res != 0);
    // }

    // var setDelegateSEL: objc.SEL = objc.sel_registerName("setDelegate:");
    // msgSend_5(w, setDelegateSEL, delegate);

    var d = NSWindowDelegate.init(
        .{
            .windowWillClose = windowWillClose,
        }
    );

    std.debug.print("[window_delegate#1] {*}\n", .{d._id});

    try w.setDelegate(d);

    std.debug.print("[window_delegate#2] {*}\n", .{w.delegate().?._id});

    w.makeKeyAndOrderFront(null);

    app.activateIgnoringOtherApps(true);
}
    
pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.c_allocator);
    defer arena.deinit();

    try toolkit.enableWidgetResolvers(arena.allocator());

    var app: *NSApplication = (try NSApplication.registerSharedApplication(arena.allocator())).?;

    std.debug.print("policy = {}\n", .{ app.activationPolicy() });

    // Regular Application
    app.setActivationPolicy(NSActivationPolicy.Regular);

    var d = NSApplicationDelegate.init(
        .{
            .applicationWillFinishLaunching = applicationWillFinishLaunching,
        }  
    );

    try app.setDelegate(d);

    std.debug.print("delegate class name: {s}\n", .{ app.delegate().?.className() });
    app.run();

    std.log.info("All your codebase are belong to us.", .{});
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
