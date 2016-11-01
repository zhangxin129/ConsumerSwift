//
//  GYHDCustomerModel.h
//  GYRestaurant
//
//  Created by apple on 16/3/31.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDCustomerModel : NSObject
@property(nonatomic,copy)NSString*Friend_Name;//客户姓名
@property(nonatomic,copy)NSString*User_MessageTop;//消息置顶
@property(nonatomic,copy)NSString*Friend_detailed;//好友详情
@property(nonatomic,copy)NSString*MSG_FromID;//发送者id
@property(nonatomic,copy)NSString*MSG_ToID;//接受者id
@property(nonatomic,copy)NSString*User_Name;//用户名
@property(nonatomic,copy)NSString*MSG_UserState;//用户标示（区别企业（‘e’）消费者（‘c’））
@property(nonatomic,copy)NSString*Tream_ID;//未用
@property(nonatomic,copy)NSString*MSG_SendTime;//发送时间
@property(nonatomic,copy)NSString*MSG_Body;//消息体
@property(nonatomic,copy)NSString*Friend_CustID;//好友custid
@property(nonatomic,copy)NSString*Friend_UserType;//好友类型
@property(nonatomic,copy)NSString*MSG_DataString;//消息本地缓存路径
@property(nonatomic,copy)NSString*Friend_ID;//好友id
@property(nonatomic,copy)NSString*MSG_ID;//消息id
@property(nonatomic,copy)NSString*Friend_Basic;//好友基本信息
@property(nonatomic,copy)NSString*ID;//未用用来创建表的标示
@property(nonatomic,copy)NSString*MSG_Card;//消息custid
@property(nonatomic,copy)NSString*MSG_State;//消息发送状态 0:成功 1:发送中 2:发送失败
@property(nonatomic,copy)NSString*Friend_MessageTop;//消息置顶
@property(nonatomic,copy)NSString*MSG_RecvTime;//消息接收时间
@property(nonatomic,copy)NSString*Friend_Icon;//好友头像
@property(nonatomic,copy)NSString*MSG_Type;//消息类型 15：聊天消息
@property(nonatomic,copy)NSString*MSG_Read;//消息读取状态 1:已读
@property(nonatomic,copy)NSString*MSG_Self;//是否自己发送区别聊天左右
@property(nonatomic,copy)NSString*messageUnreadCount;//消息未读数量
@property(nonatomic,assign)BOOL isSelect;//是否被选定
-(void)initModelWithDic:(NSDictionary*)dic;

@end
