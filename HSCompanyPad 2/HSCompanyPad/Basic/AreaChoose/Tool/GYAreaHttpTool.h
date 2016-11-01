//
//  GYAreaHttpTool.h
//  company
//
//  Created by sqm on 16/3/10.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYNetwork.h"
#import "GYAddressCountryModel.h"

@interface GYAreaHttpTool : GYNetwork
/**
 *  结构树
 *
 *  @param countryNo <#countryNo description#>
 *  @param success   <#success description#>
 *  @param err       <#err description#>
 */
+ (void)queryProvinceTreeWithCountryNo:(NSString*)countryNo success:(HTTPSuccess)success failure:(HTTPFailure)err;
/**
 *  单独查一个城市
 *
 *  @param cityNo  <#cityNo description#>
 *  @param success <#success description#>
 *  @param err     <#err description#>
 */
+ (void)queryCityINfoWithNo:(NSString*)cityNo success:(HTTPSuccess)success failure:(HTTPFailure)err;
/**
 *  单独查一个省份
 *
 *  @param provinceNo <#provinceNo description#>
 *  @param success    <#success description#>
 *  @param err        <#err description#>
 */
+ (void)queryProvinceInfoWithNo:(NSString*)provinceNo success:(HTTPSuccess)success failure:(HTTPFailure)err;
/**
 *  查询国家
 *
 *  @param success <#success description#>
 *  @param err     <#err description#>
 */
+ (void)getQueryCountry:(HTTPSuccess)success failure:(HTTPFailure)err; //查询开户国家
/**
 *  查询省
 *
 *  @param countryNo <#countryNo description#>
 *  @param success   <#success description#>
 *  @param err       <#err description#>
 */
+ (void)getQueryProvinceWithCountryNo:(NSString*)countryNo success:(HTTPSuccess)success failure:(HTTPFailure)err; //查询开户省
/**
 *  查询城市
 *
 *  @param countryNo  <#countryNo description#>
 *  @param provinceNo <#provinceNo description#>
 *  @param success    <#success description#>
 *  @param err        <#err description#>
 */
+ (void)getQueryCityWithCountryNo:(NSString*)countryNo provinceNo:(NSString*)provinceNo success:(HTTPSuccess)success failure:(HTTPFailure)err; //查询开户市
/**
 *  查询城市的全名  如果conryNo不传则默认不拼接国家
 *
 *  @param countryNo  <#countryNo description#>
 *  @param provinceNo <#provinceNo description#>
 *  @param cityNo     <#cityNo description#>
 *  @param success    <#success description#>
 *  @param err        <#err description#>
 */
+ (void)queryCityNameWithCountryNo:(NSString *)countryNo provinceNo:(NSString *)provinceNo cityNo:(NSString *)cityNo success:(HTTPSuccess)success failure:(HTTPFailure)err;

@end
