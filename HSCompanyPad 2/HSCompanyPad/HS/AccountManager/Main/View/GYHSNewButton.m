//
//  GYHSNewButton.m
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSNewButton.h"

#define kCommonPicHW kDeviceProportion(50)
#define kButtonY (contentRect.size.height - kCommonPicHW) * 0.5

#define kTitleX (kCommonPicHW + kDeviceProportion(20))
#define kTitleHeight kDeviceProportion(25)
#define kTitleY (contentRect.size.height - kTitleHeight) * 0.5
#define kTitleWidth (contentRect.size.width - kCommonPicHW - kDeviceProportion(20))

@implementation GYHSNewButton

- (id)initWithFrame:(CGRect)frame normalWithImageName:(NSString *)normalName selectedWithImageName:(NSString *)selectName setTitleString:(NSString *)titleStr normalTitleColor:(UIColor *)colorNormal selectedTitleColor:(UIColor *)colorSelected
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 1、图片
        self.imageView.contentMode = UIViewContentModeCenter;
        [self setImage:[UIImage imageNamed:normalName]
              forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:selectName]
              forState:UIControlStateSelected];

        // 2、设置文字
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self setTitle:titleStr
              forState:UIControlStateNormal];
        [self setTitleColor:kGray333333
                   forState:UIControlStateNormal];
        [self setTitleColor:kGray333333
                   forState:UIControlStateSelected];
        self.titleLabel.font = kFont48;
    }
    return self;
}

#pragma mark - 设置按钮内部图片和文字的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, kButtonY, kCommonPicHW, kCommonPicHW);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(kTitleX - kDeviceProportion(8), kTitleY, kTitleWidth + kDeviceProportion(15), kTitleHeight);
}

@end
