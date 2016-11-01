//
//  GYHSPointTransformHSBView.m
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/2.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPointTransformHSBView.h"
#import "GYHSAccountUIFactory.h"
#import <GYKit/UIView+Extension.h>

#import "UITextField+GYHSPointTextField.h"

#define kLetfwidth kDeviceProportion(20)
#define kButtonWidth kDeviceProportion(90)
#define kInputViewWidth kDeviceProportion(429)
#define kCommonHeight kDeviceProportion(45)
#define kNavigationHeight 44
#define KLineHeight kDeviceProportion(3.0)
#define kDistanceHeight kDeviceProportion(24)
#define kSetBtnSize kDeviceProportion(20)

//定义宽度
#define kLabelWidthMax kDeviceProportion(429)
#define kLabelHeightMax kDeviceProportion(45)

@interface GYHSPointTransformHSBView ()
@property (nonatomic, strong) UILabel *showNuberLabel;
@property (nonatomic, strong) UILabel *showCanUsePointLabel;
@end

@implementation GYHSPointTransformHSBView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initView];
    }
    return self;
}

/**
 *  初始化ui
 */
- (void)initView
{
    self.backgroundColor = kDefaultVCBackgroundColor; //左边大的view的背景色
    GYHSAccountUIFactory *availableNumView = [[GYHSAccountUIFactory alloc] initKVImageViewWithFrame:CGRectMake(kLetfwidth, kLetfwidth + kNavigationHeight, kLabelWidthMax, kLabelHeightMax)
                                                                                          imageName:kLocalized(@"gyhs_point_min")
                                                                                              title:kLocalized(@"GYHS_Account_The_Remainder_Is_Available")
                                                                                              value:@"0.00"
                                                                                         valueColor:kBlue0A59C2];

    self.showCanUsePointLabel = availableNumView.valueLabel;
    [self addSubview:availableNumView];

    GYHSAccountUIFactory *realView = [[GYHSAccountUIFactory alloc] initInputViewWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(availableNumView.frame) + KLineHeight, kInputViewWidth, kCommonHeight)
                                                                                    title:kLocalized(@"GYHS_Account_Transfer_Product_Score")
                                                                              placeholder:kLocalized(@"GYHS_Account_Input_Transfer_Product_Score")];
    realView.textField.userInteractionEnabled = YES;
    [self addSubview:realView];
    self.turnOutTf = realView.textField;

    GYHSAccountUIFactory *twoLabelView = [[GYHSAccountUIFactory alloc] initKVCustomViewWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(realView.frame) + KLineHeight, kInputViewWidth, kCommonHeight)
                                                                                           title:kLocalized(@"GYHS_Account_Transfer_Into_Account")
                                                                                           value:kLocalized(@"GYHS_Account_HSB_Account")
                                                                                      valueColor:kGray333333
                                                                                      isOKButton:NO];
    twoLabelView.textField.userInteractionEnabled = NO;
    [self addSubview:twoLabelView];

    //第四个小方框 gyhs_point_min_coin
    GYHSAccountUIFactory *coinAmountView = [[GYHSAccountUIFactory alloc] initImageValueViewWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(twoLabelView.frame) + KLineHeight, kInputViewWidth, kCommonHeight)
                                                                                           imageName:kLocalized(@"gyhs_point_min_coin")
                                                                                               value:@""];

    self.showNuberLabel = coinAmountView.valueLabel;
    [self addSubview:coinAmountView];
    //第五个小方框  温馨提示
    GYHSAccountUIFactory *tipsView = [[GYHSAccountUIFactory alloc] init]; //
    [tipsView initWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(coinAmountView.frame) + KLineHeight, kInputViewWidth, kDeviceProportion(52))
              showTipsWords:[kLocalized(@"GYHS_Account_Integration_Points_Available_For_The_Number_Of_Points_Can_Be_Transferred_Out_The_Number_Is_Not_Less_Than") stringByAppendingString:[[NSString stringWithFormat:@"%.0f", globalData.config.pointMin.doubleValue] stringByAppendingString:kLocalized(@"GYHS_Account_The_Interger")]]];
    [self addSubview:tipsView];

    //第六个小方框  提示输入密码
    GYHSAccountUIFactory *tipPasswordsView = [[GYHSAccountUIFactory alloc] initPasswordViewWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(tipsView.frame) + kDeviceProportion(24), kInputViewWidth, kCommonHeight)];
    tipPasswordsView.userInteractionEnabled = YES;
    self.passWordTf                         = tipPasswordsView.textField;
    [self addSubview:tipPasswordsView];

    self.size = CGSizeMake(kDeviceProportion(469), kDeviceProportion(626)); //根据ui设计写
}

//set方法
- (void)setCanUsePoints:(NSString *)canUsePoints
{
    _canUsePoints                  = canUsePoints;
    self.showCanUsePointLabel.text = [GYUtils formatCurrencyStyle:canUsePoints.doubleValue];
}

//set方法
- (void)setTuranOutValue:(NSString *)turanOutValue
{
    _turanOutValue           = turanOutValue;
    self.showNuberLabel.text = turanOutValue;
}

@end
