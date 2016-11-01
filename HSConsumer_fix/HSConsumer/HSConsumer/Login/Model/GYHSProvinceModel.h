//
//  GYHSProvinceModel.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/24.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface GYHSProvinceModel : JSONModel <NSCoding>

@property (nonatomic, copy) NSString* countryNo;
@property (nonatomic, copy) NSString* delFlag;
@property (nonatomic, copy) NSString* directedCity;
@property (nonatomic, copy) NSString* provinceName;
@property (nonatomic, copy) NSString* provinceNameCn;
@property (nonatomic, copy) NSString* provinceNo;
@property (nonatomic, copy) NSString* version;

@end
