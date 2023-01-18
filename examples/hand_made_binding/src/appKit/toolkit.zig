const std = @import("std");
const HashMap = std.AutoHashMap;

const builtin = std.builtin;

const c = @import("../objc.zig");
const appKit = @import("../appKit.zig");

pub fn WidgetResolver(comptime TWidget: type) type {
    return struct {
        const Self = @This();
        
        cache: HashMap(c.id, *TWidget),

        pub fn init(allocator: std.mem.Allocator) !*Self {
            var self = try allocator.create(Self);

            self.* = .{
                .cache = HashMap(c.id, *TWidget).init(allocator),
            };

            return self;
        }

        pub fn register(self: *Self, id: c.id, widget: *TWidget) !void {
            var result = try self.cache.getOrPut(id);
            if (! result.found_existing) {
                result.value_ptr.* = widget;
            }
        }

        pub fn unregister(self: *Self, id: c.id) void {
            _ = self.cache.remove(id);
        }

        pub fn resolve(self: *Self, id: c.id) ?*TWidget {
            return self.cache.get(id);
        }
    };
}

pub fn enableWidgetResolvers(allocator: std.mem.Allocator) !void {
    try appKit.NSApplication.enableResolvers(allocator);
    try appKit.NSWindow.enableResolvers(allocator);
}
