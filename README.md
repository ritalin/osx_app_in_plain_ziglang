# osx_app_in_plain_ziglang

For studying, transcript code from https://github.com/jimon/osx_app_in_plain_c

# Build & run

```
zig build

./zig-out/bin/osx_app_in_plain_ziglang
```

# Bundle build

Above the describing can not use main menu.
Main menu can use app bundle (*.app)

Generating appbundle is:

```
zig build bundle
```
