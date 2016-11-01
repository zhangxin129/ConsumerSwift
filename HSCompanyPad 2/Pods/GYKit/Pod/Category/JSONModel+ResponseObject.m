//
//  JSONModel+ResponseObject.m
//  Pods
//
//  Created by zhangqy on 16/3/10.
//
//

#import "JSONModel+ResponseObject.h"

@implementation JSONModel (ResponseObject)

+ (NSArray*)modelArrayWithResponseObject:(NSDictionary*)responseObject error:(NSError* __autoreleasing*)err
{
    NSMutableArray* modelArray = [[NSMutableArray alloc] init];
    void (^parseBlock)(NSDictionary*) = ^(NSDictionary* dict) {
        @try {
            JSONModel *model = [[self alloc] initWithDictionary:dict error:err];
            if (model) {
                [modelArray addObject:model];
            }
        }@catch (NSException *exception) {
            if (err && !*err) *err = [NSError errorWithDomain:@"" code:-9003 userInfo:@{@"NSLocalizedDescription":exception.description}];
        } @finally {

        }
    };

    id data = responseObject[@"data"];
    if ([data isKindOfClass:[NSArray class]]) {
        NSArray* dataArray = data;
        for (int i = 0; i < dataArray.count; i++) {
            NSDictionary* dict = dataArray[i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                parseBlock(dict);
            }
        }
    }
    else if ([data isKindOfClass:[NSDictionary class]]) {
        parseBlock(data);
    }

    if (modelArray.count > 0) {
        return modelArray;
    }

    if (err && !(*err))
        *err = [NSError errorWithDomain:@"" code:-9004 userInfo:@{ @"NSLocalizedDescription" : @"data为空" }];

    return nil;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

#pragma clang diagnostic pop

@end
