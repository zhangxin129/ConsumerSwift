//
//  FDShopFoodCategoryModel.m
//  HSConsumer
//
//  Created by zhangqy on 15/9/23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "FDShopFoodModel.h"

@implementation FDShopFoodModel

- (instancetype)initWithDictionary:(NSDictionary*)dict error:(NSError* __autoreleasing*)err
{
    FDShopFoodModel* model = [super initWithDictionary:dict error:err];
    NSString* supportService = model.supportService;
    if (supportService) {

        NSDictionary* sdict = [NSJSONSerialization JSONObjectWithData:[supportService dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        model.supportServiceDict = sdict;
    }

    return model;

}

@end
