//
//  GYHSBankListModel.h
//  HSCompanyPad
//
//  Created by apple on 16/8/23.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYHSBankListModel : JSONModel
@property (nonatomic, copy) NSString* accId; //账户编号 （主键序列号） 自动生成
@property (nonatomic, copy) NSString* bankCode; //开户行代码
@property (nonatomic, copy) NSString* custName; //客户号
@property (nonatomic, copy) NSString* bankName; //开户行名称
@property (nonatomic, copy) NSString* bankAccNo; //银行账号
@property (nonatomic, copy) NSString* bankAccName; //银行账户名称
@property (nonatomic, copy) NSString* isDefault; //是否默认账户（1:是 0：否）
@property (nonatomic, copy) NSString* countryCode; //国家编号
@property (nonatomic, copy) NSString* cityCode; //开户地址
@property (nonatomic, copy) NSString* provinceCode; //省编号
@property (nonatomic, copy) NSString* isValidAccount; //是否已验证，0否，1是
@property (nonatomic, copy) NSString* bankBranch; //银行的分行名称
@property (nonatomic,copy) NSString *realName;//银行账户名称
@property (nonatomic, copy) NSString *bankCardType;//帐户类型 1：DR_CARD-借记卡2：CR_CARD-贷记卡3：PASSBOOK-存折 4：CORP_ACCT-对公帐号
@property (nonatomic, copy) NSString *openArea;//拼接后地区全称
- (void)getLocation:(void(^)(NSString *local)) location;
@end
