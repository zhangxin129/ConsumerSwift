//
//  GYHSLogonManager.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/22.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSLoginManager.h"
#import "GYHSLoginModel.h"
#import "GYHSLoginViewController.h"
#import "GYHSRequestData.h"
#import "GYHSAlternateModel.h"
#import "GYHSLoginHistoryModel.h"
#import "GYHSCustGlobalDataModel.h"
#import "GYNavigationController.h"
#import "GYAddressData.h"
#import "GYHDUserSetingViewController.h"
#import "GYAppDelegate.h"
#import "GYSlideMenuController.h"
#import "GYTabBarController.h"
#import "GYCityAddressModel.h"
#import "GYProvinceModel.h"
#import "GYLocationManager.h"
#import "iVersion.h"
#import "UIDevice+YYAdd.h"
#import "GYHSPopView.h"
#import "GYHDSDK.h"
#import "GYHDMessageCenter.h"
#import "GYHSMainViewController.h"
#import "GYHDMessageMainViewController.h"

#define kLoginModel_SaveData_Key @"kLoginModel_SaveData_Key"
#define kLocalInfo_SaveData_Key @"kLocalInfo_SaveData_Key"
#define kLoginHistory_SaveData_Key @"kLoginHistory_SaveData_Key"

// 登录保存的状态
#define kGYHSLoginManagerTypeKey @"kGYHSLoginManagerTypeKey"
// 登录持卡状态
#define kGYHSLoginManagerHasCard @"kGYHSLoginManagerHasCard"
// 登录非持卡状态
#define kGYHSLoginManagerNoCard @"kGYHSLoginManagerNoCard"

@interface GYHSLoginManager ()

@property (nonatomic, strong) GYHSLoginModel* loginModule;
@property (nonatomic, strong) GYHSAlternateModel* tmpAlternateModel;
@property (strong, nonatomic) NSDictionary* tmpDicHsConfig;
@property (nonatomic, strong) GYHSRequestData* requestData;

// 错误码配置文件
@property (strong, nonatomic) NSDictionary* errConfigDic;

@property (strong, nonatomic) GYHSPopView* popView;
@property (strong, nonatomic) NSString* userIp;

@end

@implementation GYHSLoginManager

#pragma mark - public methods
+ (GYHSLoginManager*)shareInstance
{
    static GYHSLoginManager* manager;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GYHSLoginManager alloc] init];
        [manager initObj];
    });

    return manager;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (GYHSLoginModel*)loginModuleObject
{
    [self initLoginModelLocalData];

    return self.loginModule;
}

- (void)saveLoginModel:(GYHSLoginModel*)module
{
    self.loginModule = module;
    [self saveData:self.loginModule];
}

- (GYHSLocalInfoModel*)localInfoModel
{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kLocalInfo_SaveData_Key];
    GYHSLocalInfoModel* module = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    return module;
}

- (void)saveLocalInfoModel:(GYHSLocalInfoModel*)module
{
    if ([GYUtils checkObjectInvalid:module]) {
        DDLogDebug(@"The module is nil.");
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:module];
        [userDefault setObject:data forKey:kLocalInfo_SaveData_Key];
        [userDefault synchronize];
    });
}

- (GYHSAlternateModel*)alternateModel
{
    return self.tmpAlternateModel;
}

- (void)savealternateModel:(GYHSAlternateModel*)model
{
    self.tmpAlternateModel = model;
}

- (NSMutableArray*)loginHistoryModel
{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginHistory_SaveData_Key];
    NSMutableArray* resultArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    if ([GYUtils checkArrayInvalid:resultArray]) {
        resultArray = [NSMutableArray array];
    }

    return resultArray;
}

- (void)saveLoginHistoryModel:(GYHSLoginHistoryModel*)model
{
    NSMutableArray* resultAry = [self loginHistoryModel];

    for (GYHSLoginHistoryModel* indexModel in resultAry) {
        if ([model.userName isEqualToString:indexModel.userName]) {
            [resultAry removeObject:indexModel];
            break;
        }
    }

    // 最近登录的数据放到首位
    if ([resultAry count] > 0) {
        [resultAry insertObject:model atIndex:0];
    }
    else {
        [resultAry addObject:model];
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:resultAry];
        [userDefault setObject:data forKey:kLoginHistory_SaveData_Key];
        [userDefault synchronize];
    });
}

