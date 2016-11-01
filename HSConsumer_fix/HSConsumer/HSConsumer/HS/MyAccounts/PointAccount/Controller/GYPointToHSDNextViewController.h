//
//  GYPointToCashViewNextController.h
//  HSConsumer
//
//  Created by apple on 14-10-27.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

////积分转互生币与积分投资下一步页面

#import <UIKit/UIKit.h>
#import "GYHSCardBandModel.h"

@interface GYPointToHSDNextViewController : GYViewController

//用于上一步传递过来的详情信息
@property (nonatomic, assign) double inputValue;
@property (nonatomic, copy) NSString* integral;
@property (nonatomic, copy) NSString* type;
@property (nonatomic,copy)NSArray *delArray;
@property (nonatomic,copy)GYHSCardBandModel *bandModel;

@end
