//
//  GYHSInfoHeadPicCell.m
//  HSConsumer
//
//  Created by zhangqy on 16/4/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSInfoHeadPicCell.h"

@implementation GYHSInfoHeadPicCell

- (void)awakeFromNib
{
    // Initialization code
    _titleLabel.textColor = kCellItemTitleColor;
    _headPicImageView.clipsToBounds = YES;
    _headPicImageView.layer.cornerRadius = _headPicImageView.bounds.size.width / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
