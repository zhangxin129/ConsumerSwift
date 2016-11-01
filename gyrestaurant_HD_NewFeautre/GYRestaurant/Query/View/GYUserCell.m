//
//  GYUserCell.m
//  GYRestaurant
//
//  Created by apple on 15/10/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYUserCell.h"
#import "GYUserInfoModel.h"
@interface GYUserCell()

@end
@implementation GYUserCell

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
    
    
    float numLableW = 182;
    float nameLableW = 120;
    float phoneLableW = 131;
    float actorLableW = 146;
    float stateLableW = 131;
    
     float x = (kScreenWidth - 0.15 * kScreenWidth - numLableW -nameLableW - phoneLableW - actorLableW - stateLableW)/4;
    
    
    [self.numLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.top.equalTo(self.mas_top).offset(21);
        make.height.equalTo(@21);
        make.width.equalTo(@(numLableW));
        
    }];
 //   self.numLable.adjustsFontSizeToFitWidth =  YES;
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8 + x + numLableW );
        make.top.equalTo(self.mas_top).offset(21);
        make.height.equalTo(@21);
        make.width.equalTo(@(nameLableW));
        
    }];
 //   self.nameLable.adjustsFontSizeToFitWidth = YES;
    
    [self.phoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8 + 2 * x + numLableW + nameLableW  + 20);
        make.top.equalTo(self.mas_top).offset(21);
        make.height.equalTo(@21);
        make.width.equalTo(@(phoneLableW));
        
    }];
 //   self.phoneLable.adjustsFontSizeToFitWidth= YES;
    [self.actorLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset( 8 + 3 * x + numLableW + nameLableW + phoneLableW + 30);
        make.top.equalTo(self.mas_top).offset(21);
        make.height.equalTo(@21);
        make.width.equalTo(@(actorLableW));
        
    }];
 //   self.actorLable.adjustsFontSizeToFitWidth= YES;
    
    
    [self.stateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8 + 3 * x + numLableW + nameLableW + phoneLableW + actorLableW + 50);
        make.top.equalTo(self.mas_top).offset(21);
        make.height.equalTo(@21);
        make.width.equalTo(@(stateLableW));
        
    }];
    
    self.stateLable.adjustsFontSizeToFitWidth = YES;
}

-(void)fillCellWithModel:(id)model{


    [self.numLable setText:[model valueForKey:@"userID"]];
    [self.nameLable setText:[model valueForKey:@"name"]]; 
//    [self.nicknameLable setText:[model valueForKey:@"nickname"]];
//    [self.menberLable setText:[model valueForKey:@"identiticationNumber"]];
    [self.phoneLable setText:[model valueForKey:@"telNumber"]];
    
    
    
    [self.actorLable setText:[model valueForKey:@"roleID"]];
    
    [self.stateLable setText:kLocalized(@"Active")];
    
}


@end
