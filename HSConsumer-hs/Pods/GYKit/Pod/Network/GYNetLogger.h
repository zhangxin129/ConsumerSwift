//
//  GYNetLogger.h
//  Pods
//
//  Created by zhangqy on 16/3/30.
//
//

#import <Foundation/Foundation.h>
@class GYNetRequest;
@interface GYNetLogger : NSObject
+ (void)printResponse:(NSDictionary*)responseObject request:(GYNetRequest*)request;
+ (void)printRequest:(GYNetRequest*)request;
+ (void)printCancelRequest:(GYNetRequest*)request;
+ (void)printAddRequest:(GYNetRequest*)request requestQueue:(NSDictionary*)requestQueue;
+ (void)printRemoveRequest:(GYNetRequest*)request requestQueue:(NSDictionary*)requestQueue;
+ (void)printRequestFinished:(GYNetRequest*)request;
+ (void)printRequestFailed:(GYNetRequest*)request;
+ (void)printAllRequestFinished;
+ (void)printRequesting;
+ (void)printRequestDealloc:(GYNetRequest*)request;
+ (void)printResponseError:(NSError*)error request:(GYNetRequest*)request;

@end
