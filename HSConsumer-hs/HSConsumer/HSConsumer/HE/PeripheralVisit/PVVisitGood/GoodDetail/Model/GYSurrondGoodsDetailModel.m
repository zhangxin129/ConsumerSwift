//
//  GYSurrondGoodsDetailModel.m
//  HSConsumer
//
//  Created by apple on 15-3-9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSurrondGoodsDetailModel.h"

@implementation GYSurrondGoodsDetailModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _propList = [NSMutableArray array];
        _shopUrl = [NSMutableArray array];
    }
    return self;
}

@end
