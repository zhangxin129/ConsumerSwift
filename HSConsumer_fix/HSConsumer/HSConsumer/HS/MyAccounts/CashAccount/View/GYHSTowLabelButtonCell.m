//
//  GYHSTowLabelButtonCell.m
//  GYHSConsumer_MyHS
//
//  Created by liss on 16/4/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSTowLabelButtonCell.h"

@implementation GYHSTowLabelButtonCell

- (void)awakeFromNib
{
    // Initialization code
    self.titleLabel.textColor = kCellItemTitleColor;
    self.bankNumberLabel.textColor = kCellItemTitleColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
