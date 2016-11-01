//
//  GYHSMakeUpCardInfoTableViewCell.m
//  HSConsumer
//
//  Created by admin on 16/9/18.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSMakeUpCardInfoTableViewCell.h"

@implementation GYHSMakeUpCardInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.orderStateLabel.text = kLocalized(@"订单提交成功，请您尽快付款！");
    self.orderNumTagLabel.text = kLocalized(@"订单号:");
    self.orderNumLabel.text = kLocalized(@"支付金额:");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
