//
//  FDChoosedFoodModel.h
//  HSConsumer
//
//  Created by zhangqy on 15/9/28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "JSONModel+LoadData.h"
#import "FDFoodDetailModel.h"
#import "FDFoodFormatModel.h"
@interface FDChoosedFoodModel : JSONModel
@property (strong, nonatomic) FDFoodDetailModel* food;
@property (strong, nonatomic) FDFoodFormatModel* format;
@property (assign, nonatomic) NSInteger count; //点菜数量
@property (assign, nonatomic) NSInteger salesCount; //已售数量
@end
