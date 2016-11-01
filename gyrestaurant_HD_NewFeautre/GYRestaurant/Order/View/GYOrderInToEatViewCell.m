//
//  GYOrderInToEatViewCell.m
//  GYRestaurant
//
//  Created by apple on 15/12/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOrderInToEatViewCell.h"
#import "GYOrderListModel.h"

@implementation GYOrderInToEatViewCell
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
    float startBtnW = 50;
    float cancelBtnW = 90;
    float x = (kScreenWidth- OrdIdLabelW -useIdlabelW - ordStartTimeLabelW - arriveTimeLableW -payCountLabelW- startBtnW - cancelBtnW )/7;
    
    
    [self.orderIdLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(OrdIdLabelW));
        
    }];
    self.orderIdLable.adjustsFontSizeToFitWidth= YES;
    
    [self.resNoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18 + x + OrdIdLabelW);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(useIdlabelW));
        
    }];
    self.resNoLable.adjustsFontSizeToFitWidth= YES;
    
    [self.takeTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18 + 2 * x + OrdIdLabelW + useIdlabelW + 10 );
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(ordStartTimeLabelW));
        
    }];
    self.takeTimeLable.adjustsFontSizeToFitWidth= YES;
    
    [self.bookTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18 + 3 *x+OrdIdLabelW + useIdlabelW + ordStartTimeLabelW );
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(arriveTimeLableW));
        
    }];
    self.bookTimeLable.adjustsFontSizeToFitWidth = YES;
    
    
    [self.coinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18 + 4 * x + OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + arriveTimeLableW + 20);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
        
    }];
    [self.accountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18 + 4 * x+OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + arriveTimeLableW + 20 +20);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(payCountLabelW));
        
    }];
    self.accountLable.adjustsFontSizeToFitWidth = YES;
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(startBtnW));
        make.left.equalTo(self.mas_left).offset(18 + 5 * x + OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + arriveTimeLableW + payCountLabelW );
        
    }];
   
    [self.LineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@2);
        make.left.equalTo(self.mas_left).offset(18 + 5 * x + OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + arriveTimeLableW + payCountLabelW + startBtnW + 5);
        
    }];

    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(cancelBtnW));
        make.left.equalTo(self.mas_left).offset(18 + 5 * x + OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + arriveTimeLableW + payCountLabelW + startBtnW + 12);
        
    }];

    
}


- (IBAction)startBtnAction:(GYOrderListModel *)model {
    
    if ([self.delegate respondsToSelector:@selector(startBtn:button:)]) {
        [self.delegate startBtn:self.model button:self.startBtn];
    }
}
- (IBAction)cancelBtnAction:(GYOrderListModel *)model {
    
    if ([self.delegate respondsToSelector:@selector(cancelBtn:button:)]) {
        [self.delegate cancelBtn:self.model button:self.cancelBtn];
    }
    
}

-(void)setModel:(GYOrderListModel *)model
{
    if (_model != model) {
        _model = model;
        
        _orderIdLable.text = model.orderId;
        _resNoLable.text = model.resNo;
        _takeTimeLable.text = model.orderStartDatetime;
        _bookTimeLable.text = model.planTime;
        _accountLable.text =model.orderPayCount;
    }
}


@end
