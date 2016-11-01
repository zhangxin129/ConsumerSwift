//
//  GYOdrOutDetailCell.m
//  GYRestaurant
//
//  Created by apple on 15/10/27.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOdrOutDetailCell.h"
#import "FoodListInModel.h"

@implementation GYOdrOutDetailCell

-(void)layoutSubviews{
    [super layoutSubviews];
//    [self addBottomBorder];
//    [self setBottomBorderInset:YES];
    self.customBorderType = UIViewCustomBorderTypeBottom;
}

-(void)updateConstraints
{
    [super updateConstraints];
         [self.contentView removeConstraints:[self.contentView constraints]];
    
    float width = (kScreenWidth-80)/8;
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.top.equalTo(self.mas_top).offset(5);
        make.height.equalTo(@70);
        make.width.equalTo(@70);
    }];
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(85);
//        make.top.equalTo(self.mas_top).offset(38);
//        make.height.equalTo(@70);
//        make.width.equalTo(@70);
//    }];
    [self.foodNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(90);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@(width));
    }];
   // self.foodNameLable.adjustsFontSizeToFitWidth = YES;
    
    [self.foodLableLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(60 + width);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@(width));
    }];
    self.foodLableLable.adjustsFontSizeToFitWidth =YES;
    [self.coinView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(90 + width *2 + 40);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@21);
    }];
    
    [self.foodPriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(90 + width *2 + 20 +21 +20);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@(width - 21));
    }];
    self.foodPriceLable.adjustsFontSizeToFitWidth = YES;
    [self.foodNumLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(90 + width *4);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@(width));
    }];
    self.foodNumLable.adjustsFontSizeToFitWidth= YES;
    [self.coinView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(90 + width *5 + 20);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@21);
    }];
    
    [self.totalPayLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(90 + width *5 + 20 + 21);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@(width  - 21));
    }];
    self.totalPayLable.adjustsFontSizeToFitWidth = YES;
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(90 + width * 6 + 20 +60 );
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@27);
    }];
    
    [self.pointLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(90 + width *6 + 20 +27 + 60);
        make.top.equalTo(self.mas_top).offset(38);
        make.height.equalTo(@21);
        make.width.equalTo(@(width - 27 - 20));
    }];
    self.pointLable.adjustsFontSizeToFitWidth = YES;
//    [self.stautLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(80 + width *6);
//        make.top.equalTo(self.mas_top).offset(38);
//        make.height.equalTo(@21);
//        make.width.equalTo(@(width - 40));
//    }];
//    
//    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(80 + width *7);
//        make.top.equalTo(self.mas_top).offset(35);
//        make.height.equalTo(@30);
//        make.width.equalTo(@(width - 40));
//    }];
    
}




@end
