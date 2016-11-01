//
//  GYHDProtoBufSocket.m
//  HSConsumer
//
//  Created by Yejg on 16/8/8.
//  Copyright © 2016年 jianglincen. All rights reserved.
//


#import "GYHDProtoBufSocket.h"
#import "ImHxcommon.pb.h"
#import "ImHxconn.pb.h"
#import "ImHxfriend.pb.h"
#import "ImHxmessage.pb.h"
#import "ImHxbpn.pb.h"
#import "ImHxkefu.pb.h"
#import "GCDAsyncSocket.h"
#import "GYHDStream.h"
#import "GYHDProtoBufHeader.h"
#import "GYHDTimeOutModel.h"

@interface GYHDProtoBufSocket () <GCDAsyncSocketDelegate>
/**登录服务器参数*/
@property (nonatomic, strong) GYHDStream* stream;
@property (nonatomic, strong) GCDAsyncSocket* hdSocket;
@property (nonatomic, strong) NSTimer *connectTimer;

@property (nonatomic, assign) int heartbeatCounter;// 每发包一次置零，每秒加1
@property (nonatomic, strong) NSMutableArray *timeOutArray;// 每个元素是未能发送出去的包
// 计时器
@end

@implementation GYHDProtoBufSocket
const static int headerSize = 27;
// 有一种情况，一个包分两次甚至更多次收到，此时就要把这些包集中拼接起来
static NSData *dataBadPackage = nil;


- (NSMutableArray *)timeOutArray {
    
    if (_timeOutArray == nil) {
        _timeOutArray = [NSMutableArray array];
    }
    return _timeOutArray;
}

/**设置*/
- (void)setloginStream:(GYHDStream*)loginStream
{
    self.stream = loginStream;
    self.hdSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    //    登录服务器
    NSError *error = nil;
    [self.hdSocket connectToHost:self.stream.hostName onPort:self.stream.hostPort withTimeout:-1 error:&error];
    
}
// 心跳连接
- (void)sendHeartbeat {
    
    // 根据服务器要求发送固定格式的数据
    // 构建包头
    GYHDProtoBufHeader* buf = [GYHDProtoBufHeader headerWithGYHDStream:self.stream];
    buf.cmd = CommandIDSysHeartbeat;
    NSData* dataStream = [buf dataOfHeader];
    DDLogInfo(@"******心跳回忆*******%@",buf);
    [self sendMessageWithData:dataStream tag:CommandIDSysHeartbeat];
}

// 每秒做一次，登录后开始计时，登出时停止计时
- (void)longConnectToSocket{
    
    //每秒做一次遍历
    if(self.timeOutArray.count > 0){
        //有未发送成功的消息
        for (GYHDTimeOutModel *model in self.timeOutArray) {
            if (model.counter < 15) {
                model.counter++;
            }else if (model.counter == 15) {
                // 不让model.counter继续加1，所以只需赋值一个大于15的值就好，100是随便取的。
                model.counter = 100;
                
                // 停止转圈，变红色的叹号
                if ([self.delegate respondsToSelector:@selector(protoBufStream:didSendMessageTimeOutWithGuid:)]) {
                    [self.delegate protoBufStream:self.stream didSendMessageTimeOutWithGuid:model.strMsguid];
                }
            }
        }
    }
    //    NSLog(@"心跳计时：%d",self.heartbeatCounter);
    //每隔25s向服务器发送心跳包
    if (self.heartbeatCounter >= 25) {
        
        [self sendHeartbeat];
        
    }else{
        
        self.heartbeatCounter++;
        
    }
}

- (void)removeWitingMsgWithGuid:(NSString*)guid {
    
    NSMutableArray *tempArr=[NSMutableArray array];
    
    [tempArr addObjectsFromArray:self.timeOutArray];
    // 把对应的guid的model删除
    for (GYHDTimeOutModel *model in tempArr) {
        if ([model.strMsguid isEqualToString:guid]) {
            [self.timeOutArray removeObject:model];
            DDLogInfo(@"移除timeOutArray里的某个未发送成功的消息");
        }
    }
}

// 每当发送消息时，开始为每个消息的guid计时，15秒后变红色叹号
- (void)sendMsgStartCounterWithGuid:(NSString *)guid {
    
    GYHDTimeOutModel *model = [[GYHDTimeOutModel alloc]initWithMsguid:guid];
    [self.timeOutArray addObject:model];
}




