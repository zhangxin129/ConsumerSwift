//
//  GYHSAlternateModel.h
//  GYHSConsumer_MyHS
//
//  Created by liss on 16/3/30.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYHSAlternateModel : JSONModel
/**银行卡最大数量*/
@property (nonatomic, copy) NSString* bankCardCount;

@property (nonatomic, copy) NSString* cashTransferToBank;
/**货币转银行的最小交易金额*/
@property (nonatomic, copy) NSString* cashTransferToBankMinimum;
/**货币代码*/
@property (nonatomic, copy) NSString* currencyCode;
/**货币转换率*/
@property (nonatomic, copy) NSString* currencyConversionFee;
/**货币英文名称*/
@property (nonatomic, copy) NSString* currencyEnName;
/**货币中文名称*/
@property (nonatomic, copy) NSString* currencyName;
//货币转换比率
@property (nonatomic, copy) NSString* currencyToHsbRate;

@property (nonatomic, copy) NSString* dailyBuyHsbMaxmum;
/**文件服务器地址*/
@property (nonatomic, copy) NSString* fileHttpUrl;
/**互生币转现最小交易金额*/
@property (nonatomic, copy) NSString* hsbTransferToCashMinimum;

@property (nonatomic, copy) NSString* hsbTransferToConsumeMinimum;
@property (nonatomic, copy) NSString* integralToCashMinimum;
/**积分转互生币最小交易金额*/
@property (nonatomic, copy) NSString* integralToHsbMinimum;
/**积分转投资账户最小交易金额*/
@property (nonatomic, copy) NSString* integralToInvestMinimum;
/**积分转互生币比率*/
@property (nonatomic, copy) NSString* integralTransferToHsbRate;

@property (nonatomic, copy) NSString* notRegisteredBuyHsbMaxmum;
@property (nonatomic,copy) NSString *notRegisteredBuyHsbMinimum;
@property (nonatomic,copy) NSString *registeredBuyHsbMaxmum;
@property (nonatomic,copy) NSString *registeredBuyHsbMinimum;

@end
