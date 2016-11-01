//
//  GYHDSearchCustomerListModel.m
//  GYRestaurant
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSearchCustomerListModel.h"

@implementation GYHDSearchCustomerListModel
/*
 @property(nonatomic,copy)NSString*iconUrl;
 @property(nonatomic,copy)NSString*name;
 @property(nonatomic,copy)NSString*hsCardNum;
 @property(nonatomic,copy)NSString*keyWord;
 */

-(void)initWithDict:(NSDictionary*)dict{

    _iconUrl=dict[@"Friend_Icon"];
    
    _name=dict[@"Friend_Name"];
    
    _custId=dict[@"Friend_CustID"];
    
    _friendUserType=dict[@"Friend_UserType"];
    
    if ([dict[@"Friend_ID"] containsString:@"_c_"]) {
        
        _hsCardNum=[_custId substringWithRange:NSMakeRange(0, 11)];
    }
    
    
//    NSDictionary *bodyDict =  [GYUtils stringToDictionary:dict[@"Friend_Basic"]];
    
}
@end
