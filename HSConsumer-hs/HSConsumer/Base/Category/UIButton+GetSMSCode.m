//
//  UIButton+GetSMSCode.m
//  Build
//
//  Created by 00 on 14-10-27.
//  Copyright (c) 2014年 00. All rights reserved.
//

#import "UIButton+GetSMSCode.h"

@implementation UIButton (GetSMSCode)

static long int s;
static NSString* btnTitle;

- (void)setButtonWithTitle:(NSString*)title state:(UIControlState)state width:(CGFloat)width radius:(CGFloat)radius color:(UIColor*)color
{
    [self setTitle:title forState:state];
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    self.layer.cornerRadius = radius;
    self.titleLabel.frame = CGRectMake(0, 0, 200, 25);
}

- (void)saveBtnTitle:(NSString*)title
{
    btnTitle = title;
}

- (void)getCodeWithTimer:(NSTimer*)timer secs:(NSInteger)secs
{
    self.enabled = NO;
    s = secs;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeIsGoingWithTimer:) userInfo:nil repeats:YES];
}

- (void)timeIsGoingWithTimer:(NSTimer*)timer
{
    --s;

    if (kSystemVersionLessThan(@"8.0")) {
        self.titleLabel.text = [NSString stringWithFormat:@"%ld%@", s, kLocalized(@"GYHS_Base_second")];
    }
    else {
        [self setTitle:[NSString stringWithFormat:@"%ld%@", s, kLocalized(@"GYHS_Base_second")] forState:UIControlStateNormal];
    }

    [self setButtonWithTitle:self.titleLabel.text state:UIControlStateNormal width:1.0 radius:4.0 color:[UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0]];
    if (s <= 1) {
        [timer invalidate];
        [self setButtonWithTitle:btnTitle state:UIControlStateNormal width:1.0 radius:4.0 color:[UIColor colorWithRed:250 / 255.0 green:60 / 255.0 blue:40 / 255.0 alpha:1.0]];
        self.enabled = YES;
    }
}

@end
