//
//  GYHESCDistributionWayTableViewCell.m
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/3/31.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHESCDistributionWayTableViewCell.h"

@implementation GYHESCDistributionWayTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.distributionWayLabel.font = [UIFont systemFontOfSize:17];
    self.distributionWayLabel.textColor = kCorlorFromHexcode(0x464646);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshDataWithModel:(GYHESCDistributionTypeModel*)model fee:(NSString*)feeString
{
    self.distributionWayLabel.text = model.desc;
    if ([model.type isEqualToString:@"1"]) {
        model.moneyString = [NSString stringWithFormat:@"%.2f", [feeString doubleValue]];
        model.coinIconWidth = 21.0f;
        model.isIconShow = NO;
        model.isMoneyShow = NO;
    }
    else {
        model.moneyString = @"0.00";
        model.coinIconWidth = 0;
        model.isIconShow = YES;
        model.isMoneyShow = YES;
    }
    self.moneyLabel.text = model.moneyString;
    self.coinImageView.hidden = model.isIconShow;
    self.moneyLabel.hidden = model.isMoneyShow;
}

@end
