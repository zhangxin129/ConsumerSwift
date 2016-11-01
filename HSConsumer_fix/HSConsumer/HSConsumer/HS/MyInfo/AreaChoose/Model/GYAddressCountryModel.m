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

#import "GYAddressCountryModel.h"

@implementation GYAddressCountryModel

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{

    if (self = [super init]) {
        _countryCode = [aDecoder decodeObjectForKey:@"GYAddressCountryModelCountryCode"];
        _countryName = [aDecoder decodeObjectForKey:@"GYAddressCountryModelCountryName"];
        _countryNameCn = [aDecoder decodeObjectForKey:@"GYAddressCountryModelCountryNameCn"];
        _countryNo = [aDecoder decodeObjectForKey:@"GYAddressCountryModelCountryNo"];
        _delFlag = [aDecoder decodeObjectForKey:@"GYAddressCountryModelDelFlag"];
        _phonePrefix = [aDecoder decodeObjectForKey:@"GYAddressCountryModelPhonePrefix"];
        _postCode = [aDecoder decodeObjectForKey:@"GYAddressCountryModelPostCode"];
        _version = [aDecoder decodeObjectForKey:@"GYAddressCountryModelVersion"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{

    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_countryCode forKey:@"GYAddressCountryModelCountryCode"];
    [aCoder encodeObject:_countryName forKey:@"GYAddressCountryModelCountryName"];
    [aCoder encodeObject:_countryNameCn forKey:@"GYAddressCountryModelCountryNameCn"];
    [aCoder encodeObject:_countryNo forKey:@"GYAddressCountryModelCountryNo"];
    [aCoder encodeObject:_delFlag forKey:@"GYAddressCountryModelDelFlag"];
    [aCoder encodeObject:_phonePrefix forKey:@"GYAddressCountryModelPhonePrefix"];
    [aCoder encodeObject:_postCode forKey:@"GYAddressCountryModelPostCode"];
    [aCoder encodeObject:_version forKey:@"GYAddressCountryModelVersion"];
}

@end
