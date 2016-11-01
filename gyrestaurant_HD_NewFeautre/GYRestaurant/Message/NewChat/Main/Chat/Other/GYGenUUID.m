//
//  GYGenUUID.m
//  HSConsumer
//
//  Created by shiang on 15/10/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYGenUUID.h"

@implementation GYGenUUID




//iOS 生成 UUID（或者叫GUID）例子代码
+(NSString *)gen_uuid
{
    CFUUIDRef uuid_ref = CFUUIDCreate(nil);
    CFStringRef uuid_string_ref= CFUUIDCreateString(nil, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    uuid=[uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(uuid_string_ref);
    return uuid;
}

+(NSString *)unique_uuid
{
    NSString *deviceID=nil;
    UIDevice *device = [UIDevice currentDevice];//创建设备对象
    NSUUID *UUID = [device identifierForVendor];
    deviceID = [UUID UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return deviceID;
}

+ (NSString *)createUUID
{
    NSDate *date = [NSDate date];
    long long t = ([date timeIntervalSince1970] + [globalData getTimeDifference:NO]) * 1000;
    NSNumber *n = [NSNumber numberWithLongLong:t];
    return [n stringValue];
}
@end
