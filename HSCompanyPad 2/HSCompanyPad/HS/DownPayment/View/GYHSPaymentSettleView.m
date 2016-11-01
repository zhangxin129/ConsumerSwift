//
//  GYHSPaymentSettleView.m
//  HSCompanyPad
//
//  Created by 梁晓辉 on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPaymentSettleView.h"
#import "GYHSDownPayMainVC.h"
#import "GYHSPaymentCheckModel.h"
#import "GYHSPaymentListView.h"
#import "GYHSPointInputView.h"
#import "GYHSPointView.h"
#import "GYHSPointVolumeView.h"
#import "GYHSPublicMethod.h"
#import <GYKit/UIButton+GYExtension.h>
#import "UITextField+GYHSPointTextField.h"
#import "GYTextField.h"
#define kLetfwidth kDeviceProportion(20)
#define kButtonWidth kDeviceProportion(90)
#define kInputViewWidth kDeviceProportion(429)
#define kCommonHeight kDeviceProportion(45)
#define KLineHeight kDeviceProportion(3.0)
#define kDistanceHeight kDeviceProportion(24)
#define kSetBtnSize kDeviceProportion(20)
#define kImageSize kDeviceProportion(8)
#define kBtnColor [UIColor colorWithHexString:@"#c8c8d8"]

@interface GYHSPaymentSettleView () <GYHSVolumeViewDelegate, GYHSPaymentSelectDelegate>
@property (nonatomic, weak) GYHSPointVolumeView* volumeView;
@property (nonatomic, weak) GYHSPaymentListView* payListView;
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) NSArray* pointArray;

@end
@implementation GYHSPaymentSettleView

- (instancetype)init
{
    if (self = [super init]) {
        [self setUI];
    }
    return self;
}

#pragma  mark - setUI
- (void)setUI
{
    self.volumeAmount = @"0.00";
    self.volumePage = @"0";
    self.backgroundColor = kDefaultVCBackgroundColor;
    //互生卡行
    @weakify(self);
    GYHSPointInputView* cardView = [[GYHSPointInputView alloc] initWithFrame:CGRectMake(kLetfwidth, kLetfwidth + kNavigationHeight, kInputViewWidth, kCommonHeight) imageName:@"gyhs_payment_card" placeholder:kLocalized(@"GYHS_Down_Swipe_Input_Number")];
    [self addSubview:cardView];
    self.cardView = cardView;
    
    GYHSPointInputView* cashView = [[GYHSPointInputView alloc] initWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(self.cardView.frame) + KLineHeight, kInputViewWidth, kCommonHeight) imageName:@"gyhs_HSBCoin" placeholder:kLocalized(@"GYHS_Down_Settle_Down_Cash")];
    cashView.textfield.userInteractionEnabled = NO;
    [self addSubview:cashView];
    self.cashView = cashView;
    
    UIButton* button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"gyhs_payment_arrow"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.cashView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(self.cashView);
        make.right.equalTo(self.cashView).offset(-kDeviceProportion(22));
        make.size.mas_equalTo(CGSizeMake(kDeviceProportion(16), kDeviceProportion(16)));
    }];
    [button setEnlargEdgeWithTop:10 right:10 bottom:10 left:10];
    GYHSPointInputView* consumView = [[GYHSPointInputView alloc] initWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(self.cashView.frame) + KLineHeight, kInputViewWidth - kButtonWidth, kCommonHeight) imageName:@"gyhs_point_cash" placeholder:kLocalized(@"GYHS_Down_Input_Consume_Cash")];
    [self addSubview:consumView];
    self.consumView = consumView;
    
    UIButton* volumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    volumeBtn.frame = CGRectMake(CGRectGetMaxX(self.consumView.frame), CGRectGetMinY(self.consumView.frame), kButtonWidth, kCommonHeight);
    [volumeBtn setTitle:kLocalized(@"GYHS_Down_Volume") forState:UIControlStateNormal];
    volumeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    volumeBtn.backgroundColor = kBtnColor;
    [volumeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [volumeBtn addTarget:self action:@selector(volumeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:volumeBtn];
    self.volumeBtn = volumeBtn;
    
    UIImageView* imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"gyhs_point_arrow"];
    [self.volumeBtn addSubview:imageView];
    self.imageView = imageView;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.centerX.equalTo(self.volumeBtn);
        make.bottom.equalTo(self.volumeBtn).offset(-5);
        make.size.mas_equalTo(CGSizeMake(kImageSize, kImageSize));
    }];
    
    //折合互生币
    GYHSPointInputView* HSBView = [[GYHSPointInputView alloc] initWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(self.consumView.frame) + KLineHeight, kInputViewWidth / 2, kCommonHeight) imageName:@"gyhs_HSBCoin_min" placeholder:kLocalized(@"GYHS_Down_Equivalent_Hsb")];
    HSBView.textfield.userInteractionEnabled = NO;
    HSBView.textfield.text = @"0.00";
    [self addSubview:HSBView];
    self.HSBView = HSBView;
    //积分金额
    GYHSPointInputView* pointView = [[GYHSPointInputView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.HSBView.frame), CGRectGetMaxY(self.consumView.frame) + KLineHeight, kInputViewWidth / 2, kCommonHeight) imageName:@"gyhs_max_point" placeholder:kLocalized(@"GYHS_Down_Point_Cash")];
    pointView.textfield.userInteractionEnabled = NO;
    pointView.textfield.text = @"0.00";
    [self
        addSubview:pointView];
    self.pointView = pointView;
    
    //积分比率
    self.pointArray = kGetNSUser(paymentPoint);
    GYHSPointView* pointSelect = [[GYHSPointView alloc] initWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(self.HSBView.frame) + kDistanceHeight, kInputViewWidth, 0) array:self.pointArray];
    [self addSubview:pointSelect];
    self.pointRate = pointSelect.pointStr;
    pointSelect.block = ^(NSString* pointString) {
        @strongify(self);
        self.pointRate = pointString;
    };
    
    UIButton* setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.size = CGSizeMake(kSetBtnSize, kSetBtnSize);
    setButton.center = CGPointMake(pointSelect.x, pointSelect.y);
    [setButton setBackgroundImage:[UIImage imageNamed:@"gyhs_point_set"] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:setButton];
    
    self.size = CGSizeMake(CGRectGetMaxX(self.cardView.frame), CGRectGetMaxY(self.HSBView.frame) + kDistanceHeight + pointSelect.height);
}

