//
//  GYHSOtherPayStyleCell.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSOtherPayStyleCell.h"
#import "GYHSTools.h"

@implementation GYHSOtherPayStyleCell

- (void)awakeFromNib {
    // Initialization code
    self.otherPayStyleLb.font = kOtherPayCellFont;
    self.accreditationCardPayBtn.titleLabel.font = kOtherPayCellFont;
    
    [self.otherPayStyleLb setTextColor:kcurrencyBalanceCorlor];
    [self.accreditationCardPayBtn setTintColor:kotherPayBtnCorlor];
    self.backgroundColor = kDefaultVCBackgroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
