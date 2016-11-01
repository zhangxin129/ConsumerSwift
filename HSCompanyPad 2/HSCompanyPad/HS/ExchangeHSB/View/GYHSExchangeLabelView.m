//
//  GYLabelView.m
//  HSCompanyPad
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 wangbb. All rights reserved.
//

#import "GYHSExchangeLabelView.h"

@interface GYHSExchangeLabelView ()

@property (nonatomic, strong) UILabel* secondLabel;
@property (nonatomic, strong) UILabel* firstLabel;

@end

@implementation GYHSExchangeLabelView

- (NSString*)textContent
{
    if (!_textContents) {
        _textContents = [NSString string];
    }
    _textContents = _secondLabel.text;
    return _textContents;
}

- (void)setTextContents:(NSString*)textContents
{
    _textContents = textContents;
    _secondLabel.text = textContents;
}

-(void)dealloc {
    DDLogInfo(@"消失了");
}

- (instancetype)initWithTitle:(NSString*)title
{
    self = [super init];
    if (self) {
        [self setUp:title];
    }
    return self;
}

- (void)setUp:(NSString*)title
{
    self.firstLabel.text = title;
    [self addSubview:self.firstLabel];
    [_firstLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self).offset(10);
        make.height.equalTo(@21);
        make.centerY.equalTo(self.mas_centerY);
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self addSubview:self.secondLabel];
    [_secondLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(_firstLabel.mas_right).offset(5);
        make.top.bottom.equalTo(self);
        make.width.lessThanOrEqualTo(@250);
        
    }];
}

- (UILabel*)secondLabel
{
    if (!_secondLabel) {
        _secondLabel = [[UILabel alloc] init];
        _secondLabel.textColor = kBlue0A59C2;
        _secondLabel.font = kFont32;
    }
    return _secondLabel;
}

- (UILabel*)firstLabel
{
    if (!_firstLabel) {
        _firstLabel = [[UILabel alloc] init];
        _firstLabel.textColor = kGray333333;
        _firstLabel.font = kFont32;
    }
    return _firstLabel;
}

@end
