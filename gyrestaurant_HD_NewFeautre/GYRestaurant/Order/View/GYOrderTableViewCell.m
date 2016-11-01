//
//  GYOrderTableViewCell.m
//  GYRestaurant
//
//  Created by ios007 on 15/10/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOrderTableViewCell.h"
#import "GYOrderListModel.h"

#define kFrontWidth 40

@interface GYOrderTableViewCell ()

//订单号
@property (weak, nonatomic) IBOutlet UILabel *oderIdLabel;
//用户名
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
//下单时间
@property (weak, nonatomic) IBOutlet UILabel *orderStartDatetimeLabel;
//订单状态
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLable;
//小图片
@property (weak, nonatomic) IBOutlet UIImageView *coinImg;
//订单金额
@property (weak, nonatomic) IBOutlet UILabel *orderPayCountLabel;

@end


@implementation GYOrderTableViewCell

- (void)updateConstraints
{
    [super updateConstraints];
    [self.contentView removeConstraints:[self.contentView constraints]];
    float width = (kScreenWidth - kFrontWidth)/5;

    [self.oderIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(width+30));
        
    }];
    self.oderIdLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.userIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kFrontWidth + width + 20);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(width - 20));
        
    }];
    self.userIdLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.orderStartDatetimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kFrontWidth + width * 2);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(width));
        
    }];
    self.orderStartDatetimeLabel.adjustsFontSizeToFitWidth = YES;
//    [self.orderStatusLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(kFrontWidth + width * 3 + 10);
//        make.top.equalTo(self.mas_top).offset(11);
//        make.height.equalTo(@21);
//        make.width.equalTo(@(width - 10));
//        
//    }];
    
    [self.coinImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kFrontWidth + width * 3 + 60);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@20);
        make.width.equalTo(@(20));
        
    }];
    
    [self.orderPayCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kFrontWidth + width * 3 + 20 + 60);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(width - 20 - 40));
        
    }];
    self.orderPayCountLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.oprateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(5);
        make.height.equalTo(@40);
        make.width.equalTo(@(width));
        make.left.equalTo(self.mas_left).offset(kFrontWidth + width * 4);
    }];
    
}


- (IBAction)btn:(GYOrderListModel *)model
{
    if ([self.delegate respondsToSelector:@selector(operateBtn:withTableViewType:button:)]) {
        [self.delegate operateBtn:self.model withTableViewType:self.tableViewType button:self.oprateBtn];
    }
}


-(void)setModel:(GYOrderListModel *)model
{
    if (_model != model) {
        _model = model;
      
        _oderIdLabel.text = model.orderId;
        _userIdLabel.text = model.resNo;
        _orderStartDatetimeLabel.text = model.orderStartDatetime;
//        _orderStatusLable.text = model.payStatus;
        _orderPayCountLabel.text =model.orderPayCount;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    [self addBottomBorder];
//    [self setBottomBorderInset:YES];
    self.customBorderType = UIViewCustomBorderTypeBottom;
}


@end
