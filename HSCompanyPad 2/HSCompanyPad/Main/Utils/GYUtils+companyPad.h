//
//  GYUtils+companyPad.h
//  HSCompanyPad
//
//  Created by sqm on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <GYKit/GYUtils.h>

@interface GYUtils (companyPad)


/**
 *功能：判断字符串是否为null
 *@param
 *NSString     string    要判断的字符串
 *返回：字符串
 */
+ (BOOL)isBlankString:(NSString *)string;
#pragma mark - 存模型
+ (void)writeModel : (NSObject *)model toPath : (NSString *)modelName;

#pragma mark - 读取模型
+ (NSObject *)readFromPath : (NSString *)modelName;

#pragma mark - 删除模型
+ (BOOL)deleteFromPath : (NSString *)modelName;

+ (NSString *)getAppLanguage;

//验证输入的是否是正确格式的手机号
+ (BOOL)isValidMobileNumber:(NSString*)mobileNum;

+ (NSString *)transPOSAmount:(NSString *)amount;
// 字符串为空判断，非法返回真
+ (BOOL)checkStringInvalid:(NSString*)param;
+ (BOOL)checkObjectInvalid:(id)param;
+ (BOOL)checkDictionaryInvalid:(id)param;
@end
