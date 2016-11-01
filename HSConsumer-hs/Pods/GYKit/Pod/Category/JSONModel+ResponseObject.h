//
//  JSONModel+ResponseObject.h
//  Pods
//
//  Created by zhangqy on 16/3/10.
//
//

#import <JSONModel/JSONModel.h>

@interface JSONModel (ResponseObject)
+ (NSArray*)modelArrayWithResponseObject:(NSDictionary*)responseObject error:(NSError**)err;
@end
