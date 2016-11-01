//
//  GYHENearMainCell.m
//  HSConsumer
//
//  Created by zhengcx on 16/10/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHENearMainCell.h"

@implementation GYHENearMainCell

- (void)awakeFromNib {
    // Initialization code
    self.lineView.hidden = YES;
    self.contentView.backgroundColor = kBackgroundGrayColor;
    self.areaLabel.font = [UIFont systemFontOfSize:14];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(GYHENearModel *)model
{
    _model = model;
    self.areaLabel.text = model.areaName;
}

@end
