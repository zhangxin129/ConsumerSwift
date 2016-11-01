//
//  GYHSTakeAwayAddressCell.m
//  HSConsumer
//
//  Created by kuser on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSTakeAwayAddressCell.h"
#import "GYHSTakeAwayDetailAllModel.h"

@implementation GYHSTakeAwayAddressCell

- (void)awakeFromNib
{
    // Initialization code

    self.receiverLabel.font = [UIFont systemFontOfSize:13];
    self.receiverAddressLabel.textColor = kCorlorFromHexcode(0x333333);
    self.receiverContactLabel.font = [UIFont systemFontOfSize:13];
    self.receiverContactLabel.textColor = kCorlorFromHexcode(0x333333);
    self.receiverAddressLabel.font = [UIFont systemFontOfSize:13];
    self.receiverAddressLabel.textColor = kCorlorFromHexcode(0x333333);
    self.receiveTimeLabel.font = [UIFont systemFontOfSize:13];
    self.receiveTimeLabel.textColor = kCorlorFromHexcode(0x333333);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(GYHSTakeAwayDetailAllModel*)model
{
    _model = model;
    self.receiverLabel.text = [NSString stringWithFormat:@"联系人:%@", model.receiver];
    self.receiverContactLabel.text = model.receiverContact;
    self.receiverAddressLabel.text = model.receiverAddress;
    self.receiveTimeLabel.text = [NSString stringWithFormat:@"期望送达时间%@", model.receiveTime];
}

@end
