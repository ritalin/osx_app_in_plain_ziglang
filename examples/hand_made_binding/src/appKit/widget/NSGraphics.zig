const std = @import("std");

pub const NSBackingStoreType = enum(c_ulong) {
    Buffered = 2,
};