//
//  GYAddressCountryModel.m
//  HSConsumer
//
//  Created by apple on 15/12/29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSAddressCountryModel.h"

@implementation GYHSAddressCountryModel

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super init]) {
        _countryCode = [aDecoder decodeObjectForKey:@"_countryCode"];
        _countryName = [aDecoder decodeObjectForKey:@"_countryName"];
        _countryNameCn = [aDecoder decodeObjectForKey:@"_countryNameCn"];
        _countryNo = [aDecoder decodeObjectForKey:@"_countryNo"];
        _delFlag = [aDecoder decodeObjectForKey:@"_delFlag"];
        _postCode = [aDecoder decodeObjectForKey:@"_postCode"];
        _version = [aDecoder decodeObjectForKey:@"_version"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:_countryCode forKey:@"_countryCode"];
    [aCoder encodeObject:_countryName forKey:@"_countryName"];
    [aCoder encodeObject:_countryNameCn forKey:@"_countryNameCn"];
    [aCoder encodeObject:_countryNo forKey:@"_countryNo"];
    [aCoder encodeObject:_delFlag forKey:@"_delFlag"];
    [aCoder encodeObject:_phonePrefix forKey:@"_phonePrefix"];
    [aCoder encodeObject:_postCode forKey:@"_postCode"];
    [aCoder encodeObject:_version forKey:@"_version"];
}

@end
