//
//  GYHEMapNearCell.m
//  HSConsumer
//
//  Created by zhengcx on 16/10/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEMapNearCell.h"

@implementation GYHEMapNearCell

- (void)awakeFromNib {
    // Initialization code
    
    self.nearAddressLabel.font = [UIFont systemFontOfSize:13];
    self.nearAddressLabel.textColor = [UIColor lightGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(GYNearAddressModel *)model
{
    _model = model;
    self.nearAddressLabel.text = model.title;
}

@end
