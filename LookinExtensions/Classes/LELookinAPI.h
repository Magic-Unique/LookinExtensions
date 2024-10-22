//
//  LELookinAPI.h
//  LookinExtensions
//
//  Created by Magic-Unique on 2024/10/17.
//

#import <Foundation/Foundation.h>

#define LOOKIN_SECTION_NAME @"Extensions"

NS_INLINE NSMutableDictionary *LEStringProperty(NSString *title, NSString *value, void(^setter)(NSString *newValue)) {
    NSMutableDictionary *property = [NSMutableDictionary dictionary];
    property[@"section"] = LOOKIN_SECTION_NAME;
    property[@"title"] = title;
    property[@"valueType"] = @"string";
    property[@"value"] = value;
    property[@"retainedSetter"] = [setter copy];
    return property;
}

NS_INLINE NSMutableDictionary *LEBoolProperty(NSString *title, BOOL value, void(^setter)(BOOL newValue)) {
    NSMutableDictionary *property = [NSMutableDictionary dictionary];
    property[@"section"] = LOOKIN_SECTION_NAME;
    property[@"title"] = title;
    property[@"valueType"] = @"bool";
    property[@"value"] = [NSNumber numberWithBool:value];
    property[@"retainedSetter"] = [setter copy];
    return property;
}

NS_INLINE NSMutableDictionary *LEVirtualSubview(NSString *title, NSString *subtitle, UIView *superview, NSArray *properties) {
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[@"title"] = title;
    info[@"subtitle"] = subtitle;
    info[@"properties"] = properties;
    return info;
}

FOUNDATION_EXTERN void LELookinHookMessageEx(Class _class, SEL sel, IMP imp, IMP *result);
