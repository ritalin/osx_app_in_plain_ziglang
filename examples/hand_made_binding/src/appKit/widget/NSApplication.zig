const std = @import("std");

const c = @import("../../objc.zig");


const toolkit = @import("../toolkit.zig");

const foundation = @import("../../foundation.zig");

const NSObject = foundation.NSObject;
const NSNotification = foundation.NSNotification;

const appKit = @import("../../appKit.zig");
const ActionSelector = appKit.ActionSelector;
const NSActivationPolicy = appKit.NSActivationPolicy;
const NSMenu = appKit.NSMenu;

extern "C" fn class_NSApplicationDelegate() c.Class;
extern "C" fn replaceMethod_support(_class: c.Class, _selectorNmae: [*c]const u8, _method: c.IMP, _typeEncoding: [*c]const u8) void;
extern "C" fn newInstance_support(_class: c.Class) c.id;

const DelegateMetaInfo = struct {
    selectorName: []const u8,
    typeEncoding: []const u8,
};

// @offsetOf で構造体フィールドのオフセットByte拾える
// @ptrCast でフィールドの型として取り出す
// fn buildProtocol(comptime TProtocol: type, p: TProtocol) c.id {

// }
fn buildProtocol(_: NSApplicationDelegateRawMethods) c.id {
    var arena = std.heap.ArenaAllocator.init(std.heap.c_allocator);
    defer arena.deinit();

    _ = arena.allocator();

    var delegateClass = class_NSApplicationDelegate();

    replaceMethod_support(delegateClass, "applicationWillFinishLaunching:", @ptrCast(c.IMP, &NSApplicationDelegateRawMethods.applicationWillFinishLaunching), "v@:@");
    
    return newInstance_support(delegateClass);
}

// メソッドリストはclass_copyMethodList で取得できる
// fn loadProtocol(comptime TProtocol: type, _id: c.id) TProtocol {

// }

test "Delegateの構造を拾い出す" {
    const delType = @typeInfo(NSApplicationDelegate);

    std.debug.print("field count => {}\n", .{delType.Struct.fields.len});

    const fields = delType.Struct.fields;

    var meta = DelegateMetaInfo {
        .selectorName = fields[0].name,
        .typeEncoding = "",           
    };

    std.debug.print("\n", .{});
    std.debug.print("meta => {}\n", .{ meta });
}

test "構造体フィールドのオフセットアクセス" {
    const S = struct {
        a: []const u8,
        b: []const u8,
        c: []const u8
    };

    var ss = S { .a = "qwerty", .b = "ijkl",  .c = "1414235623" };

    std.debug.print("dump => {}\n", .{ ss });
    std.debug.print("size => {}\n", .{ @sizeOf(S) });

    std.debug.print("offset:a => {}, addr => {*}, value => {1s}\n", .{ @offsetOf(S, "a"), @field(ss, "a") });
    std.debug.print("offset:b => {}, addr => {*}, value => {1s}\n", .{ @offsetOf(S, "b"), @field(ss, "b") });
    std.debug.print("offset:c => {}, addr => {*}, value => {1s}\n", .{ @offsetOf(S, "c"), @field(ss, "c") });

    try std.testing.expect(true);
}

extern "C" fn print_id(x: c.id) void;

extern "C" fn class_NSApplication() c.Class;
extern "C" fn msgSend_NSApplication_sharedApplication() c.id;
extern "C" fn msgSend_NSApplication_delegate() c.id;
extern "C" fn msgSend_NSApplication_setDelegate(self: c.id, delegate: c.id) void;
extern "C" fn msgSend_NSApplication_run(id: c.id) void;
extern "C" fn msgSend_NSApplication_setMainMenu(id: c.id, menuBar: c.id) void;
extern "C" fn msgSend_NSApplication_activateIgnoringOtherApps(id: c.id, flag: c.BOOL) void;
extern "C" fn msgSend_NSApplication_activationPolicy(id: c.id) c_long;
extern "C" fn msgSend_NSApplication_setActivationPolicy(id: c.id, policy: c_long) void;
extern "C" fn msgSend_NSApplication_terminate(id: c.id, sender: c.id) void;

extern "C" fn action_NSApplication_terminate() ActionSelector;

