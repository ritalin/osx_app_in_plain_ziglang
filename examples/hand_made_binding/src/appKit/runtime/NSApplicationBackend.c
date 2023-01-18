#include <stddef.h>
#include <assert.h>
#include <objc/runtime.h>
#include <objc/message.h>

#include "appKitTypes.h"

extern Class newDelegateClass_support(const char *className, const char *protocolName);

static Class _class_NSApplication;
static SEL _sel_NSApplication_sharedApplication;
static SEL _sel_NSApplication_setDelegate;
static SEL _sel_NSApplication_run;
static SEL _sel_NSApplication_setMainMenu;
static SEL _sel_NSApplication_activateIgnoringOtherApps;
static SEL _sel_NSApplication_activationPolicy;
static SEL _sel_NSApplication_setActivationPolicy;
static SEL _sel_NSApplication_terminate;

static const char *_NSApplicationDelegateClassName = "NSApplicationDelegate" "Impl";

Class class_NSApplication() {
    if (_class_NSApplication == NULL) {
        _class_NSApplication = objc_getClass("NSApplication");
        assert(_class_NSApplication != NULL);
    }
    return _class_NSApplication;
}

id msgSend_NSApplication_sharedApplication() {
    if (_sel_NSApplication_sharedApplication == NULL) {
        _sel_NSApplication_sharedApplication = sel_registerName("sharedApplication");
        assert(_sel_NSApplication_sharedApplication != NULL);
    }

    id app = ((id (*)(Class, SEL))objc_msgSend)(class_NSApplication(), _sel_NSApplication_sharedApplication);
    assert(app != NULL);
    return app;
}

Class class_NSApplicationDelegate() {
    Class c = objc_getClass(_NSApplicationDelegateClassName);

    if (c == NULL) {
        c = newDelegateClass_support(_NSApplicationDelegateClassName, ""/*"NSApplicationDelegate"*/);
        assert(c != NULL);
    }

    return c;
}

void msgSend_NSApplication_setDelegate(id instance, id delegate) {
    if (_sel_NSApplication_setDelegate == NULL) {
        _sel_NSApplication_setDelegate = sel_registerName("setDelegate:");
        assert(_sel_NSApplication_setDelegate != NULL);
    }

    ((void (*)(id, SEL, id))objc_msgSend)(instance, _sel_NSApplication_setDelegate, delegate);
}

void msgSend_NSApplication_run(id instance) {
    if (_sel_NSApplication_run == NULL) {
        _sel_NSApplication_run = sel_registerName("run");
        assert(_sel_NSApplication_run != NULL);
    }

    ((void (*)(id, SEL))objc_msgSend)(instance, _sel_NSApplication_run);
}

void msgSend_NSApplication_setMainMenu(id instance, id menuBar) {
    if (_sel_NSApplication_setMainMenu == NULL) {
        _sel_NSApplication_setMainMenu = sel_registerName("setMainMenu:");
        assert(_sel_NSApplication_setMainMenu != NULL);
    }

    ((void (*) (id, SEL, id))objc_msgSend)(instance, _sel_NSApplication_setMainMenu, menuBar);
}

void msgSend_NSApplication_activateIgnoringOtherApps(id instance, BOOL flag) {
    if (_sel_NSApplication_activateIgnoringOtherApps == NULL) {
        _sel_NSApplication_activateIgnoringOtherApps = sel_registerName("activateIgnoringOtherApps:");
        assert(_sel_NSApplication_activateIgnoringOtherApps != NULL);
    }

    ((void (*) (id, SEL, BOOL))objc_msgSend)(instance, _sel_NSApplication_activateIgnoringOtherApps, flag);
}

long msgSend_NSApplication_activationPolicy(id instance) {
    if (_sel_NSApplication_activationPolicy == NULL) {
        _sel_NSApplication_activationPolicy = sel_registerName("activationPolicy");
        assert(_sel_NSApplication_activationPolicy != NULL);
    }

    return ((long (*) (id, SEL))objc_msgSend)(instance, _sel_NSApplication_activationPolicy); 
}

void msgSend_NSApplication_setActivationPolicy(id instance, long policy) {
    if (_sel_NSApplication_setActivationPolicy == NULL) {
        _sel_NSApplication_setActivationPolicy = sel_registerName("setActivationPolicy:");
        assert(_sel_NSApplication_setActivationPolicy != NULL);
    }

    return ((void (*) (id, SEL, long))objc_msgSend)(instance, _sel_NSApplication_setActivationPolicy, policy);    
}

SEL sel_NSApplication_terminate() {
    if (_sel_NSApplication_terminate == NULL) {
        _sel_NSApplication_terminate = sel_registerName("terminate:");
        assert(_sel_NSApplication_terminate != NULL);
    }

    return _sel_NSApplication_terminate;
}

struct ActionSelector action_NSApplication_terminate() {
    struct ActionSelector _x = { .name = "terminate:", .selector = sel_NSApplication_terminate() };

    return _x;
}

void msgSend_NSApplication_terminate(id instance, id sender) {
    ((void (*)(id, SEL, id))objc_msgSend)(instance, sel_NSApplication_terminate(), sender);
}