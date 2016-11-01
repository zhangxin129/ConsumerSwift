//
//  FDSearchFoodsModel.m
//  HSConsumer
//
//  Created by apple on 15/12/26.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "FDSearchFoodsModel.h"

@implementation FDSearchFoodsModel
- (instancetype)initWithDictionary:(NSDictionary*)dict error:(NSError* __autoreleasing*)err
{
    FDSearchFoodsModel* model = [super initWithDictionary:dict error:err];
    CGFloat sendRange = model.sendRange.floatValue;
    CGFloat distance = model.dist.floatValue;
    if (distance <= sendRange || model.sendRange == nil || model.sendRange.length == 0 || [model.sendRange isEqualToString:@""]) {
        model.isInSendRange = YES;
    }
    else {
        model.isInSendRange = NO;
    }
    return model;
}

@end
