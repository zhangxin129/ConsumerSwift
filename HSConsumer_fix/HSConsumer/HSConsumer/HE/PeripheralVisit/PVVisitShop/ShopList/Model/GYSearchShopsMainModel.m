//
//  GYSearchShopsMainModel.m
//  HSConsumer
//
//  Created by apple on 15/11/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSearchShopsMainModel.h"

@implementation GYSearchShopsMainModel

- (void)setValue:(id)value forKey:(NSString*)key
{

    //判断是否为NSNumber类型
    if ([value isKindOfClass:[NSNumber class]]) {

        [self setValue:[NSString stringWithFormat:@"%@", value] forKey:key];
    }
    else {

        //调用父类的方法
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString*)key
{
    //手动赋值
    if ([key isEqualToString:@"id"]) {

        [self setValue:value forKey:@"idStr"];
    }
    else {

        //        DDLogDebug(@"未定的key值：%@",key);
    }
}

- (id)valueForUndefinedKey:(NSString*)key
{

//    DDLogDebug(@"未找到key:%@",key);
    return nil;
}

@end
