#include <stddef.h>
#include <assert.h>
#include <objc/runtime.h>
#include <objc/message.h>

extern id msgSend_alloc(Class _class);
extern id newInstance_support(Class _class);

static Class _class_NSMenuItem;
static SEL _sel_NSMenuItem_initWithTitle;
static SEL _sel_NSMenuItem_setSubmenu;

Class class_NSMenuItem() {
    if (_class_NSMenuItem == NULL) {
        _class_NSMenuItem = objc_getClass("NSMenuItem");
        assert(_class_NSMenuItem != NULL);
    }
    return _class_NSMenuItem;
}

id newInstance_NSMenuItem_init() {
    return newInstance_support(class_NSMenuItem());
}

id msgSend_NSMenuItem_initWithTitle(id instance, id _title, SEL _action, id _equiv) {
    if (_sel_NSMenuItem_initWithTitle == NULL) {
        _sel_NSMenuItem_initWithTitle = sel_registerName("initWithTitle:action:keyEquivalent:");
        assert(_sel_NSMenuItem_initWithTitle != NULL);
    }

    return ((id (*) (id, SEL, id, SEL, id))objc_msgSend)(instance, _sel_NSMenuItem_initWithTitle, _title, _action, _equiv);
}

id newInstance_NSMenuItem_initWithTitle(id _title, SEL _action, id _equiv) {
    id instance = msgSend_alloc(class_NSMenuItem());
    assert(instance != NULL);

    return msgSend_NSMenuItem_initWithTitle(instance, _title, _action, _equiv);
}

void msgSend_NSMenuItem_setSubmenu(id instance, id submenu) {
    if (_sel_NSMenuItem_setSubmenu == NULL) {
        _sel_NSMenuItem_setSubmenu = sel_registerName("setSubmenu:");
        assert(_sel_NSMenuItem_setSubmenu != NULL);
    }

    ((void (*) (id, SEL, id))objc_msgSend)(instance, _sel_NSMenuItem_setSubmenu, submenu);
}