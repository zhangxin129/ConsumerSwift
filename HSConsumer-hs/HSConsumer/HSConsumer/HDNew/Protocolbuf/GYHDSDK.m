//
//  GYHDSDK.m
//  HSConsumer
//
//  Created by Yejg on 16/8/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSDK.h"
#import "GYHDProtoBufSocket.h"
#import "GYHDStream.h"
#import "ImHxconn.pb.h"
#import "ImHxcommon.pb.h"
#import "ImHxfriend.pb.h"
#import "ImHxmessage.pb.h"
#import "GYHDProtoBufHeader.h"
#import "DDTTYLogger.h"
#import "XMPPLogging.h"
#import "FMDatabase.h"
#import "GYHDMessageCenter.h"
#import "GYHDReceiveMessageModel.h"
#import "GYHDPushMsgModel.h"
#import "ImHxkefu.pb.h"
#import "GYUtils+HSConsumer.h"
#import "GYAlertView.h"

@interface GYHDSDK () < GYHDProtoBufSocketDelegate>

//登录开关，用来判断重连接时，是否该自动登录。
@property (nonatomic, assign) BOOL isCalledLogin;
//强制登录。暂时用这个属性装着，后期有可能通过外部传入
@property (nonatomic, assign) BOOL isForceLogin;
//频道类型
@property (nonatomic, assign)UInt32  channelType;
//设备类型
@property (nonatomic, assign)UInt32  deviceType;
//设备Token，消费者为@"11"
@property (nonatomic, copy) NSString *deviceToken;
//企业资源号，消费者为@""
@property (nonatomic, copy) NSString *entResNoStr;
//-----------------------

@property (nonatomic, strong) GYHDProtoBufSocket *hdSocket;
@property (nonatomic, assign) NSTimeInterval connectTimeout;

/**
*  login名
*/
@property (nonatomic, copy) NSString *loginName;
/**
 *  密码
 */
@property (nonatomic, copy) NSString *password;
/**
 *  域名
 */
@property (nonatomic, copy) NSString *hostName;
/**
 *  即时消息端口
 */
@property(assign,nonatomic) UInt16 hostPort;

// 推送消息的连接
@property (nonatomic, copy) NSString *domainString;
@property (nonatomic, copy) NSString *resource;

// 推送消息端口
//@property (nonatomic, assign) UInt16 pushHostPort;
@property (nonatomic, copy) NSString *pushHostName;

@end

@implementation GYHDSDK

+ (instancetype)sharedInstance
{
    static GYHDSDK *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GYHDSDK alloc]init];
    });
    return instance;
}

#pragma -mark
- (instancetype)init
{
    
    if (self = [super init]) {
        //初始化hdSocket，会在登陆的时候使用到。而且链接服务器也需要用hdSocket，所以重写init方法，让该类的对象一开始创建的时候就把通信管道铺好，这样就可以直接使用其功能
        self.isCalledLogin = NO;
        self.isForceLogin = YES;
        self.connectTimeout = 15.f;
        
        self.domainString = @"im.gy.com";
        self.resource = @"mobile_im";
        //本地回环地址，公司的hostName；
        self.hostName = @"192.168.41.193";
        //设置端口号（让服务器知道你是哪一个app）
        self.hostPort = 5222;
        //设置代理
//        [self.hdSocket addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [DDLog addLogger:[DDTTYLogger sharedInstance] withLogLevel:XMPP_LOG_FLAG_SEND_RECV];
        //2***********好友管理*******************
        
        
        
        //***********3、保存聊天记录的****************
        
        
    }
    return self;
}
// 连接socket，并登录。本类内不允许调用这个方法。
- (void)loginWithChannelType:(UInt32)channelType
                  DeviceType:(UInt32)deviceType
                 entResNoStr:(NSString *)entResNoStr
                 deviceToken:(NSString *)deviceToken
                       block:(LoginBlock)block
{
    self.isCalledLogin = YES;
    //1、为关键的几个属性赋值
    self.channelType = channelType; //消费者是4
    self.entResNoStr = entResNoStr; //消费者是@""
    self.deviceType = deviceType;   //消费者是5
    self.deviceToken = deviceToken; //消费者是@"11"
    
    //2、初始化username，登录用loginName，其他诸如加好友、发消息，用username
    
    if ([self.entResNoStr isEqualToString:@""]) {//消费者//Bill
        if (globalData.loginModel.cardHolder) {
            self.username = [NSString stringWithFormat:@"c_%@", globalData.loginModel.custId];
        }else {
            self.username = [NSString stringWithFormat:@"nc_%@", globalData.loginModel.custId];
        }
    }else{//企业
        self.username = [NSString stringWithFormat:@"e_%@", globalData.loginModel.custId];
        
    }
    self.loginName = self.username;
    
    // 为了配合后台 加上 m_ p_
    switch (self.deviceType) {
        case IMDeviceTypeIOSMobile:// 手机
            self.username = [NSString stringWithFormat:@"m_%@", self.username];
            break;
        case IMDeviceTypeIOSPad:// iOS平板
            self.username = [NSString stringWithFormat:@"p_%@", self.username];
            break;
        default:
            break;
    }
    
    //王彪-----------------------------------
    self.loginBlock = block;
    if (!self.hostName || !globalData.loginModel.token) {
        // 验证登录所需参数是否为空
        if (self.loginBlock) {
            self.loginState = kIMLoginStateUnknowError;
            self.loginBlock(kIMLoginStateUnknowError);
        }
        [GYHDMessageCenter sharedInstance].state = GYHDMessageLoginStateUnknowError;
        return;
    }
    //-----------------------------
    
    
    //设置protobuf
    [self setupProtoBufSocket];
    //链接服务器
//    [self connectToServer];
    
    //检查及创建数据库
//    NSString *dbFullName = [GYDBCenter getUserDBNameInDirectory:self.username];
//    if (![GYDBCenter fileIsExists:dbFullName])
//    {
//        DDLogCInfo(@"用户数据库不存在，将创建");
//        if (![GYDBCenter createFile:dbFullName])
//        {
//            return;
//        }
//    }
//    
//    DDLogCInfo(@"im数据库完整路径:%@", dbFullName);
//    _imFMDB = [[FMDatabase alloc] initWithPath:dbFullName];
//    
//    [[GYHDMessageCenter sharedInstance] savedbFull:dbFullName];
//    
//    DDLogInfo(@"im数据库完整路径:%@", dbFullName);
}

/**protobuf 登录*/
- (void)setupProtoBufSocket
{
    
//    [[GYHDMessageCenter sharedInstance] getOfflinePushMsg];
    
    self.hdSocket = [[GYHDProtoBufSocket alloc] init];
    self.hdSocket.delegate = self;
    GYHDStream *stream = [[GYHDStream alloc] init];
    NSString *imUrl = globalData.loginModel.ttMsgServer;
    
    
    
    if ([GYHSLoginEn sharedInstance].loginLine == kLoginEn_dev) {
        stream.hostName = @"192.168.229.139";//@"192.168.229.136";//@"192.168.229.139";
        stream.hostPort = 13000 ;//5859;//8001;//13080;
        
//        stream.hostName = @"192.168.229.137";
//        stream.hostPort = 5857;
    } else {
//        stream.hostName = @"192.168.229.60";
//        stream.hostPort = 13000;
        stream.hostName = [imUrl componentsSeparatedByString:@":"].firstObject;
        stream.hostPort = [imUrl componentsSeparatedByString:@":"].lastObject.integerValue;
    }
    
    
    [self.hdSocket setloginStream:stream];
//    [self.hdSocket Login];
    
    
}

