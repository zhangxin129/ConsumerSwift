//
//  Network.m
//  HSConsumer
//
//  Created by apple on 14-10-9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "Network.h"
#import "AFNetworking.h"
#import "GYAppDelegate.h"
#import "GYGIFHUD.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "GYSlideMenuController.h"
#import "GYHSLoginManager.h"

@implementation Network

+ (void)initialize
{
    [super initialize];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [self startMonitoringNetState];
}

+ (void)startMonitoringNetState
{
    AFNetworkReachabilityManager* manager = [AFNetworkReachabilityManager sharedManager];
    globalData.isOnNet = YES;

    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
        case AFNetworkReachabilityStatusUnknown:
            globalData.isOnNet = NO;
            break;
        case AFNetworkReachabilityStatusNotReachable:
            [GYGIFHUD dismiss];     //在这里关闭网络提示图

            globalData.isOnNet = NO;
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            globalData.isOnNet = YES;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            globalData.isOnNet = YES;
            break;
        default:
            break;
        }
    }];
    [manager startMonitoring];
}

+ (void)GET:(NSString*)URLString parameters:(NSDictionary*)parameters isJsonRequest:(BOOL)isJsonRequest completion:(NetworkCompletion)completion
{
    [GYUtils collectUserInfoAppRequestURLsWith:URLString parmas:parameters];
    [GYGIFHUD show];
    [self printRequest:URLString parameters:parameters];
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    if (isJsonRequest) {
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    else {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    manager.requestSerializer.timeoutInterval = kNetworkTimeoutTime;

    [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
        [GYGIFHUD dismiss];
        [self printResponse:responseObject];
        if (![Network isVerifiedKeys:responseObject]) return;
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
        [GYGIFHUD dismiss];
        [self printResponse:nil];
        [[self class] showMessageNetwrokError:error];
    }];
}

+ (void)Post:(NSString*)URLString parameters:(NSDictionary*)parameters isJsonRequest:(BOOL)isJsonRequest completion:(NetworkCompletion)completion
{
    if (!globalData.isOnNet)
        return;
    [GYUtils collectUserInfoAppRequestURLsWith:URLString parmas:parameters];
    [GYGIFHUD show];
    [self printRequest:URLString parameters:parameters];
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    if (isJsonRequest) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    else {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = kNetworkTimeoutTime;

    [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
        [GYGIFHUD dismiss];
        [self printResponse:responseObject];
        if (![Network isVerifiedKeys:responseObject]) return;
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
        [GYGIFHUD dismiss];
        [self printResponse:nil];
        [[self class] showMessageNetwrokError:error];
    }];
}

+ (void)GET:(NSString*)URLString parameters:(NSDictionary*)parameters completion:(NetworkCompletion)completion
{
    if (!globalData.isOnNet)
        return;

    [GYUtils collectUserInfoAppRequestURLsWith:URLString parmas:parameters];
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];

    NSMutableDictionary* dictM = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSArray* keysArray = [dictM allKeys];

    if (globalData.loginModel.token.length > 0) {
        [manager.requestSerializer setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        if (![keysArray containsObject:@"token"]) {
            [dictM setValue:globalData.loginModel.token forKey:@"token"];
        }
    }
    [self printRequest:URLString parameters:dictM];
    [manager GET:URLString parameters:dictM progress:nil success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
        [GYGIFHUD dismiss];
        [self printResponse:responseObject];
        if (![Network isVerifiedKeys:responseObject]) return;
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
        [self printResponse:nil];
        [GYGIFHUD dismiss];
//        completion(nil,error);
        [[self class] showMessageNetwrokError:error];
    }];
}

