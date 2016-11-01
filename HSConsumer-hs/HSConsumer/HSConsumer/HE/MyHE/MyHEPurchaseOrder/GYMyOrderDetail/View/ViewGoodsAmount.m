//
//  ViewGoodsAmount.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "ViewGoodsAmount.h"

@interface ViewGoodsAmount ()

@end

@implementation ViewGoodsAmount

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}
- (id)init
{
    NSArray* subviewArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    ViewGoodsAmount* v = [subviewArray objectAtIndex:0];
    [v.lbLabelAmount setTextColor:kCorlorFromHexcode(0x464646)];
    [v.lbLabelCourierFees setTextColor:kCorlorFromHexcode(0x464646)];
    [v.lbLabelPoint setTextColor:kCorlorFromHexcode(0x464646)];
    [v.lbLabelAmount setText:kLocalized(@"GYHE_MyHE_GoodsTotalMoney")];
    [v.lbLabelCourierFees setText:kLocalized(@"GYHE_MyHE_Freight")];
    [v.lbLabelPoint setText:kLocalized(@"GYHE_MyHE_BonusPoints")];

    [v.lbAmount setTextColor:kValueRedCorlor];
    [v.lbCourierFees setTextColor:kValueRedCorlor];
    [v.lbPoint setTextColor:kCorlorFromRGBA(0, 143, 215, 1)];

    [GYUtils setFontSizeToFitWidthWithLabel:v.lbAmount labelLines:1];
    [GYUtils setFontSizeToFitWidthWithLabel:v.lbCourierFees labelLines:1];
    [GYUtils setFontSizeToFitWidthWithLabel:v.lbPoint labelLines:1];
    [v setBackgroundColor:kDefaultVCBackgroundColor];
    return v;
}

+ (CGFloat)getHeight
{
    return 110.f;
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
