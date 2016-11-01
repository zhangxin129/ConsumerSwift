//
//  GYAppDelegate.m
//  HSConsumer
//
//  Created by apple on 14-10-10.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAppDelegate.h"
#import "GYLogFormatter.h"
#import <AVFoundation/AVAudioSession.h>
#import <AVFoundation/AVFoundation.h>
#import "XMPP.h"
//#import "GYXMPP.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"
#import "JPEngine.h"
#import "UMMobClick/MobClick.h"
#import "UMSocialData.h"
#import "UMSocialSnsService.h"
#import "GYTabBarController.h"
#import "GYNewFeatureViewController.h"
#import "GYHDUserSetingViewController.h"
#import "GYSlideMenuController.h"
#import "GYHDMessageCenter.h"
#import "GYLocationManager.h"
#import "GYHSLoginManager.h"
#import "GYJSPatch.h"
#import "GYHEAreaLocationModel.h"

@interface GYAppDelegate () <UIApplicationDelegate>
@end

@implementation GYAppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    [self loadJS];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    [self initLog];

    //启动百度地图服务
    [[GYLocationManager sharedInstance] startMapService];

    //设置状态栏字体为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

    [self isFirstLanched];

    if (kIS_IOS9ORLATER) {
        [self shortcutMessage];
    }

    [self.window makeKeyAndVisible];

    [GYUtils collectUserInfoAppPlayTimesWithStatus:[[NSString alloc] initWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding]];
    [self pushNotification];

    //设置友盟统计
    [self umengSet];
    
    [self areaAndLocation];
    
    [self getServerTimeString];

    [[GYHSLoginManager shareInstance] getLocationInfo];
    [[GYHSLoginManager shareInstance] updateNetState];
    [[GYHSLoginManager shareInstance] checkVersionUpdate];
    [[GYHSLoginManager shareInstance] pingUserIP];

    // 清除app角标
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    // 获取当前设备是iPad还是iPhone
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        [GYHDMessageCenter sharedInstance].deviceType = IMDeviceTypeIOSMobile; //iOS手机
        
    } else {
        [GYHDMessageCenter sharedInstance].deviceType = IMDeviceTypeIOSPad; //iOS平板
    }
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication*)application
{
    // 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
    [UMSocialSnsService applicationDidBecomeActive];
    [GYUtils collectUserInfoAppPlayTimesWithStatus:[[NSString alloc] initWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding]];
}