/*重复登录*/
- (void)protoBufStreamReLogined:(GYHDStream*)sender
{
    if (self.isForceLogin) {//强制登录下，遇到重登录警告，不需重新登录
        
    }else{
        
    }
}

//退出登录
- (void)logout
{
    self.isCalledLogin = NO;
//    [self teardownStream];
    [self protobufDisconnect];
}

- (void)teardownStream
{
    //移除代理
    self.hdSocket.delegate = nil;
}

- (void)protobufDisconnect
{
    if (self.hdSocket == nil) {
        return;
    }
    
    if ([self.hdSocket isConnect]) {
        // 1.先退出登录
        LogoutReq* req = [[[[LogoutReq builder] setSCustId:self.loginName] setNDeviceType:self.deviceType] build];
        GYHDProtoBufHeader* buf = [[GYHDProtoBufHeader alloc] init];
        buf.cmd = CommandIDCmCustLogout;
        NSData* data = [buf dataWithProtobufData:[req data]];
    
        [self.hdSocket sendMessageWithData:data tag:CommandIDCmCustLogout];
        
        
    }
}

#pragma mark- P2P发送消息
- (void)sendMessageToFriendID:(NSString *)friendID guid:(NSString*)guid content:(NSString *)content
{
    
    ChatMsg *chat = [[[[[[[[[[[[ChatMsg builder]setMsgid:@""]setFromid:self.username]setToid:friendID]setSessiontype:@"p2p"]setMsgtype:@"c2c"]setSendtime:0]setContent:content]setContenttype:@"00"]setIsreaded:NO]setGuid:guid]build];
    
    DDLogInfo(@"*****发送消息内容*****:%@",content);
    
    [self splitProtobufPackageWithData:[chat data] tag:CommandIDMsgSessionMessage];
}


#pragma mark- 发送消息后15秒未发送成功*/
- (void)protoBufStream:(GYHDStream*)sender didSendMessageTimeOutWithGuid:(NSString*)guid {
    
//    //    获取消息id更新消息发送状态
//    NSString *msgID = guid;
//    
//    [self.dataBaseCenter updateMessageStateWithMessageID:msgID State:GYHDDataBaseCenterMessageSendStateFailure];
//    NSDictionary* dict = @{ @"msgID" : msgID,
//                            @"State" : @(GYHDDataBaseCenterMessageSendStateFailure) };
//    [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:dict];
//    
//    
//    DDLogInfo(@"*****发送消息失败*****");
    
}

#pragma mark- P2P消息发送成功*/
- (void)protoBufStreamDidSendMessage:(GYHDStream*)sender chatMsg:(ChatMsgRsp *)chatMsg{
    
    
    if (chatMsg.code==ResultCodeNoError) {
        
        //    获取消息id更新消息发送状态
        NSString *msgID = chatMsg.guid;
        
        [[GYHDMessageCenter sharedInstance] updateMessageStateWithMessageID:msgID State:GYHDDataBaseCenterMessageSendStateSuccess];
        NSDictionary* dict = @{ @"msgID" : msgID,
                                @"State" : @(GYHDDataBaseCenterMessageSendStateSuccess) };
        [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:dict];
        
        DDLogInfo(@"*****发送消息成功*****");
        
    }else{
        
        //    获取消息id更新消息发送状态
        NSString *msgID = chatMsg.guid;
        
        [[GYHDMessageCenter sharedInstance] updateMessageStateWithMessageID:msgID State:GYHDDataBaseCenterMessageSendStateFailure];
        NSDictionary* dict = @{ @"msgID" : msgID,
                                @"State" : @(GYHDDataBaseCenterMessageSendStateFailure) };
        [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:dict];
        
        DDLogInfo(@"*****发送消息失败*****");
    }
    
}

/**服务器响应消息已读*/
- (void)protoBufStream:(GYHDStream*)sender didReadMessage:(NSData*)message
{
    
}

/**接收消息*/
- (void)protoBufStream:(GYHDStream *)sender didReceiveMessage:(NSData *)message {
    
    
    
    // 1.发一个已经接收到的消息过去
    ChatMsg *rsp = [ChatMsg parseFromData:message];
    
    if ([rsp.sessiontype isEqualToString:@"friend"]) {// 收到好友加我的消息，需要我验证
        GYHDPushMsgModel *model = [[GYHDPushMsgModel alloc] init];
//        @property(nonatomic,copy)NSString*fromid;//推送id
//        @property(nonatomic,copy)NSString*pushtime;//推送消息时间
//        @property(nonatomic,copy)NSString*toid;//推送对象
//        @property(nonatomic,copy)NSString*content;//推送消息内容
//        @property(nonatomic,copy)NSString*msgtype;//推送消息类型
//        @property(nonatomic,copy)NSString*msgid;//推送消息id
        model.fromid = rsp.fromid;
        model.pushtime = [NSString stringWithFormat:@"%lld",rsp.sendtime];
        model.toid = rsp.toid;
        model.content = rsp.content;
        model.msgtype = rsp.msgtype;
        model.msgid = rsp.msgid;
        [[GYHDMessageCenter sharedInstance] receivePushMsg:model];
//        if ([rsp.msgtype isEqualToString:@"add"]) {
//            // 此时，我作为被加好友的一方，会在好友消息里看到这个好友申请，然后决定同意还是拒绝。
//            if ([self.delegate respondsToSelector:@selector(didReceiveAddedFriendChatMsg:)]) {
//                [self.delegate didReceiveAddedFriendChatMsg:rsp ];
//            }
//        }else if ([rsp.msgtype isEqualToString:@"del"]) {
//            // 此时，我作为被加好友的一方，对方已将我删除，所以我这边应该刷新好友列表，并更新数据库相关的。
//            if ([self.delegate respondsToSelector:@selector(didReceiveDeletedFriendChatMsg:)]) {
//                [self.delegate didReceiveDeletedFriendChatMsg:rsp ];
//            }
//        }else if ([rsp.msgtype isEqualToString:@"agree"]) {
//            // 此时，我作为主动加别人为好友的一方，对方同意加我为好友，我这边应该刷新一下好友列表。
//            if ([self.delegate respondsToSelector:@selector(didReceiveAgreeFriendChatMsg:)]) {
//                [self.delegate didReceiveAgreeFriendChatMsg:rsp ];
//            }
//        }else if ([rsp.msgtype isEqualToString:@"refuse"]) {
//            // 此时，我作为主动加别人为好友的一方，对方同意加我为好友，我这边应该刷新一下好友列表。
//            if ([self.delegate respondsToSelector:@selector(didReceiveRefuseFriendChatMsg:)]) {
//                [self.delegate didReceiveRefuseFriendChatMsg:rsp ];
//            }
//        }

        // 告诉服务器，已经收到消息----------------------------
        ChatMsgAckReq *req = [[[[ChatMsgAckReq builder] setUserid:self.username] setMsgid:rsp.msgid] build];
        
        [self splitProtobufPackageWithData:[req data] tag:CommandIDMsgSessionMessageAck];
        
        // 2.发一个已读消息过去
        ChatMsgReadReq *readReq = [[[[ChatMsgReadReq builder] setUserid:self.username]setMsgid:rsp.msgid]build];
        
        [self splitProtobufPackageWithData:[readReq data] tag:CommandIDMsgSessionMessageReaded];

        
    }else if([rsp.sessiontype isEqualToString:@"p2p"]){// 收到好友即时消息
        
        DDLogInfo(@"*****接收消息成功*****:%@",rsp);
        
        GYHDReceiveMessageModel *model = [[GYHDReceiveMessageModel alloc]init];
        model.fromid = rsp.fromid;
        model.toid = rsp.toid;
        model.content = rsp.content;
        model.msgid = rsp.msgid; 
        model.guid = rsp.guid;
        model.sessionid = @"";
        model.sendtime = [NSString stringWithFormat:@"%lld",rsp.sendtime];
        [[GYHDMessageCenter sharedInstance ] ReceiveMessageModel:model];
        
        // 告诉服务器，已经收到消息----------------------------
        ChatMsgAckReq *req = [[[[ChatMsgAckReq builder] setUserid:self.username] setMsgid:rsp.msgid] build];
        
        [self splitProtobufPackageWithData:[req data] tag:CommandIDMsgSessionMessageAck];
        
        // 2.发一个已读消息过去
        ChatMsgReadReq *readReq = [[[[ChatMsgReadReq builder] setUserid:self.username]setMsgid:rsp.msgid]build];
        
        [self splitProtobufPackageWithData:[readReq data] tag:CommandIDMsgSessionMessageReaded];
    }
    
    
}

