//
//  GYTakeOutOrderOperateCell.m
//  GYRestaurant
//
//  Created by ios007 on 15/10/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYTakeOutOrderOperateCell.h"
#import "GYOrderTakeOutModel.h"

@implementation GYTakeOutOrderOperateCell

-(void)layoutSubviews{
    [super layoutSubviews];
//    [self addBottomBorder];
//    [self setBottomBorderInset:YES];
    self.customBorderType = UIViewCustomBorderTypeBottom;
}

- (void)updateConstraints
{
    [super updateConstraints];
         [self.contentView removeConstraints:[self.contentView constraints]];
    
    float OrdIdLabelW = 180;
    float useIdlabelW = 130;
    float ordStartTimeLabelW = 150;
    float arriveTimeLableW = 150;
    float payCountLabelW = 130;
    float confirmBtnW = 45;
     float refuseBtnW = 45;
    
    float x = (kScreenWidth- OrdIdLabelW -useIdlabelW - ordStartTimeLabelW - arriveTimeLableW -payCountLabelW- confirmBtnW -refuseBtnW)/6;
    
    
    [self.ordIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(OrdIdLabelW));
        
    }];
    
    self.ordIdLabel.adjustsFontSizeToFitWidth= YES;
    [self.useIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8 + x + OrdIdLabelW );
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(useIdlabelW));
        
    }];
    self.useIdLabel.adjustsFontSizeToFitWidth= YES;
    [self.orderStartTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8 + 2 * x + OrdIdLabelW + useIdlabelW + 10);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(ordStartTimeLabelW));
        
    }];
    self.orderStartTimeLabel.adjustsFontSizeToFitWidth = YES;
  
    [self.arriveTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( 3 * x + OrdIdLabelW + useIdlabelW + ordStartTimeLabelW +20);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(arriveTimeLableW));
        
    }];
    self.arriveTimeLable.adjustsFontSizeToFitWidth = YES;
    
    
    [self.coinImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(4 * x + OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + arriveTimeLableW );
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@20);
        make.width.equalTo(@(20));
        
    }];
    [self.payCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(4 * x+OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + arriveTimeLableW +20);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(payCountLabelW));
        
    }];
    self.payCountLabel.adjustsFontSizeToFitWidth = YES;
    [self.acceptButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(confirmBtnW));
        make.left.equalTo(self.mas_left).offset(5 * x + OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + arriveTimeLableW + payCountLabelW  );
        
    }];
    [self.vCenterLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(2));
        make.left.equalTo(self.mas_left).offset(5 * x + OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + arriveTimeLableW + payCountLabelW + confirmBtnW + 5 );
        
    }];
    
    [self.refuseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(refuseBtnW));
        make.left.equalTo(self.mas_left).offset(5 * x + OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + arriveTimeLableW + payCountLabelW + confirmBtnW + 10 );
        
    }];
}


- (IBAction)btn:(GYOrderTakeOutModel *)model {
    if ([self.delegate respondsToSelector:@selector(operateBtn:withTableViewType:button:)]) {
        [self.delegate operateBtn:self.model withTableViewType:self.tableViewType button:self.acceptButton];
    }


}

- (IBAction)refuseBtn:(GYOrderTakeOutModel *)model {
    if ([self.delegate respondsToSelector:@selector(refuseBtn:withTableViewType:button:)]) {
        [self.delegate refuseBtn:self.model withTableViewType:self.tableViewType button:self.refuseButton];
    }


}

-(void)setModel:(GYOrderTakeOutModel *)model
{
    if (_model != model) {
        _model = model;
        
        _ordIdLabel.text = model.orderId;
        _useIdLabel.text = model.resNo;
        _orderStartTimeLabel.text = model.orderStartDatetime;
    //    _payStatusLabel.text = model.payStatus;
        _arriveTimeLable.text = model.planTime;
        _payCountLabel.text =model.orderPayCount;
    }
}


@end
