//
//  GYTakeOrderModel.h
//  GYRestaurant
//
//  Created by apple on 15/10/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYTakeOrderListModel : NSObject
@property (nonatomic, copy) NSString *itemNum;//数量
@property (nonatomic, copy) NSString *itemCustomCategoryId;//自定义类目ID
@property (nonatomic, copy) NSString *itemCustomCategoryName;//自定义类目名称
@property (nonatomic, strong) NSArray *itemFoodIdList;//自定义类目关联的菜品ID集合

@end
