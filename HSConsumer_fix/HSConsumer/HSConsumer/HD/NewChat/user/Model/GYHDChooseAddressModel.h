//
//  GYHDChooseAddressModel.h
//  HSConsumer
//
//  Created by shiang on 16/3/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDChooseAddressModel : NSObject
/**城市名字*/
@property (nonatomic, copy, readonly) NSString* cityName;
/**城市代码*/
@property (nonatomic, copy, readonly) NSString* cityCode;
/**省份代码*/
@property (nonatomic, copy, readonly) NSString* provinceCode;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
