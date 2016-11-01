//
//  GYHDReceiveMessageModel.h
//  HSCompanyPad
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDReceiveMessageModel : NSObject
@property(nonatomic,copy)NSString*fromid;//消息发送者
@property(nonatomic,copy)NSString*sendtime;//消息发送时间
@property(nonatomic,copy)NSString*toid;//发送对象
@property(nonatomic,copy)NSString*content;//消息内容
@property(nonatomic,copy)NSString*msgid;//消息id
@property(nonatomic,copy)NSString*guid;//消息标记id更新发送状态
@property(nonatomic,copy)NSString*sessionid;//会话id（只存在于客服对话）
@property(nonatomic,copy)NSString*messageType;//主要用于区别提示语和正常消息接收，解析方式不同
@property(nonatomic,copy)NSString*icon;//头像
@property(nonatomic,copy)NSString*name;//昵称
@end
