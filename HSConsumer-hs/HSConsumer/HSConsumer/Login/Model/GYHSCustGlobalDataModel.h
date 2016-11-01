//
//  GYCustGlobalDataModel.h
//  HSConsumer
//
//  Created by wangfd on 16/6/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel+LoadData.h"

@interface GYHSCustGlobalDataModel : JSONModel <NSCoding>

//互生意外伤害补贴最大限额（每次）
@property (nonatomic, strong) NSString* accidentTimesMax;

//互生意外伤害补贴最大限额（每年）
@property (nonatomic, strong) NSString* accidentYearMax;

// 银行卡绑定数量
@property (nonatomic, strong) NSString* bankCardBindCount;

// 国家代码
@property (nonatomic, strong) NSString* countryNo;

// 币种代码
@property (nonatomic, strong) NSString* currencyCode;

// 币种英文名称
@property (nonatomic, strong) NSString* currencyEnName;

// 币种中文名称
@property (nonatomic, strong) NSString* currencyName;

// 货币转互生币比率
@property (nonatomic, strong) NSString* currencyToHsbRate;

// 享受意外保障福利需累计消费积分的阀值
@property (nonatomic, strong) NSString* consumeThresholdPoint;

//个人单日货币转银行最大限额
@property (nonatomic, strong) NSString* dayHbToBankMax;

//意外身故补贴有效期
@property (nonatomic, strong) NSString* deathExpiry;

//意外身故补贴最大限额
@property (nonatomic, strong) NSString* deathYearMax;

// 连续失效的天数 致使意外保障失效
@property (nonatomic, strong) NSString* durInvalidDays;

//免费医疗补贴年度赔付上限
@property (nonatomic, strong) NSString* freeMedicalMax;

//个人单笔货币转银行审核最小限额
@property (nonatomic, strong) NSString* hbToBankCheckMin;

//个人货币转银行单日有效交易次数
@property (nonatomic, strong) NSString* hbToBankCheckNum;

//个人单笔货币转银行最大限额
@property (nonatomic, strong) NSString* hbToBankMax;

//个人单笔货币转银行最小限额
@property (nonatomic, strong) NSString* hbToBankMin;

// 互生币转货币单次最低限额
@property (nonatomic, strong) NSString* hsbToHbMin;

// 互生币转货币手续费比率
@property (nonatomic, strong) NSString *hsbToHbRate;

//个人单笔积分投资最小限额
@property (nonatomic, strong) NSString *investPointMin;

@property (nonatomic, strong) NSString *investThresholdPoint;

//个人单笔积分汇兑最小限额
@property (nonatomic, strong) NSString *pointMin;

@property (nonatomic, strong) NSString *pointSave;

// 积分转互生币比率, 客户端本地使用，服务端没有给
@property (nonatomic, copy) NSString *integralTransferToHsbRate;

@end
