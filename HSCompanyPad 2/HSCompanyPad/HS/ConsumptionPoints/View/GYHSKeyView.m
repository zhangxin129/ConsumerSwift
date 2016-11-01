//
//  GYHSKeyView.m
//
//  Created by apple on 16/7/28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSKeyView.h"
#import "GYHSPublicMethod.h"
#import "GYPadKeyboradView.h"
#import <GYKit/UIColor+HEX.h>
#define kKeyBtnWidth kDeviceProportion(130)
#define kLetfwidth kDeviceProportion(20)
#define kButtonTag 100
#define kHSBNavColor [UIColor colorWithHexString:@"#f2b80a"]
#define kScanNavColor [UIColor colorWithHexString:@"#87b500"]
@interface GYHSKeyView () <GYPadKeyboradViewDelegate>
@property (nonatomic, weak) UIView* keyView;
@property (nonatomic, weak) GYPadKeyboradView* keyboard;
@property (nonatomic, strong) UIButton* payBtn;
@property (nonatomic, strong) UIButton* payOtherBtn;

@end
@implementation GYHSKeyView

- (instancetype)init
{
    if (self = [super init]) {
        [self setUI];
    }
    return self;
}

#pragma mark - setUI
- (void)setUI
{
    UIView* keyView = [[UIView alloc] init];
    keyView.backgroundColor = kWhiteFFFFFF;
    [self addSubview:keyView];
    self.keyView = keyView;
    @weakify(self);
    [self.keyView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.right.left.bottom.equalTo(self);
    }];
    
    GYPadKeyboradView* keyboard = [[GYPadKeyboradView alloc] init];
    keyboard.delegate = self;
    keyboard.backgroundColor = kWhiteFFFFFF;
    [keyView addSubview:keyboard];
    self.keyboard = keyboard;
    [self.keyboard mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.left.top.bottom.equalTo(self.keyView);
        make.right.equalTo(self.keyView).offset(-(kKeyBtnWidth + kLetfwidth));
    }];
    
    CGFloat checkHeight = kDeviceProportion(77);
    CGFloat payHeight = kDeviceProportion(162);
    //    CGFloat okHeight =  kDeviceProportion(187);
    UIButton* checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_point_notes"] forState:UIControlStateNormal];
    checkBtn.tag = kButtonTag;
    [checkBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.keyView addSubview:checkBtn];
    [checkBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.right.equalTo(self.keyView).offset(-kLetfwidth);
        make.top.equalTo(self.keyView).offset(kLetfwidth / 2);
        make.size.mas_equalTo(CGSizeMake(kKeyBtnWidth, checkHeight));
    }];
    
    UIButton* payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.tag = kButtonTag + 1;
    [payBtn setBackgroundImage:[UIImage imageNamed:@"point_payHSB"] forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.keyView addSubview:payBtn];
    self.payBtn = payBtn;
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.right.equalTo(self.keyView).offset(-kLetfwidth);
        make.top.equalTo(checkBtn).offset(kLetfwidth / 4 + checkHeight);
        make.size.mas_equalTo(CGSizeMake(kKeyBtnWidth, payHeight));
    }];
    
    UIButton* payOtherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payOtherBtn.tag = kButtonTag + 2;
    [payOtherBtn setBackgroundImage:[UIImage imageNamed:@"point_payscan"] forState:UIControlStateNormal];
    [payOtherBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.keyView addSubview:payOtherBtn];
    self.payOtherBtn = payOtherBtn;
    [self.payOtherBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.right.equalTo(self.keyView).offset(-kLetfwidth);
        make.top.equalTo(self.payBtn).offset(kLetfwidth / 4 + payHeight);
        make.size.mas_equalTo(CGSizeMake(kKeyBtnWidth, payHeight));
    }];
    
    UIButton* sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"point_surecash"] forState:UIControlStateNormal];
    sureBtn.tag = kButtonTag + 3;
    [sureBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.keyView addSubview:sureBtn];
    self.sureBtn = sureBtn;
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.right.equalTo(self.keyView).offset(-kLetfwidth);
        make.top.equalTo(self.payOtherBtn).offset(kLetfwidth / 4 + payHeight);
        make.bottom.equalTo(self).offset(-13);
        make.width.mas_equalTo(kKeyBtnWidth);
    }];
}

#pragma mark - 支付方式
- (void)setPointPay:(kPointPayType)pointPay
{
    _pointPay = pointPay;
    UIViewController* vc = [GYHSPublicMethod viewControllerWithView:self];
    switch (_pointPay) {
    case kPointPayCash:
        [self.payBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_point_hsbpay"] forState:UIControlStateNormal];
        [self.payOtherBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_point_scanpay"] forState:UIControlStateNormal];
        [self.sureBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_point_ok_cash"] forState:UIControlStateNormal];
        vc.navigationController.navigationBar.barTintColor = kBlue0A59C2;
        vc.title = kLocalized(@"GYHS_Point_Consume_Cash_Pay");
        break;
    case kPointPayHSB:
        [self.payBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_point_cashpay"] forState:UIControlStateNormal];
        [self.payOtherBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_point_scanpay"] forState:UIControlStateNormal];
        [self.sureBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_point_ok_hsb"] forState:UIControlStateNormal];
        vc.navigationController.navigationBar.barTintColor = kHSBNavColor;
        vc.title = kLocalized(@"GYHS_Point_Consume_Hsb_Pay");
        
        break;
    case kPointPayScan:
        [self.payBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_point_cashpay"] forState:UIControlStateNormal];
        [self.payOtherBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_point_hsbpay"] forState:UIControlStateNormal];
        [self.sureBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_point_ok_scan"] forState:UIControlStateNormal];
        vc.navigationController.navigationBar.barTintColor = kScanNavColor;
        vc.title = kLocalized(@"GYHS_Point_Consume_Code_Pay");
        break;
    default:
        break;
    }
}

#pragma mark - clcik
- (void)click:(UIButton*)button
{
    if (self.pointPay == kPointPayCash) {
        if (button.tag == kButtonTag + 1) {
            self.pointPay = kPointPayHSB;
        } else if (button.tag == kButtonTag + 2) {
            self.pointPay = kPointPayScan;
        }
    } else if (self.pointPay == kPointPayHSB) {
        if (button.tag == kButtonTag + 1) {
            self.pointPay = kPointPayCash;
        } else if (button.tag == kButtonTag + 2) {
            self.pointPay = kPointPayScan;
        }
    } else if (self.pointPay == kPointPayScan) {
        if (button.tag == kButtonTag + 1) {
            self.pointPay = kPointPayCash;
        } else if (button.tag == kButtonTag + 2) {
            self.pointPay = kPointPayHSB;
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(keyClick:)]) {
        [_delegate keyClick:button.tag - kButtonTag];
    }
}

#pragma mark -GYPadKeyboradViewDelegate
- (void)padKeyBoardViewDidClickNumberWithString:(NSString*)string;
{
    if (_delegate && [_delegate respondsToSelector:@selector(keyAddWithString:)]) {
        [_delegate keyAddWithString:string];
    }
}

- (void)padKeyBoardViewDidClickDelete
{
    if (_delegate && [_delegate respondsToSelector:@selector(keyDeleteWithString)]) {
        [_delegate keyDeleteWithString];
    }
}

@end
