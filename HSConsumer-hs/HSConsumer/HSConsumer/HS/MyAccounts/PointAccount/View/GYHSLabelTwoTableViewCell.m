//
//  GYHSLabelTwoTableViewCell.m
//  GYHSConsumer_MyHS
//
//  Created by ios007 on 16/3/21.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSLabelTwoTableViewCell.h"
#import "GYHSTools.h"

@implementation GYHSLabelTwoTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.detLabel.textColor = kcurrencyBalanceCorlor;
    self.titleLabel.textColor = kcurrencyBalanceCorlor;
    
    self.detLabel.font = kPointInvestmentCellFont;
    self.titleLabel.font = kPointInvestmentCellFont;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
