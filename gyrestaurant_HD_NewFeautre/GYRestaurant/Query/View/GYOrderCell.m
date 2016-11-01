//
//  GYOrderCell.m
//  GYRestaurant
//
//  Created by apple on 15/10/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOrderCell.h"

@interface GYOrderCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderNumLable;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *strTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *stateLable;
@property (weak, nonatomic) IBOutlet UILabel *totalLable;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *payStateLable;
@property (weak, nonatomic) IBOutlet UILabel *classLable;
@property (weak, nonatomic) IBOutlet UIImageView *coinView;

@end

@implementation GYOrderCell

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

    float orderNumLableW = 160;
    float nameLableW = 120;
    float strTimeLableW = 130;
    float stateLableW = 99;
    float totalLableW = 88;
    float endTimeLableW = 130;
    float payStateLableW = 77;
    float classLableW = 80;


    float x = (kScreenWidth- 0.15 * kScreenWidth - orderNumLableW -nameLableW - strTimeLableW-stateLableW - totalLableW- endTimeLableW - payStateLableW - classLableW)/9;


    [self.orderNumLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5);
        make.top.equalTo(self.mas_top).offset(21);
        make.height.equalTo(@21);
        make.width.equalTo(@(orderNumLableW));

    }];
  //  self.orderNumLable.adjustsFontSizeToFitWidth = YES;
    
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( x + orderNumLableW - 5);
        make.top.equalTo(self.mas_top).offset(21);
        make.height.equalTo(@21);
        make.width.equalTo(@(nameLableW));

    }];
  //  self.nameLable.adjustsFontSizeToFitWidth = YES;
    [self.strTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(2 * x + orderNumLableW + nameLableW - 5);
        make.top.equalTo(self.mas_top).offset(21);
        make.height.equalTo(@21);
        make.width.equalTo(@(strTimeLableW));

    }];
  //  self.strTimeLable.adjustsFontSizeToFitWidth = YES;
    [self.stateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( 3 * x + orderNumLableW + nameLableW +strTimeLableW - 10);
        make.top.equalTo(self.mas_top).offset(21);
        make.height.equalTo(@21);
        make.width.equalTo(@(stateLableW));

    }];
 //   self.stateLable.adjustsFontSizeToFitWidth = YES;
    [self.coinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(4 * x + orderNumLableW + nameLableW + strTimeLableW + stateLableW + 5);
        make.top.equalTo(self.mas_top).offset(21);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
        
    }];

   
    [self.totalLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(4 * x + orderNumLableW + nameLableW + strTimeLableW + stateLableW + 25);
        make.top.equalTo(self.mas_top).offset(21);
        make.height.equalTo(@21);
        make.width.equalTo(@(totalLableW));

    }];
 //   self.totalLable.adjustsFontSizeToFitWidth= YES;
    [self.endTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5 * x + orderNumLableW + nameLableW + strTimeLableW + stateLableW + totalLableW -5);
        make.top.equalTo(self.mas_top).offset(21);
        make.height.equalTo(@21);
        make.width.equalTo(@(endTimeLableW));

    }];
 //   self.endTimeLable.adjustsFontSizeToFitWidth = YES;
    [self.payStateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(6 * x + orderNumLableW + nameLableW + strTimeLableW + stateLableW + totalLableW + endTimeLableW -10);
        make.top.equalTo(self.mas_top).offset(21);
        make.height.equalTo(@21);
        make.width.equalTo(@(payStateLableW));

    }];
 //   self.payStateLable.adjustsFontSizeToFitWidth = YES;
    [self.classLable mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(self.mas_top).offset(21);
        make.height.equalTo(@21);
        make.width.equalTo(@(classLableW));
        make.left.equalTo(self.mas_left).offset(7 * x + orderNumLableW + nameLableW + strTimeLableW + stateLableW + totalLableW + endTimeLableW + payStateLableW -10);

    }];
    self.classLable.adjustsFontSizeToFitWidth = YES ;
}




-(void)fillCellWithModel:(id)model{
    
    [self.orderNumLable setText:[model valueForKey:@"orderId"]];
    [self.nameLable setText:[model valueForKey:@"resNo"]];
    [self.strTimeLable setText:[model valueForKey:@"orderStartDatetime"]];
    [self.stateLable setText:[model valueForKey:@"orderStatus"]];
    [self.totalLable setText:[model valueForKey:@"orderPayCount"]];
    
    if (![[model valueForKey:@"checkOutTime"] isKindOfClass:NULL]) {
        [self.endTimeLable setText:[model valueForKey:@"checkOutTime"]];
    }
    
    [self.payStateLable setText:[model valueForKey:@"payStatus"]];
    [self.classLable setText:[model valueForKey:@"orderType"]];
}



@end
