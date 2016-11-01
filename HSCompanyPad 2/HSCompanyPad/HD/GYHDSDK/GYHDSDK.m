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
#import <CocoaLumberjack/DDTTYLogger.h>
#import  <FMDB/FMDatabase.h>
#import "GYHDMessageCenter.h"
#import "GYDBCenter.h"
#import "GYLoginEn.h"
#import "GYHDPushMsgModel.h"
#import "GYHDReceiveMessageModel.h"
#import "GYLoginHttpTool.h"
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
 *  用户名
 */
@property (nonatomic, copy) NSString *username;
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
@property (nonatomic, strong, readonly) FMDatabase *imFMDB;
@property(nonatomic, strong)GYHDDataBaseCenter *dataBaseCenter;
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

-(GYHDDataBaseCenter *)dataBaseCenter{
    
    if (!_dataBaseCenter) {
        _dataBaseCenter = [GYHDDataBaseCenter sharedInstance];
        
    }
    return _dataBaseCenter;
}

#pragma -mark
- (instancetype)init
{
    
    if (self = [super init]) {
        //初始化hdSocket，会在登录的时候使用到。而且链接服务器也需要用hdSocket，所以重写init方法，让该类的对象一开始创建的时候就把通信管道铺好，这样就可以直接使用其功能
        self.isCalledLogin = NO;
        self.isForceLogin = YES;
        self.connectTimeout = 15.f;
        
        self.domainString = @"im.gy.com";
        self.resource = @"mobile_im";
        
        //本地回环地址，公司的hostName；
        self.hostName = @"192.168.41.193";
        //设置端口号（让服务器知道你是哪一个app）
        self.hostPort = 5222;
        
    }
    return self;
}
#pragma mark-  连接socket，并登录。本类内不允许调用这个方法。
- (void)loginWithChannelType:(UInt32)channelType
                  DeviceType:(UInt32)deviceType
                 entResNoStr:(NSString *)entResNoStr
                 deviceToken:(NSString *)deviceToken
                       block:(LoginBlock)block
{
    self.isCalledLogin = YES;
    //1、为关键的几个属性赋值
    self.channelType = channelType;
    self.entResNoStr = entResNoStr;
    self.deviceType = deviceType;
    self.deviceToken = deviceToken;
    
    //2、初始化username，登录用loginName，其他诸如加好友、发消息，用username

    self.username = [NSString stringWithFormat:@"e_%@", globalData.loginModel.custId];

    self.loginName = self.username;
    
    // 配合后台 加上 m_ /p_
    switch (self.deviceType) {
        case IMDeviceTypeIOSMobile:// 手机
            self.username = [NSString stringWithFormat:@"m_%@", self.username];
            break;
        case IMDeviceTypeIOSPad:// iOS平板
            self.username=[NSString stringWithFormat:@"p_%@", self.username];
            break;
        default:
            break;
    }

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

    //检查及创建数据库
    NSString *dbFullName = [GYDBCenter getUserDBNameInDirectory:self.username];
    if (![GYDBCenter fileIsExists:dbFullName])
    {
        DDLogCInfo(@"用户数据库不存在，将创建");
        if (![GYDBCenter createFile:dbFullName])
        {
            return;
            
        }
    }
    DDLogCInfo(@"im数据库完整路径:%@", dbFullName);
    _imFMDB = [[FMDatabase alloc] initWithPath:dbFullName];
    
    [self.dataBaseCenter savedbFull:dbFullName];
    
    DDLogInfo(@"im数据库完整路径:%@", dbFullName);

}

#pragma mark- protobuf 登录*/
- (void)setupProtoBufSocket
{
    
    self.hdSocket = [[GYHDProtoBufSocket alloc] init];
    self.hdSocket.delegate = self;
    GYHDStream *stream = [[GYHDStream alloc] init];
    NSString *imUrl = globalData.loginModel.ttMsgServer;
    
    if ([GYLoginEn sharedInstance].loginLine == kLoginEn_dev) {
        
//                stream.hostName = [imUrl componentsSeparatedByString:@":"].firstObject;
//                stream.hostPort = [imUrl componentsSeparatedByString:@":"].lastObject.integerValue;

        stream.hostName = @"192.168.229.139";
        stream.hostPort = 13000;
 
    } else {
        
                stream.hostName = [imUrl componentsSeparatedByString:@":"].firstObject;
                stream.hostPort = [imUrl componentsSeparatedByString:@":"].lastObject.integerValue;
        
//        stream.hostName = @"192.168.233.139";
//        stream.hostPort = 13000;
    }
    
    [self.hdSocket setloginStream:stream];
}

