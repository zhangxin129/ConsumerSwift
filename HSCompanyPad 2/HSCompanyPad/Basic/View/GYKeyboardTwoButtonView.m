//
//  UIViewTwoButton.m
//  HSCompanyPad
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 wangbb. All rights reserved.
//

#import "GYKeyboardTwoButtonView.h"
#import <GYKit/UIButton+GYExtension.h>
@interface GYKeyboardTwoButtonView ()

@property (nonatomic, strong) UIButton* btnOne;
@property (nonatomic, strong) UIButton* btnOk;
@property (nonatomic, copy) NSString* title;

@end

@implementation GYKeyboardTwoButtonView

- (instancetype)initWithTitle:(NSString*)titleName
{
    self = [super init];
    if (self) {
        self.title = titleName;
        [self setUp];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)dealloc
{
    DDLogInfo(@"消失了");
}

- (void)setUp
{
    
    [self addSubview:self.btnOne];
    [_btnOne mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(kDeviceProportion(10));
        make.height.equalTo(self).multipliedBy(0.5).offset(kDeviceProportion(-14));
    }];
    
    [self addSubview:self.btnOk];
    [_btnOk mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(kDeviceProportion(-13));
        make.top.equalTo(self.mas_centerYWithinMargins).offset(kDeviceProportion(2.5));
    }];
}

- (void)btnOneAction
{
    if ([self.delegate respondsToSelector:@selector(keyboardTwoButtonViewFirstClick)]) {
        [_delegate keyboardTwoButtonViewFirstClick];
    }
}

- (void)btnOkAction:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(keyboardTwoButtonViewSecondClick:)]) {
        [_delegate keyboardTwoButtonViewSecondClick:button];
    }
}

#pragma mark - lazy load
- (UIButton*)btnOne
{
    if (!_btnOne) {
        _btnOne = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnOne.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_btnOne addTarget:self action:@selector(btnOneAction) forControlEvents:UIControlEventTouchUpInside];
        [_btnOne setBackgroundImage:[UIImage imageNamed:@"gycom_keyboard_bigBackground"] forState:UIControlStateNormal];
        [_btnOne setBackgroundImage:[UIImage imageNamed:@"gycom_keyboard_bigBackground"] forState:UIControlStateHighlighted];
        [_btnOne setTitle:self.title forState:UIControlStateNormal];
        _btnOne.titleLabel.font = [UIFont boldSystemFontOfSize:21];
        _btnOne.titleLabel.numberOfLines = 0;
        _btnOne.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_btnOne setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    return _btnOne;
}

- (UIButton*)btnOk
{
    if (!_btnOk) {
        _btnOk = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnOk.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_btnOk setBackgroundImage:[UIImage imageNamed:@"gyhs_btn_blue_ok"] forState:UIControlStateNormal];
        [_btnOk setBackgroundImage:[UIImage imageNamed:@"gyhs_btn_blue_ok_high"] forState:UIControlStateHighlighted];
        [_btnOk addTarget:self action:@selector(btnOkAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnOk;
}

@end
