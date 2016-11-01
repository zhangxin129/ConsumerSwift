//
//  GYHSTableViewWarmCell.m
//  GYHSConsumer_MyHS
//
//  Created by ios007 on 16/3/21.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSTableViewWarmCell.h"
#import "GYHSConstant.h"
@implementation GYHSTableViewWarmCell

- (void)awakeFromNib
{
    self.label.textColor = kCellItemTitleColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
