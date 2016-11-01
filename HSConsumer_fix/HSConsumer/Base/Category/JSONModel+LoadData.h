//
//  JSONModel+LoadData.h
//  HSConsumer
//
//  Created by zhangqy on 15/11/5.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "JSONModel.h"
#import "NSArray+GYJSONString.h"
#import "NSDictionary+GYJSONString.h"
#import "NSString+GYExtension.h"

typedef NS_ENUM(NSUInteger, GYMOption) {
    GYM_GetHttp,

    GYM_GetJson,

    GYM_PostHttp,

    GYM_PostJson,

};

typedef void (^GYModelBlock)(NSArray* modelArray, id responseObject, NSError* error);
@interface JSONModel (LoadData)

+ (void)modelArrayNetURL:(NSString*)urlString parameters:(id)parameters option:(GYMOption)option completion:(GYModelBlock)completion;

+ (void)modelArrayCacheURL:(NSString*)urlString parameters:(id)parameters completion:(GYModelBlock)completion;
@end
