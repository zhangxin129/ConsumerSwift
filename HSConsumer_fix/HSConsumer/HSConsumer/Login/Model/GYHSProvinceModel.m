//
//  GYHSProvinceModel.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/24.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSProvinceModel.h"

@implementation GYHSProvinceModel

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    if (self == [super init]) {
        _countryNo = [aDecoder decodeObjectForKey:@"_countryNo"];
        _delFlag = [aDecoder decodeObjectForKey:@"_delFlag"];
        _directedCity = [aDecoder decodeObjectForKey:@"_directedCity"];
        _provinceName = [aDecoder decodeObjectForKey:@"_provinceName"];
        _provinceNameCn = [aDecoder decodeObjectForKey:@"_provinceNameCn"];
        _provinceNo = [aDecoder decodeObjectForKey:@"_provinceNo"];
        _version = [aDecoder decodeObjectForKey:@"_version"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:_countryNo forKey:@"_countryNo"];
    [aCoder encodeObject:_delFlag forKey:@"_delFlag"];
    [aCoder encodeObject:_directedCity forKey:@"_directedCity"];
    [aCoder encodeObject:_provinceName forKey:@"_provinceName"];
    [aCoder encodeObject:_provinceNameCn forKey:@"_provinceNameCn"];
    [aCoder encodeObject:_provinceNo forKey:@"_provinceNo"];
    [aCoder encodeObject:_version forKey:@"_version"];
}

@end
