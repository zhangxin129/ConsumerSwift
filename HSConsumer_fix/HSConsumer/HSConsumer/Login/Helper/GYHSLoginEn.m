//
//  LoginEn.m
//  HSConsumer
//
//  Created by liangzm on 15-3-25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSLoginEn.h"

@implementation GYHSLoginEn

#pragma mark - 单例
static id _instace;
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];

    });
    return _instace;
}

+ (id)allocWithZone:(struct _NSZone*)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}

- (id)copyWithZone:(NSZone*)zone
{
    return _instace;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.loginLine = [[self class] getInitLoginLine];
    }
    return self;
}

- (void)setLoginLine:(EMLoginEn)l
{
    _loginLine = l;
    globalData.retailDomain = [self getDefaultRetailDomain];
    globalData.foodConsmerDomain = [self getFoodConsmerDomain];
}

//发布环境登录
- (NSString*)getLoginUrl
{
    switch (self.loginLine) {
    case kLoginEn_dev:
        return @"http://192.168.229.182:8080/reconsitution";
        //return @"http://192.168.41.56:8080/reconsitution";//罗宾本地
        //return @"http://192.168.41.44:8084/reconsitution";//张俊本地
        //return @"http://192.168.41.72:8080/reconsitution";// 张平
        //return @"http://192.168.41.56:8080/reconsitution";
        //return @"http://192.168.41.77:8080/reconsitution";//耿佳琪本地
        break;
    case kloginEn_test:
        return @"https://dc.aadv.net/mobile/reconsitution";
        break;
    case kLoginEn_demo:
        return @"http://www.aahv.net:19064/refactor";
        break;

    case kLoginEn_is_release:
    case kLoginEn_is_preRelease:
        return @"https://mobi.hsxt.cn:9446/refactor";
        break;
    default:
        break;
    }
}

//默认电商的
- (NSString*)getDefaultRetailDomain
{
    switch (self.loginLine) {
    case kLoginEn_dev:
        return @"http://192.168.229.72:8080/phapi";
        break;
    case kloginEn_test:
        return @"https://dc.aadv.net/mobile/phapi";
        break;
    case kLoginEn_demo:
        return @"http://mobi.aahv.net:19065/phapi";
        break;
    case kLoginEn_is_release: //发布环境 电商url
    case kLoginEn_is_preRelease:
        return @"https://mobi.hsxt.cn:9447/phapi";
        break;
    default:
        break;
    }
}

//默认餐饮域名的
- (NSString*)getFoodConsmerDomain
{
    switch (self.loginLine) {
    case kLoginEn_dev:
        return @"http://192.168.229.80:9090/foodconsumer";
        break;

    case kloginEn_test:
        return @"https://dp.aaij.net/mobile/person";
        break;

    case kLoginEn_demo:
        return @"http://mobi.aahv.net:19062/person";
        break;

    case kLoginEn_is_release: //发布环境 电商url
    case kLoginEn_is_preRelease:
        return @"https://mobi.hsxt.cn:9444/person";
        break;

    default:
        break;
    }
    return @"/";
}

- (NSString*)getFilterUrl
{
    switch (self.loginLine) {
    case kLoginEn_dev:
        return @"http://192.168.229.80:8083/filter";
        break;
    case kloginEn_test:
        return @"http://192.168.228.51:8080/app-filter";
        break;
    case kLoginEn_demo:
        return @"";
        break;
    case kLoginEn_is_release:
    case kLoginEn_is_preRelease:
        return @"http://hx.hsxt.mobi:9999/hsec-app-filter-service";
        break;

    default:
        break;
    }
    return @"http://hx.hsxt.mobi:9999/hsec-app-filter-service";
}

+ (EMLoginEn)getInitLoginLine
{
    if (![self isReleaseEn]) {

        //return kLoginEn_is_preRelease;
        return kloginEn_test;
        return kLoginEn_dev;
        //return kLoginEn_demo;
    }
    else {
        return kLoginEn_is_release;
    }
}

#pragma mark - 设置发布时参数
//是否为生产发布环境 否：NO 是：YES
+ (BOOL)isReleaseEn {
    return NO;
}

@end
