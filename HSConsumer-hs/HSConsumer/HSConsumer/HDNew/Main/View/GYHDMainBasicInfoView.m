//
//  GYHDMainBasicInfoView.m
//  GYHDMainViewController
//
//  Created by kuser on 16/9/9.
//  Copyright © 2016年 hsxt. All rights reserved.
//

#import "GYHDMainBasicInfoView.h"

@implementation GYHDMainBasicInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    
    self.bottomView.backgroundColor = kBackgroundGrayColor;
    
    self.hsNumberLabel.font = [UIFont systemFontOfSize:12];
    self.hsNumberLabel.textColor = kCorlorFromHexcode(0x000000);
    
    self.mobileBindLabel.font = [UIFont systemFontOfSize:12];
    self.mobileBindLabel.textColor = kCorlorFromHexcode(0x000000);
    
    self.emailBindLabel.font = [UIFont systemFontOfSize:12];
    self.emailBindLabel.textColor = kCorlorFromHexcode(0x000000);
    
    self.hsCardStatusLabel.font = [UIFont systemFontOfSize:12];
    self.hsCardStatusLabel.textColor = kCorlorFromHexcode(0x000000);
    
    self.hsNotRegisterLabel.font = [UIFont systemFontOfSize:12];
    self.hsNotRegisterLabel.textColor = kCorlorFromHexcode(0x000000);
    
    self.realNameLabel.font = [UIFont systemFontOfSize:12];
    self.realNameLabel.textColor = kCorlorFromHexcode(0x000000);
    
    UISwipeGestureRecognizer *tap=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFromUp)];
    [tap setDirection:UISwipeGestureRecognizerDirectionUp];
    [self addGestureRecognizer:tap];
}

-(void)handleSwipeFromUp
{
    NSLog(@"fromUP");
    if ([self.delegate respondsToSelector:@selector(upGestureClickDelegate)]) {
        [self.delegate upGestureClickDelegate];
    }
}

@end
