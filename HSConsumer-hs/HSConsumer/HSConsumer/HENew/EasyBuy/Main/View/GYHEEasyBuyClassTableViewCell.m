//
//  GYHEEasyBuyClassTableViewCell.m
//  HSConsumer
//
//  Created by chenwy on 16/9/30.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEEasyBuyClassTableViewCell.h"

@implementation GYHEEasyBuyClassTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateStateWithIndex:(BOOL)isSelected {
    if (isSelected) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = kCorlorFromRGBA(251, 125, 0, 1);
        self.separateLineHeight.constant = 3.0f;
        self.separateLineView.backgroundColor = kCorlorFromRGBA(242, 135, 0, 1);
        self.separateLineView.layer.cornerRadius = 1.5f;
    } else {
        self.contentView.backgroundColor = kCorlorFromRGBA(238, 238, 238, 1);
        self.titleLabel.textColor = kCorlorFromRGBA(102, 102, 102, 1);
        self.separateLineHeight.constant = 1 / [UIScreen mainScreen].scale;
        self.separateLineView.backgroundColor = kCorlorFromRGBA(220, 220, 220, 1);
    }
}

@end
