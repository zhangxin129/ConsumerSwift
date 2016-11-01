//
//  GYLanguageController.h
//  HSConsumer
//
//  Created by kuser on 16/3/7.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CHINESE @"zh-Hans"
#define Traditonal @"zh-Hant"
#define ENGLISH @"en"

@class GYLanguageController;
@protocol GYLanguageControllerDelegate <NSObject>

- (void)tableViewdidSelected:(NSInteger)index withTitle:(NSString*)title withIcon:(NSString*)icon;

@end
@interface GYLanguageController : GYViewController

@property (nonatomic, weak) id<GYLanguageControllerDelegate> delegate;

@end
