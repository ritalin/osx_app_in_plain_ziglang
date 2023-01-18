#include <stddef.h>
#include <assert.h>
#include <objc/runtime.h>
#include <objc/message.h>

extern id msgSend_alloc(Class _class);
extern id newInstance_support(Class _class);

static Class _class_NSMenu;
static SEL _sel_NSMenu_addItem;

Class class_NSMenu() {
    if (_class_NSMenu == NULL) {
        _class_NSMenu = objc_getClass("NSMenu");
        assert(_class_NSMenu != NULL);
    }
    return _class_NSMenu;
}

id newInstance_NSMenu_init() {
    return newInstance_support(class_NSMenu());
}
id newInstance_NSMenu_initWithTitle(const char *_title) {


    id instance = msgSend_alloc(class_NSMenu());

}

void msgSend_NSMenu_addItem(id instance, id menuItem) {
    if (_sel_NSMenu_addItem == NULL) {
        _sel_NSMenu_addItem = sel_registerName("addItem:");
        assert(_sel_NSMenu_addItem != NULL);
    }

    ((void (*) (id, SEL, id))objc_msgSend)(instance, _sel_NSMenu_addItem, menuItem);
}