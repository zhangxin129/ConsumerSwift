//
//  GYOrderOperateCell.m
//  GYRestaurant
//
//  Created by ios007 on 15/10/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOrderOperateCell.h"
#import "GYOrderTakeOutModel.h"
@interface GYOrderOperateCell()



@end
@implementation GYOrderOperateCell

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
    float ordStartTimeLabelW = 110;
    float arriveTimeLableW = 110;
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
        make.left.equalTo(self.mas_left).offset( x + OrdIdLabelW);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(useIdlabelW));
        
    }];
    self.useIdlabel.adjustsFontSizeToFitWidth= YES;
    [self.ordStartTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(2 * x + OrdIdLabelW + useIdlabelW + 20);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(ordStartTimeLabelW));
        
    }];
    self.ordStartTimeLabel.adjustsFontSizeToFitWidth= YES;
   [self.arriveTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( 3 *x+OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + 30);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(arriveTimeLableW));
        
    }];
    self.arriveTimeLable.adjustsFontSizeToFitWidth = YES;
  
    
    [self.coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18 + 4 * x + OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + arriveTimeLableW + 35);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@20);
        make.width.equalTo(@(20));
        
    }];
    [self.payCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18 + 4 * x+OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + arriveTimeLableW + 55);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(payCountLabelW));
        
    }];
    self.payCountLabel.adjustsFontSizeToFitWidth = YES;
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(confirmBtnW));
        make.left.equalTo(self.mas_left).offset(13 + 5 * x + OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + arriveTimeLableW + payCountLabelW + 10);
        
    }];
    
    



}
- (IBAction)operateBtn:(GYOrderTakeOutModel *)model {
    
    if ([self.celldelegate respondsToSelector:@selector(postBtn:withTableViewType:button:)]) {
        [self.celldelegate postBtn:self.model withTableViewType:self.tableViewType button:self.confirmBtn];
    }

    
}

-(void)setModel:(GYOrderTakeOutModel *)model
{
    if (_model != model) {
        _model = model;
        
        _ordIdLabel.text = model.orderId;
        _useIdlabel.text = model.resNo;
        _ordStartTimeLabel.text = model.orderStartDatetime;
        if([_model.orderStatus isEqualToString:kLocalized(@"PendingDelivery")]){
            _arriveTimeLable.text = model.planTime;
        }else if([_model.orderStatus isEqualToString:kLocalized(@"CancelUnconfirmed")]){
            _arriveTimeLable.text = model.cancelApplyTime;
        }
        
        _payCountLabel.text =model.orderPayCount;
    }
}



@end
