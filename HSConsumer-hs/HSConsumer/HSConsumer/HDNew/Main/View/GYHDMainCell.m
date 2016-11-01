//
//  GYHDMainCell.m
//  GYHDMessageDemo
//
//  Created by kuser on 16/9/8.
//  Copyright © 2016年 hsxt. All rights reserved.
//

#import "GYHDMainCell.h"

@implementation GYHDMainCell

- (void)awakeFromNib {
    // Initialization code
    
    self.iconImage.layer.cornerRadius = 2;
    self.iconImage.clipsToBounds = YES;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.contentLabel.textColor = [UIColor lightGrayColor];
    self.contentLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.font = [UIFont systemFontOfSize:11];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
