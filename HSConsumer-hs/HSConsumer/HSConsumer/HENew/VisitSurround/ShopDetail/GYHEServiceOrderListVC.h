//
//  GYHEServiceOrderListVC.h
//  HSConsumer
//
//  Created by 吴文超 on 16/10/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//服务订单列表 提交订单界面
/**
 *    @业务标题 : 服务订单列表
 *
 *    @Created : 吴文超
 *    @Modify  : 1.从商品服务信息中 免费预约预订按钮点击进入 暂时设置多个参数 将多个界面整合到一起
 *               2.
 *               3.
 */
#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, ServiceOrFoodType)
{
    kServiceOrderType = 1, //服务订单
    kFoodOrderType  = 2, //餐品服务
};

typedef NS_ENUM (NSUInteger, FreeOrderOrPayImmediatelyType)
{
    kFreeOrderType = 1, //免费预约
    kPayImmediatelyType  = 2, //先实际付款
};

@interface GYHEServiceOrderListVC : GYViewController
@property (nonatomic, assign) ServiceOrFoodType serviceOrFoodType;
@property (nonatomic, assign) FreeOrderOrPayImmediatelyType freeOrPayImmediatelyType;
@property (nonatomic, assign) BOOL hasAbilityTakeHSCard; //判断赠卡的条件
@property (nonatomic, assign) BOOL hasValidAddress;  //存在有效地址

@property (nonatomic, assign) BOOL isOnlyPayOnline; //仅仅在线支付
@end
