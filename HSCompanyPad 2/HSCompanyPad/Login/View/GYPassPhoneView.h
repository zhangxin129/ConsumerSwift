//
//  GYPassPhoneView.h
//  HSCompanyPad
//
//  Created by User on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYPassPhoneDelegate <NSObject>

//选中获取验证码按钮
-(void)didSelectCodeBtnRequest:(NSString*)phoneText;

@end

@interface GYPassPhoneView : UIView

@property (weak, nonatomic) IBOutlet UILabel *wrongCodeLabel;//验证码错误提示标签

@property (weak, nonatomic) IBOutlet UIView *phoneBackView;//手机号背影view

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UIView *codeBackView;//短信验证码背景view
@property (weak, nonatomic) IBOutlet UITextField *codeTF;//验证码输入框
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;//获取验证码按钮

@property (nonatomic ,copy)NSString * phoneText;//电话号码

@property (nonatomic,weak) id<GYPassPhoneDelegate> delegate;

@end
