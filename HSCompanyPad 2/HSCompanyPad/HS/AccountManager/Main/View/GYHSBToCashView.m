//
//  GYHSHSBToCoinLeftView.m
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/9.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSBToCashView.h"
#import "GYHSAccountUIFactory.h"
#import <GYKit/UIView+Extension.h>
#import "UITextField+GYHSPointTextField.h"
#import "GYHSAccountCenter.h"
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
@interface GYHSBToCashView ()
@property (nonatomic, weak) GYHSAccountUIFactory *availableNumView;
@property (nonatomic, strong) UILabel *showNumberLabel;
@property (nonatomic, strong) UILabel *transfromFeeLabel;
@end
@implementation GYHSBToCashView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initView];
    }

    return self;
}

/**
 *  互生币转货币的左边视图
 */
- (void)initView
{
    self.backgroundColor = kDefaultVCBackgroundColor; //左边大的view的背景色

    //第一个小方框

    GYHSAccountUIFactory *availableNumView = [[GYHSAccountUIFactory alloc] initKVImageViewWithFrame:CGRectMake(kLetfwidth, kLetfwidth + kNavigationHeight, kLabelWidthMax, kLabelHeightMax)
                                                                                          imageName:kLocalized(@"gyhs_point_min_coin")
                                                                                              title:kLocalized(@"GYHS_Account_Number_Of_Turns")
                                                                                              value:@"0.00"
                                                                                         valueColor:kBlue0A59C2];
    [self addSubview:availableNumView];
    self.availableNumView = availableNumView;

    //第二个小方框

    GYHSAccountUIFactory *realView = [[GYHSAccountUIFactory alloc] initInputViewWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(availableNumView.frame) + KLineHeight, kInputViewWidth, kCommonHeight)
                                                                                    title:kLocalized(@"GYHS_Account_Output_Quantity")
                                                                              placeholder:kLocalized(@"GYHS_Account_Output_HSB_Quantity")];
    realView.textField.userInteractionEnabled = YES;
    realView.textField.inputView              = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:realView];
    self.turnOutTf = realView.textField;

    //第三个小方框  实际上是前面两个小方框拼起来的

    GYHSAccountUIFactory *twoLabelView = [[GYHSAccountUIFactory alloc] initKVCustomViewWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(realView.frame) + KLineHeight, kInputViewWidth, kCommonHeight)
                                                                                           title:kLocalized(@"GYHS_Account_Transfer_Into_Account")
                                                                                           value:kLocalized(@"GYHS_Account_Cash_Account")
                                                                                      valueColor:kGray333333
                                                                                      isOKButton:NO];

    twoLabelView.textField.userInteractionEnabled = YES;
    [self addSubview:twoLabelView];

    GYHSAccountUIFactory *threeLabelView = [[GYHSAccountUIFactory alloc] initKVCustomViewWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(twoLabelView.frame) + KLineHeight, kInputViewWidth, kCommonHeight)
                                                                                             title:[kLocalized(@"GYHS_Account_Cash_Transform_Fee") stringByAppendingString:[NSString stringWithFormat:@"%.0f%%)", globalData.config.hsbToHbRate.doubleValue * 100]]
                                                                                             value:@"0.00"
                                                                                        valueColor:kRedE50012
                                                                                        isOKButton:NO];

    self.transfromFeeLabel = threeLabelView.valueLabel;

    threeLabelView.textField.userInteractionEnabled = YES;
    [self addSubview:threeLabelView];

    //第四个小方框 gyhs_point_min_coin

    GYHSAccountUIFactory *coinAmountView = [[GYHSAccountUIFactory alloc] initKVCustomViewWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(threeLabelView.frame) + KLineHeight, kInputViewWidth, kCommonHeight)
                                                                                             title:kLocalized(@"GYHS_Account_Actual_Transfer_Quantity")
                                                                                             value:@"0.00"
                                                                                        valueColor:kGray333333
                                                                                        isOKButton:NO];
    
    

    self.showNumberLabel = coinAmountView.valueLabel;

    [self addSubview:coinAmountView];

    //第四个小方框  温馨提示

    GYHSAccountUIFactory *tipsView = [[GYHSAccountUIFactory alloc] init];
    [tipsView initWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(coinAmountView.frame) + KLineHeight, kInputViewWidth, kDeviceProportion(100))
           showTipsWordsOne:[kLocalized(@"GYHS_Account_HSB_Accounts_Can_Be_Transferred_The_Number_Is_Not_Less_Than") stringByAppendingString:[[NSString stringWithFormat:@"%.0f", globalData.config.hsbToHbMin.doubleValue] stringByAppendingString:kLocalized(@"GYHS_Account_The_Interger_Again")]]
               tipsWordsTwo:[kLocalized(@"GYHS_Account_HSB_Transform_Cash_Accounts_Should_Be_Deducted_From") stringByAppendingString:[[NSString stringWithFormat:@"%.0f%%", [globalData.config.hsbToHbRate doubleValue] * 100] stringByAppendingString:kLocalized(@"GYHS_Account_The_HSB_As_The_Currency_Conversion_Fee")]]
             tipsWordsThree:kLocalized(@"GYHS_Account_The_Number_Of_Available_Currency_Is_Ltb_Account_Less_ 300_(Alternate_Currency_Remainder_Base_Number)")];

    [self addSubview:tipsView];

    //第五个小方框  提示输入密码
    GYHSAccountUIFactory *tipPasswordsView = [[GYHSAccountUIFactory alloc] initPasswordViewWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(tipsView.frame) + kDeviceProportion(24), kInputViewWidth, kCommonHeight)];

    [self addSubview:tipPasswordsView];
    self.passWordTf = tipPasswordsView.textField;

    //设置自身视图的大小

    self.size = CGSizeMake(kDeviceProportion(469), kDeviceProportion(626)); //根据ui设计写
}

/**
 *  设流通币的余额值
 *
 *  @param ltbBalance 流通币余额值参数
 */
- (void)setLtbBalance:(NSString *)ltbBalance
{
    _ltbBalance                           = ltbBalance;
    self.availableNumView.valueLabel.text = [GYUtils formatCurrencyStyle:(ltbBalance.doubleValue - 300.f)];
}

/**
 *  设转换费的值
 *
 *  @param turnOutFee 转换费的数值
 */
- (void)setTurnOutFee:(NSString *)turnOutFee
{
    _turnOutFee                 = turnOutFee;
    self.transfromFeeLabel.text = [GYUtils formatCurrencyStyle:turnOutFee.doubleValue];
    self.showNumberLabel.text   = [GYUtils formatCurrencyStyle:([self.turnOutTf deleteFormString].doubleValue - turnOutFee.doubleValue)];
}

@end