- (void)initLoginHistory:(NSArray*)saveAry
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:saveAry];
        [userDefault setObject:data forKey:kLoginHistory_SaveData_Key];
        [userDefault synchronize];
    });
}

- (NSString*)userName
{
    [self initLoginModelLocalData];

    if ([GYUtils checkObjectInvalid:self.loginModule]) {
        return @"06002111712";
    }

    return self.loginModule.resNo;
}

- (GYHSAppLanguage)appLanguage
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];

    NSArray* languages = [def objectForKey:@"AppleLanguages"];
    NSString* currentLanguage = [languages objectAtIndex:0];

    if ([currentLanguage hasPrefix:@"zh-Hans"]) {
        return GYHSAppLanguageChineseSimplified;
    }
    else if ([currentLanguage hasPrefix:@"zh-Hant"]) {
        return GYHSAppLanguageChineseTraditional;
    }
    else {
        return GYHSAppLanguageEnglish;
    }
}

- (NSDictionary*)dicHsConfig
{
    if (_tmpDicHsConfig) {
        return _tmpDicHsConfig;
    }

    NSString* configFilePath = [[NSBundle mainBundle] pathForResource:@"GYHSAccountDetailConfig" ofType:@"plist"];
    if (!configFilePath)
        return nil;
    _tmpDicHsConfig = [NSDictionary dictionaryWithContentsOfFile:configFilePath];
    return _tmpDicHsConfig;
}

- (void)clearSaveData
{
    self.loginModule = nil;
    self.tmpAlternateModel = nil;
    self.tmpDicHsConfig = nil;
    [self.requestData clearSaveData];

    // 清理缓存数据
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:kLoginModel_SaveData_Key];
    [userDefault removeObjectForKey:kLocalInfo_SaveData_Key];
    [userDefault synchronize];
}

- (BOOL)checkLogin
{
    [self initLoginModelLocalData];

    if ([GYUtils checkObjectInvalid:self.loginModule] ||
        [GYUtils checkStringInvalid:self.loginModule.userName]) {
        return NO;
    }

    return YES;
}

- (void)reLogin
{
    [self clearLoginInfo];
    [self showLoginView];
}

// 清空登录信息
- (void)clearLoginInfo
{
    [self clearSaveData];

    globalData.isLogined = NO;
    globalData.isHdLogined = NO;
    //[[GYXMPP sharedInstance] Logout];
    [[GYHDSDK sharedInstance] logout];
    globalData.loginModel = [[GYHSLoginModel alloc] init];
}

- (void)autoLogin
{
    globalData.loginModel = [self loginModuleObject];

    if (globalData.loginModel != nil) {
        [self setGlobalData];
    }
}

- (void)showLoginView
{
    [self showLoginView:1 otherLogin:NO];
}

- (void)showLoginView:(NSInteger)dismissToBarIndex otherLogin:(BOOL)otherLogin
{
    if (otherLogin == NO) {
        // 跟页面不显示登陆对话框
        UITabBarController* tabBarVc = (UITabBarController*)globalData.viewController.mainViewController;
        id selectVC = tabBarVc.selectedViewController;

        if ([selectVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController* selectNav = (UINavigationController*)selectVC;
            NSArray* vcAry = selectNav.viewControllers;

            if ([vcAry count] <= 0) {
                DDLogDebug(@"The vcAry count is zero.");
                return;
            }

            if ([vcAry count] == 1) {
                if (tabBarVc.selectedIndex == 3) {
                    GYHSMainViewController* vc = [vcAry firstObject];
                    [vc showLoginView];
                    return;
                }
                else if (tabBarVc.selectedIndex == 0) {
                    GYHDMessageMainViewController* vc = [vcAry firstObject];
                    [vc showLoginView];
                    return;
                }
                else {
                    DDLogDebug(@"Not need to show login view.");
                    return;
                }
            }
        }
    }

    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kGYHSLoginManagerTypeKey];
    NSString* loginTypeKey = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    // 同时只显示一个登录对话框
    if (self.popView) {
        [self.popView dismissViewPop];
        self.popView = nil;
    }

    self.popView = [[GYHSPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    GYHSLoginMainVC* vc = [[GYHSLoginMainVC alloc] init];
    vc.loginType = GYHSLoginViewControllerTypeHashsCard;
    if (![GYUtils checkStringInvalid:loginTypeKey] && [loginTypeKey isEqualToString:kGYHSLoginManagerNoCard]) {
        vc.loginType = GYHSLoginViewControllerTypeNohsCard;
    }

    vc.popType = GYHSLoginVCShowPopView;
    vc.pageType = GYHSLoginVCPageTypeHE;
    [self.popView showView:vc withViewFrame:CGRectMake(10, (kScreenHeight - 325) / 2, kScreenWidth - 20, 325)];
}

- (void)goToRootView:(NSInteger)tabIndex
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        globalData.viewController = [[GYSlideMenuController alloc] init];
        GYHDUserSetingViewController *leftView = [[GYHDUserSetingViewController alloc] init];
        globalData.viewController.mainViewController = [[GYTabBarController alloc] init];
        globalData.viewController.leftViewController = leftView;
        kAppDelegate.window.rootViewController = globalData.viewController;
        UITabBarController *tabBarVc = (UITabBarController *)globalData.viewController.mainViewController;
        tabBarVc.selectedIndex = tabIndex;
    });
}

