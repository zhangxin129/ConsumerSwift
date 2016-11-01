//
//  GYOrderListModel.m
//  GYRestaurant
//
//  Created by ios007 on 15/10/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOrderListModel.h"

@implementation GYOrderListModel

//订单类型
-(NSString *)orderType{
    NSString *str;
    if ([_orderType isEqualToString:@"1"]) {
        str = @"店内就餐";
    }else if ([_orderType isEqualToString:@"2"]){
        
        str = @"送货上门";
    }else if ([_orderType isEqualToString:@"3"]){
        
        str = @"门店自提";
    }
    return str;
    
}

//付款状态判断
-(NSString *)payStatus{
    
    NSString *str;
    if ([_payStatus isEqualToString:@"0"]) {
        str = kLocalized(@"Unpaid");
    }else if([_payStatus isEqualToString:@"1"]){
        str = kLocalized(@"AlreadyPaid");
    }else{
        str = @"";
    }
    return str;
}



//订单状态判断
-(NSString *)orderStatusN{
    
    NSString *str;
    if ([_orderType isEqualToString:@"1"]) {
        if ([_orderStatus isEqualToString:@"1"]||[_orderStatus isEqualToString:@"-3"]) {
            str = kLocalized(@"ToBeConfirmed");
        }else if ([_orderStatus isEqualToString:@"2"]||[_orderStatus isEqualToString:@"9"]){
            str = kLocalized(@"ToBeDining");
        }else if ([_orderStatus isEqualToString:@"6"]||[_orderStatus isEqualToString:@"7"]){
            str = kLocalized(@"ToBeCheckout");
        }else if ([_orderStatus isEqualToString:@"4"]){
            str = kLocalized(@"TransactionComplete");
        }else if ([_orderStatus isEqualToString:@"10"]){
            str = kLocalized(@"CancelUnconfirmed");
        }else if ([_orderStatus isEqualToString:@"99"]){
            str = kLocalized(@"Cancelled");
        }
    }else if([_orderType isEqualToString:@"3"]){
        if ([_orderStatus isEqualToString:@"8"]) {
            str = kLocalized(@"ToBeConfirmed");
        }else if ([_orderStatus isEqualToString:@"2"]){
            str = kLocalized(@"ToBeSelf-created");
        }else if([_orderStatus isEqualToString:@"4"]){
            str = kLocalized(@"TransactionComplete");
        }else if([_orderStatus isEqualToString:@"10"]){
             str = kLocalized(@"CancelUnconfirmed");
        }else if([_orderStatus isEqualToString:@"5"]){
            str = kLocalized(@"Tradingclosed");
        }else if([_orderStatus isEqualToString:@"99"]){
            str = kLocalized(@"Cancelled");
        }
    }else if ([_orderType isEqualToString:@"2"]){
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
            
            str = kLocalized(@"Canceled");
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

-(NSString *)postDateTimeRange{
    NSString *postStr;
    if (_postDateTimeRange.length > 0) {
        postStr = [_postDateTimeRange substringWithRange:NSMakeRange(5, 11)];
    }
    return postStr;
}

-(NSString *)payOrderDate{

    NSString *paidStr;
    if (_payOrderDate.length > 0) {
        paidStr = [_payOrderDate substringWithRange:NSMakeRange(5, 11)];
    }
    return paidStr;
}
-(NSString *)planTime{
    NSString *planTimeStr;
    if (_planTime.length > 0) {
        planTimeStr = [_planTime substringWithRange:NSMakeRange(5, 11)];
    }
    return planTimeStr;
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
