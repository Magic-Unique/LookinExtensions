//
//  UIView+LookinExtension.h
//  LookinExtensions
//
//  Created by Magic-Unique on 2024/10/17.
//

#import <UIKit/UIKit.h>
#import "LELookinAPI.h"

@interface UIView (LookinExtension)

/// DO NOT OVERRIDE THIS METHOD
- (NSDictionary *)lookin_customDebugInfos;

/// Override this method to append new properties in subclass
- (NSMutableArray *)le_customPropertyInfos;

/// Override this to append new subviews in subclass
- (NSMutableArray *)le_customSubviews;

@end
