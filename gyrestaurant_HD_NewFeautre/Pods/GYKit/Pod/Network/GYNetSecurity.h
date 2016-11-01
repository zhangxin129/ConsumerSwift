//
//  GYNetSecurity.h
//  Pods
//
//  Created by zhangqy on 16/3/23.
//
//

#import <Foundation/Foundation.h>
@class AFSecurityPolicy;
@interface GYNetSecurity : NSObject
+ (AFSecurityPolicy *)securityPolicyWithContentsOfFile:(NSString *)cerPath;
@end