#pragma mark- 重复登录*/
- (void)protoBufStreamReLogined:(GYHDStream*)sender
{
    if (self.isForceLogin) {//强制登录下，遇到重登录警告，不需重新登录
        
    }else{
        
    }
}

#pragma mark- 退出登录
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
    
    ChatMsg *chat = [[[[[[[[[[[[ChatMsg builder]setMsgid:@""]setFromid:self.username]setToid:kSaftToNSString(friendID)]setSessiontype:@"p2p"]setMsgtype:@"e2e"]setSendtime:0]setContent:kSaftToNSString(content)]setContenttype:@"00"]setIsreaded:NO]setGuid:kSaftToNSString(guid)]build];
  
    DDLogInfo(@"*****发送消息内容*****:%@",content);
    [self updateMessageStateWithGuid:guid];
    
    [self splitProtobufPackageWithData:[chat data] tag:CommandIDMsgSessionMessage];
    
}

#pragma mark- 发送消息后15秒未发送成功*/
- (void)protoBufStream:(GYHDStream*)sender didSendMessageTimeOutWithGuid:(NSString*)guid {
    
    //    获取消息id更新消息发送状态
    NSString *msgID = guid;
    
    [self.dataBaseCenter updateMessageStateWithMessageID:msgID State:GYHDDataBaseCenterMessageSendStateFailure];
    NSDictionary* dict = @{ @"msgID" : msgID,
                            @"State" : @(GYHDDataBaseCenterMessageSendStateFailure) };
    [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:dict];
    
    
    DDLogInfo(@"*****发送消息失败*****");
    
}

#pragma mark - 判定用户登录状态更新消息状态

-(void)updateMessageStateWithGuid:(NSString*)guid{


    
    if (self.loginState!=kIMLoginStateAuthenticateSucced) {
        
        //    获取消息id更新消息发送状态
        NSString *msgID = guid;
        
        [self.dataBaseCenter updateMessageStateWithMessageID:msgID State:GYHDDataBaseCenterMessageSendStateFailure];
        NSDictionary* dict = @{ @"msgID" : msgID,
                                @"State" : @(GYHDDataBaseCenterMessageSendStateFailure) };
        [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:dict];
        
        
        DDLogInfo(@"*****发送消息失败*****");
    }else{
        
        [self.hdSocket sendMsgStartCounterWithGuid:guid];
        
    }


}

#pragma mark- P2P消息发送成功*/
- (void)protoBufStreamDidSendMessage:(GYHDStream*)sender chatMsg:(ChatMsgRsp *)chatMsg{
    
    
    if (chatMsg.code==ResultCodeNoError) {
        
        //    获取消息id更新消息发送状态
        NSString *msgID = chatMsg.guid;
        
        [self.dataBaseCenter updateMessageStateWithMessageID:msgID State:GYHDDataBaseCenterMessageSendStateSuccess];
        NSDictionary* dict = @{ @"msgID" : msgID,
                                @"State" : @(GYHDDataBaseCenterMessageSendStateSuccess) };
        [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:dict];
        
        [self.hdSocket removeWitingMsgWithGuid:msgID];
        DDLogInfo(@"*****发送消息成功*****");
        
    }else{
    
        //    获取消息id更新消息发送状态
        NSString *msgID = chatMsg.guid;
        
        [self.dataBaseCenter updateMessageStateWithMessageID:msgID State:GYHDDataBaseCenterMessageSendStateFailure];
        NSDictionary* dict = @{ @"msgID" : msgID,
                                @"State" : @(GYHDDataBaseCenterMessageSendStateFailure) };
        [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:dict];
        
        
        DDLogInfo(@"*****发送消息失败*****");
    }

}

