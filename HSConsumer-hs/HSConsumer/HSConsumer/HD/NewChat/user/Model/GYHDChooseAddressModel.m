//
//  GYHDChooseAddressModel.m
//  HSConsumer
//
//  Created by shiang on 16/3/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDChooseAddressModel.h"
//cityFullName = "\U4e2d\U56fd-\U5c71\U897f-\U957f\U6cbb";
//cityName = "\U957f\U6cbb";
//cityNameCn = "\U957f\U6cbb";
//cityNo = 140107;
//countryNo = 156;
//delFlag = 0;
//phonePrefix = "";
//population = 0;
//postCode = "";
//provinceNo = 14;
//version = 1;
@interface GYHDChooseAddressModel ()
/**城市名字*/
@property (nonatomic, copy, readwrite) NSString* cityName;
/**城市代码*/
@property (nonatomic, copy, readwrite) NSString* cityCode;
/**省份代码*/
@property (nonatomic, copy, readwrite) NSString* provinceCode;
@end

@implementation GYHDChooseAddressModel

- (instancetype)initWithDict:(NSDictionary*)dict
{
    if (self = [super init]) {
        [self setupWithDict:dict];
    }
    return self;
}

- (void)setupWithDict:(NSDictionary*)dict
{
    self.cityName = dict[@"cityNameCn"];
    self.provinceCode = dict[@"provinceNo"];
    self.cityCode = dict[@"cityNo"];
}

@end
