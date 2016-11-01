//
//  GYPointToCashViewController.h
//  HSConsumer
//
//  Created by apple on 14-10-24.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//积分转互生币与积分投资 互生币转货币页面

#import <UIKit/UIKit.h>

@interface GYPointToHSDViewController : GYViewController

@property (nonatomic, copy) NSString* type; ////0 积分转互生币  1 积分投资  2 互生币转货币
@property (nonatomic,copy)NSString *integral;// 上一界面传来的余额
@end
