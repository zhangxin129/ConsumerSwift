//
//  GYHSScanCodeTradeVoucherViewController.h
//  HSConsumer
//
//  Created by admin on 16/9/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYViewController.h"
@class GYHSVoucherModel;

typedef NS_ENUM (NSInteger, GYHSQRCodeStatus) {
    GYHSScanCodeVoucher = 200,
    GYHSPaymentCodeVoucher,
    GYHSIntegralCodeVoucher
};

@interface GYHSScanCodeTradeVoucherViewController : GYViewController

@property (nonatomic, strong) GYHSVoucherModel *model;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, assign) GYHSQRCodeStatus qrCodeState;
@property (nonatomic, copy) NSString *codeClass;
//@property (nonatomic, copy) NSString *timeDateStr;
//@property (nonatomic, copy) NSString *amountStr;
//@property (nonatomic, copy) NSString *pvNumStr;


@end
