//
//  GYSecurityFailureTableViewCell.m
//  HSConsumer
//
//  Created by xiaoxh on 16/7/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSecurityFailureTableViewCell.h"
#import "GYHSTools.h"

@implementation GYSecurityFailureTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.guaranteeConditionLb.font = kHeaderViewFont;
    self.allFailureDateListlb.font = kButtonCellFont;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
