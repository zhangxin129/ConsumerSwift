//
//  GYHSDownPayCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSDownPayCell.h"

#define kImageSize kDeviceProportion(90)
#define kLabelHeight kDeviceProportion(20)
#define kDistance kDeviceProportion(25)

@interface GYHSDownPayCell ()
@property (nonatomic, weak) UIImageView* imageView;
@property (nonatomic, weak) UILabel* label;

@end
@implementation GYHSDownPayCell
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
    UIImageView* imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    self.imageView = imageView;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-kImageSize / 4);
        make.size.mas_equalTo(CGSizeMake(kImageSize, kImageSize));
    }];
    
    UILabel* label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:20.0f];
    [self addSubview:label];
    self.label = label;
    [self.label mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(kDistance / 2 + kLabelHeight / 2 + kImageSize / 4);
        make.height.mas_equalTo(kLabelHeight);
    }];
}

#pragma mark - setter
- (void)setImageName:(NSString*)imageName
{
    if (_imageName != imageName) {
        _imageName = imageName;
        self.imageView.image = [UIImage imageNamed:imageName];
    }
}

- (void)setTitleName:(NSString*)titleName
{
    if (_titleName != titleName) {
        _titleName = titleName;
        self.label.text = titleName;
    }
}
@end
