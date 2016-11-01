//
//  GYHSCellTypeImagelabel.m
//  company
//
//  Created by apple on 14-11-12.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYHSCellTypeImagelabel.h"
#import "GYHSConstant.h"
@interface GYHSCellTypeImagelabel ()

@end

@implementation GYHSCellTypeImagelabel

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.lbCellLabel setTextColor:UIColorFromRGB(0x464646)];
    self.lbCellLabel.font = [UIFont systemFontOfSize:18];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
