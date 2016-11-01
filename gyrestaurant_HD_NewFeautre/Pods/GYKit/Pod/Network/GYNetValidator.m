//
//  GYNetManagerValidator.m
//  Pods
//
//  Created by zhangqy on 16/3/15.
//
//

#import "GYNetValidator.h"

@implementation GYNetValidator

+ (BOOL)verifyResponseObject:(NSDictionary *)dict error:(NSError * *)error {
    NSNumber *retCode = [dict valueForKey:@"retCode"];
    NSString *msg = @"null";
    if ([retCode isKindOfClass:[NSNumber class]]) {
        if ([retCode integerValue] == 200) {
            return YES;
        } else {
            switch ([retCode integerValue]) {
            case 210:
                msg = @"互商key失效.";
                break;
            case 215:
                msg = @"互商key失效.";
                break;
            case 810:
                msg = @"互动个人资料key失效或登录时鉴权失败.";
                break;
            case 208:
                msg = @"互动业务key失效.";
                break;
            default:
                msg = @"";
                break;
            }
            NSString *rMsg = [dict valueForKey:@"msg"];
            if ([rMsg isKindOfClass:[NSString class]] && rMsg.length > 0 && ![rMsg isEqualToString:@"<null>"]) {
                msg = rMsg;
            }

            if (error) *error = [NSError errorWithDomain:@"" code:-9001 userInfo:@{@"NSLocalizedDescription":[NSString stringWithFormat:@"retCode校验失败(retCode=%@)! %@", retCode, msg]}];
            return NO;
        }
    } else {
        if (error) *error = [NSError errorWithDomain:@"" code:-9002 userInfo:@{@"NSLocalizedDescription":[NSString stringWithFormat:@"retCode校验失败! %@", msg]}];
        return NO;
    }


}

@end
