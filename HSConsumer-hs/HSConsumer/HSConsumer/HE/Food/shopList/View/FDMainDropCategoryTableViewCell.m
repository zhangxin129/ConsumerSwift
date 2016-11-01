//
//  FDMainDropCategoryTableViewCell.m
//  HSConsumer
//
//  Created by zhangqy on 15/9/24.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#define scoreRed ([UIColor colorWithRed:254 / 255.0 green:71 / 255.0 blue:66 / 255.0 alpha:1])
#import "FDMainDropCategoryTableViewCell.h"
@interface FDMainDropCategoryTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView* choosedImageView;

@end
@implementation FDMainDropCategoryTableViewCell

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
        _nameLabel.textColor = scoreRed;
    }
    else {
        _choosedImageView.image = [UIImage imageNamed:@""];
        _nameLabel.textColor = [UIColor darkGrayColor];
    }
}

@end
