//
//  GYOrderManagerViewModel.m
//  GYRestaurant
//
//  Created by ios007 on 15/10/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOrderManagerViewModel.h"
#import "GYOrderListModel.h"
#import "GYOrdDetailModel.h"
#import "NSObject+HXAddtions.h"
#import "GYPostDataModel.h"
#import "GYGIFHUD.h"
#import "GYOrderTakeOutModel.h"

@implementation GYOrderManagerViewModel

#pragma mark -- 根据条件查询订单列表
-(void)GetOderListWithparams:(NSDictionary *)params{
    

    
    NSString *paramsStr = [NSObject jsonStringWithDictionary:params];
    
    NSDictionary *paramter = @{@"key":globalData.loginModel.token,@"params":paramsStr};
    
   
    
    [Network GET:GY_FOODOMAINAPP(GYHEFoodQueryOrder) parameter:paramter success:^(id returnValue) {
       
        self.returnBlock(returnValue);
        
        
    }  failure:^(id error){
        [self error:error];
        
       
        [GYGIFHUD dismiss];
      
    }];
    
}



#pragma mark - 查询订单详情
- (void)GetOrderDetailWithUserIdId:(NSString *)userId
                           orderId:(NSString *)orderId{
    NSDictionary *paramter = @{@"key":globalData.loginModel.token,@"userId": userId,@"orderId":orderId};
    [Network GET:GY_FOODOMAINAPP(GYHEFoodQueryOrderDetail) parameter:paramter success:^(id returnValue) {
        
        NSMutableArray *orderArr=[[NSMutableArray alloc] init];
        id arr = returnValue[@"data"];
        if ([arr isKindOfClass:[NSNull class]]) {
            [GYGIFHUD dismiss];
            
        }else if([arr isKindOfClass:[NSDictionary class]]){
        
        NSDictionary *dataDic = returnValue[@"data"];
        
        
        GYOrdDetailModel *orderModel=[GYOrdDetailModel mj_objectWithKeyValues:dataDic];
        
        [orderArr addObject:orderModel];
            self.returnBlock(orderArr);
        }
        
        
        
        
    } failure:^(id error){
        [self error:error];
        
    }];
    
    
}
#pragma mark - 根据条件查询订单列表(外卖)
-(void)GetOderOutWithparams:(NSDictionary *)params{
    
    NSString *paramsStr = [NSObject jsonStringWithDictionary:params];
    
    NSDictionary *paramter = @{@"key":globalData.loginModel.token,@"params":paramsStr};
    
   
    
    [Network GET:GY_FOODOMAINAPP(GYHEFoodQueryOrder) parameter:paramter success:^(id returnValue) {
        NSMutableArray *orderArr=[[NSMutableArray alloc] init];
        id arr = returnValue[@"data"];
        if ([arr isKindOfClass:[NSNull class]]) {
            
            [GYGIFHUD dismiss];
            
        }else if([arr isKindOfClass:[NSArray class]]){
            
            for(NSDictionary *dataDic in returnValue[@"data"]){
                GYOrderListModel *orderOutModel=[GYOrderListModel mj_objectWithKeyValues:dataDic];
                
                [orderArr addObject:orderOutModel];
            }}
        
        self.returnBlock(orderArr);
        
        
    } failure:^(id error){
        [self error:error];
        
       
      
        
    }];
 
    

}

#pragma mark - 接受订单
- (void)acceptOrderWithuserId:(NSString *)userId
                  withOrderId:(NSString*)orderId withIsAccept:(BOOL)isAccept {
    NSString *url;
    if (isAccept) {
        url = GY_FOODOMAINAPP(GYHEFoodAcceptOrder);
    }else{
        url = GY_FOODOMAINAPP(GYHEFoodRefuseOrder);
    }
    NSDictionary *parameter = @{@"key":globalData.loginModel.token,
                                @"userId":userId,
                                @"orderId":orderId};
    [Network PUT:url parameter:parameter success:^(id returnValue) {
        self.returnBlock(returnValue);
    } failure:^(id error){
        [self error:error];
       
    }];
    
}

