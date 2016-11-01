//
//  FDSubmitCommitViewController.h
//  HSConsumer
//
//  Created by zhangqy on 15/10/20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
@protocol FDSubmitCommitViewControllerDelegate <NSObject>

- (void)headerRereshing;

@end
#import "FDShopModel.h"
#import <UIKit/UIKit.h>

@interface FDSubmitCommitViewController : GYViewController
@property (copy, nonatomic) NSString* userKey;
@property (copy, nonatomic) NSString* userId;
@property (copy, nonatomic) NSString* orderId;
@property (copy, nonatomic) NSString* shopId;
@property (copy, nonatomic) NSString* vShopId;
@property (copy, nonatomic) NSString* shopName;
@property (assign, nonatomic) BOOL isTakeaway;//是否是外卖或门店自提
@property (nonatomic, copy) NSString *foodOrderType;//餐饮评价类型(type): 1.店内 ,2.外卖 3. 自提
@end
