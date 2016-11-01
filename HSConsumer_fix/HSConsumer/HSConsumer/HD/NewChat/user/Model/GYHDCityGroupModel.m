//
//  GYHDCityGroupModel.m
//  HSConsumer
//
//  Created by shiang on 16/4/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDCityGroupModel.h"

@implementation GYHDCityGroupModel
- (NSMutableArray*)cityGroupArray
{
    if (!_cityGroupArray) {
        _cityGroupArray = [NSMutableArray array];
    }
    return _cityGroupArray;
}

@end

@implementation GYHDCityModel
- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init]) {
        _cityName = dict[@"cityName"];
    }
    return self;
}

@end