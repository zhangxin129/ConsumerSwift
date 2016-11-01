//
//  GYExpressModel.m
//  HSConsumer
//
//  Created by apple on 16/3/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYExpressModel.h"

@implementation GYExpressModel
- (void)loadModelDataWithDictionary:(NSDictionary*)dic
{

    self.expressId = kSaftToNSString(dic[@"id"]);
    self.name = kSaftToNSString(dic[@"name"]);
    self.code = kSaftToNSString(dic[@"code"]);
    self.isSelect = NO;
}

@end