#pragma mark- P2P接收消息*/
- (void)protoBufStream:(GYHDStream *)sender didReceiveMessage:(NSData *)message {
    // 1.发一个已经接收到的消息过去
    ChatMsg *msg = [ChatMsg parseFromData:message];
    /**
     msgid: 57c7d16107dd2023412c8df5
     fromid: m_e_0603211000012340000
     toid: p_e_0603211000000260000
     sessiontype: p2p
     msgtype: e2e
     sendtime: 1472713057078
     content: {"msg_code":"00","sub_msg_code":"10101","msg_type":"2","msg_icon":"http:\/\/192.168.229.27:8080\/hsi-fs-server\/fs\/download\/F00Sn4BD37a24A436A2be7B3eeceVH","msg_note":"zhangx","msg_content":"11111"}
     contenttype: 00
     isreaded: 0
     */
     DDLogInfo(@"*****接收消息成功*****:%@",msg);
    
    GYHDReceiveMessageModel*model=[[GYHDReceiveMessageModel alloc]init];
    model.fromid=msg.fromid;
    model.toid=msg.toid;
    model.content=msg.content;
    model.msgid=msg.msgid;
    model.guid=msg.guid;
    model.sessionid=@"";
    model.sendtime=[NSString stringWithFormat:@"%lld",msg.sendtime];
    [[GYHDMessageCenter sharedInstance ] ReceiveMessageModel:model];
    
    // 告诉服务器，已经收到消息----------------------------
    ChatMsgAckReq *req = [[[[ChatMsgAckReq builder] setUserid:self.username] setMsgid:msg.msgid] build];
    
    [self splitProtobufPackageWithData:[req data] tag:CommandIDMsgSessionMessageAck];
    
    // 2.发一个已读消息过去
    ChatMsgReadReq *readReq = [[[[ChatMsgReadReq builder] setUserid:self.username]setMsgid:msg.msgid]build];
    
    [self splitProtobufPackageWithData:[readReq data] tag:CommandIDMsgSessionMessageReaded];
}

#pragma mark - 客服模块
#pragma mark - P2C创建会话
-(void)creatPersonToCompanySessionReqWithSelfCustid:(NSString *)selfCustid entCustid:(NSString *)entCustid companyname:(NSString *)companyname companylogo:(NSString *)companylogo{
    
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    [dict setObject:kSaftToNSString(companyname) forKey:@"company_name"];
    [dict setObject:kSaftToNSString(companylogo) forKey:@"company_logo"];
    NSString*content=[GYHDUtils dictionaryToString:dict];
    
    CreateP2CSessionReq*req=[[[[[CreateP2CSessionReq builder]setConsumerid:kSaftToNSString(selfCustid)]setEntid:kSaftToNSString(entCustid)]setContent:kSaftToNSString(content)]build];
    
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
    model.content=welcomeword;
    model.sessionid=sessionid;
    NSDictionary*dict=[GYHDUtils stringToDictionary:sessionRsp.content];
    model.messageType=@"20";
    model.icon=dict[@"consumer_head"];
    model.name=dict[@"consumer_name"];
    model.sendtime=[NSString stringWithFormat:@"%lld",sessionRsp.resptime];
    [[GYHDMessageCenter sharedInstance ] ReceiveMessageModel:model];
    
    DDLogInfo(@"%@",sessionRsp);
}
#pragma mark -P2C发送消息
-(void)sendMessageToKefuWithSessionid:(NSString*)sessionid guid:(NSString*)guid toid:(NSString*)toid content:(NSString*)content{

    P2CMsg*msg=[[[[[[[[[[P2CMsg builder]setSessionid:kSaftToNSString(sessionid) ]setMsgid:@""]setFromid:self.username]setGuid:kSaftToNSString(guid)] setToid:toid]setContent:kSaftToNSString(content)]setSendtime:0]setIsread:NO]build];
    
    DDLogInfo(@"*****发送消息内容*****:%@",content);
    
    [self updateMessageStateWithGuid:guid];
    
    [self splitProtobufPackageWithData:[msg data] tag:CommandIDP2CMessage];
    
    
}

