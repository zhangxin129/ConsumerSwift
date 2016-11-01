//
//  GYFoodSpecModel.h
//  GYRestaurant
//
//  Created by apple on 15/10/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYFoodSpecModel : NSObject
@property (nonatomic, copy) NSString *pId;
@property (nonatomic, copy) NSString *pName;
@property (nonatomic, copy) NSString *pVId;
@property (nonatomic, copy) NSString *pVName;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *auction;
//父类的地址和名称
@property (nonatomic, strong) NSMutableArray *picUrl;
@property (nonatomic, copy) NSString *foodName;//菜品名称
@property (nonatomic, copy) NSString *identify;



/**
 *  将菜品的规格转化为字典
 *
 *  @param model <#model description#>
 *
 *  @return <#return value description#>
 */
- (NSDictionary *)translationModelToFoodFormatId;

@end