#pragma mark - 送餐
-(void)postOrderWithkey:(NSString *)key userId:(NSString *)userId orderId:(NSString *)orderId shopId:(NSString *)shopId expressID:(NSString *)expressID deliverName:(NSString *)deliverName deliverContact:(NSString *)deliverContact{
    
    NSDictionary *parameter = @{@"key":key,
                                @"userId":userId,
                                @"orderId":orderId,
                                @"expressID":expressID,
                                @"deliverName":deliverName,
                                @"deliverContact":deliverContact,
                                @"shopId":shopId};
    
    [Network PUT:GY_FOODOMAINAPP(GYHEFoodPostOrder) parameter:parameter success:^(id returnValue) {
        self.returnBlock(returnValue);
    } failure:^(id error){
        [self error:error];
       
    }];
    
    
    
}


#pragma mark - 消费者用餐
-(void)orderInConfirmWithUseId:(NSString *)userId
                         ordId:(NSString *)ordId
                       tableNo:(NSString *)tableNo
                   tableNumber:(NSString *)tableNumber{
        
    NSDictionary *paramters = @{@"key":globalData.loginModel.token, @"userId":userId, @"orderId":ordId, @"tableNo":tableNo, @"tableNumber":tableNumber};
    
    [Network PUT:GY_FOODOMAINAPP(GYHEFoodOrderUse) parameter:paramters success:^(id returnValue) {
      
               
        self.returnBlock(returnValue);
    } failure:^(id error){
        [self error:error];
       
    }];
}

#pragma mark - 查询送餐员
-(void)getDeliverList{
    
//    if (!globalData.loginModel.shopId) {
//        return;
//    }
    if (!kGetNSUser(@"shopId")) {
        return;
    }
//    NSDictionary *paramter = @{@"vShopId":globalData.loginModel.vshopId,@"shopId": globalData.loginModel.shopId};
   NSDictionary *paramter = @{@"vShopId":globalData.loginModel.vshopId,@"shopId": kGetNSUser(@"shopId")};
    
    [Network GET:GY_FOODOMAINAPP(GYHEFoodDeliverQuery) parameter:paramter success:^(id returnValue) {
          NSMutableArray *arrM = [NSMutableArray array];
        id arr = returnValue[@"data"];
        if ([arr isKindOfClass:[NSNull class]]) {
            [GYGIFHUD dismiss];
        }else if ([arr isKindOfClass:[NSArray class]]){
        
      
        NSArray *datArr = returnValue[@"data"];
        
        for (NSDictionary *d in datArr) {
            GYPostDataModel  *postModel=[GYPostDataModel mj_objectWithKeyValues:d];
            [arrM addObject:postModel];
        }
        }
 
        self.returnBlock(arrM);
        
    }  failure:^(id error){
        [self error:error];
        
      
      
    }];
}


#pragma mark - 现金结账
- (void)orderPayWithUserId:(NSString*)userId
               withOrderId:(NSString*)orderId
                 withDic:(NSMutableDictionary*)dic{
    NSMutableDictionary *paramers =  [[NSMutableDictionary alloc] initWithDictionary:dic];
    [paramers setValue:globalData.loginModel.token forKey:@"key"];
    [paramers setValue:userId forKey:@"userId"];
    [paramers setValue:orderId forKey:@"orderId"];

    [Network PUT:GY_FOODOMAINAPP(GYHEFoodOrderPay) parameter:paramers success:^(id returnValue) {
        self.returnBlock(returnValue);
        
    }  failure:^(id error){
        [self error:error];
       
      
    }];
    
}
#pragma mark - 外卖现金结账
- (void)outOrderPayWithkey:(NSString *)key userId:(NSString*)userId
                   orderId:(NSString*)orderId orderType:(NSString *)orderType{
    
    NSDictionary *parameter = @{@"key":key,
                                @"userId":userId,
                                @"orderId":orderId,
                                @"orderType":orderType,
                               };
   
    [Network PUT:GY_FOODOMAINAPP(GYHEFoodOrderPay) parameter:parameter success:^(id returnValue) {
       
        self.returnBlock(returnValue);
        
    }  failure:^(id error){
        [self error:error];
       
      
    }];
  
}

- (void)toGetWithOrderId:(NSString *)orderId userId:(NSString *)userId orderType:(NSString *)orderType
{

    
    NSDictionary *parameter = @{@"key":globalData.loginModel.token,
                                @"userId":userId,
                                @"orderId":orderId,
                                @"orderType":orderType,
                                };
    [Network PUT:GY_FOODOMAINAPP(GYHEFoodOrderPay) parameter:parameter success:^(id returnValue) {
        self.returnBlock(returnValue);
    }  failure:^(id error){
        [self error:error];
      
      
        
    }];


}