#pragma mark -P2C发送成功
-(void)protoBufDidSendP2CMessage:(P2CMsgRsp *)Msg{
    
    if (Msg.code==ResultCodeNoError) {
        
        //    获取消息id更新消息发送状态
        NSString *msgID = Msg.guid;
        
        [self.dataBaseCenter updateMessageStateWithMessageID:msgID State:GYHDDataBaseCenterMessageSendStateSuccess];
        NSDictionary* dict = @{ @"msgID" : msgID,
                                @"State" : @(GYHDDataBaseCenterMessageSendStateSuccess) };
        [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:dict];
        
        [self.hdSocket removeWitingMsgWithGuid:msgID];
        
        DDLogInfo(@"*****发送消息成功*****");
        
    }else{
        
        //    获取消息id更新消息发送状态
        NSString *msgID = Msg.guid;
        
        [self.dataBaseCenter updateMessageStateWithMessageID:msgID State:GYHDDataBaseCenterMessageSendStateFailure];
        NSDictionary* dict = @{ @"msgID" : msgID,
                                @"State" : @(GYHDDataBaseCenterMessageSendStateFailure) };
        [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:dict];
        
        DDLogInfo(@"*****发送消息失败*****");
    }

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
    
    [dict setObject:kSaftToNSString(consumername)  forKey:@"consumer_name"];
    [dict setObject:kSaftToNSString(consumerhead) forKey:@"consumer_head"];
    [dict setObject:kSaftToNSString(consumerid) forKey:@"consumer_id"];
    [dict setObject:kSaftToNSString(kefuid)forKey:@"kefu_id"];
    [dict setObject:kSaftToNSString(companyname) forKey:@"company_name"];
    [dict setObject:kSaftToNSString(companylogo) forKey:@"company_logo"];
    
    NSString*content=[GYHDUtils dictionaryToString:dict];
    
    P2CSession*session=[[[[[P2CSession builder]setKefuid:kSaftToNSString(kefuid)]setSessionid:kSaftToNSString(sessionid)]setConsumerid:kSaftToNSString(consumerid)]build];
    
    CloseP2CSessionReq* req=[[[[[[CloseP2CSessionReq builder]setSession:session]setEntid:kSaftToNSString(entid)]setUserid:kSaftToNSString(userid)]setContent:kSaftToNSString(content)] build];
    
    [self splitProtobufPackageWithData:[req data] tag:CommandIDP2CCloseReq];
    
    DDLogInfo(@"*****企业客服结束会话参数:%@*****",req);
    
}

#pragma mark -P2C结束会话响应

-(void)protoBufCloseP2CSession:(CloseP2CSessionRsp *)sessionRsp{

    // 作为一条新消息 发给结束方
    NSString*time=[NSString stringWithFormat:@"%lld",sessionRsp.resptime];//消息时间
    NSString*userid=sessionRsp.userid; //消息回复对象
    NSString*greeting=sessionRsp.greeting; //结束语 utf8编码
    NSDictionary*dict=[GYHDUtils stringToDictionary:sessionRsp.content];
    
    if ([userid isEqualToString:self.username]) {
//        对于企业而言
        GYHDReceiveMessageModel*model=[[GYHDReceiveMessageModel alloc]init];
        model.fromid=dict[@"consumer_id"];
        model.toid=userid;
        if (greeting.length>0) {
            
            model.content=greeting;
            
        }else{
            
            model.content=kLocalized(@"GYHD_EndGreeting") ;
        }
        
        model.sessionid=@"-1";
        model.sendtime=time;
        model.messageType=@"20";
        model.icon=dict[@"consumer_head"];
        model.name=dict[@"consumer_name"];
        model.sendtime=time;
        
        if ( model.fromid.length>0) {
            
            [[GYHDMessageCenter sharedInstance ] ReceiveMessageModel:model];
        }
        
    }else{
        
        //   于消费者而言
        
        GYHDReceiveMessageModel*model=[[GYHDReceiveMessageModel alloc]init];
        model.fromid=dict[@"kefu_id"];
        model.toid=userid;
        model.content=greeting;
        model.sessionid=@"-1";
        model.messageType=@"20";
        model.icon=dict[@"company_logo"];
        model.name=dict[@"company_name"];
        model.sendtime=time;
        if ( model.fromid.length>0) {
            
            [[GYHDMessageCenter sharedInstance ] ReceiveMessageModel:model];
        }
        
    }

    DDLogInfo(@"%@%@",greeting,sessionRsp);
}