+ (void)Post:(NSString*)URLString hidenHUD:(BOOL)hidenHUD parameters:(NSDictionary*)parameters completion:(NetworkCompletion)completion
{
    if (!globalData.isOnNet)
        return;
    if (!hidenHUD) {
        [GYGIFHUD show];
    }

    [GYUtils collectUserInfoAppRequestURLsWith:URLString parmas:parameters];
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = kNetworkTimeoutTime;
    NSMutableDictionary* dictM = [NSMutableDictionary dictionaryWithDictionary:parameters];

    if (globalData.loginModel.token.length > 0) {
        [manager.requestSerializer setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        //        if(![keysArray containsObject:@"token"]) {
        //            [dictM setValue:globalData.loginModel.token forKey:@"token"];
        //        }
    }
    [self printRequest:URLString parameters:dictM];
    [manager POST:URLString parameters:dictM progress:nil success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {

        if (!hidenHUD) {
               [GYGIFHUD dismiss];
        }
        [self printResponse:responseObject];
        if (![Network isVerifiedKeys:responseObject]) return;
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
        [self printResponse:nil];
        if (!hidenHUD) {
            [GYGIFHUD dismiss];
            [[self class] showMessageNetwrokError:error];
        }
    }];
}

+ (void)Post:(NSString*)URLString parameters:(NSDictionary*)parameters completion:(NetworkCompletion)completion
{
    if (!globalData.isOnNet)
        return;
    [GYGIFHUD show];
    [GYUtils collectUserInfoAppRequestURLsWith:URLString parmas:parameters];
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = kNetworkTimeoutTime;
    NSMutableDictionary* dictM = [NSMutableDictionary dictionaryWithDictionary:parameters];

    if (globalData.loginModel.token.length > 0) {
        [manager.requestSerializer setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        //        if(![keysArray containsObject:@"token"]) {
        //            [dictM setValue:globalData.loginModel.token forKey:@"token"];
        //        }
    }
    [self printRequest:URLString parameters:dictM];
    [manager POST:URLString parameters:dictM progress:nil success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
        [GYGIFHUD dismiss];
        [self printResponse:responseObject];
        if (![Network isVerifiedKeys:responseObject]) return;
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
        [self printResponse:nil];
        [GYGIFHUD dismiss];
        [[self class] showMessageNetwrokError:error];
    }];
}

+ (void)PostTextHtmlUrlString:(NSString*)URLString parameters:(NSDictionary*)parameters completion:(NetworkCompletion)completion
{

    if (!globalData.isOnNet)
        return;
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = kNetworkTimeoutTime;

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if (globalData.loginModel.token.length > 0) {
        [manager.requestSerializer setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        //        if(![keysArray containsObject:@"token"]) {
        //            [dictM setValue:globalData.loginModel.token forKey:@"token"];
        //        }
    }
    [manager POST:URLString parameters:parameters progress:^(NSProgress* _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
        NSError *jError = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&jError];
        completion(dict,nil);
        [self printResponse:dict];
    } failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
//        failure(task, error);
        [self printResponse:nil];
//        [[self class] showMessageNetwrokError:error];
    }];
}

+ (void)Put:(NSString*)URLString parameters:(NSDictionary*)parameters completion:(NetworkCompletion)completion
{
    if (!globalData.isOnNet)
        return;
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = kNetworkTimeoutTime;
    NSMutableDictionary* dictM = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSArray* keysArray = [dictM allKeys];
    if (globalData.loginModel.token.length > 0) {
        [manager.requestSerializer setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        if (![keysArray containsObject:@"token"]) {
            [dictM setValue:globalData.loginModel.token forKey:@"token"];
        }
    }
    [self printRequest:URLString parameters:dictM];
    [manager PUT:URLString parameters:dictM success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
        [GYGIFHUD dismiss];
        [self printResponse:responseObject];
        if (![Network isVerifiedKeys:responseObject]) return;
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
        [self printResponse:nil];
        [GYGIFHUD dismiss];
        [[self class] showMessageNetwrokError:error];
    }];
}

