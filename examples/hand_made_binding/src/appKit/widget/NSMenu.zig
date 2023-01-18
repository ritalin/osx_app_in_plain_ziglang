const std = @import("std");

const c = @import("../../objc.zig");

const toolkit = @import("../toolkit.zig");
const foundation = @import("../../foundation.zig");
const appKit = @import("../../appKit.zig");

const NSString = foundation.NSString;
const NSStringEncoding = foundation.NSStringEncoding;

const NSMenuItem = appKit.NSMenuItem;

extern "C" fn newInstance_NSMenu_init() c.id;
extern "C" fn newInstance_NSMenu_initWithTitle(_title: NSString) c.id;
extern "C" fn msgSend_NSMenu_addItem(_instance: c.id, _item: c.id) void;

pub const NSMenu = struct {
    const Self = @This();

    _allocator: std.mem.Allocator,
    _id: c.id,

    pub fn init(_allocator: std.mem.Allocator) !*Self {
        var self = try _allocator.create(Self);

        self.* = .{
            ._allocator = _allocator,
            ._id = newInstance_NSMenu_init(),
        };

        return self;
    }

    pub fn initWithTitle(_title: []const u8, _allocator: std.mem.Allocator) !*Self {
        var self = try _allocator.create(Self);
        var _title_1 = try NSString.initWithBytes(_title, _title.length, NSStringEncoding.UTF8, _allocator);
        defer _title_1.deinit();

        self.* = .{
            ._allocator = _allocator,
            ._id = newInstance_NSMenu_initWithTitle(_title_1),
        };

        return self;
    }

    pub fn deinit(self: *Self) void {
        self._allocator.destroy(self);
    }

    pub fn addItem(self: *Self, _item: *NSMenuItem) void {
        msgSend_NSMenu_addItem(self._id, _item._id);
    }

    // pub fn setSubmenu(self: *Self, menuItem: *NSMenuItem) void {
        
    // }
};