#pragma mark - 客服模块
#pragma mark - P2C创建会话
-(void)creatPersonToCompanySessionReqWithSelfCustid:(NSString *)selfCustid entCustid:(NSString *)entCustid companyname:(NSString *)companyname companylogo:(NSString *)companylogo{
    
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
//    [dict setObject:companyname forKey:@"company_name"];
//    [dict setObject:companylogo forKey:@"company_logo"];
    dict[@"company_name"] = kSaftToNSString(companyname);
    dict[@"company_logo"] = kSaftToNSString(companylogo) ;
    NSString*content=[GYUtils dictionaryToString:dict];

    
    CreateP2CSessionReq *req = [[[[[CreateP2CSessionReq builder]setConsumerid:self.username]setEntid:entCustid]setContent:content]build];
    
    [self splitProtobufPackageWithData:[req data]tag:CommandIDP2CCreateReq];
    
}
#pragma mark -P2C响应会话
-(void)createPersonToCompanySuccess:(CreateP2CSessionRsp *)sessionRsp{
    
    NSString*welcomeword=sessionRsp.welcomeword;//欢迎语 utf8编码
    
    P2CSession*session=sessionRsp.session;//会话模型
    
    NSString*customerid=session.consumerid;//消费者id
    
    NSString*kefuid=session.kefuid;//客服id
    
    NSString*sessionid=session.sessionid;//本次会话id
    
    if (self.sessionBlock) {
        
        self.sessionBlock(sessionRsp); //sessionRsp.code为0创建会话成功 , 当为401时 启用对企业留言窗口
    }
    
    GYHDReceiveMessageModel*model=[[GYHDReceiveMessageModel alloc]init];
    model.fromid=kefuid;
    model.toid=customerid;
    NSMutableDictionary *contDict = [NSMutableDictionary dictionary];
    contDict[@"msg_code"] = @"20";
    contDict[@"msg_content"] = welcomeword;
    model.content= [GYUtils dictionaryToString:contDict];
    model.sessionid=sessionid;
    NSDictionary*dict=[GYUtils stringToDictionary:sessionRsp.content];
    model.messageType=@"20";
    model.icon=dict[@"consumer_head"];
    model.name=dict[@"consumer_name"];
    model.sendtime=[NSString stringWithFormat:@"%lld",sessionRsp.resptime];
    [[GYHDMessageCenter sharedInstance ] ReceiveMessageModel:model];
    
    DDLogInfo(@"%@",sessionRsp);
}
#pragma mark -P2C发送消息
-(void)sendMessageToKefuWithSessionid:(NSString*)sessionid guid:(NSString*)guid toid:(NSString*)toid content:(NSString*)content{
    
    P2CMsg*msg=[[[[[[[[[[P2CMsg builder]setSessionid:sessionid]setMsgid:@""]setFromid:self.username]setToid:toid]setContent:content]setSendtime:0]setIsread:NO] setGuid:guid]build];
    
    [self splitProtobufPackageWithData:[msg data] tag:CommandIDP2CMessage];
    
}

#pragma mark -P2C发送成功
-(void)protoBufDidSendP2CMessage:(P2CMsgRsp *)Msg{
    
    if (Msg.code==ResultCodeNoError) {
        
        //    获取消息id更新消息发送状态
        NSString *msgID = Msg.guid;
        
        [[GYHDMessageCenter sharedInstance] updateMessageStateWithMessageID:msgID State:GYHDDataBaseCenterMessageSendStateSuccess];
        NSDictionary* dict = @{ @"msgID" : msgID,
                                @"State" : @(GYHDDataBaseCenterMessageSendStateSuccess) };
        [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:dict];
        
        DDLogInfo(@"*****发送消息成功*****");
        
    }else{
        
        //    获取消息id更新消息发送状态
        NSString *msgID = Msg.guid;
        
        [[GYHDMessageCenter sharedInstance] updateMessageStateWithMessageID:msgID State:GYHDDataBaseCenterMessageSendStateFailure];
        NSDictionary* dict = @{ @"msgID" : msgID,
                                @"State" : @(GYHDDataBaseCenterMessageSendStateFailure) };
        [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:dict];
        
        DDLogInfo(@"*****发送消息失败*****");
    }
    
}

#pragma mark -接收任何消息

- (void)protoBufDidReceiveMessage:(PBGeneratedMessage *)msg {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.receiveMsgBlock) {
            self.receiveMsgBlock(msg);
        }
    });

}

#pragma mark -P2C接收消息

-(void)protoBufDidReceiveP2CMessage:(P2CMsg *)msg{
    
    GYHDReceiveMessageModel*model=[[GYHDReceiveMessageModel alloc]init];
    model.fromid=msg.fromid;
    model.toid=msg.toid;
    model.content=msg.content;
    model.msgid=msg.msgid;
    model.guid=msg.guid;
    model.sessionid=msg.sessionid;
    model.sendtime=[NSString stringWithFormat:@"%lld",msg.sendtime];
    [[GYHDMessageCenter sharedInstance ] ReceiveMessageModel:model];
    // 告诉服务器，已经收到消息----------------------------
    P2CMsgAckReq *req = [[[[P2CMsgAckReq builder] setUserid:self.username] setMsgid:msg.msgid] build];
    
    [self splitProtobufPackageWithData:[req data] tag:CommandIDP2CMessageAckReq];
    // 2.发一个已读消息过去
    P2CMsgReadReq *readReq = [[[[P2CMsgReadReq builder] setUserid:self.username]setMsgid:msg.msgid]build];
    
    [self splitProtobufPackageWithData:[readReq data] tag:CommandIDP2CMessageReadedReq];
    
}

#pragma mark -P2C结束会话
-(void)closePersonToCompanySessionWithUserid:(NSString *)userid entid:(NSString *)entid sessionid:(NSString *)sessionid kefuid:(NSString *)kefuid consumerid:(NSString *)consumerid consumername:(NSString *)consumername consumerhead:(NSString *)consumerhead companyname:(NSString *)companyname companylogo:(NSString *)companylogo{
    
    //    required string      content      = 4;  头像、昵称等信息(json格式 consumer_id,consumer_name,consumer_head,kefu_id,company_name,company_logo)
    
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    
    [dict setObject:consumername forKey:@"consumer_name"];
    [dict setObject:consumerhead forKey:@"consumer_head"];
    [dict setObject:consumerid forKey:@"consumer_id"];
    [dict setObject:kefuid forKey:@"kefu_id"];
    [dict setObject:companyname forKey:@"company_name"];
    [dict setObject:companylogo forKey:@"company_logo"];
    
    NSString*content=[GYUtils dictionaryToString:dict];
    
    P2CSession*session=[[[[[P2CSession builder]setKefuid:kefuid]setSessionid:sessionid]setConsumerid:consumerid]build];
    
    CloseP2CSessionReq* req=[[[[[[CloseP2CSessionReq builder]setSession:session]setEntid:entid]setUserid:userid]setContent:content] build];
    
    [self splitProtobufPackageWithData:[req data] tag:CommandIDP2CCloseReq];
    
}