#pragma mark -P2C结束会话响应通知到被结束方
- (void)protoBufCloseP2CSessionToOtherSide:(CloseP2CSessionRsp *)sessionRsp{

    // 作为一条新消息 发给被结束方
    NSString*time=[NSString stringWithFormat:@"%lld",sessionRsp.resptime];//消息时间
    NSString*userid=sessionRsp.userid; //消息回复对象
    NSString*greeting=sessionRsp.greeting; //结束语 utf8编码
    
    NSDictionary*dict=[GYHDUtils stringToDictionary:sessionRsp.content];
    
    if ([userid isEqualToString:self.username]) {
        //        于企业而言
        GYHDReceiveMessageModel*model=[[GYHDReceiveMessageModel alloc]init];
        model.fromid=dict[@"consumer_id"];
        model.toid=userid;
        if (greeting.length>0) {
            
            model.content=greeting;
            
        }else{
            
           model.content=kLocalized(@"GYHD_EndGreeting_Other");
        }
        
        model.sessionid=@"-1";
        model.sendtime=time;
        model.messageType=@"20";
        model.icon=dict[@"consumer_head"];
        model.name=dict[@"consumer_name"];
        model.sendtime=time;
        
        if ( model.fromid.length>0) {
            
            [[GYHDMessageCenter sharedInstance ] ReceiveMessageModel:model];
        }
        
    }else{
        
        //        于消费者而言
        
        GYHDReceiveMessageModel*model=[[GYHDReceiveMessageModel alloc]init];
        model.fromid=dict[@"kefu_id"];
        model.toid=userid;
        model.content=greeting;
        model.sessionid=@"-1";
        model.messageType=@"20";
        model.icon=dict[@"company_logo"];
        model.name=dict[@"company_name"];
        model.sendtime=time;
        
        if ( model.fromid.length>0) {
            
            [[GYHDMessageCenter sharedInstance ] ReceiveMessageModel:model];
        }
        
    }

    DDLogInfo(@"你的对话被结束%@%@",greeting,sessionRsp);
}

#pragma mark -企业客服转移会话

-(void)swicthP2CReqWithConsumerid:(NSString *)consumerid consumername:(NSString *)consumername newkefuid:(NSString *)newkefuid newkefuname:(NSString *)newkefuname oldkefuid:(NSString *)oldkefuid oldkefuname:(NSString *)oldkefuname sessionid:(NSString *)sessionid consumerhead:(NSString *)consumerhead companyname:(NSString *)companyname companylogo:(NSString *)companylogo{
    
//    content     = 5;  头像、昵称等信息(json格式consumer_name,consumer_head,company_name,company_logo,newkefu_name,oldkefu_name)
    
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    
    [dict setObject:kSaftToNSString(consumername)  forKey:@"consumer_name"];
    [dict setObject:kSaftToNSString(consumerhead)  forKey:@"consumer_head"];
    [dict setObject:kSaftToNSString(companyname)  forKey:@"company_name"];
    [dict setObject:kSaftToNSString(companylogo)  forKey:@"company_logo"];
    [dict setObject:kSaftToNSString(newkefuname)  forKey:@"newkefu_name"];
    [dict setObject:kSaftToNSString(oldkefuname)  forKey:@"oldkefu_name"];
    
    NSString*content=[GYHDUtils dictionaryToString:dict];
    
    P2CSwitchEntity*entity=[[[[[[[P2CSwitchEntity builder]setConsumerid:kSaftToNSString(consumerid)]setNewkefuid:kSaftToNSString(newkefuid)]setOldkefuid:kSaftToNSString(oldkefuid)]setSessionid:kSaftToNSString(sessionid)]setContent:kSaftToNSString(content)]build];

    SwitchP2CReq*req=[[[[[SwitchP2CReq builder]setElement:entity]setResptime:0]setGreeting:@""]build];//结束语由服务端产生，客户端不传
    [self splitProtobufPackageWithData:[req data] tag:CommandIDP2CSwitchReq];
    
      DDLogInfo(@"*****企业客服转移会话转移参数:%@*****",req);
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
    NSString*kefuStr=req.element.oldkefuid;
    kefuStr=[kefuStr substringWithRange:NSMakeRange(15, 4)];
    model.content=[NSString stringWithFormat:@"%@%@%@",kLocalized(@"GYHD_HaveOneSession"),kefuStr,kLocalized(@"GYHD_SessionSwitch")];
    model.sessionid=req.element.sessionid;
    model.sendtime=time;
    NSDictionary*dict=[GYHDUtils stringToDictionary:req.element.content];
    model.messageType=@"20";
    model.icon=dict[@"consumer_head"];
    model.name=dict[@"consumer_name"];
    
    if ( model.fromid.length>0) {
        
        [[GYHDMessageCenter sharedInstance ] ReceiveMessageModel:model];
    }
    
}

#pragma mark - 新客服接收到转移会话通知到消费者和老客服

