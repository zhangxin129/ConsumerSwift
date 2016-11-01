//
//  GYNetManagerCache.m
//  Pods
//
//  Created by zhangqy on 16/3/15.
//
//

#import "GYNetCache.h"
#import <CommonCrypto/CommonDigest.h>
#import "GYNetRequest.h"

@implementation GYNetCache

+ (void)cacheResponseObject:(NSDictionary *)responseObject URL:(NSString *)URLString parameters:(NSDictionary *)parameters {
    if (!responseObject || !URLString) {
        return;
    }
    if (!([responseObject isKindOfClass:[NSDictionary class]] && responseObject.count > 0)) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachePath = [self cachePathWithURL:URLString parameters:parameters];
        [NSKeyedArchiver archiveRootObject:responseObject toFile:cachePath];
    });
}

+ (void)responseObjectFromCacheURL:(NSString *)URLString parameters:(NSDictionary *)parameters completion:(void (^)(NSDictionary *))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachePath = [self cachePathWithURL:URLString parameters:parameters];
        NSDictionary *responseObject = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
        if ([responseObject isKindOfClass:[NSDictionary class]] && responseObject.count > 0) {
            completion(responseObject);
        }
    });
}

+ (NSString *)cachePathWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters {
    if (URLString == nil || [URLString length] == 0)
        return nil;
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *oriName = URLString;
    if ([parameters isKindOfClass:[NSDictionary class]] && [parameters count] > 0) {
        oriName = [URLString stringByAppendingString:[parameters description]];
    }
    NSString *md5Name = [self md5StringFromString:oriName];
    NSString *path = [docPath stringByAppendingPathComponent:md5Name];
    path = [path stringByAppendingString:@".plist"];
    return path;
}

+ (NSString *)md5StringFromString:(NSString *)string {
    if (string == nil || [string length] == 0)
        return nil;
    const char *value = [string UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++) {
        [outputString appendFormat:@"%02x", outputBuffer[count]];
    }
    return outputString;
}

@end
