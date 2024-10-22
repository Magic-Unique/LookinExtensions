//
//  UIScrollView+LookinExtension.m
//  LookinExtensions
//
//  Created by Magic-Unique on 2024/10/17.
//

#import "UIScrollView+LookinExtension.h"

@implementation UIScrollView (LookinExtension)

- (NSMutableArray *)le_customPropertyInfos {
    NSMutableArray *list = [super le_customPropertyInfos];
    [list addObject:LEStringProperty(@"Delegate", ({
        NSString *value = @"null";
        if (self.delegate) {
            value = [NSString stringWithFormat:@"<%@: %p>", [self.delegate class], self.delegate];
        }
        value;
    }), nil)];
    return list;
}

@end


@implementation UITableView (LookinExtension)

- (NSMutableArray *)le_customPropertyInfos {
    NSMutableArray *list = [super le_customPropertyInfos];
    [list addObject:LEStringProperty(@"Data Source", ({
        NSString *value = @"null";
        if (self.dataSource) {
            value = [NSString stringWithFormat:@"<%@: %p>", [self.dataSource class], self.dataSource];
        }
        value;
    }), nil)];
    return list;
}

@end


@implementation UICollectionView (LookinExtension)

- (NSMutableArray *)le_customPropertyInfos {
    NSMutableArray *list = [super le_customPropertyInfos];
    [list addObject:LEStringProperty(@"Data Source", ({
        NSString *value = @"null";
        if (self.dataSource) {
            value = [NSString stringWithFormat:@"<%@: %p>", [self.dataSource class], self.dataSource];
        }
        value;
    }), nil)];
    return list;
}

@end
