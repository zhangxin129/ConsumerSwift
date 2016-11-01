//
//  EasyPurchaseData.m
//  HSConsumer
//
//  Created by liangzm on 15-2-6.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "EasyPurchaseData.h"

@implementation EasyPurchaseData

+ (NSString*)getOrderStateString:(EMOrderState)state
{

    //    kOrderStateCancelBySystem = -1,//系统取消订单
    //    kOrderStateWaittingPay = 0, //待买家付款
    //    kOrderStateHasPay = 1,      //买家已付款
    //    kOrderStateWaittingDelivery = 2,        //商家备货中
    //    kOrderStateWaittingConfirmReceiving = 3,//待确认收货
    //    kOrderStateFinished = 4,//交易成功
    //    kOrderStateClosed = 5,  //交易关闭
    //    kOrderStateWaittingPickUpCargo = 6, //待自提、已备货待提
    //    kOrderStateWaittingSellerSendGoods = 7, //待商家送货、商家备货中
    //    kOrderStateSellerWaittingPayConfirm = 8, //企业待支付确认、待收货
    //    kOrderStateSellerPreparingGoods = 9, //待备货
    //    kOrderStateSellerCancelOrder = 10, //已申请取消订单
    //    kOrderStateCancelPaidOrderByBuyer = 97,//买家退款退货//取消已经支付的订单
    //    kOrderStateCancelBySeller = 98,//商家取消订单
    //    kOrderStateCancelByBuyer = 99,//买家已取消
    //    kOrderStateAll = 1000       //全部订单

    switch (state) {
    case kOrderStateCancelBySystem:
        // 改为订单取消
        return kLocalized(@"GYHE_SurroundVisit_AlreadyCancel");
        break;

    case kOrderStateWaittingPay:
        return kLocalized(@"GYHE_SurroundVisit_NoPay");
        //            return kLocalized(@"待买家付款");

        break;

    case kOrderStateHasPay:
        return kLocalized(@"GYHE_SurroundVisit_AlreadyPay");
        //            return kLocalized(@"买家已付款");

        break;

    case kOrderStateWaittingDelivery:
        return kLocalized(@"GYHE_SurroundVisit_BusinessesStocking");

        break;

    case kOrderStateWaittingConfirmReceiving:
        return kLocalized(@"GYHE_SurroundVisit_WaitConfirmReceiveGoods");
        //            return kLocalized(@"待确认收货");

        break;

    case kOrderStateFinished:
        return kLocalized(@"GYHE_SurroundVisit_TransactionSucess");

        break;

    case kOrderStateClosed:
        return kLocalized(@"GYHE_SurroundVisit_ClosedTransaction");
        break;

    case kOrderStateWaittingPickUpCargo:
        return kLocalized(@"GYHE_SurroundVisit_HaveGoodsReadyForTake");
        break;

    case kOrderStateWaittingSellerSendGoods:
        return kLocalized(@"GYHE_SurroundVisit_BusinessesStocking");
        break;

    case kOrderStateCancelBySeller:
        // 改为订单取消
        return kLocalized(@"GYHE_SurroundVisit_AlreadyCancel");
        break;

    case kOrderStateCancelPaidOrderByBuyer:
        return kLocalized(@"GYHE_SurroundVisit_BuyerRefundAndGoods");
        break;

    case kOrderStateSellerWaittingPayConfirm:
        return kLocalized(@"GYHE_SurroundVisit_WaitReceiveGoods"); //待商家确认支付//企业待支付确认
        break;

    case kOrderStateSellerPreparingGoods:
        return kLocalized(@"GYHE_SurroundVisit_BeReady"); //待商家确认支付//企业待支付确认
        break;

    case kOrderStateSellerCancelOrder:
        return kLocalized(@"GYHE_SurroundVisit_AlreadyApplyCancel"); //待商家确认支付//企业待支付确认
        break;

    case kOrderStateCancelByBuyer:
        // 改为订单取消
        return kLocalized(@"GYHE_SurroundVisit_AlreadyCancel"); //消费者取消订单
        break;

    default:
        break;
    }
    return kLocalized(@"GYHE_SurroundVisit_StatusUnknown");
}

+ (NSString*)getOrderRefundStateString:(EMOrderRefundState)state
{
    switch (state) {
    case kOrderRefundStateAppling:
        return kLocalized(@"GYHE_SurroundVisit_CommitApply");
        break;

    case kOrderRefundStateSellerDisAgree:
        return kLocalized(@"GYHE_SurroundVisit_CompaniesNoAgree");
        break;

    case kOrderRefundStateWaittingSellerComeReceive:
        return kLocalized(@"GYHE_SurroundVisit_PickUpBusiness");
        break;

    case kOrderRefundStateWaittingBuyersDelivery:
        return kLocalized(@"GYHE_SurroundVisit_WaitSendGood");
        break;

    case kOrderRefundStateWaittingSellerConfirmReceiving:
        return kLocalized(@"GYHE_SurroundVisit_WaitCompanyReceiveConfirm");
        break;

    case kOrderRefundStateRefunding:
        return kLocalized(@"GYHE_SurroundVisit_RefundMoneying");
        break;

    case kOrderRefundStateRefundSuccess:
        return kLocalized(@"GYHE_SurroundVisit_AlreadyComplete");
        break;

    case kOrderRefundStateRefundFaild:
        return kLocalized(@"GYHE_SurroundVisit_RefundMoneyFaild");
        break;

    case kOrderRefundStateWaittingSellerDeliveryOrChangeGoods:
        return kLocalized(@"GYHE_SurroundVisit_WaitCompaniesSendGoods");
        break;

    case kOrderRefundStateWaittingbuyerConfirmReceiving:
        return kLocalized(@"GYHE_SurroundVisit_WaitConfirmReceiveGoods");
        break;

    case kOrderRefundStateWaittingSellerSendGoodsHomeOrChangeGoods:
        return kLocalized(@"GYHE_SurroundVisit_WaitCompanySendGoodsToHome");
        break;

    case kOrderRefundStateUnApply:
        return kLocalized(@"GYHE_SurroundVisit_NoApply");
        break;

    case kOrderRefundStateCancelAppling:
        return kLocalized(@"GYHE_SurroundVisit_CancelApply");
        break;

    default:
        break;
    }
    return kLocalized(@"GYHE_SurroundVisit_StatusUnknown");
}

@end
