const std = @import("std");

const c = @import("../../objc.zig");
const toolkit = @import("../toolkit.zig");

const foundation = @import("../../foundation.zig");
const NSObject = foundation.NSObject;
const NSNotification = foundation.NSNotification;

const appKitTypes = @import("../types/appKitTypes.zig");
const ActionSelector = appKitTypes.ActionSelector;
const NSRect = appKitTypes.NSRect;

const appKit = @import("../../appKit.zig");
const NSBackingStoreType = appKit.NSBackingStoreType;

extern "C" fn _newInstance_NSWindow_initWithContentRect(_rect: NSRect, _styleMask: c_ulong, _backing: c_ulong, _defer: c.BOOL) c.id;
extern "C" fn msgSend_NSWindow_makeKeyAndOrderFront(instance: c.id, _sender: c.id) void;

extern "C" fn class_NSWindowDelegate() c.Class;
extern "C" fn msgSend_NSWindow_setDelegate(instance: c.id, _delegate: c.id) void;
extern "C" fn newInstance_support(_class: c.Class) c.id;

extern "C" fn replaceMethod_support(_class: c.Class, _selectorNmae: [*c]const u8, _method: c.IMP, _typeEncoding: [*c]const u8) void;

pub const NSWindowStyleMask = enum(c_ulong) {
    Borderless = 0,
    Titled = 1 << 0,
    Closable = 1 << 1,
    Miniaturizable = 1 << 2,
    Resizable = 1 << 3,
    UtilityWindow = 1 << 4,
    DocModalWindow = 1 << 6,
    NonactivatingPanel	= 1 << 7, 
    UnifiedTitleAndToolbar = 1 << 12,
    HUDWindow = 1 << 13,
    FullScreen = 1 << 14,
    FullSizeContentView = 1 << 15,
};
// pub const NSWindowStyleMaskOptions = extern struct {
//     Titled: bool,
//     Closable: bool,
//     Miniaturizable: bool,
//     Resizable: bool,
//     UnifiedTitleAndToolbar: bool,
//     _reserved_1: bool,
//     FullScreen: bool,
//     FullSizeContentView: bool,
//     _reserved_2: bool,
//     _reserved_3: bool,
//     _reserved_4: bool,
//     _reserved_5: bool,
//     UtilityWindow: bool,
//     DocModalWindow: bool,
//     NonactivatingPanel: bool,
//     HUDWindow: bool,

//     pub fn init(...: NSWindowStyleMask) {
//         // ...
//     }
// };

pub const NSWindowStyleMaskOptions = struct {
    const Self = @This();
    options: c_ulong,

    pub fn init(values: []const NSWindowStyleMask) Self {
        var x: c_ulong = 0;

        for (values) |v| {
            x |= @enumToInt(v);
        }

        return .{ .options = x };
    }
};

pub const NSWindow = struct {
    const Self = @This();

    var Resolver: *toolkit.WidgetResolver(NSWindow) = undefined;

    _allocator: std.mem.Allocator,
    _id: c.id,
    _delegate: ?NSWindowDelegate = null,

    pub fn enableResolvers(_allocator: std.mem.Allocator) !void {
        NSWindow.Resolver = try toolkit.WidgetResolver(NSWindow).init(_allocator);
    }

    pub fn initWithContentRect(_rect: NSRect, _styleMask: NSWindowStyleMaskOptions, _backing: NSBackingStoreType, _defer: bool, _allocator: std.mem.Allocator) !*Self {
        var self = try _allocator.create(Self);

        self.* = .{
            ._allocator = _allocator,
            ._id = _newInstance_NSWindow_initWithContentRect(_rect, _styleMask.options, @enumToInt(_backing), if (_defer) c.YES else c.NO),
        };

        try NSWindow.Resolver.register(self._id, self);

        return self;
    }

    pub fn delegate(self: *Self) ?NSWindowDelegate {
        return self._delegate;
    }
    pub fn setDelegate(self: *Self, _delegate: ?NSWindowDelegate) !void {
        msgSend_NSWindow_setDelegate(self._id, if (_delegate != null) _delegate.?._id else null);

        self._delegate = _delegate;

        if (_delegate != null) {
            try NSWindow.Resolver.register(_delegate.?._id, self);
        }
    }

    pub fn makeKeyAndOrderFront(self: *Self, _sender: ?*NSObject) void {
        msgSend_NSWindow_makeKeyAndOrderFront(self._id, if (_sender != null) _sender.?._id else null);
    }
};

const WindowWillCloseFn = (*const fn (window: *NSWindow, notification: NSNotification) anyerror!void);

pub const NSWindowDelegateMethods = struct {
    windowWillClose: ?WindowWillCloseFn = null,
};

const NSWindowDelegateRawMethods = struct {
    _methods: NSWindowDelegateMethods,

    pub fn windowWillClose(sender: c.id, _: c.SEL, notification: c.id) void {
        var self = NSWindow.Resolver.resolve(sender).?.delegate().?._rawMethods;

        if (self._methods.windowWillClose != null) {
            (self._methods.windowWillClose.?)(NSWindow.Resolver.resolve(sender).?, .{ .id = notification }) catch unreachable;
        }
    }
};

pub const NSWindowDelegate = struct {
    const Self = @This();

    _id: c.id,
    _rawMethods: NSWindowDelegateRawMethods,

    pub fn init(_methods: NSWindowDelegateMethods) Self {
        var delegateClass = class_NSWindowDelegate();

        if (_methods.windowWillClose != null) {
            replaceMethod_support(delegateClass, "windowWillClose:", @ptrCast(c.IMP, &NSWindowDelegateRawMethods.windowWillClose), "v@:@");
        }

        return .{
            ._id = newInstance_support(delegateClass),
            ._rawMethods = .{ ._methods = _methods },
        };
    }
};