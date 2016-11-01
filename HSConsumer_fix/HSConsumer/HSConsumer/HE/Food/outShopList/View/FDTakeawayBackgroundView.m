//
//  FDTakeawayBackgroundView.m
//  HSConsumer
//
//  Created by zhangqy on 15/9/23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#define SINGLE_LINE_WIDTH (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET ((1 / [UIScreen mainScreen].scale) / 2)
#import "FDTakeawayBackgroundView.h"

@implementation FDTakeawayBackgroundView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1 / [UIScreen mainScreen].scale);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 0, height - 1 - SINGLE_LINE_ADJUST_OFFSET);
    CGContextAddLineToPoint(ctx, width, height - 1 - SINGLE_LINE_ADJUST_OFFSET);
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:210 / 255.0 green:210 / 255.0 blue:210 / 255.0 alpha:1.0].CGColor);
    CGContextStrokePath(ctx);

    CGContextMoveToPoint(ctx, (int)width / 3 + SINGLE_LINE_ADJUST_OFFSET, 10);
    CGContextAddLineToPoint(ctx, (int)width / 3 + SINGLE_LINE_ADJUST_OFFSET, height - 10);
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0].CGColor);
    CGContextStrokePath(ctx);

    CGContextMoveToPoint(ctx, (int)width / 3 * 2 + SINGLE_LINE_ADJUST_OFFSET, 10);
    CGContextAddLineToPoint(ctx, (int)width / 3 * 2 + SINGLE_LINE_ADJUST_OFFSET, height - 10);
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0].CGColor);
    CGContextStrokePath(ctx);
}

@end
