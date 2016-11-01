//
//  GYQRPayModel.h
//  HSConsumer
//
//  Created by sqm on 16/4/18.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYQRPayModel : NSObject

@property (nonatomic, copy) NSString* batchNo;
@property (nonatomic, copy) NSString* entCustId;
@property (nonatomic, copy) NSString* tradeAmount;
@property (nonatomic, copy) NSString* pointRate;
@property (nonatomic, copy) NSString* hsbAmount;
@property (nonatomic, copy) NSString* date;
@property (nonatomic, copy) NSString* entResNo;
@property (nonatomic, copy) NSString* currencyCode;
@property (nonatomic, copy) NSString* entName;
@property (nonatomic, copy) NSString* acceptScore;
@property (nonatomic, copy) NSString* voucherNo;
@property (nonatomic, copy) NSString* posDeviceNo;
@property (nonatomic, copy) NSString* transNo;
@property (nonatomic, copy) NSString* couponNum;
@property (nonatomic, copy) NSString* couponValue;
@property (nonatomic, copy) NSString* transAmount;

@end
