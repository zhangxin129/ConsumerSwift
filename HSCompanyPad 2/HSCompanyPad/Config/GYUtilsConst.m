//
//  GYUtilsConst.m
//  company
//
//  Created by sqm on 16/3/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYUtilsConst.h"
#pragma mark - 外部第三方库配置
NSString* const GYUMengReleaseKey = @"5760f57567e58e58fa0023a8";//友盟生产
NSString* const GYUMengDebugKey = @"577dcab367e58e5ba4003812";//友盟测试
NSString* const GYBaiduMapReleaseKey = @"fvoXnKLPGiHgq2l1IDbhyrAT1YHyly7A";//百度地图

#pragma mark - 网络相关的key
NSString* const GYNetWorkCodeKey = @"retCode";
NSString* const GYNetWorkDataKey = @"data";

#pragma mark 系统配置常量
NSString* const GYChannelType = @"5";


NSString* const GYYLPayExchangeHSB = @"HSXT_AO_0001";//兑换互生币
NSString* const GYYLPayPersonalityCard = @"HSXT_BS_0002";//个性定制卡服务费
NSString* const GYYLPayAnnualFee = @"HSXT_BS_0003"; //年费
NSString* const GYYLPayPurchaseTool = @"HSXT_BS_0004";//工具申购
NSString* const GYYLPayPurchaseHSCard = @"HSXT_BS_0005";//消费者资源申购

#pragma mark - 二维码类型
NSString* const GY_PointCode = @"11";
NSString* const GY_ConsumptionCode = @"21";

#pragma mark - 用户类型
NSString* const GYUserTypeCompany = @"4";
NSString* const GYUserTypeOperater = @"3";
NSString* const GYLoginResNoKey = @"com.hsxt.HSCompanyPad.GYLoginResNoKey";


#pragma mark - pos机器传设备类型参数

NSString* const GYPOSDeviceMoblie = @"6";
NSString* const GYPOSDeviceCardReader = @"3";

//消费者资源段每段的卡数量
NSInteger const GYPerSegmentHsCardCount = 1000;

NSString* const GYPayChannelUPPay = @"100";
NSString* const GYPayChannelMobliePay = @"101";
NSString* const GYPayChannelQuickPay = @"102";
NSString* const GYPayChannelBankPay = @"103";
NSString* const GYPayChannelHSBPay = @"200";

NSString* const GYHSCardPurchaseCode = @"P_CARD";

#pragma mark - 本地存取文件
//NSString* const GY_LoginModelPath = @"com.guiyi.company.GY_LoginModelPath";
NSString* const GY_CityAdressModelArrMPath = @"com.guiyi.company.GY_CityAdressModelArrMPath";
NSString* const GY_ProvinceAdressModelArrMPath = @"com.guiyi.company.GY_ProvinceAdressModelArrMPath";
//NSString* const GY_BankInfoPath = @"com.guiyi.company.GY_BankInfoPath";
NSString* const GY_AddressCountryModelArrMPath = @"com.guiyi.company.GY_AddressCountryModelArrMPath";
//NSString* const GY_USERINFOPATH = @"com.guiyi.company.GY_USERINFOPATH";

CGFloat const kDefaultMarginToBounds = 16;

#pragma mark - 业务办理工具申购 请求的参数
NSString* const GY_Business_SWIPE_CARD = @"SWIPE_CARD";
NSString* const GY_Business_CARD = @"CARD";

#pragma mark 语言
NSString* const GY_CHINESE = @"zh-Hans";
NSString* const GY_TRADITIONAL = @"zh-Hant";
NSString* const GY_ENGLISH = @"en";

NSArray      *EncodeArrayFromDic(NSDictionary *dic, NSString *key)
{
    id temp = [dic objectForKey:key];
    if ([temp isKindOfClass:[NSArray class]])
    {
        return temp;
    }
    return nil;
}

NSArray      *EncodeArrayFromDicUsingParseBlock(NSDictionary *dic, NSString *key, id(^parseBlock)(NSDictionary *innerDic))
{
    NSArray *tempList = EncodeArrayFromDic(dic, key);
    if ([tempList count])
    {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[tempList count]];
        for (NSDictionary *item in tempList)
        {
            id dto = parseBlock(item);
            if (dto) {
                [array addObject:dto];
            }
        }
        return array;
    }
    return nil;
}
