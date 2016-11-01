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
#import "UIView+Extension.h"
#import "Masonry.h"
#import "UIBarButtonItem+Target.h"
#import "Utils.h"
#import "UIImageView+YYWebImage.h"
#import "GYAlertView.h"
#import "UIButton+GYExtension.h"
#import "GYNetApiConfig.h"
#import "GYNotificationmacro.h"
#import "MJExtension.h"
#import "UIView+Toast.h"
#import "UIColor+YYAdd.h"
#import "AFNetworking.h"
#import "GYLogFormatter.h"
#import "YYKitMacro.h"
#import "GYUtilsConst.h"
#import "DDLog.h"
#import "FMDatabase.h"
#import "GYGIFHUD.h"
#import "GYLogFormatter.h"
#import "GYRefreshFooter.h"
#import "GYRefreshHeader.h"
#import "GYUtilsConst.h"
#import "Masonry.h"
#import "NSString+Size.h"
#import "NSString+YYAdd.h"
#import "Network.h"
#import "UIColor+YYAdd.h"
#import "Utils.h"
#import "YYKitMacro.h"

//-------------------国际化-------------------------
#define kLocalized(key)  NSLocalizedString(key, nil)
#define kLocalizedAddParams(key1, key2) [key1 stringByAppendingString:key2]

//-------------------获取设备大小-------------------------
//NavBar高度
#define kNavigationBar_HEIGHT 44
//获取屏幕 宽度、高度 、倍率
#define kScreenBounds  [[UIScreen mainScreen] bounds]
#define kScreenWidth  kScreenBounds.size.width
#define kScreenHeight kScreenBounds.size.height
#define kScreenScale  [UIScreen mainScreen].scale
//-------------------获取设备大小-------------------------

//设备IP
#define kIp [UIDevice currentDevice].ipAddressCell ? [UIDevice currentDevice].ipAddressCell : [UIDevice currentDevice].ipAddressWIFI
#define kDeviceIp kIp ?kIp : @""

//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif



//---------------------打印日志--------------------------

//----------------------系统----------------------------
// 是否iPad
#define someThing (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? ipad: iphone

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
#define kIS_IOS9ORLATER kSystemVersionGreaterThanOrEqualTo(@"9.0")
#define kIS_IOS8ORLATER kSystemVersionGreaterThanOrEqualTo(@"8.0")


//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

//获取当前语言
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//判断是否 Retina屏
#define kIS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)


//判断设备的操做系统是不是ios7
#define kIOS7 ([[[UIDevice currentDevice].systemVersion doubleValue] >= 7.0]

#define kSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
//判断系统时哪个版本之后
#define kIOS7OrLater (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? YES : NO)


//当前APP 默认Bundle
#define kDefaultBundle [NSBundle mainBundle]

//文件管理器声明
#define kFileManager [NSFileManager defaultManager]


//定义一个define函数
#define TT_RELEASE_CF_SAFELY(__REF) { if (nil != (__REF)) { CFRelease(__REF); __REF = nil; } }

//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif


//iOS版本比较 用法：kSystemVersionEqualTo(@"6.0") 返回BOOL
#define kSystemVersionEqualTo(v)        ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame) //等于
#define kSystemVersionGreaterThan(v)    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending) //大于
#define kSystemVersionGreaterThanOrEqualTo(v)   ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending) //大于等于
#define kSystemVersionLessThan(v)               ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending) //小于
#define kSystemVersionLessThanOrEqualTo(v)      ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending) //小于等于


//名称
#define kAppName        [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey]
//版本
#define kAppVersion     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//编译版本
#define kAppBuildVersion     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//存取数据
#define kSetNSUser(k,v) \
[[NSUserDefaults standardUserDefaults]setObject:v forKey:k];\
[[NSUserDefaults standardUserDefaults]synchronize];
#define kGetNSUser(k) [[NSUserDefaults standardUserDefaults]objectForKey:k]
#define kRemoveNSUser(k)                                          \
[[NSUserDefaults standardUserDefaults] removeObjectForKey:k]; \
[[NSUserDefaults standardUserDefaults] synchronize];

