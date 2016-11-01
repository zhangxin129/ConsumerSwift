//
//  FDTakeawayShopModel.m
//  HSConsumer
//
//  Created by zhangqy on 15/9/21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "FDShopModel.h"

@implementation FDShopModel

- (instancetype)initWithDictionary:(NSDictionary*)dict error:(NSError* __autoreleasing*)err
{
    FDShopModel* model = [super initWithDictionary:dict error:err];
    CGFloat sendRange = model.sendRange.floatValue;
    CGFloat distance = model.shopDistance.floatValue;
    if (distance <= sendRange || model.sendRange == nil || model.sendRange.length == 0 || [model.sendRange isEqualToString:@""]) {
        model.isInSendRange = YES;
    }
    else {
        model.isInSendRange = NO;
    }
    return model;
}

@end
