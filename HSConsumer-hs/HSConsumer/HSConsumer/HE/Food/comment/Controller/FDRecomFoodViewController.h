//
//  FDRecomFoodViewController.h
//  HSConsumer
//
//  Created by apple on 15/12/24.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYViewController.h"
#import "FDSubmitCommitOrderDetailFoodModel.h"
typedef void (^BackmyBlock)(FDSubmitCommitOrderDetailFoodModel* model);

@interface FDRecomFoodViewController : GYViewController

@property (nonatomic, strong) BackmyBlock myBlock;
@property (copy, nonatomic) NSString* userKey;
@property (copy, nonatomic) NSString *orderId;

@end
