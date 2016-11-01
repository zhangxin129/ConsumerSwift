//
//  GYOrderConfirmTableViewCell.m
//  GYRestaurant
//
//  Created by apple on 15/11/18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOrderConfirmTableViewCell.h"
#import "GYOrderListModel.h"
#define kFrontWidth 40
@interface GYOrderConfirmTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderIdLable;
@property (weak, nonatomic) IBOutlet UILabel *userIdLable;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *typeLable;
//@property (weak, nonatomic) IBOutlet UILabel *payStatusLable;
@property (weak, nonatomic) IBOutlet UILabel *bookTimeLable;
@property (weak, nonatomic) IBOutlet UIImageView *coinImg;
@property (weak, nonatomic) IBOutlet UILabel *accountLable;

@end

@implementation GYOrderConfirmTableViewCell

- (void)updateConstraints
{
    [super updateConstraints];
    [self.contentView removeConstraints:[self.contentView constraints]];
    
    float width = (kScreenWidth - kFrontWidth)/7;
    
    [self.orderIdLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(width+35));
        
    }];
    self.orderIdLable.adjustsFontSizeToFitWidth = YES;
    
    [self.userIdLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kFrontWidth + width );
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(width - 15));
        
    }];
    self.userIdLable.adjustsFontSizeToFitWidth = YES;
    
    [self.orderTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kFrontWidth + width * 2 );
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(width));
        
    }];
    self.orderTimeLable.adjustsFontSizeToFitWidth = YES;
    
    
   
    [self.bookTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kFrontWidth + width * 3 + 15);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(width));
        
    }];
    self.bookTimeLable.adjustsFontSizeToFitWidth = YES;
    [self.typeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kFrontWidth + width * 4 + 40);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(width));
    }];
    self.typeLable.adjustsFontSizeToFitWidth = YES;
    
    [self.coinImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kFrontWidth + width * 5 +30);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@20);
        make.width.equalTo(@(20));
        
    }];
    [self.accountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kFrontWidth + width * 5 + 30 + 20);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(width - 20 - 30));
        
    }];
    self.accountLable.adjustsFontSizeToFitWidth = YES;
    
    [self.operateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(5);
        make.height.equalTo(@40);
        make.width.equalTo(@(width));
        make.left.equalTo(self.mas_left).offset(kFrontWidth + width * 6);
    }];
    
}



-(void)layoutSubviews{
    [super layoutSubviews];
//    [self addBottomBorder];
//    [self setBottomBorderInset:YES];
    self.customBorderType = UIViewCustomBorderTypeBottom;
}

- (IBAction)btnAction:(id)sender {

    if ([self.delegate respondsToSelector:@selector(operateBtn:withTableViewType:button:)]) {
        [self.delegate operateBtn:self.model withTableViewType:self.tableViewType button:sender];
    }

}
-(void)setModel:(GYOrderListModel *)model
{
    if (_model != model) {
        _model = model;
        
        _orderIdLable.text = model.orderId;
        _userIdLable.text = model.resNo;
        _orderTimeLable.text = model.orderStartDatetime;
        _typeLable.text = model.orderType;
        _bookTimeLable.text = model.planTime;
        _accountLable.text = model.orderPayCount;
        
    }
}


@end
