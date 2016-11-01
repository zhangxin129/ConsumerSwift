//
//  GYThemeManager.h
//  HSCompanyPad
//
//  Created by User on 16/9/1.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, kThemeType) {
    kThemeTypeDefault = 0, //
    //
    //
    kThemeTypeOther
};

@interface GYThemeManager : NSObject

//是否设置过主题
+(BOOL)isThemed;

+(NSArray*)loadThemeColor;

+(void)saveTheme:(kThemeType)type;

@end