- (void)setGlobalData
{
    globalData.retailDomain = globalData.loginModel.phapiUrl;
    globalData.foodConsmerDomain = globalData.loginModel.foodUrl;
    globalData.tfsDomain = globalData.loginModel.tfsDomain;
    globalData.isLogined = YES;

    NSString* hasHSCard = kGYHSLoginManagerHasCard;
    if (!globalData.loginModel.cardHolder) {
        globalData.loginModel.resNo = globalData.loginModel.userName;
        hasHSCard = kGYHSLoginManagerNoCard;
    }

    // 缓存前一次等状态
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:hasHSCard];
    [userDefault setObject:data forKey:kGYHSLoginManagerTypeKey];
    [userDefault synchronize];

    [self loginToHDServer];
    [self.requestData queryCustGlobalData:^(GYHSCustGlobalDataModel* custGlobaModel) {
        if (custGlobaModel == nil) {
            DDLogDebug(@"The localModel is nil.");
            return;
        }
        
        globalData.custGlobalDataModel = custGlobaModel;
    }];

    WS(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf queryLocalInfoData];
    });
}

- (NSString*)showErrorMsg:(NSDictionary*)responseDic
{
    NSString* retCode = kSaftToNSString(responseDic[@"retCode"]);
    NSString* errorMsg = kSaftToNSString(responseDic[@"msg"]);

    return [self showErrorMsg:retCode errorMsg:errorMsg];
}

- (NSString*)showErrorMsg:(NSString*)returnCode errorMsg:(NSString*)errorMsg
{
    NSString* msg = kLocalized(@"GYHS_Login_Universally_synchronousError");

    // 从msg获取的消息的错误码
    NSArray* errorAry = @[ @"160467", @"160411" ];

    NSString* retCode = kSaftToNSString(returnCode);
    if ([GYUtils checkStringInvalid:retCode]) {
        return msg;
    }

    msg = self.errConfigDic[retCode];

    // 登录密码, 交易密码,使用后台的信息
    if ([errorAry containsObject:retCode]) {
        msg = errorMsg;
    }

    if ([@"804" isEqualToString:retCode] ||
        [@"611" isEqualToString:retCode]) {
        msg = kLocalized(@"手机号已注册");
    }
    else if ([@"160133" isEqualToString:retCode]) {
        msg = kLocalized(@"短信验证码不正确");
    }
    else if ([@"160134" isEqualToString:retCode]) {
        msg = kLocalized(@"短信验证码已过期,请重新获取");
    }

    DDLogDebug(@"showErrorMsg: retCode:%@, msg:%@", retCode, msg);

    if ([GYUtils checkStringInvalid:msg]) {
        msg = kLocalized(@"GYHS_Login_Universally_synchronousError");
    }

    return msg;
}

- (void)getLocationInfo
{
    [[GYLocationManager sharedInstance] reverseAdress:^(NSString* cityName, NSString* address) {
        DDLogDebug(@"cityName:%@, address:%@", cityName, address);
        
        globalData.locaitonAddress = kSaftToNSString(address);
        globalData.locationCity = kSaftToNSString(cityName);
        globalData.selectedCityName = kSaftToNSString(cityName);
        
        // 地址定位后发送通知，变更地址
        [[NSNotificationCenter defaultCenter] postNotificationName:kGYHSLoginManagerCityAddressNotification object:nil];
    }];

    [[GYLocationManager sharedInstance] localCoordinate:YES block:^(CLLocationCoordinate2D coord) {
        DDLogDebug(@"coord lat:%f, lon:%f", coord.latitude, coord.longitude);
        
        globalData.locationCoordinate = coord;
        globalData.selectedCityCoordinate = nil;
        globalData.selectedCityAddress = nil;
        globalData.selectedCityName = nil;
    }];
}

