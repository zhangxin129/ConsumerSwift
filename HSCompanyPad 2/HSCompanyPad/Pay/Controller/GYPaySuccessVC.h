//
//  GYPaySuccessVC.h
//  HSCompanyPad
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYBaseViewController.h"

typedef NS_ENUM(NSUInteger, GYPaymentType)
{
    GYPaymentTypeToolPurchase,//工具申购
    GYPaymentTypeResourcePurchase,//资源申购
    GYPaymentTypePersonalCard, //个性卡定制
    GYPaymentTypePayAnnualFee, //年费
    GYPaymentTypeExchangeHSCurrency //兑换互生币
};


@interface GYPaySuccessVC : GYBaseViewController

@property (nonatomic, copy) NSString *payStr;

@property (nonatomic, assign) GYPaymentType type;
@property (nonatomic, assign) BOOL isQueryDetailVC;

@end
