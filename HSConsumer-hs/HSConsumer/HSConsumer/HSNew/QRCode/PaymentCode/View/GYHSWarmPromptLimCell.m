//
//  GYHSWarmPromptLimCell.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSWarmPromptLimCell.h"
#import "GYHSTools.h"

@implementation GYHSWarmPromptLimCell

- (void)awakeFromNib {
    // Initialization code
    [self.titleLb setTextColor:kcurrencyBalanceCorlor];
    [self.valueLb setTextColor:kcurrencyBalanceCorlor];
    self.titleLb.font = [UIFont systemFontOfSize:12];
    self.valueLb.font = [UIFont systemFontOfSize:12];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