/**
 * 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation
{
    return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (void)applicationWillTerminate:(UIApplication*)application
{
    [GYUtils collectUserInfoAppPlayTimesWithStatus:[[NSString alloc] initWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding]];
}

- (void)applicationDidEnterBackground:(UIApplication*)application
{
    [GYUtils collectUserInfoAppPlayTimesWithStatus:[[NSString alloc] initWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding]];
    
    //1 把自定义对象写入NSUserDefaults---------------------------------
    //  创建 NSUserDefaults
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    // 写入 NSUserDefaults
    [userDefault setObject:[GYHDMessageCenter sharedInstance].deviceVersion forKey:@"deviceVersion"];
    [userDefault setObject:[GYHDMessageCenter sharedInstance].deviceToken forKey:@"deviceToken"];
    [userDefault setObject:@([GYHDMessageCenter sharedInstance].deviceType) forKey:@"deviceType"];
    [userDefault setObject:@([GYHDMessageCenter sharedInstance].state) forKey:@"state"];
    
    [userDefault synchronize];
    //-----------------------
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{

    // 解决从系统定位返回时，再次启动定位
    if ([GYUtils checkStringInvalid:globalData.selectedCityName]) {
        [[GYHSLoginManager shareInstance] getLocationInfo];
    }
    
    [self getServerTimeString];
    
    // GYHDMessageCenter的属性重新赋值
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    //  先获取到 NSData，
    [GYHDMessageCenter sharedInstance].deviceVersion =  [userDefaults objectForKey:@"deviceVersion"];
    [GYHDMessageCenter sharedInstance].deviceToken =  [userDefaults objectForKey:@"deviceToken"];
    
    NSNumber *deviceType = [userDefaults objectForKey:@"deviceType"];
    [GYHDMessageCenter sharedInstance].deviceType =  deviceType.intValue;
    
    NSNumber *state = [userDefaults objectForKey:@"state"];
    [GYHDMessageCenter sharedInstance].deviceType =  state.unsignedIntegerValue;
    
}

- (void)application:(UIApplication*)application performActionForShortcutItem:(UIApplicationShortcutItem*)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    //    globalData.viewController = [[GYSlideMenuController alloc] init];
    GYHDUserSetingViewController* leftView = [[GYHDUserSetingViewController alloc] init];
    GYTabBarController* tabBarVc = [[GYTabBarController alloc] init];
    globalData.viewController.mainViewController = tabBarVc;
    if ([shortcutItem.type isEqualToString:@"1"]) {
        tabBarVc.selectedIndex = 0;
    }
    else if ([shortcutItem.type isEqualToString:@"2"]) {

        tabBarVc.selectedIndex = 1;
    }
    else if ([shortcutItem.type isEqualToString:@"3"]) {

        tabBarVc.selectedIndex = 2;
    }
    // globalData.viewController.leftViewController = leftView;

    globalData.viewController = [[GYSlideMenuController alloc] initWithMainViewController:tabBarVc leftViewController:leftView rightViewController:nil animationBlock:^(UIView* mainView, CGRect orginFrame, CGFloat xOffset){

    }];
    self.window.rootViewController = globalData.viewController;
}

// IOS8 需要调用内容
- (void)application:(UIApplication*)application didRegisterUserNotificationSettings:(UIUserNotificationSettings*)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication*)application handleActionWithIdentifier:(NSString*)identifier forRemoteNotification:(NSDictionary*)userInfo completionHandler:(void (^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]) {
    }
    else if ([identifier isEqualToString:@"answerAction"]) {
    }
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    DDLogInfo(@"设备令牌: %@", deviceToken);
    NSString* tokeStr = [NSString stringWithFormat:@"%@", deviceToken];
    //过滤字符串前后的空格
    tokeStr= [tokeStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //过滤中间空格
    tokeStr = [tokeStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    tokeStr = [tokeStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    tokeStr = [tokeStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    [GYHDMessageCenter sharedInstance].deviceVersion = [NSString stringWithFormat:@"%f",kSystemVersion];
    
    [GYHDMessageCenter sharedInstance].deviceToken = tokeStr;
    
    
    
    if ([tokeStr length] == 0) {
        return;
    }
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    NSLog(@"%@", [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    //以警告框的方式来显示推送消息
    if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"] != NULL) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"经过推送发送过来的消息"
                                                        message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                                       delegate:self
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:@"处理", nil];
        [alert show];
    }
}




- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"注册推送服务时，发生以下错误： %@", error);
}

#pragma mark - private methods
- (void)isFirstLanched
{
    NSString* key = @"CFBundleVersion";
    NSString* lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSString* currentVersion = kAppVersion;

    if ([currentVersion isEqualToString:lastVersion]) {
        globalData.viewController = [[GYSlideMenuController alloc] init];
        GYHDUserSetingViewController* leftView = [[GYHDUserSetingViewController alloc] init];
        globalData.viewController.mainViewController = [[GYTabBarController alloc] init];
        globalData.viewController.leftViewController = leftView;
        self.window.rootViewController = globalData.viewController;
        [[GYHSLoginManager shareInstance] autoLogin]; //自动登录
    }
    else {
        GYNewFeatureViewController* newFeature = [[GYNewFeatureViewController alloc] init];
        self.window.rootViewController = newFeature;

        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)shortcutMessage
{

    UIApplicationShortcutIcon* icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"gycommon_tab_message_normal"];
    UIApplicationShortcutItem* item1 = [[UIApplicationShortcutItem alloc] initWithType:@"1" localizedTitle:kLocalized(@"GYHS_Base_tab_title_message") localizedSubtitle:nil icon:icon1 userInfo:nil];
    UIApplicationShortcutIcon* icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"gycommon_tab_around_normal"];
    UIApplicationShortcutItem* item2 = [[UIApplicationShortcutItem alloc] initWithType:@"2" localizedTitle:kLocalized(@"GYHS_Base_tab_title_around") localizedSubtitle:nil icon:icon2 userInfo:nil];
    UIApplicationShortcutIcon* icon3 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"gycommon_tab_easybuy_normal"];
    UIApplicationShortcutItem* item3 = [[UIApplicationShortcutItem alloc] initWithType:@"3" localizedTitle:kLocalized(@"GYHS_Base_tab_title_easybuy") localizedSubtitle:nil icon:icon3 userInfo:nil];

    [[UIApplication sharedApplication] setShortcutItems:@[ item1, item2, item3 ]];
}

- (void)pushNotification
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        //ios8注册推送
        UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeNone | UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)
                                                                                 categories:nil];

        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}

- (void)loadJS
{
    //强制升级后删除本地js
    NSString* key = @"CFBundleVersion";
    NSString* lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSString* currentVersion = kAppVersion;
    
    if (![currentVersion isEqualToString:lastVersion]) {
        
        [GYJSPatch deleteLocaJSpatch];
    }
    
    NSArray* arr = [kAppVersion componentsSeparatedByString:@"."];

    NSArray* subArr = [arr subarrayWithRange:NSMakeRange(0, 3)];
    NSString* version = [subArr componentsJoinedByString:@"."];
    [GYJSPatch getNewVersionWithURL:kCheckJSPatchUpdateURL parameters:@{ @"appKey" : @"73F165558AD148638C06D0F77FCD76BD",
        @"versionCode" : version } withFileUrl:kFilterServerBaseURL];
}

- (void)initLog
{
    //全局日志设置
    [[DDTTYLogger sharedInstance] setLogFormatter:[[GYLogFormatter alloc] init]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDASLLogger sharedInstance]];

    // 安装插件后，日志会有颜色显示：https://github.com/robbiehanson/XcodeColors
    /*
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor] backgroundColor:nil forFlag:LOG_FLAG_ERROR];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor orangeColor] backgroundColor:nil forFlag:LOG_FLAG_WARN];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor greenColor] backgroundColor:nil forFlag:LOG_FLAG_INFO];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor whiteColor] backgroundColor:nil forFlag:LOG_FLAG_VERBOSE];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
     */
}

