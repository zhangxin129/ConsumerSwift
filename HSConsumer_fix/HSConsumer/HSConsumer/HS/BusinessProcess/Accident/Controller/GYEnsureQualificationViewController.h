//
//  GYEnsureQualificationViewController.h
//  HSConsumer
//
//  Created by xiaoxh on 16/7/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYViewControllerDelegate.h"

@interface GYEnsureQualificationViewController : GYViewController
@property (weak, nonatomic) id<GYViewControllerDelegate> delegate;
@property (nonatomic, strong) UINavigationController* nav;
@end
