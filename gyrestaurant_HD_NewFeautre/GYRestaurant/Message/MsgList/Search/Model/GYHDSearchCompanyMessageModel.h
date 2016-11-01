//
//  GYHDSearchCompanyMessageModel.h
//  GYRestaurant
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDSearchCompanyMessageModel : NSObject
@property(nonatomic,copy)NSString*msgCard;//客户custid
@property(nonatomic,copy)NSString*time;//发送时间
@property(nonatomic,copy)NSString*content;//发送内容
@property(nonatomic,copy)NSString*msgIcon;//客户头像
@property(nonatomic,copy)NSString*msgNote;//客户昵称
@property(nonatomic,copy)NSString*msgID;
@property(nonatomic,copy)NSString*UserState;
@property(nonatomic,strong)NSArray*saleAndOperatorRelationList;//营业点列表
@property(nonatomic,strong)NSDictionary*searchUserInfo;//操作员信息
@property(nonatomic,copy)NSString*roleName;//操作员角色名称
@property(nonatomic,copy)NSString*kerWord;
-(void)initWithDict:(NSDictionary*)dict;
@end
