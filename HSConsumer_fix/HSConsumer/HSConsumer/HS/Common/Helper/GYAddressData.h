//
//  GYAddressData.h
//  HSConsumer
//
//  Created by lizp on 16/6/16.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYProvinceModel.h"
#import "GYCityAddressModel.h"
#import "GYAddressCountryModel.h"

#define kProvinceKey @"provincesList"
#define kCityKey @"citysList"
#define kCountryKey @"CountryList"

typedef void (^arrayBlock)(NSArray* array);

@interface GYAddressData : NSObject

@property (nonatomic, copy) arrayBlock addressBlock;

+ (GYAddressData*)shareInstance;

//获取网络地址相关信息
- (void)netRequestForAddressInfo;

//通过省份代码查找省份
- (GYProvinceModel*)queryProvinceNo:(NSString*)provinceNo;

//通过城市代码查找城市
- (GYCityAddressModel*)queryCityNo:(NSString*)cityNo;

//返回省份信息
- (void)receiveProvinceInfoBlock:(arrayBlock)block;

//返回城市信息
- (void)receiveCityInfoBlock:(arrayBlock)block;

//通过cityFullName查找该数据的模型
- (GYCityAddressModel*)selectWithCityFullName:(NSString*)cityFullName;

//根据拼音全拼或者首拼搜索或者汉字
- (NSMutableArray*)selectAddressWithString:(NSString*)pinYinName;

//返回所有城市
- (NSMutableArray*)selectAllCitys;

//返回所有省份
- (NSMutableArray*)selectAllProvinces;

//通过通过省份代码查找所有该省份下的城市
- (NSMutableArray*)selectCitysByProvinceNo:(NSString*)provinceNo;

//获取全部国家存入本地
- (void)netRequestForCountrys:(void (^)(void))complete;

//通过国家代码查找国家
- (GYAddressCountryModel*)queryCountry:(NSString*)countryNo;

//通过国家名称返回模型
- (GYAddressCountryModel*)queryCountryName:(NSString*)countryName;

//返回所有国家
- (NSMutableArray*)selectAllCountrys;

//返回本地国家
-(NSMutableArray *)selectLocalCountry;

// 清理缓存的数据
- (void) clearData;

// 对省数据的合法性检查
- (BOOL)checkProvinceValid:(NSArray*)dataAry;

// 对城市数据的合法性检查
- (BOOL)checkCityValid:(NSArray*)dataAry;

// 对国家数据的合法性检查
- (BOOL)checkCountryValid:(NSArray *)dataAry;

// 清除指定key的数据
- (void)clearDataByKey:(NSString*)dataKey;

@end
