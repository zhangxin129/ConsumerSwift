//
//  GYHDOpereotrListModel.h
//  GYRestaurant
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDOpereotrListModel : NSObject
@property(nonatomic,strong)NSArray*saleAndOperatorRelationList;//营业点列表
@property(nonatomic,strong)NSDictionary*searchUserInfo;//操作员信息
@property(nonatomic,strong)NSString*roleName;//操作员角色名称
@property(nonatomic,copy)NSString*messageUnreadCount;//消息未读数量
@end
