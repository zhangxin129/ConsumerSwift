//
//  GYFoodSpecModel.m
//  GYRestaurant
//
//  Created by apple on 15/10/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYFoodSpecModel.h"


@implementation GYFoodSpecModel
/**
 *  将菜品的规格转化为字典
 *
 *  @param model <#model description#>
 *
 *  @return <#return value description#>
 */
- (NSDictionary *)translationModelToFoodFormatId
{
    return @{@"auction":self.auction,
             @"pId":self.pId,
             @"pName":self.pName,
             @"pVId":self.pVId,
             @"pVName":self.pVName,
             @"price":self.price
             };
    
}
MJCodingImplementation
@end
