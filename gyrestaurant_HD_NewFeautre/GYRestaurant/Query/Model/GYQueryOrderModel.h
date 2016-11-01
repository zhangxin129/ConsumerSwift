//
//  GYQueryOrderModel.h
//  GYRestaurant
//
//  Created by apple on 15/10/20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYQueryOrderModel : NSObject

@property(nonatomic,copy)NSString *orderId;             //订单Id
@property(nonatomic,copy)NSString *userId;              //用户Id
@property(nonatomic,copy)NSString *orderPhone;          //手机号（外卖）
@property(nonatomic,copy)NSString *resNo;               //买家手机号或互生号
@property(nonatomic,copy)NSString *orderPayCount;       //订单金额
@property(nonatomic,copy)NSString *orderStartDatetime;  //订单开始时间
@property(nonatomic,copy)NSString *orderStatus;      //订单状态
@property(nonatomic,copy)NSString *payOrderDate;        //交易完成时间
@property(nonatomic,copy)NSString *orderType;           //订单类型
@property(nonatomic,copy)NSString *payStatus;           //付款状态
@property(nonatomic,copy)NSString *checkOutTime;        //结账时间

@end