-(void)switchP2CSessionNotify:(NotifySwitchP2C *)notify{
    
    //   作为一条新的消息发送给消费者和老客服
    
    NSString*time=[NSString stringWithFormat:@"%lld",notify.resptime];//消息时间
//        notify.element : 描述转移客服的元素
    
    if ([notify.element.consumerid isEqualToString:self.username]) {
        
//        当前为消费者时需回复接收转移会话 老客服不需要回复 消费者需要更新kefuid和sessionid到数据库便于下次发送消息时传入参数
        
        NotifySwitchP2CRsp*rsp=[[[[NotifySwitchP2CRsp builder]setElement:notify.element]setCode:0]build];
        
        [self splitProtobufPackageWithData:[rsp data] tag:CommandIDP2CNotifySwitchRsp];
    
        GYHDReceiveMessageModel*model=[[GYHDReceiveMessageModel alloc]init];
        model.fromid=notify.element.consumerid;
        model.toid=notify.element.oldkefuid;
        model.content=notify.greeting;
        model.sessionid=notify.element.sessionid;
        model.sendtime=time;
        NSDictionary*dict=[GYHDUtils stringToDictionary:notify.element.content];
        model.messageType=@"20";
        model.icon=dict[@"company_name"];
        model.name=dict[@"company_logo"];
        
        if ( model.fromid.length>0) {
            
            [[GYHDMessageCenter sharedInstance ] ReceiveMessageModel:model];
        }
    }else{
        
//        老客服收到转移对话咨询提示 消费者变更到咨询结束列表 关闭输入框不能进行消息发送了
        
        GYHDReceiveMessageModel*model=[[GYHDReceiveMessageModel alloc]init];
        model.fromid=notify.element.consumerid;
        model.toid=notify.element.oldkefuid;
        NSString*kefuStr=notify.element.newkefuid;
        kefuStr=[kefuStr substringWithRange:NSMakeRange(15, 4)];
        model.content=[NSString stringWithFormat:@"%@%@",kLocalized(@"GYHD_SessionSwitch_CustomerService"),kefuStr];
        model.sessionid=@"-1";
        NSDictionary*dict=[GYHDUtils stringToDictionary:notify.element.content];
        model.messageType=@"20";
        model.icon=dict[@"consumer_head"];
        model.name=dict[@"consumer_name"];
        model.sendtime=[NSString stringWithFormat:@"%lld",notify.resptime];
        
        if ( model.fromid.length>0) {
            
            [[GYHDMessageCenter sharedInstance ] ReceiveMessageModel:model];
        }
    
    }
}

#pragma mark - 消费者给企业发送留言
-(void)LeaveMessageToCompanyWithFromid:(NSString *)fromid entid:(NSString *)entid content:(NSString *)content guid:(NSString *)guid sessionid:(NSString *)sessionid{

     P2CLeaveMsgReq*req=[[[[[[[P2CLeaveMsgReq builder]setFromid:kSaftToNSString(fromid) ]setEntid:kSaftToNSString(entid)]setGuid:kSaftToNSString(guid)]setContent:kSaftToNSString(content)]setSessionid:kSaftToNSString(sessionid)]build];
    
    [self splitProtobufPackageWithData:[req data] tag:CommandIDP2CLeaveMsgReq];
}

#pragma mark - 消费者给企业发送留言服务器响应
-(void)leaveMessageDidSendToCompany:(P2CLeaveMsgRsp *)rsp{

    if (rsp.code==ResultCodeNoError) {
        
        //    获取消息id更新消息发送状态
        NSString *msgID = rsp.guid;
        
        [self.dataBaseCenter updateMessageStateWithMessageID:msgID State:GYHDDataBaseCenterMessageSendStateSuccess];
        NSDictionary* dict = @{ @"msgID" : msgID,
                                @"State" : @(GYHDDataBaseCenterMessageSendStateSuccess) };
        [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:dict];
        
        DDLogInfo(@"*****发送留言成功*****");
        
    }else{
        
        //    获取消息id更新消息发送状态
        NSString *msgID = rsp.guid;
        
        [self.dataBaseCenter updateMessageStateWithMessageID:msgID State:GYHDDataBaseCenterMessageSendStateFailure];
        NSDictionary* dict = @{ @"msgID" : msgID,
                                @"State" : @(GYHDDataBaseCenterMessageSendStateFailure) };
        [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:dict];
        
        DDLogInfo(@"*****发送留言失败*****");
    }
}


#pragma mark- 发送离线消息汇总请求*/
- (void)sendMessageSummary
{
    OfflineMsgSumReq *req = [[[OfflineMsgSumReq builder]setUserid:self.username]build];
    
    [self splitProtobufPackageWithData:[req data] tag:CommandIDHistoryMessageSummary];
}


