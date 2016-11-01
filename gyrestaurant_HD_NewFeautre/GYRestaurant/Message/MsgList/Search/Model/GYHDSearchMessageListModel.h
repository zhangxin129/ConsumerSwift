//
//  GYHDSearchMessageListModel.h
//  GYRestaurant
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDSearchMessageListModel : NSObject
@property(nonatomic,copy)NSString*pullMsgType;//消息类型 /1为系统消息 2为订单消息 3为服务消息（暂时屏蔽）
@property(nonatomic,copy)NSString*titleName;//名称
@property(nonatomic,strong)NSArray*contentArr;//消息内容数组
@property(nonatomic,copy)NSString*msgType;//消息类型 /9 为推送消息 10为聊天消息
@property(nonatomic,copy)NSString*iconUrl;
@property(nonatomic,copy)NSString*keyWord;
@property(nonatomic,assign)NSInteger countrow;
@property(nonatomic,copy)NSString*custId;

@end
