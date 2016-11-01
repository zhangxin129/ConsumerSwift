//
//  Network.h
//  HSConsumer
//
//  Created by apple on 14-10-9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//以下为互生必须固定的参数
#define kuType @"ios" //设备类型
typedef void (^HTTPHandler)(NSData* jsonData, NSError* error);

typedef void (^NetworkCompletion)(id responseObject, NSError* error);

#import <Foundation/Foundation.h>

@interface Network : NSObject

+ (void)GET:(NSString*)URLString parameters:(NSDictionary*)parameters isJsonRequest:(BOOL)isJsonRequest completion:(NetworkCompletion)completion;

+ (void)Post:(NSString*)URLString parameters:(NSDictionary*)parameters isJsonRequest:(BOOL)isJsonRequest completion:(NetworkCompletion)completion;

+ (void)GET:(NSString*)URLString parameters:(NSDictionary*)parameters completion:(NetworkCompletion)completion;

+ (void)Post:(NSString*)URLString hidenHUD:(BOOL)hidenHUD parameters:(NSDictionary*)parameters completion:(NetworkCompletion)completion;
+ (void)Post:(NSString*)URLString parameters:(NSDictionary*)parameters completion:(NetworkCompletion)completion;
+ (void)PostTextHtmlUrlString:(NSString*)URLString parameters:(NSDictionary*)parameters completion:(NetworkCompletion)completion;
+ (void)Put:(NSString*)URLString parameters:(NSDictionary*)parameters completion:(NetworkCompletion)completion;

+ (void)Delete:(NSString*)URLString parameters:(NSDictionary*)parameters completion:(NetworkCompletion)completion;

+ (void)Post:(NSString*)URLString parameters:(NSDictionary*)parameters image:(UIImage*)image completion:(NetworkCompletion)completion;

+ (void)HttpPostRequetURL:(NSString*)urlString parameters:(NSDictionary*)parameters requetResult:(HTTPHandler)handler;

+ (void)HttpPostForImRequetURL:(NSString*)urlString parameters:(NSDictionary*)parameters requetResult:(HTTPHandler)handler;

@end
