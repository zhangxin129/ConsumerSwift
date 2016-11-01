//
//  GYHSLocalInfoModel.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/24.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSLocalInfoModel.h"

@implementation GYHSLocalInfoModel

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    if (self == [super init]) {
        _countryName = [aDecoder decodeObjectForKey:@"_countryName"];
        _countryNameCn = [aDecoder decodeObjectForKey:@"_countryNameCn"];
        _countryNo = [aDecoder decodeObjectForKey:@"_countryNo"];
        _platNameCn = [aDecoder decodeObjectForKey:@"_platNameCn"];
        _platNo = [aDecoder decodeObjectForKey:@"_platNo"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:_countryName forKey:@"_countryName"];
    [aCoder encodeObject:_countryNameCn forKey:@"_countryNameCn"];
    [aCoder encodeObject:_countryNo forKey:@"_countryNo"];
    [aCoder encodeObject:_platNameCn forKey:@"_platNameCn"];
    [aCoder encodeObject:_platNo forKey:@"_platNo"];
}

@end
