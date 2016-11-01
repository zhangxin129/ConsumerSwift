//
//  GYHDRegisterSuccessHeaderCell.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDRegisterSuccessHeaderCell.h"
#import "GYHSTools.h"

@implementation GYHDRegisterSuccessHeaderCell

- (void)awakeFromNib {
    // Initialization code
    [self.successLb setTextColor:kSuccessLbCorlor];
    self.successLb.font = kButtonCellFont;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
