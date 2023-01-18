const std = @import("std");

pub const NSActivationPolicy = enum(c_long) {
    Regular, 
    Accessory,  
    Prohibited,
};