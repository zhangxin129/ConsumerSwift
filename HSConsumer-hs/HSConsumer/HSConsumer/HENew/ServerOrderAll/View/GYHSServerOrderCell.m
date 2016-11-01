//
//  GYHSServerOrderCell.m
//  HSConsumer
//
//  Created by kuser on 16/9/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSServerOrderCell.h"
#import "UIButton+GYExtension.h"
#import "GYHSServerOrderAllModel.h"

@implementation GYHSServerOrderCell

- (void)awakeFromNib
{
    // Initialization code
    //确认服务按钮
    [_confirmBtn setBackgroundColor:kClearColor];
    [_confirmBtn setTitleColor:kCorlorFromHexcode(0x1d7dd6) forState:UIControlStateNormal];
    [_confirmBtn setBorderWithWidth:1.0 andRadius:2.0 andColor:kCorlorFromHexcode(0x1d7dd6)];
    self.confirmBtn.layer.cornerRadius = 5;
    self.confirmBtn.layer.masksToBounds = YES;
    //退款，取消，再订按钮
    [_otherBtn setBackgroundColor:kClearColor];
    [_otherBtn setTitleColor:kCorlorFromHexcode(0x1d7dd6) forState:UIControlStateNormal];
    [_otherBtn setBorderWithWidth:1.0 andRadius:2.0 andColor:kCorlorFromHexcode(0x1d7dd6)];
    self.otherBtn.layer.cornerRadius = 5;
    self.otherBtn.layer.masksToBounds = YES;
    self.confirmBtn.hidden = YES;
    self.otherBtn.hidden = YES;
    self.orderIdLabel.textColor = kCorlorFromHexcode(0x999999);
    self.orderIdLabel.font = [UIFont systemFontOfSize:11];
    self.titleLabel.textColor = kCorlorFromHexcode(0x3f3000);
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.detailTimeLabel.textColor = kCorlorFromHexcode(0x999999);
    self.detailTimeLabel.font = [UIFont systemFontOfSize:11];
    self.timeLabel.textColor = kCorlorFromHexcode(0x999999);
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.priceLabel.textColor = kCorlorFromHexcode(0xff5000);
    self.priceLabel.font = [UIFont systemFontOfSize:14];
    self.pvLabel.textColor = kCorlorFromHexcode(0x1d7dd6);
    self.pvLabel.font = [UIFont systemFontOfSize:14];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(GYHSServerOrderCellModel*)model
{
    _model = model;
    if ([model.type isEqualToString:@"0"]) { //零售状态
        [self.urlIcon setImageWithURL:[NSURL URLWithString:model.url] placeholder:[UIImage imageNamed:@"gy_he_examples_icon"]];
        self.timeLabel.text = [NSString stringWithFormat:@"订单号:%@", model.orderDetailId];
        self.orderIdLabel.text = model.time;
        self.detailTimeLabel.text = model.detailTime;
        self.timeLabelDistanceTopConstraint.constant = 5 + 21;
        self.orderIDDistanceRightConstraint.constant = 90;
        if ([model.statu isEqualToString:@"0"]) { //返回状态，判断按钮显示文字
            self.confirmBtn.hidden = NO;
            self.otherBtn.hidden = YES;
            [self.confirmBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        }
        else if ([model.statu isEqualToString:@"1"]) {
            [self.otherBtn setTitle:@"再订" forState:UIControlStateNormal];
            self.confirmBtn.hidden = YES;
            self.otherBtn.hidden = NO;
        }
        else if ([model.statu isEqualToString:@"2"]) {
            [self.otherBtn setTitle:@"取消" forState:UIControlStateNormal];
            self.confirmBtn.hidden = YES;
            self.otherBtn.hidden = NO;
        }
        else if ([model.statu isEqualToString:@"3"]) {
            [self.otherBtn setTitle:@"退款" forState:UIControlStateNormal];
            self.confirmBtn.hidden = YES;
            self.otherBtn.hidden = NO;
        }
    }
    else if ([model.type isEqualToString:@"1"]) { //服务状态
        [self.urlIcon setImageWithURL:[NSURL URLWithString:model.url] placeholder:[UIImage imageNamed:@"gy_he_example_icon"]];
        self.timeLabel.text = [NSString stringWithFormat:@"预约/预约时间:%@", model.time];
        self.orderIdLabel.text = [NSString stringWithFormat:@"订单号:%@", model.orderDetailId];
        self.detailTimeLabel.text = model.detailTime;
        self.timeLabelDistanceTopConstraint.constant = 5;
        self.orderIDDistanceRightConstraint.constant = 15;
        if ([model.statu isEqualToString:@"0"]) { //返回状态，判断按钮显示文字
            self.confirmBtn.hidden = NO;
            self.otherBtn.hidden = YES;
            [self.confirmBtn setTitle:@"确认服务" forState:UIControlStateNormal];
        }
        else if ([model.statu isEqualToString:@"1"]) {
            [self.otherBtn setTitle:@"再订" forState:UIControlStateNormal];
            self.confirmBtn.hidden = YES;
            self.otherBtn.hidden = NO;
        }
        else if ([model.statu isEqualToString:@"2"]) {
            [self.otherBtn setTitle:@"取消" forState:UIControlStateNormal];
            self.confirmBtn.hidden = YES;
            self.otherBtn.hidden = NO;
        }
        else if ([model.statu isEqualToString:@"3"]) {
            [self.otherBtn setTitle:@"退款" forState:UIControlStateNormal];
            self.confirmBtn.hidden = YES;
            self.otherBtn.hidden = NO;
        }
    }
    //零售，服务共用部分
    self.titleLabel.text = model.title;
    self.priceLabel.text = [GYUtils formatCurrencyStyle:[model.price doubleValue]];
    self.pvLabel.text = [GYUtils formatCurrencyStyle:[model.pv doubleValue]];
}

@end
