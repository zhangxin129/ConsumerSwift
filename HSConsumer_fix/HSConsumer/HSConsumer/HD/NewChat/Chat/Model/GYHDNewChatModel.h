//
//  GYHDNewChatModel.h
//  HSConsumer
//
//  Created by shiang on 16/2/26.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDNewChatModel : NSObject
/**
 *  聊天头像
 */
@property (nonatomic, copy) NSString* chatIcon;
/**消息数字ID*/
@property (nonatomic, copy, readonly) NSString* chatMessageID;
/**消息富文本*/
@property (nonatomic, strong, readonly) NSAttributedString* chatContentAttString;
/**文字*/
@property (nonatomic, copy) NSString *chatContentString;
/**消息体*/
@property (nonatomic, copy, readonly) NSString* chatBody;
/**消息ID*/
@property (nonatomic, copy, readonly) NSString* chatCard;
/**消息数据体*/
@property (nonatomic, copy) NSString* chatDataString;
/**发送者FromID*/
@property (nonatomic, copy, readonly) NSString* chatFromID;
/**接收者ToID*/
@property (nonatomic, copy, readonly) NSString* chatToID;
/**接收时间*/
@property (nonatomic, copy) NSString* chatRecvTime;
/**是否为自己发送*/
@property (nonatomic, assign, readonly) BOOL chatIsSelfSend;
/**发送状态*/
@property (nonatomic, assign) NSInteger chatSendState;

+ (instancetype)chatModelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
