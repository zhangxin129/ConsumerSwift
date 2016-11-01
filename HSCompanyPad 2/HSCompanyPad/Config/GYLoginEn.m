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

#import "GYLoginEn.h"

@implementation GYLoginEn

+ (GYLoginEn*)sharedInstance
{
    static GYLoginEn* _s = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _s = [[self alloc] init];
    });
    return _s;
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
}

/**
 *  获取登录接口
 *
 *  @return 接口
 */
- (NSString*)getLoginUrl
{
    switch (self.loginLine) {
    case kLoginEn_dev:
        return @"http://192.168.229.72:8090/made"; //开发环境服务机,其他同事如需要修改，请修改完后改回来，谢谢！！！
//
            return @"http://192.168.41.56:8090/made"; ///罗宾本地
      
        return @"http://192.168.41.44:8090/made"; ///张俊本地
        
        break;
    case kLoginEn_testA:
           return @"https://dc.aadv.net/mobile/padmade";
    case kLoginEn_test_realPay:
        return @"https://dc.aadv.net/mobile/reconsitution";
        
        break;
    case kLoginEn_demo:
        return @"http://www.aahv.net:19064/refactor";
        
        break;
    case kLoginEn_release: //发布环境 登录url
        return @"https://mobi.hsxt.cn:9446/refactor";
        break;
    case kLoginEn_testB: //发布环境 登录url
        return @"https://dc.aadv.net:10443/mobile/padmade";
        break;
    default:
        break;
    }
    return @"http://192.168.229.80:9999";
}


/**
 *  获取重构项目
 *
 *  @return 接口
 */
- (NSString*)getReconsitution
{
    switch (self.loginLine) {
        case kLoginEn_dev:
           return @"http://192.168.229.182:8080/reconsitution";//开发环境服务机,其他同事如需要修改，请修改完后改回来，谢谢！！！
            //        return @"http://192.168.41.72:8080/reconsitution";
            //             return @"http://192.168.41.77:8080/reconsitution";
            return @"http://192.168.41.56:8080/reconsitution"; ///罗宾本地
            return @"http://192.168.41.44:8084/reconsitution"; ///张俊本地
            
            break;
        case kLoginEn_testA:
        case kLoginEn_test_realPay:
            return @"https://dc.aadv.net/mobile/reconsitution";
            
            break;
        case kLoginEn_testB://测试环境B
            return @"https://dc.aadv.net:10443/mobile/reconsitution";
            break;
        case kLoginEn_demo:
            return @"http://www.aahv.net:19064/refactor";
            
            break;
        case kLoginEn_release: //发布环境 登录url
        case kLoginEn_preRelease: //发布环境 登录url
            return @"https://mobi.hsxt.cn:9446/refactor";
            break;
        default:
            break;
    }
    return @"http://192.168.229.80:9999";
}

- (NSString*)getFilterUrl
{
    switch (self.loginLine) {
    case kLoginEn_dev:
        return @"http://192.168.229.80:8083/filter";
        break;
    case kLoginEn_testA:
    case kLoginEn_test_realPay:
        return @"http://192.168.228.51:8080/app-filter";
        
        break;
    case kLoginEn_demo:
        return @"http://www.aahv.net:19064/refactor";
        
        break;
    case kLoginEn_release: //发布环境 登录url
    case kLoginEn_preRelease: //发布环境 登录url
        return @"http://hx.hsxt.mobi:9999/hsec-app-filter-service";
        break;
    case kLoginEn_testB://测试环境B
            return @"http://192.168.228.51:8080/app-filter";
            break;
    default:
        break;
    }
    return @"http://hx.hsxt.mobi:9999/hsec-app-filter-service";
}

#pragma mark - 互信发送地理位置调用电商商铺和餐饮商铺相关接口 add by zhangx
//默认电商的
- (NSString*)getDefaultRetailDomain
{
    switch (self.loginLine) {
        case kLoginEn_dev:
            return @"http://192.168.229.72:8080/phapi";
            break;
        case kLoginEn_testA:
            return @"https://dc.aadv.net/mobile/phapi";
            break;
        case kLoginEn_demo:
            return @"http://www.aahv.net:19065/phapi";
            break;
        case kLoginEn_release: //发布环境 电商url
        case kLoginEn_preRelease:
            return @"https://mobi.hsxt.cn:9447/phapi";
            break;
        case kLoginEn_testB://测试环境B
            return @"https://dc.aadv.net:10443/mobile/phapi";
            break;
        default:
            break;
    }
    return @"/";
}

//默认餐饮域名的
- (NSString*)getFoodConsmerDomain
{
    switch (self.loginLine) {
        case kLoginEn_dev:
            return @"http://192.168.229.80:9090/foodconsumer";
            break;
            
        case kLoginEn_testA:
            return @"https://dp.aaij.net/mobile/person";
            break;
            
        case kLoginEn_demo:
            return @"http://www.aahv.net:19062/person";
            break;
            
        case kLoginEn_release: //发布环境 电商url
        case kLoginEn_preRelease:
            return @"https://mobi.hsxt.cn:9444/person";
            break;
        case kLoginEn_testB://测试环境B
            return @"https://dp.aaij.net:8443/mobile/person";
            break;
        default:
            break;
    }
    return @"/";
}


/**
 *  检测更新
 *
 *  @return 接口
 */
- (NSString*)getDefaultUpdateDm
{
    switch (self.loginLine) {
    case kLoginEn_testA:
    case kLoginEn_test_realPay:
        return @"http://192.168.228.102:17002/upgrade/app/checkUpgrade";
        break;
        
    case kLoginEn_release:
        return @"http://hdhiz.hsxt.mobi:8884/upgrade/app/checkUpgrade";
        break;
        
    default:
        return @"http://192.168.229.39:17002/upgrade/app/checkUpgrade";
        break;
    }
    return @"/";
}

/**
 *  获取登录账号密码
 *
 *  @param iscardUser 是否互生卡用户
 *
 *  @return 账号密码
 */
- (NSArray*)getDefaultUserPwdIsCardUser:(BOOL)iscardUser
{
    if (iscardUser) //积分卡登录
    {
        switch (self.loginLine) {
        case kLoginEn_dev: //开发环境账号
        
            break;
            
        default:
            break;
        }
    }
    else //企业用户登录
    {
        switch (self.loginLine) {
        case kLoginEn_dev: //开发环境账号
        {
            /********************服务公司账号***********************/
            
            /********************托管企业账号***********************/
            
            /********************成员企业账号***********************/
            
        } break;
        case kLoginEn_testA: //测试环境账号
        {
            /********************服务公司账号***********************/
            
            /********************托管企业账号***********************/
            
            /********************成员企业账号***********************/
            
        } break;
        
        case kLoginEn_demo:
            return @[ @"", @"", @"" ];
            break;
            
        case kLoginEn_release: //发布环境 电商url
            return @[ @"", @"", @"" ];
            break;
            
        default:
            break;
        }
    }
    return @[ @"", @"", @"" ];
}

#pragma mark - 设置默认的登录环境
+ (EMLoginEn)getInitLoginLine
{
    if (![self isReleaseEn])
    {
    
    
//        return kLoginEn_dev; 
//       return kLoginEn_testA;
        return kLoginEn_testB;
//        return kLoginEn_test_realPay;
        return kLoginEn_demo;
        return kLoginEn_preRelease;
        
    }else
    {
        return kLoginEn_release;
    }
}

#pragma mark - 设置发布时参数
//是否为生产发布环境 否：NO 是：YES
+ (BOOL)isReleaseEn
{

    return NO;
}

@end