#pragma mark -P2C结束会话响应

-(void)protoBufCloseP2CSession:(CloseP2CSessionRsp *)sessionRsp{
    
    // 作为一条新消息 发给结束方  缺少fromid
    NSString*time=[NSString stringWithFormat:@"%lld",sessionRsp.resptime];//消息时间
    NSString*userid=sessionRsp.userid; //消息回复对象
    NSString*greeting=sessionRsp.greeting; //结束语 utf8编码
    NSDictionary*dict=[GYUtils stringToDictionary:sessionRsp.content];
    
    if ([dict[@"kefu_id"] isEqualToString:self.username]) {
        //        对于企业而言
        GYHDReceiveMessageModel*model=[[GYHDReceiveMessageModel alloc]init];
        model.fromid=dict[@"consumer_id"];
        model.toid=userid;
        NSMutableDictionary *contDict = [NSMutableDictionary dictionary];
        contDict[@"msg_code"] = @"20";
        contDict[@"msg_content"] = greeting;
        model.content= [GYUtils dictionaryToString:contDict];
        model.sessionid=@"-1";
        model.sendtime=time;
        model.messageType=@"20";
        model.icon=dict[@"consumer_head"];
        model.name=dict[@"consumer_name"];
        model.sendtime=time;
        [[GYHDMessageCenter sharedInstance ] ReceiveMessageModel:model];
        
    }else{
        
        //   于消费者而言
        
        GYHDReceiveMessageModel*model=[[GYHDReceiveMessageModel alloc]init];
        model.fromid=dict[@"kefu_id"];
        model.toid=userid;
        NSMutableDictionary *contDict = [NSMutableDictionary dictionary];
        contDict[@"msg_code"] = @"20";
        contDict[@"msg_content"] = greeting;
        model.content= [GYUtils dictionaryToString:contDict];
 
        model.sessionid=@"-1";
        model.messageType=@"20";
        model.icon=dict[@"company_logo"];
        model.name=dict[@"company_name"];
        model.sendtime=time;
        [[GYHDMessageCenter sharedInstance ] ReceiveMessageModel:model];
        
    }
    
    DDLogInfo(@"%@%@",greeting,sessionRsp);
}

#pragma mark -P2C结束会话响应通知到被结束方
- (void)protoBufCloseP2CSessionToOtherSide:(CloseP2CSessionRsp *)sessionRsp{
    
    // 作为一条新消息 发给被结束方 缺少fromid
    NSString*time=[NSString stringWithFormat:@"%lld",sessionRsp.resptime];//消息时间
    NSString*userid=sessionRsp.userid; //消息回复对象
    NSString*greeting=sessionRsp.greeting; //结束语 utf8编码
    
    NSDictionary*dict=[GYUtils stringToDictionary:sessionRsp.content];
    
    if ([dict[@"kefu_id"] isEqualToString:self.username]) {
        //        于企业而言
        GYHDReceiveMessageModel*model=[[GYHDReceiveMessageModel alloc]init];
        model.fromid=dict[@"consumer_id"];
        model.toid=userid;
        NSMutableDictionary *contDict = [NSMutableDictionary dictionary];
        contDict[@"msg_code"] = @"20";
        contDict[@"msg_content"] = greeting;
        model.content= [GYUtils dictionaryToString:contDict];
        model.sessionid=@"-1";
        model.sendtime=time;
        model.messageType=@"20";
        model.icon=dict[@"consumer_head"];
        model.name=dict[@"consumer_name"];
        model.sendtime=time;
        [[GYHDMessageCenter sharedInstance ] ReceiveMessageModel:model];
        
    }else{
        
        //        于消费者而言
        
        GYHDReceiveMessageModel*model=[[GYHDReceiveMessageModel alloc]init];
        model.fromid=dict[@"kefu_id"];
        model.toid=userid;
        NSMutableDictionary *contDict = [NSMutableDictionary dictionary];
        contDict[@"msg_code"] = @"20";
        contDict[@"msg_content"] = greeting;
        model.content= [GYUtils dictionaryToString:contDict];
        model.sessionid=@"-1";
        model.messageType=@"20";
        model.icon=dict[@"company_logo"];
        model.name=dict[@"company_name"];
        model.sendtime=time;
        [[GYHDMessageCenter sharedInstance ] ReceiveMessageModel:model];
        
    }
    
    DDLogInfo(@"你的对话被结束%@%@",greeting,sessionRsp);
}

#pragma mark -企业客服转移会话

-(void)swicthP2CReqWithConsumerid:(NSString *)consumerid consumername:(NSString *)consumername newkefuid:(NSString *)newkefuid newkefuname:(NSString *)newkefuname oldkefuid:(NSString *)oldkefuid oldkefuname:(NSString *)oldkefuname sessionid:(NSString *)sessionid consumerhead:(NSString *)consumerhead companyname:(NSString *)companyname companylogo:(NSString *)companylogo{
    
    //    content     = 5;  头像、昵称等信息(json格式consumer_name,consumer_head,company_name,company_logo,newkefu_name,oldkefu_name)
    
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    
    [dict setObject:consumername forKey:@"consumer_name"];
    [dict setObject:consumerhead forKey:@"consumer_head"];
    [dict setObject:companyname forKey:@"company_name"];
    [dict setObject:companylogo forKey:@"company_logo"];
    [dict setObject:newkefuname forKey:@"newkefu_name"];
    [dict setObject:oldkefuname forKey:@"oldkefu_name"];
    
    NSString*content=[GYUtils dictionaryToString:dict];
    
    P2CSwitchEntity*entity=[[[[[[[P2CSwitchEntity builder]setConsumerid:consumerid]setNewkefuid:newkefuid]setOldkefuid:oldkefuid]setSessionid:sessionid]setContent:content]build];
    
    SwitchP2CReq*req=[[[[[SwitchP2CReq builder]setElement:entity]setResptime:0]setGreeting:@""]build];//结束语由服务端产生，客户端不传
    [self splitProtobufPackageWithData:[req data] tag:CommandIDP2CSwitchReq];
}

#pragma mark - 服务器响应转移会话
-(void)switchP2CSession:(SwitchP2CRsp *)rsp{
    
    //    此处只是服务器响应转移会话，不代表转移会话成功，需等到新客服回复转移会话之后才算成功
    
    if (rsp.code==ResultCodeNoError) {
        
        DDLogInfo(@"*****服务器响应转移会话成功*****");
        
    }
    
}

#pragma mark - 新客服接收到转移会话并默认同意

