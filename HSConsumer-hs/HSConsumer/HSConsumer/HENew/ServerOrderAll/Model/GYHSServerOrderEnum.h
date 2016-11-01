//
//  GYHSServerOrderEnum.h
//  HSConsumer
//
//  Created by zhengcx on 16/10/11.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#ifndef GYHSServerOrderEnum_h
#define GYHSServerOrderEnum_h

typedef NS_ENUM (NSInteger, EMServerOrderRefundState) {// 售后申请记录订单状态
    
    kServerOrderRefundStateAppling = 0,//提交申请
    kServerOrderRefundStateSellerDisAgree = 1,//企业不同意
    kServerOrderRefundStateWaittingSellerComeReceive = 2,//待企业上门取货
    kServerOrderRefundStateWaittingBuyersDelivery = 3,//待买家发货
    kServerOrderRefundStateWaittingSellerConfirmReceiving = 4,//待企业收货确认
    kServerOrderRefundStateRefunding = 5,//退款中
    kServerOrderRefundStateRefundSuccess = 6,//退/换货结束
    kServerOrderRefundStateRefundFaild = 7,//退款失败
    kServerOrderRefundStateWaittingSellerDeliveryOrChangeGoods = 8,//待企业发货-换货
    kServerOrderRefundStateWaittingbuyerConfirmReceiving = 9,//待买家确认收货
    kServerOrderRefundStateWaittingSellerSendGoodsHomeOrChangeGoods = 10,//待企业送货上门-换货
    kServerOrderRefundStateUnApply = -2,//未申请
    kServerOrderRefundStateCancelAppling = -1,//取消申请
};


typedef NS_ENUM (NSInteger, EMServerOrderState) {
    
    kServerOrderStateCancelBySystem = -1,//取消订单
    kServerOrderStateWaittingPay = 0, //待买家付款
    kServerOrderStateHasPay = 1,      //买家已付款
    kServerOrderStateWaittingDelivery = 2,        //商家备货中
    kServerOrderStateWaittingConfirmReceiving = 3,//待确认收货
    kServerOrderStateFinished = 4,//交易成功
    kServerOrderStateClosed = 5,  //交易关闭
    kServerOrderStateWaittingPickUpCargo = 6, //待自提、已备货待提
    kServerOrderStateWaittingSellerSendGoods = 7, //待商家送货、商家备货中
    kServerOrderStateSellerWaittingPayConfirm = 8, //企业待支付确认、待收货
    kServerOrderStateSellerPreparingGoods = 9, //待备货
    kServerOrderStateSellerCancelOrder = 10, //已申请取消订单
    kServerOrderStateCancelPaidOrderByBuyer = 97,//买家退款退货//取消已经支付的订单
    kServerOrderStateCancelBySeller = 98,//商家取消订单
    kServerOrderStateCancelByBuyer = 99,//买家已取消
    kServerOrderStateAll = 1000       //全部订单
};


#endif /* GYHSServerOrderEnum_h */
