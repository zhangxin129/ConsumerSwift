//
//  GYNetManagerCache.h
//  Pods
//
//  Created by zhangqy on 16/3/15.
//
//

#import <Foundation/Foundation.h>

@interface GYNetCache : NSObject

+ (void)cacheResponseObject:(NSDictionary *)responseObject URL:(NSString *)URLString parameters:(NSDictionary *)parameters;

+ (void)responseObjectFromCacheURL:(NSString *)URLString parameters:(NSDictionary *)parameters completion:(void (^)(NSDictionary *))completion;

@end
