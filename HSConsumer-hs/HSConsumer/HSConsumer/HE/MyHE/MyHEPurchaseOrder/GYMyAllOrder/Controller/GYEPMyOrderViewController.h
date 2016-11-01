//
//  GYEPMyOrderViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasyPurchaseData.h"

@interface GYEPMyOrderViewController : GYViewController

@property (nonatomic, strong) NSMutableArray* arrResult;
@property (nonatomic, strong) UINavigationController* nav;
@property (nonatomic, assign) EMOrderState orderState;
@property (nonatomic, assign) BOOL firstTipsErr; //查询及结果错误首次提示提示
@property (nonatomic, assign) int startPageNo; //从第几开始 这里默认从第1页开始传

@property (nonatomic, assign) BOOL isQueryRefundRecord; //YES:查询售后申请记录列表，NO：查询订单列表
@property(nonatomic, assign) BOOL isSaleAfter;//是否是售后

- (void)headerRereshing;

@end
