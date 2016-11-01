//
//  GYHDMainMobileBasicInfoView.m
//  HSConsumer
//
//  Created by kuser on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDMainMobileBasicInfoView.h"

@implementation GYHDMainMobileBasicInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    self.mobileLabel.font = [UIFont systemFontOfSize:12];
    self.mobileLabel.textColor = kCorlorFromHexcode(0x000000);
    
    self.emailLabel.font = [UIFont systemFontOfSize:12];
    self.emailLabel.textColor = kCorlorFromHexcode(0x000000);
    self.bottomView.backgroundColor = kBackgroundGrayColor;
    
    UISwipeGestureRecognizer *tap=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFromUp)];
    [tap setDirection:UISwipeGestureRecognizerDirectionUp];
    [self addGestureRecognizer:tap];
    
}

-(void)handleSwipeFromUp
{
    NSLog(@"fromUP");
    if ([self.delegate respondsToSelector:@selector(upGestureMobileClickDelegate)]) {
        [self.delegate upGestureMobileClickDelegate];
    }
}

@end
