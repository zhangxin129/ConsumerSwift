//
//  GYAddressData.m
//  HSConsumer
//
//  Created by lizp on 16/6/16.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAddressData.h"
#import "GYCityAddressModel.h"
#import "GYProvinceModel.h"

@implementation GYAddressData

+ (GYAddressData*)shareInstance
{
    static dispatch_once_t onceToken;
    static GYAddressData* address;
    dispatch_once(&onceToken, ^{
        address = [[GYAddressData alloc] init];
    });
    return address;
}

#pragma mark - 通过省份代码查找省份
- (GYProvinceModel*)queryProvinceNo:(NSString*)provinceNo
{

    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kProvinceKey];
    if (data) {
        NSArray* provinceArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([GYUtils checkArrayInvalid:provinceArr]) {
            DDLogDebug(@"the provinceArr is empty.");
            return nil;
        }

        for (GYProvinceModel* model in provinceArr) {
            if ([provinceNo isEqualToString:model.provinceNo]) {
                return model;
                break;
            }
        }
    }
    return nil;
}

#pragma mark - 通过城市代码查找城市
- (GYCityAddressModel*)queryCityNo:(NSString*)cityNo
{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kCityKey];
    if (data) {
        NSArray* cityArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([GYUtils checkArrayInvalid:cityArr]) {
            DDLogDebug(@"the cityArr is empty.");
            return nil;
        }
        for (GYCityAddressModel* model in cityArr) {
            if ([cityNo isEqualToString:model.cityNo]) {
                return model;
                break;
            }
        }
    }
    return nil;
}

#pragma mark - 网络获取省份、城市 信息
- (void)netRequestAddressInfo:(void (^)(NSArray* provinceAry, NSArray* cityAry))complete
{
    [Network GET:kUrlAllCity parameters:@{ @"countryNo" : kSaftToNSString(globalData.localInfoModel.countryNo) } completion:^(NSDictionary* responseObject, NSError* error) {
         
         if (error || ([responseObject[@"retCode"] integerValue] != 200)) {
             DDLogDebug(@"获取城市列表失败");
             
             if(complete) {
                 complete(nil, nil);
             }
             
             return;
         }
         
         NSMutableArray *cityMarr = [NSMutableArray array];
         NSMutableArray *provinceMarr = [NSMutableArray array];
         NSArray *serverAry = responseObject[@"data"];
         
         if([GYUtils checkArrayInvalid:serverAry]) {
             DDLogInfo(@"the serverAry is empty.");
             if(complete) {
                 complete(nil, nil);
             }
             return ;
         }
         
         for (NSDictionary *tempDic in serverAry) {
             
             for (NSDictionary *dic in tempDic[@"citys"]) {
                 GYCityAddressModel *model = [[GYCityAddressModel alloc] initWithDic:dic];
                 [cityMarr addObject:model];
             }
             
             GYProvinceModel *model = [[GYProvinceModel alloc] initWithDictionary:tempDic[@"province"] error:nil];
             [provinceMarr addObject:model];
         }

        
         if([cityMarr count] <= 0 || [provinceMarr count] <= 0) {
             DDLogDebug(@"the cityArr or provinceArr  is empty.");
             if(complete) {
                 complete(nil, nil);
             }
             return ;
         }
        
        if ([self checkProvinceValid:provinceMarr] && [self checkCityValid:cityMarr]) {
            NSData *cityData = [NSKeyedArchiver archivedDataWithRootObject:cityMarr];
            [[NSUserDefaults standardUserDefaults] setObject:cityData forKey:kCityKey];
            
            NSData *provinceData = [NSKeyedArchiver archivedDataWithRootObject:provinceMarr ];
            [[NSUserDefaults standardUserDefaults] setObject:provinceData forKey:kProvinceKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
         if(complete) {
             complete(provinceMarr, cityMarr);
         }
    }];
}

#pragma mark - 返回省份信息
- (void)receiveProvinceInfoBlock:(arrayBlock)block
{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kProvinceKey];
    NSArray* provinceAry = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    if (![self checkProvinceValid:provinceAry]) {
        [self clearDataByKey:kProvinceKey];
        provinceAry = [NSArray array];
    }

    if ([provinceAry count] > 0) {
        if (block) {
            block(provinceAry);
        }
    }
    else {
        [self netRequestAddressInfo:^(NSArray* provinceAry, NSArray* cityAry) {
            if ([GYUtils checkArrayInvalid:provinceAry]) {
                DDLogDebug(@"The provinceAry is empty.");
                return;
            }
            
            if (block) {
                block(provinceAry);
            }
        }];
    }
}

#pragma mark - 返回城市信息
- (void)receiveCityInfoBlock:(arrayBlock)block
{

    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kCityKey];
    NSArray* cityAry = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    if (![self checkCityValid:cityAry]) {
        [self clearDataByKey:kCityKey];
        cityAry = [NSArray array];
    }

    if ([cityAry count] > 0) {
        if (block) {
            block(cityAry);
        }
    }
    else {
        [self netRequestAddressInfo:^(NSArray* provinceAry, NSArray* cityAry) {
            if ([GYUtils checkArrayInvalid:cityAry]) {
                DDLogDebug(@"The cityAry is empty.");
                return;
            }
            
            if (block) {
                block(cityAry);
            }
        }];
    }
}

