//
//  AppDelegate.m
//  GYRestaurant
//
//  Created by kuser on 15/9/28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "AppDelegate.h"

#import "GYLoginViewController.h"
#import "GYNavigationController.h"
#import "GYNewFeatureViewController.h"
#import "GYLoginViewModel.h"
#import "GYXMPP.h"
#import "JPEngine.h"
#import "iRate.h"
#import "iVersion.h"
#import "JPFPSStatus.h"
#import "DDTTYLogger.h"
#import "DDFileLogger.h"
#import "DDASLLogger.h"
#import "UMMobClick/MobClick.h"
#import "GYHDMessageCenter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - 系统方法

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
  
    [self isFirstLanched];
    [self.window makeKeyAndVisible];
    [self iRate];
    [self log];
    [self UMengSet];
    [self pushNotification];
    return YES;
}



- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{

    return [window.rootViewController supportedInterfaceOrientations];

}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}
/**
 *  进入后台时
 *
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {

//  张鑫 注释  
    //登录
//    if ( globalData.isLogined) {
//        
//        GYXMPP *xmpp = [GYXMPP sharedInstance];
//        [xmpp Logout];
//    }

}
/**
 *  进入前台
 *
 */
- (void)applicationWillEnterForeground:(UIApplication *)application {
//  张鑫 注释
    //登录
//    if ( globalData.isLogined) {
//        GYXMPP *xmpp = [GYXMPP sharedInstance];
//        [xmpp login:nil];
//    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {
  
}


#pragma mark 自定义方法

#pragma mark判断是否首次启动
- (void)isFirstLanched{
    NSString *key = @"CFBundleVersion";
    
    NSString *lastVersion = kGetNSUser(key);
    NSString *currentVersion = kAppVersion;
    
    if ([currentVersion isEqualToString:lastVersion]) {
        GYLoginViewController *vcLogin = [[GYLoginViewController alloc]init];
        GYNavigationController *ncLogin = [[GYNavigationController alloc] initWithRootViewController:vcLogin];
        self.window.rootViewController = ncLogin;
        
    }else{
        
        GYNewFeatureViewController *newFeature = [[GYNewFeatureViewController alloc]init];
        self.window.rootViewController = newFeature;
        kSetNSUser(key, currentVersion);
        
    }
    
   
}



#pragma mark - 通知相关


- (void)pushNotification
{
    
    UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeNone
                                                                                             | UIUserNotificationTypeBadge
                                                                                             | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)
                                                                                 categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];

}

//ios8需要调用内容
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
    NSLog(@"设备令牌: %@", deviceToken);
    NSString* tokeStr = [NSString stringWithFormat:@"%@", deviceToken];
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

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册推送服务时，发生以下错误： %@", error);
}

#pragma mark - JSPatch
-(void)loadJS {
    
    [JPEngine startEngine];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    
    NSURL *urlS = [NSURL URLWithString:@"http://192.168.41.185:8083/phapi/js/jquery/damo.js"];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlS];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:config];
    
    NSURLSessionDownloadTask *task =  [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSURL *fileUrl = [[NSFileManager defaultManager]URLForDirectory:NSDocumentationDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [fileUrl URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSString *jsDocument = [filePath path];
        NSString *js = [NSString stringWithContentsOfFile:jsDocument encoding:NSUTF8StringEncoding error:nil];
        if (js) {
            [JPEngine evaluateScript:jsDocument];
        }
        
        
    }];
    [task resume];
    
}
#define tipUpdateUrl @"http://116.31.92.77:9999/hsec-app-filter-service/appfliter/isTipUpdate"
- (void)iRate {
    [iRate sharedInstance].daysUntilPrompt = 6;
    [iRate sharedInstance].appStoreID = 1067254712;
    [iRate sharedInstance].useAllAvailableLanguages = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    [manager GET:tipUpdateUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject &&[responseObject[@"retCode"] isEqualToNumber:@200] && [responseObject[@"data"] isEqualToString:@"1"]) {
            
           [iVersion sharedInstance].appStoreID = 1067254712;
            [iVersion sharedInstance].updatePriority = iVersionUpdatePriorityHigh;
        }
        
    } failure:nil];
    
    
}

- (void)log {
#if DEBUG
    
//    [[JPFPSStatus sharedInstance] open];
#endif
    //全局日志设置
    [[DDTTYLogger sharedInstance] setLogFormatter:[[GYLogFormatter alloc]init]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor greenColor] backgroundColor:nil forFlag:LOG_FLAG_INFO];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor] backgroundColor:nil forFlag:LOG_FLAG_ERROR];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];

    
}


- (void)UMengSet {
#if DEBUG
    
   UMConfigInstance.appKey = @"575f6b4d67e58e6bb1003ead";
#else
     UMConfigInstance.appKey = @"5760f57567e58e58fa0023a8";
#endif
  
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setAppVersion:kAppVersion];
    
    
}

@end