#pragma mark - setter
- (void)setPointRate:(NSString*)pointRate
{
    _pointRate = pointRate;
    // 输入金额
    if (self.consumView.textfield.text.length) {
        double inputValue = [self.consumView.textfield deleteFormString].doubleValue;
        double pointValue = inputValue * globalData.config.currencyToHsbRate.doubleValue * pointRate.doubleValue;
        self.pointView.textfield.text = [GYHSPublicMethod keepTwoDecimal:[NSString stringWithFormat:@"%.2f", pointValue]];
    } else {
        self.pointView.textfield.text = @"0.00";
    }
}

#pragma mark - click
- (void)click
{
    NSString* cardStr = [self.cardView.textfield deleteSpaceField];
    if (cardStr.length != 11) {
        [self.cardView.textfield tipWithContent:kLocalized(@"GYHS_Down_Input_Number_Error_Tip") animated:YES];
        return;
    }
    
    if (self.payListView == nil) {
        GYHSPaymentListView* payListView = [[GYHSPaymentListView alloc] initWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(self.cashView.frame) + KLineHeight + kMainHeadHeight, CGRectGetWidth(self.cashView.frame), 300)];
        payListView.isShow = YES;
        payListView.delegate = self;
        self.payListView = payListView;
    } else {
        self.payListView.isShow = !self.payListView.isShow;
    }
    if (self.payListView.isShow) {
        [self.payListView addRefreshView:cardStr];
    }
}

#pragma mark - 积分比率设置
- (void)setClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(popPointRate)]) {
        [_delegate popPointRate];
    }
}

#pragma mark - 抵扣券
- (void)volumeClick:(UIButton*)button
{
    if (!self.volumeView) {
        GYHSPointVolumeView* volume = [[GYHSPointVolumeView alloc] init];
        volume.delegate = self;
        volume.x = button.x;
        volume.y = CGRectGetMaxY(button.frame) + kMainHeadHeight;
        @weakify(self);
        volume.block = ^{
            @strongify(self);
            [UIView animateWithDuration:0.1
                             animations:^{
                                 self.imageView.transform = self.volumeView.isShow ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformIdentity;
                             }
                             completion:^(BOOL finished){
                             }];
                             
        };
        self.volumeView = volume;
    } else {
        self.volumeView.isShow = !self.volumeView.isShow;
    }
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.imageView.transform = self.volumeView.isShow ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished){
                     }];
}

#pragma mark -GYPOSVolumeViewDelegate
- (void)selectedVolume:(NSString*)volumeAmount pageVolume:(NSString*)pageVolume
{
    self.volumeBtn.backgroundColor = [pageVolume intValue] > 0?kGreenB5FFB5:kGrayc8c8d8;
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.imageView.transform = self.volumeView.isShow ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished){
                     }];
    [self.volumeBtn setTitle:volumeAmount.length ? [NSString stringWithFormat:@"%@", volumeAmount] : kLocalized(@"GYHS_Down_Volume") forState:UIControlStateNormal];
    self.volumeAmount = volumeAmount.length ? volumeAmount : @"0.00";
    self.volumePage = pageVolume;
    if (self.consumView.textfield.text.length) {
        NSString* consumeStr = [self.consumView.textfield deleteFormString];
        NSDecimalNumber* consumeDeciaml = [NSDecimalNumber decimalNumberWithString:consumeStr];
        NSDecimalNumber* volumeDecimal = [NSDecimalNumber decimalNumberWithString:self.volumeAmount];
        NSDecimalNumber* HSBRateDeicmal = [NSDecimalNumber decimalNumberWithString:globalData.config.currencyToHsbRate];
        self.HSBView.textfield.text = [[consumeDeciaml decimalNumberByAdding:volumeDecimal] decimalNumberByMultiplyingBy:HSBRateDeicmal].stringValue;
        self.HSBView.textfield.text = [UITextField keepTwoDeciaml:self.HSBView.textfield.text];
        
    } else {
    }
}

#pragma mark - GYHSPaymentSelectDelegate
- (void)selectPaymentModel:(GYHSPaymentCheckModel*)model
{
    self.cashView.textfield.text = [GYHSPublicMethod keepTwoDecimal:model.transAmount];
    self.model = model;
}

@end
