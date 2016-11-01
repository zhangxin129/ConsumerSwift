//
//  GYLoginHttpTool.m
//  HSCompanyPad
//
//  Created by User on 16/8/2.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYLoginHttpTool.h"
#import <YYKit/YYKit.h>

#import "GYLoginEn.h"
#import <GYKit/CALayer+Transition.h>
#import "GYAuthorityCenter.h"
#import "GYUtilsConst.h"
#import <GYKit/GYKitConstant.h>
#import "GYNetApiMacro.h"
#import "GYAuthorityCenter.h"
#import "GYNetwork.h"
#import "GYLoginModel.h"
#import "GlobalData.h"
#import "GYAreaHttpTool.h"
#import "GYHDSDK.h"
#import <MJExtension/MJExtension.h>
#import "GYGIFHUD.h"

@implementation GYLoginHttpTool


//为什么放在这里，因为要避免耦合，对外只暴露方法和接口 by jianglincen
NSString* const K_USERNAME = @"com.guiyi.company.username";
NSString* const K_USEPWD = @"com.guiyi.company.password";

NSString* const K_USERLOGINTYPE = @"com.guiyi.company.usertype";
NSString* const GYNOCARDLOGINTYPE = @"com.guiyi.company.GYNOCARDLOGINTYPE";

NSString* const GYCARDLOGINTYPE = @"com.guiyi.company.GYCARDLOGINTYPE";

NSString* const K_OPERATER = @"com.guiyi.company.operater";

NSString* const GY_LoginModelPath = @"com.guiyi.company.GY_LoginModelPath";

#pragma mark - 登录接口
+ (void)loginWithResNo:(NSString*)resNO userName:(NSString*)userName password:(NSString*)pwd success:(HTTPSuccess)success failure:(HTTPFailure)failure
{
     [GYGIFHUD show];
    
    if (userName) { //企业号
        pwd = [pwd encodeWithKey:[resNO stringByAppendingString:userName]];
    }
    else { //互生卡登录
        pwd = [pwd encodeWithKey:resNO];
    }
    



    NSMutableDictionary* dict = @{
        @"resNo" : resNO ? resNO : @"",
        @"userName" : userName ? userName : @"",
        @"loginIp" : [self userDeviceIP],
        @"loginPwd" : pwd ? pwd : @"",
        @"versionNumber" : kAppVersion,
        @"channelType" : GYChannelType
    }.mutableCopy;

    kSetNSUser(GYLoginResNoKey, (@{ @"resNo" : resNO,
        @"userName" : userName ? userName : @"" }));
  
    
    

    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSOperatorLogin) parameter:dict success:^(id returnValue) {
    
        if (kHTTPSuccessResponse(returnValue)) {
              globalData.loginModel = [GYLoginModel mj_objectWithKeyValues:returnValue[GYNetWorkDataKey]];
            
              
            if (kSYSTEM_ADMINISTRATOR || kCASHIER || kSTAFFER || kSTORE_MANAGER || kWAITER) {//只有这五种角色才允许
                [GYUtils showToast:@"登录成功"];
                KExcuteBlock(success,returnValue[GYNetWorkDataKey]);
              
                [self settleLoginBusiness];
                
//                
//                //归档保存Model
//                [GYUtils writeModel:returnValue[GYNetWorkDataKey] toPath:GY_LoginModelPath];
    
                
                
            }else {
                [GYUtils showToast:@"无访问权限"];
          
            }
        }

        success(returnValue);

    } failure:^(NSError* error) {
    
        [GYUtils showToast:kLocalized(@"网络连接错误")];

    } isIndicator:YES];
}

+ (void)getEntGlobaleData
{

    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSEntGloabalData) parameter:nil success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue)) {
            globalData.config = [GYEntGlobalData mj_objectWithKeyValues:returnValue[GYNetWorkDataKey]];
        }else {
        
        
        }
    } failure:nil];
}

+ (BOOL)translationRole:(NSString*)roleId
{

    NSString* roleStr = globalData.loginModel.roles.firstObject.roleId; //roleId越小 权限越大，暂时使用比较大小来进行处理
    for (Role* model in globalData.loginModel.roles) {
        if (model.roleId.integerValue < roleStr.integerValue) {
            roleStr = model.roleId;
        }
    }

    if ([roleStr isEqualToString:roleId]) {
        return YES;
    }

    return NO;
}

