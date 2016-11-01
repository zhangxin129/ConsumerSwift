//
//  GYLoginViewModel.m
//  GYCompany
//
//  Created by cook on 15/9/20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYLoginViewModel.h"
#import "GYencryption.h"
#import "GYLoginEn.h"
#import "GYGIFHUD.h"
#import "GYXMPP.h"
#import "GYLoginModel.h"
#import "GYLoginViewController.h"
#import "UIDevice+YYAdd.h"
#import "AppDelegate.h"
#import "CALayer+Transition.h"
#import "GYHDNetWorkTool.h"

@implementation GYLoginViewModel


#pragma mark 登陆
- (void) loginWithResNo:(NSString *)resNO userName:(NSString *)userName password:(NSString *)pwd{
    
    pwd = [GYencryption l:pwd k:[resNO stringByAppendingString:userName]];
    NSMutableDictionary *dict = @{@"resNo":resNO,@"userName":userName,@"loginPwd":pwd,@"versionNumber":kAppVersion,@"loginIp":kDeviceIp,@"channelType":GYChannelType}.mutableCopy ;
    [Network POST:GY_FOODLOGINAPPENDING(GYHEFoodOperatorLogin) parameter:dict success:^(id returnValue) {
        if ([returnValue[@"retCode"] isEqualToNumber:@200]){
            globalData.loginModel = [GYLoginModel mj_objectWithKeyValues:returnValue[@"data"]] ;
            RoleListModel *tempModel = [[RoleListModel alloc] init];
            for (RoleListModel *model in globalData.loginModel.roles) {
                if (tempModel.roleId == nil) {
                    tempModel = model;
                }else if ([tempModel.roleId integerValue] > [model.roleId integerValue]) {
                    tempModel = model;
                }
            }
              globalData.isLogined = YES;
            if (tempModel.roleId.length > 0) {
                if ([tempModel.roleId isEqualToString:@"301"]) {
                    globalData.currentRole = roleTypeTrusteeshipCompanySystemAdministrator;
                }
                if ([tempModel.roleId isEqualToString:@"302"]) {
                    globalData.currentRole = roleTypeTrusteeshipCompanyStoreManger;
                }
                if ([tempModel.roleId isEqualToString:@"303"]) {
                    globalData.currentRole = roleTypeTrusteeshipCompanyCashier;
                }
                if ([tempModel.roleId isEqualToString:@"304"]) {
                    globalData.currentRole = roleTypeTrusteeshipCompanyWaiter;
                }
                if ([tempModel.roleId isEqualToString:@"305"]) {
                    globalData.currentRole = roleTypeTrusteeshipCompanyDeliveryStaff;
                }
                
                if ([tempModel.roleId isEqualToString:@"201"]) {
                    globalData.currentRole = roleTypeMemberCompanySystemAdministrator;
                }
                if ([tempModel.roleId isEqualToString:@"202"]) {
                    globalData.currentRole = roleTypeMemberCompanyStoreManger;
                }
                if ([tempModel.roleId isEqualToString:@"203"]) {
                    globalData.currentRole = roleTypeMemberCompanyCashier;
                }
                if ([tempModel.roleId isEqualToString:@"204"]) {
                    globalData.currentRole = roleTypeMemberCompanyWaiter;
                }
                if ([tempModel.roleId isEqualToString:@"205"]) {
                    globalData.currentRole = roleTypeMemberCompanyDeliveryStaff;
                }
                [self loginToHDServer];
                
                [kDefaultNotificationCenter postNotificationName:@"startGetOfflineMsg" object:nil];
                
                [self getGlobalParams];
                //设置推送消息
                [self setPushInfo];
                
                self.returnBlock(globalData);
            }else{
            
                DDLogCInfo(@"roleId为空！");
            }
        
        }else if ([returnValue[@"retCode"] isEqualToNumber:@160102]){
            kNotice(kLocalized(@"UserDoesNotExist"));
            [GYGIFHUD dismiss];
        }else if ([returnValue[@"retCode"] isEqualToNumber:@160108] || [returnValue[@"retCode"] isEqualToNumber:@601]){
            kNotice(kLocalized(@"LoginFailedForUsernameOrPasswordIncorrect"));
            [GYGIFHUD dismiss];
        }else if ([returnValue[@"retCode"] isEqualToNumber:@160467]){
            kNotice(returnValue[@"msg"]);
            [GYGIFHUD dismiss];
        }else{
            kNotice(kLocalized(@"LoginFailed"));
        [GYGIFHUD dismiss];
        }

    } failure:^(id error) {
        [self error:error];
    }];
    
}

