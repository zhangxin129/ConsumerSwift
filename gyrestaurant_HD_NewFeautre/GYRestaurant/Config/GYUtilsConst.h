//
//  GYUtilsConst.h
//  company
//
//  Created by sqm on 16/3/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 系统常量配置
FOUNDATION_EXPORT NSString *const GYChannelType;

#define kBackFont 28
#define kRedFontColor [UIColor colorWithRed:230/255.0f green:33/255.0f blue:41/255.0f alpha:1.0f]
#define kBlueFontColor [UIColor colorWithRed:0/255.0f green:160/255.0f blue:255/255.0f alpha:1.0f]
#define kDeepBlueFontColor [UIColor colorWithRed:0/255.0f green:67/255.0f blue:149/255.0f alpha:1.0f]

//将NSDecimalNumber类型的数据结果保留小数点后两位
#define kRoundUp [NSDecimalNumberHandler                                       decimalNumberHandlerWithRoundingMode:NSRoundPlain                                                                      scale:2                                                           raiseOnExactness:YES                                                            raiseOnOverflow:YES                                                           raiseOnUnderflow:YES                                                        raiseOnDivideByZero:YES]

//默认控制器的背景色
#define kDefaultVCBackgroundColor kRGBA(240, 240, 240, 1)

//导航栏颜色
#define kNavigationBarColor kRGBA(0, 160, 223, 1)//
