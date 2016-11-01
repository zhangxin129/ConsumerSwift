//
//  GYTakeOrderTool.h
//  GYRestaurant
//
//  Created by kuser on 15/11/7.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GYSyncShopFoodsModel,GYFoodSpecModel;
@interface GYTakeOrderTool : NSObject


+ (NSUInteger)getAllFoodNumWithModel:(GYSyncShopFoodsModel *)model;
+ (void)reloadTabkeOrderList;
+ (NSString *)getFoodNumWithPid:(NSString *)pid;
+ (NSString *)getFoodNumWithFoodId:(NSString *)foodId;
+ (void)saveModelWithCount:(NSInteger)count model:(id)model;
+ (void)saveModelWithModel:(id)model;
+ (int)getTakeListNum;

@end
