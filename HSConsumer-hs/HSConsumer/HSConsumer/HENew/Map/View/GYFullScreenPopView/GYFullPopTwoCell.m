//
//  GYFullPopTwoCell.m
//  GYFullScreenPopView
//
//  Created by xiaoxh on 16/9/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GYFullPopTwoCell.h"

@implementation GYFullPopTwoCell

- (void)awakeFromNib {
    self.cityNameLb.textColor = kCorlorFromHexcode(0x777777);
    self.backgroundColor = [kCorlorFromHexcode(0xffffff) colorWithAlphaComponent:0.8];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
