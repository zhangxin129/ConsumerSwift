//
//  GYHSCoinToBankLeftView.m
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSCashToBankView.h"
#import "GYHSAccountUIFactory.h"
#import <GYKit/UIView+Extension.h>
#import "UITextField+GYHSPointTextField.h"
#import "GYHSBankListModel.h"
#define kLetfwidth kDeviceProportion(20)
#define kButtonWidth kDeviceProportion(90)
#define kInputViewWidth kDeviceProportion(429)
#define kCommonHeight kDeviceProportion(45)
#define kSpecialHeight kDeviceProportion(68)
#define kNavigationHeight 44
#define KLineHeight kDeviceProportion(3.0)
#define kDistanceHeight kDeviceProportion(24)
#define kSetBtnSize kDeviceProportion(20)

//定义宽度
#define kLabelWidthMax kDeviceProportion(429)
#define kLabelHeightMax kDeviceProportion(45)
#define kSmallImageSizeWH kDeviceProportion(20)
#define kCommonCardViewTag 221
#define kSetSmallPicWH kDeviceProportion(26)

@interface GYHSCashToBankView () <GYHSAccountUIFactoryDelegate>
@property (nonatomic, weak) GYHSAccountUIFactory *availableNumView;
@property (nonatomic, weak) UIView *bottomView;

@property (nonatomic, weak) GYHSAccountUIFactory *coinAmountView;
@end

@implementation GYHSCashToBankView


#pragma mark-----第一次进入界面
// 制作第一次进入的界面(默认带有银行卡)
- (void)initCommanView
{
    
    self.backgroundColor = kDefaultVCBackgroundColor; //左边大的view的背景色

    //第一个小方框
    GYHSAccountUIFactory *availableNumView = [[GYHSAccountUIFactory alloc] initKVImageViewWithFrame:CGRectMake(kLetfwidth, kLetfwidth, kLabelWidthMax, kLabelHeightMax)
                                                                                          imageName:kLocalized(@"gyhs_coinToBank_small_icon")
                                                                                              title:kLocalized(@"GYHS_Account_Available_Balance")
                                                                                              value:@"0.00"
                                                                                         valueColor:kBlue0A59C2];
    [self addSubview:availableNumView];
    self.availableNumView = availableNumView;

    //第二个小方框

    GYHSAccountUIFactory *realView = [[GYHSAccountUIFactory alloc] initInputViewWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(availableNumView.frame) + kDistanceHeight, kInputViewWidth, kCommonHeight)
                                                                                    title:kLocalized(@"GYHS_Account_Transfer_Amount")
                                                                              placeholder:kLocalized(@"GYHS_Account_Input_Transfer_Amount")];
    realView.textField.userInteractionEnabled = YES;
    [self addSubview:realView];
    self.turnOutTf = realView.textField;

    //第三个小方框  实际上是前面两个小方框拼起来的

    GYHSAccountUIFactory *twoLabelView = [[GYHSAccountUIFactory alloc] initKVCustomViewWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(realView.frame) + KLineHeight, kInputViewWidth, kCommonHeight)
                                                                                           title:kLocalized(@"GYHS_Account_Transfer_Into_Account")
                                                                                           value:kLocalized(@"GYHS_Account_Bank_Bccount")
                                                                                      valueColor:kGray333333
                                                                                      isOKButton:NO];
    [self addSubview:twoLabelView];

    //第四个小方框 gyhs_point_min_coin
    GYHSAccountUIFactory *coinAmountView = [[GYHSAccountUIFactory alloc] initChooseViewWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(twoLabelView.frame) + kDistanceHeight, kInputViewWidth, kCommonHeight)
                                                                                           title:kLocalized(@"GYHS_Account_Bank_Bccount")
                                                                                           value:kLocalized(@"GYHS_Account_Other_Bank_Accounts")
                                                                                 smallArrowColor:YES];
    self.coinAmountView = coinAmountView;
    [self addSubview:coinAmountView];
    coinAmountView.delegate = self;

    //第五个小方框

    GYHSAccountUIFactory *addBankCardView = [[GYHSAccountUIFactory alloc] init];
    [addBankCardView initBankCardViewWithImageName:@""title:kLocalized(@"GYHS_Account_Bank_Card")  bankCardType:@"1"
                                                                                                                          value:kLocalized(@"GYHS_Account_Last_Digits")];
    addBankCardView.frame = CGRectMake(kLetfwidth, CGRectGetMaxY(coinAmountView.frame) + KLineHeight, kInputViewWidth, kSpecialHeight);
    [self addSubview:addBankCardView];
    self.addBankCardView = addBankCardView;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(coinAmountView.frame) + kDeviceProportion(24), kInputViewWidth, kCommonHeight + kDeviceProportion(52) + kDistanceHeight)];
    [self addSubview:view];
    self.bottomView = view;

    //第五个小方框  提示输入密码
    GYHSAccountUIFactory *tipPasswordsView = [[GYHSAccountUIFactory alloc] initPasswordViewWithFrame:CGRectMake(0, 0, kInputViewWidth, kCommonHeight)];
    [view addSubview:tipPasswordsView];
    self.passWordTf = tipPasswordsView.textField;

    //第六个小方框  温馨提示

    
    GYHSAccountUIFactory *tipsView = [[GYHSAccountUIFactory alloc] init];
    [tipsView initTwoTipsWithFrame:CGRectMake(0, CGRectGetMaxY(tipPasswordsView.frame) + kDistanceHeight, kInputViewWidth, kDeviceProportion(92))
                     showTipsWords:[kLocalized(@"GYHS_Account_Can_TurnOut_And_Can_Not_Less") stringByAppendingString:[[NSString stringWithFormat:@"%.0f", globalData.config.hbToBankMin.doubleValue] stringByAppendingString:kLocalized(@"GYHS_Account_The_Interger")] ] andAnotherWords:kLocalized(@"GYHS_Account_The_Transfer_Fee_Is_Deducted_Please_Ensure_That_The_Balance_Is_Sufficient")];
    [view addSubview:tipsView];
}

