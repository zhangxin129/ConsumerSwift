//
//  GYHSExchangeNextHeaderCell.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSExchangeNextHeaderCell.h"
#import "GYHSTools.h"

@implementation GYHSExchangeNextHeaderCell

- (void)awakeFromNib {
    // Initialization code
    [self.orderNumberLb setTextColor:kCellTitleBlack];
    [self.payAmountLb setTextColor:kSelectedRed];
    [self.submittedSuccessLb setTextColor:kCellTitleBlack];
    [self.exchangeHSBLb setTextColor:kCellTitleBlack];
    self.intervalView.backgroundColor = kDefaultVCBackgroundColor;
    self.lineView.backgroundColor = kCellLineGary;
    
    self.submittedSuccessLb.font = kExchangeHSBOneCellFont;
    self.orderNumberLb.font = kExchangeHSBOneCellFont;
    self.payAmountLb.font = kExchangeHSBOneCellFont;
    self.exchangeHSBLb.font = kExchangeHSBOneCellFont;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
