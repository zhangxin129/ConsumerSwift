//
//  GYNetManagerValidator.h
//  Pods
//
//  Created by zhangqy on 16/3/15.
//
//

#import <Foundation/Foundation.h>

@class GYNetRequest;
@interface GYNetValidator : NSObject

+ (BOOL)verifyResponseObject:(GYNetRequest*)request
              responseObject:(NSDictionary*)responseObject
                       error:(NSError**)error;

+ (void)showMessageNetwrokError:(NSError*)error;

+ (BOOL)checkShowErrorMsg:(GYNetRequest*)request error:(NSError*)error;

@end
