//
//  GYStaffMangerViewCell.m
//  GYRestaurant
//
//  Created by apple on 15/11/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYStaffMangerViewCell.h"
#import "GYDeliverModel.h"

@implementation GYStaffMangerViewCell

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
    
    
    float headImageNameLableW = 80;
    float nameLableW = 90;
    float sexLableW = 43;
    float phoneNumLableW = 159;
    float stateLableW = 68;
    float shopLableW = 139;
    float remarkLableW = 152;
    float deleteBtnW = 65;
    float changeBtnW = 65;
    
    float x = (kScreenWidth  - headImageNameLableW -nameLableW - sexLableW-phoneNumLableW - stateLableW- shopLableW - remarkLableW - deleteBtnW)/8;
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.equalTo(@80);
        make.width.equalTo(@(headImageNameLableW));
        
    }];
    
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8 + x + headImageNameLableW);
        make.top.equalTo(self.mas_top).offset(35);
        make.height.equalTo(@30);
        make.width.equalTo(@(nameLableW));
        
    }];
    [self.sexLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8 + 2 * x + headImageNameLableW + nameLableW );
        make.top.equalTo(self.mas_top).offset(35);
        make.height.equalTo(@30);
        make.width.equalTo(@(sexLableW));
        
    }];
    
    [self.phoneNumLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8 + 3 * x + headImageNameLableW + nameLableW +sexLableW );
        make.top.equalTo(self.mas_top).offset(35);
        make.height.equalTo(@30);
        make.width.equalTo(@(phoneNumLableW));
        
    }];
    
    
    
    [self.stateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8 + 4 * x + headImageNameLableW + nameLableW +sexLableW + phoneNumLableW);
        make.top.equalTo(self.mas_top).offset(35);
        make.height.equalTo(@30);
        make.width.equalTo(@(stateLableW));
        
    }];
    
    [self.shopLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8 + 5 * x + headImageNameLableW + nameLableW +sexLableW + phoneNumLableW+ stateLableW);
        make.top.equalTo(self.mas_top).offset(8);
        make.height.equalTo(@82);
        make.width.equalTo(@(shopLableW));
        
    }];
    
    [self.remarkLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8 + 6 * x + headImageNameLableW + nameLableW +sexLableW + phoneNumLableW+ stateLableW + shopLableW);
        make.top.equalTo(self.mas_top).offset(8);
        make.height.equalTo(@82);
        make.width.equalTo(@(remarkLableW));
        
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8 + 7 * x + headImageNameLableW + nameLableW +sexLableW + phoneNumLableW+ stateLableW + shopLableW + remarkLableW);
        make.top.equalTo(self.mas_top).offset(15);
        make.height.equalTo(@30);
        make.width.equalTo(@(deleteBtnW));
        
    }];
    
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(53);
        make.height.equalTo(@30);
        make.width.equalTo(@(changeBtnW));
        make.left.equalTo(self.mas_left).offset(8 + 7 * x + headImageNameLableW + nameLableW +sexLableW + phoneNumLableW+ stateLableW + shopLableW + remarkLableW);
        
    }];
}




- (IBAction)btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(deleteBtn:)]) {
        btn.enabled = NO;
        [self.delegate deleteBtn:self.model];
        btn.enabled = YES;
    }

}
- (IBAction)changeBtn:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(changeBtnAction:)]) {
        btn.enabled = NO;
        [self.delegate changeBtnAction:self.model];
        btn.enabled = YES;
    }
}



-(void)setModel:(GYDeliverModel *)model{
    if (_model != model) {
        _model = model;
    
        [self.nameLable setText:[model valueForKey:@"name"]];
        [self.sexLable setText:[model valueForKey:@"sex"]];
        [self.phoneNumLable setText:[model valueForKey:@"phone"]];
        [self.stateLable setText:[model valueForKey:@"status"]];
        [self.shopLable setText:[model valueForKey:@"shopName"]];
        [self.remarkLable setText:[model valueForKey:@"remark"]];
        
        [self.deleteBtn setTitle:kLocalized(@"Delete") forState:UIControlStateNormal];
        [self.deleteBtn setTitleColor:[UIColor colorWithRed:62/255.0 green:85/255.0 blue:128/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [self.changeBtn setTitle:kLocalized(@"Modify") forState:UIControlStateNormal];
        [self.changeBtn setTitleColor:[UIColor colorWithRed:62/255.0 green:85/255.0 blue:128/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        NSString *url = [NSString stringWithFormat:@"%@",[model valueForKey:@"picUrl"]];
        NSArray *urlArr = [[NSArray alloc] init];
        urlArr = [[model valueForKey:@"picUrl"] componentsSeparatedByString:@"/"];
        if ([[urlArr lastObject]  rangeOfString:@"."].location!= NSNotFound	) {
            
            [_headImageView setImageWithURL:[NSURL URLWithString:url] placeholder:nil options:kNilOptions completion:nil];
        }else{
            
            [_headImageView setImage:[UIImage imageNamed:@"emptyPic"]];
        }

    }
}

@end
