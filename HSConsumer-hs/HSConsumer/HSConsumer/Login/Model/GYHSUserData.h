//
//  UserData.h
//  HSConsumer
//
//  Created by apple on 14-10-10.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//用户信息类
@interface GYHSUserData : NSObject

/****************以下是有卡用户的属性******************/

@property (assign, nonatomic) double pointAccBal; //*积分账户余额
@property (assign, nonatomic) double cashAccBal; //*现金账户余额
@property (assign, nonatomic) double HSDToCashAccBal; //*互生币账户流通币余额
@property (assign, nonatomic) double HSDConAccBal; //*互生币账户消费币余额
@property (assign, nonatomic) double investAccTotal; //*投资账户总数

@property (assign, nonatomic) double grandTotalPointAmount; //累计积分总数
@property (assign, nonatomic) double availablePointAmount; //*可用积分
@property (assign, nonatomic) double todayPointAmount; //*今日积分
@property (assign, nonatomic) double minPointToCashAmount; //*积分转货币最低值
@property (assign, nonatomic) double minPointToInvest; //*个人积分投资最低值
@property (assign, nonatomic) double minHSDTransferToCash; //*个人互生币转现最低数
@property (assign, nonatomic) double minHSDTransferToConsume; //*个人互生币转消费最低数
@property (assign, nonatomic) double minPointToHSD; //个人积分转互生币最低数

@property (assign, nonatomic) double hsdToCashCurrencyConversionFee; //*互生币转货币转换费比率
@property (assign, nonatomic) double investmentDividendsTotal; //*投资分红总额
@property (assign, nonatomic) double investAccToHSDToCashAccTotal; //*投资账户转入流通币总数
@property (assign, nonatomic) double investAccToHSDToConAccTotal; //*投资账户转入消费币总数

@property (assign, nonatomic) double pointForReachAccidentalInjuriesSafeguard; //达到意外伤害保障积分数
@property (assign, nonatomic) double pointForReachFreeMedicalSubsidy; //达到免费医疗补贴积分数

@property (assign, nonatomic) BOOL isNeedRefresh; //*完成业务操作后，是否要刷新本地数据
@property (assign, nonatomic) int dailyBuyHsbMaxmum; //个人购互生币每日上限
@property (assign, nonatomic) int todayBuyHsbTotalAmount;     //个人购互生币每日上限
@property (assign, nonatomic) int notRegisteredBuyHsbMaxmum;   //*未实名注册用户购互生币单笔最高
@property (assign, nonatomic) int notRegisteredBuyHsbMinimum;  //*未实名注册用户购互生币单笔最少
@property (assign, nonatomic) int registeredBuyHsbMaxmum;      //*实名注册用户购互生币单笔最高
@property (assign, nonatomic) int registeredBuyHsbMinimum;     //*实名注册用户购互生币单笔最少

@end

