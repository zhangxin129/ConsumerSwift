//
//  GYPasswordTextFiled.m
//  密码输入框Demo
//
//  Created by lizp on 16/9/5.
//  Copyright © 2016年 Apple05. All rights reserved.
//



#import "GYPasswordTextFiled.h"

@implementation GYPasswordTextFiled

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGFloat perWidth = (frame.size.width - kPasswordLength + 1)*1.0/kPasswordLength;
    for(NSInteger i=0;i<kPasswordLength;i++){
        if(i < kPasswordLength - 1){
            UILabel *vLine = (UILabel *)[self viewWithTag:kLineTag + i];
            if(!vLine){
                vLine = [[UILabel alloc]init];
                vLine.tag = kLineTag + i;
                [self addSubview:vLine];
            }
            vLine.frame = CGRectMake(perWidth + (perWidth + 1)*i, 0, 1, frame.size.height);
            vLine.backgroundColor = [UIColor grayColor];
        }
        UILabel *dotLabel = (UILabel *)[self viewWithTag:kDotTag + i];
        if(!dotLabel){
            dotLabel = [[UILabel alloc]init];
            dotLabel.tag = kDotTag + i;
            [self addSubview:dotLabel];
        }
        dotLabel.frame = CGRectMake((perWidth + 1)*i + (perWidth - 10)*0.5, (frame.size.height - 10)*0.5, 10, 10);
        dotLabel.layer.masksToBounds = YES;
        dotLabel.layer.cornerRadius = 5;
        dotLabel.backgroundColor = [UIColor blackColor];
        dotLabel.hidden = YES;
    }
}


-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if(menuController){
        menuController.menuVisible = NO;
    }
    return NO;
}


@end