#pragma mark-----没有默认银行卡的界面
/**
 *  制作没有默认银行卡的左边界面
 */
- (void)initNoCardView
{
    self.backgroundColor = kDefaultVCBackgroundColor; //左边大的view的背景色

    //第一个小方框
    GYHSAccountUIFactory *availableNumView = [[GYHSAccountUIFactory alloc] initKVImageViewWithFrame:CGRectMake(kLetfwidth, kLetfwidth, kLabelWidthMax, kLabelHeightMax)
                                                                                          imageName:kLocalized(@"gyhs_coinToBank_small_icon")
                                                                                              title:kLocalized(@"GYHS_Account_Available_Balance")
                                                                                              value:@"0.00"
                                                                                         valueColor:kBlue0A59C2];
    [self addSubview:availableNumView];
    self.availableNumView = availableNumView;

    //第二个小方框

    GYHSAccountUIFactory *realView = [[GYHSAccountUIFactory alloc] initInputViewWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(availableNumView.frame) + kDistanceHeight, kInputViewWidth, kCommonHeight)
                                                                                    title:kLocalized(@"GYHS_Account_Transfer_Amount")
                                                                              placeholder:kLocalized(@"GYHS_Account_Input_Transfer_Amount")];
    realView.textField.userInteractionEnabled = YES;
    [self addSubview:realView];
    self.originTurnOutTf = realView.textField;

    //第三个小方框  实际上是前面两个小方框拼起来的

    GYHSAccountUIFactory *twoLabelView = [[GYHSAccountUIFactory alloc] initKVCustomViewWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(realView.frame) + KLineHeight, kInputViewWidth, kCommonHeight)
                                                                                           title:kLocalized(@"GYHS_Account_Transfer_Into_Account")
                                                                                           value:kLocalized(@"GYHS_Account_Bank_Bccount")
                                                                                      valueColor:kGray333333
                                                                                      isOKButton:NO];
    [self addSubview:twoLabelView];

    //第四个小方框 gyhs_point_min_coin
    GYHSAccountUIFactory *coinAmountView = [[GYHSAccountUIFactory alloc] initChooseViewWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(twoLabelView.frame) + kDistanceHeight, kInputViewWidth, kCommonHeight)
                                                                                           title:kLocalized(@"GYHS_Account_Bank_Bccount")
                                                                                           value:@""
                                                                                 smallArrowColor:YES];
    self.coinAmountView = coinAmountView;
    [self addSubview:coinAmountView];
    coinAmountView.delegate = self;


    //第六个小方框  温馨提示
    GYHSAccountUIFactory *tipsView = [[GYHSAccountUIFactory alloc] init];
    [tipsView initTwoTipsWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(coinAmountView.frame) + kDistanceHeight, kInputViewWidth, kDeviceProportion(92) )
              showTipsWords:[kLocalized(@"GYHS_Account_Can_TurnOut_And_Can_Not_Less") stringByAppendingString:[[NSString stringWithFormat:@"%.0f", globalData.config.hbToBankMin.doubleValue] stringByAppendingString:kLocalized(@"GYHS_Account_The_Interger")] ] andAnotherWords:kLocalized(@"GYHS_Account_The_Transfer_Fee_Is_Deducted_Please_Ensure_That_The_Balance_Is_Sufficient")];

    [self addSubview:tipsView];
}

