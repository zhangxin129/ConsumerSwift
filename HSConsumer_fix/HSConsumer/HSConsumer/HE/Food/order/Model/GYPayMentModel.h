//
//  GYPayMentModel.h
//  HSConsumer
//
//  Created by appleliss on 15/10/22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYPayMentModel : NSObject
@property (copy, nonatomic) NSString* amount;
@property (copy, nonatomic) NSString* preAmount;
@property (copy, nonatomic) NSString* orderId;
@property (copy, nonatomic) NSString* payType;
@property (copy, nonatomic) NSString* pwd;
@property (copy, nonatomic) NSString* currency;
@property (copy, nonatomic) NSString* userId;
@property (copy, nonatomic) NSString* custId;
@property (copy, nonatomic) NSString* userKey;
@property (copy, nonatomic) NSString* retCode;
@property (copy, nonatomic) NSString* amountActually;
@end
