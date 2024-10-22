//
//  UIControl+LookinExtension.m
//  LookinExtensions
//
//  Created by Magic-Unique on 2024/10/17.
//

#import "UIControl+LookinExtension.h"

static NSString *NSStringFromUIControlEvent(UIControlEvents event) {
    switch (event) {
#define CaseEvent(event) case UIControlEvent##event: return @#event;
            CaseEvent(TouchDown);
            CaseEvent(TouchDownRepeat);
            CaseEvent(TouchDragInside);
            CaseEvent(TouchDragOutside);
            CaseEvent(TouchDragEnter);
            CaseEvent(TouchDragExit);
            CaseEvent(TouchUpInside);
            CaseEvent(TouchUpOutside);
            CaseEvent(TouchCancel);
            CaseEvent(ValueChanged);
            CaseEvent(EditingDidBegin);
            CaseEvent(EditingChanged);
            CaseEvent(EditingDidEnd);
            CaseEvent(EditingDidEndOnExit);
#undef CaseEvent
            case UIControlEventAllTouchEvents:
            case UIControlEventAllEditingEvents:
            case UIControlEventApplicationReserved:
            case UIControlEventSystemReserved:
            case UIControlEventAllEvents:
        default:break;
    }
    if (@available(iOS 9.0, *)) {
        if (event == UIControlEventPrimaryActionTriggered) {
            return @"PrimaryActionTriggered";
        }
    }
    if (@available(iOS 14.0, *)) {
        if (event == UIControlEventMenuActionTriggered) {
            return @"MenuActionTriggered";
        }
    }
    return nil;
}

static NSArray *LEControlEventInfosForControl(UIControl *control) {
    NSMutableArray *results = [NSMutableArray array];
    
    UIControlEvents events = control.allControlEvents;
    NSArray *targets = control.allTargets.allObjects;
    for (NSUInteger i = 0; i < 20; i++) {
        UIControlEvents currentEvent = 1 << i;
        if ((events & currentEvent) == 0) {
            continue;
        }
        NSString *currentEventName = NSStringFromUIControlEvent(currentEvent);
        if (currentEventName == nil) {
            continue;
        }
        for (id target in targets) {
            NSString *className = NSStringFromClass([target class]);
            NSArray *actions = [control actionsForTarget:target forControlEvent:currentEvent];
            for (NSString *action in actions) {
                NSString *targetAction = [NSString stringWithFormat:@"-[%@ %@]", className, action];
                NSDictionary *info = LEStringProperty(currentEventName, targetAction, nil);
                [results addObject:info];
            }
        }
    }
    return results;
}

@implementation UIControl (LookinExtension)

- (NSMutableArray *)le_customPropertyInfos {
    NSMutableArray *list = [super le_customPropertyInfos];
    [list addObjectsFromArray:LEControlEventInfosForControl(self)];
    return list;
}

@end
