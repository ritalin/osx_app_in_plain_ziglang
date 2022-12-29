## Reference



## Getting start

Create project.

```
zig init-exe
```

Build project.

```
zig build
```

Run app.

```
./zig-out/bin/osx_app_in_plain_ziglang
```

## Use objc SEL

Translate objc.h header.

```
zig translate-c -I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/ translate/objc.c > translate/objc_objc.zig 
```

Check `sel_registerName` function.

```ziglang
pub extern fn sel_registerName(str: [*c]const u8) SEL;
```

Fetch sysroot.

```
xcrun --sdk macosx --show-sdk-path
```

Add build property to `build.zig`.

```ziglang
// compile property
exe.addSystemIncludeDir("/usr/include");
// link priperty
exe.addFrameworkDir("/System/Library/Frameworks");
exe.linkFramework("Foundation");
```

Build !

```
zig build --sysroot $(xcrun --sdk macosx --show-sdk-path)
```

see also: https://github.com/kubkon/zig-ios-example

## Send message

`objc_msgSend` is varargs function.
`@ptrCast` and `@call` could be used to resolve.

```ziglang
fn msgSend_1(self: objc.Class, selector: objc.SEL) objc.id {
    const FnType = fn (objc.Class, objc.SEL) callconv(.C) objc.id;

    var func = @ptrCast(FnType, objc.objc_msgSend);

    return @call(.{}, func, .{ self, selector });
}
```

see also: https://github.com/hazeycode/zig-objcrt/blob/main/src/message.zig