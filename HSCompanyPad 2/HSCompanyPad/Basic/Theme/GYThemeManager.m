//
//  GYThemeManager.m
//  HSCompanyPad
//
//  Created by User on 16/9/1.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYThemeManager.h"

@interface GYThemeManager ()

//主题名称
@property (nonatomic ,copy)NSString * themeName;
//主题图片字典
@property (nonatomic ,copy)NSDictionary * themeDic;
//主题颜色字典
@property (nonatomic ,copy)NSString * fontColorDic;

@end

@implementation GYThemeManager

+(void)load{

    //默认生成一套缺省主题,包括头部导航栏颜色，以及底部按钮块颜色
    
    
}

//加载主题图片
+(UIImage*)loadThemeImage:(NSString*)imgName{

    return nil;
}


+(NSArray*)loadThemeColor{

    NSString *custId=globalData.loginModel.custId;//企业互生号
    //根据用户id取之前存储过的主题颜色
    NSArray *colorArray = [[NSUserDefaults standardUserDefaults]objectForKey:custId];
    
        return colorArray;
}

//根据用户id保存主题

+(void)saveTheme:(kThemeType)type{

    NSString *custId=globalData.loginModel.custId;//企业互生号
    
    if (type==kThemeTypeDefault) {
        
        //默认主题
        if (custId) {
            [[NSUserDefaults standardUserDefaults]setObject:[GYThemeManager defaultColorArray] forKey:custId];
        }
    }
    
    else if (type == kThemeTypeOther){
       
        if (custId) {
            [[NSUserDefaults standardUserDefaults]setObject:[GYThemeManager otherColorArray] forKey:custId];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
    
   
}

+ (NSArray*)defaultColorArray
{
    NSArray*colorArray = @[@"#2D89EF",
                         @"#653FBF",
                         @"#0959C1",
                         @"#F1BB00",
                         @"#2D89EF",
                         @"#F1BB00",
                         @"#00A500",
                         @"#2D89EF",
                         @"#00A500",
                         @"#0959C1",
                         @"#2D89EF",
                         @"#DB312D",
                         @"#FF7F00" ];
    
    return colorArray;
}

+ (NSArray*)otherColorArray
{
    NSArray*colorArray = @[@"#000000",
                           @"#000000",
                           @"#0000",
                           @"#000000",
                           @"#000000",
                           @"#000000",
                           @"#000000",
                           @"#000000",
                           @"#000000",
                           @"#000000",
                           @"#000000",
                           @"#000000",
                           @"#000000" ];
    
    return colorArray;
}

+(NSString*)defaultMainHeadColorStr{

     return @"#000000";
}

+(BOOL)isThemed{

    if (!globalData.isLogined) {
        
        DDLogInfo(@"没登录，不显示主题");
        
        return NO;
    }
    
    NSString *custId=globalData.loginModel.custId;//企业互生号
    //根据用户id取之前存储过的主题颜色
    NSArray *colorArray = [[NSUserDefaults standardUserDefaults]objectForKey:custId];
    
    if (colorArray&&colorArray.count!=0) {
        
        return YES;
    }
    return NO;
}
@end
