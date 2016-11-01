//
//  FDCityModel.h
//  HSConsumer
//
//  Created by zhangqy on 15/11/6.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "JSONModel+LoadData.h"

@interface FDCityModel : JSONModel
@property (copy, nonatomic) NSString* areaCode;
@property (copy, nonatomic) NSString* areaName;
@property (copy, nonatomic) NSString* enName;
@property (copy, nonatomic) NSString* parentCode;
@property (copy, nonatomic) NSString *sortOrder;
@end
