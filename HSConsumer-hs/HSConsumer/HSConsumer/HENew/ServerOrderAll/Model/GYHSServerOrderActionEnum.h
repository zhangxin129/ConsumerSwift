//
//  GYHSServerOrderActionEnum.h
//  HSConsumer
//
//  Created by zhengcx on 16/10/11.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#ifndef GYHSServerOrderActionEnum_h
#define GYHSServerOrderActionEnum_h

typedef NS_ENUM (NSUInteger, URLType){
    kGYOrderGetGoodsInfoURL = 0,//
    kGYOrderDeleteURL = 1,//
    kGYOrderBuyAgainURL = 2,//
    kGYOrderCancelURL = 3,
    kGYRemindDeliverURL = 4,
    kGYDelayDeliverURL = 5,
    kGYConfirmDeliveryURL = 6,
};


#endif /* GYHSServerOrderActionEnum_h */
