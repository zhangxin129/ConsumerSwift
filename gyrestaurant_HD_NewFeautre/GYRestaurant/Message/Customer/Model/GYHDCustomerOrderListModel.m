//
//  GYHDCustomerOrderListModel.m
//  GYRestaurant
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDCustomerOrderListModel.h"

@implementation GYHDCustomerOrderListModel
/*
 @property(nonatomic,copy)NSString*vshopname;//营业点id
 @property(nonatomic,copy)NSString*createtime;//下单时间
 @property(nonatomic,copy)NSString*orderstatus;//订单状态
 @property(nonatomic,copy)NSString*userId;//用户id
 @property(nonatomic,copy)NSString*orderid;//订单id
 */
-(void)initModelWithDict:(NSDictionary *)dict{

    self.vshopName=kSaftToNSString(dict[@"shopName"]);
    self.createTime=kSaftToNSString(dict[@"orderStartDatetime"]);
    self.orderStatus= kSaftToNSString(dict[@"orderStatus"]);
    self.userId=kSaftToNSString(dict[@"userId"]) ;
    self.orderId=kSaftToNSString(dict[@"orderId"])  ;
    self.orderType=kSaftToNSString(dict[@"orderType"]) ;

}

//订单类型
-(NSString *)orderTypeStr{
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
        }else if ([_orderStatus isEqualToString:@"5"]){
            str = @"交易关闭";
            
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
            
        }else if ([_orderStatus isEqualToString:@"5"]){
            str = @"交易关闭";
            
        }else if ([_orderStatus isEqualToString:@"99"]){
            
            str = kLocalized(@"Canceled");
        }
    }
    return str;
}


@end
