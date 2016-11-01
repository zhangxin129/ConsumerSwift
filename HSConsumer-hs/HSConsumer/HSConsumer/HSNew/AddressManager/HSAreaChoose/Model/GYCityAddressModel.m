//
//  GYCityAddressModel.m
//  HSConsumer
//
//  Created by apple on 15/12/29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYCityAddressModel.h"
#import "GYPinYinConvertTool.h"

@implementation GYCityAddressModel

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    if (self == [super init]) {
        _cityFullName = [aDecoder decodeObjectForKey:@"GYCityAddressModelCityFullName"];
        _cityName = [aDecoder decodeObjectForKey:@"GYCityAddressModelCityName"];
        _cityNameCn = [aDecoder decodeObjectForKey:@"GYCityAddressModelCityNameCn"];
        _cityNo = [aDecoder decodeObjectForKey:@"GYCityAddressModelCityNo"];
        _countryNo = [aDecoder decodeObjectForKey:@"GYCityAddressModelCountryNo"];
        _delFlag = [aDecoder decodeObjectForKey:@"GYCityAddressModelDelFlag"];
        _phonePrefix = [aDecoder decodeObjectForKey:@"GYCityAddressModelPhonePrefix"];
        _population = [aDecoder decodeObjectForKey:@"GYCityAddressModelPopulation"];
        _postCode = [aDecoder decodeObjectForKey:@"GYCityAddressModelPostCode"];
        _provinceNo = [aDecoder decodeObjectForKey:@"GYCityAddressModelProvinceNo"];
        _version = [aDecoder decodeObjectForKey:@"GYCityAddressModelVersion"];
        _cityPinYin = [aDecoder decodeObjectForKey:@"GYCityAddressModelCityPinYin"];
        _cityFirstLetterPinYin = [aDecoder decodeObjectForKey:@"GYCityAddressModelCityFirstLetterPinYin"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:_cityFullName forKey:@"GYCityAddressModelCityFullName"];
    [aCoder encodeObject:_cityName forKey:@"GYCityAddressModelCityName"];
    [aCoder encodeObject:_cityNameCn forKey:@"GYCityAddressModelCityNameCn"];
    [aCoder encodeObject:_cityNo forKey:@"GYCityAddressModelCityNo"];
    [aCoder encodeObject:_countryNo forKey:@"GYCityAddressModelCountryNo"];
    [aCoder encodeObject:_delFlag forKey:@"GYCityAddressModelDelFlag"];
    [aCoder encodeObject:_phonePrefix forKey:@"GYCityAddressModelPhonePrefix"];
    [aCoder encodeObject:_population forKey:@"GYCityAddressModelPopulation"];
    [aCoder encodeObject:_postCode forKey:@"GYCityAddressModelPostCode"];
    [aCoder encodeObject:_provinceNo forKey:@"GYCityAddressModelProvinceNo"];
    [aCoder encodeObject:_version forKey:@"GYCityAddressModelVersion"];
    [aCoder encodeObject:_cityPinYin forKey:@"GYCityAddressModelCityPinYin"];
    [aCoder encodeObject:_cityFirstLetterPinYin forKey:@"GYCityAddressModelCityFirstLetterPinYin"];
}

- (instancetype)initWithDic:(NSDictionary*)dic
{

    if (self = [super init]) {
        self = [self initWithDictionary:dic error:nil];
        self.cityPinYin = [[GYPinYinConvertTool chineseConvertToPinYin:self.cityName] lowercaseString];
        self.cityFirstLetterPinYin = [[GYPinYinConvertTool chineseConvertToPinYinHead:self.cityName] lowercaseString];

        if ([self.cityNameCn isEqualToString:kLocalized(@"GYHS_Address_ChangzhiCity")]) {
            self.cityPinYin = @"changzhishi";
            self.cityFirstLetterPinYin = @"czs";
        }
        if ([self.cityNameCn isEqualToString:kLocalized(@"GYHS_Address_changchunCity")]) {
            self.cityPinYin = @"changchunshi";
            self.cityFirstLetterPinYin = @"ccs";
        }
        if ([self.cityNameCn isEqualToString:kLocalized(@"GYHS_Address_XiamenCity")]) {
            self.cityPinYin = @"xiamenshi";
            self.cityFirstLetterPinYin = @"xms";
        }
        if ([self.cityNameCn isEqualToString:kLocalized(@"GYHS_Address_ChangshaCity")]) {
            self.cityPinYin = @"changshashi";
            self.cityFirstLetterPinYin = @"css";
        }
        if ([self.cityNameCn isEqualToString:kLocalized(@"GYHS_Address_ChongqingCity")]) {
            self.cityPinYin = @"chongqingshi";
            self.cityFirstLetterPinYin = @"cqs";
        }
    }
    return self;
}

@end
