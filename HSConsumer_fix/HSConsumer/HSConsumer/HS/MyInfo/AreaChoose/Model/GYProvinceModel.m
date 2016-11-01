//
//  GYProvinceModel.m
//  HSConsumer
//
//  Created by apple on 15/12/29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYProvinceModel.h"

@implementation GYProvinceModel

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    if (self == [super init]) {
        _primaryKey = [aDecoder decodeObjectForKey:@"GYProvinceModelPrimaryKey"];
        _countryNo = [aDecoder decodeObjectForKey:@"GYProvinceModelCountryNo"];
        _delFlag = [aDecoder decodeObjectForKey:@"GYProvinceModelDelFlag"];
        _directedCity = [aDecoder decodeObjectForKey:@"GYProvinceModelDirectedCity"];
        _provinceName = [aDecoder decodeObjectForKey:@"GYProvinceModelProvinceName"];
        _provinceNameCn = [aDecoder decodeObjectForKey:@"GYProvinceModelProvinceNameCn"];
        _provinceNo = [aDecoder decodeObjectForKey:@"GYProvinceModelProvinceNo"];
        _version = [aDecoder decodeObjectForKey:@"GYProvinceModelVersion"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:_primaryKey forKey:@"GYProvinceModelPrimaryKey"];
    [aCoder encodeObject:_countryNo forKey:@"GYProvinceModelCountryNo"];
    [aCoder encodeObject:_delFlag forKey:@"GYProvinceModelDelFlag"];
    [aCoder encodeObject:_directedCity forKey:@"GYProvinceModelDirectedCity"];
    [aCoder encodeObject:_provinceName forKey:@"GYProvinceModelProvinceName"];
    [aCoder encodeObject:_provinceNameCn forKey:@"GYProvinceModelProvinceNameCn"];
    [aCoder encodeObject:_provinceNo forKey:@"GYProvinceModelProvinceNo"];
    [aCoder encodeObject:_version forKey:@"GYProvinceModelVersion"];
}

@end
