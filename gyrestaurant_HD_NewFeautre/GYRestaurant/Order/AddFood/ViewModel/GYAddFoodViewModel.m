//
//  GYAddFoodViewModel.m
//  GYRestaurant
//
//  Created by apple on 15/10/28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAddFoodViewModel.h"
#import "GYTakeOrderListModel.h"
#import "GYSyncShopFoodsModel.h"
#import "GYSyncShopFoodsModel.h"
#import "GYFoodSpecModel.h"
#import "NSObject+HXAddtions.h"
@implementation GYAddFoodViewModel

- (void)requestAddFoodWithOrderId:(NSString *)orderId userId:(NSString *)userId
{
    NSMutableArray *dataList = [NSMutableArray array];

    NSArray *arr = globalData.takeOrderA;
    for (GYSyncShopFoodsModel *model in arr) {
//        if (model.selected.count == 0) {
//            [[UIApplication sharedApplication].delegate.window makeToast:@"请先选择菜品！"];
//        }
        if (model.selected.count > 0) {
            
            if (model.foodSpec.count > 0) {
               
                for (GYFoodSpecModel *m in model.foodSpec) {
                    
                    if ([model.selected[m.identify] intValue] > 0) {
                        
                        NSDictionary *standard = [m translationModelToFoodFormatId];
                        NSString *strStandard = [NSObject jsonStringWithDictionary:standard];
                        
                        NSDictionary *dict = @{@"id":model.foodId,
                                               @"quantity":[model.selected[m.identify] stringValue],
                                               @"standard":strStandard
                                               };
                        [dataList addObject:dict];
                        
                    }
                    
                }
           
            }else{
                
                int num = [model.selected[model.foodId] intValue];
                
                NSDictionary *standard = @{@"auction":model.foodPv,
                                           @"price":model.foodPrice
                                           };
                
                NSString *strStandard = [NSObject jsonStringWithDictionary:standard];
                
                if (num != 0) {
                    NSDictionary *dict = @{@"id":model.foodId,
                                           @"quantity":[@(num) stringValue],
                                           @"standard":strStandard
                                           };
                    
                    [dataList addObject:dict];
                }
            }
        }
    }
    [self PostAddFoodOrderAddOrderDetailWithOrderId:orderId userId:userId dataList:dataList];

}

- (void)PostAddFoodOrderAddOrderDetailWithOrderId:(NSString *)orderId
                                           userId:(NSString *)userId
                                         dataList:(NSMutableArray *)dataList
{
    
    NSDictionary *paramter = @{@"key":globalData.loginModel.token,
                               @"orderId":orderId,
                               @"vShopId":globalData.loginModel.vshopId,
                               @"userId":userId,
                               @"dataList":dataList
                               };

    [Network POST:GY_FOODOMAINAPP(GYHEFoodAddOrderDetail) parameter:paramter success:^(id returnValue) {
        
        self.returnBlock(returnValue);
        
    } failure:^(id error){
        [self error:error];
        
       
        
    }];
    
}

- (void)GetAddFoodFoodCategoryListFetchSuccess:(id)returnValue
{
    
    NSMutableArray *modelArrM = [NSMutableArray array];
    NSArray *dictArr = returnValue[@"data"];
    id arr = returnValue[@"data"];
    if ([arr isKindOfClass:[NSNull class]]) {
    
        return ;
    }else if ([dictArr isKindOfClass:[NSArray class]]){
        for (NSDictionary *d in dictArr) {
        GYSyncShopFoodsModel *model = [GYSyncShopFoodsModel mj_objectWithKeyValues:d];
        [modelArrM addObject:model];
        }
    }
    self.returnBlock(modelArrM);
    
}

@end
