//
//  GYHSPaymentCheckModel.h
//  HSCompanyPad
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYHSPaymentCheckModel : JSONModel
@property (nonatomic, copy) NSString* sourceTransNo;//原始交易号
@property (nonatomic, copy) NSString* sourceTransDate;//原始交易时间
@property (nonatomic, copy) NSString* orderAmount;//消费金额
@property (nonatomic, copy) NSString* transAmount;//实付金额
@property (nonatomic, copy) NSString* transType;//交易类型
@property (nonatomic, copy) NSString* sourceCurrencyCode;//原始交易币种代号
@end
