//
//  UIButton+GYTimeOut.m
//  company
//
//  Created by sqm on 16/5/11.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "UIButton+GYTimeOut.h"
#define timeOut 3
@implementation UIButton (GYTimeOut)
- (void)controlTimeOut
{
    self.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeOut * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.enabled = YES;
    });
}
- (void)controlTimeOutWithSecond:(NSInteger)second
{

    self.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    self.enabled = YES;
    });
}
@end
