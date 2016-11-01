//
//  GYUtils+companyPad.m
//  HSCompanyPad
//
//  Created by sqm on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYUtils+companyPad.h"



@implementation GYUtils (companyPad)
+ (void)showToast:(NSString*)text
{
    CSToastStyle *style = [[CSToastStyle alloc]initWithDefaultStyle];
    style.backgroundColor = [UIColor redColor];
    style.cornerRadius = 3;

    [[UIApplication sharedApplication].keyWindow makeToast:text duration:1 position:CSToastPositionCenter style:style];
    
}



#pragma mark - 存模型
+ (void)writeModel : (NSObject *)model toPath : (NSString *)modelName {
    //1.获取文件路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:modelName];
    
    //2.将自定义的对象保存到文件中
    [NSKeyedArchiver archiveRootObject:model toFile:path];
    
}

#pragma mark - 读取模型
+ (NSObject *)readFromPath : (NSString *)modelName {
    //1.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path=[docPath stringByAppendingPathComponent:modelName];
    
    //2.从文件中读取对象
    NSObject *object=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return object;
}

#pragma mark - 删除模型
+ (BOOL)deleteFromPath : (NSString *)modelName {
    //1.获取删除路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path=[docPath stringByAppendingPathComponent:modelName];
    return  [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
}

+ (NSString *)getAppLanguage
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    //获取系统当前语言版本(简体中文zh-Hans,繁体中文zh-Hant,英文en)
    NSArray* languages = [def objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage hasPrefix:GY_CHINESE]) {
        
        return GY_CHINESE;
        
    }else if ([currentLanguage hasPrefix:GY_TRADITIONAL]) {
        return GY_TRADITIONAL;
        
    }else if ([currentLanguage hasPrefix:GY_ENGLISH]) {
        return GY_ENGLISH;
        
    }
    return GY_ENGLISH;
    
}

//验证输入的是否是正确格式的手机号
+ (BOOL)isValidMobileNumber:(NSString*)mobileNum
{
    /**
     *手机号码
     *移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     *联通：130,131,132,152,155,156,185,186
     *电信：133,1349,153,180,189
     *4G号码段：178，177，176
     */
    
    
    NSString* MOBILE =@"^(\\+?\\d{2,3}\\-?\\s?)?1\\d{10}$";//不需要配备这么多规则，只用验证11位且开头是1的数字即可
    
    /**
     10         *中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString* CM =@"^1(34[0-8]|(3[5-9]|5[017-9]|8[278]|78)\\d)\\d{7}$";
    /**
     15         *中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString* CU =@"^1(3[0-2]|5[256]|8[56]|7[6])\\d{8}$";
    /**
     20         *中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString* CT =@"^1((33|53|8[09]|77)[0-9]|349)\\d{7}$";
    /**
     25         *大陆地区固话及小灵通
     26         *区号：010,020,021,022,023,024,025,027,028,029
     27         *号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    /**
     29         *国际长途中国区(+86)
     30         *区号：+86
     31         *号码：十一位
     32         */
    NSString* IPH =@"^\\+861(3|5|7|8)\\d{9}$";
    
    //判断是否为正确格式的手机号码
    NSPredicate* regextestmobile;
    NSPredicate* regextestcm;
    NSPredicate* regextestcu;
    NSPredicate* regextestct;
    NSPredicate* regextestiph;
    
    regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    regextestiph = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", IPH];
    
    if(([regextestmobile evaluateWithObject:mobileNum] == YES)
       || ([regextestcm evaluateWithObject:mobileNum] == YES)
       || ([regextestct evaluateWithObject:mobileNum] == YES)
       || ([regextestcu evaluateWithObject:mobileNum] == YES)
       || ([regextestiph evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        
        return NO;
    }
}
+ (NSString *)transPOSAmount:(NSString *)amount {
    return [NSString stringWithFormat:@"%.2f",[amount doubleValue]];
}
//是否是空字符串 如果是返回yes 否则返回no
+ (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isEqualToString:@"null"]) {
        return YES;
    }
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    return NO;
}
+ (BOOL)checkStringInvalid:(NSString*)param
{
    if ((!param) || ([param isEqual:[NSNull null]]) || ([param isKindOfClass:[NSString class]] == NO) || (0 == param.length) || ([param isEqualToString:@"<null>"]) || ([param isEqualToString:@"(null)"])) {
        return YES;
    }
    
    return NO;
}
+ (BOOL)checkDictionaryInvalid:(id)param
{
    if ([self checkObjectInvalid:param] || [param isKindOfClass:[NSDictionary class]] == NO) {
        return YES;
    }
    
    return NO;
}
+ (BOOL)checkObjectInvalid:(id)param
{
    if ((!param) || ([param isEqual:[NSNull null]])) {
        return YES;
    }
    
    return NO;
}

@end
