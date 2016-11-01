//
//  GYNetApiConfig.m
//  GYRestaurant
//
//  Created by sqm on 16/3/24.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYNetApiConfig.h"

NSString *const GYHSisRelease = @"/common/isRelease";//查询是否生产环境
NSString *const GYHEFoodOperatorLogin = @"/recompany/operatorLogin"; //登录接口
NSString *const GYHEFoodGlobalData = @"/common/globalData"; //查询全局参数
NSString *const GYHEFoodOperatorLogout = @"/recompany/operatorLogout"; //登出接口
NSString *const GYHEFoodQueryOrder = @"/order/queryOrder"; //查询订单接口
NSString *const GYHDCustomerOrderDetail = @"/order/getCustomerOrder"; //互动获取客户订单列表接口
NSString *const GYHEFoodAddOrderDetail = @"/order/addOrderDetail";
NSString *const GYHEFoodSubmitOrder = @"/order/submitOrder"; //下单接口
NSString *const GYHEFoodCheckAccount = @"/userc/checkAccount"; //验证互生号／手机号接口
NSString *const GYHEFoodGetFoodCategoryList = @"/shops/getFoodCategoryList"; //自定义菜单列表接口
NSString *const GYHEFoodQueryEmployeeAccountList = @"/userc/queryEmployeeAccountList"; //根据条件查询用户信息接口
NSString *const GYHEFoodQueryOrderDetail = @"/order/queryOrderDetail"; //查询订单详情
NSString *const GYHEFoodPostOrder = @"/order/postOrder"; //送餐接口
NSString *const GYHEFoodOrderUse = @"/order/orderUse"; //消费者用餐接口
NSString *const GYHEFoodDeliverQuery = @"/order/deliverQuery"; //查询送餐员接口
NSString *const GYHEFoodOrderPay = @"/order/orderPay"; //现金结账接口
NSString *const GYHEFoodAcceptOrder = @"/order/acceptOrder"; //接受订单
NSString *const GYHEFoodRefuseOrder = @"/order/refuseOrder"; //拒绝接单
NSString *const GYHEFoodDelOrderDetail = @"/order/delOrderDetail"; //删除菜接口
NSString *const GYHEFoodSendOrderMessage = @"/order/sendOrderMessage"; //打单接口
NSString *const GYHEFoodCancelOrderValidate = @"/order/cancelOrderValidate"; //消费者取消订单接口
NSString *const GYHEFoodUpdateOrder = @"/order/updateOrder"; //保存订单接口
NSString *const GYHEFoodCancelReservations = @"/order/cancelReservations"; //企业取消预定
NSString *const GYHEFoodGetShopList = @"/shops/getShopList"; //营业点接口
NSString *const GYHEFoodSyncShopFoods = @"/shops/syncShopFoods"; //同步菜品列表接口
NSString *const GYHEFoodQueryDeliverList = @"/userc/queryDeliverList"; //查询企业用户送餐员列表
NSString *const GYHEFoodDeleteDeliver = @"/userc/deleteDeliver"; //删除送餐员
NSString *const GYHEFoodAddDeliver = @"/userc/addDeliver"; //添加送餐员
NSString *const GYHEFoodUpdateDeliver = @"/userc/updateDeliver"; //修改送餐员
NSString *const GYHEFoodEmployeeRoleIdIsNull = @"/userc/employeeRoleIdIsNull"; //查询企业用户roleID为空的列表
