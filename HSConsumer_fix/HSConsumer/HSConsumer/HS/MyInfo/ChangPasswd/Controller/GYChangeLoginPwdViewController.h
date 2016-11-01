//
//  GYChangeLoginPwdViewController.h
//  HSConsumer
//
//  Created by apple on 14-10-16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYChangeLoginPwdViewController : GYViewController <UITextFieldDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField* OldPassword; //原登录密码
@property (weak, nonatomic) IBOutlet UITextField* NewPassword; //新密码
@property (weak, nonatomic) IBOutlet UITextField* NewPasswordAgain; //再次输入新密码
@property (weak, nonatomic) IBOutlet UILabel* WaringLabel; //原登录密码label
@property (weak, nonatomic) IBOutlet UIButton* BtnnextStep; //下一步btn
@property (nonatomic, assign) BOOL fromWhere;


- (IBAction)btnNextStep:(id)sender;

@end