- (void)umengSet
{
    if (kisReleaseEn) {
        UMConfigInstance.appKey = kUMSocialDataAppKeyRelease;
        [UMSocialData setAppKey:kUMSocialDataAppKeyRelease];
    }
    else {
        UMConfigInstance.appKey = kUMSocialDataAppKeyDebug;
        [UMSocialData setAppKey:kUMSocialDataAppKeyDebug];
    }
    
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setAppVersion:kAppVersion];
}

-(void)areaAndLocation
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"arealocationlist" ofType:@"txt"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *version = kSaftToNSString(dict[@"msg"]);
    if ([GYUtils isBlankString:version]) {
        version = @"20161008";
    }
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kgetMobileAreaFileUrl parameters:@{@"version" :version } requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return;
        }
        NSMutableArray *array = responseObject[@"data"];
        GYHEAreaLocationModel *model = [[GYHEAreaLocationModel alloc] init];
        model.msg = responseObject[@"msg"];
        if (!array) {
            NSData* provinceData = [NSKeyedArchiver archivedDataWithRootObject:array];
            [[NSUserDefaults standardUserDefaults] setObject:provinceData forKey:@"arealocationlist"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}
-(void)getServerTimeString
{
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kGetTimeURL parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        double t = [[NSString stringWithFormat:@"%@",responseObject[@"t"]] doubleValue];
        UInt64 f = [[NSDate date] timeIntervalSince1970] * 1000;
        long time = t - f;
        globalData.loginModel.timeDifference = time;
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}
@end
