//
//  ViewUseVouchesInfo.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "ViewUseVouchesInfo.h"

@interface ViewUseVouchesInfo ()

@end

@implementation ViewUseVouchesInfo

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
    ViewUseVouchesInfo* v = [subviewArray objectAtIndex:0];

    [v.lbLabelHSConsumptionVouchers setTextColor:kCellItemTitleColor];
    [v.lbLabelHSGoldVouchers setTextColor:kCellItemTitleColor];
    [v.lbLabelTotalVouchers setTextColor:kCellItemTitleColor];
    [v.lbLabelHSConsumptionVouchers setText:kLocalized(@"GYHE_MyHE_FirstSend")];
    [v.lbLabelHSGoldVouchers setText:kLocalized(@"GYHE_MyHE_HSVouchers")];
    [v.lbLabelTotalVouchers setText:kLocalized(@"GYHE_MyHE_TotalDeduction")];

    [v.lbHSConsumptionVouchers setTextColor:kCellItemTextColor];
    [v.lbHSGoldConsumption setTextColor:kCellItemTextColor];
    [v.lbTotalVouchers setTextColor:kValueRedCorlor];

    [v.lbLabelDi0 setTextColor:kCellItemTextColor];
    [v.lbLabelDi1 setTextColor:kCellItemTextColor];
    [v.lbLabelDi0 setText:kLocalized(@"GYHE_MyHE_Di")];
    [v.lbLabelDi1 setText:kLocalized(@"GYHE_MyHE_Di")];

    [v.lbVouchersInfo0 setTextColor:kCellItemTextColor];
    [v.lbVouchersInfo1 setTextColor:kCellItemTextColor];

    for (UIView* view in v.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [GYUtils setFontSizeToFitWidthWithLabel:view labelLines:1];
        }
    }

    return v;
}

+ (CGFloat)getHeight
{
    return 55.0f;
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
