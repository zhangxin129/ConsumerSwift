//
//  GYHSPointInvestmentLeftView.m
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPointInvestView.h"

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
@interface GYHSPointInvestView ()
@property (nonatomic, strong) UILabel *showCanUsePointLabel;
@property (nonatomic, strong) UILabel *showNumberLabel;
@end
@implementation GYHSPointInvestView

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

    //第一个小方框

    GYHSAccountUIFactory *availableNumView = [[GYHSAccountUIFactory alloc] initKVImageViewWithFrame:CGRectMake(kLetfwidth, kLetfwidth + kNavigationHeight, kLabelWidthMax, kLabelHeightMax)
                                                                                          imageName:kLocalized(@"gyhs_point_min")
                                                                                              title:kLocalized(@"GYHS_Account_The_Remainder_Is_Available")
                                                                                              value:@"0.00"
                                                                                         valueColor:kBlue0A59C2];

    self.showCanUsePointLabel = availableNumView.valueLabel;
    [self addSubview:availableNumView];

    //第二个小方框

    GYHSAccountUIFactory *realView = [[GYHSAccountUIFactory alloc] initInputViewWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(availableNumView.frame) + KLineHeight, kInputViewWidth, kCommonHeight)
                                                                                    title:kLocalized(@"GYHS_Account_Points_Of_Investment")
                                                                              placeholder:kLocalized(@"GYHS_Account_Input_Points_Of_Investment")];
    realView.textField.userInteractionEnabled = YES;
    [self addSubview:realView];
    self.turnOutTf = realView.textField;
    //第三个小方框  实际上是前面两个小方框拼起来的

    GYHSAccountUIFactory *twoLabelView = [[GYHSAccountUIFactory alloc] initKVCustomViewWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(realView.frame) + KLineHeight, kInputViewWidth, kCommonHeight)
                                                                                           title:kLocalized(@"GYHS_Account_Transfer_Into_Account")
                                                                                           value:kLocalized(@"GYHS_Account_Investment_Account")
                                                                                      valueColor:kGray333333
                                                                                      isOKButton:NO];

    twoLabelView.textField.userInteractionEnabled = YES;
    [self addSubview:twoLabelView];

    //第四个小方框  温馨提示
    GYHSAccountUIFactory *tipsView = [[GYHSAccountUIFactory alloc] init];
    [tipsView initWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(twoLabelView.frame) + KLineHeight, kInputViewWidth, kDeviceProportion(95))
           showTipsWordsOne:[kLocalized(@"GYHS_Account_Integral_Investment_Amount") stringByAppendingString:[[NSString stringWithFormat:@"%.0f", globalData.config.investPointMin.doubleValue] stringByAppendingString:kLocalized(@"GYHS_Account_The_Interger_Three")]]
               tipsWordsTwo:kLocalized(@"GYHS_Account_Integral_Investment_Once_Confirmed_Will_Never_Be_Revoked")
             tipsWordsThree:kLocalized(@"GYHS_Account_The_Platform_Is_Committed_To_Capital_Preservation_Fund_The_Return_Is_Calculated_Per_Year")];                                                                                                                                                                                                  //52 * kDeviceProportion 是有点问题

    [self addSubview:tipsView];

    //第五个小方框  提示输入密码
    GYHSAccountUIFactory *tipPasswordsView = [[GYHSAccountUIFactory alloc] initPasswordViewWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(tipsView.frame) + kDeviceProportion(24), kInputViewWidth, kCommonHeight)]; //52 * kDeviceProportion 是有点问题
    self.passWordTf = tipPasswordsView.textField;

    [self addSubview:tipPasswordsView];

    //设置自身视图的大小

    self.size = CGSizeMake(kDeviceProportion(469), kDeviceProportion(626)); //根据ui设计写
}

//set方法
- (void)setCanUsePoints:(NSString *)canUsePoints
{
    _canUsePoints                  = canUsePoints;
    self.showCanUsePointLabel.text = [GYUtils formatCurrencyStyle:canUsePoints.doubleValue];
}

@end
