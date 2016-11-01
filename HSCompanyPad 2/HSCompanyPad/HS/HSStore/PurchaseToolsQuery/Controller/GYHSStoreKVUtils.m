//
//  GYHSStoreKVUtils.m
//  HSCompanyPad
//
//  Created by cook on 16/9/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSStoreKVUtils.h"

#import "GYHSStoreQueryDetailModel.h"
#import "GYHSStoreQueryListModel.h"
#import "GYHSMyPayYearFeeModel.h"


@implementation GYHSStoreKVUtils

+ (NSString *)getOrderChannel:(NSString *)orderChannel
{
    NSString * strChanal = orderChannel;
    if ([orderChannel isEqualToString:@"1"]) {
        strChanal = kLocalized(@"GYHS_HSStore_Query_WebTerminal");
    }else if ([orderChannel isEqualToString:@"2"]){
        strChanal = kLocalized(@"GYHS_HSStore_Query_POSTerminal");
    }else if ([orderChannel isEqualToString:@"3"]){
        strChanal = kLocalized(@"GYHS_HSStore_Query_CreditCardTerminal");
    }else if ([orderChannel isEqualToString:@"4"]){
        strChanal = kLocalized(@"GYHS_HSStore_Query_MobileAppTerminal");
    }else if ([orderChannel isEqualToString:@"5"]){
        strChanal = kLocalized(@"GYHS_HSStore_Query_HSPadTerminal");
    }else if ([orderChannel isEqualToString:@"6"]){
        strChanal = kLocalized(@"GYHS_HSStore_Query_SystemTerminal");
    }else if ([orderChannel isEqualToString:@"7"]){
        strChanal = kLocalized(@"GYHS_HSStore_Query_VoiceTerminal");
    }else if ([orderChannel isEqualToString:@"8"]){
        strChanal = kLocalized(@"GYHS_HSStore_Query_Third-partySystem");
    }
    return strChanal;
}
+ (NSString *)getOrderStatusWithStatus:(NSString *)status
{
    NSString *orderStatus = @"";
    if ([status isEqualToString:@"1"]) {
        orderStatus = kLocalized(@"GYHS_HSStore_Query_Unpaid");
    }else if ([status isEqualToString:@"2"]){
        orderStatus = kLocalized(@"GYHS_HSStore_Query_ToBePicking");
    }else if ([status isEqualToString:@"3"]){
        orderStatus = kLocalized(@"GYHS_HSStore_Query_Completed");
    }else if ([status isEqualToString:@"4"]){
        orderStatus = kLocalized(@"GYHS_HSStore_Query_Expired");
    }else if ([status isEqualToString:@"5"]){
        orderStatus = kLocalized(@"GYHS_HSStore_Query_Closed");
    }else if ([status isEqualToString:@"6"]){
        orderStatus = kLocalized(@"GYHS_HSStore_Query_ToBeConfirmed");
    }else if ([status isEqualToString:@"7"]){
        orderStatus = kLocalized(@"GYHS_HSStore_Query_ItHasWithdrawals");
    }else if ([status isEqualToString:@"8"]){
        orderStatus = kLocalized(@"GYHS_HSStore_Query_PaymentProcessing");
    }else if ([status isEqualToString:@"9"]){
        orderStatus = kLocalized(@"GYHS_HSStore_Query_Shipped");
    }
    return orderStatus;
}

