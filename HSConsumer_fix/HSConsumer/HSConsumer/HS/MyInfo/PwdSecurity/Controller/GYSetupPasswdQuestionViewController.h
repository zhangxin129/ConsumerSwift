//
//  GYSetupPasswdQuestionViewController.h
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYSetupPasswdQuestionViewController : GYViewController <UITextFieldDelegate, UIActionSheetDelegate>
@property (nonatomic, copy) NSString* strContent;
@property (nonatomic, copy) NSString *strAnswer;

@end