/**登录*/
//- (void)Login
//{
//    [self.hdSocket connectToHost:self.stream.hostName onPort:self.stream.hostPort error:nil];
//}

- (BOOL)isConnect
{
    return [self.hdSocket isConnected];
}
/**登出*/
- (void)disconnect
{
    // 中断心跳包
    [self invalidateTimer];
    
    if ([self.hdSocket isConnected]) {
        [self.hdSocket disconnect];
    }
}

- (void)sendMessageWithData:(NSData *)data tag:(long)tag
{
    self.heartbeatCounter = 0;
    if (self.hdSocket && self.hdSocket.isConnected) {
        [self.hdSocket writeData:data withTimeout:-1 tag:tag];
    }
    
}

#pragma mark - GCDAsyncSocket代理方法
- (void)socket:(GCDAsyncSocket*)sock didConnectToHost:(NSString*)host port:(uint16_t)port
{
    DDLogInfo(@"互动 连接成功---%@----%d", host, port);
    // 把计时器加到主线程里，才能正常运作
    
    if ([self.delegate respondsToSelector:@selector(protoBufStreamDidConnect:)]) {
        [self.delegate protoBufStreamDidConnect:self.stream];
    }
    
    
}

- (void)invalidateTimer
{
    if (self.connectTimer) {
        [self.connectTimer invalidate];
        self.connectTimer = nil;
    }
}

- (void)setTimer
{
    [self invalidateTimer];
    //每隔25s向服务器发送心跳包
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                         target:self
                                                       selector:@selector(longConnectToSocket)
                                                       userInfo:nil
                                                        repeats:YES];
    [self.connectTimer fire];
}

- (void)socketDidDisconnect:(GCDAsyncSocket*)sock withError:(NSError*)err
{
    DDLogInfo(@"互动 连接失败 %@", err);
    
    if ([self.delegate respondsToSelector:@selector(protoBufStreamDidDisconnect:withError:)]) {
        [self.delegate protoBufStreamDidDisconnect:self.stream withError:err];
    }
}

