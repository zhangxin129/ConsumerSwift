//
//  FDMainLocationModel.h
//  HSConsumer
//
//  Created by zhangqy on 15/9/24.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "JSONModel+LoadData.h"

@interface FDLocationModel : JSONModel
@property (copy, nonatomic) NSNumber* areaId;
@property (copy, nonatomic) NSString* areaName;
@property (copy, nonatomic) NSNumber* kId;
@property (copy, nonatomic) NSString* sortOrder;
@property (copy, nonatomic) NSString* locationName;
@end
