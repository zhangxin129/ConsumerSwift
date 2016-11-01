//
//  GYQueryViewModel.m
//  GYRestaurant
//
//  Created by apple on 15/10/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYQueryViewModel.h"
#import "NSObject+HXAddtions.h"
#import "GYQueryOrderModel.h"
#import "GYUserInfoModel.h"

@implementation GYQueryViewModel
#pragma mark - 订单查询
-(void)getQueryOrderWithParams:(NSDictionary *)params{
    
   
    NSString *paramsStr = [NSObject jsonStringWithDictionary:params];

    NSDictionary *paramsDic=@{@"key":globalData.loginModel.token,@"params":paramsStr};

    [Network GET:GY_FOODOMAINAPP(GYHEFoodQueryOrder) parameter:paramsDic success:^(id returnValue) {
        NSMutableArray *orderArr=[[NSMutableArray alloc] init];

        id arr = returnValue[@"data"];
        if ([arr isKindOfClass:[NSNull class]]) {
               self.returnBlock(orderArr);
        }else if ([arr isKindOfClass:[NSArray class]]){
        for(NSDictionary *dataDic in returnValue[@"data"]){
            GYQueryOrderModel *orderModel=[GYQueryOrderModel mj_objectWithKeyValues:dataDic];
      
            [orderArr addObject:orderModel];
        }
            
        }
        self.returnBlock(orderArr);

    }  failure:^(id error) {
        
    }];

}

#pragma mark - 查询用户信息
-(void)getEmployeeAccountListWithKey:(NSString *)key andParams:(NSDictionary *)params{
    
    NSString *str = [NSObject jsonStringWithDictionary:params];
    NSDictionary *paramsDic=@{@"key":key,@"params":str};
    
    [Network GET:GY_FOODOMAINAPP(GYHEFoodQueryEmployeeAccountList) parameter:paramsDic success:^(id returnValue) {
        NSMutableArray *orderArr=[[NSMutableArray alloc] init];
        
        id arr = returnValue[@"data"];
        if ([arr isKindOfClass:[NSNull class]]) {
            self.returnBlock(orderArr);
        }else if([arr isKindOfClass:[NSArray class]]){
            for(NSDictionary *dataDic in returnValue[@"data"]){
                GYUserInfoModel *userModel=[GYUserInfoModel mj_objectWithKeyValues:dataDic];
                
                [orderArr addObject:userModel];
            }
            
        }
        self.returnBlock(orderArr);
        
    }failure:^(id error){
        [self error:error];
       
    }];

}
-(void)getEmployeeAccountListWithKey:(NSString *)key andShopId:(NSString *)shopId andEnterpriseResourceNo:(NSString *)enterpriseResourceNo roleId:(NSString *)roleId name:(NSString *)name phone:(NSString *)phone{
    
    
    
    NSMutableDictionary *paramsDic=@{@"key":key,@"shopId":shopId,@"enterpriseResourceNo":enterpriseResourceNo,@"roleId":roleId,@"name":name}.mutableCopy;
    if (phone && ![phone isEqualToString:@""] && phone.length > 0) {
        [paramsDic addEntriesFromDictionary:@{@"phone":phone}];
    }
    
    [Network GET:GY_FOODOMAINAPP(GYHEFoodQueryEmployeeAccountList) parameter:paramsDic success:^(id returnValue) {
        NSMutableArray *orderArr=[[NSMutableArray alloc] init];
        
        id arr = returnValue[@"data"];
        if ([arr isKindOfClass:[NSNull class]]) {
            self.returnBlock(orderArr);
        }else if([arr isKindOfClass:[NSArray class]]){
            for(NSDictionary *dataDic in returnValue[@"data"]){
                GYUserInfoModel *userModel=[GYUserInfoModel mj_objectWithKeyValues:dataDic];
                
                [orderArr addObject:userModel];
            }
            
        }
        self.returnBlock(orderArr);
        
    }failure:^(id error){
        [self error:error];
        
    }];



}

@end
