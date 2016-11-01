//
//  GYGoodsDetailModel.m
//  HSConsumer
//
//  Created by 00 on 15-2-4.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYGoodsDetailModel.h"

@implementation SelShopModel

@end

@implementation ArrSubsModel

@end

@implementation ArrModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.arrSubs = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

@implementation GYGoodsDetailModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.arrBasicParameter = [[NSMutableArray alloc] init];
        self.arrPicList = [[NSMutableArray alloc] init];
        self.arrPropList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setLowPrice:(NSString*)lowPrice
{
    if (!lowPrice) {
        _lowPrice = @"";
        return;
    }
    _lowPrice = [NSString stringWithFormat:@"%.02f", [lowPrice doubleValue]];
}

@end


