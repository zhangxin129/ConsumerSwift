//
//  GYHSResetPasswordVC.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHSLoginViewController.h"
#import "GYViewController.h"

@interface GYHSResetPasswordVC : GYViewController

@property (nonatomic, assign) GYHSLoginViewControllerEnum loginType;
@property (nonatomic, assign) GYHSLoginVCShowTypeEnum popType;
@property (nonatomic, assign) GYHSLoginVCPageTypeEnum pageType;

@property (nonatomic, assign) BOOL isFindPwdByPhone;

@property (nonatomic, strong) NSMutableDictionary* pwdByPhoneDic;

@property (nonatomic, strong) NSMutableDictionary* pwdByQuestionDic;

@end
