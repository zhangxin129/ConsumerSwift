//
//  GYBaseNavController.m
//  HSCompanyPad
//
//  Created by User on 16/7/25.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYBaseNavController.h"

@interface GYBaseNavController ()

@end

@implementation GYBaseNavController

+ (void)initialize
{
    [super initialize];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //设置Navigation颜色
    [[UINavigationBar appearance] setBarTintColor:kBlue0A59C2];
    [[UINavigationBar appearance] setBackgroundColor:kClearColor];
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    kNavigationTitleColor, NSForegroundColorAttributeName,
                                    kNavigationTitleColor, NSBackgroundColorAttributeName,
                                    kFont36, NSFontAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    
    

}



@end
