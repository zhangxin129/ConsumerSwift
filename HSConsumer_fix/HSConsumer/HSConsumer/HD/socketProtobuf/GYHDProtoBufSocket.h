//
//  GYHDProtoBufSocket.h
//  HSConsumer
//
//  Created by shiang on 16/4/11.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GYHDStream;
@protocol GYHDProtoBufSocketDelegate <NSObject>

/**连接成功*/
- (void)protoBufStreamDidConnect:(GYHDStream*)sender;
/**连接超时*/
- (void)protoBufStreamConnectDidTimeout:(GYHDStream*)sender;
/**连接失败*/
- (void)protoBufStreamDidDisconnect:(GYHDStream*)sender withError:(NSError*)error;
/**发送成功*/
- (void)protoBufStream:(GYHDStream*)sender didSendMessage:(NSData*)message;
/**发送失败*/
- (void)protoBufStream:(GYHDStream*)sender didFailToSendMessage:(NSData*)message error:(NSError*)error;
/**接收消息*/
- (void)protoBufStream:(GYHDStream*)sender didReceiveMessage:(NSData*)message;

@end

@interface GYHDProtoBufSocket : NSObject
@property (nonatomic, weak) id<GYHDProtoBufSocketDelegate> delegate;
/**设置*/
- (void)setloginStream:(GYHDStream*)loginStream;
/**登录*/
- (void)Login;
/**登出*/
- (void)Logout;
/**发送消息*/
- (void)sendMessageWithData:(NSData*)data;
/**是否连接*/
- (BOOL)isConnect;
@end
