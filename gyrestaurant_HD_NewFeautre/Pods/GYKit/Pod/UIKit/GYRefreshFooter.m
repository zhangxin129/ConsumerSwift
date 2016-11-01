//
//  GYRefreshFooter.m
//  company
//
//  Created by sqm on 16/5/25.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYRefreshFooter.h"

@implementation GYRefreshFooter
#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    // 设置普通状态的动画图片
    NSMutableArray* idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i <= 10; i++) {
    
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"GYRefresh.bundle/0%ld", (unsigned long)i]];
        CGSize size = CGSizeMake(35, 35);
        
        UIGraphicsBeginImageContext(size);
        
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [idleImages addObject:newImage];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray* refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i <= 10; i++) {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"GYRefresh.bundle/0%ld", (unsigned long)i]];
        
        CGSize size = CGSizeMake(35, 35);
        
        UIGraphicsBeginImageContext(size);
        
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [refreshingImages addObject:newImage];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    
}

- (void)beginRefreshing
{
    
    [super beginRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endRefreshing];
    });
}
@end
