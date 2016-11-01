//
//  GYHEGoodsDetailsModel.m
//  HSConsumer
//
//  Created by lizp on 2016/10/24.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEGoodsDetailsModel.h"

@implementation GYHEGoodsDetailsModel

+(JSONKeyMapper *)keyMapper {

    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"idString":@"id"}];
}

@end


@implementation SupportServiceModel

@end



@implementation SkuModel

+(JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"idString":@"id"}];
}

@end


@implementation SkuNameModel

@end