- (void)updateNetState
{
    AFNetworkReachabilityManager* manager = [AFNetworkReachabilityManager sharedManager];
    globalData.isOnNet = YES;

    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable:
                globalData.isOnNet = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                globalData.isOnNet = YES;
                break;
            default:
                break;
        }
    }];

    [manager startMonitoring];
}

- (void)checkVersionUpdate
{
    [self.requestData checkVersionUpdate:^(NSString* updateLevel) {
        DDLogDebug(@"updateLevel:%@, kConsumerAppId:%d", updateLevel, kConsumerAppId);
        
        // 0 级别不需要升级
        if ([@"0" isEqualToString:updateLevel]) {
            return;
        }
        
        iVersionUpdatePriority level = iVersionUpdatePriorityDefault;
        
        // 高级别需要强制升级
        if ([@"1" isEqualToString:updateLevel]) {
            level = iVersionUpdatePriorityHigh;
        }
        //可选择升级
        else if([@"2" isEqualToString:updateLevel]) {
            level = iVersionUpdatePriorityLow;
        }
        
        [iVersion sharedInstance].appStoreID = kConsumerAppId;
        [iVersion sharedInstance].updatePriority = level;
    }];
}

- (void)pingUserIP
{
    WS(weakSelf)
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:@"http://ip.taobao.com/service/getIpInfo.php?ip=myip" parameters:@{} requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        if (error) {
            DDLogDebug(@"error:%@", [error localizedDescription]);
            return;
        }
        
        NSDictionary *serverDic = [responseObject valueForKey:@"data"];
        if ([GYUtils checkDictionaryInvalid:serverDic]) {
            DDLogDebug(@"The serverDic:%@ is invalid.", serverDic);
            return;
        }
        weakSelf.userIp = [serverDic valueForKey:@"ip"];
        DDLogDebug(@"userIP:%@", self.userIp);
    }];
    request.returnCodeName = @"code";
    request.returnCodeAry = [NSMutableArray arrayWithObject:@0];
    request.noShowErrorMsg = YES;
    [request start];
}

- (NSString*)userDeviceIP
{
    NSString* tmpIP = self.userIp;
    if ([GYUtils checkStringInvalid:tmpIP]) {
        tmpIP = [UIDevice currentDevice].ipAddressCell ? [UIDevice currentDevice].ipAddressCell : [UIDevice currentDevice].ipAddressWIFI;
    }

    return kSaftToNSString(tmpIP);
}

#pragma mark - event Action
- (void)loginSucessedAction
{
    if (self.popView) {
        [self.popView dismissViewPop];
        self.popView = nil;
    }
}

#pragma mark - private methods
- (void)initObj
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucessedAction) name:kGYHSLoginMainVCLoginSucessedNotification object:nil];
}

- (void)initLoginModelLocalData
{
    if ([GYUtils checkObjectInvalid:self.loginModule]) {
        self.loginModule = [self unarchiveLoginModel];
    }
}

- (void)saveData:(GYHSLoginModel*)module
{
    if ([GYUtils checkObjectInvalid:module]) {
        DDLogDebug(@"The module is nil.");
        return;
    }
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:module];
    [userDefault setObject:data forKey:kLoginModel_SaveData_Key];
    [userDefault synchronize];
}

- (GYHSLoginModel*)unarchiveLoginModel
{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginModel_SaveData_Key];
    GYHSLoginModel* module = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    return module;
}

