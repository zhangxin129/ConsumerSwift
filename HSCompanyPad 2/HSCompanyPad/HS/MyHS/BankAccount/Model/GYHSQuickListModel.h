//
//  GYHSQuickListModel.h
//  HSCompanyPad
//
//  Created by apple on 16/8/25.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYHSQuickListModel : JSONModel
@property (nonatomic, copy) NSString *accId;//账户ID，查询时返回
@property (nonatomic, copy) NSString *custId;//客户号，（跟userType参数相关）
@property (nonatomic, copy) NSString *bankCode;//开户行代码
@property (nonatomic, copy) NSString *bankName;//开户行名称
@property (nonatomic, copy) NSString *bankCardNo;//银行卡号
@property (nonatomic, copy) NSString *bankCardType;//借贷记标识1-借记卡；2-贷记卡(即:信用卡)；
@property (nonatomic, copy) NSString *signNo;//快捷账户签约号
@property (nonatomic, copy) NSString *smallPayExpireDate;//小额支付有效期
@property (nonatomic, copy) NSString *amountTotalLimit;//总限额
@property (nonatomic, copy) NSString *amountSingleLimit;//单笔限额
@property (nonatomic, copy) NSString *bindingChannel;//签约渠道C：中国银联P：平安银行
@property (nonatomic, copy) NSString *resNo;//企业互生号

@end
