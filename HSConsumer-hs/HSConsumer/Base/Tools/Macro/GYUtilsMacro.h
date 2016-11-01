//
//  GYUtilsMacro.h
//  HSConsumer
//
//  Created by zhangqy on 16/2/19.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#ifndef GYUtilsMacro_h
#define GYUtilsMacro_h

#pragma mark - 第三库KEY
//-------------------第三库KEY-------------------------
#define WeChatAppId @"wx2f3b74a5c55acc63"
#define WeChatAppSecret @"04c5d9f41a529e33b51eb1664e07b93b"
#define QQAppId @"1101128973"
#define QQAppKey @"0i9VDLlPAHaYh1Hv"
#define WeiboAppSecret @"4554d69fa1fbc4db121e671d8b118b5a"
#define WeiboAppKey @"1634067607"
#define WeiboRedirectUri @"http://www.hsxt.com"

// com.hsxt.hsxt.test for baidu key
#define kBaiduMapTestKey @"gBW4ysTReU0PauM5eyk97Ra8"
// com.hsxt.hsxt
#define kBaiduMapReleaseKey @"1c3ea7dca0a6526d82868c06cec91155"
// com.hsxt.hsxt.demo for baidu key
#define kBaiduMapDemoKey @"HjvergejnmE8nC8GKi5eV1Kck0yYEEU1"

#define kUMSocialDataAppKeyDebug @"577dca6ee0f55a245f00147b"
#define kUMSocialDataAppKeyRelease @"5760f52967e58e59a5001fa2"

// 消费者APPID
#define kConsumerAppId 725215709

//易联支付 env:环境参数 00: 测试环境  01: 生产环境
#define kPayEcoPpiPluginMode ((kisReleaseEn || [GYHSLoginEn sharedInstance].loginLine == kLoginEn_is_preRelease || [GYHSLoginEn sharedInstance].loginLine == kLoginEn_is_release) ? @"01" : @"00")

#pragma mark - 常用宏
//-------------------常用宏-------------------------
#define globalData [GlobalData shareInstance]
#define kErrorMsg [[GYHSLoginManager shareInstance] showErrorMsg:responseObject]

#define WS(weakSelf) __weak __typeof(self) weakSelf = self;

//id类型安全转换成字符串
#define kSaftToNSString(v) [GYUtils saftToNSString:v]

//id类型安全转换成Integer
#define kSaftToNSInteger(v) [GYUtils saftToNSInteger:v]

//id类型安全转换成float
#define kSaftToCGFloat(v) [GYUtils saftToCGFloat:v]

//id类型安全转换成double
#define kSaftToDouble(v) [GYUtils saftToDouble:v]

//判断字符是否为空
#define kBlankNSString(v) [GYUtils isBlankString:v]

// 网络请求的超时时间
#define kNetworkTimeoutTime 15.0f

//是否为生产发布环境 否：NO 是：YES
#define kisReleaseEn [GYHSLoginEn isReleaseEn]

//加载、实例化ViewController
#define kLoadVcFromClassStringName(classStringName) [GYUtils loadVcFromClassStringName:classStringName]

//加载UIImage图片
#define kLoadPng(fileName) [UIImage imageNamed:fileName]

// 字符串去除空格
#define kTrimmingString(str) [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]

#pragma mark - Function
//-------------------Function-------------------------
// 检查是否需要弹登录对话框
#define kCheckLogined                                                                     \
    if (!globalData.isLogined) {                                                          \
        if (!globalData.loginModel.resNo) {                                               \
            GYHSLoginModel* model = [[GYHSLoginManager shareInstance] loginModuleObject]; \
            globalData.loginModel.resNo = model.resNo;                                    \
        }                                                                                 \
                                                                                          \
        [[GYHSLoginManager shareInstance] showLoginView:1 otherLogin:NO];                 \
        return;                                                                           \
    };

//在根视图弹登录对话框
#define kCheckLoginedToRoot                                                               \
    if (!globalData.isLogined) {                                                          \
        if (!globalData.loginModel.resNo) {                                               \
            GYHSLoginModel* model = [[GYHSLoginManager shareInstance] loginModuleObject]; \
            globalData.loginModel.resNo = model.resNo;                                    \
        }                                                                                 \
                                                                                          \
        [[GYHSLoginManager shareInstance] showLoginView:1 otherLogin:YES];                \
        return;                                                                           \
    };

// 检查互生根视图是否进入登录主界面
#define kRootCheckLogined                                                                                      \
    if (!globalData.isLogined) {                                                                               \
        if (!globalData.loginModel.resNo) {                                                                    \
            GYHSLoginModel* model = [[GYHSLoginManager shareInstance] loginModuleObject];                      \
            globalData.loginModel.resNo = model.resNo;                                                         \
        }                                                                                                      \
        [[NSNotificationCenter defaultCenter] postNotificationName:kGYHSToLoginMainVCNotification object:nil]; \
        return;                                                                                                \
    };

// 检查消息根视图是否进入登录主界面
#define kRootMessageCheckLogined                                                                               \
    if (!globalData.isLogined) {                                                                               \
        if (!globalData.loginModel.resNo) {                                                                    \
            GYHSLoginModel* model = [[GYHSLoginManager shareInstance] loginModuleObject];                      \
            globalData.loginModel.resNo = model.resNo;                                                         \
        }                                                                                                      \
        [[NSNotificationCenter defaultCenter] postNotificationName:kGYHDToLoginMainVCNotification object:nil]; \
        return;                                                                                                \
    };

#endif