//
//  GYQuickPayViewController.h
//  HSCompanyPad
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYBaseViewController.h"
typedef NS_ENUM(NSInteger, QuickPaymentType) {
    QuickPaymentTypeTool = 103, //新增申购工具
    QuickPaymentTypeFee = 100, //缴纳年费
    QuickPaymentTypeBehalf = 4, //兑换互生币
    QuickPaymentTypePersonCardOrder = 5, //兑个性卡下单
    QuickPaymentTypeHSCardPurchase ,
};

@class GYHSToolPayModel;

@interface GYQuickPayViewController : GYBaseViewController

@property (nonatomic, strong) GYHSToolPayModel *model;
@property (nonatomic, assign) QuickPaymentType type;
@property (nonatomic, assign) BOOL isQueryDetailVC;

@end
