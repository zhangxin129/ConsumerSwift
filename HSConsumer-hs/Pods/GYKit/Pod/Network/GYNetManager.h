//
//  GYNetManager.h
//  Pods
//
//  Created by zhangqy on 16/3/14.
//
//

#import <Foundation/Foundation.h>
@class GYNetRequest;
@class AFSecurityPolicy;

@interface GYNetManager : NSObject

@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (nonatomic, strong) AFSecurityPolicy* securityPolicy;

+ (instancetype)sharedManager;

- (void)startRequest:(GYNetRequest*)request;

- (void)cancelRequest:(GYNetRequest*)request;

- (void)cancelAllRequest;

@end
