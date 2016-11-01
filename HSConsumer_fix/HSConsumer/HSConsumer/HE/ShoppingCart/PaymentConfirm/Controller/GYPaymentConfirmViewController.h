//
//  GYPaymentConfirmViewController.h
//  HSConsumer
//
//  Created by admin on 16/7/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYViewController.h"

typedef NS_ENUM(NSUInteger, GYPaymentMode) {
    GYPaymentModeWithGoods = 100,//零售
    GYPaymentModeWithFood,//餐饮
    GYPaymentModeWithReApplyCard//补办互生卡
};

@interface GYPaymentConfirmViewController : GYViewController

@property (nonatomic, assign) GYPaymentMode paymentMode;//什么支付
@property (nonatomic, copy) NSString *orderNO;//订单号
@property (nonatomic, copy) NSString *orderMoney;//订单金额
@property (nonatomic, copy) NSString *discount;//抵扣券
@property (nonatomic, copy) NSString *realMoney;//实付金额
@property (nonatomic, copy) NSString *userId;
//@property (nonatomic, copy) NSString *orderType;//是否是餐饮支付
@property (nonatomic, assign) BOOL isFromOrderList;//是否从订单列表传过来的
@end