/**
 *  获取支付状态
 *
 *  @param paystate <#paystate description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getPayState:(NSString *)paystate
{
    
    if ([paystate isEqualToString:@"0"]) {
        return kLocalized(@"GYHS_HSStore_Query_Unpaid");
    }
    
    if ([paystate isEqualToString:@"2"]) {
        return kLocalized(@"GYHS_HSStore_Query_Paid");
    }
    
    return @"--";
}
// 获取订单支付方式
+ (NSString *)getOrderPayWay:(NSString *)payWay
{
    
    NSString * orderPayWay = @"";
    if ([payWay isEqualToString:@"100"]) {
        orderPayWay = kLocalized(@"GYHS_HSStore_Query_PayMethodUppay");
    }else if ([payWay isEqualToString:@"101"]){
        orderPayWay = kLocalized(@"GYHS_HSStore_Query_MobilePayment");
    }else if ([payWay isEqualToString:@"102"]){
        orderPayWay = kLocalized(@"GYHS_HSStore_Query_QuickPay");
    }else if ([payWay isEqualToString:@"200"]){
        orderPayWay = kLocalized(@"GYHS_HSStore_Query_HsbToPay");
    }else if ([payWay isEqualToString:@"300"]){
        orderPayWay = kLocalized(@"GYHS_HSStore_Query_MoneyPay");
    }else if ([payWay isEqualToString:@"400"]){
        orderPayWay = kLocalized(@"GYHS_HSStore_Query_OfflinePayments");
    }else if ([payWay isEqualToString:@"120"]){
        orderPayWay = kLocalized(@"GYHS_HSStore_Query_CertificationCardPayment");
    }else if ([payWay isEqualToString:@"110"]){
        orderPayWay = kLocalized(@"GYHS_HSStore_Query_FastCardPayment");
    }else if ([payWay isEqualToString:@"111"]){
        orderPayWay = kLocalized(@"GYHS_HSStore_Query_CommonBankCardPayment");
    }else if ([payWay isEqualToString:@"121"]){
        orderPayWay = kLocalized(@"GYHS_HSStore_Query_OtherBankCardPayment");
    }else{
        orderPayWay = @"--";
    }
    
    return orderPayWay;
}
+ (NSString *)getOrderType:(NSString *)orderType
{
    NSString * orderTypeResult = nil;
    if ([orderType isEqualToString:@"100"]) {
        orderTypeResult = kLocalized(@"GYHS_HSStore_Query_PaySystemUseFee");
    }else if ([orderType isEqualToString:@"101"]){
        orderTypeResult = kLocalized(@"GYHS_HSStore_Query_ResourceFee");
    }else if ([orderType isEqualToString:@"102"]){
        orderTypeResult = kLocalized(@"GYHS_HSStore_Query_SpecailCardFee");
    }else if ([orderType isEqualToString:@"103"]){
        orderTypeResult = kLocalized(@"GYHS_HSStore_Query_AddNewTool");
    }else if ([orderType isEqualToString:@"104"]){
        orderTypeResult = kLocalized(@"GYHS_HSStore_Query_PraviteFillCard");
    }else if ([orderType isEqualToString:@"105"]){
        orderTypeResult = kLocalized(@"GYHS_HSStore_Query_PraviteFillCard");
    }else if ([orderType isEqualToString:@"106"]){
        orderTypeResult = kLocalized(@"GYHS_HSStore_Query_HSRebuyCard");
    }else if ([orderType isEqualToString:@"107"]){
        orderTypeResult = kLocalized(@"GYHS_HSStore_Query_SpecailCardFee");
    }else if ([orderType isEqualToString:@"110"]){
        orderTypeResult = kLocalized(@"GYHS_HSStore_Query_ApplyPersonResource");
    }else if ([orderType isEqualToString:@"109"]){
        orderTypeResult = kLocalized(@"GYHS_HSStore_Query_ToolPuash");
    }
    
    
    return orderTypeResult;
}


+ (NSArray *)getTitleListWithModel:(GYHSStoreQueryDetailModel *)model
{
    NSMutableArray *titleArr = @[].mutableCopy;
    
    if ( [model.orderInfo.orderType isEqualToString:@"109"]) {//申报申购
        titleArr = @[kLocalized(@"GYHS_HSStore_Query_OrderNo"),kLocalized(@"GYHS_HSStore_Query_OrderTime"),kLocalized(@"GYHS_HSStore_Query_OrderType"),kLocalized(@"GYHS_HSStore_Query_SubscriptionType"),kLocalized(@"GYHS_HSStore_Query_TheAmountActuallyPaid"),kLocalized(@"GYHS_HSStore_Query_BillingCurrency"),kLocalized(@"GYHS_HSStore_Query_CurrencyConversionRatio"),kLocalized(@"GYHS_HSStore_Query_EquivalentToTheAmountOfMoney"),kLocalized(@"GYHS_HSStore_Query_PaymentMethod"),kLocalized(@"GYHS_HSStore_Query_OrderStatus"),kLocalized(@"GYHS_HSStore_Query_OrderOperator"),kLocalized(@"GYHS_HSStore_Query_AcceptedWay"),kLocalized(@"GYHS_HSStore_Query_Receiver"),kLocalized(@"GYHS_HSStore_Query_ShippingAddress"),kLocalized(@"GYHS_HSStore_Query_Remark")].mutableCopy;
        
        if ([model.orderInfo.orderPayChanel isEqualToString:GYPayChannelHSBPay] || [model.orderInfo.orderStatus isEqualToString:@"1"]) {
            [titleArr removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(6, 2)]];
            if ([model.orderInfo.orderStatus isEqualToString:@"1"]) {
                [titleArr removeObjectAtIndex:6];
            }
            
        }
        
        
    }else if ([model.orderInfo.orderType isEqualToString:@"104"] ||[model.orderInfo.orderType isEqualToString:@"107"]) {
        titleArr = @[kLocalized(@"GYHS_HSStore_Query_OrderNo"),kLocalized(@"GYHS_HSStore_Query_OrderTime"),kLocalized(@"GYHS_HSStore_Query_OrderType"),kLocalized(@"GYHS_HSStore_Query_TheAmountActuallyPaid"),kLocalized(@"GYHS_HSStore_Query_BillingCurrency"),kLocalized(@"GYHS_HSStore_Query_CurrencyConversionRatio"),kLocalized(@"GYHS_HSStore_Query_EquivalentToTheAmountOfMoney"),kLocalized(@"GYHS_HSStore_Query_PaymentMethod"),kLocalized(@"GYHS_HSStore_Query_OrderStatus"),kLocalized(@"GYHS_HSStore_Query_OrderOperator"),kLocalized(@"GYHS_HSStore_Query_AcceptedWay"),kLocalized(@"GYHS_HSStore_Query_Remark")].mutableCopy;
        
        if ([model.orderInfo.orderPayChanel isEqualToString:GYPayChannelHSBPay] || [model.orderInfo.orderStatus isEqualToString:@"1"]) {
            [titleArr removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(5, 2)]];
            if ([model.orderInfo.orderStatus isEqualToString:@"1"]) {
                [titleArr removeObjectAtIndex:5];
            }
            
        }
        
        
    }else if([model.orderInfo.orderType isEqualToString:@"103"]|| [model.orderInfo.orderType isEqualToString:@"110"]) {
        
        titleArr = @[kLocalized(@"GYHS_HSStore_Query_OrderNo"),kLocalized(@"GYHS_HSStore_Query_OrderTime"),kLocalized(@"GYHS_HSStore_Query_OrderType"),kLocalized(@"GYHS_HSStore_Query_SubscriptionType"),kLocalized(@"GYHS_HSStore_Query_ConsigneeName"),kLocalized(@"GYHS_HSStore_Query_ReceiverPhone"),kLocalized(@"GYHS_HSStore_Query_ShippingAddress"),kLocalized(@"GYHS_HSStore_Query_PaymentMethod"),kLocalized(@"GYHS_HSStore_Query_CurrencyConversionRatio"),kLocalized(@"GYHS_HSStore_Query_EquivalentToTheAmountOfMoney"),kLocalized(@"GYHS_HSStore_Query_OrderStatus"),kLocalized(@"GYHS_HSStore_Query_OrderOperator"),kLocalized(@"GYHS_HSStore_Query_Remark")].mutableCopy;
        if ([model.orderInfo.orderPayChanel isEqualToString:GYPayChannelHSBPay] || [model.orderInfo.orderStatus isEqualToString:@"1"]) {
            [titleArr removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(8, 2)]];
            if ([model.orderInfo.orderStatus isEqualToString:@"1"]) {
                [titleArr removeObjectAtIndex:7];
            }
            
        }
        
    }else if ([model.orderInfo.orderType isEqualToString:@"100"]){
        titleArr = @[kLocalized(@"GYHS_HSStore_Query_OrderNo"),kLocalized(@"GYHS_HSStore_Query_OrderTime"),kLocalized(@"GYHS_HSStore_Query_OrderType"),kLocalized(@"订单金额："),kLocalized(@"缴纳年费区间："),kLocalized(@"GYHS_HSStore_Query_TheAmountActuallyPaid"),kLocalized(@"GYHS_HSStore_Query_BillingCurrency"),kLocalized(@"GYHS_HSStore_Query_PaymentMethod"),kLocalized(@"GYHS_HSStore_Query_OrderStatus"),kLocalized(@"GYHS_HSStore_Query_OrderOperator"),kLocalized(@"GYHS_HSStore_Query_AcceptedWay"),kLocalized(@"GYHS_HSStore_Query_Remark")].mutableCopy;
        
        if ([model.orderInfo.orderPayChanel isEqualToString:GYPayChannelHSBPay] || [model.orderInfo.orderStatus isEqualToString:@"1"]) {
            [titleArr removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(7, 1)]];
        }

    }
    
    return titleArr;
    
}

/**
 *获取详情的value
 */
