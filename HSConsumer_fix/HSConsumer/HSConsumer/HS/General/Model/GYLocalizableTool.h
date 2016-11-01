//
//  GYLocalizableTool.h
//  HSConsumer
//
//  Created by kuser on 16/3/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYLocalizableTool : NSObject

+ (NSBundle*)bundle; //获取当前资源文件

+ (void)initUserLanguage; //初始化语言文件

+ (NSString*)userLanguage; //获取应用当前语言

+ (void)setUserlanguage:(NSString *)language;//设置当前语言

@end
