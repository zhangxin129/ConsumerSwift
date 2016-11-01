//
//  GYHDTitleBottomButton.m
//  HSConsumer
//
//  Created by shiang on 16/3/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDTitleBottomButton.h"
#import "GYHDMessageCenter.h"

@implementation GYHDTitleBottomButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self setTitleColor:[UIColor colorWithRed:102 / 255.0f green:102 / 255.0f blue:102 / 255.0f alpha:1] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    self.titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(22)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, 50, 50);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 50, 50, 20);
}

@end