#pragma mark - 退出登录
+ (void)logoutWithSuccess:(HTTPSuccess)success failure:(HTTPFailure)failure
{

    [globalData.timer invalidate];
    globalData.timer = nil;
    [GYUtils deleteFromPath:GY_LoginModelPath];

    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSOperatorLogout) parameter:@{ @"channelType" : GYChannelType,
        @"custId" : globalData.loginModel.custId,
        @"token" : globalData.loginModel.token }
        success:^(id returnValue) {
                                                                             globalData.isLogined = NO;
                                                                             KExcuteBlock(success, returnValue);
        }
        failure:^(NSError* error) {

        }
        isIndicator:YES];
}

#pragma mark - 处理登录后的同步数据
+ (void)settleLoginBusiness
{
    [self getEntGlobaleData];
    
    [self loginToHDServer];
    
    //    [self loadMainVc];

    //    [[GYPOSService sharedInstance] disConnectionPOS];//需要登录的时候断开刷卡器，放置刷卡器断开未成功
    [GYAreaHttpTool queryProvinceTreeWithCountryNo:globalData.loginModel.countryCode success:nil failure:nil]; //通过国家地区文件
    
    //获取企业信息状态
     [kDefaultNotificationCenter postNotificationName:GYPointAndMemberCancelStatusNotification object:nil];
}

/**
 *  登录互动服务器
 *aaaaaaaa
 *  @param success 回调
 */
+ (void)loginToHDServer{
    
    
    //设置主机参数
    [[GYHDSDK sharedInstance] loginWithChannelType:IMChannelTypeHSPad
                                        DeviceType:[GYHDMessageCenter sharedInstance].deviceType
                                       entResNoStr:globalData.loginModel.entResNo
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
}

+ (void)autoLogin
{

    if ([GYUtils readFromPath:GY_LoginModelPath]) {

        globalData.loginModel = [GYLoginModel mj_objectWithKeyValues:[GYUtils readFromPath:GY_LoginModelPath]];
        globalData.isLogined = YES;
        [self getEntGlobaleData];
        
      
    }
    else {
        //如果没有曾经登录过,需要登录,此登录方法尚不严谨，纯属照搬，待以后修正

        globalData.isLogined = NO;
    }
}

+ (void)checkPassWordWithPassword:(NSString*)passWord Success:(HTTPSuccess)success failure:(HTTPFailure)failure
{

    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSLoginPwdValid) parameter:@{ @"userType" : GYUserTypeCompany,
        @"loginPwd" : [passWord encodeWithKey:globalData.loginModel.custId],
        @"custId" : globalData.loginModel.custId }
        success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue)) {
            KExcuteBlock(success, returnValue);
        }else  {
            KExcuteBlock(failure,nil);
        }
        }
        failure:^(NSError* error) {
            KExcuteBlock(failure,nil);
        }isIndicator:YES];
}

+ (void)relogin {
    if (globalData.isLogined) {
        
        [GYUtils showToast:@"您的账号已经在别处登录，请重新登录"];
    }
    
//    互信隐藏消息右上角红点
     [[NSNotificationCenter defaultCenter] postNotificationName:GYHDOtherLoginNotification object:nil];
    
    [self clearData];
 


}

+ (void)clearData {
    [globalData.timer invalidate];
    globalData.timer = nil;
    globalData.isLogined = NO;
    globalData.isHdLogined = NO;
    globalData.isLocked = NO;
    globalData.loginModel = [[GYLoginModel alloc]init];
    [kDefaultNotificationCenter postNotificationName:GYCommonPopRootNotification object:nil];
    [kDefaultNotificationCenter postNotificationName:GYCommonLogoutNotification object:nil];

}

- (void)dealloc
{
    [kDefaultNotificationCenter removeObserver:self];
}
+ (void)pingUserIP{
    
    [GYNetwork GET:@"http://ip.taobao.com/service/getIpInfo.php?ip=myip" parameter:@{} success:^(id returnValue) {
        NSDictionary *serverDic = returnValue[GYNetWorkDataKey];
        if ([GYUtils checkDictionaryInvalid:serverDic]) {
            DDLogDebug(@"The serverDic:%@ is invalid.", serverDic);
            return;
        }
        globalData.userIp = [serverDic valueForKey:@"ip"];
        
    } failure:^(NSError *error) {
        
    }];
}
+ (NSString*)userDeviceIP{
    NSString* tmpIP = globalData.userIp;
    if ([GYUtils checkStringInvalid:tmpIP]) {
        tmpIP = [UIDevice currentDevice].ipAddressCell ? [UIDevice currentDevice].ipAddressCell : [UIDevice currentDevice].ipAddressWIFI;
    }
    
    return kSaftToNSString(tmpIP);
}

@end
