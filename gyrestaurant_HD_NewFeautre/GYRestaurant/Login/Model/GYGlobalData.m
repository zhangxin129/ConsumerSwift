//
//  GYGlobalData.m
//  GYRestaurant
//
//  Created by apple on 15/10/13.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYGlobalData.h"


@implementation GYGlobalData

SingletonM(Instant)


- (NSTimeInterval)getTimeDifference:(BOOL)isCheck
{
    if (!isCheck)
    {
        return nowTimeInterval;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.baidu.com/"]];
    NSHTTPURLResponse *response = nil;
    NSData *urlDate = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    if (urlDate && response.allHeaderFields)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'"];
        //        [df setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss 'GMT'"];//Tue, 16 Jun 2015 08:01:20 GMT  Wed, 17 Jun 2015 02:21:51 GMT
        df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        NSDate *onLinedate = [df dateFromString:response.allHeaderFields[@"Date"]];
        NSDate *devDate = [NSDate date];
        DDLogCInfo(@"线上时间:%@ 设备时间:%@", onLinedate, devDate);
        if (onLinedate && devDate)
        {
            nowTimeInterval = [onLinedate timeIntervalSince1970] - [devDate timeIntervalSince1970];
        }
        return nowTimeInterval;
    }
    return nowTimeInterval;
}


@end



