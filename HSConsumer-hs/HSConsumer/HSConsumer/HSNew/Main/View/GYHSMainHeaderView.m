//
//  GYHSMainHeaderView.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSMainHeaderView.h"
#import "GYHSTools.h"

@interface GYHSMainHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton* sweepCodePayBtn;
@property (weak, nonatomic) IBOutlet UIButton* paymentCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton* exchangeBtn;
@property (weak, nonatomic) IBOutlet UIButton* integralCodeBtn;

@property (weak, nonatomic) IBOutlet UIImageView* oneTriangleImageView;
@property (weak, nonatomic) IBOutlet UIImageView* twoTriangleImageView;
@property (weak, nonatomic) IBOutlet UIImageView* threeTriangleImageView;
@property (weak, nonatomic) IBOutlet UIImageView* fourTriangleImageView;

@property (weak, nonatomic) IBOutlet UILabel* sweepCodeLb;
@property (weak, nonatomic) IBOutlet UILabel *sweepCodeUpLb;
@property (weak, nonatomic) IBOutlet UILabel* paymentLb;
@property (weak, nonatomic) IBOutlet UILabel *paymentUpLb;
@property (weak, nonatomic) IBOutlet UILabel* integralCodeLb;
@property (weak, nonatomic) IBOutlet UILabel *integralCodeUpLb;
@property (weak, nonatomic) IBOutlet UILabel* exchangeLb;
@property (weak, nonatomic) IBOutlet UILabel *exchangeUpLb;

@end

@implementation GYHSMainHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = kotherPayBtnCorlor;
    self.sweepCodeLb.font = kHeaderViewFont;
    self.sweepCodeUpLb.font = kSecondTitleFont;
    self.paymentLb.font = kHeaderViewFont;
    self.paymentUpLb.font = kSecondTitleFont;
    self.integralCodeLb.font = kHeaderViewFont;
    self.integralCodeUpLb.font = kSecondTitleFont;
    self.exchangeLb.font = kHeaderViewFont;
    self.exchangeUpLb.font = kSecondTitleFont;
}

- (void)resetSelectFlag:(NSInteger)flag
{
    switch (flag) {
        case 0:{
            self.oneTriangleImageView.hidden = YES;
            self.twoTriangleImageView.hidden = YES;
            self.threeTriangleImageView.hidden = YES;
            self.fourTriangleImageView.hidden = YES;
            
            [self.sweepCodeLb setTextColor:[UIColor whiteColor]];
            [self.paymentLb setTextColor:[UIColor whiteColor]];
            [self.integralCodeLb setTextColor:[UIColor whiteColor]];
            [self.exchangeLb setTextColor:[UIColor whiteColor]];
        }
            break;
        case 1:{
            self.oneTriangleImageView.hidden = NO;
            self.twoTriangleImageView.hidden = YES;
            self.threeTriangleImageView.hidden = YES;
            self.fourTriangleImageView.hidden = YES;
            
            [self.sweepCodeLb setTextColor:kMainYellowCorlor];
            [self.paymentLb setTextColor:[UIColor whiteColor]];
            [self.integralCodeLb setTextColor:[UIColor whiteColor]];
            [self.exchangeLb setTextColor:[UIColor whiteColor]];
        }
            break;
        case 2:{
            self.oneTriangleImageView.hidden = YES;
            self.twoTriangleImageView.hidden = NO;
            self.threeTriangleImageView.hidden = YES;
            self.fourTriangleImageView.hidden = YES;
            
            [self.sweepCodeLb setTextColor:[UIColor whiteColor]];
            [self.paymentLb setTextColor:kMainYellowCorlor];
            [self.integralCodeLb setTextColor:[UIColor whiteColor]];
            [self.exchangeLb setTextColor:[UIColor whiteColor]];
        }
            break;
        case 3:{
            self.oneTriangleImageView.hidden = YES;
            self.twoTriangleImageView.hidden = YES;
            self.threeTriangleImageView.hidden = NO;
            self.fourTriangleImageView.hidden = YES;
            
            [self.sweepCodeLb setTextColor:[UIColor whiteColor]];
            [self.paymentLb setTextColor:[UIColor whiteColor]];
            [self.integralCodeLb setTextColor:kMainYellowCorlor];
            [self.exchangeLb setTextColor:[UIColor whiteColor]];        }
            break;
        case 4:{
            self.oneTriangleImageView.hidden = YES;
            self.twoTriangleImageView.hidden = YES;
            self.threeTriangleImageView.hidden = YES;
            self.fourTriangleImageView.hidden = NO;
            
            [self.sweepCodeLb setTextColor:[UIColor whiteColor]];
            [self.paymentLb setTextColor:[UIColor whiteColor]];
            [self.integralCodeLb setTextColor:[UIColor whiteColor]];
            [self.exchangeLb setTextColor:kMainYellowCorlor];
        }
            break;
        default:
            break;
    }
    
}

