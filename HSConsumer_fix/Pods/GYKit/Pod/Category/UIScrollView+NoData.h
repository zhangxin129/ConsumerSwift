//
//  UIScrollView+NoData.h
//  Applications
//
//  Created by apple on 16/6/17.
//  Copyright © 2016年 DZN Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"
typedef void (^dispatch_noDataAction)(void);
@interface UIScrollView (NoData) <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

- (void)noDataViewWithContext:(NSString*)content block:(dispatch_block_t)aciton;

@property (nonatomic, copy, readonly) NSString* content;
@property (nonatomic, copy, readonly) dispatch_noDataAction action;

@end
