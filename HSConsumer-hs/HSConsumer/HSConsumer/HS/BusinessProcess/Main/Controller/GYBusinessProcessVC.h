//
//  GYAccountOperatingViewController.h
//  HSConsumer
//
//  Created by apple on 14-11-3.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  业务办理主界面

#import <UIKit/UIKit.h>
#import "GYViewControllerDelegate.h"

@interface GYBusinessProcessVC : GYViewController

@property (weak, nonatomic) id<GYViewControllerDelegate> delegate;
@end
