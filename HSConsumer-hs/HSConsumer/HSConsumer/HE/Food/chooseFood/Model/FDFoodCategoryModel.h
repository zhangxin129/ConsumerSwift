//
//  FDFoodCategoryModel.h
//  HSConsumer
//
//  Created by zhangqy on 15/11/3.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

@protocol FDFoodCategoryModel

@end

#import "JSONModel+LoadData.h"
#import "FDFoodDetailModel.h"

@interface FDFoodCategoryModel : JSONModel
@property (copy, nonatomic) NSString* itemCustomCategoryId;
@property (copy, nonatomic) NSString* itemCustomCategoryName;
@property (strong, nonatomic) NSArray* itemFoodIdList;
@property (strong, nonatomic) NSArray<FDFoodDetailModel>* itemInfoFoodList;
@property (copy, nonatomic) NSString *itemNum;

@end
