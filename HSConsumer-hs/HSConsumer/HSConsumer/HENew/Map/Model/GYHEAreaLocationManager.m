//
//  GYHEAreaLocationManager.m
//  HSConsumer
//
//  Created by xiaoxh on 16/10/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEAreaLocationManager.h"

@implementation GYHEAreaLocationManager

+ (GYHEAreaLocationManager*)shareInstance
{
    static dispatch_once_t onceToken;
    static GYHEAreaLocationManager *areaLocation;
    dispatch_once(&onceToken, ^{
        areaLocation = [[GYHEAreaLocationManager alloc] init];
    });
    return areaLocation;
}
-(NSMutableArray*)returnsAllProvinces
{
    NSMutableArray *provinceArray = [[NSMutableArray alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"arealocationlist" ofType:@"txt"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary* oneDic in dict[@"data"]) {
        GYHEAreaLocationModel* oneModel = [[GYHEAreaLocationModel alloc] initWithDictionary:oneDic error:nil];
        [provinceArray addObject:oneModel];
    }
    return provinceArray;
}
-(NSMutableArray*)queryProvincesofAllCity:(NSString*)areaCode
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"arealocationlist" ofType:@"txt"];
    NSMutableArray *cityArray = [[NSMutableArray alloc] init];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    for (NSDictionary* oneDic in dict[@"data"]) {
        GYHEAreaLocationModel* oneModel = [[GYHEAreaLocationModel alloc] initWithDictionary:oneDic error:nil];
        if ([oneModel.areaCode isEqualToString:areaCode]) {
            cityArray  = oneModel.childs;
        }
    }
    return cityArray;
}
-(NSMutableArray*)queryCitysofAllDistrict:(NSString*)areaCode
{
    
    NSString *path= [[NSBundle mainBundle] pathForResource:@"arealocationlist" ofType:@"txt"];
    NSMutableArray *districtArray = [[NSMutableArray alloc] init];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    for (NSDictionary* oneDic in dict[@"data"]) {
        GYHEAreaLocationModel* oneModel = [[GYHEAreaLocationModel alloc] initWithDictionary:oneDic error:nil];
        for (GYHEChildsModel *childsModel in oneModel.childs) {
            if ([childsModel.areaCode isEqualToString:areaCode]) {
                districtArray = childsModel.childs;
            }
        }
    }
    return districtArray;
}
@end
