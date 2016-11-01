//
//  GYOrderTakeOutModel.m
//  GYRestaurant
//
//  Created by ios007 on 15/10/21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOrderTakeOutModel.h"

@implementation GYOrderTakeOutModel



//类型判断
-(NSString *)orderType{
    
    NSString *str;
    
    if ([_orderType isEqualToString:@"1"]) {
        
        str = kLocalized(@"Store");
    }else if ([_orderType isEqualToString:@"2"]){
        
        str = kLocalized(@"Takeout");
    }
    
    
    return str;
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

//订单状态判断
-(NSString *)orderStatus{
    
    NSString *str;
    
    if ([_orderStatus isEqualToString:@"1"]||[_orderStatus isEqualToString:@"8"]) {
        
        str = kLocalized(@"Unconfirmed");
    }else if ([_orderStatus isEqualToString:@"2"]){
        
        str = kLocalized(@"PendingDelivery");
        
    }else if ([_orderStatus isEqualToString:@"3"]||[_orderStatus isEqualToString:@"11"]){
        
        str = kLocalized(@"Deliveries");
        
    }else if ([_orderStatus isEqualToString:@"4"]){
        
        str = kLocalized(@"TransactionComplete");
    }else if ([_orderStatus isEqualToString:@"10"]){
        
        str = kLocalized(@"CancelUnconfirmed");
    }else if ([_orderStatus isEqualToString:@"99"]){
        
        str = kLocalized(@"Cancelled");
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

    NSString *payTimeStr;
    if (_payOrderDate.length > 0) {
        payTimeStr = [_payOrderDate substringWithRange:NSMakeRange(5, 11)];
    }
    return payTimeStr;
}

-(NSString *)postDateTimeRange{
    NSString *postTimeStr;
    
    if (_postDateTimeRange.length > 0) {
       
        postTimeStr=[_postDateTimeRange substringWithRange:NSMakeRange(5, 11)];
        
    }
    return postTimeStr;
}

-(NSString *)planTime{
    NSString *plantimeStr;
    if (_planTime.length > 0) {
        plantimeStr =[_planTime substringWithRange:NSMakeRange(5, 11)];
    }
    return plantimeStr;
}

-(NSString *)cancelApplyTime{
    NSString *currentDateStr;
    NSString *str=_cancelApplyTime;
    NSTimeInterval time=[str longLongValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time/1000];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    
    currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

@end
