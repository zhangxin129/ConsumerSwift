//
//  GYAreaHttpTool.m
//  company
//
//  Created by sqm on 16/3/10.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAreaHttpTool.h"
#import "GYAddressCountryModel.h"
#import <MJExtension/MJExtension.h>

@implementation GYAreaHttpTool
+ (void)queryProvinceTreeWithCountryNo:(NSString*)countryNo success:(HTTPSuccess)success failure:(HTTPFailure)err
{
    NSArray* cityAddressArr = (NSArray*)[GYUtils readFromPath:GY_CityAdressModelArrMPath];
    NSArray* provinceAddressArr = (NSArray*)[GYUtils readFromPath:GY_ProvinceAdressModelArrMPath];
    
    if (cityAddressArr.count > 0 && provinceAddressArr.count > 0) { //如果本地已经存在则不再获取
    
        KExcuteBlock(success, @{ GY_CityAdressModelArrMPath : cityAddressArr, GY_ProvinceAdressModelArrMPath : provinceAddressArr });
        return;
    }
    
    [self GET:GY_HSDOMAINAPPENDING(GYHSQueryProvinceTree) parameter:@{ @"countryNo" : countryNo } success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue)) {
            NSMutableArray *cityAdressModelArrM = @[].mutableCopy;
            NSMutableArray *provinceModelArrM = @[].mutableCopy;
            for (NSDictionary *addressDict in returnValue[GYNetWorkDataKey]) {
                for (NSDictionary *cityDict in addressDict[@"citys"]) {
                    GYCityAddressModel *cityModel = [GYCityAddressModel mj_objectWithKeyValues:cityDict];
                    [cityAdressModelArrM addObject:cityModel];
                    
                }
                
                GYProvinceModel *provinceModel = [GYProvinceModel mj_objectWithKeyValues:addressDict[@"province"]];
                [provinceModelArrM addObject:provinceModel];
                
            }
            KExcuteBlock(success,@{GY_CityAdressModelArrMPath:cityAdressModelArrM,GY_ProvinceAdressModelArrMPath:provinceModelArrM});
            [GYUtils writeModel:cityAdressModelArrM toPath:GY_CityAdressModelArrMPath];
            [GYUtils writeModel:provinceModelArrM toPath:GY_ProvinceAdressModelArrMPath];
        }else {
            
            KExcuteBlock(err,nil);
        }

    } failure:^(NSError *error) {
        
    }];
}

+ (void)queryCityINfoWithNo:(NSString*)cityNo success:(HTTPSuccess)success failure:(HTTPFailure)err
{
       
    [self queryProvinceTreeWithCountryNo:globalData.loginModel.countryCode success:^(id responsObject) {
    
    NSMutableArray *cityAdressModelArrM  = (NSMutableArray *) responsObject[GY_CityAdressModelArrMPath];
    if ([cityAdressModelArrM count] > 0) {
        for (GYCityAddressModel *model in cityAdressModelArrM) {
            if ([model.cityNo isEqualToString:cityNo]) {
                success(model);
                break;
            }
        }
    }
    
    } failure:nil];
}

+ (void)queryProvinceInfoWithNo:(NSString*)provinceNo success:(HTTPSuccess)success failure:(HTTPFailure)err
{

    [self queryProvinceTreeWithCountryNo:globalData.loginModel.countryCode success:^(id responsObject) {
        NSMutableArray *cityAdressModelArrM  = (NSMutableArray *) responsObject[GY_ProvinceAdressModelArrMPath];
        if ([cityAdressModelArrM count] > 0) {
            for (GYProvinceModel *model in cityAdressModelArrM) {
                if ([model.provinceNo isEqualToString:provinceNo]) {
                    success(model);
                    break;
                }
            }
        }
        
    } failure:nil];
}

+ (void)getQueryCountry:(HTTPSuccess)success failure:(HTTPFailure)err
{
    NSArray* countryArr = (NSArray*)[GYUtils readFromPath:GY_AddressCountryModelArrMPath];
    if (countryArr.count > 0) {
        KExcuteBlock(success, countryArr);
        return;
    }
    [self GET:GY_HSDOMAINAPPENDING(GYHSQueryCountry) parameter:nil success:^(id returnValue) {
        if(kHTTPSuccessResponse(returnValue)){
            NSMutableArray *data = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in returnValue[GYNetWorkDataKey]) {
                GYAddressCountryModel *model = [GYAddressCountryModel mj_objectWithKeyValues:dic];
                [data addObject:model];
            }
            [GYUtils writeModel:data toPath:GY_AddressCountryModelArrMPath];
            
            KExcuteBlock(success,data)
        }else{
            KExcuteBlock(err,nil)
        }

    } failure:^(NSError *error) {
        
    }];
    
}