//系统delegate
#define kAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

//通知中心
#define kDefaultNotificationCenter [NSNotificationCenter defaultCenter]

//----------------------系统----------------------------


//----------------------内存----------------------------

//使用ARC和不使用ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
// compiling without ARC
#endif

#pragma mark - common functions
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

//释放一个对象
#define SAFE_DELETE(P) if(P) { [P release], P = nil; }

#define SAFE_RELEASE(x) [x release];x=nil


//----------------------内存----------------------------


//----------------------图片----------------------------

//读取本地图片
#define kLOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//加载UIImage图片
//#define kLoadPng(fileName) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:fileName ofType:@"png"]]//加载png图片
//#define kLoadJpg(fileName) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:fileName ofType:@"jpg"]]//加载jpg图片
//#define kLoadImage(fileName,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:fileName ofType:ext]]//加载指定扩展名图片
//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]


#define kImage(imageName) [UIImage imageNamed:imageName]
//----------------------图片----------------------------
//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//带有RGBA的颜色设置
#define kColor(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

// 获取RGB颜色
#define kRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define kRGB(r,g,b) RGBA(r,g,b,1.0f)

//清除背景色
#define kClearColor [UIColor clearColor]
//----------------------颜色类--------------------------
//----------------------系统目录--------------------------

//系统目录 宏
#define kAppDocumentDirectoryPath  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define kAppLibraryDirectoryPath   NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0]
#define kAppCachesDirectoryPath    NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]

//----------------------系统目录--------------------------

//----------------------其他----------------------------

//方正黑体简体字体定义
#define FONT(F) [UIFont fontWithName:@"FZHTJW--GB1-0" size:F]

#define kUSER_DEFAULT [NSUserDefaults standardUserDefaults]

#define kWEAKSELF __weak __typeof(self) weakSelf = self;

#define kFontWithSize(size) [UIFont systemFontOfSize:size];


//设置View的tag属性
#define VIEWWITHTAG(_OBJECT, _TAG)    [_OBJECT viewWithTag : _TAG]
//程序的本地化,引用国际化的文件
#define MyLocal(x, ...) NSLocalizedString(x, nil)

//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)


//由角度获取弧度 有弧度获取角度
#define kDegreesToRadian(x) (M_PI * (x) / 180.0)
#define kRadianToDegrees(radian) (radian*180.0)/(M_PI)

//----------------------其他----------------------------

//----------------------单例----------------------------
// .h文件
#define SingletonH(name) + (instancetype)shared##name;

// .m文件
#if __has_feature(objc_arc)

#define SingletonM(name) \
static id _instace; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [super allocWithZone:zone]; \
}); \
return _instace; \
} \
\
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [[self alloc] init]; \
}); \
return _instace; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instace; \
}

#else

#define SingletonM(name) \
static id _instace; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [super allocWithZone:zone]; \
}); \
return _instace; \
} \
\
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [[self alloc] init]; \
}); \
return _instace; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instace; \
} \
\
- (oneway void)release { } \
- (id)retain { return self; } \
- (NSUInteger)retainCount { return 1;} \
- (id)autorelease { return self;}

#endif
//----------------------单例----------------------------

//----------------------系统常量 ----------------------------

//id类型安全转换成字符串
#define kSaftToNSString(v)  [Utils saftToNSString:v]

//id类型安全转换成Integer
#define kSaftToNSInteger(v) [Utils saftToNSInteger:v]

//id类型安全转换成float or double
#define kSaftToCGFloat(v) [Utils saftToCGFloat:v]

//判断字符是否为空
#define kBlankNSString(v) [Utils isBlankString:v]


#define kHTTPSuccessResponse(responsObject) [responsObject[@"retCode"] isEqualToNumber:@200]


#define globalData [GYGlobalData sharedInstant]

