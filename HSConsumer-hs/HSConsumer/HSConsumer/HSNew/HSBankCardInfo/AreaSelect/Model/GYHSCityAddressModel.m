//
//  GYHSCityAddressModel.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/24.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSCityAddressModel.h"

@implementation GYHSCityAddressModel

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    if (self == [super init]) {
        _cityFullName = [aDecoder decodeObjectForKey:@"_cityFullName"];
        _cityName = [aDecoder decodeObjectForKey:@"_cityName"];
        _cityNameCn = [aDecoder decodeObjectForKey:@"_cityNameCn"];
        _cityNo = [aDecoder decodeObjectForKey:@"_cityNo"];
        _countryNo = [aDecoder decodeObjectForKey:@"_countryNo"];
        _delFlag = [aDecoder decodeObjectForKey:@"_delFlag"];
        _phonePrefix = [aDecoder decodeObjectForKey:@"_phonePrefix"];
        _population = [aDecoder decodeObjectForKey:@"_population"];
        _postCode = [aDecoder decodeObjectForKey:@"_postCode"];
        _provinceNo = [aDecoder decodeObjectForKey:@"_provinceNo"];
        _version = [aDecoder decodeObjectForKey:@"_version"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:_cityFullName forKey:@"_cityFullName"];
    [aCoder encodeObject:_cityName forKey:@"_cityName"];
    [aCoder encodeObject:_cityNameCn forKey:@"_cityNameCn"];
    [aCoder encodeObject:_cityNo forKey:@"_cityNo"];
    [aCoder encodeObject:_countryNo forKey:@"_countryNo"];
    [aCoder encodeObject:_delFlag forKey:@"_delFlag"];
    [aCoder encodeObject:_phonePrefix forKey:@"_phonePrefix"];
    [aCoder encodeObject:_population forKey:@"_population"];
    [aCoder encodeObject:_postCode forKey:@"_postCode"];
    [aCoder encodeObject:_provinceNo forKey:@"_provinceNo"];
    [aCoder encodeObject:_version forKey:@"_version"];
}

@end
