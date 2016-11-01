//
//  GYPersonInfo.h
//  HSConsumer
//
//  Created by apple on 15-3-12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYPersonInfo : NSObject

@property (nonatomic, copy) NSString* country; //国家
@property (nonatomic, copy) NSString* creBackImg; //证件背面照
@property (nonatomic, copy) NSString* creExpiryDate; //证件过期时间
@property (nonatomic, copy) NSString* creFaceImg; //证件正面照
@property (nonatomic, copy) NSString* creHoldImg; //手持证件照
@property (nonatomic, copy) NSString* creNo; //证件号码
@property (nonatomic, copy) NSString* creType; //证件类型

@property (nonatomic, copy) NSString* sex; //性别

@property (nonatomic, copy) NSString* importantInfoStatus;
@property(nonatomic, copy) NSString *verifyAppReason;//返回的 审批不通过的原因
@end
