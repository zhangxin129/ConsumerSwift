//
//  GYMainBtnCell.m
//  HSCompanyPad
//
//  Created by User on 16/7/26.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYMainBtnCell.h"

#define kEdgeInset 0
#define kLeftWidth 15
#define kLabelHeight 40
@implementation GYMainBtnCell

- (void)awakeFromNib {

    
    
  @weakify(self);
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.insets(UIEdgeInsetsMake(kEdgeInset,kEdgeInset,kEdgeInset,kEdgeInset));
  //  make.edges.insets(UIEdgeInsetsMake(12,8,8,8));
    }];
    
    [self.centerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
         @strongify(self);
        make.centerX.equalTo(self.backView);
        make.centerY.equalTo(self.backView).offset(-20);
        
        make.width.height.equalTo(self.backView.mas_height).multipliedBy(0.41);
        
        
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         @strongify(self);
        make.bottom.width.equalTo(self.backView);
        make.left.mas_equalTo(kLeftWidth);
        make.height.mas_equalTo(kLabelHeight);
    }];
    
    self.contentView.backgroundColor =[UIColor whiteColor];
}

- (void)setModel:(GYMainHistoryModel *)model{
    _model = model;
                NSString* title = model.name;
    //
                NSString * imageTitle = model.iconName;
    
                self.centerImgView.image = kLoadPng(imageTitle);
    
                NSString *tempColorStr = model.colorHexString;
    
                self.backView.backgroundColor =[UIColor colorWithHexString:tempColorStr];
    
                self.leftLabel.text = title;
}

@end
