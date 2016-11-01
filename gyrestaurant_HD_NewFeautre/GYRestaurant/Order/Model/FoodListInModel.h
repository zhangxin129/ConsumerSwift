//
//  FoodListInModel.h
//  GYRestaurant
//
//  Created by ios007 on 15/10/22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYFoodInSpecModel.h"

@interface FoodListInModel : NSObject

@property (nonatomic, copy)NSString *ID;
//菜品ID
@property (nonatomic, copy) NSString *foodId;
//菜品名称
@property (nonatomic, copy) NSString *foodName;
//菜品规格
@property (nonatomic, strong) GYFoodInSpecModel *foodSpec;
//菜品价格
@property (nonatomic, copy) NSString *foodPrice;
//菜品积分
@property (nonatomic, copy) NSString *foodPv;
//菜品类目Id
@property (nonatomic, copy) NSString *foodCategoryIdList;
//菜品标签
@property (nonatomic, copy) NSString *foodLabel;
//菜品图片
@property (nonatomic, copy) NSString *picUrl;
//菜品数量
@property (nonatomic, copy) NSString *foodNum;
//菜品状态
@property (nonatomic, copy) NSString *foodState;

@end
