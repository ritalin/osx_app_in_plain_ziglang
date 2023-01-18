const std = @import("std");

const c = @import("../../objc.zig");

const ActionSelector = @import("../types/appKitTypes.zig").ActionSelector;

const toolkit = @import("../toolkit.zig");
const foundation = @import("../../foundation.zig");
const NSString = foundation.NSString;
const NSStringEncoding = foundation.NSStringEncoding;

const appKit = @import("../../appKit.zig");
const NSMenu = appKit.NSMenu;

extern "C" fn newInstance_NSMenuItem_init() c.id;
extern "C" fn newInstance_NSMenuItem_initWithTitle(_title: c.id, _selector: c.SEL, _equiv: c.id) c.id;
extern "C" fn msgSend_NSMenuItem_setSubmenu(instance: c.id, submenu: c.id) void;

pub const NSMenuItem = struct {
    const Self = @This();

    _allocator: std.mem.Allocator,
    _id: c.id,

    pub fn init(_allocator: std.mem.Allocator) !*Self {
        var self = try _allocator.create(Self);

        self.* = .{
            ._allocator = _allocator,
            ._id = newInstance_NSMenuItem_init(),
        };

        return self;
    }

    pub fn initWithTitle(_title: []const u8, action: ActionSelector, _equiv: []const u8, _allocator: std.mem.Allocator) !*Self {
        var _title_1 = try NSString.initWithBytes(_title, _title.len, NSStringEncoding.UTF8, _allocator);
        defer _title_1.deinit();
        var _equiv_1 = try NSString.initWithBytes(_equiv, _equiv.len, NSStringEncoding.UTF8, _allocator);
        defer _equiv_1.deinit();

        var self = try _allocator.create(Self);

        self.* = .{
            ._allocator = _allocator,
            ._id = newInstance_NSMenuItem_initWithTitle(_title_1._id, action.selector, _equiv_1._id),
        };  

        return self;      
    }

    pub fn setSubmenu(self: *Self, submenu: *NSMenu) void {
        msgSend_NSMenuItem_setSubmenu(self._id, submenu._id);
    }
};
