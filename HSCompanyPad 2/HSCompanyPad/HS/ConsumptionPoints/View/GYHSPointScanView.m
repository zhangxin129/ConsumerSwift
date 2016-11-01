//
//  GYHSPointScanView.m
//
//  Created by apple on 16/8/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPointScanView.h"
#define kMargin 10
#define kDistance 15
#define kImageSize kDeviceProportion(190)
#define kButtonHeight kDeviceProportion(33)
#define kButtonWidth kDeviceProportion(101)
@implementation GYHSPointScanView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

#pragma mark - setUI
- (void)setUI
{
    self.backgroundColor = [UIColor whiteColor];
    UIView* backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    @weakify(self);
    [backView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.left.bottom.right.equalTo(self);

    }];
    
    UIImageView* scanImage = [[UIImageView alloc] init];
    [backView addSubview:scanImage];
    self.scanImageView = scanImage;
    [self.scanImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(backView).offset(kMargin);
        make.centerX.equalTo(backView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kImageSize, kImageSize));
    }];
    
    UIButton* checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkButton.layer.cornerRadius = 5;
    [checkButton setTitle:kLocalized(@"GYHS_Point_Check_Final") forState:UIControlStateNormal];
    [checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkButton setBackgroundColor:kRedE50012];
    [checkButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:checkButton];
    [checkButton mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.equalTo(self.scanImageView.mas_bottom).offset(kDistance);
        make.centerX.equalTo(backView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kButtonWidth, kButtonHeight));
    }];
    
}

#pragma mark - click
- (void)click:(UIButton*)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(scanClick)]) {
        [_delegate scanClick];
    }
}
@end
