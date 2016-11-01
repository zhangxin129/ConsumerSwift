//
//  GYHSTakeAwayTimeCell.m
//  HSConsumer
//
//  Created by kuser on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSTakeAwayTimeCell.h"
#import "GYHSTakeAwayDetailAllModel.h"
#import "GYHSTools.h"

@implementation GYHSTakeAwayTimeCell

- (void)awakeFromNib
{
    // Initialization code
    self.backGroundBlueBtn.backgroundColor = kBtnBlue;
    self.lineView.backgroundColor = kCorlorFromHexcode(0xffffff);
    self.lineView.alpha = 0.8;
    self.trandsFinishLabel.font = [UIFont systemFontOfSize:12];
    self.trandsFinishLabel.textColor = kCorlorFromHexcode(0xffffff);
    self.receiveOrderLabel.font = [UIFont systemFontOfSize:12];
    self.receiveOrderLabel.textColor = kCorlorFromHexcode(0xffffff);
    self.confirmServerLabel.font = [UIFont systemFontOfSize:12];
    self.confirmServerLabel.textColor = kCorlorFromHexcode(0xffffff);
    self.alreadyCommitOrderLabel.font = [UIFont systemFontOfSize:11];
    self.alreadyCommitOrderLabel.textColor = kCorlorFromHexcode(0x1d7dd6);
    self.alreadyReceiveTimeLabel.font = [UIFont systemFontOfSize:11];
    self.alreadyReceiveTimeLabel.textColor = kCorlorFromHexcode(0x1d7dd6);
    self.alreadyServerLabel.font = [UIFont systemFontOfSize:11];
    self.alreadyServerLabel.textColor = kCorlorFromHexcode(0x1d7dd6);
    //更具状态判断显示按钮
    [self hiddenLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)hiddenLabel
{
    self.receiveOrderLabel.hidden = YES;
    self.alreadyCommitOrderLabel.hidden = NO;
    self.alreadyReceiveTimeLabel.hidden = NO;
}

- (void)setModel:(GYHSTakeAwayDetailAllModel*)model
{
    _model = model;
    self.trandsFinishLabel.text = [NSString stringWithFormat:@"下单%@", model.receiveTime];
    self.receiveOrderLabel.text = [NSString stringWithFormat:@"已接单%@", model.receiveTime];
    self.alreadyCommitOrderLabel.text = [NSString stringWithFormat:@"已提单%@", model.arriveTime];
    self.confirmServerLabel.text = [NSString stringWithFormat:@"%@确认服务", model.confirmTime];
}

@end