#pragma mark - 删除菜
- (void)deletelOrderDetailWithUseId:(NSString *)userId
                              ordId:(NSString *)ordId
                                 Id:(NSString*)Id{
    NSDictionary *parameter = @{@"key":globalData.loginModel.token,
                                @"userId":userId,
                                @"orderId":ordId,
                                @"id":Id,
                                };
    [Network DELETE:GY_FOODOMAINAPP(GYHEFoodDelOrderDetail) parameter:parameter success:^(id returnValue) {
        self.returnBlock(returnValue);
    }  failure:^(id error){
        [self error:error];
       
      
    }];
    
    
}


#pragma mark - 打单
- (void)sendOrderMessageWithParams: (NSDictionary *)paramters
{
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    [dictM addEntriesFromDictionary:@{@"key":globalData.loginModel.token}];
    for (NSString *keyS in [paramters allKeys]) {
        [dictM addEntriesFromDictionary:@{keyS:paramters[keyS]}];
    }

    [Network PUT:GY_FOODOMAINAPP(GYHEFoodSendOrderMessage) parameter:dictM success:^(id returnValue) {
        self.returnBlock(returnValue);
    }  failure:^(id error){
        [self error:error];
       
      
    }];

}

#pragma mark - 消费取消订单
- (void)cancelOrderValidateWithUserId:(NSString *)userId orderId:(NSString *)orderId
{

   
    NSDictionary *dict = @{@"key":globalData.loginModel.token,@"orderId":orderId,@"userId":userId};
    
    [Network PUT:GY_FOODOMAINAPP(GYHEFoodCancelOrderValidate) parameter:dict success:^(id returnValue) {
        self.returnBlock(returnValue);
    }  failure:^(id error){
        [self error:error];
       
      
    }];
}

#pragma mark - 保存订单
- (void)updateOrderWithParams:(NSDictionary*)params{
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    [dictM addEntriesFromDictionary:@{@"key":globalData.loginModel.token}];
    for (NSString *keyS in [params allKeys]) {
        [dictM addEntriesFromDictionary:@{keyS:params[keyS]}];
    }
    [Network PUT:GY_FOODOMAINAPP(GYHEFoodUpdateOrder) parameter:dictM success:^(id returnValue) {
        self.returnBlock(returnValue);
    } failure:^(id error){
        [self error:error];
       
    }];
}

#pragma mark - 企业取消预定
- (void)cancelReservationswithUserId:(NSString*)userdId withOrderId:(NSString*)orderId withMoneyEarnsetRefund:(NSString*)moneyEarnsetRefund WithRefundType:(NSString*)refundType withCancelReason:(NSString*)cancelReason{
    
    NSDictionary *dictM =@{ @"key":globalData.loginModel.token,
                            @"userId":userdId,
                            @"orderId":orderId,
                            @"moneyEarnestRefund":moneyEarnsetRefund,
                            @"refundType":refundType,
                            @"cancelReason":cancelReason
                            };
    [Network PUT:GY_FOODOMAINAPP(GYHEFoodCancelReservations) parameter:dictM success:^(id returnValue) {
        self.returnBlock(returnValue);
    } failure:^(id error){
        [self error:error];
       
    }];

}
- (void)requestOrdercancelReservationWithUserId:(NSString *)userId withOrder:(NSString*)orderId{
    
    NSDictionary *dict = @{@"key":globalData.loginModel.token,@"orderId":orderId,@"userId":userId};
    
    [Network PUT:GY_FOODOMAINAPP(GYHEFoodCancelReservations) parameter:dict success:^(id returnValue) {
        self.returnBlock(returnValue);
    } failure:^(id error){
        [self error:error];
        
       
    }];
}
//企业拒绝接单
- (void)putRefuseOrderWithUserId:(NSString *)userId withOrderId:(NSString *)orderId withReason:(NSString *)reason{
    NSDictionary *dict = @{@"key":globalData.loginModel.token,@"orderId":orderId,@"userId":userId,@"reason":reason};
    
    [Network PUT:GY_FOODOMAINAPP(GYHEFoodRefuseOrder) parameter:dict success:^(id returnValue) {
        self.returnBlock(returnValue);
    }  failure:^(id error){
        [self error:error];
       
    }];
}




@end
