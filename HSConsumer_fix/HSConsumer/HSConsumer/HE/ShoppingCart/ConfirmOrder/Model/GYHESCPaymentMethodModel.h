//
//  GYHESCPaymentMethodModel.h
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYHESCPaymentMethodModel : JSONModel

@property (nonatomic, copy) NSString* type; //请求下来的类型，@"AC"为互生币支付,@"EP"为网银支付,@"CD"为货到付款,@"QU"为快捷支付
@property (nonatomic, copy) NSString* payType; //支付类型，3对应@"AC",2对应@"EP",1对应@"CD",4对应@"QU"
@property (nonatomic, copy) NSString* typeString; //支付类型语言描述
@property (nonatomic, copy) NSString *hsbBalance;//互生币余额

@end
