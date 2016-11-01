//
//  GYMainRightBtnCellCollectionViewCell.m
//  HSCompanyPad
//
//  Created by User on 16/8/8.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYMainRightBtnCell.h"


@implementation GYMainRightBtnCell

- (void)awakeFromNib {

    
    @weakify(self);
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        @strongify(self);
        
        make.height.width.equalTo(self.contentView.mas_width).multipliedBy(0.5);
        
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        
        
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.imgView.mas_bottom).offset(10);
        
        make.centerX.mas_equalTo(self.imgView.centerX);
        
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(40);
    }];
}



-(void)loadModel:(GYMainHistoryModel*)model{
    
    NSString* title = model.name;
    //
    NSString * imageTitle = model.iconName;
    
    self.imgView.image = kLoadPng(imageTitle);

    self.nameLabel.text = title;
}
@end
