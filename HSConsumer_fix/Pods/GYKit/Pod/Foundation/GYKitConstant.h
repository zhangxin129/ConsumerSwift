//
//  GYConstant.h
//  GYCompany
//
//  Created by cook on 15/9/19.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

//-------------------国际化-------------------------
#define kLocalized(key) NSLocalizedString(key, nil)
//-------------------获取设备大小-------------------------

//获取屏幕 宽度、高度 、倍率
#define kScreenBounds [[UIScreen mainScreen] bounds]
#define kScreenWidth kScreenBounds.size.width
#define kScreenHeight kScreenBounds.size.height
#define kScreenScale [UIScreen mainScreen].scale
//-------------------获取设备大小-------------------------

//----------------------系统----------------------------
// 是否iPad

#define kIS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define kIS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define kSCREEN_MAX_LENGTH (MAX(kScreenWidth, kScreenHeight))
#define kSCREEN_MIN_LENGTH (MIN(kScreenWidth, kScreenHeight))

#define kIS_IPHONE_4_OR_LESS (kIS_IPHONE && kSCREEN_MAX_LENGTH < 568.0)
#define kIS_IPHONE_5 (kIS_IPHONE && kSCREEN_MAX_LENGTH == 568.0)
#define kIS_IPHONE_6 (kIS_IPHONE && kSCREEN_MAX_LENGTH == 667.0)
#define kIS_IPHONE_6P (kIS_IPHONE && kSCREEN_MAX_LENGTH == 736.0)

#define kIS_IPAD_MAX (kIS_IPAD && kSCREEN_MIN_LENGTH == 1536.0)
#define kIS_IPAD_MINI (kIS_IPAD && kSCREEN_MIN_LENGTH == 768.0)
#define kIS_IOS9 kSystemVersionEqualTo(@"9.0")
#define kIS_IOS9ORLATER kSystemVersionGreaterThanOrEqualTo(@"9.0")
#define kIS_IOS8ORLATER kSystemVersionGreaterThanOrEqualTo(@"8.0")

//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

//判断设备的操做系统是不是ios7
#define kIOS7 ([[[UIDevice currentDevice].systemVersion doubleValue] >= 7.0]

#define kSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
//判断系统时哪个版本之后
#define kIOS7OrLater (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? YES : NO)

//当前APP 默认Bundle
#define kDefaultBundle [NSBundle mainBundle]

//iOS版本比较 用法：kSystemVersionEqualTo(@"6.0") 返回BOOL
#define kSystemVersionEqualTo(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame) //等于
#define kSystemVersionGreaterThan(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending) //大于
#define kSystemVersionGreaterThanOrEqualTo(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending) //大于等于
#define kSystemVersionLessThan(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending) //小于
#define kSystemVersionLessThanOrEqualTo(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending) //小于等于

//名称
#define kAppName [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey]
//版本
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//编译版本
#define kAppBuildVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//存取数据
#define kSetNSUser(k, v)                                          \
[[NSUserDefaults standardUserDefaults] setObject:v forKey:k]; \
[[NSUserDefaults standardUserDefaults] synchronize];
#define kGetNSUser(k) [[NSUserDefaults standardUserDefaults] objectForKey:k]
#define kRemoveNSUser(k)                                          \
[[NSUserDefaults standardUserDefaults] removeObjectForKey:k]; \
[[NSUserDefaults standardUserDefaults] synchronize];

//通知中心
#define kDefaultNotificationCenter [NSNotificationCenter defaultCenter]

#define TRIMSTRING(str) [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]

//----------------------系统----------------------------

//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

//带有RGBA的颜色设置
#define kColor(R, G, B, A) [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:A]

// 获取RGB颜色
#define kRGBA(r, g, b, a) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]
#define kRGB(r, g, b) RGBA(r, g, b, 1.0f)

//清除背景色
#define kClearColor [UIColor clearColor]
//----------------------颜色类--------------------------

//----------------------系统目录--------------------------

//系统目录 宏
#define kAppDocumentDirectoryPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define kAppLibraryDirectoryPath NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0]
#define kAppCachesDirectoryPath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]

//----------------------系统目录--------------------------

//----------------------单例----------------------------
// .h文件
#define SingletonH(name) +(instancetype)shared##name;

// .m文件
#if __has_feature(objc_arc)

#define SingletonM(name)                                                        \
    static id _instace;                                                         \
                                                                                \
    +(id)allocWithZone : (struct _NSZone*)zone                                  \
    {                                                                           \
        static dispatch_once_t onceToken;                                       \
        dispatch_once(&onceToken, ^{ _instace = [super allocWithZone:zone]; }); \
        return _instace;                                                        \
    }                                                                           \
                                                                                \
    +(instancetype)shared##name                                                 \
    {                                                                           \
        static dispatch_once_t onceToken;                                       \
        dispatch_once(&onceToken, ^{ _instace = [[self alloc] init]; });        \
        return _instace;                                                        \
    }                                                                           \
                                                                                \
    -(id)copyWithZone : (NSZone*)zone                                           \
    {                                                                           \
        return _instace;                                                        \
    }

#else

#define SingletonM(name)                                                        \
    static id _instace;                                                         \
                                                                                \
    +(id)allocWithZone : (struct _NSZone*)zone                                  \
    {                                                                           \
        static dispatch_once_t onceToken;                                       \
        dispatch_once(&onceToken, ^{ _instace = [super allocWithZone:zone]; }); \
        return _instace;                                                        \
    }                                                                           \
                                                                                \
    +(instancetype)shared##name                                                 \
    {                                                                           \
        static dispatch_once_t onceToken;                                       \
        dispatch_once(&onceToken, ^{ _instace = [[self alloc] init]; });        \
        return _instace;                                                        \
    }                                                                           \
                                                                                \
    -(id)copyWithZone : (NSZone*)zone                                           \
    {                                                                           \
        return _instace;                                                        \
    }                                                                           \
                                                                                \
    -(oneway void)release{} - (id)retain { return self; }                       \
    -(NSUInteger)retainCount { return 1; }                                      \
    -(id)autorelease { return self; }

#endif
//----------------------单例----------------------------

//----------------------系统常量 ----------------------------

#define kHTTPSuccessResponse(responsObject) [responsObject[@"retCode"] isEqualToNumber:@200]

//判断block是否为空，如果不为空则执行
#define KExcuteBlock(name, ...) \
if (name) {                 \
name(__VA_ARGS__);      \
};

//加载UIImage图片
#define kLoadPng(fileName) [UIImage imageNamed:fileName]

// 定义GYKit库使用的打印日志
#if DEBUG
    #define GYKitDebugLog(...) NSLog(__VA_ARGS__)
#else
    #define GYKitDebugLog(...)
#endif
