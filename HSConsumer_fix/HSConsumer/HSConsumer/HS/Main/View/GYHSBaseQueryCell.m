//
//  GYHSBaseQueryCell.m
//  HSConsumer
//
//  Created by liss on 16/4/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSBaseQueryCell.h"

@implementation GYHSBaseQueryCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code

    self.title.font = [UIFont systemFontOfSize:18];
    self.isSet.font = [UIFont systemFontOfSize:16];
    self.title.textColor = UIColorFromRGB(0x464646);
    self.isSet.textColor = UIColorFromRGB(0xA0A0A0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
