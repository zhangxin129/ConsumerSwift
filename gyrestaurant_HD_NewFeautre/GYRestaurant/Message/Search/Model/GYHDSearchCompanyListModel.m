//
//  GYHDSearchCompanyListModel.m
//  GYRestaurant
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSearchCompanyListModel.h"

@implementation GYHDSearchCompanyListModel

/*
 @property(nonatomic,copy)NSString*operaName;
 @property(nonatomic,copy)NSString*icon;
 @property(nonatomic,strong)NSArray*saleAndOperatorRelationList;//营业点列表
 @property(nonatomic,strong)NSDictionary*searchUserInfo;//操作员信息
 @property(nonatomic,copy)NSString*roleName;//操作员角色名称
 */
-(void)initWithDict:(NSDictionary *)dict{


    _operaName=dict[@"Friend_Name"];
    
    _icon=dict[@"Friend_Icon"];
    
    NSDictionary *bodyDict =  [Utils stringToDictionary:dict[@"Friend_Basic"]];
    
    _roleName= bodyDict[@"roleName"];
    
    _saleAndOperatorRelationList=bodyDict[@"saleAndOperatorRelationList"];
    
    _searchUserInfo=bodyDict[@"searchUserInfo"];
    
    _operPhone=bodyDict[@"searchUserInfo"][@"operPhone"];
}
@end
