//
//  GYNetManagerValidator.m
//  Pods
//
//  Created by zhangqy on 16/3/15.
//
//

#import "GYNetValidator.h"
#import "GYKitConstant.h"
#import "UIView+Toast.h"
#import "GYNetRequest.h"

@implementation GYNetValidator

+ (BOOL)verifyResponseObject:(NSDictionary*)dict error:(NSError**)error
{
    NSNumber* retCodeNumber = [dict valueForKey:@"retCode"];

    if (![retCodeNumber isKindOfClass:[NSNumber class]]) {
        if (error) {
            *error = [NSError errorWithDomain:@""
                                         code:-9001
                                     userInfo:@{ @"NSLocalizedDescription" : [NSString stringWithFormat:@"返回码校验非法!"] }];
        }

        return NO;
    }

    NSInteger retCode = [retCodeNumber integerValue];
    if (retCode == 200) {
        return YES;
    }

    NSInteger errorCode = retCode;
    NSString* msg = [dict valueForKey:@"msg"];

    if (![msg isKindOfClass:[NSString class]] || msg.length <= 0 || [msg isEqualToString:@"<null>"]) {
        msg = @"请求失败";
    }

    if (error) {
        *error = [NSError errorWithDomain:@"" code:errorCode userInfo:@{ @"NSLocalizedDescription" : msg }];
    }

    return NO;
}

+ (void)showMessageNetwrokError:(NSError*)error
{
    NSString* msg = @"服务器繁忙，请稍候再试!";
    GYKitDebugLog(@"Error Message: %@", [error localizedDescription]);

    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        switch (error.code) {
        case NSURLErrorTimedOut:
            msg = NSLocalizedString(@"网络超时,请稍后再试!", nil);
            break;
        case NSURLErrorNotConnectedToInternet:
            msg = NSLocalizedString(@"网络无连接,请检查网络!", nil);
            break;
        default:
            msg = NSLocalizedString(@"服务器繁忙，请稍候再试!", nil);
            break;
        }
    }

    [[UIApplication sharedApplication].delegate.window makeToast:msg duration:1.f position:CSToastPositionBottom];
}

+ (BOOL)checkShowErrorMsg:(GYNetRequest*)request error:(NSError*)error
{
    NSInteger errorCode = [error code];

    // 网络请求时取下请求
    if (errorCode == -999) {
        return NO;
    }
    // 为YES时不现实
    else if (request.noShowErrorMsg) {
        return NO;
    }
    
    return YES;
}

@end
