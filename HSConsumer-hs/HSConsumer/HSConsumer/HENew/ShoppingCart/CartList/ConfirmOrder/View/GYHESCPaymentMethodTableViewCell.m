//
//  GYHESCPaymentMethodTableViewCell.m
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHESCPaymentMethodTableViewCell.h"

@implementation GYHESCPaymentMethodTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.userfulBalanceLabel.font = [UIFont systemFontOfSize:14];
    self.userfulBalanceLabel.textColor = kCorlorFromHexcode(0X8C8C8C);
    self.contentLabel.font = [UIFont systemFontOfSize:17];
    self.contentLabel.textColor = kCorlorFromHexcode(0x464646);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshDataWithModel:(GYHESCPaymentMethodModel*)model
{
    if ([model.type isEqualToString:@"AC"]) {
        model.typeString = kLocalized(@"HE_SC_OrderACPayment");
        model.payType = @"3";
    }
    else if ([model.type isEqualToString:@"EP"]) {
        model.typeString = kLocalized(@"HE_SC_OrderEPPayment");
        model.payType = @"5";
    }
    else if ([model.type isEqualToString:@"CD"]) {
        model.typeString = kLocalized(@"HE_SC_OrderCDPayment");
        model.payType = @"1";
    }
    else {
        model.typeString = kLocalized(@"HE_SC_OrderQUPayment");
        model.payType = @"4";
    }
    self.contentLabel.text = model.typeString;
    if ([model.type isEqualToString:@"AC"]) {
        self.userfulBalanceLabel.hidden = NO;
        self.iconImageView.hidden = NO;
        self.moneyNumberLabel.hidden = NO;
        self.moneyNumberLabel.text = model.hsbBalance;
    }
    else {
        self.userfulBalanceLabel.hidden = YES;
        self.iconImageView.hidden = YES;
        self.moneyNumberLabel.hidden = YES;
    }
}

@end
