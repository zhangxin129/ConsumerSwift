//
//  JSONModel+LoadData.m
//  HSConsumer
//
//  Created by zhangqy on 15/11/5.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#import "Network.h"
#import "JSONModel+LoadData.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation JSONModel (LoadData)

+ (void)modelArrayNetURL:(NSString*)urlString parameters:(id)parameters option:(GYMOption)option completion:(GYModelBlock)completion
{
    BOOL isGetRequest = NO;
    BOOL isJsonRequest = NO;
    BOOL isCache = NO;
    switch (option) {
    case GYM_GetHttp:
        isGetRequest = YES;
        isJsonRequest = NO;
        isCache = YES;
        break;
    case GYM_GetJson:
        isGetRequest = YES;
        isJsonRequest = YES;
        isCache = YES;
        break;
    case GYM_PostHttp:
        isGetRequest = NO;
        isJsonRequest = NO;
        isCache = NO;
        break;
    case GYM_PostJson:
        isGetRequest = NO;
        isJsonRequest = YES;
        isCache = NO;
        break;
    default:
        break;
    }

    [self modelArrayNetURL:urlString parameters:parameters isGetRequest:isGetRequest isJsonRequest:isJsonRequest isCache:isCache completion:^(NSArray* modelArray, id responseObject, NSError* error) {
        completion(modelArray, responseObject, error);
    }];
}

+ (void)modelArrayCacheURL:(NSString*)urlString parameters:(id)parameters completion:(GYModelBlock)completion
{
    NSData* data = [NSData dataWithContentsOfFile:[self cachePathWithUrl:urlString parameters:parameters]];
    if (data) {
        NSArray* modelArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([modelArray isKindOfClass:[NSArray class]] && modelArray.count > 0) {
            completion(modelArray, nil, nil);
        }
    }
    completion(nil, nil, nil);
}

+ (void)modelArrayNetURL:(NSString*)urlString parameters:(id)parameters isGetRequest:(BOOL)isGetRequest isJsonRequest:(BOOL)isJsonRequest isCache:(BOOL)isCache completion:(GYModelBlock)completion
{
    void (^process)(id responseObject, NSError* error) = ^(id responseObject, NSError* error) {
        if (error) {
            completion(nil, nil, error);
            DDLogDebug(@"%@", error);
            return;
        } else {
            NSError *vError = nil;
            if ([self verifyResponseObject:responseObject error:&vError]) {
                NSError *error;
                NSArray *modelArray = [self modelArrayFromParseResponseObject:responseObject error:&error];
                if (isCache) {
                    [self cacheModelArray:modelArray WithURL:urlString parameters:parameters];
                }
                completion(modelArray, responseObject, error);
                if (error) {
                    DDLogDebug(@"%@", error);
                }
                return;
            } else {
                completion(nil, responseObject, vError);
                DDLogDebug(@"%@", vError);
                return;
            }
        }
    };

    if (isGetRequest) {
        GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:urlString parameters:parameters requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
            process(responseObject, error);
        }];
        [request commonParams:[GYUtils netWorkCommonParams]];
        [request start];
    }
    else {
        GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:urlString parameters:parameters requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
            process(responseObject, error);
        }];
        [request commonParams:[GYUtils netWorkCommonParams]];
        [request start];
    }
}

+ (NSArray*)modelArrayFromParseResponseObject:(NSDictionary*)responseObject error:(NSError**)err
{
    NSMutableArray* modelArray = [[NSMutableArray alloc] init];

    void (^parseBlock)(NSDictionary*) = ^(NSDictionary* dict) {
        @try {
            JSONModel *model = [[self alloc] initWithDictionary:dict error:err];
            if (model) {
                [modelArray addObject:model];
            }
        }@catch (NSException *exception) {
            *err = [NSError errorWithDomain:@"" code:-7001 userInfo:@{@"error":exception.description}];
        } @finally {

        }

    };

    id data = responseObject[@"data"];
    if ([data isKindOfClass:[NSArray class]]) {
        NSArray* dataArray = data;
        for (int i = 0; i < dataArray.count; i++) {
            NSDictionary* dict = dataArray[i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                parseBlock(dict);
            }
        }
    }
    else if ([data isKindOfClass:[NSDictionary class]]) {
        parseBlock(data);
    }

    if (modelArray.count > 0) {
        return modelArray;
    }
    return nil;
}

+ (BOOL)verifyResponseObject:(id)responseObject error:(NSError**)err
{

    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        id retCode = [responseObject valueForKey:@"retCode"];
        if ([retCode isKindOfClass:[NSNumber class]] || [retCode isKindOfClass:[NSString class]]) {
            if ([retCode integerValue] == 200) {
                return YES;
            }
            else {
                *err = [NSError errorWithDomain:@"" code:-7000 userInfo:@{ @"error" : [NSString stringWithFormat:@"responseObject校验失败!retCode = %@", retCode] }];
                return NO;
            }
        }
    }
    *err = [NSError errorWithDomain:@"" code:-7000 userInfo:@{ @"error" : [NSString stringWithFormat:@"responseObject校验失败!responseObject = %@", responseObject] }];
    return NO;
}

+ (NSString*)cachePathWithUrl:(NSString*)urlString parameters:(id)params
{
    if (![params isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString* name = urlString;
    if ([params isKindOfClass:[NSDictionary class]] && [params count] > 0) {
        name = [urlString stringByAppendingString:[params description]];
    }
    const char* cStr = [name UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)name.length, digest);
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    NSString* path = [docPath stringByAppendingPathComponent:result];
    return path;
}

+ (void)cacheModelArray:(NSArray*)modelArray WithURL:(NSString*)urlString parameters:(id)parameters
{
    NSString* path = [self cachePathWithUrl:urlString parameters:parameters];
    if (path) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:modelArray];
            [data writeToFile:path atomically:YES];
        });
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"id" : @"kId",
        @"description" : @"kDescription" }];
}

#pragma clang diagnostic pop
@end
