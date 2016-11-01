//
//  ViewCellStyle.m
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "ViewCellStyle.h"

@interface ViewCellStyle () {
    UIColor* normalColor;
}
@end

@implementation ViewCellStyle

- (void)awakeFromNib
{
    [super awakeFromNib];
    normalColor = self.backgroundColor;

    [self.lbActionName setTextColor:kCellItemTitleColor];
    self.lbActionName.font = kCellTitleFont;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //上下添加边框
    [self addTopBorder];
    [self addBottomBorder];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    self.backgroundColor = highlighted ? [UIColor lightGrayColor] : normalColor;
}

@end
