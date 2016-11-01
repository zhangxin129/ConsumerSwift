//
//  GYCityChooseModel.m
//  HSConsumer
//
//  Created by lizp on 16/6/15.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYCityChooseModel.h"

@implementation GYCityChooseModel

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{

    if (self = [super init]) {
        _areaCode = [aDecoder decodeObjectForKey:@"GYCityChooseModelAreaCode"];
        _areaName = [aDecoder decodeObjectForKey:@"GYCityChooseModelAreaName"];
        _enName = [aDecoder decodeObjectForKey:@"GYCityChooseModelEnName"];
        _parentCode = [aDecoder decodeObjectForKey:@"GYCityChooseModelParentCode"];
        _sortOrder = [aDecoder decodeObjectForKey:@"GYCityChooseModelSortOrder"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{

    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_areaCode forKey:@"GYCityChooseModelAreaCode"];
    [aCoder encodeObject:_areaName forKey:@"GYCityChooseModelAreaName"];
    [aCoder encodeObject:_enName forKey:@"GYCityChooseModelEnName"];
    [aCoder encodeObject:_parentCode forKey:@"GYCityChooseModelParentCode"];
    [aCoder encodeObject:_sortOrder forKey:@"GYCityChooseModelSortOrder"];
}

@end