#define GY_FOODLOGINAPPENDING(url) [[[GYLoginEn sharedInstance] getLoginUrl] stringByAppendingString:url]
#define GY_FOODOMAINAPP(url) [globalData.loginModel.hsecFoodPadUrl stringByAppendingString:url]
#define picHttpUrl globalData.loginModel.hsecTfsUrl
#define kNotice(text) [[UIApplication sharedApplication].delegate.window  makeToast:text duration:1.f position:CSToastPositionBottom ];

#define kHTTPSuccessResponse(responsObject) [responsObject[@"retCode"] isEqualToNumber:@200]
#define GY_HSDOMAINAPPENDING(url) [[[LoginEn sharedInstance] getLoginUrl] stringByAppendingString:url]
#define GY_RETAILDOMAINAPPENDING(url) [globalData.loginModel.phapiUrl stringByAppendingString:url]
#define GY_FOODOMAINAPPENDING(url) [globalData.loginModel.foodUrl stringByAppendingString:url]
typedef void (^HTTPSuccess)(id responsObject);
typedef void (^HTTPFailure)();
//判断block是否为空，如果不为空则执行
#define KExcuteBlock(name, ...) \
if (name) {                 \
name(__VA_ARGS__);      \
};

#define kErrorRetcodeMsg  ([responsObject[@"retCode"] isEqualToNumber:@160467]||[responsObject[@"retCode"] isEqualToNumber:@160411])?responsObject[@"msg"] :((globalData.dicErrConfig[kSaftToNSString(responsObject[@"retCode"])]) ? (globalData.dicErrConfig[kSaftToNSString(responsObject[@"retCode"])]) : kLocalized(@"HE_NetworkError"))

#define kErrorMsg [globalData showErrorMsg:responseObject]

#define kisReleaseEn [LoginEn isReleaseEn] //是否为生产发布环境 否：NO 是：YES

//10进制GRB转UIColor
#define kCorlorFromRGBA(r, g, b, a) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]

//16进制GRB转UIColor
#define kCorlorFromHexcode(hexcode) [UIColor colorWithRed:((float)((hexcode & 0xFF0000) >> 16)) / 255.0 green:((float)((hexcode & 0xFF00) >> 8)) / 255.0 blue:((float)(hexcode & 0xFF)) / 255.0 alpha:1.0]


//加载viewcontroller，通过类名实例化viewcontroller,只适合带有同名的xib文件或没有xib文件的实例化。
#define kLoadVcFromClassStringName(classStringName) [Utils loadVcFromClassStringName:classStringName]

//加载UIImage图片
#define kLoadPng(fileName) [UIImage imageNamed:fileName]


//-------------------消费者宏定义

#define TRIMSTRING(str) [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
#define App ((GYAppDelegate*)[UIApplication sharedApplication].delegate)
#define kWindow (((GYAppDelegate*)[UIApplication sharedApplication].delegate).window)



#define WS(weakSelf) __weak __typeof(self) weakSelf = self;

#define kCheckLogined                                                                                                                            \
if (!globalData.isLogined) {                                                                                                                 \
GYLoginViewController* loginVcOne = [[GYLoginViewController alloc] init];                                                                \
loginVcOne.dismissBarIndex = 1;                                                                                                          \
GYNavigationController* loginVc = [[GYNavigationController alloc] initWithRootViewController:loginVcOne];                                \
[self presentViewController:loginVc animated:YES completion:nil];                                                                        \
return;                                                                                                                                  \
};                                                                                                                                           \
if (!globalData.loginModel.resNo) {                                                                                                          \
NSMutableArray* userArrM = kGetNSUser(KEY_SAVEUSER) ? [NSMutableArray arrayWithArray:kGetNSUser(KEY_SAVEUSER)] : [NSMutableArray array]; \
NSDictionary* dict = userArrM.lastObject;                                                                                                \
globalData.loginModel.resNo = dict[KEY_USERID];                                                                                          \
};


