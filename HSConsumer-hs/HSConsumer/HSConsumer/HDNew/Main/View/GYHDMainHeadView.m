//
//  GYHDMainHeadView.m
//  GYHDMainViewController
//
//  Created by kuser on 16/9/9.
//  Copyright © 2016年 hsxt. All rights reserved.
//

#import "GYHDMainHeadView.h"

@implementation GYHDMainHeadView


-(void)awakeFromNib
{
    self.nickNameLabel.font = [UIFont systemFontOfSize:14];
    self.nickNameLabel.textColor = kCorlorFromHexcode(0x000000);
    
    self.hsNumberLabel.font = [UIFont systemFontOfSize:14];
    self.hsNumberLabel.textColor = kCorlorFromHexcode(0x000000);
    
    self.topView.backgroundColor = kCorlorFromHexcode(0xe0e0e0);
    self.bottomView.backgroundColor = kBackgroundGrayColor;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
