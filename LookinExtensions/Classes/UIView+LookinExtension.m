//
//  UIView+LookinExtension.m
//  LookinExtensions
//
//  Created by Magic-Unique on 2024/10/17.
//

#import "UIView+LookinExtension.h"
#import <objc/runtime.h>

static void *LOOKIN_INFO = &LOOKIN_INFO;
static NSMutableSet *LEGetGestureRecognizerLookinInfo(UIGestureRecognizer *target) {
    NSMutableSet *targetActions = objc_getAssociatedObject(target, LOOKIN_INFO);
    if (!targetActions) {
        targetActions = [NSMutableSet set];
        objc_setAssociatedObject(target, LOOKIN_INFO, targetActions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targetActions;
}

static NSString *LETargetActionLookinInfo(id target, SEL action) {
    return [NSString stringWithFormat:@"-[%@ %@]", [target class], NSStringFromSelector(action)];
}

static UIGestureRecognizer *(*LE_ORI_UIGestureRecognizer_init)(UIGestureRecognizer *self, SEL _cmd, id target, SEL action);
static UIGestureRecognizer *LE_NEW_UIGestureRecognizer_init(UIGestureRecognizer *self, SEL _cmd, id target, SEL action) {
    UIGestureRecognizer *result = LE_ORI_UIGestureRecognizer_init(self, _cmd, target, action);
    if (target && action) {
        NSMutableSet *info = LEGetGestureRecognizerLookinInfo(self);
        NSString *item = LETargetActionLookinInfo(target, action);
        [info addObject:item];
    }
    return result;
}

static void (*LE_ORI_UIGestureRecognizer_add)(UIGestureRecognizer *self, SEL _cmd, id target, SEL action);
static void LE_NEW_UIGestureRecognizer_add(UIGestureRecognizer *self, SEL _cmd, id target, SEL action) {
    LE_ORI_UIGestureRecognizer_add(self, _cmd, target, action);
    if (target && action) {
        NSMutableSet *info = LEGetGestureRecognizerLookinInfo(self);
        NSString *item = LETargetActionLookinInfo(target, action);
        [info addObject:item];
    }
}

static NSString *LEGestureRecognizerName(UIGestureRecognizer *sender) {
    Class cls = [sender class];
    while (cls && ![NSStringFromClass(cls) hasPrefix:@"UI"]) {
        cls = class_getSuperclass(cls);
    }
    if (cls) {
        NSString *name = NSStringFromClass(cls);
        name = [name stringByReplacingOccurrencesOfString:@"UI" withString:@""];
        name = [name stringByReplacingOccurrencesOfString:@"GestureRecognizer" withString:@""];
        return [NSString stringWithFormat:@"%@:", name];
    } else {
        NSString *name = NSStringFromClass([sender class]);
        return name;
    }
}

static NSMutableArray *LEGestureRecognizerInfosForView(UIView *view) {
    NSMutableArray *list = [NSMutableArray array];
    for (UIGestureRecognizer *gr in view.gestureRecognizers) {
        NSString *className = NSStringFromClass(gr.class);
        
        // 过滤掉 Apple 私有手势类
        if ([className hasPrefix:@"_UI"]) {
            continue;
        }
        if ([className hasPrefix:@"UIScrollView"]) {
            continue;
        }
        
        NSMutableArray *funcs = LEGetGestureRecognizerLookinInfo(gr).allObjects.mutableCopy;
        
        // 过滤掉 Apple 私有方法
        for (NSUInteger i = 0; i < funcs.count; i++) {
            NSString *func = funcs[i];
            if ([func hasPrefix:@"-[UI"]) {
                [funcs removeObjectAtIndex:i--];
                continue;
            }
            if ([func hasPrefix:@"-[_UI"]) {
                [funcs removeObjectAtIndex:i--];
                continue;
            }
            if ([func hasSuffix:@" _handleKnobHoverGesture:]"]) {
                [funcs removeObjectAtIndex:i--];
                continue;
            }
        }
        
        if (funcs.count) {
            __weak __auto_type weak_gr = gr;
            NSMutableArray *properties = [NSMutableArray array];
            [properties addObject:LEStringProperty(@"Classes", className, nil)];
            if (@available(iOS 11.0, *)) {
                [properties addObject:LEStringProperty(@"Name", gr.name?:@"", ^(NSString *newValue) {
                    __strong __auto_type gr = weak_gr;
                    if (!gr) { return; }
                    gr.name = newValue;
                })];
            }
            [properties addObject:LEBoolProperty(@"Enable", gr.enabled, ^(BOOL newValue) {
                __strong __auto_type gr = weak_gr;
                if (!gr) { return; }
                gr.enabled = newValue;
            })];
            if (gr.view) {
                [properties addObject:LEStringProperty(@"Attached View", [NSString stringWithFormat:@"<%@ %p>", gr.view.class, gr.view], nil)];
            }
            if (gr.delegate) {
                [properties addObject:LEStringProperty(@"Delegate", [NSString stringWithFormat:@"<%@ %p>", gr.delegate.class, gr.delegate], nil)];
            } else {
                [properties addObject:LEStringProperty(@"Delegate", @"nil", nil)];
            }
            
            for (NSString *func in funcs) {
                [properties addObject:LEStringProperty(@"Action", func, nil)];
            }
            
            NSDictionary *info = LEVirtualSubview(LEGestureRecognizerName(gr), [NSString stringWithFormat:@"%p", gr], view, properties);
            [list addObject:info];
        }
    }
    return list;
}

@implementation UIView (LookinExtension)

+ (void)load {
    LELookinHookMessageEx(UIGestureRecognizer.class,
                          @selector(initWithTarget:action:),
                          (IMP)&LE_NEW_UIGestureRecognizer_init, (IMP*)&LE_ORI_UIGestureRecognizer_init);
    LELookinHookMessageEx(UIGestureRecognizer.class,
                          @selector(addTarget:action:),
                          (IMP)&LE_NEW_UIGestureRecognizer_add, (IMP*)&LE_ORI_UIGestureRecognizer_add);
}

- (NSDictionary *)lookin_customDebugInfos {
    NSMutableArray *properties = [self le_customPropertyInfos];
    NSMutableArray *subviews = [self le_customSubviews];
    return NSDictionaryOfVariableBindings(properties, subviews);
}

- (NSMutableArray *)le_customPropertyInfos {
    return [NSMutableArray array];
}

- (NSMutableArray *)le_customSubviews {
    NSMutableArray *list = [NSMutableArray array];
    [list addObjectsFromArray:LEGestureRecognizerInfosForView(self)];
    return list;
}

@end
