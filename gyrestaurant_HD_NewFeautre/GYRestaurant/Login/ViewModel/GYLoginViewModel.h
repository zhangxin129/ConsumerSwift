//
//  GYLoginViewModel.h
//  GYRestaurant
//
//  Created by kuser on 15/10/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "ViewModel.h"

typedef void (^dictResult)(NSDictionary * dictData, NSError *error);

@interface GYLoginViewModel : ViewModel
/**
 *  登录接口
 *
 *  @param resNO    资源号
 *  @param userName 用户名
 *  @param pwd      密码
 *  @param userType 用户类型
 *  @param result   回调
 */
- (void)loginWithResNo:(NSString *)resNO userName:(NSString *)userName password:(NSString *)pwd ;
+ (void)logout;

+ (void)clearLoginData;

+ (void)relogin;

@end
