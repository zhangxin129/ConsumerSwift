//
//  GYUserInfoModel.m
//  GYRestaurant
//
//  Created by apple on 15/11/7.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYUserInfoModel.h"

@implementation GYUserInfoModel

-(NSString *)roleID{
    
    NSString *strAA;
    NSArray *arr = [NSArray array];
    arr = [_roleID componentsSeparatedByString:@","];
        for (NSString *str in arr) {
        
        if ([str isEqualToString:@"301"] || [str isEqualToString:@"201"] ) {
            strAA = kLocalized(@"SystemAdministrator");
            
        }else if ([str isEqualToString:@"202"] || [str isEqualToString:@"302"]){
            strAA = kLocalized(@"BusinessPointAdministrator");
            
        }else if ([str isEqualToString:@"303"] ||[str isEqualToString:@"203"]){
            strAA = kLocalized(@"Cashier");
            
        }else if ([str isEqualToString:@"304"] || [str isEqualToString:@"204"]){
            strAA = kLocalized(@"Waiter");
            
        }else if ([str isEqualToString:@"305"] || [str isEqualToString:@"205"]){
            
            strAA = kLocalized(@"DeliveryStaff");
        }else if ([str isEqualToString:kLocalized(@"All")]){
            
            strAA = @"";
        }

    }
    
    return strAA;
}

-(NSString *)status{
    
    NSString *str;
    if ([_status isEqualToString:@"0"]) {
        str = kLocalized(@"Active");
    }else if ([_status isEqualToString:@"1"]) {
        str = kLocalized(@"FrozenState");
    }else if ([_status isEqualToString:@"2"]) {
        str = kLocalized(@"LogoutState");
    }else if ([_status isEqualToString:@"3"]) {
        str = kLocalized(@"DeletedState");
    }

    return str;
}


- (NSString *)telNumber
{
    return [_telNumber isEqualToString:@"null"] ? @"":_telNumber;

}
@end
