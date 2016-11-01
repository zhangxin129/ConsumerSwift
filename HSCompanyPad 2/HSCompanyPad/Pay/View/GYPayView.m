//
//  GYPayView.m
//  HSCompanyPad
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYPayView.h"

@interface GYPayView()

@property (weak, nonatomic) IBOutlet UIButton *ylPayButton;
@property (weak, nonatomic) IBOutlet UIButton *quickPayButton;
@property (weak, nonatomic) IBOutlet UILabel *coinLable;
@property (weak, nonatomic) IBOutlet UILabel *coinRateLable;
@property (weak, nonatomic) IBOutlet UILabel *accountLable;


@end

@implementation GYPayView

- (void)layoutSubviews{
    [super layoutSubviews];
    [_ylPayButton setTitle:kLocalized(@"GYHSPay_CertificationCardPayment") forState:UIControlStateNormal];
    [_ylPayButton setImage:[UIImage imageNamed:@"gypay_unSelected"] forState:UIControlStateNormal];
    [_ylPayButton setImage:[UIImage imageNamed:@"gypay_selected"] forState:UIControlStateSelected];
    [_ylPayButton  setImageEdgeInsets:UIEdgeInsetsMake(9, 242 - 41, 0, 0)];
    [_ylPayButton setTitleColor:kGray333333 forState:UIControlStateNormal];
    [_ylPayButton setTitleColor:kRedE50012 forState:UIControlStateSelected];
    _ylPayButton.layer.borderWidth = 1.0f;
    _ylPayButton.layer.borderColor = kGrayCCCCCC.CGColor;
    
    [_quickPayButton setTitle:kLocalized(@"GYHSPay_FastCardPayment") forState:UIControlStateNormal];
    [_quickPayButton setImage:[UIImage imageNamed:@"gypay_unSelected"] forState:UIControlStateNormal];
    [_quickPayButton setImage:[UIImage imageNamed:@"gypay_selected"] forState:UIControlStateSelected];
     [_quickPayButton  setImageEdgeInsets:UIEdgeInsetsMake(9, 242 - 41, 0, 0)];
    [_quickPayButton setTitleColor:kGray333333 forState:UIControlStateNormal];
    [_quickPayButton setTitleColor:kRedE50012 forState:UIControlStateSelected];
    _quickPayButton.layer.borderWidth = 1.0f;
    _quickPayButton.layer.borderColor = kGrayCCCCCC.CGColor;
    
    NSMutableAttributedString* coinMsg = [[NSMutableAttributedString alloc] init];
    [coinMsg appendAttributedString:[[NSAttributedString alloc] initWithString:kLocalized(@"GYHSPay_LocalBillingCurrency") attributes:@{ NSFontAttributeName : kFont32, NSForegroundColorAttributeName : kGray666666 }]];
    
    [coinMsg appendAttributedString:[[NSAttributedString alloc] initWithString:kLocalized(@"GYHSPay_RenMinBi") attributes:@{ NSFontAttributeName : kFont32, NSForegroundColorAttributeName : kRedE50012 }]];
    _coinLable.attributedText = coinMsg;
    
    NSMutableAttributedString* coinRateMsg = [[NSMutableAttributedString alloc] init];
    [coinRateMsg appendAttributedString:[[NSAttributedString alloc] initWithString:kLocalized(@"GYHSPay_CurrencyConversionRatio") attributes:@{ NSFontAttributeName : kFont32, NSForegroundColorAttributeName : kGray666666 }]];
    
    [coinRateMsg appendAttributedString:[[NSAttributedString alloc] initWithString:globalData.config.currencyToHsbRate attributes:@{ NSFontAttributeName : kFont32, NSForegroundColorAttributeName : kRedE50012 }]];
    _coinRateLable.attributedText = coinRateMsg;
    
    
    NSMutableAttributedString* accountMsg = [[NSMutableAttributedString alloc] init];
    [accountMsg appendAttributedString:[[NSAttributedString alloc] initWithString:kLocalized(@"GYHSPay_CurrencyConversionAmount") attributes:@{ NSFontAttributeName : kFont32, NSForegroundColorAttributeName : kGray666666 }]];
    
    [accountMsg appendAttributedString:[[NSAttributedString alloc] initWithString:[GYUtils formatCurrencyStyle:_accountStr.doubleValue] attributes:@{ NSFontAttributeName : kFont32, NSForegroundColorAttributeName : kRedE50012 }]];
    _accountLable.attributedText = accountMsg;

}

- (IBAction)btnAction:(UIButton *)sender {
    if (sender == self.ylPayButton) {
        if ([self.delegate respondsToSelector:@selector(ylPaymentAction)]) {
            [self.delegate ylPaymentAction];
        }
        sender.selected = !sender.selected;
        if (sender.selected == YES) {
            self.quickPayButton.selected = NO;
        }else{
            self.ylPayButton.selected = YES;
        }
    }else if (sender == self.quickPayButton){
        if ([self.delegate respondsToSelector:@selector(quickPaymentAction)]) {
            [self.delegate quickPaymentAction];
        }
        sender.selected = !sender.selected;
        if (sender.selected == YES) {
            self.ylPayButton.selected = NO;
        }else{
            self.quickPayButton.selected = YES;
        }
    }
    
}

@end
