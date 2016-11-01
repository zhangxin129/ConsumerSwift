//
//  GYAppMacro.h
//  HSConsumer
//
//  Created by zhangqy on 16/2/19.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#ifndef GYAppMacro_h
#define GYAppMacro_h
#import "GYKitConstant.h"

//获得AppDelegate
#define kAppDelegate [[UIApplication sharedApplication] delegate]

//当前APP 默认Bundle

#define kBundleId [[NSBundle mainBundle] bundleIdentifier]

//获取设备宽，高
#define kWindow (((GYAppDelegate*)[UIApplication sharedApplication].delegate).window)

// 国际化
#define kLocalized(key) NSLocalizedString(key, nil)

// 是否iPad
#define kDeviceType (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? ipad : iphone

//获取当前语言
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])


#endif
