//
//  GYHENearTwoCell.m
//  HSConsumer
//
//  Created by zhengcx on 16/10/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHENearTwoCell.h"

@implementation GYHENearTwoCell

- (void)awakeFromNib {
    // Initialization code
    self.shopQuLabel.font = [UIFont systemFontOfSize:14];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(GYHEShopQuModel *)model
{
    _model = model;
    self.shopQuLabel.text = model.locationName;
}

@end
