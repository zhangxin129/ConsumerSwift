//
//  FDMainDropServiceTableViewCell.m
//  HSConsumer
//
//  Created by zhangqy on 15/11/20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "FDMainDropServiceTableViewCell.h"

@implementation FDMainDropServiceTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setChoosed:(BOOL)choosed
{
    if (choosed) {
        _choosedImageView.image = [UIImage imageNamed:@"gyhe_check_mark_red"];
        _nameLabel.textColor = kNavigationBarColor;
    }
    else {
        _choosedImageView.image = [UIImage imageNamed:@""];
        _nameLabel.textColor = [UIColor darkGrayColor];
    }
}

@end
