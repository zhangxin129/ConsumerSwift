//
//  AppDelegate.m
//  HSCompanyPad
//
//  Created by sqm on 16/7/21.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "AppDelegate.h"
#import <CocoaLumberjack/DDTTYLogger.h>
#import <CocoaLumberjack/DDFileLogger.h>
#import <CocoaLumberjack/DDASLLogger.h>
#import <GYKit/GYLogFormatter.h>
#import <UMMobClick/MobClick.h>
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import "GYGuidePageViewController.h"
#import "GYJSPatch.h"
#import "GYLoginHttpTool.h"

#if DEBUG && kCheckMemory
#import <FBMemoryProfiler/FBMemoryProfiler.h>
#import <FBRetainCycleDetector/FBRetainCycleDetector.h>
#import "GYFBMemoryProfilerPlugin.h"
#endif
@interface AppDelegate ()
@property(nonatomic,strong)BMKMapManager * mapManager;
#if DEBUG && kCheckMemory
@property (nonatomic, strong) FBMemoryProfiler* memoryProfiler;
#endif
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    [GYLoginHttpTool pingUserIP];
    [self loadJS];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self firstLaunch];
    [self UMengSet];
    [self baiduMap];
    [self FBMemoryProfilerSet];
    [self log];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self log];
    
    // 获取当前设备是iPad还是iPhone
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        [GYHDMessageCenter sharedInstance].deviceType = IMDeviceTypeIOSMobile; //iOS手机
        
    } else {
        [GYHDMessageCenter sharedInstance].deviceType = IMDeviceTypeIOSPad; //iOS平板
    }
    // 重新更新消息状态
    [[GYHDMessageCenter sharedInstance] updateSendingState];
    
    [self.window makeKeyAndVisible];
    //    注册推送通知
    
    [self pushNotification];
    
    //判断是否由远程消息通知触发应用程序启动
    if (launchOptions) {
        
        //获取应用程序消息通知标记数（即小红圈中的数字）
        NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        if (badge>0) {
            //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
//            badge--;
            //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
            
//            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
            
            NSDictionary *pushInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
            
            //获取推送详情
            NSString *pushString = [NSString stringWithFormat:@"%@",[pushInfo  objectForKey:@"aps"]];
            
            DDLogInfo(@"%@",pushString);
            
        }
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication*)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication*)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication*)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication*)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    //    eadb471e 8ddf1232 bae070e0 e2286725 c9f20dc5 6c7a5831 90915da3 e888bebe
    DDLogInfo(@"设备令牌: %@", deviceToken);
    NSString* tokeStr = [NSString stringWithFormat:@"%@", deviceToken];
    //过滤字符串前后的空格
    tokeStr= [tokeStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //过滤中间空格
    tokeStr = [tokeStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    tokeStr = [tokeStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    tokeStr = [tokeStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    [GYHDMessageCenter sharedInstance].deviceVersion=[NSString stringWithFormat:@"%f",kSystemVersion];
    
    [GYHDMessageCenter sharedInstance].deviceToken = tokeStr;
    
    if ([tokeStr length] == 0) {
        return;
    }
}


-(void)application:(UIApplication*)app didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo{
    
    
//    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    //  apns 接收推送消息
    
    DDLogInfo(@"%@",userInfo);
    
    /* eg.
     key: aps, value: {
     alert = "\U8fd9\U662f\U4e00\U6761\U6d4b\U8bd5\U4fe1\U606f";
     badge = 1;
     sound = default;
     }
     */
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    DDLogInfo(@"注册通知错误Failed to get token, error:%@", error_str);
}


- (void)pushNotification
{
    //注册推送
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeNone | UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)
                                                                             categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
}

#pragma mark - JSPatch
-(void)loadJS {
    NSString *version = @"";
    if (kisReleaseEn) {
        version = kAppVersion;
    }else {
        NSArray<NSString *> *arr = [kAppVersion componentsSeparatedByString:@"."];
        if (arr.count >=3) {
            version = [NSString stringWithFormat:@"%@.%@.%@",arr.firstObject ,arr[1],arr[2]];
        }
    }
    
    [GYJSPatch getNewVersionWithURL:GY_APPFILTERAPPENDING(GYJSUpdateUrl) parameters:@{@"appKey":@"EFFCB3186AC64697A37F56F5928080BB",@"versionCode":version}];
}

#pragma mark - method
- (void)log
{

    //全局日志设置
    [[DDTTYLogger sharedInstance] setLogFormatter:[[GYLogFormatter alloc] init]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor greenColor] backgroundColor:nil forFlag:LOG_FLAG_INFO];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor] backgroundColor:nil forFlag:LOG_FLAG_ERROR];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
}
- (void)UMengSet
{

        if (kisReleaseEn) {
            UMConfigInstance.appKey = GYUMengReleaseKey;
        }else {
    
    UMConfigInstance.appKey = GYUMengDebugKey;
        }

    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setAppVersion:kAppVersion];
}

- (void)baiduMap
{

//    BMKMapManager* mapManager = [[BMKMapManager alloc] init];
//    
//    BOOL ret = [mapManager start:GYBaiduMapReleaseKey generalDelegate:self];
//    if (!ret) {
//        DDLogInfo(@"BaiduManager start failed!");
//    }
//    else {
//    
//        DDLogInfo(@"BaiduManager start success!");
//    }
    
    // 要使用百度地图，请先启动BaiduMapManager
    
   self.mapManager = [[BMKMapManager alloc]init];
    
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    
    BOOL ret = [self.mapManager start:GYBaiduMapReleaseKey generalDelegate:nil];
    
    if (ret) {
        
        NSLog(@"百度授权成功!");
        
    }else{
        
        NSLog(@"百度授权失败!");
    }
}

- (void)FBMemoryProfilerSet
{

#if DEBUG && kCheckMemory
    NSArray* filters = @[ FBFilterBlockWithObjectIvarRelation([UIView class], @"_subviewCache"),
        FBFilterBlockWithObjectIvarRelation([UIPanGestureRecognizer class], @"_internalActiveTouches") ];
    FBObjectGraphConfiguration* configuration =
        [[FBObjectGraphConfiguration alloc] initWithFilterBlocks:filters
                                             shouldInspectTimers:NO];
                                             
    self.memoryProfiler = [[FBMemoryProfiler alloc] initWithPlugins:@[ [GYFBMemoryProfilerPlugin new] ]
                                   retainCycleDetectorConfiguration:configuration];
    self.memoryProfiler.presentationMode = FBMemoryProfilerPresentationModeDisabled;
    [[JPFPSStatus sharedInstance] open];
    [self.memoryProfiler enable];
#endif
}

//通过版本控制第一次加载的界面
- (void)firstLaunch
{

    NSString* key = @"CFBundleVersion";
    NSString* lastVersion = kGetNSUser(key);
    NSString* currentVersion = kAppVersion;
    
    if ([currentVersion isEqualToString:lastVersion]) {
        UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = [storyBoard instantiateInitialViewController];
    }
    else {
    
        GYGuidePageViewController* guideVC = [GYGuidePageViewController new];
        self.window.rootViewController = guideVC;
        kSetNSUser(key, currentVersion);
    }
}

- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
    if (globalData.isLogined && !globalData.isLocked) {
        [globalData.timer invalidate];
        globalData.timer = nil;
        [globalData.timer isValid];
    }
}


@end
