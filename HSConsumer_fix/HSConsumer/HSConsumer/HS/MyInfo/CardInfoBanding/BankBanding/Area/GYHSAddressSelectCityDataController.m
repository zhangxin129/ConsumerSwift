//
//  GYHSAddressSelectCityDataController.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/31.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSAddressSelectCityDataController.h"
#import "GYHSCityAddressModel.h"
#import "GYNetRequest.h"
#import "GYHSConstant.h"
@interface GYHSAddressSelectCityDataController () <GYNetRequestDelegate>

@property (nonatomic, copy) NSString* areaId;
@property (nonatomic, copy) NSString* provinceNO;
@property (nonatomic, strong) NSString* cityNo;

@property (nonatomic, strong) GYHSAddressSelectCityBlock citysBlock;
@property (nonatomic, strong) GYHSAddressSelectAllCitysBlock allCitysBlock;
@end

@implementation GYHSAddressSelectCityDataController

#pragma mark - public methods
- (void)queryCity:(NSString*)countryNo
        prvinceNo:(NSString*)prvinceNo
           cityNo:(NSString*)cityNo
      resultBlock:(GYHSAddressSelectCityBlock)resultBlock
{
    self.areaId = countryNo;
    self.provinceNO = prvinceNo;
    self.cityNo = cityNo;
    self.citysBlock = resultBlock;

    NSArray* localAry = [self loadLocalCitysData];
    if ([localAry count] <= 0) {
        [self queryCitysData];
    }
    else {
        GYHSCityAddressModel* cityModel = [self getCityInfo:localAry cityNo:self.cityNo];
        [self executeBlock:nil cityModel:cityModel];
    }
}

- (void)queyrCitys:(NSString*)countryNo
        privinceNo:(NSString*)privinceNo
       resultBlock:(GYHSAddressSelectAllCitysBlock)resultBlock
{
    self.areaId = countryNo;
    self.provinceNO = privinceNo;
    self.allCitysBlock = resultBlock;

    NSArray* localAry = [self loadLocalCitysData];
    if ([localAry count] <= 0) {
        [self queryCitysData];
    }
    else {
        [self executeBlock:localAry cityModel:nil];
    }
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    DDLogDebug(@"responseObject:%@", responseObject);

    if ([GYUtils checkDictionaryInvalid:responseObject]) {
        DDLogDebug(@"The responseObject:%@ invalid.", responseObject);
        [self executeBlock:nil cityModel:nil];
        return;
    }

    NSInteger returnCode = [[responseObject objectForKey:@"retCode"] integerValue];
    if (returnCode != 200) {
        DDLogDebug(@"The returnCode:%ld is not 200.", (long)returnCode);
        [self executeBlock:nil cityModel:nil];
        return;
    }

    NSArray* serverAry = responseObject[@"data"];
    if ([GYUtils checkArrayInvalid:serverAry]) {
        DDLogDebug(@"The serverAry:%@ invalid.", serverAry);
        [self executeBlock:nil cityModel:nil];
        return;
    }

    NSMutableArray* resultAry = [NSMutableArray array];
    for (NSDictionary* indexDic in serverAry) {
        if ([GYUtils checkDictionaryInvalid:indexDic]) {
            continue;
        }

        GYHSCityAddressModel* model = [[GYHSCityAddressModel alloc] initWithDictionary:indexDic error:nil];
        [resultAry addObject:model];
    }

    if ([resultAry count] > 0) {
        [self saveCitysData:resultAry];
        GYHSCityAddressModel* cityModel = [self getCityInfo:resultAry cityNo:self.cityNo];
        [self executeBlock:resultAry cityModel:cityModel];
    }
}

- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);

    WS(weakSelf)
        [GYUtils parseNetWork:error resultBlock:^(NSInteger retCode) {
        [weakSelf executeBlock:nil cityModel:nil];
        }];
}

#pragma mark - private methods
- (void)queryCitysData
{
    NSDictionary* paramsDic = @{ @"countryNo" : kSaftToNSString(self.areaId),
        @"provinceNo" : kSaftToNSString(self.provinceNO) };

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlQueryCity parameters:paramsDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];

    [request start];
}

- (NSArray*)loadLocalCitysData
{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:[self cityDataKey]];
    NSArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    if ([GYUtils checkArrayInvalid:array]) {
        array = [NSArray array];
    }

    return array;
}

- (void)saveCitysData:(NSArray*)array
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
        [userDefault setObject:data forKey:[self cityDataKey]];
        [userDefault synchronize];
    });
}

- (NSString*)cityDataKey
{
    return [NSString stringWithFormat:@"GYHSAddressCitysData_%@_%@", self.areaId, self.provinceNO];
}

- (GYHSCityAddressModel*)getCityInfo:(NSArray*)allCitysAry cityNo:(NSString*)cityNo
{
    GYHSCityAddressModel* model = nil;
    for (GYHSCityAddressModel* indexModel in allCitysAry) {
        if ([cityNo isEqualToString:indexModel.cityNo]) {
            model = indexModel;
            break;
        }
    }

    return model;
}

- (void)executeBlock:(NSArray*)allCitys cityModel:(GYHSCityAddressModel*)cityModel
{
    if (self.allCitysBlock) {
        self.allCitysBlock(allCitys);
        self.allCitysBlock = nil;
    }

    if (self.citysBlock) {
        self.citysBlock(cityModel);
        self.citysBlock = nil;
    }
}

@end
