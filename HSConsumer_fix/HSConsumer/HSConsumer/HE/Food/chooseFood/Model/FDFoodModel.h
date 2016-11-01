//
//  FDFoodModel.h
//  HSConsumer
//
//  Created by zhangqy on 15/9/22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "JSONModel+LoadData.h"
#import "FDFoodFormatModel.h"

@interface FDFoodModel : JSONModel
@property (copy, nonatomic) NSString* foodPic;
@property (copy, nonatomic) NSString* foodName;
@property (copy, nonatomic) NSString* foodId;
@property (strong, nonatomic) NSArray<FDFoodFormatModel>* foodFormat;
@property (copy, nonatomic) NSString* foodPrice;
@property (copy, nonatomic) NSString* foodPv;
@property (copy, nonatomic) NSString* foodPicParsed;
@property (copy, nonatomic) NSString* tfsDomain;

@end