+ (void)Delete:(NSString*)URLString parameters:(NSDictionary*)parameters completion:(NetworkCompletion)completion
{
    if (!globalData.isOnNet)
        return;
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = kNetworkTimeoutTime;
    NSMutableDictionary* dictM = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSArray* keysArray = [dictM allKeys];
    if (globalData.loginModel.token.length > 0) {
        [manager.requestSerializer setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        if (![keysArray containsObject:@"token"]) {
            [dictM setValue:globalData.loginModel.token forKey:@"token"];
        }
    }
    [self printRequest:URLString parameters:dictM];
    [manager DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
        [GYGIFHUD dismiss];
        [self printResponse:responseObject];
        if (![Network isVerifiedKeys:responseObject]) return;
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
        [self printResponse:nil];
        [GYGIFHUD dismiss];
        [[self class] showMessageNetwrokError:error];
    }];
}

+ (void)Post:(NSString*)URLString parameters:(NSDictionary*)parameters image:(UIImage*)image completion:(NetworkCompletion)completion
{
    if (!globalData.isOnNet)
        return;

    [GYUtils collectUserInfoAppRequestURLsWith:URLString parmas:parameters];
    [self printRequest:URLString parameters:parameters];
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    NSMutableDictionary* dictM = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSArray* keysArray = [dictM allKeys];
    if (globalData.loginModel.token.length > 0) {
        [manager.requestSerializer setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        if (![keysArray containsObject:@"token"]) {
            [dictM setValue:globalData.loginModel.token forKey:@"token"];
        }
    }

    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        [formData appendPartWithFileData:data name:@"image" fileName:@"0.png" mimeType:@"image/jpeg"];
    } progress:^(NSProgress* _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
        [GYGIFHUD dismiss];
        [self printResponse:responseObject];
        if (![Network isVerifiedKeys:responseObject]) return;
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
        [self printResponse:nil];
        [GYGIFHUD dismiss];
        [[self class] showMessageNetwrokError:error];
    }];
}

+ (void)printRequest:(NSString*)URLString parameters:(NSDictionary*)parameters
{
    DDLogInfo(@"打印请求链接=======================");
    if (parameters) {
        NSError* error = nil;
        NSData* data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
        NSString* jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        DDLogInfo(@"%@?%@", URLString, jsonStr);
    }
    else {
        DDLogInfo(@"%@", URLString);
    }
    DDLogInfo(@"======================完成打印请求链接");
}

+ (void)printResponse:(id)responseObject
{
    DDLogInfo(@"打印响应结果=======================");
    if (responseObject) {
        NSData* data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        DDLogInfo(@"%@", str);
    }
    DDLogInfo(@"======================完成打印响应结果");
}

//下面方法不要再使用======================================

+ (void)HttpPostRequetURL:(NSString*)urlString parameters:(NSDictionary*)parameters requetResult:(HTTPHandler)handler
{

    NSMutableDictionary* params = [parameters mutableCopy];
    DDLogInfo(@"<<*******************打印 POST 请求链接*******************");
    DDLogInfo(@"POST请求URL：%@  parameters:%@", urlString, params);
    DDLogInfo(@"*******************完成打印 POST 请求链接*****************>>");
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = kNetworkTimeoutTime;
    [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
        DDLogInfo(@"<<*******************打印 POST 响应结果*******************");
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        DDLogInfo(@"POST 响应结果: %@", jsonString);
        DDLogInfo(@"*******************完成打印 POST 响应结果****************>>");

        if (!responseObject) {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setValue:@"null response" forKey:NSLocalizedDescriptionKey];
            [userInfo setValue:@"Could not decode string" forKey:NSLocalizedFailureReasonErrorKey];
            [userInfo setValue:kLocalized(@"GYHS_Base_server_not_responding_please_try_again_later") forKey:@"error" ];
            //NSError *error = [[NSError alloc] initWithDomain:@"com.gyist.hs" code:NSURLErrorCannotDecodeContentData userInfo:userInfo];
            [GYUtils showToast:kLocalized(@"GYHS_Base_networkError")];

            return;
        }
        if (![Network isVerifiedKeys:responseObject]) return;

        handler(responseObject, nil);

    } failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
        DDLogInfo(@"<<*******************打印 POST 响应结果*******************");
        DDLogError(@"POST 响应错误 Error:%@", error);
        DDLogInfo(@"*******************完成打印 POST 响应结果****************>>");
        [[self class] showMessageNetwrokError:error];
    }];
}

