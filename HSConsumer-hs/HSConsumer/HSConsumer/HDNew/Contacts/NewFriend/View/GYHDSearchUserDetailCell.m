//
//  GYHDSearchUserDetailCell.m
//  HSConsumer
//
//  Created by wangbiao on 16/9/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSearchUserDetailCell.h"
#import "GYHDSearchUserDetailModel.h"

@implementation GYHDSearchUserDetailCell

- (void)setModel:(GYHDSearchUserDetailModel *)model {
    _model = model;
    [self.leftImageView setImageWithURL:[NSURL URLWithString:model.iconString] placeholder:[UIImage imageNamed:@"gyhd_contants_deafultheadportrait_icon"]];
    self.leftTopLabel.text = model.nikeNameString;
    self.leftBottomLabel.text = model.huShengString;
}


@end
