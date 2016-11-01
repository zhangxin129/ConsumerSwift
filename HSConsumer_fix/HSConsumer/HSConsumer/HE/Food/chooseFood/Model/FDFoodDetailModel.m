//
//  FDFoodDetailModel.m
//  HSConsumer
//
//  Created by zhangqy on 15/11/3.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "FDFoodDetailModel.h"
#import "FDFoodFormatModel.h"
@implementation FDFoodDetailModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"id" : @"foodId" }];
}

- (instancetype)initWithDictionary:(NSDictionary*)dict error:(NSError* __autoreleasing*)err
{
    FDFoodDetailModel* model = [super initWithDictionary:dict error:err];
    NSString* standard = model.standard;
    if ([standard isEqualToString:@""]) {
        FDFoodFormatModel* format = [[FDFoodFormatModel alloc] init];
        format.auction = model.pv;
        format.pId = @"";
        format.pName = @"";
        format.price = model.price;
        format.pVId = @"";
        model.foodFormat = @[ format ];
    }
    else if (standard.length > 10) {
        NSMutableArray* formatArray = [[NSMutableArray alloc] init];
        NSData* data = [standard dataUsingEncoding:NSUTF8StringEncoding];
        NSArray* array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        for (int i = 0; i < array.count; i++) {
            NSDictionary* dict = array[i];
            FDFoodFormatModel* model = [[FDFoodFormatModel alloc] initWithDictionary:dict error:nil];
            [formatArray addObject:model];
        }
        model.foodFormat = formatArray;
    }
    NSString* temp = model.pics;
    temp = [temp stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    NSData* data = [temp dataUsingEncoding:NSUTF8StringEncoding];
    NSArray* array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary* dic = array.lastObject;
    NSArray* arr = dic[@"mobile"];
    NSDictionary* d = arr.lastObject;
    model.foodPicParsed = d[@"name"];
    return model;
}

@end
