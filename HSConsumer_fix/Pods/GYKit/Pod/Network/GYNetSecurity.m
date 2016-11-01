//
//  GYNetSecurity.m
//  Pods
//
//  Created by zhangqy on 16/3/23.
//
//

#import "GYNetSecurity.h"
#import <AFNetworking/AFNetworking.h>

@implementation GYNetSecurity

+ (AFSecurityPolicy*)securityPolicyWithContentsOfFile:(NSString*)cerPath
{
    NSData* certData = [NSData dataWithContentsOfFile:cerPath];
    if (!certData) {
        return [AFSecurityPolicy defaultPolicy];
    }
    AFSecurityPolicy* securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
    return securityPolicy;
}

@end
