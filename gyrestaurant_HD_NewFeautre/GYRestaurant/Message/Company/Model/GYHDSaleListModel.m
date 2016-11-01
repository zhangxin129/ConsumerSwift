//
//  GYHDSaleListModel.m
//  GYRestaurant
//
//  Created by apple on 16/4/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSaleListModel.h"

@implementation GYHDSaleListModel
/*
 @property(nonatomic,copy)NSString*headImage;
 @property(nonatomic,copy)NSString*roleName;
 @property(nonatomic,copy)NSString*entCustId;
 @property(nonatomic,copy)NSString*custId;
 @property(nonatomic,copy)NSString*entResNo;
 @property(nonatomic,copy)NSString*operDuty;
 @property(nonatomic,copy)NSString*operName;
 @property(nonatomic,copy)NSString*operPhone;*/
-(instancetype)initWithDic:(NSDictionary *)dic{


    if (self=[super init]) {
        
        self.headImage=dic[@"headImage"];
        self.roleName=dic[@"roleName"];
        self.entCustId=dic[@"entCustId"];
        self.custId=dic[@"custId"];
        self.operName=dic[@"operName"];
        self.entResNo=dic[@"entResNo"];
        self.operDuty=dic[@"operDuty"];
        self.operPhone=dic[@"operPhone"];
        self.operatorId=dic[@"operatorId"];
        self.sale_networkName=dic[@"sale_networkName"];
        self.resNo=dic[@"resNo"];
        
    }
    return self;
}
@end
