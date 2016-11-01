//
//  GYOrderListModel.h
//  GYRestaurant
//
//  Created by ios007 on 15/10/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYOrderListModel : NSObject

//订单号
@property (nonatomic,copy) NSString *orderId;

//用户账号
@property (nonatomic,copy) NSString *userId;

//下单时间
@property (nonatomic,copy) NSString *orderStartDatetime;

//付款状态
@property (nonatomic,copy) NSString *payStatus;

//订单状态
@property (nonatomic,copy) NSString *orderStatusN;

@property (nonatomic, copy) NSString *orderStatus;

//订单金额
@property (nonatomic,copy) NSString *orderPayCount;

//结账时间
@property (nonatomic,copy) NSString *payOrderDate;

//送餐员
@property (nonatomic,copy) NSString *postMan;

//配送时间
@property (nonatomic,copy) NSString *postDateTimeRange;

//互生号
@property (nonatomic, copy)NSString *resNo;

@property (nonatomic, copy)NSString *orderPhone;

@property (nonatomic, copy)NSString *orderType;
//预付定金
@property (nonatomic, copy)NSString *moneyEarnest;

//预约时间
@property (nonatomic, copy)NSString *planTime;

//桌号
@property (nonatomic, copy)NSString *tableNo;
//人数
@property (nonatomic, assign)NSInteger tableNumber;
//取消时间
@property (nonatomic,copy) NSString *cancelApplyTime;

@end