+ (NSArray *)getValueListWithModel:(GYHSStoreQueryDetailModel *)model listModel:(GYHSStoreQueryListModel *)listModel yearFeeModel:(GYHSMyPayYearFeeModel *)yearFeeModel
{
    
    NSMutableArray *valueArr = @[].mutableCopy;
    NSString *orderType = [self getOrderType:model.orderInfo.orderType];
    if ([model.orderInfo.orderType isEqualToString:@"109"]) {//申购类型
        valueArr = @[model.orderInfo.orderNo,model.orderInfo.orderTime,orderType,kLocalized(@"GYHS_HSStore_Query_DeclarePurchase"),[GYUtils formatCurrencyStyle:model.orderInfo.orderAmount.doubleValue],globalData.config.currencyName,[NSString stringWithFormat:@"%.4f", listModel.exchangeRate.doubleValue],[GYUtils formatCurrencyStyle:listModel.orderCashAmount.doubleValue],[self getOrderPayWay:model.orderInfo.orderPayChanel],[self getOrderStatusWithStatus:model.orderInfo.orderStatus],kSaftToNSString(model.orderInfo.orderOperator),[self getOrderChannel:model.orderInfo.orderChanel],kSaftToNSString(model.deliverInfo.linkman),kSaftToNSString(model.deliverInfo.address),kSaftToNSString(model.orderInfo.orderRemark)].mutableCopy;
        
        
        if ([model.orderInfo.orderPayChanel isEqualToString:GYPayChannelHSBPay] || [model.orderInfo.orderStatus isEqualToString:@"1"]) {
            [valueArr removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(6, 2)]];
            if ([model.orderInfo.orderStatus isEqualToString:@"1"]) {
                [valueArr removeObjectAtIndex:6];
            }
            
        }
        
    }else if ([model.orderInfo.orderType isEqualToString:@"104"] ||[model.orderInfo.orderType isEqualToString:@"107"]) {
        valueArr = @[model.orderInfo.orderNo,model.orderInfo.orderTime,orderType,[GYUtils formatCurrencyStyle:model.orderInfo.orderAmount.doubleValue],globalData.config.currencyName,[NSString stringWithFormat:@"%.4f", listModel.exchangeRate.doubleValue],[GYUtils formatCurrencyStyle:listModel.orderCashAmount.doubleValue],[self getOrderPayWay:model.orderInfo.orderPayChanel],[self getOrderStatusWithStatus:model.orderInfo.orderStatus],model.orderInfo.orderOperator,[self getOrderChannel:model.orderInfo.orderChanel],kSaftToNSString(model.orderInfo.orderRemark)].mutableCopy;
        
        if ([model.orderInfo.orderPayChanel isEqualToString:GYPayChannelHSBPay] || [model.orderInfo.orderStatus isEqualToString:@"1"]) {
            [valueArr removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(5, 2)]];
            if ([model.orderInfo.orderStatus isEqualToString:@"1"]) {
                [valueArr removeObjectAtIndex:5];
            }
            
        }
        
        
    }else if([model.orderInfo.orderType isEqualToString:@"103"] || [model.orderInfo.orderType isEqualToString:@"110"]) {
        
        valueArr = @[model.orderInfo.orderNo,model.orderInfo.orderTime,orderType,kLocalized(@"GYHS_HSStore_Query_NewPurchase"),kSaftToNSString(model.deliverInfo.linkman),kSaftToNSString(model.deliverInfo.phone),kSaftToNSString(model.deliverInfo.address),[self getOrderPayWay:model.orderInfo.orderPayChanel],[NSString stringWithFormat:@"%.4f",kSaftToNSString(listModel.exchangeRate).doubleValue],[GYUtils formatCurrencyStyle: kSaftToNSString(listModel.orderCashAmount).doubleValue],[self getOrderStatusWithStatus:model.orderInfo.orderStatus],kSaftToNSString(model.orderInfo.orderOperator), kSaftToNSString(model.orderInfo.orderRemark)].mutableCopy;
        if ([model.orderInfo.orderPayChanel isEqualToString:GYPayChannelHSBPay] || [model.orderInfo.orderStatus isEqualToString:@"1"]) {
            [valueArr removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(8, 2)]];
            if ([model.orderInfo.orderStatus isEqualToString:@"1"]) {
                [valueArr removeObjectAtIndex:7];
            }
            
        }
    }else if ([model.orderInfo.orderType isEqualToString:@"100"]){
        valueArr = @[model.orderInfo.orderNo,model.orderInfo.orderTime,orderType,[GYUtils formatCurrencyStyle: kSaftToNSString(listModel.orderHsbAmount).doubleValue],[NSString stringWithFormat:@"%@ - %@",yearFeeModel.areaStartDate,yearFeeModel.areaEndDate],[GYUtils formatCurrencyStyle: kSaftToNSString(listModel.orderHsbAmount).doubleValue],globalData.config.currencyName,[self getOrderPayWay:model.orderInfo.orderPayChanel],[self getOrderStatusWithStatus:model.orderInfo.orderStatus],kSaftToNSString(model.orderInfo.orderOperator),[self getOrderChannel:model.orderInfo.orderChanel], kSaftToNSString(model.orderInfo.orderRemark)].mutableCopy;
        if ([model.orderInfo.orderPayChanel isEqualToString:GYPayChannelHSBPay] || [model.orderInfo.orderStatus isEqualToString:@"1"]) {
            [valueArr removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(7, 1)]];
        }

    }
    
    
    return valueArr;
    
    
}
@end