-(void)switchP2CReqSessionDidReceive:(SwitchP2CReq *)req{
    
    //   作为一条新的消息发送给新客服
    
    SwitchP2CRsp*rsp=[[[[SwitchP2CRsp builder]setElement:req.element]setCode:0]build];
    
    [self splitProtobufPackageWithData:[rsp data] tag:CommandIDP2CSwitchForwardRsp];
    
    NSString*time=[NSString stringWithFormat:@"%lld",req.resptime];//消息时间
    //    req.element  描述转移客服的元素
    DDLogInfo(@"%@%@",req.greeting,req.element);
    
    GYHDReceiveMessageModel*model=[[GYHDReceiveMessageModel alloc]init];
    model.fromid=req.element.consumerid;
    model.toid=req.element.newkefuid;
    
    NSMutableDictionary *contDict = [NSMutableDictionary dictionary];
    contDict[@"msg_code"] = @"20";
    contDict[@"msg_content"] = req.greeting;
    model.content= [GYUtils dictionaryToString:contDict];
    
    model.sessionid=req.element.sessionid;
    model.sendtime=time;
    NSDictionary*dict=[GYUtils stringToDictionary:req.element.content];
    model.messageType=@"20";
    model.icon=dict[@"consumer_head"];
    model.name=dict[@"consumer_name"];
    [[GYHDMessageCenter sharedInstance ] ReceiveMessageModel:model];
}

#pragma mark - 新客服接收到转移会话通知到消费者和老客服

-(void)switchP2CSessionNotify:(NotifySwitchP2C *)notify{
    
    //   作为一条新的消息发送给消费者和老客服
    
    NSString* greeting=notify.greeting;// 转移提示语,utf8编码
    NSString*time=[NSString stringWithFormat:@"%lld",notify.resptime];//消息时间
    //        notify.element : 描述转移客服的元素
    
    if ([notify.element.consumerid isEqualToString:self.username]) {
        
        //        当前为消费者时需回复接收转移会话 老客服不需要回复 消费者需要更新kefuid和sessionid到数据库便于下次发送消息时传入参数
        
        NotifySwitchP2CRsp*rsp=[[[[NotifySwitchP2CRsp builder]setElement:notify.element]setCode:0]build];
        
        [self splitProtobufPackageWithData:[rsp data] tag:CommandIDP2CNotifySwitchRsp];
        
        GYHDReceiveMessageModel*model=[[GYHDReceiveMessageModel alloc]init];
        model.fromid=notify.element.oldkefuid;
        model.toid=notify.element.consumerid;
        
        NSMutableDictionary *contDict = [NSMutableDictionary dictionary];
        contDict[@"msg_code"] = @"20";
        contDict[@"msg_content"] = notify.greeting;
        model.content= [GYUtils dictionaryToString:contDict];

        model.sessionid=notify.element.sessionid;
        model.sendtime=time;
        NSDictionary*dict=[GYUtils stringToDictionary:notify.element.content];
        model.messageType=@"20";
        model.icon=dict[@"consumer_head"];
        model.name=dict[@"company_logo"];
        [[GYHDMessageCenter sharedInstance ] ReceiveMessageModel:model];
    }else{
        
        //        老客服收到转移对话咨询提示 消费者变更到咨询结束列表 关闭输入框不能进行消息发送了
        
        GYHDReceiveMessageModel*model=[[GYHDReceiveMessageModel alloc]init];
        model.fromid=notify.element.consumerid;
        model.toid=notify.element.oldkefuid;
        model.content=notify.greeting;
        model.sessionid=notify.element.sessionid;
        NSDictionary*dict=[GYUtils stringToDictionary:notify.element.content];
        model.messageType=@"20";
        model.icon=dict[@"consumer_head"];
        model.name=dict[@"consumer_name"];
        model.sendtime=[NSString stringWithFormat:@"%lld",notify.resptime];
        [[GYHDMessageCenter sharedInstance ] ReceiveMessageModel:model];
        
    }
    
    DDLogInfo(@"转移提示语:%@%@",greeting,notify.element);
}

#pragma mark - 消费者给企业发送留言
-(void)LeaveMessageToCompanyWithFromid:(NSString *)fromid entid:(NSString *)entid content:(NSString *)content guid:(NSString *)guid sessionid:(NSString *)sessionid{
    
    P2CLeaveMsgReq*req=[[[[[[[P2CLeaveMsgReq builder]setFromid:fromid]setEntid:entid]setGuid:guid]setContent:content]setSessionid:sessionid]build];
    
    [self splitProtobufPackageWithData:[req data] tag:CommandIDP2CLeaveMsgReq];
}

#pragma mark - 消费者给企业发送留言服务器响应
-(void)leaveMessageDidSendToCompany:(P2CLeaveMsgRsp *)rsp{
    
    if (rsp.code==ResultCodeNoError) {
        
        //    获取消息id更新消息发送状态
        NSString *msgID = rsp.guid;
        
        [[GYHDMessageCenter sharedInstance] updateMessageStateWithMessageID:msgID State:GYHDDataBaseCenterMessageSendStateSuccess];
        NSDictionary* dict = @{ @"msgID" : msgID,
                                @"State" : @(GYHDDataBaseCenterMessageSendStateSuccess) };
        [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:dict];
        
        DDLogInfo(@"*****发送留言成功*****");
        
    }else{
        
        //    获取消息id更新消息发送状态
        NSString *msgID = rsp.guid;
        
        [[GYHDMessageCenter sharedInstance] updateMessageStateWithMessageID:msgID State:GYHDDataBaseCenterMessageSendStateFailure];
        NSDictionary* dict = @{ @"msgID" : msgID,
                                @"State" : @(GYHDDataBaseCenterMessageSendStateFailure) };
        [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:dict];
        
        DDLogInfo(@"*****发送留言失败*****");
    }
}



/**发送离线消息汇总*/
- (void)sendMessageSummary
{
    OfflineMsgSumReq *req = [[[OfflineMsgSumReq builder]setUserid:self.username]build];
    
    [self splitProtobufPackageWithData:[req data] tag:CommandIDHistoryMessageSummary];
}

#pragma mark- 接收离线消息汇总
- (void)protoBufStream:(GYHDStream*)sender didReceiveSummary:(NSArray *)arraySummary
{
    
    for (int i=0; i< arraySummary.count; i++) {
        
        OfflineMsgSum*msgSum=arraySummary[i];
        
        //为减轻服务端压力，此处拉取离线消息的count最多一次拉取20条
        
        if ([msgSum.category isEqualToString:@"p2p"]) {
            //            P2P聊天推送消息
            
            OfflineMsgReq *req=[[[[[[[OfflineMsgReq builder]setCategory:msgSum.category] setFromid:msgSum.fromid] setToid:msgSum.toid] setCount:20] setLastupdate:msgSum.lastupdate]build];
            
            [self splitProtobufPackageWithData:[req data] tag:CommandIDMsgHistoryMessageList];
            
        }else if ([msgSum.category isEqualToString:@"pf"]){
            
            //        推送互生消息类型
            NSString*pushTypeStr=msgSum.fromid;
            
            NSMutableArray *pushTypeListArr=[NSMutableArray array];
            [pushTypeListArr addObject:pushTypeStr];
            
            PfOfflineMsgReq*req=[[[[[[PfOfflineMsgReq builder]setUserid:self.username] setLastupdate:msgSum.lastupdate]setCount:20]setMsgtypelistArray:pushTypeListArr]build];
            
            [self splitProtobufPackageWithData:[req data] tag:CommandIDHsPlatformHistoryMessageList];
            
        }else if ([msgSum.category isEqualToString:@"friend"]){
            //        好友离线消息
            
            
            //            P2P聊天推送消息
            
            OfflineMsgReq *req=[[[[[[[OfflineMsgReq builder]setCategory:msgSum.category] setFromid:msgSum.fromid] setToid:msgSum.toid] setCount:20] setLastupdate:msgSum.lastupdate]build];
            
            [self splitProtobufPackageWithData:[req data] tag:CommandIDMsgHistoryMessageList];
            
            
            
        }else if ([msgSum.category isEqualToString:@"kefu"]){
            //        拉取客服离线
            
            P2COfflineMsgReq*req=[[[[[[[P2COfflineMsgReq builder]setFromid:msgSum.fromid]setToid:msgSum.toid]setCount:20]setCategory:msgSum.category]  setLastupdate:msgSum.lastupdate]build];
            
            [self splitProtobufPackageWithData:[req data] tag:CommandIDP2CHistoryMessageList];
        }
        
    }
    
}


