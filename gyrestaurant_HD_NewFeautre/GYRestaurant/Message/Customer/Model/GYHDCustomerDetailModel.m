//
//  GYHDCustomerDetailModel.m
//  GYRestaurant
//
//  Created by apple on 16/4/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDCustomerDetailModel.h"

@implementation GYHDCustomerDetailModel

/*
 @property(nonatomic,copy)NSString*custId;//custid
 @property(nonatomic,copy)NSString*resNo;//互生号
 @property(nonatomic,copy)NSString*area;//地区
 @property(nonatomic,copy)NSString*sex;//性别
 @property(nonatomic,copy)NSString*nickName;//昵称
 @property(nonatomic,copy)NSString*headImage;//头像
 @property(nonatomic,copy)NSString*hobby;//爱好
 @property(nonatomic,copy)NSString*sign;//签名
 @property(nonatomic,copy)NSString*age;//年龄
 
 
 @property(nonatomic,copy)NSString*operPhone;
 @property(nonatomic,copy)NSString*operDuty;
 @property(nonatomic,copy)NSString*operName;
 @property(nonatomic,strong)NSMutableArray*saleAndOperatorRelationList;
 @property(nonatomic,copy)NSString*username;
 */


-(void)initWithDic:(NSDictionary *)dic{
    
    self.saleAndOperatorRelationList=[NSMutableArray array];
    NSDictionary*dict=dic[@"searchUserInfo"];
 
    if ([dic[@"roleName"] isEqualToString:@"null"] || dic[@"roleName"]==nil){
        
       self.roleName=@"";
        
    }else{
        
        self.roleName=dic[@"roleName"];
    }
    
    
    self.custId=dict[@"custId"];
    self.resNo=dict[@"resNo"];
    self.area=dict[@"area"];
    self.sex=dict[@"sex"];
    self.nickName=dict[@"nickName"];
    self.headImage=dict[@"headImage"];
    self.hobby=dict[@"hobby"];
    self.sign=dict[@"sign"];
    self.age=dict[@"age"];
    self.operPhone=dict[@"operPhone"];
    self.operDuty=dict[@"operDuty"];
    self.operName=dict[@"operName"];
    self.saleAndOperatorRelationList=dic[@"saleAndOperatorRelationList"];
    self.username=dict[@"username"];
    self.userType=[dict[@"userType"] stringValue];
    self.resNoFormatStr=dic[@"resNoFormatStr"];
}
@end
