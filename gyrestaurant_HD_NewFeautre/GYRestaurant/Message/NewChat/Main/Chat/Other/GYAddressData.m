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
#import "GYLoginEn.h"
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
        if ([Utils checkArrayInvalid:provinceArr]) {
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
        if ([Utils checkArrayInvalid:cityArr]) {
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
    NSString*urlStr=[NSString stringWithFormat:@"%@/lcs/queryProvinceTree",[GYLoginEn sharedInstance].getLoginUrl];
    [Network GET:urlStr parameter:@{ @"countryNo" : kSaftToNSString(globalData.attribute.countryNo) } success:^(id returnValue) {
        
        if ([returnValue[@"retCode"]integerValue]!=200) {
            
            if(complete) {
                complete(nil, nil);
            }
            
        }
        
        NSMutableArray *cityMarr = [NSMutableArray array];
        NSMutableArray *provinceMarr = [NSMutableArray array];
        NSArray *serverAry = returnValue[@"data"];
        
        if([Utils checkArrayInvalid:serverAry]) {
            DDLogInfo(@"the serverAry is empty.");
            if(complete) {
                complete(nil, nil);
            }
            return ;
        }
        
        for (NSDictionary *tempDic in serverAry) {
            
            for (NSDictionary *dic in tempDic[@"citys"]) {
                GYCityAddressModel *model =[[GYCityAddressModel alloc]init];
                [model initWithDict:dic];
                [cityMarr addObject:model];
            }
            
            GYProvinceModel *model = [[GYProvinceModel alloc] init];
            [model initWithDict:tempDic[@"province"]];
            [provinceMarr addObject:model];
        }
        
        if([cityMarr count] <= 0 || [provinceMarr count] <= 0) {
            DDLogDebug(@"the cityArr or provinceArr  is empty.");
            if(complete) {
                complete(nil, nil);
            }
            return ;
        }
        NSData *cityData = [NSKeyedArchiver archivedDataWithRootObject:cityMarr];
        [[NSUserDefaults standardUserDefaults] setObject:cityData forKey:kCityKey];
        
        NSData *provinceData = [NSKeyedArchiver archivedDataWithRootObject:provinceMarr ];
        [[NSUserDefaults standardUserDefaults] setObject:provinceData forKey:kProvinceKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if(complete) {
            complete(provinceMarr, cityMarr);
        }
        
    } failure:^(NSError *error) {
        
        if (error) {
            DDLogDebug(@"获取城市列表失败");
            if(complete) {
                complete(nil, nil);
            }
        }
        
    }];
}

#pragma mark - 返回省份信息
- (void)receiveProvinceInfoBlock:(arrayBlock)block
{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kProvinceKey];
    NSArray* provinceAry = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    if ([provinceAry count] > 0) {
        if (block) {
            block(provinceAry);
        }
    }
    else {
        [self netRequestAddressInfo:^(NSArray* provinceAry, NSArray* cityAry) {
            if ([Utils checkArrayInvalid:provinceAry]) {
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

    if ([cityAry count] > 0) {
        if (block) {
            block(cityAry);
        }
    }
    else {
        [self netRequestAddressInfo:^(NSArray* provinceAry, NSArray* cityAry) {
            if ([Utils checkArrayInvalid:cityAry]) {
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
        if ([Utils checkArrayInvalid:cityArr]) {
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

#pragma mark - 通过string查询包含某个字的地区
- (NSMutableArray*)selectAddressWithString:(NSString*)string
{

    NSMutableArray* marr = [NSMutableArray array];
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kCityKey];
    if (data) {
        NSArray* cityArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([Utils checkArrayInvalid:cityArr]) {
            DDLogInfo(@"the cityArr is empty.");
            return nil;
        }

        for (GYCityAddressModel* model in cityArr) {
            if ([model.cityName containsString:string]) {
                [marr addObject:model];
            }
        }
    }
    return marr;
}

#pragma mark - 返回所有城市
- (NSMutableArray*)selectAllCitys
{

    NSMutableArray* allCitys = [NSMutableArray array];
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kCityKey];
    if (data) {
        allCitys = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([Utils checkArrayInvalid:allCitys]) {
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
        if ([Utils checkArrayInvalid:allProvinces]) {
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
        if ([Utils checkArrayInvalid:cityArr]) {
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

- (void) clearData {
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:kCountryKey];
    [userDefault removeObjectForKey:kProvinceKey];
    [userDefault removeObjectForKey:kCityKey];
    [userDefault synchronize];
}

@end
