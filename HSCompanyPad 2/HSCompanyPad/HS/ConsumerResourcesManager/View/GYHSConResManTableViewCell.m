//
//  GYHSConResManTableViewCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSConResManTableViewCell.h"
#import "GYHSResourceListModel.h"

@interface GYHSConResManTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *HSCardLable;
@property (weak, nonatomic) IBOutlet UILabel *conStateLable;
@property (weak, nonatomic) IBOutlet UILabel *registerTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *HSCardStateLable;


@end

@implementation GYHSConResManTableViewCell

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.contentView removeConstraints:[self.contentView constraints]];
    
    float lableW = (kScreenWidth - 60) / 4;
    float cellH = 20;
    self.HSCardLable.textColor = kGray333333;
    [self.HSCardLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.equalTo(@(kDeviceProportion(cellH)));
        make.width.equalTo(@(kDeviceProportion(lableW)));
    }];
    
    self.conStateLable.textColor = kGray333333;
    [self.conStateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.HSCardLable.mas_left).offset(lableW);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.equalTo(@(kDeviceProportion(cellH)));
        make.width.equalTo(@(kDeviceProportion(lableW)));
    }];
    
    self.registerTimeLable.textColor = kGray333333;
    [self.registerTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.conStateLable.mas_left).offset(lableW);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.equalTo(@(kDeviceProportion(cellH)));
        make.width.equalTo(@(kDeviceProportion(lableW)));
    }];
    
   
    self.HSCardStateLable.textColor = kGray333333;
    [self.HSCardStateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.registerTimeLable.mas_left).offset(lableW);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.equalTo(@(kDeviceProportion(cellH)));
        make.width.equalTo(@(kDeviceProportion(lableW)));
    }];
}

- (void)setModel:(GYHSResourceListModel *)model{
    _model = model;
    self.HSCardLable.text = model.resNo;
    self.registerTimeLable.text = model.updateTime;
    
    if ([model.cardStatus isEqualToString:@"1"]) {
        self.HSCardStateLable.text = kLocalized(@"GYHS_ConResManager_Inactive");
    }else if ([model.cardStatus isEqualToString:@"2"]) {
        self.HSCardStateLable.text = kLocalized(@"GYHS_ConResManager_Active");
    }else if ([model.cardStatus isEqualToString:@"3"]) {
        self.HSCardStateLable.text = kLocalized(@"GYHS_ConResManager_Sleep");
    }else if ([model.cardStatus isEqualToString:@"4"]) {
        self.HSCardStateLable.text = kLocalized(@"GYHS_ConResManager_Precipitation");
    }
    
    if ([model.authStatus isEqualToString:@"1"]) {
        self.conStateLable.text = kLocalized(@"GYHS_ConResManager_UnReal-nameRegistration");
    }else if ([model.authStatus isEqualToString:@"2"]) {
        self.conStateLable.text = kLocalized(@"GYHS_ConResManager_Real-nameRegistration");
    }else if([model.authStatus isEqualToString:@"3"]) {
        self.conStateLable.text = kLocalized(@"GYHS_ConResManager_HasBeenReal-nameCertification");
    }
}
@end
