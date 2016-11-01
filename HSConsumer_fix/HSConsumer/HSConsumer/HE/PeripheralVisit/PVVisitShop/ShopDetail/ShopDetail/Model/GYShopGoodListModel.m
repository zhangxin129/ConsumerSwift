//
//  GYShopGoodListModel.m
//  HSConsumer
//
//  Created by Apple03 on 15/8/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYShopGoodListModel.h"

@implementation GYShopGoodListModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+ (void)loadDataFromNetWorkWithParams:(NSDictionary*)params Complection:(CompletionBlock)block;
{
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:SearchShopItemUrl parameters:params requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {


        NSError *jsonError;
        NSMutableArray *goodsList = [[NSMutableArray alloc] init];
        if (responseObject) {

            NSDictionary *rootDict = responseObject;
            if (jsonError == nil) {
                NSArray *datas = rootDict[@"data"];

                for (NSDictionary *item in datas) {
                    GYShopGoodListModel *model = [[GYShopGoodListModel alloc] initWithDictionary:item error:nil];
                    [goodsList addObject:model];
                }
                block(goodsList, nil);
            }
        }
        if(error) {
            [GYUtils parseNetWork:error resultBlock:nil];
        }

    }];
    [request start];
}

@end
