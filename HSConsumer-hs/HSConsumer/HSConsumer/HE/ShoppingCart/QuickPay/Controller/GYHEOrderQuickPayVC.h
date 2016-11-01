//
//  GYHEOrderQuickPayVC.h
//  HSConsumer
//
//  Created by wangfd on 16/5/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYQRPayModel.h"

typedef NS_ENUM(NSInteger, GYHEOrderQuickPayVCOrderTypeEnum) {
    GYHEOrderQuickPayVCOrderTypeGoods = 1, // 零售
    GYHEOrderQuickPayVCOrderTypeFood = 2,  // 餐饮
    GYHSCashBuyHSBQuickPay,                // 兑换互生币
    GyHEReApplyCardQuickPay,               // 补办互生卡
    GyHSQRPayCardQuickPay                  // 扫码支付
};

@interface GYHEOrderQuickPayVC : GYViewController

@property (nonatomic, strong) NSString* amount;
@property (nonatomic, strong) NSString* orderNO;
@property (nonatomic, assign) GYHEOrderQuickPayVCOrderTypeEnum orderType;
@property (nonatomic, strong) GYQRPayModel* model;

@end