#pragma mark- 接收离线消息汇总*/
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
    NSString*fromid;
    long long lastUpdate;
    if (listArray.count>0) {
    
        for (ChatMsg*msg in listArray) {
            
            [msgidList addObject:msg.msgid];
            [timeList addObject:[NSString stringWithFormat:@"%lld",msg.sendtime]];
            GYHDReceiveMessageModel*model=[[GYHDReceiveMessageModel alloc]init];
            model.fromid=msg.fromid;
            model.toid=msg.toid;
            model.content=msg.content;
            model.msgid=msg.msgid;
            model.guid=msg.guid;
            model.sessionid=@"";
            model.sendtime=[NSString stringWithFormat:@"%lld",msg.sendtime];
            [[GYHDMessageCenter sharedInstance ] ReceiveMessageModel:model];
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
        
        NSMutableArray*arr=[msgidList mutableCopy];
        NSMutableArray *arr1=[msgidList mutableCopy];
        //        得到最小的时间-1再次拉取
        NSNumber*timeMin=[timeList valueForKeyPath:@"@min.longLongValue"];
        
        lastUpdate=[timeMin longLongValue]-1;
        //        fromid去除m/p/w_
        fromid=[fromid substringFromIndex:2];

        P2COfflineMsgReq*req=[[[[[[[P2COfflineMsgReq builder]setFromid:fromid]setToid:toid]setCount:20]setCategory:@"kefu"] setLastupdate:lastUpdate]build];

        [self splitProtobufPackageWithData:[req data] tag:CommandIDP2CHistoryMessageList];
        
        //    CommandIDP2CHistoryMessageListAck  拉取消息列表回复
        BatchMsgAckReq*ackReq=[[[[BatchMsgAckReq builder]setUserid:self.username]setMsgidlistArray:arr]build];
        
        [self splitProtobufPackageWithData:[ackReq data] tag:CommandIDP2CHistoryMessageListAck];
        
        //    CommandIDP2CHistoryMessageListReaded  回复已读
        
        BatchMsgReadReq*readReq=[[[[BatchMsgReadReq builder]setUserid:self.username]setMsgidlistArray:arr1]build];
        
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
            NSDictionary*dict=[GYHDUtils stringToDictionary:msg.content];
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
    NSDictionary*dict=[GYHDUtils stringToDictionary:pushMsg.content];
    model.pushtime=dict[@"time"];
    [[GYHDMessageCenter sharedInstance] receivePushMsg:model];

    pushMsgRsp *rsp=[[[[[[pushMsgRsp builder]setMsgid:pushMsg.msgid]setToid:pushMsg.toid]setRead:@"1"]setAck:@"1"]build];
    
    [self splitProtobufPackageWithData:[rsp data] tag:CommandIDBpnMessagePushRsp];
    
}

#pragma mark-  protobuf发送到服务器，都要拼接数据，所以提取为一个公共方法来调用*/
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
//        if (self.overBlock) {
//
//            self.overBlock();
//        }
//
//    }else{
        // 发送到服务器
        [self.hdSocket sendMessageWithData:protobufData tag:tag];
//    }
    
}

#pragma mark-  连接成功登录protobuf*/
- (void)protoBufStreamDidConnect:(GYHDStream*)sender
{
    
    if ([self.hdSocket isConnect]) {
        if (self.isCalledLogin) {
            LoginReqBuilder *builder = [LoginReq builder];
            LoginReq *req = [[[[[[[[[builder setSCustId:self.loginName] setSLoginToken:globalData.loginModel.token] setNChannelType:IMChannelTypeHSPad] setSEntResNo:globalData.loginModel.entResNo] setBForceLogin:YES] setNDeviceType:IMDeviceTypeIOSPad] setSDeviceToken:self.deviceToken]setSDeviceVersion:[GYHDMessageCenter sharedInstance].deviceVersion] build];
            
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

#pragma mark-  连接超时*/
- (void)protoBufStreamConnectDidTimeout:(GYHDStream*)sender
{
    
    DDLogInfo(@"**********protobufSocket连接超时***********");
    
    if (self.loginBlock) {
        self.loginState = kIMLoginStateConnetToServerTimeout;
        self.loginBlock(kIMLoginStateConnetToServerTimeout);
    }
    [GYHDMessageCenter sharedInstance].state = GYHDMessageLoginStateConnetToServerTimeout;
    
    //如果外部没登录，就不要重连
    if (!self.isCalledLogin) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.hdSocket disconnect];
        [self setupProtoBufSocket];
    });
}

