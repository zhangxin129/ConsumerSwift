//
//  GYProvinceChooseModel.m
//  HSConsumer
//
//  Created by lizp on 16/6/15.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYProvinceChooseModel.h"

@implementation GYProvinceChooseModel

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{

    if (self = [super init]) {
        _areaCode = [aDecoder decodeObjectForKey:@"GYProvinceChooseModelAreaCode"];
        _areaName = [aDecoder decodeObjectForKey:@"GYProvinceChooseModelAreaName"];
        _areaType = [aDecoder decodeObjectForKey:@"GYProvinceChooseModelAreaType"];
        _parentCode = [aDecoder decodeObjectForKey:@"GYProvinceChooseModelParentCode"];
        _sortOrder = [aDecoder decodeObjectForKey:@"GYProvinceChooseModelSortOrder"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{

    [super encodeWithCoder:aCoder];

    [aCoder encodeObject:_areaCode forKey:@"GYProvinceChooseModelAreaCode"];
    [aCoder encodeObject:_areaName forKey:@"GYProvinceChooseModelAreaName"];
    [aCoder encodeObject:_areaType forKey:@"GYProvinceChooseModelAreaType"];
    [aCoder encodeObject:_parentCode forKey:@"GYProvinceChooseModelParentCode"];
    [aCoder encodeObject:_sortOrder forKey:@"GYProvinceChooseModelSortOrder"];
}

@end