// 接收包并解析
- (void)socket:(GCDAsyncSocket*)sock didReadData:(NSData*)data withTag:(long)tag
{
    if ([data isKindOfClass:[NSNull class]])
        return;
     NSData* recvData = [NSData dataWithData:data];
    
    // 有可能一个包分两次甚至多次发过来，此时要把这些数据拼接起来解析
    if (dataBadPackage != nil) {
        NSMutableData* data = [NSMutableData data];
        [data appendData:dataBadPackage];
        [data appendData:recvData];
        dataBadPackage = nil;
        recvData = [NSData dataWithData:data];
    }
    
    // 获得的数据少于一个包头的长度，直接判断为无用的数据，不解包，留待下一次解包
    if (recvData.length < headerSize) {
        dataBadPackage = recvData;
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        long long recvLength = recvData.length;
        const char *bytes = [recvData bytes];
        
        int packageLength = headerSize;
        int i = 0;
        for (int i = 0; i < recvLength; i++) {
            if ( bytes[i] == 'H' && bytes[i+1] == 'X' ) {// 说明这是包头的开始
        
                // 获得的数据少于一个包头的长度，直接判断为无用的数据，不解包-------
                if (recvLength  - i < headerSize) {
                    dataBadPackage = [recvData subdataWithRange:NSMakeRange(i, recvLength - i)];
                    return;
                }
                
                //------------------------------------
                NSData *dataHeader = [recvData subdataWithRange:NSMakeRange(i, headerSize)];
                GYHDProtoBufHeader* buf = [[GYHDProtoBufHeader alloc]initWithData:dataHeader];
                // 计算出这次这个包的总长度，包括包头和包体的长度
                packageLength = buf.size + headerSize;
                
                // 获得的数据少于一个包的长度，直接判断为无用的数据，不解包-------
                if (recvLength  - (i + packageLength)  < 0) {
                    dataBadPackage = [recvData subdataWithRange:NSMakeRange(i, recvLength - i)];
                    return;
                }
                //------------------------------------
                // 得到包体
                NSData* bodyData = [recvData subdataWithRange:NSMakeRange(i + headerSize, buf.size)];
                // 通过cmd来判断当前包的内容，并解析包
                switch (buf.cmd) {
                    case CommandIDSysHeartbeatAck:{// 心跳包
                        DDLogInfo(@"返回心跳包Ack");
                    }break;
                    case CommandIDCmCustLoginAck:{// 登录有反应成功
                        DDLogInfo(@"返回登录Ack");
                        LoginAck *ack = [LoginAck parseFromData:bodyData];
                        
                        switch (ack.nRet) {
                            case ResultCodeNoError:{// 登录成功
                                DDLogInfo(@"登录成功");
                                if ([self.delegate respondsToSelector:@selector(protoBufStreamDidLogined:)]) {
                                    [self.delegate protoBufStreamDidLogined:self.stream ];
                                }
                                
                                if (![NSThread isMainThread]){
                                    [self performSelectorOnMainThread:@selector(setTimer) withObject:nil waitUntilDone:NO];
                                }
                                
                            }break;
                            case ResultCodeErrorLoginAuth:// 用户鉴权错误（失败）
                                DDLogInfo(@"用户鉴权错误（失败）,例如用户名和密码错误");
                                // 例如用户名和密码错误
                                if ([self.delegate respondsToSelector:@selector(protoBufStreamDidLoginedFailure:)]) {
                                    [self.delegate protoBufStreamDidLoginedFailure:self.stream];
                                }
                                break;
                            case ResultCodeErrorRelogin:// 重复登录
                                DDLogInfo(@"用户重复登录");
                                
                                if ([self.delegate respondsToSelector:@selector(protoBufStreamReLogined:)]) {
                                    [self.delegate protoBufStreamReLogined:self.stream];
                                }
                                break;
                                
                            default:
                                break;
                        }
                        
                    }break;
                    case CommandIDCmCustLogoutAck:{// 登出有反应成功
                        DDLogInfo(@"返回登出Ack");
                        LogoutAck *ack = [LogoutAck parseFromData:bodyData];
                        
                        switch (ack.nRet) {
                            case ResultCodeNoError:{// 登出成功
                                DDLogInfo(@"登出成功");
                                if ([self.delegate respondsToSelector:@selector(protoBufStreamDidLogouted:)]) {
                                    [self.delegate protoBufStreamDidLogouted:self.stream ];
                                }
                            }break;
                            case ResultCodeErrorLogout:// 用户登出错误
                                DDLogInfo(@"用户登出错误");
                                if ([self.delegate respondsToSelector:@selector(protoBufStreamDidLogoutedFailure:)]) {
                                    [self.delegate protoBufStreamDidLogoutedFailure:self.stream];
                                }
                                break;
                                
                            default:
                                break;
                        }
                        
                    }break;
                    case CommandIDCmCustKickout:{// 被踢出
                        DDLogInfo(@"已在别处登录，被踢出");
                        if ([self.delegate respondsToSelector:@selector(protoBufStreamDidKickouted:)]) {
                            [self.delegate protoBufStreamDidKickouted:self.stream];
                        }
                    }break;
                    case CommandIDMsgHistoryMessageListAck:{// 获得聊天记录
                        DDLogInfo(@"获得聊天记录Ack");
                    }break;
                    case CommandIDHsPlatformHistoryMessageListAck:{// 获得聊天记录
                        DDLogInfo(@"获得聊天记录Ack");
                    }break;
                    case CommandIDFriendHistoryMessageListAck:{// 获得聊天记录
                        DDLogInfo(@"获得聊天记录Ack");
                    }break;
                    case CommandIDMsgAddFriendRsp:{// 获得 添加好友 的响应
                        DDLogInfo(@"添加好友Rsp");
                        AddFriendRsp *rsp = [AddFriendRsp parseFromData:bodyData];
                        if ([self.delegate respondsToSelector:@selector(protoBufDidReceiveMessage:)]) {
                            [self.delegate protoBufDidReceiveMessage:rsp];
                        }
                        switch (rsp.resultCode) {
                            case ResultCodeNoError:{// 添加好友成功
                                DDLogInfo(@"添加好友成功");
                                if ([self.delegate respondsToSelector:@selector(protoBufStreamDidAddedFriend:)]) {
                                    [self.delegate protoBufStreamDidAddedFriend:self.stream ];
                                }
                            }break;
                            case ResultCodeErrorFriendAlreadyExist:     // 加好友错误
                            case ResultCodeErrorFriendCannotAddYourself:// 加好友错误
                            case ResultCodeErrorFriendRquToomuch:       // 加好友错误
                            case ResultCodeErrorFriendStranger:         // 加好友错误
                            case ResultCodeErrorFriendIToomuchFriends:  // 加好友错误
                            case ResultCodeErrorFriendUToomuchFriends:  // 加好友错误
                            case ResultCodeErrorFriendTeamToomuch:      // 加好友错误
                            case ResultCodeErrorFriendTeamAlreadyExsit: // 加好友错误
                                DDLogInfo(@"添加好友错误");
                                if ([self.delegate respondsToSelector:@selector(protoBufStreamDidAddedFriendFailure:)]) {
                                    self.stream.errorCode = rsp.resultCode;
                                    [self.delegate protoBufStreamDidAddedFriendFailure:self.stream];
                                }
                                break;
                                
                            default:
                                break;
                        }
                    }break;
                      
                    case CommandIDMsgVerifyFriendRsp:
                    {
                        VerifyFriendRsp *rsp = [VerifyFriendRsp parseFromData:bodyData];
                        if ([self.delegate respondsToSelector:@selector(protoBufDidReceiveMessage:)]) {
                            [self.delegate protoBufDidReceiveMessage:rsp];
                        }
                        break;
                    }
                    case CommandIDMsgVerifyFriendReq:{// 获得 验证好友 的响应
                        DDLogInfo(@"验证好友Rsp");
                        VerifyFriendReq *rsp = [VerifyFriendReq parseFromData:bodyData];
                        if ([self.delegate respondsToSelector:@selector(protoBufDidReceiveMessage:)]) {
                            [self.delegate protoBufDidReceiveMessage:rsp];
                        }
                        switch (rsp.agree) {
                            case ResultCodeNoError:{// 我同意，验证好友成功
                                DDLogInfo(@"验证好友成功");
                                if ([self.delegate respondsToSelector:@selector(protoBufStreamDidVerifiedFriend:)]) {
                                    [self.delegate protoBufStreamDidVerifiedFriend:self.stream ];
                                }
                            }break;
                            case 1:{// 我不同意，验证好友失败
                                DDLogInfo(@"验证好友失败");
                                if ([self.delegate respondsToSelector:@selector(protoBufStreamDidVerifiedFriendFailure:)]) {
                                    [self.delegate protoBufStreamDidVerifiedFriendFailure:self.stream ];
                                }
                            }break;
                            default:
                                break;
                        }
                    }break;
                    case CommandIDMsgDelFriendRsp:{// 删除好友 的响应
                        
                        DelFriendRsp *rsp = [DelFriendRsp parseFromData:bodyData];
                        if ([self.delegate respondsToSelector:@selector(protoBufDidReceiveMessage:)]) {
                            [self.delegate protoBufDidReceiveMessage:rsp];
                        }
                        self.stream.errorCode = rsp.resultCode;
                        DDLogInfo(@"删除好友Rsp，%d",rsp.resultCode);
                        switch (rsp.resultCode) {
                            case ResultCodeNoError:{// 删除好友成功
                                DDLogInfo(@"删除好友成功");
                                if ([self.delegate respondsToSelector:@selector(protoBufStreamDidDelFriend:)]) {
                                    [self.delegate protoBufStreamDidDelFriend:self.stream ];
                                }
                            }break;
                            case ResultCodeErrorInvalidData:
                            case ResultCodeErrorFriendStranger:{// 删除好友失败
                                DDLogInfo(@"删除好友失败");
                                if ([self.delegate respondsToSelector:@selector(protoBufStreamDidDelFriendFailure:)]) {
                                    [self.delegate protoBufStreamDidDelFriendFailure:self.stream ];
                                }
                            }break;
                            default:
                                break;
                        }
                    }break;
                        
                    case CommandIDMsgModifyFriendRsp:{// 修改好友备注 的响应
                        DDLogInfo(@"修改好友备注 Rsp");
                        ModifyFriendRsp *rsp = [ModifyFriendRsp parseFromData:bodyData];
                        if ([self.delegate respondsToSelector:@selector(protoBufDidReceiveMessage:)]) {
                            [self.delegate protoBufDidReceiveMessage:rsp];
                        }
                        self.stream.errorCode = rsp.resultCode;
                        switch (rsp.resultCode) {
                            case ResultCodeNoError:{// 修改好友备注 成功
                                DDLogInfo(@"修改好友备注 成功");
                                if ([self.delegate respondsToSelector:@selector(protoBufStreamDidModifyFriend:)]) {
                                    [self.delegate protoBufStreamDidModifyFriend:self.stream ];
                                }
                            }break;
                            case ResultCodeErrorInvalidData:
                            case ResultCodeErrorFriendStranger:{// 修改好友备注失败
                                DDLogInfo(@"修改好友备注失败");
                                if ([self.delegate respondsToSelector:@selector(protoBufStreamDidModifyFriendFailure:)]) {
                                    [self.delegate protoBufStreamDidModifyFriendFailure:self.stream ];
                                }
                            }break;
                            default:
                                break;
                        }
                    }break;
                        
                    case CommandIDMsgShieldFriendRsp:{// 屏蔽好友 的响应
                        DDLogInfo(@"屏蔽好友 Rsp");
                        ShieldFriendRsp *rsp = [ShieldFriendRsp parseFromData:bodyData];
                        self.stream.errorCode = rsp.resultCode;
                        switch (rsp.resultCode) {
                            case ResultCodeNoError:{// 修改好友 成功
                                DDLogInfo(@"屏蔽好友 成功");
                                if ([self.delegate respondsToSelector:@selector(protoBufStreamDidShieldFriend:)]) {
                                    [self.delegate protoBufStreamDidShieldFriend:self.stream ];
                                }
                            }break;
                            case ResultCodeErrorInvalidData:
                            case ResultCodeErrorFriendStranger:{// 屏蔽好友失败
                                DDLogInfo(@"屏蔽好友失败");
                                if ([self.delegate respondsToSelector:@selector(protoBufStreamDidShieldFriendFailure:)]) {
                                    [self.delegate protoBufStreamDidShieldFriendFailure:self.stream ];
                                }
                            }break;
                            default:
                                break;
                        }
                    }break;
                    case CommandIDMsgSessionMessageRsp:{// P2P发送消息成功，先得到服务器返回的响应
                        ChatMsgRsp *rsp = [ChatMsgRsp parseFromData:bodyData];
                        
                        if ([self.delegate respondsToSelector:@selector(protoBufStreamDidSendMessage:chatMsg:)]) {
                            [self.delegate protoBufStreamDidSendMessage:self.stream chatMsg:rsp];
                        }
                    }break;
                    case CommandIDMsgSessionMessageAckRsp:{// 服务器返回的响应
                        DDLogInfo(@"服务器知道发消息成功 Rsp");
                        ChatMsgAckRsp *rsp = [ChatMsgAckRsp parseFromData:bodyData];
                        
                        switch (rsp.code) {
                            case ResultCodeNoError:{// 服务器知道发消息成功
                                DDLogInfo(@"服务器知道发消息成功");
                            }break;
                            default:
                                break;
                        }
                    }break;
                    case CommandIDMsgSessionMessageForward:{//收到P2P的消息
                        DDLogInfo(@"收到消息");
                        
                        if ([self.delegate respondsToSelector:@selector(protoBufStream:didReceiveMessage:)]) {
                            [self.delegate protoBufStream:self.stream didReceiveMessage:bodyData];
                        }
                    }break;
                        
                        //   P2C（客服）会话相关:
                    case CommandIDP2CCreateRsp:{//创建客服会话响应
                        
                        DDLogInfo(@"服务器响应客服会话");
                        
                        CreateP2CSessionRsp*rsp=[CreateP2CSessionRsp parseFromData:bodyData];
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(createPersonToCompanySuccess:)]) {
                            
                            [self.delegate createPersonToCompanySuccess:rsp];
                        }
                        
                    }break;
                    case CommandIDP2CMessageRsp:{//P2C消息发送成功
                        
                        P2CMsgRsp*rsp=[P2CMsgRsp parseFromData:bodyData];
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(protoBufDidSendP2CMessage:)]) {
                            
                            [self.delegate protoBufDidSendP2CMessage:rsp];
                        }
                        
                    }break;
                    case CommandIDP2CMessageForward:{//接收到P2C消息
                        
                        P2CMsg*msg=[P2CMsg parseFromData:bodyData];
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(protoBufDidReceiveP2CMessage:)]) {
                            
                            [self.delegate protoBufDidReceiveP2CMessage:msg];
                        }
                        
                    }break;
                        
                    case CommandIDP2CCloseRsp:{//结束会话响应
                        
                        CloseP2CSessionRsp*rsp=[CloseP2CSessionRsp parseFromData:bodyData];
                        if ([self.delegate respondsToSelector:@selector(protoBufDidReceiveMessage:)]) {
                            [self.delegate protoBufDidReceiveMessage:rsp];
                        }
//                        if (self.delegate && [self.delegate respondsToSelector:@selector(protoBufDidReceiveP2CMessage:)]) {
//                            
//                            [self.delegate protoBufDidReceiveP2CMessage:rsp];
//                        }
                        switch (rsp.code) {
                            case ResultCodeNoError:{
                                
                                if (self.delegate && [self.delegate respondsToSelector:@selector(protoBufCloseP2CSession:)]) {
                                    
                                    [self.delegate protoBufCloseP2CSession:rsp];
                                }
                                
                            }break;
                            default:
                                break;
                        }
                        
                    }break;
                        
                    case CommandIDP2CCloseForward:{//结束会话同时通知到到另一方
                        
                        CloseP2CSessionRsp*rsp=[CloseP2CSessionRsp parseFromData:bodyData];
                        
                        switch (rsp.code) {
                                
                            case ResultCodeNoError:{
                                
                                if (self.delegate && [self.delegate respondsToSelector:@selector(protoBufCloseP2CSessionToOtherSide:)]) {
                                    
                                    [self.delegate protoBufCloseP2CSessionToOtherSide:rsp];
                                }
                                
                            }break;
                            default:
                                break;
                        }
                        
                    }break;
                        
                    case CommandIDP2CSwitchRsp:{//服务器响应咨询转移
                        
                        SwitchP2CRsp*rsp=[SwitchP2CRsp parseFromData:bodyData];
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(switchP2CSession:)]) {
                            
                            [self.delegate switchP2CSession:rsp];
                        }
                        
                    }break;
                        
                    case CommandIDP2CSwitchForward:{//新客服接收到会话转移
                        
                        SwitchP2CReq *req=[SwitchP2CReq parseFromData:bodyData];
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(switchP2CReqSessionDidReceive:)]) {
                            
                            [self.delegate switchP2CReqSessionDidReceive:req];
                            
                        }
                        
                    }break;
                        