#pragma mark- 接收P2P聊天离线消息列表*/
- (void)protoBufStream:(GYHDStream*)sender didReceiveChatOffLineList:(NSArray *)listArray{
    
    NSMutableArray*msgidList=[NSMutableArray array];
    NSMutableArray*timeList=[NSMutableArray array];
    NSString*toid;
    NSString*msgType;
    NSString*fromid;
    long long lastUpdate;
    if (listArray.count>0) {
        
        for (ChatMsg*msg in listArray) {
            
            [msgidList addObject:msg.msgid];
            [timeList addObject:[NSString stringWithFormat:@"%lld",msg.sendtime]];

            if ([msg.msgtype isEqualToString:@"add"] ||
                [msg.msgtype isEqualToString:@"del"] ||
                [msg.msgtype isEqualToString:@"agree"] ||
                [msg.msgtype isEqualToString:@"refuse"]) {
                GYHDPushMsgModel *model = [[GYHDPushMsgModel alloc] init];
                model.fromid = msg.fromid;
                model.pushtime = [NSString stringWithFormat:@"%lld",msg.sendtime];
                model.toid = msg.toid;
                model.content = msg.content;
                model.msgtype = msg.msgtype;
                model.msgid = msg.msgid;
                [[GYHDMessageCenter sharedInstance] receivePushMsg:model];
            }else {
                GYHDReceiveMessageModel*model=[[GYHDReceiveMessageModel alloc]init];
                model.fromid=msg.fromid;
                model.toid=msg.toid;
                model.content=msg.content;
                model.msgid=msg.msgid;
                model.guid=msg.guid;
                model.sessionid=@"";
                model.sessionType = msg.sessiontype;
                model.sendtime=[NSString stringWithFormat:@"%lld",msg.sendtime];
                [[GYHDMessageCenter sharedInstance ] ReceiveMessageModel:model];
            }
            


            msgType=msg.msgtype;
            toid=msg.toid;
            fromid=msg.fromid;
        }
        //        得到最小的时间-1再次拉取
        long long timeMin=[[timeList valueForKeyPath:@"@min.longLongValue"] longLongValue];
        
        lastUpdate=timeMin-1;
        //        fromid去除m/p/w_
        fromid=[fromid substringFromIndex:2];
        
        OfflineMsgReq *req=[[[[[[[OfflineMsgReq builder]setCategory:@"p2p"] setFromid:fromid] setToid:toid] setCount:20] setLastupdate:lastUpdate]build];
        
        [self splitProtobufPackageWithData:[req data] tag:CommandIDMsgHistoryMessageList];
        
        //    CommandIDMsgHistoryMessageListAck  拉取消息列表回复
        
        NSMutableArray*arr=[msgidList mutableCopy];
        BatchMsgAckReq*ackReq=[[[[BatchMsgAckReq builder]setUserid:self.username]setMsgidlistArray:arr]build];
        
        [self splitProtobufPackageWithData:[ackReq data] tag:CommandIDMsgHistoryMessageListAck];
        
        //    CommandIDMsgHistoryMessageListReaded  回复已读
        NSMutableArray *arr1=[msgidList mutableCopy];
        BatchMsgReadReq*readReq=[[[[BatchMsgReadReq builder]setUserid:self.username]setMsgidlistArray:arr1]build];
        
        [self splitProtobufPackageWithData:[readReq data] tag:CommandIDMsgHistoryMessageListReaded];
    }
}

#pragma mark- 接收P2C聊天离线消息列表*/
- (void)protoBufStream:(GYHDStream *)sender didReceiveP2CChatOffLineList:(NSArray *)listArray{
    
    NSMutableArray*msgidList=[NSMutableArray array];
    NSMutableArray*timeList=[NSMutableArray array];
    NSString*toid;
    NSString*fromid;
    long long lastUpdate;
    
    if (listArray.count>0) {
        
        for (P2CMsg*msg in listArray) {
            
            [msgidList addObject:msg.msgid];
            [timeList addObject:@(msg.sendtime)];
            GYHDReceiveMessageModel*model=[[GYHDReceiveMessageModel alloc]init];
            model.fromid=msg.fromid;
            model.toid=msg.toid;
            model.content=msg.content;
            model.msgid=msg.msgid;
            model.guid=msg.guid;
            model.sessionid=msg.sessionid;
            model.sendtime=[NSString stringWithFormat:@"%lld",msg.sendtime];
            [[GYHDMessageCenter sharedInstance ] ReceiveMessageModel:model];
            toid=msg.toid;
            fromid=msg.fromid;
            
        }
        //        得到最小的时间-1再次拉取
        NSNumber*timeMin=[timeList valueForKeyPath:@"@min.longLongValue"];
        
        lastUpdate=[timeMin longLongValue]-1;
        //        fromid去除m/p/w_
        fromid=[fromid substringFromIndex:2];
        OfflineMsgReq *req=[[[[[[[OfflineMsgReq builder]setCategory:@"kefu"] setFromid:fromid] setToid:toid] setCount:20] setLastupdate:lastUpdate]build];
        
        [self splitProtobufPackageWithData:[req data] tag:CommandIDP2CHistoryMessageList];
        
        
        //    CommandIDP2CHistoryMessageListAck  拉取消息列表回复
        BatchMsgAckReq*ackReq=[[[[BatchMsgAckReq builder]setUserid:self.username]setMsgidlistArray:msgidList]build];
        
        [self splitProtobufPackageWithData:[ackReq data] tag:CommandIDP2CHistoryMessageListAck];
        
        //    CommandIDP2CHistoryMessageListReaded  回复已读
        
        BatchMsgReadReq*readReq=[[[[BatchMsgReadReq builder]setUserid:self.username]setMsgidlistArray:msgidList]build];
        
        [self splitProtobufPackageWithData:[readReq data] tag:CommandIDP2CHistoryMessageListReaded];
    }
    
    
}

