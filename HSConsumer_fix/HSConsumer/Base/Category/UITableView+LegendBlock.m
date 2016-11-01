//
//  UITableView+LegendBlock.m
//  HSConsumer
//
//  Created by zhangqy on 15/10/27.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "UITableView+LegendBlock.h"

@implementation UITableView (LegendBlock)

- (void)addLegendHeaderWithRefreshingBlock:(lengendBlock)block
{
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:block];

    self.mj_header = header;
}

- (void)addLegendFooterWithRefreshingBlock:(lengendBlock)block
{
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:block];

    self.mj_footer = footer;
}

- (void)addLegendHeaderWithRefreshingTarget:(id)target refreshingAction:
        (SEL)action
{
    [self addLegendHeaderWithRefreshingBlock:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:action];
#pragma clang diagnostic pop
    }];
}

- (void)addLegendFooterWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    [self addLegendFooterWithRefreshingBlock:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:action];
#pragma clang diagnostic pop
    }];
}

@end
