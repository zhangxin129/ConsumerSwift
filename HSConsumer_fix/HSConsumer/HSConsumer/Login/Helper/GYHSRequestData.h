//
//  GYHSRequestData.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class GYHSLoginModel;
@class GYHSLocalInfoModel;
typedef void (^GYHSRequestDataBlock)(NSArray* resultArray);

typedef void (^GYHSRequestDataLoginBlock)(GYHSLoginModel* loginModel);

typedef void (^GYHSRequestDataQueryLocalInfoBlock)(GYHSLocalInfoModel* localModel);

typedef void (^GYHSRequestQueryChhineseCityBlock)(NSArray* resultAry);

typedef void (^GYHSRequestQueryProvinceCityBlock)(NSDictionary* resultDic);

typedef void (^GYHSRequestDataSendSMSCodeBlock)(BOOL result);

typedef void (^GYHSRequestDataCustGlobalDataBlock)(GYHSCustGlobalDataModel* custGlobaModel);

@interface GYHSRequestData : NSObject

- (void)clearSaveData;

- (void)clearTimer;

// 查询银行列表
- (void)queryBankList:(GYHSRequestDataBlock)resultBlock;

// 发送登录请求
- (void)sendLoginAction:(NSString*)userName pwd:(NSString*)pwd isCardUser:(BOOL)isCardUser loginBlokc:(GYHSRequestDataLoginBlock)loginBlock;

// 查询平台信息
- (void)queryLocalInfo:(GYHSRequestDataQueryLocalInfoBlock)localInfoBlock;

// 查询中国城市列表
- (void)queryChineseCitys:(NSString*)countryNo chineseCityBlock:(GYHSRequestQueryChhineseCityBlock)chineseCityBlock;

// 查询省市名称
- (void)privinceAndCityInfo:(NSString*)provinceNo
                     cityNo:(NSString*)cityNo
                resultBlock:(GYHSRequestQueryProvinceCityBlock)resultBlock;

// 发生验证码请求
- (void)sendSMSCode:(NSString*)url
           paramDic:(NSDictionary*)paramDic
             button:(UIButton*)button
            timeOut:(NSInteger)timeout
        resultBLock:(GYHSRequestDataSendSMSCodeBlock)resultBlock;

// 消费者获取全局数据
- (void)queryCustGlobalData:(GYHSRequestDataCustGlobalDataBlock)custGlobalDataBlock;

// 检查升级的处理
- (void) checkVersionUpdate:(void (^)(NSString *updateLevel))updateBlock;

@end
