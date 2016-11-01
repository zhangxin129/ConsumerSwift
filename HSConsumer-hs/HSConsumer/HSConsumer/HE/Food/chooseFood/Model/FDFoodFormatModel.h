//
//  FDFoodFormatModel.h
//  HSConsumer
//
//  Created by zhangqy on 15/9/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
@protocol FDFoodFormatModel

@end

#import "JSONModel+LoadData.h"

@interface FDFoodFormatModel : JSONModel
@property (copy, nonatomic) NSString* auction;
@property (copy, nonatomic) NSString* pId;
@property (copy, nonatomic) NSString* pName;
@property (copy, nonatomic) NSString* price;
@property (copy, nonatomic) NSString* pVId;
@property (copy, nonatomic) NSString *pVName;
@end
