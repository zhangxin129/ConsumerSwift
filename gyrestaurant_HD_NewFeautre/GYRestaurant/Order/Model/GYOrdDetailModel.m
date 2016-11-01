//
//  GYOrdDetailModel.m
//  GYRestaurant
//
//  Created by ios007 on 15/10/21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOrdDetailModel.h"
#import "FoodListInModel.h"
#import "GYDeliverCountModel.h"



@implementation GYOrdDetailModel

+(NSDictionary *)objectClassInArray{
    return @{@"foodList":@"FoodListInModel"};
}

//付款状态判断
-(NSString *)payStatus{
    
    NSString *str;
    if ([_payStatus isEqualToString:@"0"]) {
        
        str = kLocalized(@"Unpaid");
    }else if ([_payStatus isEqualToString:@"1"]){
        
        str = kLocalized(@"AlreadyPaid");
    }
    
    return str;
}

//类型判断
-(NSString *)orderType{
    
    NSString *str;
    
    if ([_orderType isEqualToString:@"1"]) {
        
        str = kLocalized(@"Store");
    }else if ([_orderType isEqualToString:@"2"]){
        
        str = kLocalized(@"Takeout");
    }else if ([_orderType isEqualToString:@"3"]){
        
        str = kLocalized(@"Pickup");
      
    }
    
    
    return str;
}
//订单状态判断
-(NSString *)orderStatus{
    
    NSString *str;
    if ([_orderType isEqualToString:@"1"]) {
        if ([_orderStatus isEqualToString:@"1"]||[_orderStatus isEqualToString:@"-3"]){
            str = kLocalized(@"ToBeConfirmed");
        }else if ([_orderStatus isEqualToString:@"2"]||[_orderStatus isEqualToString:@"9"]){
            str = kLocalized(@"ToBeDining");
        }else if ([_orderStatus isEqualToString:@"6"]){
            str = kLocalized(@"Tobeclosing,nottoplayasingle");
        }else if ([_orderStatus isEqualToString:@"7"]){
            str = kLocalized(@"Untilcheckout,ithastoplayasingle");
        }else if ([_orderStatus isEqualToString:@"4"]){
            str = kLocalized(@"AlreadyCheckout");
        }else if ([_orderStatus isEqualToString:@"10"]){
            str = kLocalized(@"ConsumersCancel");
        }else if([_orderStatus isEqualToString:@"99"]){
            str = kLocalized(@"Cancelled");
        }
        
    }else if ([_orderType isEqualToString:@"2"]){
        if([_orderStatus isEqualToString:@"1"]||[_orderStatus isEqualToString:@"8"]){
            str = kLocalized(@"Unconfirmed");
        }else if ([_orderStatus isEqualToString:@"2"]){
            str = kLocalized(@"PendingDelivery");
        }else if ([_orderStatus isEqualToString:@"3"]||[_orderStatus isEqualToString:@"11"]){
            str = kLocalized(@"Deliveries");
        }else if ([_orderStatus isEqualToString:@"4"]){
            str = kLocalized(@"TransactionComplete");
        }else if ([_orderStatus isEqualToString:@"10"]){
            str = kLocalized(@"CancelUnconfirmed");
        }else if([_orderStatus isEqualToString:@"99"]){
            str = kLocalized(@"Cancelled");
        }
        
    }else if ([_orderType isEqualToString:@"3"]){
        if([_orderStatus isEqualToString:@"1"]||[_orderStatus isEqualToString:@"8"]){
            str = kLocalized(@"PendingOrders");
        }else if ([_orderStatus isEqualToString:@"2"]){
            str = kLocalized(@"ToBeSelf-created");
        }else if ([_orderStatus isEqualToString:@"4"]){
            str = kLocalized(@"AlreadyCheckout");
        }else if ([_orderStatus isEqualToString:@"10"]){
            str = kLocalized(@"CancelUnconfirmed");
        }else if([_orderStatus isEqualToString:@"99"]){
            str = kLocalized(@"Cancelled");
        }
        
    }
    return str;
}

-(NSString *)prePayAmount{
    NSString *str;
    if (![_prePayAmount isEqualToString:@""]) {
        str = _prePayAmount;
    }else{
        str = @"0.00";
    }
    return str;
}

-(NSString *)orderStartTime{
    NSString *startStr;
    if (_orderStartTime.length > 0) {
        startStr = [_orderStartTime substringToIndex:16];
    }
    return startStr;
}
-(NSString *)payedTime{
    NSString *paidStr;
    if (_payedTime.length > 0) {
        paidStr = [_payedTime substringToIndex:16];
    }
    return paidStr;
}
-(NSString *)mealTime{
    NSString *mealStr;
    if (_mealTime.length > 16) {
        mealStr = [_mealTime substringToIndex:16];
    }else{
        mealStr = _mealTime;
    }
    return mealStr;
}



@end
