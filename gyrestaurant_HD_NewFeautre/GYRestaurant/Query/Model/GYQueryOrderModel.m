//
//  GYQueryOrderModel.m
//  GYRestaurant
//
//  Created by apple on 15/10/20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYQueryOrderModel.h"

@implementation GYQueryOrderModel


- (NSString *)orderType{
    
    NSString *str ;
    if ([_orderType  isEqual: @"0"]) {
        str = kLocalized(@"All");
    }else if ([_orderType  isEqual: @"1"]){
        str = kLocalized(@"In-storeDining");
    }else if ([_orderType  isEqual: @"2"]){
        str = kLocalized(@"DeliveryToHome");
    }else if ([_orderType  isEqual: @"3"]){
        str = kLocalized(@"StoresFromMentioning");
    }
    
    return str;
}

-(NSString *)payStatus{
    NSString *str ;
    if ([_orderType isEqualToString:@"2"] || [_orderType isEqualToString:@"3"]) {
        if ([_payStatus  isEqual: @"0"]) {
            str = kLocalized(@"Unpaid");
        }else if ([_payStatus  isEqual: @"1"])
            str = kLocalized(@"AlreadyPaid");
    }else if([_orderType isEqualToString:@"1"]){
        if ([_payStatus  isEqual: @"0"]) {
            str = kLocalized(@"Unpaid");
        }else if ([_payStatus  isEqual: @"1"]){
            if ([_orderType isEqualToString:@"1"]) {
                if (![_orderStatus isEqual:@"4"] ) {
                    str = kLocalized(@"PaiedDeposit");
                }else{
                    str = kLocalized(@"AlreadyPaid");
                }
            }
        }

    
    }
        
    
    return str;

}

-(NSString *)orderStatus{
    NSString *str;
    if ([_orderType isEqual:@"2"]) {
        if ([_orderStatus isEqual:@"1"] || [_orderStatus isEqual:@"8"]) {
            str=kLocalized(@"Unconfirmed");
        }else if ([_orderStatus isEqual:@"2"]){
            str=kLocalized(@"PendingDelivery");
        }else if ([_orderStatus isEqual:@"3"] || [_orderStatus isEqual:@"11"]){
            str=kLocalized(@"Deliveries");
        }else if ([_orderStatus isEqual:@"4"]){
            str=kLocalized(@"TransactionComplete");
        }else if ([_orderStatus isEqual:@"10"]){
            str=kLocalized(@"CancelUnconfirmed");
        }else if ([_orderStatus isEqual:@"99"]){
        
            str=kLocalized(@"Cancelled");
        }
    }else if ([_orderType isEqual:@"1"]){
        if ([_orderStatus isEqual:@"1"] || [_orderStatus isEqual:@"-3"] || [_orderStatus isEqual:@"8"]) {
            str=kLocalized(@"Unconfirmed");
        }else if ([_orderStatus isEqual:@"6"] || [_orderStatus isEqual:@"7"]){
            str=kLocalized(@"ToBeCheckout");
        }else if ([_orderStatus isEqual:@"2"] || [_orderStatus isEqual:@"9"] ){
            str=kLocalized(@"ToBeDining");
        }else if ([_orderStatus isEqual:@"10"]){
            str=kLocalized(@"ConsumersCancel");
        }else if ([_orderStatus isEqual:@"4"]){
            str=kLocalized(@"TransactionComplete");
        }else if ([_orderStatus isEqual:@"99"]){
            
            str=kLocalized(@"Cancelled");
        }

    }else if ([_orderType isEqual:@"3"]){
        if ([_orderStatus isEqual:@"1"] || [_orderStatus isEqual:@"8"] || [_orderStatus isEqual:@"-3"]) {
            str=kLocalized(@"Unconfirmed");
        }else if ([_orderStatus isEqual:@"2"] ){
            str=kLocalized(@"ToBeSelf-created");
        }else if ([_orderStatus isEqual:@"99"]){
            
            str=kLocalized(@"Cancelled");
        }else if ([_orderStatus isEqual:@"4"]){
            
            str=kLocalized(@"TransactionComplete");
        }else if ([_orderStatus isEqual:@"10"]){
            
            str=kLocalized(@"CancelUnconfirmed");
        }

    }

    return str;
}

-(NSString *)orderStartDatetime{
    NSString *startStr;
    if (_orderStartDatetime.length > 0) {
        startStr = [_orderStartDatetime substringWithRange:NSMakeRange(5, 11)];
    }
    return startStr;
}
-(NSString *)payOrderDate{
    NSString *payStr;
    if (_payOrderDate.length > 0) {
        payStr = [_payOrderDate substringWithRange:NSMakeRange(5, 11)];
    }
    return payStr;
}

-(NSString *)checkOutTime{
    NSString *cheackOutTimeStr;
    if (_checkOutTime.length > 0) {
        cheackOutTimeStr = [_checkOutTime substringWithRange:NSMakeRange(5, 11)];
    }
    return cheackOutTimeStr;
}

@end
