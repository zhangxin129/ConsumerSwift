//
//  GYOrderInAllViewCell.m
//  GYRestaurant
//
//  Created by apple on 15/12/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOrderInAllViewCell.h"

@implementation GYOrderInAllViewCell
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
   // float arriveTimeLableW = 150;
    float orderStatusW = 90;
    float payCountLabelW = 130;
   // float confirmBtnW = 50;
    float orderEndTimeW = 150;
    float x = (kScreenWidth- OrdIdLabelW -useIdlabelW - ordStartTimeLabelW - orderStatusW -payCountLabelW- orderEndTimeW )/6;
    
    
    [self.orderIdLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(OrdIdLabelW));
        
    }];
    self.orderIdLable.adjustsFontSizeToFitWidth= YES;
    
    [self.resNoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8 + x + OrdIdLabelW);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(useIdlabelW));
        
    }];
    self.resNoLable.adjustsFontSizeToFitWidth= YES;
    
    [self.orderStartLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8 + 2 * x + OrdIdLabelW + useIdlabelW );
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(ordStartTimeLabelW));
        
    }];
    self.orderStartLable.adjustsFontSizeToFitWidth= YES;
    
    [self.orderStatusLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8 + 3 * x + OrdIdLabelW + useIdlabelW + ordStartTimeLabelW);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(orderStatusW));
        
    }];
    self.orderStatusLable.adjustsFontSizeToFitWidth = YES;
    
    
    [self.coinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8 + 4 * x + OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + orderStatusW + 60);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@20);
        make.width.equalTo(@(20));
        
    }];
    [self.orderAcountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8 + 4 * x+OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + orderStatusW + 20 + 60);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(payCountLabelW));
        
    }];
    self.orderAcountLable.adjustsFontSizeToFitWidth = YES;
    
    [self.orderPaymentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(orderEndTimeW));
        make.left.equalTo(self.mas_left).offset(8 + 5 * x + OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + orderStatusW + payCountLabelW +20);
        
    }];
    self.orderPaymentLable.adjustsFontSizeToFitWidth = YES;
}


@end
