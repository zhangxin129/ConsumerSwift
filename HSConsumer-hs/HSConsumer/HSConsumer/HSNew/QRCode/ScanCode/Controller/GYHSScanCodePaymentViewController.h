//
//  GYHSScanCodePaymentViewController.h
//  HSConsumer
//
//  Created by admin on 16/9/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYViewController.h"
@class GYHSCollectionCodeModel;
@class GYHSQRPayModel;
@class GYHSVoucherModel;

typedef NS_ENUM (NSInteger, GYHSPaymentStatus) {
    GYHSOldPaymentWay = 100,
    GYHSNewPaymentWay,
    GYHSNearPaymentWay
};

@protocol GYHSScanCodePaymentDelegate <NSObject>

@optional

- (void)jumpToExchangeHSB;

- (void)loadMainInterface;

- (void)loadScanCodeInterface;

- (void)jumpToTradeVoucher:(GYHSVoucherModel *)model;

@end

@interface GYHSScanCodePaymentViewController : GYViewController

@property (nonatomic, assign) GYHSPaymentStatus paymentState;
@property (nonatomic, strong) GYHSCollectionCodeModel *codeModel;
@property (nonatomic, strong) GYHSQRPayModel *payModel;
@property (nonatomic, assign) BOOL isNeedInput;
@property (nonatomic, copy) NSString *codeType;
@property (nonatomic, weak) id<GYHSScanCodePaymentDelegate> delegate;

@end
