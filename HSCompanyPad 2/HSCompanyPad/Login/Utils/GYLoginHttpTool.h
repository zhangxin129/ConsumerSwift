//
//  GYLoginHttpTool.h
//  HSCompanyPad
//
//  Created by User on 16/8/2.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYLoginHttpTool : NSObject

/**
 *  登录接口
 *
 *  @param resNO    资源号
 *  @param userName 用户名
 *  @param pwd      密码 未加密
 */
+ (void)loginWithResNo:(NSString*)resNO userName:(NSString*)userName password:(NSString*)pwd success:(HTTPSuccess)success failure:(HTTPFailure)failure;

+ (void)logoutWithSuccess:(HTTPSuccess)success failure:(HTTPFailure)failure;

////自动登录
//+ (void)autoLogin;
//

+ (void)checkPassWordWithPassword:(NSString *)passWord Success:(HTTPSuccess)success failure:(HTTPFailure)failure;
+ (void)relogin;
+ (void)clearData ;
+ (void)pingUserIP;

@end
