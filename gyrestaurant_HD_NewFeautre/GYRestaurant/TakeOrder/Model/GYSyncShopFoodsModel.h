//
//  GYSyncShopFoodsModel.h
//  GYRestaurant
//
//  Created by apple on 15/10/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYSyncShopFoodsModel : NSObject

@property (nonatomic, strong) NSMutableArray *foodSpec;//菜品规格
@property (nonatomic, strong) NSMutableArray *picUrl;
@property (nonatomic, copy) NSString *foodPrice;//菜品单价
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *foodId;//菜品id
@property (nonatomic, copy) NSString *foodName;//菜品名称
@property (nonatomic, copy) NSString *foodPv;//菜品积分
@property (nonatomic, copy) NSString *foodState;
@property (nonatomic, copy) NSString *foodCategoryIdList;//菜品所属分类id的列表
@property (nonatomic, copy) NSString *foodNum;//菜品数量
@property (nonatomic, copy) NSString *foodLabel;//菜品标签
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) NSMutableDictionary *selected;


/**
 *  将主菜品转化成字典
 *
 *  @param model <#model description#>
 *
 *  @return <#return value description#>
 */
- (NSDictionary *)translationModelToFoodDict;


@end
