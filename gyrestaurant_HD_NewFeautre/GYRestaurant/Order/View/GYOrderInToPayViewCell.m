//
//  GYOrderInToPayViewCell.m
//  GYRestaurant
//
//  Created by apple on 15/12/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOrderInToPayViewCell.h"
#import "GYOrderListModel.h"

@implementation GYOrderInToPayViewCell
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
    float tableLableW = 210;
    float payCountLabelW = 130;
    float startBtnW = 50;
    float cancelBtnW = 50;
    float x = (kScreenWidth- OrdIdLabelW -useIdlabelW - ordStartTimeLabelW - tableLableW -payCountLabelW- startBtnW - cancelBtnW )/7;
    
    
    [self.orderNumLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(OrdIdLabelW));
        
    }];
    self.orderNumLable.adjustsFontSizeToFitWidth= YES;
    
    [self.resNoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18 + x + OrdIdLabelW + 5);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(useIdlabelW));
        
    }];
    self.resNoLable.adjustsFontSizeToFitWidth= YES;
    
    [self.eatTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18 + 2 * x + OrdIdLabelW + useIdlabelW + 10);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(ordStartTimeLabelW));
        
    }];
    self.eatTimeLable.adjustsFontSizeToFitWidth= YES;
    
    [self.tabNoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18 + 3 *x+OrdIdLabelW + useIdlabelW + ordStartTimeLabelW - 8 - 5);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(tableLableW));
        
    }];
  //  self.tabNoLable.adjustsFontSizeToFitWidth = YES;
    
    
    [self.coinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18 + 4 * x + OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + tableLableW - 10 -5);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
        
    }];
    [self.accountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18 + 4 * x+OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + tableLableW  +20 - 15);
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(payCountLabelW));
        
    }];
    self.accountLable.adjustsFontSizeToFitWidth = YES;
    
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(startBtnW));
        make.left.equalTo(self.mas_left).offset(18 + 5 * x + OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + tableLableW + payCountLabelW - 15);
        
    }];
    
    [self.centerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@2);
        make.left.equalTo(self.mas_left).offset(18 + 5 * x + OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + tableLableW + payCountLabelW + startBtnW + 5- 15);
        
    }];
    
    
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(11);
        make.height.equalTo(@21);
        make.width.equalTo(@(cancelBtnW));
        make.left.equalTo(self.mas_left).offset(18 + 5 * x + OrdIdLabelW + useIdlabelW + ordStartTimeLabelW + tableLableW + payCountLabelW + startBtnW + 12- 15);
        
    }];
    
    
}



- (IBAction)changeBtnAction:(GYOrderListModel *)model {
    
    if ([self.delegate respondsToSelector:@selector(changeBtn:)]) {
        [self.delegate changeBtn:self.model];
    }
    
    
}

- (IBAction)payBtnAction:(GYOrderListModel *)model {
    if ([self.delegate respondsToSelector:@selector(payBtn:)]) {
        [self.delegate payBtn:self.model];
    }
    
}

-(void)setModel:(GYOrderListModel *)model
{
    if (_model != model) {
        _model = model;
        
        _orderNumLable.text = model.orderId;
        _resNoLable.text = model.resNo;
        _eatTimeLable.text = model.planTime;
    
        _tabNoLable.text = [NSString stringWithFormat:@"%@号/%ld人",model.tableNo,(long)model.tableNumber];
        _accountLable.text =model.orderPayCount;
    }
}


@end
