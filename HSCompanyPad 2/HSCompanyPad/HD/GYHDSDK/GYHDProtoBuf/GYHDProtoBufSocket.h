//
//  GYHDProtoBufSocket.h
//  HSConsumer
//
//  Created by shiang on 16/4/11.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImHxbpn.pb.h"
#import "ImHxkefu.pb.h"
@class GYHDStream;
@protocol GYHDProtoBufSocketDelegate <NSObject>

/**连接成功*/
- (void)protoBufStreamDidConnect:(GYHDStream*)sender;
/**连接超时*/
- (void)protoBufStreamConnectDidTimeout:(GYHDStream*)sender;
/**连接失败*/
- (void)protoBufStreamDidDisconnect:(GYHDStream*)sender withError:(NSError*)error;
/**登录成功*/
- (void)protoBufStreamDidLogined:(GYHDStream*)sender;
/**登录失败*/
- (void)protoBufStreamDidLoginedFailure:(GYHDStream*)sender;
/*重复登录*/
- (void)protoBufStreamReLogined:(GYHDStream*)sender;
/**登出成功*/
- (void)protoBufStreamDidLogouted:(GYHDStream*)sender;
/**登出失败*/
- (void)protoBufStreamDidLogoutedFailure:(GYHDStream*)sender;
/**被踢出登录*/
- (void)protoBufStreamDidKickouted:(GYHDStream*)sender;


#pragma mark - P2P消息发送
/**P2P发送成功*/
- (void)protoBufStreamDidSendMessage:(GYHDStream*)sender chatMsg:(ChatMsgRsp*)chatMsg;
/**发送失败*/
- (void)protoBufStream:(GYHDStream*)sender didFailToSendMessage:(NSData*)message error:(NSError*)error;
/**P2P接收消息*/
- (void)protoBufStream:(GYHDStream*)sender didReceiveMessage:(NSData*)message;
/**P2P 发送后15秒*/
- (void)protoBufStream:(GYHDStream*)sender didSendMessageTimeOutWithGuid:(NSString*)guid;

#pragma mark - 客服功能相关
/**P2C服务器响应对话并返回对话双方*/
- (void)createPersonToCompanySuccess:(CreateP2CSessionRsp*)sessionRsp;

/**P2C接收消息*/
- (void)protoBufDidReceiveP2CMessage:(P2CMsg*)msg;

/**P2C发送成功*/
- (void)protoBufDidSendP2CMessage:(P2CMsgRsp*)msgRsp;

/**P2C结束会话响应*/
- (void)protoBufCloseP2CSession:(CloseP2CSessionRsp*)sessionRsp;

/**P2C结束会话通知给被结束方*/
- (void)protoBufCloseP2CSessionToOtherSide:(CloseP2CSessionRsp*)sessionRsp;

/**发起咨询转移响应*/
- (void)switchP2CSession:(SwitchP2CRsp*)rsp;

/**新客服接收到转移的对话*/
- (void)switchP2CReqSessionDidReceive:(SwitchP2CReq*)req;

/**接收新客服同意接收转移对话的通知*/
- (void)switchP2CSessionNotify:(NotifySwitchP2C*)notify;

/**响应消费者对企业留言*/
- (void)leaveMessageDidSendToCompany:(P2CLeaveMsgRsp*)rsp;

/**接收离线消息汇总*/
- (void)protoBufStream:(GYHDStream*)sender didReceiveSummary:(NSArray *)arraySummary;

/**接收P2P聊天离线消息列表*/
- (void)protoBufStream:(GYHDStream*)sender didReceiveChatOffLineList:(NSArray *)listArray;

/**接收推送离线平台消息列表*/
- (void)protoBufStream:(GYHDStream*)sender didReceivePushOffLineList:(NSArray *)listArray;

/**接收在线推送平台消息列表*/
- (void)protoBufStream:(GYHDStream*)sender didReceivePushOnLineMessage:(pushMsgReq *)pushMsg;

/**拉取消费者对企业留言列表*/
- (void)pullOfLeaveMessageToCompany:(AssignP2CLeaveMsgRsp*)rsp;

/**接收P2C聊天离线消息列表*/
- (void)protoBufStream:(GYHDStream*)sender didReceiveP2CChatOffLineList:(NSArray *)listArray;


#pragma mark - 好友相关
/**加好友成功*/
- (void)protoBufStreamDidAddedFriend:(GYHDStream*)sender;
/**加好友失败*/
- (void)protoBufStreamDidAddedFriendFailure:(GYHDStream*)sender;
/**验证好友成功*/
- (void)protoBufStreamDidVerifiedFriend:(GYHDStream*)sender;
/**验证好友失败*/
- (void)protoBufStreamDidVerifiedFriendFailure:(GYHDStream*)sender;
/**删除好友成功*/
- (void)protoBufStreamDidDelFriend:(GYHDStream*)sender;
/**删除好友失败*/
- (void)protoBufStreamDidDelFriendFailure:(GYHDStream*)sender;
/**修改好友资料成功*/
- (void)protoBufStreamDidModifyFriend:(GYHDStream*)sender;
/**修改好友资料失败*/
- (void)protoBufStreamDidModifyFriendFailure:(GYHDStream*)sender;
/**屏蔽好友资料成功*/
- (void)protoBufStreamDidShieldFriend:(GYHDStream*)sender;
/**屏蔽好友资料失败*/
- (void)protoBufStreamDidShieldFriendFailure:(GYHDStream*)sender;

@end

@interface GYHDProtoBufSocket : NSObject
@property (nonatomic, weak) id<GYHDProtoBufSocketDelegate> delegate;
/**设置*/
- (void)setloginStream:(GYHDStream*)loginStream;
/**登录*/
//- (void)Login;
/**登出*/
- (void)disconnect;
/**发送消息*/
- (void)sendMessageWithData:(NSData*)data tag:(long)tag;

/**P2P发送时开始计时15秒*/
- (void)sendMsgStartCounterWithGuid:(NSString*)guid;
/**是否连接*/
- (BOOL)isConnect;
/**SDK外部确认收到消息，移除等待确认成功的消息*/
- (void)removeWitingMsgWithGuid:(NSString*)guid;
@end