pub const NSApplication = struct {
    const Self = NSApplication;

    var Resolver: *toolkit.WidgetResolver(NSApplication) = undefined;

    _allocator: std.mem.Allocator,
    _id: c.id,
    _delegate: ?NSApplicationDelegate,

    pub fn class() c.Class {
        return class_NSApplication();
    }

    pub fn enableResolvers(_allocator: std.mem.Allocator) !void {
        NSApplication.Resolver = try toolkit.WidgetResolver(NSApplication).init(_allocator);
    }
    pub fn allocator(self: *Self) std.mem.Allocator {
        return self._allocator;
    }

    pub fn sharedApplication() ?*Self {
        var instance: c.id = msgSend_NSApplication_sharedApplication();
        if (instance == null) { return null; }

        return NSApplication.Resolver.resolve(instance);
    }

    pub fn registerSharedApplication(_allocator: std.mem.Allocator) !?*Self {
        var instance: c.id = msgSend_NSApplication_sharedApplication();
        std.debug.print("id#2\n", .{});
        if (instance == null) { return null; }

        var self = try _allocator.create(Self);

        self.* = .{ 
            ._id = instance,
            ._allocator = _allocator,
            ._delegate = null,
         };
         try NSApplication.Resolver.register(self._id, self);

         return self;
    }

    pub fn deinit(self: *Self) void {
        self._allocator.destroy(self);
    }

    pub fn activationPolicy(self: *NSApplication) NSActivationPolicy {
        return @intToEnum(NSActivationPolicy, msgSend_NSApplication_activationPolicy(self._id));
    }
    pub fn setActivationPolicy(self: *NSApplication, policy: NSActivationPolicy) void {
        msgSend_NSApplication_setActivationPolicy(self._id, @enumToInt(policy));
    }

    pub fn delegate(self: *NSApplication) ?NSApplicationDelegate {
        return self._delegate;
    }
    pub fn setDelegate(self: *NSApplication, _delegate: NSApplicationDelegate) !void {
        msgSend_NSApplication_setDelegate(self._id, _delegate._id);

        self._delegate = _delegate;

        try NSApplication.Resolver.register(_delegate._id, self);
    }

    pub fn run(self: *NSApplication) void {
        msgSend_NSApplication_run(self._id);
    }

    pub fn terminate(self: *NSApplication, _sender: ?*NSObject) void {
        msgSend_NSApplication_terminate(self._id, if(_sender != null) _sender.?._id else null);
    }

    pub fn mainMenu(self: *NSApplication) ?*NSMenu {
        std.debug.print("{}\n", .{ self });

        return @ptrCast(NSMenu, null);
    }
    pub fn setMainMenu(self: *NSApplication, _mainMenu: *NSMenu) void {
        msgSend_NSApplication_setMainMenu(self._id, _mainMenu._id);
    }

    pub fn activateIgnoringOtherApps(self: *Self, flag: bool) void {
        msgSend_NSApplication_activateIgnoringOtherApps(self._id, if(flag) 1 else 0);
    }
};

const ApplicationWillFinishLaunchingFn = (*const fn (app: *NSApplication, notification: NSNotification) anyerror!void);

pub const NSApplicationDelegateMethods = struct {
    applicationWillFinishLaunching: ?ApplicationWillFinishLaunchingFn = null,
};

const NSApplicationDelegateRawMethods = struct {
    _methods: NSApplicationDelegateMethods,

    pub fn applicationWillFinishLaunching(sender: c.id, _: c.SEL, notification: c.id) void {
        var self = NSApplication.Resolver.resolve(sender).?.delegate().?._rawMethods;

        if (self._methods.applicationWillFinishLaunching != null) {
            (self._methods.applicationWillFinishLaunching.?)(NSApplication.Resolver.resolve(sender).?, .{ .id = notification }) catch unreachable;
        }
    }
};

pub const NSApplicationDelegate = struct {
    const Self = NSApplicationDelegate;

    _id: c.id,
    _rawMethods: NSApplicationDelegateRawMethods,

    pub fn init(_methods: NSApplicationDelegateMethods) NSApplicationDelegate {
        var delegateClass = class_NSApplicationDelegate();

        if (_methods.applicationWillFinishLaunching != null) {
            replaceMethod_support(delegateClass, "applicationWillFinishLaunching:", @ptrCast(c.IMP, &NSApplicationDelegateRawMethods.applicationWillFinishLaunching), "v@:@");
        }

        return .{
            ._id = newInstance_support(delegateClass),
            ._rawMethods = .{ ._methods = _methods },
        };
    }

    pub fn className(self: Self) []const u8 {
        return std.mem.sliceTo(c.object_getClassName(self._id), 0);
    }
};

pub const NSApplicationActions = struct {
    pub fn terminate() ActionSelector {
        return action_NSApplication_terminate();
    }
};