//                    case CommandIDP2CNotifySwitch:{//新客服收到对话转移后同时通知到消费者 和老客服
//                        
//                        NotifySwitchP2C*notiSwitch=[NotifySwitchP2C parseFromData:bodyData];
//                        
//                        if (self.delegate && [self.delegate respondsToSelector:@selector(switchP2CSessionNotify:)]) {
//                            
//                            [self.delegate switchP2CSessionNotify:notiSwitch];
//                        }
//                        
//                    }break;
                    case CommandIDP2CNotifySwitchC:{
                        //新客服收到对话转移后同时通知到消费者
                        
                        NotifySwitchP2C*notiSwitch=[NotifySwitchP2C parseFromData:bodyData];
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(switchP2CSessionNotify:)]) {
                            
                            [self.delegate switchP2CSessionNotify:notiSwitch];
                        }
                        
                    }break;
                    case CommandIDP2CNotifySwitchP:{
                        
                        //新客服收到对话转移后同时通知到老客服
                        
                        NotifySwitchP2C*notiSwitch=[NotifySwitchP2C parseFromData:bodyData];
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(switchP2CSessionNotify:)]) {
                            
                            [self.delegate switchP2CSessionNotify:notiSwitch];
                        }
                        
                    }break;
                    case CommandIDP2CLeaveMsgRsp:{//消费者对企业留言响应
                        
                        P2CLeaveMsgRsp*rsp=[P2CLeaveMsgRsp parseFromData:bodyData];
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(leaveMessageDidSendToCompany:)]) {
                            
                            [self.delegate leaveMessageDidSendToCompany:rsp];
                        }
                        
                    }break;
                    case CommandIDP2CAssignLeaveMessageRsp:{//请求分配企业留言
                        DDLogInfo(@"请求分配企业留言成功");
                        
                        AssignP2CLeaveMsgRsp*rsp=[AssignP2CLeaveMsgRsp parseFromData:bodyData];
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(pullOfLeaveMessageToCompany:)]) {
                            
                            [self.delegate pullOfLeaveMessageToCompany:rsp];
                        }
                    }break;
                    
                    case CommandIDHistoryMessageSummaryRsp:{// 响应获取离线消息总体概要
                        DDLogInfo(@"响应获取离线消息总体概要");
                        OfflineMsgSumRsp *rsp = [OfflineMsgSumRsp parseFromData:bodyData];
                        switch (rsp.code) {
                            case ResultCodeNoError:{// 响应获取离线消息总体概要 成功
                                DDLogInfo(@"响应获取离线消息总体概要 成功");
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    if ([self.delegate respondsToSelector:@selector(protoBufStream:didReceiveSummary:)]) {
                                        
                                        [self.delegate protoBufStream:self.stream didReceiveSummary:rsp.summary];
                                    }
                                    
                                });
                                
                            }break;
                            case ResultCodeErrorConnectDatabase:
                            case ResultCodeErrorQueryDatabase:
                            case ResultCodeErrorInsertDatabase:
                            case ResultCodeErrorUpdateDatabase:
                            case ResultCodeErrorDeleteDatabase:
                            case ResultCodeErrorInvalidData:{// 屏蔽好友失败
                                DDLogInfo(@"响应获取离线消息总体概要 失败");
                                
                            }break;
                            default:
                                break;
                        }
                        
                    }break;
                    case CommandIDBpnMessagePush:{//在线响应获取互生推送消息
                        DDLogInfo(@"接收在线平台推送消息");
                        
                        pushMsgReq *req = [pushMsgReq parseFromData:bodyData];
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(protoBufStream:didReceivePushOnLineMessage:)]) {
                            
                            [self.delegate protoBufStream:self.stream didReceivePushOnLineMessage:req];
                        }
                    }break;
                    case CommandIDMsgHistoryMessageListRsp:{
                        DDLogInfo(@"接收P2P离线聊天消息");
                        
                        OfflineMsgRsp *rsp = [OfflineMsgRsp parseFromData:bodyData];
                        
                        switch (rsp.code) {
                            case ResultCodeNoError:{
                                if (self.delegate && [self.delegate respondsToSelector:@selector(protoBufStream:didReceiveChatOffLineList:)]) {
                                    
                                    [self.delegate protoBufStream:self.stream didReceiveChatOffLineList:rsp.msglist];
                                }
                            }
                                break;
                                
                            default:
                                break;
                        }
                    }break;
                    case CommandIDP2CHistoryMessageListRsp:{
                        
                        DDLogInfo(@"接收P2C离线聊天消息");
                        P2COfflineMsgRsp*rsp=[P2COfflineMsgRsp parseFromData:bodyData];
                        
                        switch (rsp.code) {
                            case ResultCodeNoError:{
                                
                                if (self.delegate && [self.delegate respondsToSelector:@selector(protoBufStream:didReceiveP2CChatOffLineList:)]) {
                                    
                                    [self.delegate protoBufStream:self.stream didReceiveP2CChatOffLineList:rsp.msglist];
                                    
                                }
                            }break;
                            default:
                                break;
                        }
                    }break;
                        
                    case CommandIDHsPlatformHistoryMessageListRsp:{
                        DDLogInfo(@"接收平台离线消息");
                        
                        PfOfflineMsgRsp*rsp=[PfOfflineMsgRsp parseFromData:bodyData];
                        
                        switch (rsp.code) {
                            case ResultCodeNoError:{
                                if (self.delegate && [self.delegate respondsToSelector:@selector(protoBufStream:didReceivePushOffLineList:)]) {
                                    
                                    [self.delegate protoBufStream:self.stream didReceivePushOffLineList:rsp.msglist];
                                }
                            }
                                break;
                                
                            default:
                                break;
                        }
                    }
                    default:
                        break;
                }
                
                // 计算出下一个包的起始位置
                i += packageLength;
                // 处理最后一个包的结尾还有数据的情况------------------------------------
                if (recvLength - i < headerSize) {// 剩下的长度连一个包头都不够，可见是一个无效数据，可以直接跳出循环
                    if (recvLength - i > 0) {// 包体的尾部有多余的数据
                        dataBadPackage = [recvData subdataWithRange:NSMakeRange(i, recvLength - i)];
                    }else{// 剩下的数据为0，即刚好是最后一个包，没有脏数据，所以保险起见，把dataBadPackage置nil
                        dataBadPackage = nil;//
                    }
                    break;
                }//------------------------------------
            }// 一个包解析结束
        }// for循环结束
    });
    [self.hdSocket readDataWithTimeout:-1 tag:tag];
}

- (void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag
{
    //    if ([self.delegate respondsToSelector:@selector(protoBufStream:didReceiveMessage:)]) {
    //        [self.delegate protoBufStream:self.stream didReceiveMessage:nil];
    //    }
    [self.hdSocket readDataWithTimeout:-1 tag:tag];
}

//- (void)sock
@end
