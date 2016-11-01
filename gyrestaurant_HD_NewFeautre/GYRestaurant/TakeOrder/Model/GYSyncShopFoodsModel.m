//
//  GYSyncShopFoodsModel.m
//  GYRestaurant
//
//  Created by apple on 15/10/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSyncShopFoodsModel.h"
#import "GYPicUrlModel.h"
#import "NSObject+HXAddtions.h"

@implementation GYSyncShopFoodsModel
+ (NSDictionary *)objectClassInArray{
    return @{@"picUrl":@"GYPicUrlModel",
             @"foodSpec":@"GYFoodSpecModel"
             };
}
MJCodingImplementation

/**
 *  将主菜品转化成字典
 *
 *  @param model <#model description#>
 *
 *  @return <#return value description#>
 */
- (NSDictionary *)translationModelToFoodDict
{
    int num = [self.selected[self.foodId] intValue];
    double pointTotal = num * [self.foodPv doubleValue];
    NSString *pointTotals = [NSString stringWithFormat:@"%.2f",pointTotal];
    double priceTotal = num * [self.foodPrice doubleValue];
    NSString *priceTotals = [NSString stringWithFormat:@"%.2f",priceTotal];
    NSMutableArray *ar = [NSMutableArray array];
    for (GYPicUrlModel *pic in self.picUrl) {
        NSDictionary *dic = pic.mj_keyValues;
        [ar addObject:dic];
        DDLogCInfo(@"%@",dic);
    }
    
    NSString *arS = [NSObject jsonStringWithArray:ar];
    
    NSDictionary *dic = @{@"foodId":self.foodId,@"foodNum":[@(num) stringValue],@"picUrl":arS,@"point":self.foodPv,@"pointTotal":pointTotals,@"price":self.foodPrice,@"priceTotal":priceTotals};
    return dic;
    
}

@end
