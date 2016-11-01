//
//  GYDeliverModel.m
//  GYRestaurant
//
//  Created by apple on 15/11/17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYDeliverModel.h"


@implementation GYDeliverModel


+ (NSDictionary *)replacedKeyFromPropertyName
{
    
    return @{@"idNum":@"id"};
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"idNum"];
    }else
    {
        [super setValue:value forKey:key];
    }
}

- (NSString *)sex
{
    NSString *str;
    if ([_sex isEqualToString:@"1"]) {
        str = kLocalized(@"Male");
    }else if([_sex isEqualToString:@"0"]){
        str = kLocalized(@"Female");
    }
    return str;

}

-(NSString *)status
{
    NSString *str;
    if ([_status isEqualToString:@"2"]){
        str = kLocalized(@"Disabled");
    }else if([_status isEqualToString:@"1"]){
        str = kLocalized(@"Enable");
    }else if([_status isEqualToString:@"0"]){
        str = kLocalized(@"Delete");
    }
    return str;
}
@end
