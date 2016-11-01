//
//  GYEasybuyCategoreTableViewCell.m
//  HSConsumer
//
//  Created by xiongyn on 16/7/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEasybuyCategoreTableViewCell.h"
@interface GYEasybuyCategoreTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel* nameLab;

@end
@implementation GYEasybuyCategoreTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(GYEasybuyColumnClassSonModel*)model
{
    _model = model;
    _nameLab.text = model.name;
    _nameLab.textColor = model.isSelected ? [UIColor redColor] : [UIColor blackColor];
}

@end
