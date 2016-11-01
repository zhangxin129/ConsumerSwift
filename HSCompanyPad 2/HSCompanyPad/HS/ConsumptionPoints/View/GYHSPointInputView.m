//
//  GYHSPointInputView.m
//
//  Created by apple on 16/7/27.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPointInputView.h"
#import "GYTextField.h"
#define kImageLeftwidth kDeviceProportion(10)
#define kFieldLeftWidth kDeviceProportion(7)
#define kImageSize kDeviceProportion(26)
#define kFieldHeight kDeviceProportion(26)
#define kRightViewWidth kDeviceProportion(45)
#define kImageTag 100

@interface GYHSPointInputView ()
@property (nonatomic, copy) NSString* imageName;
@property (nonatomic, copy) NSString* placeholder;
@property (nonatomic, strong) UIImageView* imageView;
@end

@implementation GYHSPointInputView
- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString*)imageName placeholder:(NSString*)placeholder

{
    if (self = [super initWithFrame:frame]) {
        self.imageName = imageName;
        self.placeholder = placeholder;
        self.backgroundColor = [UIColor whiteColor];
        [self setUI];
    }
    return self;
}

#pragma mark - setUI
- (void)setUI
{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageLeftwidth, 0, kImageSize, kImageSize)];
    imageView.centerY = self.size.height / 2;
    imageView.image = [UIImage imageNamed:self.imageName];
    [self addSubview:imageView];
    self.imageView = imageView;
    
    GYTextField* textfield = [[GYTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + kFieldLeftWidth, 0, CGRectGetWidth(self.frame) - CGRectGetMaxX(imageView.frame) - kFieldLeftWidth,self.height)];
    textfield.centerY = self.size.height / 2;
    textfield.placeholder = self.placeholder;
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    textfield.textColor = kGray333333;
    textfield.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:textfield];
    self.textfield = textfield;
    self.isShowRightView = NO;
}

#pragma mark - 是否显示rightView
- (void)setIsShowRightView:(BOOL)isShowRightView
{
    _isShowRightView = isShowRightView;
    if (isShowRightView) {
        UIView* baseRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kRightViewWidth * 2, kImageSize)];
        baseRightView.customBorderType = UIViewCustomBorderTypeLeft;
        UIImageView* cardRightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhs_card_post"]];
        cardRightView.userInteractionEnabled = YES;
        cardRightView.contentMode = UIViewContentModeCenter;
        cardRightView.frame = CGRectMake(0, 0, kRightViewWidth, kImageSize);
        cardRightView.tag = kImageTag + 1;
        [baseRightView addSubview:cardRightView];
        UITapGestureRecognizer* cardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [cardRightView addGestureRecognizer:cardTap];
        cardRightView.customBorderType = UIViewCustomBorderTypeRight;
        UIImageView* scanRightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhs_scan_image"]];
        scanRightView.userInteractionEnabled = YES;
        scanRightView.contentMode = UIViewContentModeCenter;
        scanRightView.frame = CGRectMake(kRightViewWidth, 0, kRightViewWidth, kImageSize);
        [baseRightView addSubview:scanRightView];
        scanRightView.tag = kImageTag + 2;
        UITapGestureRecognizer* scanTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [scanRightView addGestureRecognizer:scanTap];
        
        self.textfield.rightView = baseRightView;
        self.textfield.rightViewMode = UITextFieldViewModeAlways;
    } else {
        self.textfield.rightView = nil;
    }
}

#pragma mark - tap
- (void)tapAction:(UITapGestureRecognizer*)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickRightAction:)]) {
        [_delegate clickRightAction:tap.view.tag - kImageTag];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.customBorderType = UIViewCustomBorderTypeBottom | UIViewCustomBorderTypeTop;
}

@end
