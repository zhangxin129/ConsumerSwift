//
//  GYHSCityAddressModel.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/24.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface GYHSCityAddressModel : JSONModel <NSCoding>
@property (nonatomic, copy) NSString* cityFullName;
@property (nonatomic, copy) NSString* cityName;
@property (nonatomic, copy) NSString* cityNameCn;
@property (nonatomic, copy) NSString* cityNo;
@property (nonatomic, copy) NSString* countryNo;
@property (nonatomic, copy) NSString* delFlag;
@property (nonatomic, copy) NSString* phonePrefix;
@property (nonatomic, copy) NSString* population;
@property (nonatomic, copy) NSString* postCode;
@property (nonatomic, copy) NSString* provinceNo;
@property (nonatomic, copy) NSString* version;
@end
