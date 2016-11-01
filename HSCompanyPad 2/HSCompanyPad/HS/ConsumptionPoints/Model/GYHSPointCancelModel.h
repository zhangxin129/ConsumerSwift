//
//  GYHSPointCancelModel.h
//  HSCompanyPad
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYHSPointCancelModel : JSONModel
@property (nonatomic,copy) NSString * entResNo;//企业互生号
@property (nonatomic,copy) NSString * entCustId;//企业客户号
@property (nonatomic,copy) NSString * perResNo;//消费者互生号
@property (nonatomic,copy) NSString * perCustId;//消费者客户号
@property (nonatomic,copy) NSString * sourceTransNo;//原始交易号
@property (nonatomic,copy) NSString * transNo;//交易流水号
@property (nonatomic,copy) NSString * transType;//交易类型(消费积分系统积分单号)
@property (nonatomic,copy) NSString * sourceCurrencyCode;//原始币种代号
@property (nonatomic,copy) NSString * sourceTransAmount;//原始交易金额(退货消费金额)
@property (nonatomic,copy) NSString * transAmount;//交易金额(消费金额/退货金额)
@property (nonatomic,copy) NSString * pointRate;//积分比例
@property (nonatomic,copy) NSString * perPoint;//消费者积分(积分金额)
@property (nonatomic,copy) NSString * entPoint;//企业积分应付款(积分金额退回)
@property (nonatomic,copy) NSString * batchNo;//批次号
@property (nonatomic,copy) NSString * sourceTransDate;//原始交易时间
@property (nonatomic,assign) BOOL isSelect;//标记被选中


@end
