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

typedef NS_ENUM(NSInteger, EMLoginEn) {
    kLoginEn_dev = 0, //开发环境带默认账号
    kLoginEn_testA, //测试环境带默认账号
    kLoginEn_testB,//重构环境
    kLoginEn_test_realPay, //测试环境带默认账号(真实网银支付)
    kLoginEn_demo, //演示环境不带账号
    kLoginEn_preRelease, //预生产环境
    kLoginEn_release, //生产环境
};

#import <Foundation/Foundation.h>

@interface GYLoginEn : NSObject

@property (nonatomic, assign) EMLoginEn loginLine;
+ (GYLoginEn*)sharedInstance;
/**
 *  获取重构项目
 *
 *  @return 接口
 */
- (NSString*)getReconsitution;
- (NSString*)getLoginUrl;
- (NSArray*)getDefaultUserPwdIsCardUser:(BOOL)iscardUser;
//默认电商的
- (NSString*)getDefaultRetailDomain;
//默认餐饮域名的
- (NSString*)getFoodConsmerDomain;

+ (EMLoginEn)getInitLoginLine;

-  (NSString *)getFilterUrl;

+ (BOOL)isReleaseEn;//是否为生产发布环境 否：NO 是：YES

@end
