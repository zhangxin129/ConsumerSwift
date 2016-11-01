//
//  GYHsbPayLimitModel.h
//  HSConsumer
//
//  Created by sqm on 16/5/11.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHsbPayLimitModel : NSObject
@property (nonatomic, copy) NSString* payMax;//单笔互生币支付限额
@property (nonatomic, copy) NSString* payFreeMax;//互生币支付免密额度
@property (nonatomic, copy) NSString* payDayMax;//单日互生币支付限额
@property (nonatomic, copy) NSString* payDayMaxSwitch;
@property (nonatomic, copy) NSString* sysPayDayMax;//单日最大值
@property (nonatomic, copy) NSString* sysPayMax;//单笔最大值
@property (nonatomic, copy) NSString* payMaxSwitch;
@property (nonatomic, copy) NSString* payOnlineSwitch;
@property (nonatomic, copy) NSString* payFreeMaxSwitch;
@property (nonatomic, copy) NSString* consumerFreePaymentMax;//免密额度
@end
