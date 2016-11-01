//
//  GYHESCPaymentModel.m
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/4/11.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHESCPaymentModel.h"

@implementation GYHESCPaymentModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _orderDetailList = [[NSMutableArray<GYHESCOrderDetailListModel> alloc] init];
    }
    return self;
}

@end

@implementation GYHESCOrderDetailListModel

@end
