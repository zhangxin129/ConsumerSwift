//
//  GYHSLoginMainVC.h
//  HSConsumer
//
//  Created by wangfd on 16/9/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

// 登陆成功的通知
#define kGYHSLoginMainVCLoginSucessedNotification @"kGYHSLoginMainVCLoginSucessedNotification"
//互生根视图未登录通知
#define kGYHSToLoginMainVCNotification @"kGYHSToLoginMainVCNotification"
//消息根视图未登录通知
#define kGYHDToLoginMainVCNotification @"kGYHDToLoginMainVCNotification"

typedef NS_ENUM(NSUInteger, GYHSLoginVCShowTypeEnum) {
    GYHSLoginVCShowPopView = 1, // 弹出对话框
    GYHSLoginVCNoShowPopView = 2 // 普通视图
};

typedef NS_ENUM(NSUInteger, GYHSLoginVCPageTypeEnum) {
    GYHSLoginVCPageTypeHS = 1, // 互生登陆
    GYHSLoginVCPageTypeHE = 2, // 互商登陆
    GYHSLoginVCPageTypeHD = 3 // 互动登陆
};

typedef NS_ENUM(NSUInteger, GYHSLoginViewControllerEnum) {
    GYHSLoginViewControllerTypeHashsCard = 1, // 有互生卡
    GYHSLoginViewControllerTypeNohsCard = 2 // 无互生卡
};

@interface GYHSLoginMainVC : GYViewController

@property (nonatomic, assign) GYHSLoginVCShowTypeEnum popType;

@property (nonatomic, assign) GYHSLoginVCPageTypeEnum pageType;

@property (nonatomic, assign) GYHSLoginViewControllerEnum loginType;

@end
