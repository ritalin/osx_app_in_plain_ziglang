const c = @import("../../objc.zig");

pub const CGFloat = f64;

pub const NSPoint = extern struct {
    x: CGFloat,
    y: CGFloat,
};

pub const NSSize = extern struct {
    width: CGFloat,
    height: CGFloat,
};

pub const NSRect = extern struct {
    origin: NSPoint,
    size: NSSize,
};

pub const ActionSelector = extern struct {
    name: [*c]const u8,
    selector: c.SEL,

    pub fn noaction() ActionSelector {
        return .{ .name = "", .selector = null, };
    }
};
