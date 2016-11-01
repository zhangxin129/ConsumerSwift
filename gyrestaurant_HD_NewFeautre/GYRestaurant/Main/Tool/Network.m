//
//  Network.m
//  GYCompany
//
//  Created by cook on 15/9/19.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "Network.h"
#import "AFNetworking.h"
#import "NSObject+HXAddtions.h"
#import "GYencryption.h"
#import "GYAlertView.h"
#import "GYLoginViewController.h"
#import "GYNavigationController.h"
#import "GYGIFHUD.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "GYLoginViewModel.h"
#import "GYHDMessageCenter.h"

@implementation Network


+ (void)initialize
{
    [super initialize];
    [self startMonitoring];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;


}
#define kTimeoutInterval 15.f
#pragma - mark GET请求方式 
#pragma mark   ----2.自动拼接参数
+ (void) GET: (NSString *) requestURLString
                 parameter: (NSDictionary *) parameter
          success: (SuccessValueBlock) block
              failure: (FailureBlock) failureBlock
{
    DDLogCInfo(@"\n----------网络请求----------\nURL:%@\n网络请求PARAMETERS:%@\n--------------请求URL和参数打印完成--------\n",requestURLString,parameter);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:requestURLString parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![self isVerifiedKeys:responseObject]) {
            [GYGIFHUD dismiss];
            return ;
        }
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            block(responseObject);
            
        }else{
            
            [GYGIFHUD dismiss];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
 
}




#pragma mark - 使用json
+ (void)POST: (NSString *) requestURLString

             parameter: (NSDictionary *) parameter

      success: (SuccessValueBlock) block

          failure: (FailureBlock) failureBlock

{
    
    DDLogCInfo(@"\n----------网络请求----------\nURL:%@\n网络请求PARAMETERS:%@\n--------------请求URL和参数打印完成--------\n",requestURLString,parameter);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
 
    [manager  POST:requestURLString parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![self isVerifiedKeys:responseObject]) {
            [GYGIFHUD dismiss];
            return ;
        }
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            block(responseObject);
        }else{
            
            [GYGIFHUD dismiss];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    } ];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
}





#pragma mark - DELETE请求方式
+ (void) DELETE: (NSString *) requestURLString

             parameter: (NSDictionary *) parameter

      success: (SuccessValueBlock) block

          failure: (FailureBlock) failureBlock

{
    DDLogCInfo(@"\n----------网络请求----------\nURL:%@\n网络请求PARAMETERS:%@\n--------------请求URL和参数打印完成--------\n",requestURLString,parameter);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager DELETE:requestURLString parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![self isVerifiedKeys:responseObject]) {
            [GYGIFHUD dismiss];
            return ;
        }
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            block(responseObject);
            
        }else{
            [GYGIFHUD dismiss];
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         failureBlock(error);
    }];
    
    
}


#pragma --mark PUT请求方式

+ (void) PUT: (NSString *) requestURLString

                parameter: (NSDictionary *) parameter

         success: (SuccessValueBlock) block

             failure: (FailureBlock) failureBlock

{
    DDLogCInfo(@"URL:%@\nPARAMETERS:%@\n--------------请求URL和参数打印完成",requestURLString,parameter);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager PUT:requestURLString parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![self isVerifiedKeys:responseObject]) {
            [GYGIFHUD dismiss];
            return ;
        }

        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            block(responseObject);
        }else {
            
            [GYGIFHUD dismiss];
            
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];

}


#pragma mark - private  methods

+ (NSString *)httpBodyparameters:(NSDictionary *)parameters withURLString:(NSString *)urlString
{
    if (!parameters) return @"";//防止解析空参数
    
    NSMutableArray *parametersArray = [NSMutableArray array];
    for (NSString * key in [parameters allKeys])
    {
        id value = [parameters objectForKey:key];
        
        if ([value isKindOfClass:[NSString class]]) {
            
            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
        }
        if ([value isKindOfClass:[NSDictionary class]]) {
            
            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@",key, [self serializeDictionary:value withURLString:urlString]]];
        }
    }
    
    return [parametersArray componentsJoinedByString:@"&"];
}

//序列化GET请求体内部字典加密
+ (NSString *)serializeDictionary :(NSDictionary *)dict withURLString:(NSString *)urlString
{
    NSMutableArray *parametersArray = [[NSMutableArray alloc]init];
    for (NSString * key in [dict allKeys])
    {
        id value = [dict objectForKey:key];
        if ([value isKindOfClass:[NSString class]])
        {
            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
        }
    }
    
    NSString * str =[NSString stringWithFormat:@"{%@}",[parametersArray componentsJoinedByString:@","]];
    
    
    return str;
}




#pragma mark - 登陆验证
/**
 *  判断key是否失效
 */
+ (BOOL)isVerifiedKeys:(NSDictionary *)responseData
{
    
    if (!responseData) {
        return NO;
    }
    DDLogCError(@"\n-----------网络响应数据-----------\n%@\n------------响应数据打印完成------------\n",responseData);
    if ([responseData[@"retCode"] isKindOfClass:[NSNull class]]) {
        
        return YES;
    }
    
        if (responseData[@"retCode"] && [responseData[@"retCode"]integerValue]==210)//互商key失效
        {

            [GYLoginViewModel relogin];
             [[AFHTTPSessionManager manager].operationQueue cancelAllOperations];
            DDLogCInfo(@"互商key失效.");
            return NO;
        }
        if (responseData[@"retCode"] && [responseData[@"retCode"]integerValue]==215)//互商key失效
        {
            [GYLoginViewModel relogin];
             [[AFHTTPSessionManager manager].operationQueue cancelAllOperations];
    
            DDLogCInfo(@"互商key失效.");
            return NO;
        }
        if (responseData[@"retCode"] && [responseData[@"retCode"]integerValue]==810)//互动个人资料key失效或登录时鉴权失败
        {
//            [GYLoginViewModel relogin];
            UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"获取信息列表失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [alterView show];

            return NO;
        }
        if (responseData[@"retCode"] && [responseData[@"retCode"]integerValue]==208)//互动业务key失效
        {
            UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"获取信息列表失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [alterView show];
//            [GYLoginViewModel relogin];
            return NO;
        }
        if (responseData[@"retCode"] && [responseData[@"retCode"]integerValue]==814)
        {
            [GYLoginViewModel relogin];
             [[AFHTTPSessionManager manager].operationQueue cancelAllOperations];
            return NO;
        }
        if(responseData[@"retCode"] && [responseData[@"retCode"] integerValue]==601){
             [[AFHTTPSessionManager manager].operationQueue cancelAllOperations];
            [GYLoginViewModel relogin];
            return NO;
        }
    
    return YES;
}




+(void) startMonitoring
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                DDLogCInfo(@"未识别的网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
//                关联互动连接状态
                
          
//                dispatch_async(dispatch_get_main_queue(), ^{
                
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"xmppOffline" object:nil];
//                });
                
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                DDLogCInfo(@"2G,3G,4G...的网络");
                //                关联互动连接状态
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"xmppOnline" object:nil];
//                dispatch_async(dispatch_get_main_queue(), ^{
                
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"xmppOnline" object:nil];
//                });
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                DDLogCInfo(@"wifi的网络");
                //                关联互动连接状态
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"xmppOnline" object:nil];
//                dispatch_async(dispatch_get_main_queue(), ^{
                
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"xmppOnline" object:nil];
//                });
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];

}

@end

