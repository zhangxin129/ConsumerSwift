//
//  GYCityAddressModel.h
//  HSConsumer
//
//  Created by apple on 15/12/29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYCityAddressModel : NSObject 
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
@property (nonatomic, copy) NSString *version;
-(void)initWithDict:(NSDictionary*)dict;
@end
