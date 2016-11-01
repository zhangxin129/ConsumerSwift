//
//  GYUtilsConst.h
//  company
//
//  Created by sqm on 16/3/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>


//分割线条颜色
#define kDefaultViewBorderColor kRGBA(200, 200, 200, 1) //(230, 230, 230, 1)

#pragma mark - 外部第三方库配置
FOUNDATION_EXPORT NSString* const GYUMengReleaseKey;//友盟生产
FOUNDATION_EXPORT NSString* const GYUMengDebugKey;//友盟测试
FOUNDATION_EXPORT NSString* const GYBaiduMapReleaseKey;//百度地图

#pragma mark - 网络相关的key
FOUNDATION_EXPORT NSString* const GYNetWorkCodeKey;
FOUNDATION_EXPORT NSString* const GYNetWorkDataKey;


#pragma mark - 易联支付配置参数



FOUNDATION_EXPORT NSString* const GYYLPayExchangeHSB;//兑换互生币
FOUNDATION_EXPORT NSString* const GYYLPayPersonalityCard;//个性定制卡服务费
FOUNDATION_EXPORT NSString* const GYYLPayAnnualFee;//年费
FOUNDATION_EXPORT NSString* const GYYLPayPurchaseTool;//工具申购
FOUNDATION_EXPORT NSString* const GYYLPayPurchaseHSCard;//消费者资源申购


#pragma mark - 系统常量配置
FOUNDATION_EXPORT NSString* const GYChannelType;

#pragma mark - 用户类型
FOUNDATION_EXPORT NSString* const GYUserTypeCompany;
FOUNDATION_EXPORT NSString* const GYUserTypeOperater;

FOUNDATION_EXPORT NSString* const GYLoginResNoKey;


#pragma mark - 二维码类型
FOUNDATION_EXPORT NSString* const GY_PointCode;
FOUNDATION_EXPORT NSString* const GY_ConsumptionCode;

//消费者资源段每段的卡数量
UIKIT_EXTERN NSInteger const GYPerSegmentHsCardCount;
//消费者资源申购的code代号
FOUNDATION_EXPORT NSString* const GYHSCardPurchaseCode;

#pragma mark - 本地存取文件
//FOUNDATION_EXPORT NSString* const GY_LoginModelPath;
FOUNDATION_EXPORT NSString* const GY_CityAdressModelArrMPath;
FOUNDATION_EXPORT NSString* const GY_ProvinceAdressModelArrMPath;
//FOUNDATION_EXPORT NSString* const GY_BankInfoPath;
FOUNDATION_EXPORT NSString* const GY_AddressCountryModelArrMPath;
//FOUNDATION_EXPORT NSString* const GY_USERINFOPATH;

//距离上、下、左、右 默认的距离
UIKIT_EXTERN CGFloat const kDefaultMarginToBounds;

#pragma mark - 业务办理工具申购 请求的参数
FOUNDATION_EXPORT NSString* const GY_Business_SWIPE_CARD;
FOUNDATION_EXPORT NSString* const GY_Business_CARD;

#pragma mark - 语言
FOUNDATION_EXPORT NSString* const GY_CHINESE;
FOUNDATION_EXPORT NSString* const GY_TRADITIONAL;
FOUNDATION_EXPORT NSString* const GY_ENGLISH;

#pragma mark - 支付方式
FOUNDATION_EXPORT NSString *const GYPayChannelUPPay;
FOUNDATION_EXPORT NSString *const GYPayChannelMobliePay;
FOUNDATION_EXPORT NSString *const GYPayChannelQuickPay;
FOUNDATION_EXPORT NSString *const GYPayChannelBankPay;
FOUNDATION_EXPORT NSString *const GYPayChannelHSBPay;

#pragma mark - pos机器传设备类型参数
FOUNDATION_EXPORT NSString* const GYPOSDeviceMoblie;
FOUNDATION_EXPORT NSString* const GYPOSDeviceCardReader;


extern NSArray      *EncodeArrayFromDicUsingParseBlock(NSDictionary *dic, NSString *key, id(^parseBlock)(NSDictionary *innerDic));

extern NSArray      *EncodeArrayFromDic(NSDictionary *dic, NSString *key);