#pragma mark - 获取网络地址相关信息
- (void)netRequestForAddressInfo
{
    [self netRequestAddressInfo:nil];
}

#pragma mark - 通过cityFullName查找该数据的模型
- (GYCityAddressModel*)selectWithCityFullName:(NSString*)cityFullName
{

    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kCityKey];
    if (data) {
        NSArray* cityArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([GYUtils checkArrayInvalid:cityArr]) {
            DDLogInfo(@"the cityArr is empty.");
            return nil;
        }

        for (GYCityAddressModel* model in cityArr) {
            if ([model.cityFullName isEqualToString:cityFullName]) {
                return model;
                break;
            }
        }
    }
    return nil;
}

#pragma mark - 根据拼音全拼或者首拼搜索或者汉字
- (NSMutableArray*)selectAddressWithString:(NSString*)pinYinName
{
    pinYinName = [pinYinName lowercaseString];
    NSMutableArray* pinYinMarr = [NSMutableArray array];
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kCityKey];
    if (data) {
        NSArray* cityArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([GYUtils checkArrayInvalid:cityArr]) {
            DDLogDebug(@"the cityArr is empty.");
            return nil;
        }
        for (GYCityAddressModel* model in cityArr) {
            if ([model.cityPinYin containsString:pinYinName] || [model.cityFirstLetterPinYin containsString:pinYinName] || [model.cityName containsString:pinYinName]) {
                [pinYinMarr addObject:model];
            }
        }

        if (![GYUtils checkArrayInvalid:pinYinMarr]) {
            return pinYinMarr;
        }
        return nil;
    }
    return nil;
}

#pragma mark - 返回所有城市
- (NSMutableArray*)selectAllCitys
{

    NSMutableArray* allCitys = [NSMutableArray array];
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kCityKey];
    if (data) {
        allCitys = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([GYUtils checkArrayInvalid:allCitys]) {
            DDLogInfo(@"the allCitys is empty.");
            return nil;
        }
    }

    return allCitys;
}

#pragma mark - 返回所有省份
- (NSMutableArray*)selectAllProvinces
{
    NSMutableArray* allProvinces = [NSMutableArray array];
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kProvinceKey];
    if (data) {
        allProvinces = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([GYUtils checkArrayInvalid:allProvinces]) {
            DDLogInfo(@"the allProvinces is empty.");
            return nil;
        }
    }

    return allProvinces;
}

#pragma mark - 通过通过省份代码查找所有该省份下的城市
- (NSMutableArray*)selectCitysByProvinceNo:(NSString*)provinceNo
{

    NSMutableArray* citysMarr = [NSMutableArray array];
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kCityKey];
    if (data) {
        NSArray* cityArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([GYUtils checkArrayInvalid:cityArr]) {
            DDLogInfo(@"the allProvinces is empty.");
            return nil;
        }

        for (GYCityAddressModel* model in cityArr) {
            if ([provinceNo isEqualToString:model.provinceNo]) {
                [citysMarr addObject:model];
            }
        }
    }
    return citysMarr;
}

