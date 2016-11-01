//
//  GYHSPointReturnModel.h
//  HSCompanyPad
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHSPointReturnModel : NSObject

/**互生卡号*/
@property (nonatomic,copy) NSString *strHSCardNum;
/**暗码*/
@property (nonatomic,copy) NSString *strCipherNum;
/**posNo*/
@property (nonatomic,copy) NSString *strPosNo;
/**交易流水号*/
@property (nonatomic,copy) NSString *strDealNum;
/**交易时间*/
@property (nonatomic,copy) NSString *strDealTime;
/**交易类型*/
@property (nonatomic,copy) NSString *strDealType;
/**交易类型名*/
@property (nonatomic,copy) NSString *strDealTypeName;
/**消费金额*/
@property (nonatomic,copy) NSString *strConsumptionMoney;
/**分配积分数*/
@property (nonatomic,copy) NSString *strPointMoney;
/**批次号*/
@property (nonatomic,copy) NSString *strBatchNo;
/**终端流水号*/
@property (nonatomic,copy) NSString *strPosRunCode;

/**撤单预付款金额*/
@property (nonatomic,copy) NSString *strAssureOutValue;
/**消费者客户号*/
@property (nonatomic,copy) NSString *strCardCustId;
/**电商流水号*/
@property (nonatomic,copy) NSString *strOriginNo;

@property (nonatomic, copy) NSString *batchNo;
@property (nonatomic, copy) NSString *entCustId;
@property (nonatomic, copy) NSString *entPoint;
@property (nonatomic, copy) NSString *entResNo;
@property (nonatomic, copy) NSString *perCustId;
@property (nonatomic, copy) NSString *perPoint;
@property (nonatomic, copy) NSString *perResNo;
@property (nonatomic, copy) NSString *pointRate;
@property (nonatomic, copy) NSString *sourceCurrencyCode;
@property (nonatomic, copy) NSString *sourceTransAmount;
@property (nonatomic, copy) NSString *sourceTransDate;
@property (nonatomic, copy) NSString *sourceTransNo;
@property (nonatomic, copy) NSString *transAmount;
@property (nonatomic, copy) NSString *transNo;
@property (nonatomic, copy) NSString *transType;
@property (nonatomic, copy) NSString * orderAmount;//实付金额


@end
