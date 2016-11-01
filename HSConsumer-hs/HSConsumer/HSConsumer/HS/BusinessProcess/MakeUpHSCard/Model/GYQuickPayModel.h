//
//  GYQuickPayModel.h
//  HSConsumer
//
//  Created by apple on 16/1/5.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYQuickPayModel : JSONModel

/**资源号*/
@property (nonatomic, copy) NSString* resNo;
/**单笔限额*/
@property (nonatomic, copy) NSString* amountSingleLimit;
/**总限额*/
@property (nonatomic, copy) NSString* amountTotalLimit;
/**开户行代码*/
@property (nonatomic, copy) NSString* bankCode;
/**小额支付有效期*/
@property (nonatomic, copy) NSString* smallPayExpireDate;
/**银行卡号*/
@property (nonatomic, copy) NSString* bankCardNo;
/**开户行名称*/
@property (nonatomic, copy) NSString* bankName;
/**银行账户编号*/
@property (nonatomic, copy) NSString* accId;
/**快捷账户签约号*/
@property (nonatomic, copy) NSString* signNo;
/**客户号*/
@property (nonatomic, copy) NSString *custId;
/**借贷记标识1-借记卡； 2-贷记卡(即:信用卡)；*/
@property (nonatomic, strong) NSNumber *bankCardType;

@end