/**
 *  获取全局变量
 *
 *  @param result 回调
 */
- (void)getGlobalParams
{

    [Network GET:GY_FOODLOGINAPPENDING(GYHEFoodGlobalData) parameter:nil success:^(id returnValue) {
        if ([returnValue[@"retCode"] isEqualToNumber:@200]){
            globalData.attribute = [GlobalAttribute mj_objectWithKeyValues:returnValue[@"data"]] ;
        }
     
    } failure:^(id error){
        [self error:error];
        
    }];
}

+ (void)clearLoginData
{
    
    [GYGIFHUD dismiss];
    [[GYXMPP sharedInstance] Logout];
    globalData.isLogined = NO;
    globalData.isHdLogined = NO;
    
}

+ (void)logout
{
    [self  clearLoginData];
    void(^deleLogout)() =  ^{
    
        GYLoginViewController *loginView = [[GYLoginViewController alloc] init];
        GYNavigationController *ncLogin = [[GYNavigationController alloc] initWithRootViewController:loginView];
        [UIApplication sharedApplication].delegate.window.rootViewController = ncLogin;
        [self.class clearLoginData];
    };
    NSDictionary *dic = @{
                          @"channelType":GYChannelType,
                          @"custId":globalData.loginModel.custId,
                          @"token":globalData.loginModel.token,
                          };
   
        [Network POST:GY_FOODLOGINAPPENDING(GYHEFoodOperatorLogout) parameter:dic success:^(id returnValue) {
            deleLogout();
            
        } failure:^(id error) {
            deleLogout();
        }];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
     [kDefaultNotificationCenter postNotificationName:@"stopGetOfflineMsg" object:nil];
}


/**
 *  登录互动服务器
 *
 *  @param success 回调
 */
- (void)loginToHDServer
{

    [[GYXMPP sharedInstance] login:^(IMLoginState state) {
        switch (state) {
            case kIMLoginStateConnetToServerSucced:
                globalData.isHdLogined = YES;
                break;
                
            default:
                break;
        } }];
 
}



+ (void)relogin
{
  
    
    [self clearLoginData];
    if (globalData.isLogined) {
        [UIAlertView showWithTitle:kLocalized(@"prompt") message:kLocalized(@"YourLoginHaveExpired,PleaseSigninAgain?") cancelButtonTitle:kLocalized(@"SignIn") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
     
            GYLoginViewController *vcLogin = [[GYLoginViewController alloc]init];
            GYNavigationController *ncLogin = [[GYNavigationController alloc] initWithRootViewController:vcLogin];
            kAppDelegate.window.rootViewController = ncLogin;
             [kAppDelegate.window.layer transitionWithAnimType:TransitionAnimTypeReveal subType:TransitionSubtypesFromRight curve:TransitionCurveEaseIn duration:0.5f];
        }];

    }
       globalData.isLogined = NO;
       globalData.isHdLogined = NO;

}


#pragma mark- 首次登陆，设置推送消息状态
-(void)setPushInfo{
    
    NSString *key  = globalData.loginModel.custId;
    
    NSArray *array  = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    
    if (!array) {
        
        //如果不存在，说明没有设置过推送消息，则默认设置一次
        //@[@0,@0,@1,@1] 第一位代表免打扰全天,第二位代表夜晚时间,第三位代表声音，第四位置代表震动
        
        NSArray *pushArray =@[@0,@0,@1,@1];
        
        [[NSUserDefaults standardUserDefaults]setObject:pushArray forKey:key];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

@end
