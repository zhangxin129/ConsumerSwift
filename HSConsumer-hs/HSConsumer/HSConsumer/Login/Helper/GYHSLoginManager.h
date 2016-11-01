//
//  GYHSLogonManager.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/22.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

// 发送获取到城市地址信息的通知
#define kGYHSLoginManagerCityAddressNotification @"kGYHSLoginManagerCityAddressNotification"

typedef NS_ENUM(NSInteger, GYHSAppLanguage) {
    GYHSAppLanguageEnglish = 0,
    GYHSAppLanguageChineseSimplified,
    GYHSAppLanguageChineseTraditional
};

@class GYHSLoginHistoryModel;
@class GYHSAlternateModel;
@class GYHSLoginModel;
@class GYHSLocalInfoModel;
@interface GYHSLoginManager : NSObject

+ (GYHSLoginManager*)shareInstance;

- (GYHSLoginModel*)loginModuleObject;

- (void)saveLoginModel:(GYHSLoginModel*)module;

- (GYHSLocalInfoModel*)localInfoModel;

- (void)saveLocalInfoModel:(GYHSLocalInfoModel*)module;

- (GYHSAlternateModel*)alternateModel;

- (void)savealternateModel:(GYHSAlternateModel*)model;

- (NSMutableArray*)loginHistoryModel;

- (void)saveLoginHistoryModel:(GYHSLoginHistoryModel*)model;

- (void)initLoginHistory:(NSArray*)saveAry;

- (NSString*)userName;

- (GYHSAppLanguage)appLanguage;

// 互生的配置文件
- (NSDictionary*)dicHsConfig;

- (void)clearSaveData;

- (BOOL)checkLogin;

- (void)clearLoginInfo;

- (void)reLogin;

- (void)autoLogin;

- (void)showLoginView;

// 显示登录对话框，关闭后跳转到指定tabbar上
- (void)showLoginView:(NSInteger)dismissToBarIndex otherLogin:(BOOL)otherLogin;

// 切换到tabBar的跟视图
- (void)goToRootView:(NSInteger)tabIndex;

- (void)setGlobalData;

// 从错误码配置文件，获取错误信息
- (NSString*)showErrorMsg:(NSDictionary*)responseDic;

- (NSString*)showErrorMsg:(NSString*)returnCode errorMsg:(NSString*)errorMsg;

// 初始化位置信息
- (void)getLocationInfo;

// 更新网络状态
- (void)updateNetState;

- (void) checkVersionUpdate;

- (void) pingUserIP;

// 获取设备的IP地址
- (NSString*)userDeviceIP;

@end
