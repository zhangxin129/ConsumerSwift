//
//  GYHSImageTitleNumberCell.m
//  GYHSConsumer_MyHS
//
//  Created by ios007 on 16/3/21.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSImageTitleNumberCell.h"
#import "GYHSConstant.h"
@implementation GYHSImageTitleNumberCell

- (void)awakeFromNib
{
    self.titleLabel.textColor = kCellItemTitleColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