+ (void)HttpPostForImRequetURL:(NSString*)urlString parameters:(NSDictionary*)parameters requetResult:(HTTPHandler)handler
{

    NSData* data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableURLRequest* request =
        [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Contsetent-Type"];
    [request setHTTPBody:data];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable connectionError) {
        if (connectionError == nil) {

            DDLogInfo(@"<<*******************打印 POST 响应结果*******************");
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            DDLogInfo(@"POST 响应结果: %@", jsonString);
            DDLogInfo(@"*******************完成打印 POST 响应结果****************>>");
            dispatch_async(dispatch_get_main_queue(), ^{
                    handler(data, nil);
            });
        
        } else {
            handler(nil, connectionError);
        }
    }];
}

+ (NSString*)httpBodyWithParameters:(NSDictionary*)parameters withURLString:(NSString*)urlString
{
    // songjk 检查网络
    if (!globalData.isOnNet) {
        return @"";
    }
    if (!parameters)
        return @""; //防止解析空参数

    NSMutableArray* parametersArray = [NSMutableArray array];
    for (NSString* key in [parameters allKeys]) {
        id value = [parameters objectForKey:key];

        if ([value isKindOfClass:[NSString class]]) {

            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
        }
        if ([value isKindOfClass:[NSDictionary class]]) {

            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@", key, [self serializeDictionary:value withURLString:urlString]]];
        }
    }

    return [parametersArray componentsJoinedByString:@"&"];
}

//序列化GET请求体内部字典
+ (NSString*)serializeDictionary:(NSDictionary*)dict withURLString:(NSString*)urlString
{
    NSMutableArray* parametersArray = [[NSMutableArray alloc] init];

    for (NSString* key in [dict allKeys]) {
        id value = [dict objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
        }
    }
    NSString* str = [NSString stringWithFormat:@"{%@}", [parametersArray componentsJoinedByString:@","]];
    return str;
}

+ (BOOL)isVerifiedKeys:(NSDictionary*)responseData
{
    BOOL isVerified = YES;
    if ([responseData isKindOfClass:[NSData class]]) {
        responseData = [NSJSONSerialization JSONObjectWithData:(NSData*)responseData options:NSJSONReadingMutableContainers error:nil];
    }

    if (responseData[@"retCode"] && kSaftToNSInteger(responseData[@"retCode"]) == 210) { //互商key失效
        [[GYHSLoginManager shareInstance] reLogin];
        DDLogInfo(@"互商key失效.");
        return NO;
    }
    if (responseData[@"retCode"] && kSaftToNSInteger(responseData[@"retCode"]) == 215) { //互商key失效

        DDLogInfo(@"互商key失效.");
        [[GYHSLoginManager shareInstance] reLogin];
        return NO;
    }

    if (responseData[@"retCode"] && kSaftToNSInteger(responseData[@"retCode"]) == 208) { //互动业务key失效

        DDLogInfo(@"互动业务key失效.");
        [[GYHSLoginManager shareInstance] reLogin];
        return NO;
    }
    return isVerified;
}

+ (void)showMessageNetwrokError:(NSError*)error
{
    NSString* msg = kLocalized(@"GYHS_Base_netError");

    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        switch (error.code) {
            case NSURLErrorTimedOut:
                msg = @"网络超时,请稍后再试!";
                break;
            case NSURLErrorNotConnectedToInternet:
                msg = @"网络无连接,请检查网络!";
                break;
            default:
                msg = @"服务器繁忙，请稍候再试!";
                break;
        }
    }
    
    [GYUtils showToast:msg];
}

@end
