//
//  GYTakeOrderTool.m
//  GYRestaurant
//
//  Created by kuser on 15/11/7.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYTakeOrderTool.h"
#import "GYSyncShopFoodsModel.h"
#import "GYFoodSpecModel.h"
#import "GYSystemSettingViewModel.h"

@implementation GYTakeOrderTool


+ (NSUInteger)getAllFoodNumWithModel:(GYSyncShopFoodsModel *)model
{
    NSUInteger num = 0;
    if (model.foodSpec.count > 0) {
        for (NSString  *key in [model.selected allKeys]) {
            num += [model.selected[key] intValue];
            
        }
        
    }else{
        num = [model.selected[model.foodId] integerValue];
        
    }
    return num ;
}

+ (void)reloadTabkeOrderList
{
    
    GYSystemSettingViewModel *fclist = [[GYSystemSettingViewModel alloc]init];
    
    NSMutableArray *arr = (NSMutableArray *)[fclist readFromPath:@"foodsList"];
    
    if (arr.count > 0) {
        
        NSMutableArray *takeOrderM = [NSMutableArray array];
        for (GYSyncShopFoodsModel *model in arr) {
            model.selected = [NSMutableDictionary dictionary];
            [takeOrderM addObject:model];
        }
        globalData.takeOrderA = takeOrderM;
    }
}
+ (NSString *)getFoodNumWithPid:(NSString *)pid
{
    
    NSMutableArray *arrM = globalData.takeOrderA;
    for (GYSyncShopFoodsModel *model in arrM) {
        if (model.foodSpec.count >0) {
            for (GYFoodSpecModel *m in model.foodSpec) {
                if ([m.identify isEqualToString:pid]) {
                    
                    return    [model.selected[pid] stringValue];
                }
            }
        }
    }
    return @"";
}

+ (NSString *)getFoodNumWithFoodId:(NSString *)foodId
{
    
    NSMutableArray *arrM = globalData.takeOrderA;
    for (GYSyncShopFoodsModel *model in arrM) {
        if ([model.foodId isEqualToString:foodId]) {
                 return    [model.selected[foodId] stringValue];
        }
    }
    return @"";
}

+ (void)saveModelWithCount:(NSInteger)count model:(id)model
{
    if ([model isKindOfClass:[GYSyncShopFoodsModel class]]) {
        GYSyncShopFoodsModel *fm = model;
        fm.foodNum = [@(count) stringValue];
        for(int i = 0; i<globalData.takeOrderA.count;i ++){
            GYSyncShopFoodsModel *mo = globalData.takeOrderA[i];
            
            DDLogCInfo(@"--------------->>>>>>>>>>%@",fm.foodId);
            
            if ([fm.foodId isEqualToString:mo.foodId]) {
                mo.selected[mo.foodId] = @(count);
                globalData.takeOrderA[i] = fm;
            }
        }
    }else if([model isKindOfClass:[GYFoodSpecModel class]]){
        
        GYFoodSpecModel *fm = model;
        for(int i = 0; i<globalData.takeOrderA.count;i ++){
            GYSyncShopFoodsModel *mo = globalData.takeOrderA[i];
            if (mo.foodSpec.count > 0) {
                for ( int j = 0 ; j <mo.foodSpec.count; j ++ ) {
                    GYFoodSpecModel * m = mo.foodSpec[j];
                    if ([m.identify isEqualToString:fm.identify]) {
                        mo.selected[m.identify] = @(count);
                        globalData.takeOrderA[i] = mo;
                    }
                }
            }
        }
    }
}

+ (void)saveModelWithModel:(id)model
{
    if ([model isKindOfClass:[GYSyncShopFoodsModel class]]) {
        GYSyncShopFoodsModel *mo = model;
        for(int i = 0;i <globalData.takeOrderA.count;i++)
        {
            GYSyncShopFoodsModel *m = globalData.takeOrderA[i];
            if ([m.foodId isEqualToString:mo.foodId]) {
                globalData.takeOrderA[i] = model;
            }
        }
    }
}

+ (int)getTakeListNum
{
    int num = 0;
    
    for (GYSyncShopFoodsModel *model in globalData.takeOrderA) {
        if (model.selected.count > 0) {
            for (NSString *key in [model.selected allKeys]) {
                num += [model.selected[key] intValue];
            }
        }
    }
    return num;
}
@end
