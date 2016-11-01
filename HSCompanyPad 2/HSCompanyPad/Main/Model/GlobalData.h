//
//  GlobalData.h
//  company
//
//  Created by apple on 14-10-10.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//企业登录权限roleId
typedef NS_ENUM(NSUInteger, companyRoleType) {
    CompanyRoleTypeBigBoss = 11, //系统管理员
    CompanyRoleTypeShopBoss = 0002, //店铺管理员
    CompanyRoleTypeCashier = 0003, //收银员
    CompanyRoleTypeWaiter = 0004, //服务员
    CompanyRoleTypeDeliveryStaff = 0005, //送餐员
    companyRoleTypeRetail = 0011, //只有零售
    companyRoleTypeRetailAndFood = 0012, //零售,餐饮都有
    CompanyRoleTypeTerminalOperator = 0006 //终端操作员
};

//企业互商
typedef NS_ENUM(NSUInteger, CompanyShopType) {
    CompanyShopTypeSale = 1, //零售
    CompanyShopTypeFood = 2, //餐饮
    CompanyShopTypeSaleAndFood = 3, //零售和餐饮
};

//企业类型
typedef NS_ENUM(NSUInteger, CompanyType) {

    kCompanyType_Membercom = 2, //成员企业
    kCompanyType_Trustcom = 3, //托管企业
    kCompanyType_Servicecom = 4, //服务公司
    kCompanyType_Manage = 5, //管理公司
    kCompanyType_Platform = 6, //地区平台
};

#import <Foundation/Foundation.h>
#import "GYLoginModel.h"

 NS_ASSUME_NONNULL_BEGIN
@interface GlobalData : NSObject
/**
 *	构建单例，用于存储全局数据
 *
 *	@return	返回单例
 */
+ (GlobalData*)shareInstance;
@property (nonatomic, strong) GYLoginModel* loginModel; //登录返回的模型数据 网络获取
@property (nonatomic, strong) GYEntGlobalData *config;//配置全局参数
@property (nonatomic, assign) CompanyType companyType;
@property (nonatomic, assign) BOOL isOnNet; //表示是否有网络 暂时没有相关提示的界面 先屏蔽
#pragma mark - 屏幕适配
@property (nonatomic, assign) CGFloat scaleX;
@property (nonatomic, assign) CGFloat scaleY;
@property (nonatomic, strong) companyStatuModel *companyStatus;//企业状态的模型

@property (strong, nonatomic) NSDictionary *dicErrConfig; //错误码配置文件
#pragma mark - 本地纪录用户登录状态
@property (assign, nonatomic) BOOL isLogined;   //用户登录状态；默认为NO
@property (assign, nonatomic) BOOL isHdLogined; //用户动登录状态；默认为NO
@property (assign, nonatomic) BOOL isLocked;
//抵扣券
@property (nonatomic, copy) NSString *couponMax;
@property (nonatomic, copy) NSString *couponAmount;
@property (nonatomic, copy) NSString *couponRate;
- (NSTimeInterval)getTimeDifference:(BOOL)isCheck;
@property (nonatomic, strong) NSTimer * __nullable timer;
@property (nonatomic, copy) NSString *userIp;
@end
NS_ASSUME_NONNULL_END
