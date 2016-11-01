//
//  GYHSServerTimeCell.m
//  HSConsumer
//
//  Created by zhengcx on 16/9/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSServerTimeCell.h"
#import "GYHSServerDetailAllModel.h"
#import "GYHSTools.h"

@implementation GYHSServerTimeCell

- (void)awakeFromNib
{
    // Initialization code
    self.distanceLeftConstraint.constant = (kScreenWidth - 54 * 2 - 48) * 0.33;
    self.distanceRightConstraint.constant = (kScreenWidth - 54 * 2 - 48) * 0.33;
    self.backGroundBlueBtn.backgroundColor = kBtnBlue;
    self.lineView.backgroundColor = kCorlorFromHexcode(0xffffff);
    self.lineView.alpha = 0.8;
    self.topFirstLabel.font = [UIFont systemFontOfSize:12];
    self.topFirstLabel.textColor = kCorlorFromHexcode(0xffffff);
    self.topSecondLabel.font = [UIFont systemFontOfSize:12];
    self.topSecondLabel.textColor = kCorlorFromHexcode(0xffffff);
    self.topThirdLabel.font = [UIFont systemFontOfSize:12];
    self.topThirdLabel.textColor = kCorlorFromHexcode(0xffffff);
    self.topForthLabel.font = [UIFont systemFontOfSize:12];
    self.topForthLabel.textColor = kCorlorFromHexcode(0xffffff);

    self.bottomFirstLabel.font = [UIFont systemFontOfSize:11];
    self.bottomFirstLabel.textColor = kCorlorFromHexcode(0x1d7dd6);
    self.bottomSecondLabel.font = [UIFont systemFontOfSize:11];
    self.bottomSecondLabel.textColor = kCorlorFromHexcode(0x1d7dd6);
    self.bottomThirdLabel.font = [UIFont systemFontOfSize:11];
    self.bottomThirdLabel.textColor = kCorlorFromHexcode(0x1d7dd6);
    self.bottomForthLabel.font = [UIFont systemFontOfSize:11];
    self.bottomForthLabel.textColor = kCorlorFromHexcode(0x1d7dd6);
    //更具状态判断显示按钮
    [self hiddenLabel];
}

- (void)hiddenLabel
{
    self.topFirstLabel.hidden = NO;
    self.topSecondLabel.hidden = YES;
    self.topThirdLabel.hidden = YES;
    self.topForthLabel.hidden = NO;
    self.bottomFirstLabel.hidden = NO;
    self.bottomSecondLabel.hidden = NO;
    self.bottomThirdLabel.hidden = NO;
    self.bottomForthLabel.hidden = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(GYHSServerDetailAllModel*)model
{
    _model = model;
    self.topFirstLabel.text = @"已收到";
    self.topForthLabel.text = [NSString stringWithFormat:@"您已在%@确认收货", model.confirmTime];

    self.bottomFirstLabel.text = [NSString stringWithFormat:@"已支付%@", model.payTime];
    self.bottomSecondLabel.text = [NSString stringWithFormat:@"已发货%@", model.arriveTime];
    self.bottomThirdLabel.text = [NSString stringWithFormat:@"已收货%@", model.arriveTime];
    self.bottomForthLabel.text = [NSString stringWithFormat:@"已收货%@", model.confirmTime];
}

@end
