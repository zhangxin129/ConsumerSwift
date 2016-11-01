//
//  GYHSCunsumeTextField.m
//
//  Created by apple on 16/8/1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSCunsumeTextField.h"
#define kEdgeMargin 5

@implementation GYHSCunsumeTextField
- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super textRectForBounds:bounds];
    iconRect.origin.x += kEdgeMargin;
    return iconRect;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super placeholderRectForBounds:bounds];
    iconRect.origin.x += kEdgeMargin;
    return iconRect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super editingRectForBounds:bounds];
    iconRect.origin.x += kEdgeMargin;
    return iconRect;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super rightViewRectForBounds:bounds];
    iconRect.origin.x -= kEdgeMargin;
    return iconRect;
}

@end
