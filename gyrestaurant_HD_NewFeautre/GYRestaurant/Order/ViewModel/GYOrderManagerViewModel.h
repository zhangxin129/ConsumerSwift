//
//  GYOrderManagerViewModel.h
//  GYRestaurant
//
//  Created by ios007 on 15/10/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "ViewModel.h"

@interface GYOrderManagerViewModel : ViewModel


#pragma mark - 根据条件查询订单列表
-(void)GetOderListWithparams:(NSDictionary *)params;

#pragma mark - 根据条件查询订单列表(外卖)
-(void)GetOderOutWithparams:(NSDictionary *)params;

#pragma mark  - 查询订单详情
- (void)GetOrderDetailWithUserIdId:(NSString *)userId
                           orderId:(NSString *)orderId;

#pragma mark - 接受订单
- (void)acceptOrderWithuserId:(NSString *)userId
                  withOrderId:(NSString*)orderId
                 withIsAccept:(BOOL)isAccept;


#pragma mark - 企业确认 --消费者用餐
-(void)orderInConfirmWithUseId:(NSString *)userId
                         ordId:(NSString *)ordId
                       tableNo:(NSString *)tableNo
                   tableNumber:(NSString *)tableNumber;

#pragma mark - 送餐
-(void)postOrderWithkey:(NSString *)key userId:(NSString *)userId orderId:(NSString *)orderId shopId:(NSString *)shopId expressID:(NSString *)expressID  deliverName:(NSString *)deliverName deliverContact:(NSString *)deliverContact;

#pragma mark - 查询送餐员
-(void)getDeliverList;

#pragma mark - 现金结账
- (void)orderPayWithUserId:(NSString*)userId
               withOrderId:(NSString*)orderId
                 withDic:(NSMutableDictionary*)dic;


#pragma mark - 外卖现金结账
- (void)outOrderPayWithkey:(NSString *)key userId:(NSString*)userId
            orderId:(NSString*)orderId orderType:(NSString *)orderType;

#pragma mark - 店内确认提货
- (void)toGetWithOrderId:(NSString *)orderId userId:(NSString *)userId orderType:(NSString *)orderType;
#pragma mark - 删除菜
- (void)deletelOrderDetailWithUseId:(NSString *)userId
                          ordId:(NSString *)ordId
                             Id:(NSString*)Id;

#pragma mark - 打单
- (void)sendOrderMessageWithParams: (NSDictionary *)paramters;

#pragma mark - 消费取消订单
- (void)cancelOrderValidateWithUserId:(NSString *)userId orderId:(NSString *)orderId;

#pragma mark - 保存订单
- (void)updateOrderWithParams:(NSDictionary*)params;

#pragma mark - 企业取消预定
- (void)cancelReservationswithUserId:(NSString*)userdId withOrderId:(NSString*)orderId withMoneyEarnsetRefund:(NSString*)moneyEarnsetRefund WithRefundType:(NSString*)refundType withCancelReason:(NSString*)cancelReason;

- (void)requestOrdercancelReservationWithUserId:(NSString *)userId withOrder:(NSString*)orderId;
#pragma mark - 企业拒绝接单  
- (void)putRefuseOrderWithUserId:(NSString *)userId withOrderId:(NSString*)orderId withReason:(NSString *)reason;

@end