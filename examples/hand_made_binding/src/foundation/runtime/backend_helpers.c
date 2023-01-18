#include <stddef.h>
#include <assert.h>
#include <string.h>
#include <objc/runtime.h>
#include <objc/message.h>

extern Class class_NSObject();

static SEL _sel_alloc;
static SEL _sel_init;

SEL sel_alloc() {
    if (_sel_alloc == NULL) {
        _sel_alloc = sel_registerName("alloc");
    }

    return _sel_alloc;
}

SEL sel_init() {
    if (_sel_init == NULL) {
        _sel_init = sel_registerName("init");
    }

    return _sel_init;
}

id msgSend_alloc(Class _class) {
    return ((id (*)(Class, SEL))objc_msgSend)(_class, sel_alloc());
}

id msgSend_init(id instance) {
    return ((id (*)(id, SEL))objc_msgSend)(instance, sel_init());
}

Class newDelegateClass_support(const char *classNmae, const char *protocolName) {
    Class base = class_NSObject();
    assert(base != NULL);

    Class c = objc_allocateClassPair(base, classNmae, 0);
    assert(c != NULL);

    Protocol *p = objc_getProtocol(protocolName);
    assert(strlen(protocolName) == 0 || (p != NULL));

    BOOL res = class_addProtocol(c, p);
    assert(res);

    return c;
}

void replaceMethod_support(Class _class, const char *selectorName, IMP method, const char *typeEncoding) {
    SEL selector = sel_registerName(selectorName);
    assert(selector != NULL);

    class_replaceMethod(_class, selector, method, typeEncoding);
}

id newInstance_support(Class _class) {
    id alloc = msgSend_alloc(_class);
    assert(alloc != NULL);

    return msgSend_init(alloc);
}