//
//  GYFoodCategoryListViewModel.m
//  GYRestaurant
//
//  Created by apple on 15/10/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYFoodCategoryListViewModel.h"
#import "GYTakeOrderListModel.h"
#import "GYSyncShopFoodsModel.h"
#import "GYSyncShopFoodsModel.h"


@implementation GYFoodCategoryListViewModel

#pragma mark －－－－－－－自定义菜品分类列表

- (void)GetFoodCategoryList
{
//    if (!globalData.loginModel.shopId) {
//        return;
//    }
    if (!kGetNSUser(@"shopId")) {
        return;
    }
    NSDictionary *paramter = @{@"key":globalData.loginModel.token,@"vShopId": globalData.loginModel.vshopId,@"shopId":kGetNSUser(@"shopId")};

    [Network GET:GY_FOODOMAINAPP(GYHEFoodGetFoodCategoryList) parameter:paramter success:^(id returnValue) {
        
        [self GetFoodCategoryListFetchSuccess:returnValue];

    }  failure:^(id error){
        [self error:error];
        
       
      
    }];
    
}

- (void)GetFoodCategoryListFetchSuccess:(id)returnValue
{
    NSMutableArray *modelArrM = [NSMutableArray array];
    NSArray *dictArr = returnValue[@"data"];
    id arr = returnValue[@"data"];
    if ([arr isKindOfClass:[NSNull class]]) {
        return ;
    }else if ([dictArr isKindOfClass:[NSArray class]]){
    for (NSDictionary *d in dictArr) {
        GYTakeOrderListModel *model = [GYTakeOrderListModel mj_objectWithKeyValues:d];
        [modelArrM addObject:model];
    }
    }
    self.returnBlock(modelArrM);
}

- (void)takeOrderShopsSyncShopFoodsSuccess:(id)returnValue
{
    NSMutableArray *modelArrM = [NSMutableArray array];
    id arr = returnValue[@"data"];
    if ([arr isKindOfClass:[NSNull class]]) {
        return ;
    }
    NSArray *dictArr = returnValue[@"data"];
    if ([dictArr isKindOfClass:[NSNull class]]) {
        return ;
    }
    for (NSDictionary *d in dictArr) {
        GYSyncShopFoodsModel *model = [GYSyncShopFoodsModel mj_objectWithKeyValues:d];
        [modelArrM addObject:model];
    }
    self.returnBlock(modelArrM);
}

@end
