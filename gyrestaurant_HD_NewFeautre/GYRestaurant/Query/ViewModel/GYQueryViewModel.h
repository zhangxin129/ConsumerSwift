//
//  GYQueryViewModel.h
//  GYRestaurant
//
//  Created by apple on 15/10/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "ViewModel.h"

@interface GYQueryViewModel : ViewModel

//订单查询
-(void)getQueryOrderWithParams:(NSDictionary *)params;
//查询用户信息
//-(void)getEmployeeAccountListWithKey:(NSString *)key andParams:(NSDictionary *)params;
-(void)getEmployeeAccountListWithKey:(NSString *)key andShopId:(NSString *)shopId andEnterpriseResourceNo:(NSString *)enterpriseResourceNo roleId:(NSString *)roleId name:(NSString *)name phone:(NSString *)phone;
@end
