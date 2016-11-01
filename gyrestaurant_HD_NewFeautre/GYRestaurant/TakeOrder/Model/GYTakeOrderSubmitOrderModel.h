//
//  GYTakeOrderSubmitOrderModel.h
//  GYRestaurant
//
//  Created by apple on 15/10/22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYTakeOrderSubmitOrderModel : NSObject
@property (nonatomic, copy) NSString *activityAmount;
@property (nonatomic, copy) NSString *actuallyAmount;
@property (nonatomic, copy) NSString *devyActuallyAmount;
@property (nonatomic, copy) NSString *devyOrderIds;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderIds;
@property (nonatomic, copy) NSString *postAge;
@property (nonatomic, copy) NSString *totalAmount;
@property (nonatomic, copy) NSString *totalPoints;
@property (nonatomic, copy) NSString *userId;
@end
