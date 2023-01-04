#include <objc/objc.h>
#include <objc/message.h>

#include "geo.h";

extern id const NSDefaultRunLoopMode;

typedef unsigned long NSUInteger;

id new_window(NSRect rect) {
	SEL allocSel = sel_registerName("alloc");

	Class NSWindowClass = objc_getClass("NSWindow");
	id windowAlloc = ((id (*)(Class, SEL))objc_msgSend)(NSWindowClass, allocSel);
	SEL initWithContentRectSel = sel_registerName("initWithContentRect:styleMask:backing:defer:");
	return ((id (*)(id, SEL, NSRect, NSUInteger, NSUInteger, BOOL))objc_msgSend)(windowAlloc, initWithContentRectSel, rect, 15, 2, NO);
}

id new_window_msgSend(id alloc, SEL selector, NSRect rect, NSUInteger styleMask, NSUInteger backing, BOOL defer) {
	return ((id (*)(id, SEL, NSRect, NSUInteger, NSUInteger, BOOL))objc_msgSend)(alloc, selector, rect, styleMask, backing, defer);
}

id get_run_loop_mode() {
    return NSDefaultRunLoopMode;
}