- (IBAction)sweepCodePay:(id)sender
{
    self.oneTriangleImageView.hidden = NO;
    self.twoTriangleImageView.hidden = YES;
    self.threeTriangleImageView.hidden = YES;
    self.fourTriangleImageView.hidden = YES;
    [self.sweepCodeLb setTextColor:kMainYellowCorlor];
    [self.paymentLb setTextColor:[UIColor whiteColor]];
    [self.integralCodeLb setTextColor:[UIColor whiteColor]];
    [self.exchangeLb setTextColor:[UIColor whiteColor]];

    if ([self.delegate respondsToSelector:@selector(sweepCodePayAction:)]) {
        [self.delegate sweepCodePayAction:sender];
    }
}

- (IBAction)paymentCodeBtn:(id)sender
{
    self.oneTriangleImageView.hidden = YES;
    self.twoTriangleImageView.hidden = NO;
    self.threeTriangleImageView.hidden = YES;
    self.fourTriangleImageView.hidden = YES;
    [self.sweepCodeLb setTextColor:[UIColor whiteColor]];
    [self.paymentLb setTextColor:kMainYellowCorlor];
    [self.integralCodeLb setTextColor:[UIColor whiteColor]];
    [self.exchangeLb setTextColor:[UIColor whiteColor]];

    if ([self.delegate respondsToSelector:@selector(paymentCodeAction:)]) {
        [self.delegate paymentCodeAction:sender];
    }
}

- (IBAction)integralCode:(id)sender
{
    self.oneTriangleImageView.hidden = YES;
    self.twoTriangleImageView.hidden = YES;
    self.threeTriangleImageView.hidden = NO;
    self.fourTriangleImageView.hidden = YES;
    [self.sweepCodeLb setTextColor:[UIColor whiteColor]];
    [self.paymentLb setTextColor:[UIColor whiteColor]];
    [self.integralCodeLb setTextColor:kMainYellowCorlor];
    [self.exchangeLb setTextColor:[UIColor whiteColor]];

    if ([self.delegate respondsToSelector:@selector(integralCodeAction:)]) {
        [self.delegate integralCodeAction:sender];
    }
}

- (IBAction)exchangeBtn:(id)sender
{
    self.oneTriangleImageView.hidden = YES;
    self.twoTriangleImageView.hidden = YES;
    self.threeTriangleImageView.hidden = YES;
    self.fourTriangleImageView.hidden = NO;
    [self.sweepCodeLb setTextColor:[UIColor whiteColor]];
    [self.paymentLb setTextColor:[UIColor whiteColor]];
    [self.integralCodeLb setTextColor:[UIColor whiteColor]];
    [self.exchangeLb setTextColor:kMainYellowCorlor];

    if ([self.delegate respondsToSelector:@selector(exchangeHSMoneyAction:)]) {
        [self.delegate exchangeHSMoneyAction:sender];
    }
}


@end
