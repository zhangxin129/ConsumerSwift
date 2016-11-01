//
//  GYHSServerAddressCell.m
//  HSConsumer
//
//  Created by zhengcx on 16/9/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSServerAddressCell.h"
#import "GYHSServerDetailAllModel.h"

@implementation GYHSServerAddressCell

- (void)awakeFromNib
{
    // Initialization code

    self.receiverLabel.font = [UIFont systemFontOfSize:13];
    self.receiverAddressLabel.textColor = kCorlorFromHexcode(0x333333);
    self.receiverContactLabel.font = [UIFont systemFontOfSize:13];
    self.receiverContactLabel.textColor = kCorlorFromHexcode(0x333333);
    self.receiverAddressLabel.font = [UIFont systemFontOfSize:13];
    self.receiverAddressLabel.textColor = kCorlorFromHexcode(0x333333);
    self.sendTimeLabel.font = [UIFont systemFontOfSize:13];
    self.sendTimeLabel.textColor = kCorlorFromHexcode(0x333333);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(GYHSServerDetailAllModel*)model
{
    _model = model;
    self.receiverLabel.text = model.receiver;
    self.receiverAddressLabel.text = model.receiverAddress;
    self.receiverContactLabel.text = model.receiverContact;
    self.sendTimeLabel.text = [NSString stringWithFormat:@"买家留言:%@", model.sendTime];
}

@end
