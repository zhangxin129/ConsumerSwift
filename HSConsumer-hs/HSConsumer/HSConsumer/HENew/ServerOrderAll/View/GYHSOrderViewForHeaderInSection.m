//
//  GYHSOrderViewForHeaderInSection.m
//  HSConsumer
//
//  Created by kuser on 16/9/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSOrderViewForHeaderInSection.h"
#import "GYHSServerOrderAllModel.h"

@implementation GYHSOrderViewForHeaderInSection

- (void)awakeFromNib
{
    self.backColorView.backgroundColor = kCorlorFromHexcode(0xf6f6f6);
    self.shopNameLabel.textColor = kCorlorFromHexcode(0x333333);
    self.shopNameLabel.font = [UIFont systemFontOfSize:13];
    self.statusLabel.textColor = kCorlorFromHexcode(0xff5000);
    self.statusLabel.font = [UIFont systemFontOfSize:12];
}

- (IBAction)titleClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedDetailsBtn:)]) {
        [self.delegate didSelectedDetailsBtn:self];
    }
}

- (void)setModel:(GYHSServerOrderCellSectionModel*)model
{
    _model = model;
    [self.shopUrlIcon setImageWithURL:[NSURL URLWithString:model.shopUrl] placeholder:[UIImage imageNamed:@"gy_he_example_icon"]];
    self.shopNameLabel.text = model.shopName;
    if ([model.status isEqualToString:@"0"]) { //返回状态，判断按钮显示文字
        self.statusLabel.text = @"未付款";
    }
    else if ([model.status isEqualToString:@"1"]) {
        self.statusLabel.text = @"交易完成";
    }
    else if ([model.status isEqualToString:@"2"]) {
        self.statusLabel.text = @"已付款";
    }
    else if ([model.status isEqualToString:@"3"]) {
        self.statusLabel.text = @"已服务";
    }
}

@end