#pragma mark- 接收推送平台离线消息列表*/
- (void)protoBufStream:(GYHDStream*)sender didReceivePushOffLineList:(NSArray *)listArray{
    
    
    NSMutableArray*msgidList=[NSMutableArray array];
    NSMutableArray*timeList=[NSMutableArray array];
    NSString*msgtype;
    NSString*toid;
    NSString*fromid;
    long long lastUpdate;
    
    if (listArray.count>0) {
        
        for (ChatMsg*msg in listArray) {
            
            [msgidList addObject:msg.msgid];
            [timeList addObject:@(msg.sendtime)];
            GYHDPushMsgModel*model=[[GYHDPushMsgModel alloc]init];
            
            model.msgid=msg.msgid;
            model.fromid=msg.fromid;
            model.content=msg.content;
            model.toid=msg.toid;
            model.msgtype=msg.msgtype;
            NSDictionary*dict=[GYUtils stringToDictionary:msg.content];
            model.pushtime=dict[@"time"];
            [[GYHDMessageCenter sharedInstance] receivePushMsg:model];
            msgtype=msg.msgtype;
            toid=msg.toid;
            fromid=msg.fromid;
        }
        //        得到最小的时间-1再次拉取
        NSNumber*timeMin=[timeList valueForKeyPath:@"@min.longLongValue"];
        
        lastUpdate=[timeMin longLongValue]-1;
        
        NSString*pushTypeStr=msgtype;
        
        NSMutableArray *pushTypeListArr=[NSMutableArray array];
        
        [pushTypeListArr addObject:pushTypeStr];
        
        NSMutableArray*arr=[msgidList mutableCopy];
        NSMutableArray *arr1=[msgidList mutableCopy];
        
        PfOfflineMsgReq*req=[[[[[[PfOfflineMsgReq builder]setUserid:self.username] setLastupdate:lastUpdate]setCount:20]setMsgtypelistArray:pushTypeListArr]build];
        
        [self splitProtobufPackageWithData:[req data] tag:CommandIDP2CHistoryMessageList];
        
        
        //    CommandIDHsPlatformHistoryMessageListAck  接收推送列表
        
        BatchMsgAckReq*ackReq=[[[[BatchMsgAckReq builder]setUserid:self.username]setMsgidlistArray:arr]build];
        
        [self splitProtobufPackageWithData:[ackReq data] tag:CommandIDHsPlatformHistoryMessageListAck];
        //    CommandIDHsPlatformHistoryMessageListReaded  接收消息列表 已读
        
        BatchMsgReadReq*readReq=[[[[BatchMsgReadReq builder]setUserid:self.username]setMsgidlistArray:arr1]build];
        
        [self splitProtobufPackageWithData:[readReq data] tag:CommandIDHsPlatformHistoryMessageListReaded];
    }
    

    
    
}

#pragma mark-  接收在线推送平台消息列表*/
- (void)protoBufStream:(GYHDStream*)sender didReceivePushOnLineMessage:(pushMsgReq *)pushMsg{
    
    GYHDPushMsgModel*model=[[GYHDPushMsgModel alloc]init];
    
    model.msgid=pushMsg.msgid;
    model.fromid=pushMsg.fromid;
    model.content=pushMsg.content;
    model.toid=pushMsg.toid;
    model.msgtype=pushMsg.msgtype;
    NSDictionary *dict =  [GYUtils stringToDictionary:pushMsg.content];
    model.pushtime = dict[@"time"];
    [[GYHDMessageCenter sharedInstance] receivePushMsg:model];
    
    pushMsgRsp *rsp=[[[[[[pushMsgRsp builder]setMsgid:pushMsg.msgid]setToid:pushMsg.toid]setRead:@"1"]setAck:@"1"]build];
    
    [self splitProtobufPackageWithData:[rsp data] tag:CommandIDBpnMessagePushRsp];
//    
//}
//
//#pragma mark-  拉取消费者对企业留言请求
//- (void)pullOfflineLeaveMessage{
//    
//    P2COfflineLeaveMsgReq*req=[[[[P2COfflineLeaveMsgReq builder]setFromid:self.username]setEntid:globalData.loginModel.custId]build];
//    
//    [self splitProtobufPackageWithData:[req data] tag:CommandIDP2CLeaveMessageList];
//    
//}
//
//#pragma mark- 拉取消费者对企业留言列表
//-(void)pullOfLeaveMessageToCompany:(P2COfflineLeaveMsgRsp *)rsp{
//    
//    DDLogInfo(@"企业留言：%@",rsp.msglist);
//    
//    for (P2CMsg*msg in rsp.msglist) {
//        
//        GYHDReceiveMessageModel*model=[[GYHDReceiveMessageModel alloc]init];
//        model.fromid=msg.fromid;
//        model.toid=msg.toid;
//        model.content=msg.content;
//        model.msgid=msg.msgid;
//        model.guid=msg.guid;
//        model.sessionid=msg.sessionid;
//        model.sendtime=[NSString stringWithFormat:@"%lld",msg.sendtime];
//        [[GYHDMessageCenter sharedInstance ] ReceiveMessageModel:model];
//        
//    }
    
}

/**加好友*/
- (void)addFriendWithFriendID:(NSString *)friendID content:(NSString *)content verify:(NSString *)verify
{
//    AddFriendReq* req = [[[[[AddFriendReq builder] setUserId:self.username] setFriendId:friendID] setVerify:verify]build];
    AddFriendReq *req = [[[[[[AddFriendReq builder] setUserId:self.username] setFriendId:friendID] setContent:content] setVerify:verify] build];
    [self splitProtobufPackageWithData:[req data] tag:CommandIDMsgAddFriendReq];
    

}

/**验证好友*/
- (void)verifyFriendWithFriendID:(NSString *)friendID agree:(int)agree content:(NSString *)content
{
    VerifyFriendReq *req = [[[[[[VerifyFriendReq builder]setUserId:self.username]setFriendId:friendID]setAgree:agree]setContent:content]build];
    
    [self splitProtobufPackageWithData:[req data] tag:CommandIDMsgVerifyFriendReq];
    
    
}

/**删好友*/
- (void)deleteFriendWithFriendID:(NSString *)friendID
{
    DelFriendReq* req = [[[[DelFriendReq builder] setUserId:self.username] setFriendId:friendID]build];
    
    [self splitProtobufPackageWithData:[req data] tag:CommandIDMsgDelFriendReq];
}
/**修改好友备注*/
- (void)modifyFriendWithFriendID:(NSString *)friendID remark:(NSString *)remark
{
    ModifyFriendReq* req = [[[[[ModifyFriendReq builder] setUserId:self.username] setFriendId:friendID] setFriendRemark:remark] build];
    
    [self splitProtobufPackageWithData:[req data] tag:CommandIDMsgModifyFriendReq];
}

/**屏蔽好友*/
- (void)shieldFriendWithFriendID:(NSString *)friendID
{
    ShieldFriendReq* req = [[[[ShieldFriendReq builder] setUserId:self.username] setFriendId:friendID] build];
    
    [self splitProtobufPackageWithData:[req data] tag:CommandIDMsgShieldFriendReq];
}

/**protobuf发送到服务器，都要拼接数据，所以提取为一个公共方法来调用*/
- (void)splitProtobufPackageWithData:(NSData *)data tag:(CommandID)tag
{
    if (!self.isCalledLogin) {
        return;
    }
    
    GYHDProtoBufHeader* buf = [[GYHDProtoBufHeader alloc] init];
    buf.cmd = tag;
    // 拼接成一个完整的包
    NSData* protobufData = [buf dataWithProtobufData:data];
    
//    if (data.length > 2048) {
//        // UI处要提示用户包的内容过长，缩短内容再发。
//        if(self.overBlock){
//            self.overBlock();
//        }
//        
//    }else{
//        // 发送到服务器
//        [self.hdSocket sendMessageWithData:protobufData tag:tag];
//    }
    [self.hdSocket sendMessageWithData:protobufData tag:tag];
    
}

