//
//  GYFullPopOneCell.m
//  GYFullScreenPopView
//
//  Created by xiaoxh on 16/9/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GYFullPopOneCell.h"

@implementation GYFullPopOneCell

- (void)awakeFromNib {
    self.lineView.hidden = YES;
    self.backgroundColor = [kCorlorFromHexcode(0xfb7d00) colorWithAlphaComponent:0.8];
    self.provinceNameLb.textColor = kCorlorFromHexcode(0xffffff);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
