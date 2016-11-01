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

#pragma mark 单例
SingletonM(Instance)


- (instancetype)init
{
    if (self = [super init])
    {
        self.loginLine = [[self class] getInitLoginLine];
    }
    return self;
}

-(void)setLoginLine:(EMLoginEn)loginLine{
    if (_loginLine != loginLine) {
        _loginLine = loginLine;
    }
}



/**
 *  获取接口
 *
 *  @return 接口
 */
- (NSString *)getLoginUrl
{
    switch (self.loginLine)
    {
        case kLoginEn_dev:
            return @"http://192.168.229.182:8080/reconsitution";
            break;
        case kLoginEn_test:
            return  @"https://dc.aadv.net/mobile/reconsitution";
            
            break;
        case kLoginEn_demo:
            return @"http://www.aahv.net:19061/pad";
            break;
            
        case kLoginEn_pre_release:
        case kLoginEn_is_release://发布环境 登录url
            return @"https://mobi.hsxt.cn:9446/refactor";
            break;
        default:
            break;
    }
    return @"http://192.168.229.80:9999";
}




- (NSArray *)getDefaultUserPwdIsCardUser:(BOOL)iscardUser
{
    if (iscardUser)//积分卡登录
    {
        
    }else//企业用户登录
    {
        switch (self.loginLine)
        {
            case kLoginEn_dev://开发环境账号
            {
   //         return @[@"06032110000", @"3002", @"789456"];//系统管理员
//            return @[@"06002110000", @"0101", @"123123"];//系统操作员b
//            return @[@"06032110000", @"1234", @"123123"];
//            return @[@"06032120000", @"8301", @"963852"];
            }
                break;
            case kLoginEn_test://测试环境账号
            {

//                return @[@"06007110000", @"2222", @"135246"];
               // return @[@"06010010000", @"0000", @"666666"];
                
            }
                break;
            case kLoginEn_demo:
            case kLoginEn_pre_release:
            case kLoginEn_is_release://发布环境 电商url
                return @[@"", @"", @""];
                break;
                
            default:
                break;
        }
        
    }
    return @[@"", @"", @""];
}

#pragma mark - 设置默认的登录环境
+ (EMLoginEn)getInitLoginLine
{
    if (![self isReleaseEn])
    {
//        return kLoginEn_pre_release;
       return kLoginEn_test;
        return kLoginEn_dev;
//        return kLoginEn_demo;
        
    }else
    {
        return kLoginEn_is_release;
    }
}

#pragma mark - 设置发布时参数

//是否为生产发布环境 否：NO 是：YES
+ (BOOL)isReleaseEn
{

    return NO;
}



@end
