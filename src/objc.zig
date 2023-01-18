pub usingnamespace @cImport({
    @cDefine("__objc_yes", "((BOOL)1)");
    @cDefine("__objc_no", "((BOOL)0)");
    // @cUndef("__has_feature(objc_bool)");
    // @cInclude("objc/objc.h");
    @cInclude("objc/runtime.h");
    @cInclude("objc/message.h");
    // @cInclude("objc/NSObjCRuntime.h");
});

pub const NSInteger = c_long;
pub const NSUInteger = c_ulong;