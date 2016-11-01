//
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/28.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface GYHSCardBandModel : JSONModel

@property (nonatomic, copy) NSString* bankBranch; //开户支行名称
@property (nonatomic, copy) NSString* usedFlag; //账户转账标识 1:转账成功 0：从未转账 2：转账失败 只要一次转账成功，此状态以后就不再改变
@property (nonatomic, copy) NSString* realName; //姓名
@property (nonatomic, copy) NSString* accId; //银行账户编号
@property (nonatomic, copy) NSString* bankName; //银行名称
@property (nonatomic, copy) NSString* cityName; //收款账户开户市,跨行转账必输,如:"深圳"
@property (nonatomic, copy) NSString* countryName; //国家
@property (nonatomic, copy) NSString* provinceCode; //所在省编号
@property (nonatomic, copy) NSString* bankCode; //开户银行代号
//@property (nonatomic,copy)NSString *bankAcctNo;//客户银行账号
@property (nonatomic, copy) NSString* cityCode; //收款账户开户市号,跨行转账必输
@property (nonatomic, copy) NSString* custId; // 客户id
@property (nonatomic, copy) NSString* bankCardType; //帐户类型 1：DR_CARD-借记卡2：CR_CARD-贷记卡3：PASSBOOK-存折 4：CORP_ACCT-对公帐号
@property (nonatomic, copy) NSString* isDefault; //是否默认账户（1:是 0：否）
@property (nonatomic, copy) NSString* provinceName; //省
@property (nonatomic, copy) NSString* resNo; //消费者互生号
@property (nonatomic, copy) NSString* bankAccName; //客户银行户名
@property (nonatomic, copy) NSString* countryCode; //国代码
@property (nonatomic, copy) NSString *isValidAccount;//是否已验证，0否，1是，只有查询时才有该值
@property (nonatomic, copy) NSString *custName;//客户名
@property (nonatomic, copy) NSString *bankAccNo;//等价bankAcctNo
@property (nonatomic, copy) NSString *isDefaultAccount;//等价isDefault

@end
