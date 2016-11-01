//
//  GYHSMainLeftBottomCommonView.m
//  HSCompanyPad
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMainLeftBottomCommonView.h"
#import <YYKit/UIControl+YYAdd.h>

@interface GYHSMainLeftBottomCommonView ()

@property (nonatomic, strong) UILabel* contenLabel;
@property (nonatomic, strong) UIButton* lookButton;

@end

@implementation GYHSMainLeftBottomCommonView

#pragma mark - life cycle
- (instancetype)initWithImage:(UIImage*)image title:(NSString*)title
{
    self = [super init];
    if (self) {
        [self setUpWithImage:(UIImage*)image title:(NSString*)title];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.isEmailAuthenticate) {
        self.lookButton.imageEdgeInsets = UIEdgeInsetsMake(0, self.lookButton.bounds.size.width - kDeviceProportion(13), 0, 0);
        self.lookButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kDeviceProportion(31));
    }
    else {
        self.lookButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kDeviceProportion(9));
    }
    self.customBorderLineWidth = @1;
    self.customBorderType = UIViewCustomBorderTypeBottom;
    self.customBorderColor = kGrayE3E3EA;
}

#pragma mark - event respose
- (void)lookButtonAction
{
    DDLogInfo(@"点击查看了");
    if (self.buttonBlock) {
        self.buttonBlock();
    }
}

#pragma mark - pravate method

- (void)setText:(NSAttributedString*)text
{
    _text = text;
    _contenLabel.attributedText = text;
}

- (void)setButtonTitle:(NSString*)buttonTitle
{
    _buttonTitle = buttonTitle;
    [_lookButton setTitle:buttonTitle forState:UIControlStateNormal];
}

- (void)setIsEmailAuthenticate:(BOOL)isEmailAuthenticate
{
    _isEmailAuthenticate = isEmailAuthenticate;
    if (isEmailAuthenticate) {
        [_lookButton setTitleColor:kBlue0A59C2 forState:UIControlStateNormal];
        [_lookButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_lookButton setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        [_lookButton removeAllTargets];
    }
    else {
        [_lookButton setTitleColor:kBlue0A59C2 forState:UIControlStateNormal];
        [_lookButton setImage:[UIImage imageNamed:@"gyhs_grayArrow_midIcon"] forState:UIControlStateNormal];
        [_lookButton setImage:[UIImage imageNamed:@"gyhs_grayArrow_midIcon"] forState:UIControlStateHighlighted];
        [_lookButton removeAllTargets];
        [_lookButton addTarget:self action:@selector(lookButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setUpWithImage:(UIImage*)image title:(NSString*)title
{
    UIView* leftView = [[UIView alloc] init];
    leftView.backgroundColor = kColor(236, 238, 242, 1);
    [self addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(@(kDeviceProportion(170)));
    }];
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    [leftView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.width.height.equalTo(@(kDeviceProportion(24)));
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(leftView.mas_left).offset(kDeviceProportion(25));
    }];
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = kFont38;
    titleLabel.textColor = kGray666666;
    [leftView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(imageView.mas_right).offset(kDeviceProportion(5));
        make.top.right.bottom.equalTo(leftView);
    }];
    
    [self addSubview:self.lookButton];
    [self.lookButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(self).offset(kDeviceProportion(-18));
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@(kDeviceProportion(36)));
        make.width.equalTo(@(kDeviceProportion(120)));
    }];
    self.isEmailAuthenticate = NO;
    
    [self addSubview:self.contenLabel];
    [self.contenLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(leftView.mas_right).offset(kDeviceProportion(13));
        make.right.equalTo(_lookButton.mas_left).offset(kDeviceProportion(13));
        make.top.bottom.equalTo(self);
    }];
}

#pragma mark - lazy load
- (UIButton*)lookButton
{
    if (!_lookButton) {
        _lookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookButton.titleLabel.font = kFont36;
        _lookButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_lookButton addTarget:self action:@selector(lookButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookButton;
}

- (UILabel*)contenLabel
{
    if (!_contenLabel) {
        _contenLabel = [[UILabel alloc] init];
        _contenLabel.numberOfLines = 0;
    }
    return _contenLabel;
}

@end
