#include <stddef.h>
#include <assert.h>
#include <objc/runtime.h>
#include <objc/message.h>

#include "appKitTypes.h"

extern id msgSend_alloc(Class _class);
extern Class newDelegateClass_support(const char *className, const char *protocolName);

static Class _class_NSWindow;
static SEL _sel_NSWindow_initWithContentRect;
static SEL _sel_NSWindow_setDelegate;
static SEL _sel_NSWindow_makeKeyAndOrderFront;

static const char *_NSWindowDelegateClassName = "NSWindowDelegate" "Impl";

Class class_NSWindow() {
    if (_class_NSWindow == NULL) {
        _class_NSWindow = objc_getClass("NSWindow");
        assert(_class_NSWindow != NULL);
    }

    return _class_NSWindow;
}

SEL sel_NSWindow_initWithContentRect() {
    if (_sel_NSWindow_initWithContentRect == NULL) {
        _sel_NSWindow_initWithContentRect = sel_registerName("initWithContentRect:styleMask:backing:defer:");
        assert(_sel_NSWindow_initWithContentRect != NULL);
    }
    return _sel_NSWindow_initWithContentRect;
}

id msgSend_NSWindow_initWithContentRect(id instance, NSRect _rect, unsigned long _styleMask, unsigned long _backing, BOOL _defer) {
    return ((id (*)(id, SEL, NSRect, unsigned long, unsigned long, BOOL))objc_msgSend)(instance, sel_NSWindow_initWithContentRect(), _rect, _styleMask, _backing, _defer);
}

id _newInstance_NSWindow_initWithContentRect(NSRect _rect, unsigned long _styleMask, unsigned long _backing, BOOL _defer) {
    id instance = msgSend_alloc(class_NSWindow());
    assert(instance != NULL);

    return msgSend_NSWindow_initWithContentRect(instance, _rect, _styleMask, _backing, _defer);
}

void msgSend_NSWindow_makeKeyAndOrderFront(id instance, id _sender) {
    if (_sel_NSWindow_makeKeyAndOrderFront == NULL) {
        _sel_NSWindow_makeKeyAndOrderFront = sel_registerName("makeKeyAndOrderFront:");
        assert(_sel_NSWindow_makeKeyAndOrderFront != NULL);
    }

    ((void (*)(id, SEL, id))objc_msgSend)(instance, _sel_NSWindow_makeKeyAndOrderFront, _sender);
}

Class class_NSWindowDelegate() {
    Class c = objc_getClass(_NSWindowDelegateClassName);

    if (c == NULL) {
        c = newDelegateClass_support(_NSWindowDelegateClassName, "NSWindowDelegate");
        assert(c != NULL);
    }

    return c;
 }

 void msgSend_NSWindow_setDelegate(id instance, id delegate) {
    if (_sel_NSWindow_setDelegate == NULL) {
        _sel_NSWindow_setDelegate = sel_registerName("setDelegate:");
        assert(_sel_NSWindow_setDelegate != NULL);
    }

    ((void (*)(id, SEL, id))objc_msgSend)(instance, _sel_NSWindow_setDelegate, delegate);
 }