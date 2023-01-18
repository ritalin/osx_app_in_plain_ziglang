#include <objc/objc.h>

struct ActionSelector {
    const char* name;
    SEL selector;
};

typedef double CGFloat;

struct CGPoint {
     CGFloat x;
     CGFloat y;
};
typedef struct CGPoint NSPoint;

struct CGSize {
     CGFloat width;
     CGFloat height;
};
typedef struct CGRect NSSize;

struct CGRect {
    struct CGPoint origin;
    struct CGSize size;
};
typedef struct CGRect NSRect;

