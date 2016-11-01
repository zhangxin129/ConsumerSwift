//
//  UITableView+LegendBlock.h
//  HSConsumer
//
//  Created by zhangqy on 15/10/27.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
typedef void (^lengendBlock)();
#import <UIKit/UIKit.h>

@interface UITableView (LegendBlock)
- (void)addLegendHeaderWithRefreshingBlock:(lengendBlock)block;

- (void)addLegendFooterWithRefreshingBlock:(lengendBlock)block;

- (void)addLegendFooterWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

- (void)addLegendHeaderWithRefreshingTarget:(id)target refreshingAction:
        (SEL)action;
@end