/**
 *  set方法 对余额赋值
 *
 *  @param cashBalance 余额参数
 */
- (void)setCashBalance:(NSString *)cashBalance
{
    _cashBalance                          = cashBalance;
    self.availableNumView.valueLabel.text = [GYUtils formatCurrencyStyle:cashBalance.doubleValue];
}

/**
 *  点击其他银行列表 跳转到列表页面的方法
 *
 *  @param cardViews 当前小视图
 */
- (void)hsAccountUITurnToBankList:(GYHSAccountUIFactory *)cardViews
{
    if ([self.delegate
         respondsToSelector:@selector(cashToBankViewDidClickSelectedBankAccount:)])
    {
        [self.delegate
         cashToBankViewDidClickSelectedBankAccount:self];
    }
}

/**
 *  setter方法
 *
 *  @param model 银行模型
 */
- (void)setModel:(GYHSBankListModel *)model
{
    _model = model;
    if (!model)
    {
        self.bottomView.y                   = CGRectGetMaxY(self.coinAmountView.frame) + kDeviceProportion(24);
        self.coinAmountView.valueLabel.text = @"";
    }
    else
    {
        self.bottomView.y                   = CGRectGetMaxY(self.addBankCardView.frame) + kDeviceProportion(24);
        self.coinAmountView.valueLabel.text = kLocalized(@"GYHS_Account_Other_Bank_Accounts");



        //还需要添加一个 储蓄卡 或 借记卡之类的标记

        if (model.bankAccNo.length < 5)
        {

            [self.addBankCardView
             initBankCardViewWithImageName:@""
                                     title:model.bankName
                              bankCardType:model.bankCardType
                                     value:[kLocalized(@"GYHS_Account_Last_Digits") stringByAppendingString:model.bankAccNo]];
        }
        else
        {
            [self.addBankCardView
             initBankCardViewWithImageName:@""
                                     title:model.bankName
                              bankCardType:model.bankCardType
                                     value:[kLocalized(@"GYHS_Account_Last_Digits") stringByAppendingString:[model.bankAccNo
                                                                                     substringFromIndex:model.bankAccNo.length - 4]]];

        }
    }
    [self layoutSubviews];
}

@end
