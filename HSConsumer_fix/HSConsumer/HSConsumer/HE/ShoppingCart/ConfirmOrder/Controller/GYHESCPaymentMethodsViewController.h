//
//  GYHESCPaymentMethodsViewController.h
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHESCPaymentMethodModel.h"

typedef void (^paymentBlock)(GYHESCPaymentMethodModel* model);

@interface GYHESCPaymentMethodsViewController : GYViewController

@property (nonatomic, copy) NSString* shopIds;
@property (nonatomic, copy) NSString* isDelivery; //是否快递支付，1为是，0为否
@property (nonatomic, strong) paymentBlock paymentBlock;

@end
