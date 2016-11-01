//
//  UIButton+GetSMSCode.h
//  Build
//
//  Created by 00 on 14-10-27.
//  Copyright (c) 2014年 00. All rights reserved.
//

#import <UIKit/UIKit.h>

//验证码按钮 方法

@interface UIButton (GetSMSCode)

/************使用方法***********
   //点击事件
   - (IBAction)getCodeClick:(id)sender {

   [btnGetCode setButtonWithTitle:@"验证码" state:UIControlStateNormal width:1.0 radius:4.0 color:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]];
   [btnGetCode getCodeWithTimer:self.timer secs:60];
   }


   - (void)viewDidLoad
   {
    [super viewDidLoad];

   //获取验证码按钮设置
   [btnGetCode setButtonWithTitle:@"验证码" state:UIControlStateNormal width:1.0 radius:4.0 color:[UIColor colorWithRed:0/255.0 green:170/255.0 blue:230/255.0 alpha:1.0]];
   [btnGetCode saveBtnTitle:@"验证码"];
   }
 */

//设置标题、边框
- (void)setButtonWithTitle:(NSString*)title state:(UIControlState)state width:(CGFloat)width radius:(CGFloat)radius color:(UIColor*)color;
//保存标题，点击前调用
- (void)saveBtnTitle:(NSString*)title;
//点击时调用，设置时间
- (void)getCodeWithTimer:(NSTimer *)timer secs:(NSInteger)secs;


@end
