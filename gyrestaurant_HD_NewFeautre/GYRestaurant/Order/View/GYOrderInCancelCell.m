//
//  GYOrderInCancelCell.m
//  GYRestaurant
//
//  Created by apple on 16/1/11.
//  Copyright © 2016年 kuser. All rights reserved.
//

#import "GYOrderInCancelCell.h"
#import "GYOrderListModel.h"

@implementation GYOrderInCancelCell
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
    float confirmBtnW = 130;
    float x = (kScreenWidth- OrdIdLabelW -useIdlabelW - ordStartTimeLabelW - arriveTimeLableW -payCountLabelW- confirmBtnW )/6;
    
    
    [self.ordIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(OrdIdLabelW));
        
    }];
    self.ordIdLabel.adjustsFontSizeToFitWidth= YES;
    [self.useIdlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(13 + x + OrdIdLabelW);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(useIdlabelW));
        
    }];
    self.useIdlabel.adjustsFontSizeToFitWidth= YES;
    [self.ordStartTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(2 * x + OrdIdLabelW + useIdlabelW + 45);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(ordStartTimeLabelW));
        
    }];
    self.ordStartTimeLabel.adjustsFontSizeToFitWidth= YES;
    [self.arriveTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( 3 *x+OrdIdLabelW + useIdlabelW + ordStartTimeLabelW );
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(arriveTimeLableW));
        
    }];
    self.arriveTimeLable.adjustsFontSizeToFitWidth = YES;
    
    
    [self.coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(4 * x + OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + arriveTimeLableW + 30);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@20);
        make.width.equalTo(@(20));
        
    }];
    [self.payCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(4 * x+OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + arriveTimeLableW + 50);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(payCountLabelW));
        
    }];
    self.payCountLabel.adjustsFontSizeToFitWidth = YES;
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(confirmBtnW));
        make.left.equalTo(self.mas_left).offset(5 * x + OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + arriveTimeLableW + payCountLabelW + 10);
        
    }];
    
    
    
    
    
}

- (IBAction)oprateBtn:(GYOrderListModel *)model {
    
    if ([self.canceldelegate respondsToSelector:@selector(confirmBtn:button:)]) {
        [self.canceldelegate confirmBtn:self.model button:self.confirmBtn];
    }
}

-(void)setModel:(GYOrderListModel *)model
{
    if (_model != model) {
        _model = model;
        
        _ordIdLabel.text = model.orderId;
        _useIdlabel.text = model.resNo;
        _ordStartTimeLabel.text = model.orderStartDatetime;
        _arriveTimeLable.text = model.cancelApplyTime;
        _payCountLabel.text =model.orderPayCount;
    }
}


@end
