//
//  GlobalData.h
//  HSConsumer
//
//  Created by apple on 14-10-10.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "GYHSUserData.h"
#import "GYPersonInfo.h"
#import "GYHSCustGlobalDataModel.h"
#import "GYHSLoginModel.h"
#import "GYHSLocalInfoModel.h"
#import "GYHSLoginManager.h"
#import "GYHDUserSetingHeaderModel.h"

#define KChangeLocationNotice @"ChangeLocationNotice"

@class GYSlideMenuController;
@interface GlobalData : NSObject

+ (instancetype)shareInstance;

#pragma mark - 基本数据
// 登录互生接口返回数据
@property (nonatomic, strong) GYHSLoginModel* loginModel;

@property (nonatomic, strong) GYHDUserSetingHeaderModel* networkInfoModel;

// 消费者获取全局数据
@property (nonatomic, strong) GYHSCustGlobalDataModel* custGlobalDataModel;

// 获取全平台详细信息
@property (nonatomic, strong) GYHSLocalInfoModel* localInfoModel;

// 强引用主控制器
@property (nonatomic, strong) GYSlideMenuController* viewController;

#pragma mark - 定位相关的全局参数
//定位的经纬度
@property (assign, nonatomic) CLLocationCoordinate2D locationCoordinate;

//定位的城市名
@property (copy, nonatomic) NSString* locationCity;

//定位的地址
@property (copy, nonatomic) NSString* locaitonAddress;

// 手动选择了城市名
@property (nonatomic, copy) NSString* selectedCityName;

// 手动选择了地址
@property (nonatomic, copy) NSString* selectedCityAddress;

// 手动选择了经纬度
@property (nonatomic, copy) NSString* selectedCityCoordinate;

#pragma mark - 网络相关数据
//移动api零售域名
@property (nonatomic, copy) NSString* retailDomain;

//消费者餐饮域名
@property (nonatomic, copy) NSString* foodConsmerDomain;

//图片服务器，只有在餐饮的时候，由店铺请求数据返回，不然要登录完之后返回赋值
@property (nonatomic, copy) NSString* tfsDomain;

// 是否有网络
@property (nonatomic, assign) BOOL isOnNet;

//用户互生登录状态；默认为NO
@property (assign, nonatomic) BOOL isLogined;

//用户动登录状态；默认为NO
@property (assign, nonatomic) BOOL isHdLogined;

#pragma mark - 考虑移除的全局数据
// 用户登录信息
@property (strong, nonatomic) GYHSUserData* user;
@property (nonatomic, strong) GYPersonInfo* personInfo;

// 从本地文件获取的城市信息
@property (strong, nonatomic) NSArray *cityModels;
@property (strong, nonatomic) NSArray *areaModels;
@property (strong, nonatomic) NSArray *locationModels;

//逛商品左侧的菜单index
@property (nonatomic, assign) NSInteger goodsLeftMenuIndex;

//购物车的商品数量
@property (nonatomic, assign) NSInteger goodsNum;

@end
