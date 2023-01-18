#include <stddef.h>
#include <assert.h>
#include <objc/runtime.h>
#include <objc/message.h>

extern id msgSend_alloc(Class _class);

static Class _class_NSString;
static SEL _sel_NSString_initWithBytes;

Class class_NSString() {
    if (_class_NSString == NULL) {
        _class_NSString = objc_getClass("NSString");
        assert(_class_NSString != NULL);
    }
    return _class_NSString;
}

id msgSend_NSString_initWithBytes(id instance, const void *_bytes, unsigned long _length, unsigned long _encoding) {
    if (_sel_NSString_initWithBytes == NULL) {
        _sel_NSString_initWithBytes = sel_registerName("initWithBytes:length:encoding:");
        assert(_sel_NSString_initWithBytes != NULL);
    }

    return ((id (*)(id, SEL, const void *, long, int))objc_msgSend)(instance, _sel_NSString_initWithBytes, _bytes, _length, _encoding);
}

id newInstance_NSString_initWithBytes(const char *_bytes, unsigned long _length, unsigned long _encoding) {
    id alloc = msgSend_alloc(class_NSString());
    assert(alloc != NULL);

    return msgSend_NSString_initWithBytes(alloc, _bytes, _length, _encoding);

}
