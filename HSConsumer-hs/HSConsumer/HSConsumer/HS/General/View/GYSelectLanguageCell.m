//
//  GYSelectLanguageCell.m
//  HSConsumer
//
//  Created by kuser on 16/3/7.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSelectLanguageCell.h"

@implementation GYSelectLanguageCell

- (void)awakeFromNib
{
    // Initialization code

    _titleLabel.textColor = kCellItemTitleColor;
    _titleLabel.font = [UIFont systemFontOfSize:17];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
