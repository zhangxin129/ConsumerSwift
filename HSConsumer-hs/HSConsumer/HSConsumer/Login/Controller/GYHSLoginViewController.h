//
//  GYHSLoginViewControllerNew.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYViewController.h"
#import "GYHSLoginMainVC.h"

@interface GYHSLoginViewController : GYViewController

@property (nonatomic, assign) GYHSLoginVCShowTypeEnum popType;
@property (nonatomic, assign) GYHSLoginVCPageTypeEnum pageType;
@property (nonatomic, assign) GYHSLoginViewControllerEnum loginType;

@end
