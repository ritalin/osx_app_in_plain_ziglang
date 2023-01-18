const std = @import("std");
const c = @import("../objc.zig");

pub const NSObject = struct {
    const Self = @This();
    _id: c.id,
};

pub const NSObjectFactory = struct {
    pub fn fromId(_id: c.id) NSObject {
        return .{ ._id = _id };
    }
};