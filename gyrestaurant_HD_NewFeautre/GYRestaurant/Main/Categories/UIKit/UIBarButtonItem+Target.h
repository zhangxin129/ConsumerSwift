//
//  UIBarButtonItem+Target.h
//  GYCompany
//
//  Created by cook on 15/9/19.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Target)
+ (instancetype)itemWithTarget: (id) target  action: (SEL)action normalImageName: (NSString *)normalImageName highlightedImageName:(NSString *)highlightImageName ;


+ (instancetype)itemWithTarget: (id) target  action: (SEL)action normalTitle: (NSString *)normalTitle highlightedTitle:(NSString *)highlightTitle;

@end
