//
//  GYPayViewController.h
//
//  Created by sqm on 16/8/18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYBaseViewController.h"


@protocol GYPayViewDelegate <NSObject>

- (void)transPassword:(NSString *)password;

@end

@class GYHSToolPayModel;
/**
 *    @业务标题 :平板支付类
 *
 *    @Created :
 *    @Modify  : 1.
 *               2.
 *               3.
 */

typedef NS_ENUM(NSUInteger, GYPaymentServiceType)
{
    GYPaymentServiceTypeToolPurchase,//工具申购
    GYPaymentServiceTypeResourcePurchase,//资源申购
    GYPaymentServiceTypePersonalCard, //个性卡定制
    GYPaymentServiceTypePayAnnualFee, //年费
    GYPaymentServiceTypeExchangeHSCurrency //兑换互生币
};


@interface GYPayViewController: GYBaseViewController

@property (nonatomic, assign) GYPaymentServiceType type;
@property (nonatomic, strong) GYHSToolPayModel *model;
@property (nonatomic, weak) id<GYPayViewDelegate> delegate;
@property (nonatomic, assign) BOOL isQueryDetailVC;

@end
