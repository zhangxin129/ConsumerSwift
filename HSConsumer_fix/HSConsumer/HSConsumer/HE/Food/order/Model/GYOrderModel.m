//
//  GYOrderModel.m
//  HSConsumer
//
//  Created by appleliss on 15/9/24.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOrderModel.h"
#import "MJExtension.h"
@implementation GYOrderModel

+ (NSDictionary*)replacedKeyFromPropertyName
{

    return @{ @"orderNumber" : @"orderId",
        @"userIds" : @"userId",
        @"useDate" : @"planTime",
        @"restaurantName" : @"shopName",
        @"type" : @"repastForm",
        @"preAmount" : @"prePayAmount",
        @"orderSate" : @"orderStatus",
        @"foodArr" : @"foodList",
        @"restaurantAddres" : @"addr" };
}

// 孙秋明合并代码 注释
+ (void)confirmanOrderFromNetWork:(NSData*)params andUrl:(NSString*)url andOrdeBlock:(retCodeBlock)block
{
}

+ (void)orderDataFromNetWork:(NSDictionary*)params andUrl:(NSString*)url andOrdeBlock:(GYOderModelDataBlock)block
{
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:url
                                                     parameters:params
                                                  requestMethod:GYNetRequestMethodGET
                                              requestSerializer:GYNetRequestSerializerJSON
                                                   respondBlock:^(NSDictionary* responseObject, NSError* error) {
                                                       if (error) {
                                                           block(nil, error);
                                                           return;
                                                       }
                                                       NSMutableDictionary* restDic = [responseObject mutableCopy];
                                                       block(restDic, nil);
                                                   }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

+ (void)requestOrderDetailsforNetWork:(NSDictionary*)params andUrl:(NSString*)url andOrderDetails:(GYOderModelDataBlock)block
{
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:url
                                                     parameters:params
                                                  requestMethod:GYNetRequestMethodGET
                                              requestSerializer:GYNetRequestSerializerJSON
                                                   respondBlock:^(NSDictionary* responseObject, NSError* error) {
                                                       if (error) {
                                                           block(nil, error);
                                                           return;
                                                       }
                                                       NSMutableDictionary* restDic = [responseObject mutableCopy];
                                                       block(restDic, nil);
                                                   }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
    
    [Network GET:url parameters:params completion:^(id responseObject, NSError* error) {

        if (!error) {
            NSMutableDictionary *restDic = responseObject;
            block(restDic, nil);
        } else {
            block(nil, error);
        }
    }];
}

/***
 *取消订单
 */
+ (void)cancelOrderFromNetWork:(NSDictionary*)params andUrl:(NSString*)url andOrderBlock:(GYOderModelDataBlock)block
{
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:url
                                                     parameters:params
                                                  requestMethod:GYNetRequestMethodPOST
                                              requestSerializer:GYNetRequestSerializerHTTP
                                                   respondBlock:^(NSDictionary* responseObject, NSError* error) {
                                                       if (error) {
                                                           block(nil, error);
                                                           return;
                                                       }
                                                       NSMutableDictionary* restDic = [responseObject mutableCopy];
                                                       block(restDic, nil);
                                                   }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

/*
 *企业给消费者下单  消费者确认
 *
 */
+ (void)enterpriseToConsumersPlaceOrder:(NSDictionary*)params andUrl:(NSString*)url andRetCodeBlock:(GYOderModelDataBlock)block
{
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:url
                                                     parameters:params
                                                  requestMethod:GYNetRequestMethodPOST
                                              requestSerializer:GYNetRequestSerializerJSON
                                                   respondBlock:^(NSDictionary* responseObject, NSError* error) {
                                                       if (error) {
                                                           block(nil, error);
                                                           return;
                                                       }
                                                       NSMutableDictionary* restDic = [responseObject mutableCopy];
                                                       block(restDic, nil);
                                                   }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

// 孙秋明合并代码注释
/*
 *外卖  消费者确认收货
 *
 */
+ (void)confirmGoods:(NSDictionary*)params andUrl:(NSString*)url andRetCodeBlock:(GYOderModelDataBlock)block
{
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:url
                                                     parameters:params
                                                  requestMethod:GYNetRequestMethodPOST
                                              requestSerializer:GYNetRequestSerializerJSON
                                                   respondBlock:^(NSDictionary* responseObject, NSError* error) {
                                                       if (error) {
                                                           block(nil, error);
                                                           return;
                                                       }
                                                       NSMutableDictionary* restDic = [responseObject mutableCopy];
                                                       block(restDic, nil);
                                                   }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

@end
