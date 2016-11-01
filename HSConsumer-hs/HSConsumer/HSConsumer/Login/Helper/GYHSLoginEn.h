//
//  LoginEn.h
//  HSConsumer
//
//  Created by liangzm on 15-3-25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EMLoginEn) {
    kLoginEn_dev = 0,
    kloginEn_test = 1,
    //电商改版教新的一套测试地址，一般B包含A
    kloginEn_testB,
    kLoginEn_demo,
    kLoginEn_is_preRelease,
    kLoginEn_is_release,
};

@interface GYHSLoginEn : NSObject

@property (nonatomic, assign) EMLoginEn loginLine;

+ (GYHSLoginEn*)sharedInstance;

- (NSString*)getLoginUrl;

//零售接口
- (NSString*)getDefaultRetailDomain;

//餐饮接口
- (NSString*)getFoodConsmerDomain;

// 获取过滤配置的URL
- (NSString*)getFilterUrl;

+ (EMLoginEn)getInitLoginLine;

//是否为生产发布环境 否：NO 是：YES
+ (BOOL)isReleaseEn;

//获取服务器时间配置的URl
- (NSString*)getTimeUrl;

@end
