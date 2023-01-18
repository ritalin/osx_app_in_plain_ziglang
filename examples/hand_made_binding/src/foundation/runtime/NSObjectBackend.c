#include <stddef.h>
#include <assert.h>
#include <objc/runtime.h>
#include <objc/message.h>

static Class _class_NSObject;

Class class_NSObject() {
    if (_class_NSObject == NULL) {
        _class_NSObject = objc_getClass("NSObject");
        assert(_class_NSObject != NULL);
    }
    return _class_NSObject;
}