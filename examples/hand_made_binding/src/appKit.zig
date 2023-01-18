const appKit_appKitTypes = @import("appKit/types/appKitTypes.zig");
pub const ActionSelector = appKit_appKitTypes.ActionSelector;

const appKit_NSApplication = @import("appKit/widget/NSApplication.zig");
pub const NSApplication = appKit_NSApplication.NSApplication;
pub const NSApplicationDelegate = appKit_NSApplication.NSApplicationDelegate;
pub const NSApplicationActions = appKit_NSApplication.NSApplicationActions;

const appKit_NSRunningApplication = @import("appKit/widget/NSRunningApplication.zig");
pub const NSActivationPolicy = appKit_NSRunningApplication.NSActivationPolicy;

const appKit_NSMenu = @import("appKit/widget/NSMenu.zig");
pub const NSMenu = appKit_NSMenu.NSMenu;

const appKit_NSMenuItem = @import("appKit/widget/NSMenuItem.zig");
pub const NSMenuItem = appKit_NSMenuItem.NSMenuItem;

const appKit_NSWindow = @import("appKit/widget/NSWindow.zig");
pub const NSWindow = appKit_NSWindow.NSWindow;
pub const NSWindowStyleMask = appKit_NSWindow.NSWindowStyleMask;
pub const NSWindowStyleMaskOptions = appKit_NSWindow.NSWindowStyleMaskOptions;
pub const NSWindowDelegate = appKit_NSWindow.NSWindowDelegate;

const appKit_NSGraphics = @import("appKit/widget/NSGraphics.zig");
pub const NSBackingStoreType = appKit_NSGraphics.NSBackingStoreType;