//
//  GYOderInPaidCell.m
//  GYRestaurant
//
//  Created by ios007 on 15/10/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOderInPaidCell.h"
#import "GYOrderListModel.h"

#define kFrontWidth 40

@implementation GYOderInPaidCell

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
    
    float width = (kScreenWidth - kFrontWidth)/5;
    
    [self.ordIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(50);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(width+30));
        
    }];
    self.ordIdLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.useIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kFrontWidth + width + 5);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(width - 20));
        
    }];
    self.useIdLabel.adjustsFontSizeToFitWidth = YES;
    [self.orderStartDatetimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kFrontWidth + width * 2);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(width));
        
    }];
    self.orderStartDatetimeLabel.adjustsFontSizeToFitWidth = YES;
//    [self.orderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(kFrontWidth + width * 3 );
//        make.top.equalTo(self.mas_top).offset(11);
//        make.height.equalTo(@21);
//        make.width.equalTo(@(width - 10));
//        
//    }];
//    self.orderStatusLabel.adjustsFontSizeToFitWidth = YES;
    [self.coinImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kFrontWidth + width * 3 + 55);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@20);
        make.width.equalTo(@(20));
        
    }];
    [self.orderPayCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kFrontWidth + width * 3 + 20 + 55);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(width - 20 - 40));
        
    }];
    self.orderPayCountLabel.adjustsFontSizeToFitWidth = YES;
    [self.ordFinishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(width));
        make.left.equalTo(self.mas_left).offset(kFrontWidth + width * 4);
    }];
    self.ordFinishTimeLabel.adjustsFontSizeToFitWidth = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
