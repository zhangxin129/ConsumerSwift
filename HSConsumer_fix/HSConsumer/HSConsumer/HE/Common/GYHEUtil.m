//
//  GYHEUtil.m
//  HSConsumer
//
//  Created by xiongyn on 16/7/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEUtil.h"
#import "GYAlertView.h"

@implementation GYHEUtil

+ (void)alertViewParseNetWork:(NSDictionary*)serverDic
{
    if ([GYUtils checkDictionaryInvalid:serverDic]) {
        [GYAlertView showMessage:kLocalized(@"GYHE_SurroundVisit_RequestNetworkDataFail")];
        return;
    }

    NSString* msg = [serverDic objectForKey:@"msg"];
    if ([GYUtils checkStringInvalid:msg]) {
        msg = kLocalized(@"GYHE_SurroundVisit_RequestNetworkDataFail");
    }
    [GYAlertView showMessage:msg];
}

+ (void)showLocationServiceInfo:(void (^)())cancleBlock
{
    NSURL* url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
    NSString* confirmMsg = [[UIApplication sharedApplication] canOpenURL:url] ? kLocalized(@"GYHE_SurroundVisit_ToSet") : nil;
    NSString* msg = [NSString stringWithFormat:@"%@\n%@", kLocalized(@"GYHE_SurroundVisit_PositioningServiceNoOpen"), kLocalized(@"GYHE_SurroundVisit_PositioningServiceOpen")];

    [GYAlertView showMessage:msg cancleButtonTitle:kLocalized(@"GYHE_SurroundVisit_ManualSwitching") confirmButtonTitle:confirmMsg cancleBlock:^{
        if (cancleBlock) {
            cancleBlock();
        }
    } confirmBlock:^{
        [[UIApplication sharedApplication] openURL:url];
    }];
}

@end
