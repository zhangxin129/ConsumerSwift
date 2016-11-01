//
//  GYHSForgotPasswdVC.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHSLoginViewController.h"
#import "GYViewController.h"

@protocol GYHSForgotPasswdVCDelegate <NSObject>

- (void)toRestPwdPage:(BOOL)isFindPwdByPhone dataDic:(NSMutableDictionary*)dataDic;

@end

@interface GYHSForgotPasswdVC : GYViewController

@property (nonatomic, assign) GYHSLoginViewControllerEnum loginType;

@property (nonatomic, assign) GYHSLoginVCShowTypeEnum popType;

@property (nonatomic, assign) GYHSLoginVCPageTypeEnum pageType;

@property (nonatomic, weak) id<GYHSForgotPasswdVCDelegate> delegate;

@end
