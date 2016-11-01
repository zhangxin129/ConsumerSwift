//
//  GYLocalizableTool.m
//  HSConsumer
//
//  Created by kuser on 16/3/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYLocalizableTool.h"
#import "GYLanguageController.h"

@implementation GYLocalizableTool

static NSBundle* bundle = nil;
+ (void)initialize
{
    [super initialize];

    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSString* newString = [def valueForKey:@"userLanguage"];

    if ([newString isEqualToString:@"zh-Hans"]) {

        [GYLocalizableTool setUserlanguage:CHINESE];
        [self initUserLanguage];
    }
    else if ([newString isEqualToString:@"zh-Hant"]) {
        [GYLocalizableTool setUserlanguage:Traditonal];
        [self initUserLanguage];
    }
    else if ([newString isEqualToString:@"en"]) {
        [GYLocalizableTool setUserlanguage:ENGLISH];
        [self initUserLanguage];
    }
    else {
        [GYLocalizableTool setUserlanguage:CHINESE];
        [self initUserLanguage];
    }
}

+ (NSBundle*)bundle
{

    return bundle;
}

+ (void)initUserLanguage
{

    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSString* string = [def valueForKey:@"userLanguage"];
    if (string.length == 0) {
        //获取系统当前语言版本
        NSArray* languages = [def objectForKey:@"AppleLanguages"];
        NSString* current = [languages objectAtIndex:0];

        string = current;
        [def setValue:current forKey:@"userLanguage"];
        [def synchronize]; //持久化，不加的话不会保存
    }

    //获取文件路径
    NSString* path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path]; //生成bundle
}

+ (NSString*)userLanguage
{

    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSString* language = [def valueForKey:@"userLanguage"];
    return language;
}

+ (void)setUserlanguage:(NSString*)language
{

    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];

    //1.第一步改变bundle的值
    NSString* path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];

    //2.持久化
    [def setValue:language forKey:@"userLanguage"];
    [def synchronize];
}

@end
