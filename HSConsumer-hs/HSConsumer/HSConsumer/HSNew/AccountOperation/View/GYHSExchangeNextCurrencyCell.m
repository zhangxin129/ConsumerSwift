//
//  GYHSExchangeNextCurrencyCell.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSExchangeNextCurrencyCell.h"
#import "GYHSTools.h"

@implementation GYHSExchangeNextCurrencyCell

- (void)awakeFromNib {
    // Initialization code
    [self.currencyAccountPayLb setTextColor:kCellTitleBlack];
    [self.currencyBalanceLb setTextColor:kcurrencyBalanceCorlor];
    
    self.currencyAccountPayLb.font = kExchangeHSBTwoCellFont;
    self.currencyBalanceLb.font = kExchangeHSBTwoCellFont;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
