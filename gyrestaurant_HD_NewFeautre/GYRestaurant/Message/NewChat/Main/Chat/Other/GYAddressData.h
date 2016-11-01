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

//通过string查询包含某个字的地区
- (NSMutableArray*)selectAddressWithString:(NSString*)string;

//返回所有城市
- (NSMutableArray*)selectAllCitys;

//返回所有省份
- (NSMutableArray*)selectAllProvinces;

//通过通过省份代码查找所有该省份下的城市
- (NSMutableArray*)selectCitysByProvinceNo:(NSString*)provinceNo;

// 清理缓存的数据
- (void) clearData;

#pragma mark - 网络获取省份、城市 信息
- (void)netRequestAddressInfo:(void (^)(NSArray* provinceAry, NSArray* cityAry))complete;

@end
