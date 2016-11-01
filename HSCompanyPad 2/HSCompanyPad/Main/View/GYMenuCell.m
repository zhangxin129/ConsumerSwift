//
//  GYMenuCell.m
//  HSCompanyPad
//
//  Created by User on 16/8/19.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYMenuCell.h"

@implementation GYMenuCell

- (void)awakeFromNib {
    
    @weakify(self);
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(18);
        make.width.height.mas_equalTo(38);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        make.left.equalTo(self.imgView.mas_right).offset(8);
        make.top.height.equalTo(self.imgView);
        make.rightMargin.mas_equalTo(10);
    }];
}

-(void)loadModel:(GYMainHistoryModel*)model{

    self.nameLabel.text =model.name;
    
  //  NSString *imageName =[NSString stringWithFormat:@"%@_small",model.iconName];
    
    self.imgView.image =kLoadPng(model.iconName);

}

@end
