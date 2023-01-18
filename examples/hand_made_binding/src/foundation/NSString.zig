const std = @import("std");

const c = @import("../objc.zig");

extern "C" fn newInstance_NSString_initWithBytes(bytes: *const u8, length: c_ulong, encoding: c_ulong) c.id;

pub const NSStringEncoding = enum(c_ulong) {
    UTF8 = 4,
};

pub const NSString = struct {
    const Self = @This();

    _allocator: std.mem.Allocator,
    _id: c.id,

    pub fn initWithBytes(_bytes: []const u8, _length: c_ulong, _encoding: NSStringEncoding, _allocator: std.mem.Allocator) !*Self {
        var self = try _allocator.create(Self);

        self.* = .{
            ._allocator = _allocator,
            ._id = newInstance_NSString_initWithBytes(@ptrCast(*const u8, _bytes), _length, @enumToInt(_encoding)),
        };

        return self;
    }

    pub fn deinit(self: *Self) void {
        self._allocator.destroy(self);
    }
};