//
//  GYHSConsumerView.m
//  HSCompanyPad
//
//  Created by 梁晓辉 on 16/7/27.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSConsumerView.h"
#import "GYHSConsumePointMainVC.h"
#import "GYHSPointInputView.h"
#import "GYHSPointView.h"
#import "GYHSPointVolumeView.h"
#import "GYHSPublicMethod.h"
#import "GYSettingHttpTool.h"
#import "GYSettingPointRateSetViewController.h"
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
@interface GYHSConsumerView () <GYHSVolumeViewDelegate>
@property (nonatomic, weak) GYHSPointVolumeView* volumeView;
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) NSArray* pointArray;
@end
@implementation GYHSConsumerView

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
    self.volumeAmount = @"0.00";
    self.volumePage = @"0";
    self.backgroundColor = kDefaultVCBackgroundColor;
    GYHSPointInputView* consumView = [[GYHSPointInputView alloc] initWithFrame:CGRectMake(kLetfwidth, kLetfwidth + kNavigationHeight, kInputViewWidth - kButtonWidth, kCommonHeight) imageName:@"gyhs_point_cash" placeholder:kLocalized(@"GYHS_Point_Input_Consume_Cash")];
    [self addSubview:consumView];
    
    self.consumView = consumView;
    
    UIButton* volumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    volumeBtn.frame = CGRectMake(CGRectGetMaxX(self.consumView.frame), kLetfwidth + kNavigationHeight, kButtonWidth, kCommonHeight);
    [volumeBtn setTitle:kLocalized(@"GYHS_Point_Volume") forState:UIControlStateNormal];
    volumeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    volumeBtn.backgroundColor = kGrayc8c8d8;
    [volumeBtn setTitleColor:kGray888888 forState:UIControlStateNormal];
    [volumeBtn addTarget:self action:@selector(volumeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:volumeBtn];
    self.volumeBtn = volumeBtn;
    
    UIImageView* imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"gyhs_point_arrow"];
    [self.volumeBtn addSubview:imageView];
    self.imageView = imageView;
    @weakify(self);
    [self.imageView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.centerX.equalTo(self.volumeBtn);
        make.bottom.equalTo(self.volumeBtn).offset(-5);
        make.size.mas_equalTo(CGSizeMake(kImageSize, kImageSize));
    }];
    
    GYHSPointInputView* realView = [[GYHSPointInputView alloc] initWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(self.consumView.frame) + KLineHeight, kInputViewWidth, kCommonHeight) imageName:@"gyhs_money_coin" placeholder:kLocalized(@"GYHS_Point_Real_Cash")];
    realView.textfield.userInteractionEnabled = NO;
    realView.textfield.textColor = kRedE40011;
    [self addSubview:realView];
    self.realView = realView;
    
    //折合互生币
    GYHSPointInputView* HSBView = [[GYHSPointInputView alloc] initWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(self.realView.frame) + KLineHeight, kInputViewWidth / 2, kCommonHeight) imageName:@"gyhs_HSBCoin_min" placeholder:kLocalized(@"GYHS_Point_Equivalent_Hsb")];
    HSBView.textfield.userInteractionEnabled = NO;
    HSBView.textfield.text = @"0.00";
    [self addSubview:HSBView];
    self.HSBView = HSBView;
    //积分金额
    GYHSPointInputView* pointView = [[GYHSPointInputView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.HSBView.frame), CGRectGetMaxY(self.realView.frame) + KLineHeight, kInputViewWidth / 2, kCommonHeight) imageName:@"gyhs_max_point" placeholder:kLocalized(@"GYHS_Point_Point_Cash")];
    pointView.textfield.userInteractionEnabled = NO;
    pointView.textfield.text = @"0.00";
    [self
        addSubview:pointView];
    self.pointView = pointView;
    
    //积分比率
    self.pointArray = kGetNSUser(pointData);
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
    
    self.size = CGSizeMake(CGRectGetMaxX(self.realView.frame), CGRectGetMaxY(self.HSBView.frame) + kDistanceHeight + pointSelect.height);
}

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
    if (_cleanBlock) {
        _cleanBlock();
    }
}

#pragma mark - 设置
- (void)setClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(popSetPointRate)]) {
        [_delegate popSetPointRate];
    }
}

#pragma mark - 抵扣券
- (void)volumeClick:(UIButton*)button
{
    if (!self.consumView.textfield.text.length) {
        [self.consumView.textfield tipWithContent:kLocalized(@"GYHS_Point_Input_Consume_Cash") animated:YES];
        return;
    }
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
    [self.volumeBtn setTitle:volumeAmount.length ? [NSString stringWithFormat:@"%@", volumeAmount] : kLocalized(@"GYHS_Point_Volume") forState:UIControlStateNormal];
    self.volumeAmount = volumeAmount.length ? volumeAmount : @"0.00";
    self.volumePage = pageVolume;
    if (self.consumView.textfield.text.length) {
        NSString* consumeStr = [self.consumView.textfield deleteFormString];
        NSDecimalNumber* consumeDeciaml = [NSDecimalNumber decimalNumberWithString:consumeStr];
        NSDecimalNumber* volumeDecimal = [NSDecimalNumber decimalNumberWithString:self.volumeAmount];
        NSDecimalNumber* HSBRateDeicmal = [NSDecimalNumber decimalNumberWithString:globalData.config.currencyToHsbRate];
        self.realView.textfield.text = [consumeDeciaml decimalNumberByAdding:volumeDecimal].stringValue;
        self.realView.textfield.text = [UITextField keepTwoDeciaml:self.realView.textfield.text];
        self.HSBView.textfield.text = [[consumeDeciaml decimalNumberByAdding:volumeDecimal] decimalNumberByMultiplyingBy:HSBRateDeicmal].stringValue;
        self.HSBView.textfield.text = [UITextField keepTwoDeciaml:self.HSBView.textfield.text];
        
    } else {
        self.realView.textfield.text = @"";
    }
    if (_cleanBlock) {
        _cleanBlock();
    }
}



@end
