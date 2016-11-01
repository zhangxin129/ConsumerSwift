//
//  GYNetApiConfig.h
//  GYRestaurant
//
//  Created by sqm on 16/3/24.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma mark - 新增3.0登录接口
FOUNDATION_EXPORT NSString *const GYHSisRelease;//查询是否生产环境
FOUNDATION_EXPORT NSString *const GYHEFoodOperatorLogin; //登录接口
FOUNDATION_EXPORT NSString *const GYHEFoodGlobalData; //查询全局参数
FOUNDATION_EXPORT NSString *const GYHEFoodOperatorLogout; //登出接口
FOUNDATION_EXPORT NSString *const GYHDCustomerOrderDetail; //互动获取客户订单列表接口
#pragma mark - 功能接口
FOUNDATION_EXPORT NSString *const GYHEFoodAddOrderDetail;
FOUNDATION_EXPORT NSString *const GYHEFoodSubmitOrder; //下单接口
FOUNDATION_EXPORT NSString *const GYHEFoodCheckAccount; //验证互生号／手机号接口
FOUNDATION_EXPORT NSString *const GYHEFoodGetFoodCategoryList; //自定义菜单列表接口
FOUNDATION_EXPORT NSString *const GYHEFoodQueryOrder; //查询订单接口
FOUNDATION_EXPORT NSString *const GYHEFoodQueryEmployeeAccountList; //根据条件查询用户信息接口
FOUNDATION_EXPORT NSString *const GYHEFoodQueryOrderDetail; //查询订单详情
FOUNDATION_EXPORT NSString *const GYHEFoodPostOrder; //送餐接口
FOUNDATION_EXPORT NSString *const GYHEFoodOrderUse; //消费者用餐接口
FOUNDATION_EXPORT NSString *const GYHEFoodDeliverQuery; //查询送餐员接口
FOUNDATION_EXPORT NSString *const GYHEFoodOrderPay; //现金结账接口
FOUNDATION_EXPORT NSString *const GYHEFoodAcceptOrder; //接受订单
FOUNDATION_EXPORT NSString *const GYHEFoodRefuseOrder; //拒绝接单
FOUNDATION_EXPORT NSString *const GYHEFoodDelOrderDetail; //删除菜接口
FOUNDATION_EXPORT NSString *const GYHEFoodSendOrderMessage; //打单接口
FOUNDATION_EXPORT NSString *const GYHEFoodCancelOrderValidate; //消费者取消订单接口
FOUNDATION_EXPORT NSString *const GYHEFoodUpdateOrder; //保存订单接口
FOUNDATION_EXPORT NSString *const GYHEFoodCancelReservations; //企业取消预定
FOUNDATION_EXPORT NSString *const GYHEFoodGetShopList; //营业点接口
FOUNDATION_EXPORT NSString *const GYHEFoodSyncShopFoods; //同步菜品列表接口
FOUNDATION_EXPORT NSString *const GYHEFoodQueryDeliverList; //查询企业用户送餐员列表
FOUNDATION_EXPORT NSString *const GYHEFoodDeleteDeliver; //删除送餐员
FOUNDATION_EXPORT NSString *const GYHEFoodAddDeliver; //添加送餐员
FOUNDATION_EXPORT NSString *const GYHEFoodUpdateDeliver; //修改送餐员
FOUNDATION_EXPORT NSString *const GYHEFoodEmployeeRoleIdIsNull; //查询企业用户roleID为空的列表