#pragma mark - 获取全部国家存入本地
- (void)netRequestForCountrys:(void (^)(void))complete
{

    [Network GET:kUrlQueryCountry parameters:nil completion:^(NSDictionary* responseObject, NSError* error) {
        if (!error) {
            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(concurrentQueue, ^{
                NSMutableArray *countrysMarr = [NSMutableArray array];
                for (NSDictionary *tempDic in responseObject[@"data"]) {
                    
                    GYAddressCountryModel *model = [[GYAddressCountryModel alloc] initWithDictionary:tempDic error:nil];
                    [countrysMarr addObject:model];
                }
                
                if([GYUtils checkArrayInvalid:countrysMarr]) {
                    DDLogInfo(@"the countrysMarr is empty.");
                    return ;
                }
                
                NSData *data  = [NSKeyedArchiver archivedDataWithRootObject:countrysMarr];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCountryKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            });
            
            
        }
        if (complete) {
            complete();
        }

    }];
}

#pragma mark - 通过国家代码查找国家
- (GYAddressCountryModel*)queryCountry:(NSString*)countryNo
{

    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kCountryKey];
    if (data) {
        NSArray* countryArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([GYUtils checkArrayInvalid:countryArr]) {
            DDLogInfo(@"the countryArr is empty.");
            return nil;
        }
        for (GYAddressCountryModel* model in countryArr) {
            if ([model.countryNo isEqualToString:countryNo]) {
                return model;
                break;
            }
        }
    }
    return nil;
}

#pragma mark - 通过国家名称返回模型
- (GYAddressCountryModel*)queryCountryName:(NSString*)countryName
{

    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kCountryKey];
    if (data) {
        NSArray* countryArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([GYUtils checkArrayInvalid:countryArr]) {
            DDLogInfo(@"the countryArr is empty.");
            return nil;
        }

        for (GYAddressCountryModel* model in countryArr) {
            if ([model.countryName isEqualToString:countryName]) {
                return model;
                break;
            }
        }
    }
    return nil;
}

#pragma mark - 返回所有国家
- (NSMutableArray*)selectAllCountrys
{

    NSMutableArray* countrysMarr = [NSMutableArray array];
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kCountryKey];
    if (data) {
        NSArray* countryArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([GYUtils checkArrayInvalid:countryArr]) {
            DDLogInfo(@"the countryArr is empty.");
            return nil;
        }
        for (GYAddressCountryModel* model in countryArr) {
            [countrysMarr addObject:model];
        }
    }
    return countrysMarr;
}

#pragma mark -返回本地国家
- (NSMutableArray*)selectLocalCountry
{
    NSMutableArray* countrysMarr = [NSMutableArray array];
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kCountryKey];
    if (data) {
        NSArray* countryArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([GYUtils checkArrayInvalid:countryArr]) {
            DDLogInfo(@"the countryArr is empty.");
            return nil;
        }
        for (GYAddressCountryModel* model in countryArr) {
            //只保存本地国家
            if ([model.countryNo isEqualToString:globalData.localInfoModel.countryNo]) {
                [countrysMarr addObject:model];
            }
        }
    }
    return countrysMarr;
}

- (void)clearData
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:kCountryKey];
    [userDefault removeObjectForKey:kProvinceKey];
    [userDefault removeObjectForKey:kCityKey];
    [userDefault synchronize];
}

- (BOOL)checkProvinceValid:(NSArray*)dataAry
{
    BOOL result = YES;

    NSInteger indexNum = 0;
    for (GYProvinceModel* indexModel in dataAry) {
        if ([GYUtils checkStringInvalid:indexModel.provinceName]) {
            indexNum++;
        }

        if (indexNum > 2) {
            result = NO;
            break;
        }
    }

    return result;
}

- (BOOL)checkCountryValid:(NSArray *)dataAry {
    BOOL result = YES;
    
    NSInteger indexNum = 0;
    for (GYAddressCountryModel * indexModel in dataAry) {
        if ([GYUtils checkStringInvalid:indexModel.countryName]) {
            indexNum++;
        }
        
        if (indexNum > 2) {
            result = NO;
            break;
        }
    }
    
    return result;
}

- (BOOL)checkCityValid:(NSArray*)dataAry
{
    BOOL result = YES;

    NSInteger indexNum = 0;
    for (GYCityAddressModel* indexModel in dataAry) {
        if ([GYUtils checkStringInvalid:indexModel.cityName]) {
            indexNum++;
        }

        if (indexNum > 2) {
            result = NO;
            break;
        }
    }
    
    return result;
}

- (void)clearDataByKey:(NSString*)dataKey
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:dataKey];
    [userDefault synchronize];
}



@end
