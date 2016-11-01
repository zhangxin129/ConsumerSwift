//
//  EasyPurchaseData.h
//  HSConsumer
//
//  Created by liangzm on 15-2-6.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//轻松购的单例

typedef NS_ENUM(NSInteger, EMOrderState) {
    kOrderStateCancelBySystem = -1, //取消订单
    kOrderStateWaittingPay = 0, //待买家付款
    kOrderStateHasPay = 1, //买家已付款
    kOrderStateWaittingDelivery = 2, //商家备货中
    kOrderStateWaittingConfirmReceiving = 3, //待确认收货
    kOrderStateFinished = 4, //交易成功
    kOrderStateClosed = 5, //交易关闭
    kOrderStateWaittingPickUpCargo = 6, //待自提、已备货待提
    kOrderStateWaittingSellerSendGoods = 7, //待商家送货、商家备货中
    kOrderStateSellerWaittingPayConfirm = 8, //企业待支付确认、待收货
    kOrderStateSellerPreparingGoods = 9, //待备货
    kOrderStateSellerCancelOrder = 10, //已申请取消订单
    kOrderStateCancelPaidOrderByBuyer = 97, //买家退款退货//取消已经支付的订单
    kOrderStateCancelBySeller = 98, //商家取消订单
    kOrderStateCancelByBuyer = 99, //买家已取消
    kOrderStateAll = 1000 //全部订单
};
// /*0 待买家付款*/
//OBLIGATION(0),
///**1 买家已付款*/
//ALREADY_PAID(1),
///**2 待卖家发货*/
//WAIT_SHIPPING(2),
///**3 待确认收货*/
//WAIT_CONFIRM_REC(3),
///**4 交易成功*/
//SUCESS(4),
///**5 交易关闭*/
//CLOSED(5),
///**6 待自提*/
//WAIT_PICK_UP_CARGO(6),
///**7 卖家待送货*/
//WAIT_HOME_DELIVERY(7),
///**8 企业待支付确认*/
//WAIT_PAY_CONFIRM(8),
///**97买家退款退货*/
//BUYER_REFUND(97),
///**98 卖家取消订单*/
//SALER_CANCELD(98),
///**99 买家已取消*/
//BUYER_CANCELD(99),
///**-1 系统取消订单*/
//SYSTEM_CANCELD(-1);*/
//
//
//    /*
//  0 提交申请
//	1 企业不同意
//	2 待企业上门取货
//	3 待买家发货
//	4 待企业收货确认
//	5 退款中
//	6 退/换货结束
//	7 退款失败
//	8 待企业发货-换货
//	10 待企业送货上门-换货
//	-2 未申请
//	-1 取消申请;

//
//     */
typedef NS_ENUM(NSInteger, EMOrderRefundState) { //售后申请记录订单状态
    kOrderRefundStateAppling = 0, //提交申请
    kOrderRefundStateSellerDisAgree = 1, //企业不同意
    kOrderRefundStateWaittingSellerComeReceive = 2, //待企业上门取货
    kOrderRefundStateWaittingBuyersDelivery = 3, //待买家发货
    kOrderRefundStateWaittingSellerConfirmReceiving = 4, //待企业收货确认
    kOrderRefundStateRefunding = 5, //退款中
    kOrderRefundStateRefundSuccess = 6, //退/换货结束
    kOrderRefundStateRefundFaild = 7, //退款失败
    kOrderRefundStateWaittingSellerDeliveryOrChangeGoods = 8, //待企业发货-换货
    kOrderRefundStateWaittingbuyerConfirmReceiving = 9, //待买家确认收货
    kOrderRefundStateWaittingSellerSendGoodsHomeOrChangeGoods = 10, //待企业送货上门-换货
    kOrderRefundStateUnApply = -2, //未申请
    kOrderRefundStateCancelAppling = -1, //取消申请
};

#define kNotificationNameRefreshOrderList @"refreshOrderList_state_"
#define kEasyPurchaseRequestSucceedCode 200 //轻松购请求结果成功的代码
//浏览历史
#define kKeyForBrowsingHistory @"BrowsingHistory"
//经常光顾
#define kKeyForVisitHistory @"visit"
//搜索商品
#define kKeyForsearchHistorygoods @"searchHistorygoods"
//搜索商铺
#define kKeyForsearchHistoryshop @"searchHistoryshop"
#import <Foundation/Foundation.h>

@interface EasyPurchaseData : NSObject

+ (NSString *)getOrderStateString:(EMOrderState)state;
+ (NSString *)getOrderRefundStateString:(EMOrderRefundState)state;

@end
