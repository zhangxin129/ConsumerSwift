//
//  FoodListInModel.m
//  GYRestaurant
//
//  Created by ios007 on 15/10/22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "FoodListInModel.h"


@implementation FoodListInModel

-(NSString *)foodState{
    NSString *str;
    if ([_foodState isEqualToString:@"0"]) {
        str = kLocalized(@"Normal");
    }else if ([_foodState isEqualToString:@"1"]) {
         str = kLocalized(@"Deleted");
    }else{
        str = kLocalized(@"PermanentlyDeleted");
    }
    return str;
}

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

@end
