//
//  GYNetManagerValidator.h
//  Pods
//
//  Created by zhangqy on 16/3/15.
//
//

#import <Foundation/Foundation.h>

@interface GYNetValidator : NSObject

+ (BOOL)verifyResponseObject:(NSDictionary *)responseObject error:(NSError * *)error;

@end
