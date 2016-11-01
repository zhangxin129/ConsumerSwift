//
//  GYEPOrderDetailViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-24.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEPMyOrderViewController.h"
@interface GYEPOrderDetailViewController : GYViewController

@property (strong, nonatomic) NSString* orderID;
@property (strong, nonatomic) NSMutableDictionary* dicDataSource; //仅用于售后申请、立即支付、判断是否货到付款
//  延时收货同同步刷新
@property (weak, nonatomic) GYEPMyOrderViewController* delegate;
// songji 商品详情用到数据
@property (strong, nonatomic) NSString *vShopId;
@property (strong, nonatomic) NSString *itemId;

@property (nonatomic, assign) BOOL isComeOrder;
@end