#pragma mark-  连接失败*/
- (void)protoBufStreamDidDisconnect:(GYHDStream*)sender withError:(NSError*)error
{
    
    DDLogInfo(@"******protobufSocket连接失败*******");
    
    
    if (self.loginBlock) {
        self.loginState = kIMLoginStateConnetToServerFailure;
        self.loginBlock(kIMLoginStateConnetToServerFailure);
    }
    if ([GYHDMessageCenter sharedInstance].state != GYHDMessageLoginStateOtherLogin) {
        [GYHDMessageCenter sharedInstance].state = GYHDMessageLoginStateConnetToServerFailure;
    }
    
    //如果外部没登录，就不要重连
    if (!self.isCalledLogin) {
        return;
    }
    
    WS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf setupProtoBufSocket];
    });
    
}

#pragma mark-  登录成功
- (void)protoBufStreamDidLogined:(GYHDStream *)sender
{// 登录成功
    
     DDLogInfo(@"******protobufSocket登录成功******%@: %@", THIS_FILE, THIS_METHOD);
    [[GYHDMessageCenter sharedInstance] updateSendingState];
    if (self.loginBlock) {
        self.loginState = kIMLoginStateAuthenticateSucced;
        self.loginBlock(kIMLoginStateAuthenticateSucced);
    }
    [GYHDMessageCenter sharedInstance].state = GYHDMessageLoginStateAuthenticateSucced;
    
//    请求分配企业留言成功后 发出拉取离线消息汇总
    AssignP2CLeaveMsgReq*req=[[[[AssignP2CLeaveMsgReq builder]setEntid:globalData.loginModel.entCustId]setFromid:self.username]build];
     [self splitProtobufPackageWithData:[req data] tag:CommandIDP2CAssignLeaveMessage];
    
}

#pragma mark- 响应分配企业留言
-(void)pullOfLeaveMessageToCompany:(AssignP2CLeaveMsgRsp *)rsp{
    
    if (rsp.code==ResultCodeNoError) {
        
        //    发送离线消息汇总
        [self sendMessageSummary];
    }else if (rsp.code==ResultCodeErrorP2CWithoutKefuPermission){
    
//    无客服权限
        //    发送离线消息汇总
        [self sendMessageSummary];

    }

}


#pragma mark-  登录失败
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

#pragma mark- 断开连接
- (void)protoBufStreamDidLogouted:(GYHDStream *)sender
{// 登出成功
    // 2.断开连接
     DDLogInfo(@"******protobufSocket断开连接******");
    
    [self.hdSocket disconnect];
}

- (void)protoBufStreamDidLogoutedFailure:(GYHDStream *)sender
{// 登出失败
    
}

#pragma mark- 踢出登录
- (void)protoBufStreamDidKickouted:(GYHDStream*)sender
{// 被踢出登录
    DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
    DDLogInfo(@"检测到你的账号在其它设备登录，你将被迫断开连接");
    globalData.isHdLogined = NO;
    self.isCalledLogin = NO;

    [self.hdSocket disconnect];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [GYLoginHttpTool relogin];
        
    });
    
    [GYHDMessageCenter sharedInstance].state = GYHDMessageLoginStateOtherLogin;
    
}

#pragma mark- 发送失败*///此方法暂时没有调用
- (void)protoBufStream:(GYHDStream *)sender didFailToSendMessage:(NSData *)message error:(NSError *)error {

    DDLogInfo(@"*******发送失败******:%@", error);
    
    //如果外部没登录，就不要重连
    if (!self.isCalledLogin) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.hdSocket disconnect];
        [self setupProtoBufSocket];
    });
    
}



#pragma mark-  加好友功能企业暂时不调用
- (void)addFriendWithFriendID:(NSString *)friendID content:(NSString *)content verify:(NSString *)verify
{
    //    AddFriendReq* req = [[[[[AddFriendReq builder] setUserId:self.username] setFriendId:friendID] setVerify:verify]build];
    AddFriendReq *req = [[[[[[AddFriendReq builder] setUserId:self.username] setFriendId:friendID] setContent:content] setVerify:verify] build];
    [self splitProtobufPackageWithData:[req data] tag:CommandIDMsgAddFriendReq];
    
    
}

/**验证好友*/
- (void)verifyFriendWithFriendID:(NSString *)friendID agree:(int)agree
{
    VerifyFriendReq* req = [[[[[VerifyFriendReq builder] setUserId:self.username] setFriendId:friendID] setAgree:agree]build];
    
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


#pragma mark- 好友功能暂时不用
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
