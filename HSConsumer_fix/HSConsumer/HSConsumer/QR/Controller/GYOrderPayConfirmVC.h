//
//  GYOrderPayConfirmVC.h
//  HSConsumer
//
//  Created by sqm on 16/4/19.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYQRPayModel;

typedef NS_ENUM(NSInteger, GYPaymentStatus) {
    GYOldPaymentWay = 100,
    GYNewPaymentWay,
};

@interface GYOrderPayConfirmVC : GYViewController
@property (nonatomic, strong) GYQRPayModel* model;
@property (nonatomic, assign) GYPaymentStatus paymentStatu;
@end
