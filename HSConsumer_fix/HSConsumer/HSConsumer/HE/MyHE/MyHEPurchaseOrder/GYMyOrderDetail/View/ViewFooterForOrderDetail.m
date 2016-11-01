//
//  ViewFooterForOrderDetail.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "ViewFooterForOrderDetail.h"

@interface ViewFooterForOrderDetail ()

@end

@implementation ViewFooterForOrderDetail

- (id)init
{
    NSArray* subviewArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    ViewFooterForOrderDetail* v = [subviewArray objectAtIndex:0];
    [v.lbLabelRealisticAmount setTextColor:kCellItemTitleColor];
    [v.lbLabelPoint setTextColor:kCellItemTitleColor];

    [v.lbLabelRealisticAmount setText:kLocalized(@"GYHE_MyHE_ReallyPayMoney")];
    [v.lbLabelPoint setText:kLocalized(@"GYHE_MyHE_BonusPoints")];

    [v.lbRealisticAmount setTextColor:kValueRedCorlor];
    [v.lbPoint setTextColor:kCorlorFromRGBA(0, 143, 215, 1)];
    [v.lbRealisticAmount setFont:[UIFont boldSystemFontOfSize:20.f]];
    [v.lbPoint setFont:[UIFont boldSystemFontOfSize:20.f]];

    [GYUtils setFontSizeToFitWidthWithLabel:v.lbRealisticAmount labelLines:1];
    [GYUtils setFontSizeToFitWidthWithLabel:v.lbPoint labelLines:1];
    return v;
}

+ (CGFloat)getHeight
{
    return 65.0f;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    [self addTopBorderAndBottomBorder];
}

/*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   - (void)drawRect:(CGRect)rect
   {
    // Drawing code
   }
 */

@end
