//
//  GYGlobalData.h
//  GYRestaurant
//
//  Created by apple on 15/10/13.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYNavigationController.h"
#import "GYLoginModel.h"

typedef NS_ENUM(NSUInteger, roleType) {
    roleTypeTrusteeshipCompanySystemAdministrator = 301,  //托管企业系统管理员
    roleTypeTrusteeshipCompanyStoreManger = 302,  //托管企业店铺管理员
    roleTypeTrusteeshipCompanyCashier = 303,  //托管企业收银员
    roleTypeTrusteeshipCompanyWaiter = 304,  //托管企业服务员
    roleTypeTrusteeshipCompanyDeliveryStaff = 305,  //托管企业送餐员
    roleTypeMemberCompanySystemAdministrator = 201,  //成员企业系统管理员
    roleTypeMemberCompanyStoreManger = 202,  //成员企业店铺管理员
    roleTypeMemberCompanyCashier = 203,  //成员企业收银员
    roleTypeMemberCompanyWaiter = 204,  //成员企业服务员
    roleTypeMemberCompanyDeliveryStaff = 205  //成员企业送餐员
    };

@interface GYGlobalData : NSObject
{
    NSTimeInterval nowTimeInterval;
}

SingletonH(Instant)

@property (nonatomic, strong) GYLoginModel *loginModel;
@property (nonatomic, strong)GlobalAttribute *attribute;

#pragma mark - 用户状态
@property (assign, nonatomic) BOOL isLogined;   //用户登录状态；默认为NO
@property (assign, nonatomic) BOOL isHdLogined; //用户动登录状态；默认为NO
@property (assign, nonatomic) roleType currentRole;//当前角色



#pragma mark - 加菜页面用来存储变量的数据 点菜单 以及是否pop（用于是否刷新菜单）
@property (nonatomic, strong) NSMutableArray *takeOrderA;
@property (nonatomic, assign) BOOL pop;

/**
 *  取得系统时间与北京时间的时间差
 *
 *	@param 	isCheck 	是否要再联网检测一次
 *
 *	@return	毫秒的时间差
 */
- (NSTimeInterval)getTimeDifference:(BOOL)isCheck;


@end






