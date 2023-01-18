const std = @import("std");
const c = @import("../objc.zig");

pub const NSNotification = struct {
    id: c.id,
};