- (void)loginToHDServer
{

    //    [[GYHDMessageCenter sharedInstance] searchFriendWithCustId:globalData.loginModel.custId RequetResult:^(NSDictionary *resultDict) {
    //
    //    }];
    NSMutableDictionary* frienddeletedict = [NSMutableDictionary dictionary];
    frienddeletedict[@"friendChange"] = @(GYHDProtobufMessage04102);
    frienddeletedict[@"toID"] = globalData.loginModel.custId;
    [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:frienddeletedict];

    //设置主机参数
    [[GYHDSDK sharedInstance] loginWithChannelType:IMChannelTypeMobile
                                        DeviceType:[GYHDMessageCenter sharedInstance].deviceType
                                       entResNoStr:@""
                                       deviceToken:[GYHDMessageCenter sharedInstance].deviceToken
                                             block:^(IMLoginState state) {
                                                 
                                                 switch (state) {
                                                     case kIMLoginStateAuthenticateSucced:
                                                         globalData.isHdLogined = YES;

                              
                                                         break;
                                                     default:
                                                         globalData.isHdLogined = NO;
                                                         break;
                                                 }
                                             }];

    NSString* dbFullName = [[GYHDMessageCenter sharedInstance] getUserDBNameInDirectory:[GYHDSDK sharedInstance].username];
    if (![[GYHDMessageCenter sharedInstance] fileIsExists:dbFullName]) {
        DDLogInfo(@"用户数据库不存在，将创建");
        if (![[GYHDMessageCenter sharedInstance] createFile:dbFullName]) {
            //                [GYUtils alertViewOKbuttonWithTitle:nil message:@"sorry, create user's im db error."];
            return;
        }
    }

    DDLogInfo(@"im数据库完整路径:%@", dbFullName);
    //    _imFMDB = [[FMDatabase alloc] initWithPath:dbFullName];
    [[GYHDMessageCenter sharedInstance] savedbFull:dbFullName];
    //    GYXMPP* xmp = [GYXMPP sharedInstance];
    //    //设置主机参数
    //    [xmp login:^(IMLoginState state) {
    //        switch (state) {
    //            case kIMLoginStateAuthenticateSucced:
    //                globalData.isHdLogined = YES;
    //                break;
    //            default:
    //                globalData.isHdLogined = NO;
    //                break;
    //        }
    //    }];
}

// 获取平台信息
- (void)queryLocalInfoData
{
    [self.requestData queryLocalInfo:^(GYHSLocalInfoModel* localModel) {
        if (localModel == nil) {
            DDLogDebug(@"The localModel is nill.");
            return;
        }

        globalData.localInfoModel = localModel;
        [self saveLocalInfoModel:localModel];

        NSMutableArray* provinceAry = [[GYAddressData shareInstance] selectAllProvinces];
        if (![[GYAddressData shareInstance] checkProvinceValid:provinceAry]) {
            [[GYAddressData shareInstance] clearDataByKey:kProvinceKey];
            [provinceAry removeAllObjects];
        }
        
        NSMutableArray *cityAry = [[GYAddressData shareInstance] selectAllCitys];
        if (![[GYAddressData shareInstance] checkCityValid:cityAry]) {
            [[GYAddressData shareInstance] clearDataByKey:kCityKey];
            [cityAry removeAllObjects];
        }
        
        if ([provinceAry count] <= 0 || [cityAry count] <= 0) {
            [[GYAddressData shareInstance] netRequestForAddressInfo];
        }
    }];

    //全部国家
    NSMutableArray* countrysAry = [[GYAddressData shareInstance] selectAllCountrys];
    if (![[GYAddressData shareInstance] checkCountryValid:countrysAry]) {
        [[GYAddressData shareInstance] clearDataByKey:kCountryKey];
        [countrysAry removeAllObjects];
    }
    if (countrysAry.count <= 0) {
        [[GYAddressData shareInstance] netRequestForCountrys:nil];
    }
}

#pragma mark - getter and setter
- (GYHSRequestData*)requestData
{
    if (_requestData == nil) {
        _requestData = [[GYHSRequestData alloc] init];
    }

    return _requestData;
}

- (NSDictionary*)errConfigDic
{
    if (_errConfigDic == nil) {
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"GYErrorMsgConfig"
                                                             ofType:@"plist"];
        if (filePath == nil) {
            return nil;
        }

        NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        if ([self appLanguage] == GYHSAppLanguageChineseSimplified) {
            _errConfigDic = dic[@"zh-Hans"];
        }
        else if ([self appLanguage] == GYHSAppLanguageChineseTraditional) {
            _errConfigDic = dic[@"zh-Hant"];
        }
        else {
            _errConfigDic = dic[@"en"];
        }
    }

    return _errConfigDic;
}

@end
