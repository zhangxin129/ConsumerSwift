//
//  GYHDAllMsgListModel.h
//  GYRestaurant
//
//  Created by apple on 16/7/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYHDMessageCenter.h"
@interface GYHDAllMsgListModel : NSObject
@property(nonatomic,copy)NSString*iconUrl;
@property(nonatomic,copy)NSString*titlName;
@property(nonatomic,copy)NSString*content;
@property(nonatomic,copy)NSString*timeStr;
@property(nonatomic,copy)NSString*messageUnreadCount;//消息未读数量
@property(nonatomic,copy)NSString*msgType;//区分推送与聊天 9为推送 10为聊天
@property(nonatomic,copy)NSString*pushMsgType;//推送消息类型1为系统消息 2为订单 3为服务
@property(nonatomic,copy)NSString*msgCard;//聊天custid
@property(nonatomic,copy)NSString*MSG_UserState;
@property(nonatomic,copy)NSString*friendUserType;//区别于持卡人与非持卡人
@property (nonatomic,copy) NSString * messageTopTime;//置顶时间
/**
 * 消息置顶
 */
@property(nonatomic, assign) GYHDPopMessageState messageState;
@property(nonatomic, copy)NSString  *ID;
@property(nonatomic, assign)BOOL isSelect;//是否选定
-(void)initWithDict:(NSDictionary*)dict;
@end
