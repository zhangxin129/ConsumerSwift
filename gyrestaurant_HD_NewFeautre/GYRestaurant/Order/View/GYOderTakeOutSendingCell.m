//
//  GYOderTakeOutSendingCell.m
//  GYRestaurant
//
//  Created by ios007 on 15/10/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOderTakeOutSendingCell.h"
#import "GYOrderTakeOutModel.h"

@implementation GYOderTakeOutSendingCell

-(void)layoutSubviews{
    [super layoutSubviews];
//    [self addBottomBorder];
//    [self setBottomBorderInset:YES];
    self.customBorderType = UIViewCustomBorderTypeBottom;
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    float OrdIdLabelW = 180;
    float useIdlabelW = 130;
    float ordStartTimeLabelW = 110;
 //   float ordStatusLabelW = 80;
    float payCountLabelW = 130;
    float deliverLabelW = 100;
    float ordArriveTimeLabelW = 110;
    float confirmBtnW = 90;
    
    
    float x = (kScreenWidth- OrdIdLabelW -useIdlabelW - ordStartTimeLabelW - payCountLabelW- confirmBtnW - deliverLabelW - ordArriveTimeLabelW)/7;
    
    
    [self.ordIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(OrdIdLabelW));
        
    }];
    
    self.ordIdLabel.adjustsFontSizeToFitWidth= YES;
    [self.useIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10 + x + OrdIdLabelW - 10);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(useIdlabelW));
        
    }];
    self.useIdLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.ordStartTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( 2 * x + OrdIdLabelW + useIdlabelW - 5);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(ordStartTimeLabelW));
        
    }];
    self.ordStartTimeLabel.adjustsFontSizeToFitWidth= YES;
//    [self.payStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset( 3 * x + OrdIdLabelW + useIdlabelW + ordStartTimeLabelW );
//        make.top.equalTo(self.mas_top).offset(11);
//        make.height.equalTo(@21);
//        make.width.equalTo(@(ordStatusLabelW));
//        
//    }];
    
    
    
    [self.coinImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(3 * x + OrdIdLabelW + useIdlabelW + ordStartTimeLabelW );
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@20);
        make.width.equalTo(@(20));
        
    }];
    [self.payCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(3 * x+OrdIdLabelW + useIdlabelW + ordStartTimeLabelW  +20);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(payCountLabelW));
        
    }];
    self.payCountLabel.adjustsFontSizeToFitWidth = YES;
    [self.postManLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(4 * x+OrdIdLabelW + useIdlabelW + ordStartTimeLabelW  + payCountLabelW - 15);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(deliverLabelW));
        
    }];
   // self.postManLabel.adjustsFontSizeToFitWidth = YES;
    [self.postDateTimeRangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5 * x+OrdIdLabelW + useIdlabelW + ordStartTimeLabelW  + payCountLabelW + deliverLabelW - 5 );
        make.top.equalTo(self.mas_top).offset(0);
        make.height.equalTo(@21);
        make.width.equalTo(@(ordArriveTimeLabelW));
        
    }];
    self.postDateTimeRangeLabel.adjustsFontSizeToFitWidth = YES;
    [self.oparateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(8);
        make.height.equalTo(@21);
        make.width.equalTo(@(confirmBtnW));
        make.left.equalTo(self.mas_left).offset(10 + 6 *x + OrdIdLabelW + useIdlabelW + ordStartTimeLabelW  + payCountLabelW + ordArriveTimeLabelW + deliverLabelW - 15);
        
    }];
}



- (IBAction)payBtnAction:(GYOrderTakeOutModel *)model {
    if ([self.paydelegate respondsToSelector:@selector(payBtn:withTableViewType:button:)]) {
        [self.paydelegate payBtn:self.model withTableViewType:self.tableViewType button:self.oparateBtn];
    }

}

@end
