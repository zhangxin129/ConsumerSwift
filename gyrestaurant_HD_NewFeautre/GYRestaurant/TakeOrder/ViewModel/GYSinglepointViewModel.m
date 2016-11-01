//
//  GYSinglepointViewModel.m
//  GYRestaurant
//
//  Created by apple on 15/10/22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSinglepointViewModel.h"
#import "GYTakeOrderSubmitOrderModel.h"
#import "NSObject+HXAddtions.h"
#import "GYencryption.h"
#import "GYSyncShopFoodsModel.h"
#import "GYFoodSpecModel.h"

@implementation GYSinglepointViewModel

- (void)PostOrderSubmitOrderWithAmountTotal:(NSString *)amountTotal
                                personCount:(NSString *)personCount
                                pointsTotal:(NSString *)pointsTotal
                                     remark:(NSString *)remark
                                      resNo:(NSString *)resNo
                                     userId:(NSString *)userId isCardCustomer:(NSString *)isCardCustomer
{
    
    
    NSArray *arr = globalData.takeOrderA;
    NSMutableArray *foodList = [NSMutableArray array];
    for (GYSyncShopFoodsModel *model in arr) {
        if (model.selected.count > 0) {
            
            if (model.foodSpec.count > 0) {
                
                for (GYFoodSpecModel *m in model.foodSpec) {
                    if ([model.selected[m.identify] intValue] >0) {
                        NSDictionary *foodFormatId = [m translationModelToFoodFormatId];
                        NSMutableDictionary *foodListD = [NSMutableDictionary dictionary];
                        [foodListD addEntriesFromDictionary:[model translationModelToFoodDict]];
                        //替换相关的key对应的值
                        int num = [model.selected[m.identify] intValue ];
                        foodListD[@"foodNum"] = [@(num) stringValue];
                        foodListD[@"point"] = m.auction;
                        foodListD[@"price"] = m.price;
                        foodListD[@"pointTotal"] = [NSString stringWithFormat:@"%.2f",num * [m.auction doubleValue]];
                        foodListD[@"priceTotal"] = [NSString stringWithFormat:@"%.2f",num * [m.price doubleValue]];
                        [foodListD addEntriesFromDictionary:@{@"foodFormatId":[NSObject jsonStringWithDictionary:foodFormatId]}];
                        [foodList addObject:foodListD];
                    }
                }
            }else{
                
                [foodList addObject:[model translationModelToFoodDict]];
            }
        }
        
    }

    id  foodListJ = [NSNull null];
    if (foodList.count > 0) 
        foodListJ = foodList;
//    if (!globalData.loginModel.shopId) {
//        return;
//    }
    if (!kGetNSUser(@"shopId")) {
        return;
    }
    NSDictionary *paramter = @{@"amountTotal":amountTotal,@"key":globalData.loginModel.token,@"personCount":personCount,@"pointsTotal":pointsTotal,@"remark":remark,@"resNo":resNo,@"shopId":kGetNSUser(@"shopId"),@"userId":userId,@"vShopId":globalData.loginModel.vshopId,@"foodList":foodListJ,@"isCardCustomer":isCardCustomer};

   
    
    [Network POST:GY_FOODOMAINAPP(GYHEFoodSubmitOrder) parameter:paramter  success:^(id returnValue) {
        self.returnBlock(returnValue);
    } failure:^(id error){
        [self error:error];
       
      
    }];

}

- (void)OrderSubmitOrderFetchSuccess:(id)returnValue
{
    
    NSMutableArray *modelArrM = [NSMutableArray array];
    NSArray *dictArr = returnValue[@"data"];
    id arr = returnValue[@"data"];
    if ([arr isKindOfClass:[NSNull class]]) {
        return ;
    }else  if ([arr isKindOfClass:[NSArray class]]){
    
    for (NSDictionary *d in dictArr) {
        GYTakeOrderSubmitOrderModel *model = [GYTakeOrderSubmitOrderModel mj_objectWithKeyValues:d];
        [modelArrM addObject:model];
    }
    }
    self.returnBlock(modelArrM);

}

- (void)POSTCheckAccountIdWithAccountId:(NSString *)accountId password:(NSString *)pwd
{
    pwd = [GYencryption l:pwd k:accountId];
    NSDictionary *paramter = @{@"key":globalData.loginModel.token,@"accountId":accountId,@"pwd":pwd};
 
   [Network POST:GY_FOODOMAINAPP(GYHEFoodCheckAccount) parameter:paramter success:^(id returnValue) {
       [self GetCheckAccountIdFetchSuccess:returnValue];
   } failure:^(id error){
        [self error:error];
      
     
   }];
}
-(void)POSTCheckAccountIdWithAccountId:(NSString *)accountId password:(NSString *)pwd UserType:(NSString *)userType isCardCustomer:(NSString *)isCardCustomer{

    pwd = [GYencryption l:pwd k:accountId];
    NSDictionary *paramter = @{@"key":globalData.loginModel.token,@"accountId":accountId,@"pwd":pwd,@"userType":userType,@"isCardCustomer":isCardCustomer};
    
    [Network POST:GY_FOODOMAINAPP(GYHEFoodCheckAccount) parameter:paramter success:^(id returnValue) {
        [self GetCheckAccountIdFetchSuccess:returnValue];
    } failure:^(id error){
        [self error:error];
        
        
    }];


}
- (void)GetCheckAccountIdFetchSuccess:(id)returnValue
{
    
    id retCode = returnValue[@"retCode"];
    id data = returnValue[@"data"];
    id msg = returnValue[@"msg"];
    if ([retCode isKindOfClass:[NSNull class]]) {
        return ;
    }

    NSMutableArray *modelStr = [NSMutableArray arrayWithObjects:retCode,data,msg,nil];
    
    self.returnBlock(modelStr);
}

@end
