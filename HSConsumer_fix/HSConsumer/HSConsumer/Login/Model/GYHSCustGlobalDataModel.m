//
//  GYCustGlobalDataModel.m
//  HSConsumer
//
//  Created by wangfd on 16/6/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSCustGlobalDataModel.h"

@implementation GYHSCustGlobalDataModel

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    if (self == [super init]) {
        _accidentTimesMax = [aDecoder decodeObjectForKey:@"_accidentTimesMax"];
        _accidentYearMax = [aDecoder decodeObjectForKey:@"_accidentYearMax"];
        _bankCardBindCount = [aDecoder decodeObjectForKey:@"_bankCardBindCount"];
        _countryNo = [aDecoder decodeObjectForKey:@"_countryNo"];
        _currencyCode = [aDecoder decodeObjectForKey:@"_currencyCode"];
        _currencyEnName = [aDecoder decodeObjectForKey:@"_currencyEnName"];
        _currencyName = [aDecoder decodeObjectForKey:@"_currencyName"];
        _currencyToHsbRate = [aDecoder decodeObjectForKey:@"_currencyToHsbRate"];
        _consumeThresholdPoint = [aDecoder decodeObjectForKey:@"_consumeThresholdPoint"];
        _dayHbToBankMax = [aDecoder decodeObjectForKey:@"_dayHbToBankMax"];
        _deathExpiry = [aDecoder decodeObjectForKey:@"_deathExpiry"];
        _deathYearMax = [aDecoder decodeObjectForKey:@"_deathYearMax"];
        _durInvalidDays = [aDecoder decodeObjectForKey:@"_durInvalidDays"];
        _freeMedicalMax = [aDecoder decodeObjectForKey:@"_freeMedicalMax"];
        _hbToBankCheckMin = [aDecoder decodeObjectForKey:@"_hbToBankCheckMin"];
        _hbToBankCheckNum = [aDecoder decodeObjectForKey:@"_hbToBankCheckNum"];
        _hbToBankMax = [aDecoder decodeObjectForKey:@"_hbToBankMax"];
        _hbToBankMin = [aDecoder decodeObjectForKey:@"_hbToBankMin"];
        _hsbToHbMin = [aDecoder decodeObjectForKey:@"_hsbToHbMin"];
        _hsbToHbRate = [aDecoder decodeObjectForKey:@"_hsbToHbRate"];
        _investPointMin = [aDecoder decodeObjectForKey:@"_investPointMin"];
        _investThresholdPoint = [aDecoder decodeObjectForKey:@"_investThresholdPoint"];
        _pointMin = [aDecoder decodeObjectForKey:@"_pointMin"];
        _pointSave = [aDecoder decodeObjectForKey:@"_pointSave"];
        _integralTransferToHsbRate = [aDecoder decodeObjectForKey:@"_integralTransferToHsbRate"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:_accidentTimesMax forKey:@"_accidentTimesMax"];
    [aCoder encodeObject:_accidentYearMax forKey:@"_accidentYearMax"];
    [aCoder encodeObject:_bankCardBindCount forKey:@"_bankCardBindCount"];
    [aCoder encodeObject:_countryNo forKey:@"_countryNo"];
    [aCoder encodeObject:_currencyCode forKey:@"_currencyCode"];
    [aCoder encodeObject:_currencyEnName forKey:@"_currencyEnName"];
    [aCoder encodeObject:_currencyName forKey:@"_currencyName"];
    [aCoder encodeObject:_currencyToHsbRate forKey:@"_currencyToHsbRate"];
    [aCoder encodeObject:_consumeThresholdPoint forKey:@"_consumeThresholdPoint"];
    [aCoder encodeObject:_dayHbToBankMax forKey:@"_dayHbToBankMax"];
    [aCoder encodeObject:_deathExpiry forKey:@"_deathExpiry"];
    [aCoder encodeObject:_deathYearMax forKey:@"_deathYearMax"];
    [aCoder encodeObject:_durInvalidDays forKey:@"_durInvalidDays"];
    [aCoder encodeObject:_freeMedicalMax forKey:@"_freeMedicalMax"];
    [aCoder encodeObject:_hbToBankCheckMin forKey:@"_hbToBankCheckMin"];
    [aCoder encodeObject:_hbToBankCheckNum forKey:@"_hbToBankCheckNum"];
    [aCoder encodeObject:_hbToBankMax forKey:@"_hbToBankMax"];
    [aCoder encodeObject:_hbToBankMin forKey:@"_hbToBankMin"];
    [aCoder encodeObject:_hsbToHbMin forKey:@"_hsbToHbMin"];
    [aCoder encodeObject:_hsbToHbRate forKey:@"_hsbToHbRate"];
    [aCoder encodeObject:_investPointMin forKey:@"_investPointMin"];
    [aCoder encodeObject:_investThresholdPoint forKey:@"_investThresholdPoint"];
    [aCoder encodeObject:_pointMin forKey:@"_pointMin"];
    [aCoder encodeObject:_pointSave forKey:@"_pointSave"];
    [aCoder encodeObject:_integralTransferToHsbRate forKey:@"_integralTransferToHsbRate"];
}

@end
