//
//  GYLoginModel.m
//  GYRestaurant
//
//  Created by sqm on 16/3/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYLoginModel.h"

@implementation GYLoginModel
MJCodingImplementation
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"roles":@"RoleListModel"};
    
}
@end
@implementation GlobalAttribute
MJCodingImplementation

@end

@implementation RoleListModel

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"ID": @"id"};
}

@end