#pragma -mark protobuf的方法
/**连接成功*/
- (void)protoBufStreamDidConnect:(GYHDStream*)sender
{
    
    //    暂时过滤登录直接拉取离线
    
    // 发送离线消息汇总
    [self sendMessageSummary];
    // 请求拉取企业留言
//    [self pullOfflineLeaveMessage];
    
    if ([self.hdSocket isConnect]) {
        if (self.isCalledLogin) {
            LoginReqBuilder *builder = [LoginReq builder];
            LoginReq *req = [[[[[[[[[builder setSCustId:self.loginName] setSLoginToken:globalData.loginModel.token] setNChannelType:self.channelType] setSEntResNo:self.entResNoStr] setBForceLogin:self.isForceLogin] setNDeviceType:self.deviceType] setSDeviceToken:self.deviceToken]setSDeviceVersion:[GYHDMessageCenter sharedInstance].deviceVersion] build];
            
            GYHDProtoBufHeader *buf = [[GYHDProtoBufHeader alloc] init];
            buf.cmd = CommandIDCmCustLogin;
            NSData *data = [buf dataWithProtobufData:[req data]];
            [self.hdSocket sendMessageWithData:data tag:CommandIDCmCustLogin];
            DDLogInfo(@"*****protobufSocket发起链接*****%@",data);
            
            
            if (self.loginBlock) {
                self.loginState = kIMLoginStateConnetToServerSucced;
                self.loginBlock(kIMLoginStateConnetToServerSucced);
            }
            [GYHDMessageCenter sharedInstance].state = GYHDMessageLoginStateConnetToServerSucced;
        }
    }
}

/**连接超时*/
- (void)protoBufStreamConnectDidTimeout:(GYHDStream*)sender
{
    DDLogInfo(@"连接超时");
    
    
    if (self.loginBlock) {
        self.loginState = kIMLoginStateConnetToServerTimeout;
        self.loginBlock(kIMLoginStateConnetToServerTimeout);
    }
    [GYHDMessageCenter sharedInstance].state = GYHDMessageLoginStateConnetToServerTimeout;
    
    //如果外部没登录，就不要重连
    if (!self.isCalledLogin) {
        return;
    }
    
    WS(weakSelf);//Bill
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.hdSocket disconnect];
        [weakSelf setupProtoBufSocket];
    });
}

#pragma mark-  连接失败
- (void)protoBufStreamDidDisconnect:(GYHDStream*)sender withError:(NSError*)error
{
    DDLogInfo(@"******protobufSocket连接失败*******");
    
    
    if (self.loginBlock) {
        self.loginState = kIMLoginStateConnetToServerFailure;
        self.loginBlock(kIMLoginStateConnetToServerFailure);
    }
//    if ([GYHDMessageCenter sharedInstance].state != GYHDMessageLoginStateOtherLogin) {
        [GYHDMessageCenter sharedInstance].state = GYHDMessageLoginStateConnetToServerFailure;
//    }
    
    //如果外部没登录，就不要重连
    if (!self.isCalledLogin) {
        return;
    }
    
    WS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf setupProtoBufSocket];
    });
    
}

- (void)protoBufStreamDidLogined:(GYHDStream *)sender
{// 登录成功
    DDLogInfo(@"******protobufSocket登录成功******%@: %@", THIS_FILE, THIS_METHOD);
    [[GYHDMessageCenter sharedInstance] updateSendingState];
    if (self.loginBlock) {
        self.loginState = kIMLoginStateAuthenticateSucced;
        self.loginBlock(kIMLoginStateAuthenticateSucced);
    }
    [GYHDMessageCenter sharedInstance].state = GYHDMessageLoginStateAuthenticateSucced;
    
    // 发送离线消息汇总
    [self sendMessageSummary];
    
    
}

- (void)protoBufStreamDidLoginedFailure:(GYHDStream*)sender
{
    // 登录失败，通常是用户名和密码错误
    DDLogInfo(@"******protobufSocket登录失败******%@: %@", THIS_FILE, THIS_METHOD);
    if (self.loginBlock) {
        self.loginState = kIMLoginStateAuthenticateFailure;
        self.loginBlock(kIMLoginStateAuthenticateFailure);
    }
    [GYHDMessageCenter sharedInstance].state = GYHDMessageLoginStateAuthenticateFailure;
}

- (void)protoBufStreamDidLogouted:(GYHDStream *)sender
{// 登出成功
    // 2.断开连接
    
    DDLogInfo(@"******protobufSocket断开连接******");
    
    [self.hdSocket disconnect];
}

- (void)protoBufStreamDidLogoutedFailure:(GYHDStream *)sender
{// 登出失败
    
}

- (void)protoBufStreamDidKickouted:(GYHDStream*)sender
{
    // 被踢出登录
    [[GYHSLoginManager shareInstance] clearLoginInfo];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [GYAlertView showMessage:kLocalized(@"请重新登录") cancleButtonTitle:@"取消" confirmButtonTitle:@"立即登录" cancleBlock:^{
            
        } confirmBlock:^{
            
            kCheckLoginedToRoot
        }];
    });

    DDLogInfo(@"呀呀呀呀呀呀哎呀呀呀呀呀");
    DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    DDLogInfo(@"xmpp检测到你的账号在其它设备登录，你将被迫断开xmpp连接");
    globalData.isHdLogined = NO;
    self.isCalledLogin = NO;
    self.loginState = kIMLoginStateOtherLogin;//Bill
    [GYHDMessageCenter sharedInstance].state = GYHDMessageLoginStateOtherLogin;
    
    [self.hdSocket disconnect];//Bill
}



/**发送失败*///此方法暂时没有调用
- (void)protoBufStream:(GYHDStream *)sender didFailToSendMessage:(NSData *)message error:(NSError *)error {
    
    DDLogInfo(@"发送失败:%@", error);
    
    //如果外部没登录，就不要重连
    if (!self.isCalledLogin) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.hdSocket disconnect];
        [self setupProtoBufSocket];
    });
}



/**加好友成功*/
- (void)protoBufStreamDidAddedFriend:(GYHDStream*)sender
{
    
}

/**加好友失败*/
- (void)protoBufStreamDidAddedFriendFailure:(GYHDStream*)sender
{
    
    switch (sender.errorCode) {
        case ResultCodeErrorFriendAlreadyExist:     // 加好友错误,好友已经存在
        case ResultCodeErrorFriendCannotAddYourself:// 加好友错误,不可以自己加自己为好友
        case ResultCodeErrorFriendRquToomuch:       // 加好友错误,超过请求添加好友次数
        case ResultCodeErrorFriendStranger:         // 加好友错误,陌生人,非好友关系
        case ResultCodeErrorFriendIToomuchFriends:  // 加好友错误,您的好友数量已达上限
        case ResultCodeErrorFriendUToomuchFriends:  // 加好友错误,对方好友数量已达上限
        case ResultCodeErrorFriendTeamToomuch:      // 加好友错误,好友分组已达上限
        case ResultCodeErrorFriendTeamAlreadyExsit: // 加好友错误,好友分组已存在
            break;
            
        default:
            break;
    }
}

/**验证好友成功*/
- (void)protoBufStreamDidVerifiedFriend:(GYHDStream*)sender
{
 
}
/**验证好友失败*/
- (void)protoBufStreamDidVerifiedFriendFailure:(GYHDStream*)sender{
    
}


/**删除好友成功*/
- (void)protoBufStreamDidDelFriend:(GYHDStream*)sender
{
    
}
/**删除好友失败*/
- (void)protoBufStreamDidDelFriendFailure:(GYHDStream*)sender{
    
}


/**修改好友资料成功*/
- (void)protoBufStreamDidModifyFriend:(GYHDStream*)sender
{
    
}

/**修改好友资料失败*/
- (void)protoBufStreamDidModifyFriendFailure:(GYHDStream*)sender
{
    
}

/**屏蔽好友资料成功*/
- (void)protoBufStreamDidShieldFriend:(GYHDStream*)sender{
    
}

/**屏蔽好友资料失败*/
- (void)protoBufStreamDidShieldFriendFailure:(GYHDStream*)sender{
    
}
@end
