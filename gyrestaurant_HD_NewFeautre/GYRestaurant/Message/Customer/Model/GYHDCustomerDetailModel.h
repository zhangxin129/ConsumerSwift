//
//  GYHDCustomerDetailModel.h
//  GYRestaurant
//
//  Created by apple on 16/4/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYHDCustomerDetailModel.h"
@interface GYHDCustomerDetailModel : NSObject

@property(nonatomic,copy)NSString*custId;//custid
//消费者个人信息详情
@property(nonatomic,copy)NSString*resNo;//互生号
@property(nonatomic,copy)NSString*area;//地区
@property(nonatomic,copy)NSString*sex;//性别
@property(nonatomic,copy)NSString*nickName;//昵称
@property(nonatomic,copy)NSString*headImage;//头像
@property(nonatomic,copy)NSString*hobby;//爱好
@property(nonatomic,copy)NSString*sign;//签名
@property(nonatomic,copy)NSString*age;//年龄
@property(nonatomic,copy)NSString*userType;//区分持卡人与非持卡人
@property(nonatomic,copy)NSString*resNoFormatStr;
//企业个人的信息资料
@property(nonatomic,copy)NSString*operPhone;//操作员电话
@property(nonatomic,copy)NSString*operDuty;//岗位
@property(nonatomic,copy)NSString*operName;//操作用称呼
@property(nonatomic,strong)NSMutableArray*saleAndOperatorRelationList;//营业点信息
@property(nonatomic,copy)NSString*username;//操作员用户名
@property(nonatomic,copy)NSString*roleName;
@property(nonatomic,assign)BOOL isClickSelf;//
-(void)initWithDic:(NSDictionary*)dic;
@end
