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
MJCodingImplementation
/*
 @property (nonatomic, copy) NSString* primaryKey;
 @property (nonatomic, copy) NSString* countryNo;
 @property (nonatomic, copy) NSString* delFlag;
 @property (nonatomic, copy) NSString* directedCity;
 @property (nonatomic, copy) NSString* provinceName;
 @property (nonatomic, copy) NSString* provinceNameCn;
 @property (nonatomic, copy) NSString* provinceNo;
 @property (nonatomic, copy) NSString *version;
 */
-(void)initWithDict:(NSDictionary*)dict{

    _primaryKey= dict[@"primaryKey"];
    _countryNo= dict[@"countryNo"];
    _delFlag= dict[@"delFlag"];
    _directedCity= dict[@"directedCity"];
    _provinceName= dict[@"provinceName"];
    _provinceNameCn= dict[@"provinceNameCn"];
    _provinceNo= dict[@"provinceNo"];
    _version=dict[@"version"];
    
    
}
@end