+ (void)getQueryProvinceWithCountryNo:(NSString*)countryNo success:(HTTPSuccess)success failure:(HTTPFailure)err
{

    [self queryProvinceTreeWithCountryNo:globalData.loginModel.countryCode success:^(id responsObject) {
        NSMutableArray *cityAdressModelArrM  = (NSMutableArray *) responsObject[GY_ProvinceAdressModelArrMPath];
        if (cityAdressModelArrM.count > 0) {
             KExcuteBlock(success,cityAdressModelArrM);
        }else {
            KExcuteBlock(err,nil);
        }
        
    } failure:^{
           KExcuteBlock(err,nil);
    }];
}

+ (void)getQueryCityWithCountryNo:(NSString*)countryNo provinceNo:(NSString*)provinceNo success:(HTTPSuccess)success failure:(HTTPFailure)err
{
    [self queryProvinceTreeWithCountryNo:globalData.loginModel.countryCode success:^(id responsObject) {
        NSMutableArray *cityAdressModelArrM  = (NSMutableArray *) responsObject[GY_CityAdressModelArrMPath];
        if ([cityAdressModelArrM count] > 0) {
            NSMutableArray *selectedCityArrM = @[].mutableCopy;
            for (GYCityAddressModel *model in cityAdressModelArrM) {
                if ([model.provinceNo isEqualToString:provinceNo]) {
                    [selectedCityArrM addObject:model];
                }
            }
            KExcuteBlock(success,selectedCityArrM);
        }else {
            KExcuteBlock(err,nil);
            
        }
        
    } failure:^{
        KExcuteBlock(err,nil);
    }];
}

/**
 *  查询城市的全名  如果conryNo不传则默认不拼接国家
 *
 *  @param countryNo  <#countryNo description#>
 *  @param provinceNo <#provinceNo description#>
 *  @param cityNo     <#cityNo description#>
 *  @param success    <#success description#>
 *  @param err        <#err description#>
 */
+ (void)queryCityNameWithCountryNo:(NSString*)countryNo provinceNo:(NSString*)provinceNo cityNo:(NSString*)cityNo success:(HTTPSuccess)success failure:(HTTPFailure)err
{
 __block NSString *cityFullName = @"";
    if (countryNo) {
        [self getQueryCountry:^(id responsObject) {
       
        for (GYAddressCountryModel *countryModel in responsObject) {
            if ([countryModel.countryNo isEqualToString:countryNo]) {
            cityFullName = [cityFullName stringByAppendingString:countryModel.countryName];
            [self getQueryProvinceWithCountryNo:countryNo ? countryNo :globalData.loginModel.countryCode success:^(id responsObject) {
            for (GYProvinceModel *provinceModel in responsObject) {
                if ([provinceModel.provinceNo isEqualToString:provinceNo]) {
                    cityFullName = [cityFullName stringByAppendingString:provinceModel.provinceNameCn];
                    [self getQueryCityWithCountryNo:globalData.loginModel.countryCode provinceNo:provinceNo success:^(id responsObject) {
                        for (GYCityAddressModel *cityModel in responsObject) {
                        if ([cityModel.cityNo isEqualToString:cityNo]) {
                        cityFullName = [cityFullName stringByAppendingString:cityModel.cityNameCn];
                        KExcuteBlock(success, cityFullName);
                        break;
                                        }
                                    }
                                } failure:nil];
                                break;
                            }
                        }
                    } failure:nil];
                    break;
                }
            }
        } failure:nil];
    }else {
        [self getQueryProvinceWithCountryNo:countryNo ? countryNo :globalData.loginModel.countryCode success:^(id responsObject) {
            for (GYProvinceModel *provinceModel in responsObject) {
                if ([provinceModel.provinceNo isEqualToString:provinceNo]) {
                    cityFullName = [cityFullName stringByAppendingString:provinceModel.provinceNameCn];
                    [self getQueryCityWithCountryNo:globalData.loginModel.countryCode provinceNo:provinceNo success:^(id responsObject) {
                        for (GYCityAddressModel *cityModel in responsObject) {
                            if ([cityModel.cityNo isEqualToString:cityNo]) {
                                cityFullName = [cityFullName stringByAppendingString:cityModel.cityNameCn];
                                KExcuteBlock(success, cityFullName);
                                break;
                            }
                        }
                    } failure:nil];
                    break;
                }
            }
        } failure:nil];
    
    
    }
 
}
@end
