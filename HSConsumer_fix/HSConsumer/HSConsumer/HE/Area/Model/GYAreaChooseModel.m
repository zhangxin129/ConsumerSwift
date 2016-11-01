//
//  GYAreaChooseModel.m
//  HSConsumer
//
//  Created by lizp on 16/6/15.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAreaChooseModel.h"

@implementation GYAreaChooseModel

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{

    if (self = [super init]) {
        _areaCode = [aDecoder decodeObjectForKey:@"GYAreaChooseModelAreaCode"];
        _areaName = [aDecoder decodeObjectForKey:@"GYAreaChooseModelAreaName"];
        _enName = [aDecoder decodeObjectForKey:@"GYAreaChooseModelEnName"];
        _parentCode = [aDecoder decodeObjectForKey:@"GYAreaChooseModelParentCode"];
        _sortOrder = [aDecoder decodeObjectForKey:@"GYAreaChooseModelSortOrder"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{

    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_areaCode forKey:@"GYAreaChooseModelAreaCode"];
    [aCoder encodeObject:_areaName forKey:@"GYAreaChooseModelAreaName"];
    [aCoder encodeObject:_enName forKey:@"GYAreaChooseModelEnName"];
    [aCoder encodeObject:_parentCode forKey:@"GYAreaChooseModelParentCode"];
    [aCoder encodeObject:_sortOrder forKey:@"GYAreaChooseModelSortOrder"];
}

@end
