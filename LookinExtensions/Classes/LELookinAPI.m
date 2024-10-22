//
//  LELookinAPI.m
//  LookinExtensions
//
//  Created by Magic-Unique on 2024/10/17.
//

#import "LELookinAPI.h"
#import <objc/runtime.h>

void LELookinHookMessageEx(Class _class, SEL sel, IMP imp, IMP *result) {
    Method ori_method = class_getInstanceMethod(_class, sel);
    const char *typeEncoding = method_getTypeEncoding(ori_method);
    if(!class_addMethod(_class, sel, imp, typeEncoding)) {
        // Replace implementation and return old implementation
        *result = method_getImplementation(ori_method);
        method_setImplementation(ori_method, imp);
    } else {
        // Add implementation and return super implementation
        Class superClass = class_getSuperclass(_class);
        ori_method = class_getInstanceMethod(superClass, sel);
        *result = method_getImplementation(ori_method);
    }
}
