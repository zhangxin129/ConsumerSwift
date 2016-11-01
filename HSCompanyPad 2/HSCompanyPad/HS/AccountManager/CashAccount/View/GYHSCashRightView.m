//
//  GYHSCashRightView.m
//  HSCompanyPad
//
//  Created by 吴文超 on 16/9/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSCashRightView.h"

@interface GYHSCashRightView ()

//显示账户余额的label
@property (weak, nonatomic) IBOutlet UILabel *showAccountBalanceLabel;

//查询明细按钮
@property (weak, nonatomic) IBOutlet UIButton *detailCheckBtn;

//账户余额名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel1;

//货币转银行按钮
@property (weak, nonatomic) IBOutlet UIButton *cashTransformBankBtn;







@end


@implementation GYHSCashRightView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.detailCheckBtn
     setTitle:kLocalized(@"GYHS_Account_Detail_Query")
     forState:UIControlStateNormal];
    self.nameLabel1.text = kLocalized(@"GYHS_Account_Account_Balance");
    [self.cashTransformBankBtn
     setTitle:kLocalized(@"GYHS_Account_CashToBank")
     forState:UIControlStateNormal];
}

//点击了明细查询
- (IBAction)clickDetailCheck:(id)sender
{
    [self.delegate
     cashView:self
     didTouchEvent:kCashAccountTouchEventDetail];
}

//点击了右边的小箭头
- (IBAction)clickTapDetailCheck:(id)sender
{
    [self.delegate
     cashView:self
     didTouchEvent:kCashAccountTouchEventDetail];
}

- (IBAction)clickTapCashToBank:(id)sender {
    [self.delegate
     cashView:self
     didTouchEvent:kCashAccountTouchEventCashToBank];
    
}

//点击了货币转银行
- (IBAction)cashTransformBank:(id)sender
{
    [self.delegate
     cashView:self
     didTouchEvent:kCashAccountTouchEventCashToBank];
}

- (void)setData:(GYHSAccountCenter *)data
{
    _data                             = data;
    self.showAccountBalanceLabel.text = [GYUtils formatCurrencyStyle:_data.cashBanlance.doubleValue];
}

@end
