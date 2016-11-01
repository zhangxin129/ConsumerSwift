//
//  GYLoginEn.h
//  GYRestaurant
//
//  Created by kuser on 15/10/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYEnum.h"
@interface GYLoginEn : NSObject

@property (nonatomic, assign) EMLoginEn loginLine;

SingletonH(Instance)

- (NSString *)getLoginUrl;
- (NSArray *)getDefaultUserPwdIsCardUser:(BOOL)iscardUser;

+ (EMLoginEn)getInitLoginLine;

+ (BOOL)isReleaseEn;//是否为生产发布环境 否：NO 是：YES

@end
