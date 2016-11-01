//
//  GYXMPP.m
//  IMXMPPPro
//
//  Created by liangzm on 15-1-7.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//用于测试
#define kEnableDDLogCInfo YES
#define kEnableXMPPLog NO

#define kIMDomain    @"im.gy.com" //默认的后缀
#define kIMResource  @"mobile_im" //移动终端固定使用此resource //[Utils getRandomString:5]
#define kIMNoCardUserPrefix    @"m_nc_"    //无卡用户前缀


#import "GYXMPP.h"
#import "DDTTYLogger.h"
#import "GYDBCenter.h"
#import "GYHDMessageCenter.h"
#import "XMPPLogging.h"
#import "GYMessengeExtendElement.h"
#import "GYGenUUID.h"
#import "XMPPReconnect.h"
#import "GYLoginEn.h"
#import "GYLoginViewModel.h"
static dispatch_queue_t messageQueue = nil;

@interface GYXMPP()<GYHDMessageCenterDelegate,GYHDProtoBufSocketDelegate>

{
    BOOL customCertEvaluation;
    
}
#pragma mark - 主机参数部分
/**
 *  用户名
 */
@property (nonatomic, copy) NSString *userName;
/**
 *  密码
 */
@property (nonatomic, copy) NSString *password;
/**
 *  域名
 */
@property (nonatomic, copy) NSString *hostName;
/**
 *  推送消息的连接
 */
@property (nonatomic, copy) NSString *domainString;
@property (nonatomic, copy) NSString *resource;
@property (nonatomic, copy) NSString *pushHostName;
/**
 *  即时消息端口
 */
@property (nonatomic, assign) UInt16 hostPort;
/**
 *  推送消息端口
 */
@property (nonatomic, assign) UInt16 pushHostPort;

@property (nonatomic, copy) NSString *myJID;

#pragma mark - 其他参数
/**
 *  登录回调的block
 */
@property (nonatomic, copy) LoginBlock loginBlock;
/**
 *  即时聊天的自动连接
 */
@property (nonatomic, strong) XMPPReconnect *msgXmppReconnect;
/**
 *  推送消息的自动连接
 */
@property (nonatomic, strong) XMPPReconnect *pushXmppReconnect;


@property(nonatomic, weak) GYHDMessageCenter *messageCenter;



@property (nonatomic, assign) NSTimeInterval connectTimeout;

/**
 *  xmpp断开连接
 */
- (void)disconnect;

/**
 *  xmpp是否连接
 */
- (BOOL)connect;


#pragma mark xmpp
/**
 *  初始化xmppStream
 */
- (void)setupStream;


/**
 *  释放资源
 */
- (void)teardownStream;

/**
 *  上线
 */
- (void)goOnline;

/**
 *  离线
 */
- (void)goOffline;
@property(nonatomic ,strong)GYHDProtoBufSocket *hdSocket;
@end


@implementation GYXMPP

#pragma mark - xmpp单例
static id _instace;

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    return _instace;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instace;
}


/**
 *  初始化
 *
 *  @return
 */
- (instancetype)init
{
    if (self = [super init])
    {
        _connectTimeout = 15.f;
        if (kEnableXMPPLog)
            [DDLog addLogger:[DDTTYLogger sharedInstance] withLogLevel:XMPP_LOG_FLAG_SEND_RECV];
    }
    return self;
}

#pragma mark - 懒加载部分

- (GYHDMessageCenter *)messageCenter
{
    if (!_messageCenter) {
        _messageCenter = [GYHDMessageCenter sharedInstance];

        _messageCenter.delegate = self;
    }
    return _messageCenter;
}

- (BOOL)sendToServerWithDict:(NSDictionary *)dict
{
    //1. 在此组装xml发送到服务器
    XMPPJID *JID = [XMPPJID jidWithString:dict[GYHDDataBaseCenterMessageToID]];
    NSString *elementID = [NSString stringWithFormat:@"%@",dict[GYHDDataBaseCenterMessageID]];
    XMPPMessage *sendXpmmMsg = [XMPPMessage messageWithType:@"chat" to:JID elementID:elementID];

    NSString *uuid=[GYGenUUID gen_uuid];
    NSXMLElement *element=[GYMessengeExtendElement GYExtendElementWithID:uuid];
    [sendXpmmMsg addChild:element];
    
    [sendXpmmMsg addAttributeWithName:@"from" stringValue:dict[GYHDDataBaseCenterMessageFromID]];
    [sendXpmmMsg addBody:dict[GYHDDataBaseCenterMessageBody]];
    [self.msgXmppStream sendElement:sendXpmmMsg];
    
    return YES;
}





- (dispatch_queue_t)getMessageQueue
{
    if (!messageQueue)
        messageQueue = dispatch_queue_create("com.gyist", DISPATCH_QUEUE_SERIAL);
    return messageQueue;
}

//
////设置主机参数
//- (void)setParameterUserName:(NSString *)u
//                    password:(NSString *)p
//                      domain:(NSString *)d
//                    resource:(NSString *)r
//                    hostName:(NSString *)h
//                    hostPort:(UInt16)pt
//                pushHostName:(NSString *)pushName
//                pushHostPort:(UInt16)pushPort
//{
//    self.pushHostName = @"192.168.228.109";//pushName;
//    self.pushHostPort = @"5222";pushPort;
//    [self setParameterUserName:u password:p domain:d resource:r hostName:h hostPort:pt];
//    
//}

////设置主机参数
//- (void)setParameterUserName:(NSString *)u
//                    password:(NSString *)p
//                      domain:(NSString *)d
//                    resource:(NSString *)r
//                    hostName:(NSString *)h
//                    hostPort:(UInt16)pt
//{
//    self.userName =@"m_c_06119110999";u; @"m_c_06112110089";
//    self.password = p;
//    self.domainString = d;
//    self.resource = r;
//    self.hostName = @"192.168.228.101";h;@"192.168.41.8";
//    self.hostPort = 5222;pt;
//    self.myJID = [NSString stringWithFormat:@"%@@%@",self.userName, self.domainString];
//    DDLogCInfo(@"登录消息服务器用户：%@", self.myJID);
//    
//}


//登录
- (void)login:(LoginBlock)block
{
    self.userName = [NSString stringWithFormat:@"m_e_%@",globalData.loginModel.custId];
    NSString *password = [NSString stringWithFormat:@"%@,8,%@,%@",globalData.loginModel.custId,globalData.loginModel.token,globalData.loginModel.entResNo];
    self.password = password;
 
//    if ([GYLoginEn sharedInstance].loginLine==kLoginEn_dev) {
//        
//            self.hostName = @"192.168.41.193";@"192.168.229.34";
//            self.hostPort = 5222;
//        
//    }else{
    
        NSString *urlString = globalData.loginModel.hdDomain;
        
        self.hostName = [urlString componentsSeparatedByString:@":"].firstObject;globalData.loginModel.hdDomain;
        self.hostPort = [urlString componentsSeparatedByString:@":"].lastObject.integerValue;
//    }

    self.domainString = @"im.gy.com";
    self.resource = @"mobile_im";
    self.myJID = [NSString stringWithFormat:@"%@@%@",self.userName, self.domainString];
    
    self.loginBlock = block;
    
    if (!self.hostName || !self.myJID)
    {
        if(self.loginBlock)
        self.loginBlock(kIMLoginStateUnknowError);
        return;
    }
    [self setupStream];
//    [self setupProtoBufSocket];
    [self connect];
        //检查及创建数据库
    NSString *dbFullName = [GYDBCenter getUserDBNameInDirectory:self.userName];
    if (![GYDBCenter fileIsExists:dbFullName])
    {
            DDLogCInfo(@"用户数据库不存在，将创建");
        if (![GYDBCenter createFile:dbFullName])
        {
//                [Utils alertViewOKbuttonWithTitle:nil message:@"sorry, create user's im db error."];
        
            
            return;
            }
        }
        
        DDLogCInfo(@"im数据库完整路径:%@", dbFullName);
        _imFMDB = [[FMDatabase alloc] initWithPath:dbFullName];
        [self.messageCenter savedbFull:dbFullName];
//        BOOL isInitDB = [GYDBCenter setDefaultTablesForImDB:_imFMDB];
//        if (isInitDB)
//        {
//            DDLogCInfo(@"用户数据库--表结构初始化完成");
//        }else
//        {
////            [Utils alertViewOKbuttonWithTitle:nil message:@"用户数据库--表结构初始化失败."];
//            [Utils showMessgeWithTitle:nil message:@"用户数据库--表结构初始化失败" isPopVC:nil];
//            return;
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameInitDB object:nil];
    
}
/**protobuf 登录*/
- (void)setupProtoBufSocket {
    
    GYHDProtoBufSocket *hdSocket = [[GYHDProtoBufSocket alloc] init];
    hdSocket.delegate = self;
    self.hdSocket = hdSocket;
    GYHDStream *stream = [[GYHDStream alloc] init];
    
//    if ([GYLoginEn sharedInstance].loginLine==kLoginEn_dev) {
//        
//            stream.hostName = @"192.168.229.139";
//            stream.hostPort = 13000;
//        
//    }else{
    
        NSString*urlStr=globalData.loginModel.ttMsgServer;
        stream.hostName = [urlStr componentsSeparatedByString:@":"].firstObject;
        stream.hostPort = [urlStr componentsSeparatedByString:@":"].lastObject.integerValue;
//    }
    [self.hdSocket setloginStream:stream];
    [self.hdSocket Login];
    LoginReq*req=[[[[[[[[[[LoginReq builder]setCstId:globalData.loginModel.custId]setLoginToken:globalData.loginModel.token]setChannelType:8]setEntResNo:globalData.loginModel.entResNo]setStatus:1]setForceLogin:1]setDeviceType:6]setDeviceToken:@"11"]build];
    GYHDProtoBufHeader *buf = [[GYHDProtoBufHeader alloc] init];
    buf.cmdid = 0x3019;
    NSData *data = [buf DataWithProtobufData:[req data]];
    [self.hdSocket sendMessageWithData:data];
    DDLogCInfo(@"%@",data);
    
}

- (BOOL)sendProtobufToServerWithData:(NSData *)data {
    [self.hdSocket sendMessageWithData:data];
    return YES;
}


//退出登录
- (void)Logout
{
    [self goOffline];
    [self disconnect];
    [self teardownStream];
    [self protobufDisconnect];
}

-(void)protobufDisconnect{

    long long userid= [globalData.loginModel.custId longLongValue];
    
    LoginOutReq*req= [[[[LoginOutReq builder]setUserId:userid]setDeviceType:6]build];
    
    GYHDProtoBufHeader *buf = [[GYHDProtoBufHeader alloc] init];
    
    buf.cmdid = 0x301b;
    
    NSData *data = [buf DataWithProtobufData:[req data]];
    
    [self.hdSocket sendMessageWithData:data];
    
    [self.hdSocket Logout];

}

- (XMPPJID *)reGetJID:(NSString *)jidString
{
    //重组合法的XMPPJID
    XMPPJID *_jid = [[XMPPJID jidWithString:jidString] bareJID];
    NSString *u = _jid.user;
    if (!u)
    {
        u = _jid.domain;
    }
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", u, self.domainString]];
    return jid;
}


#pragma mark - 私有方法

- (void)setupStream
{
    
    if (self.msgXmppStream && self.pushXmppStream) return;
    NSAssert(self.msgXmppStream == nil, @"Method setupStream invoked multiple times");
    NSAssert(self.pushXmppStream == nil, @"Method setupStream invoked multiple times");
    
	self.msgXmppStream = [[XMPPStream alloc] init];
    self.pushXmppStream = [[XMPPStream alloc] init];
    
#if !TARGET_IPHONE_SIMULATOR
	{
		self.msgXmppStream.enableBackgroundingOnSocket = YES;
        self.pushXmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
	
    //自动连接模块
	self.msgXmppReconnect = [[XMPPReconnect alloc] init];
	[self.msgXmppReconnect activate:self.msgXmppStream];
    [self.msgXmppStream setHostName:self.hostName];
    [self.msgXmppStream setHostPort:self.hostPort];
    
 
    self.pushXmppReconnect = [[XMPPReconnect alloc] init];
    [self.pushXmppReconnect  activate:self.pushXmppStream];
    [self.pushXmppStream setHostName:self.pushHostName];
    [self.pushXmppStream setHostPort:self.pushHostPort];
    
    //代理在子线程调用
    [self.pushXmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    [self.msgXmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
	customCertEvaluation = YES;
}



- (void)teardownStream
{
    //移除代理
	[self.msgXmppStream removeDelegate:self];
    [self.pushXmppStream removeDelegate:self];
	
	//取消激活模块
	[self.msgXmppReconnect          deactivate];
    [self.pushXmppReconnect         deactivate];

	
	[self.msgXmppStream disconnect];
    [self.pushXmppStream disconnect];
	
	self.msgXmppStream = nil;
	self.msgXmppReconnect  = nil;
    
    self.pushXmppStream = nil;
    self.pushXmppReconnect= nil;

}


- (void)goOnline
{
	XMPPPresence *msgPresence = [XMPPPresence presence];
	[self.msgXmppStream sendElement:msgPresence];
    
 
    XMPPPresence *pushPresence = [XMPPPresence presence];
    [self.pushXmppStream sendElement:pushPresence];
}



- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	[self.msgXmppStream sendElement:presence];
    
    XMPPPresence *pushPresence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.pushXmppStream sendElement:pushPresence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)connect
{
	if (![self.msgXmppStream isDisconnected])
    {
		return YES;
	}
	
	if (self.userName == nil || self.password == nil)
    {
		return NO;
	}
    
    //两种登录方式
	self.msgXmppStream.myJID =[XMPPJID jidWithUser:self.userName domain:self.domainString resource:self.resource];
//	[xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
//    [self.pushXmppStream setMyJID:[XMPPJID jidWithUser:userName domain:domainString resource:resource]];
//    [self.pushXmppStream connectWithTimeout:_connectTimeout error:nil];
	NSError *error = nil;
	if (![self.msgXmppStream connectWithTimeout:_connectTimeout error:&error] )//XMPPStreamTimeoutNone
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
        
		if (kEnableDDLogCInfo) DDLogCInfo(@"Error connecting: %@", error);
        
		return NO;
	}
	return YES;
}

- (void)disconnect
{
	[self.msgXmppStream disconnect];
    [self.pushXmppStream disconnect];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	if (kEnableDDLogCInfo) DDLogCInfo(@"%@: %@", THIS_FILE, THIS_METHOD);

}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	if (kEnableDDLogCInfo) DDLogCInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
    if ([sender.hostName isEqualToString:self.hostName]) {
        
        NSString *expectedCertName = [self.msgXmppStream.myJID domain];
        if (expectedCertName)
        {
            [settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
        }
        
        if (customCertEvaluation)
        {
            [settings setObject:@(YES) forKey:GCDAsyncSocketManuallyEvaluateTrust];
        }
        
    } else if ([sender.hostName isEqualToString:self.pushHostName]) {
        
        NSString *expectedCertName = [self.pushXmppStream.myJID domain];
        if (expectedCertName)
        {
            [settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
        }
        
        if (customCertEvaluation)
        {
            [settings setObject:@(YES) forKey:GCDAsyncSocketManuallyEvaluateTrust];
        }
        
    }

}

- (void)xmppStream:(XMPPStream *)sender didReceiveTrust:(SecTrustRef)trust
 completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
	if (kEnableDDLogCInfo) DDLogCInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
		
	dispatch_queue_t bgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(bgQueue, ^{
		
		SecTrustResultType result = kSecTrustResultDeny;
		OSStatus status = SecTrustEvaluate(trust, &result);
		
		if (status == noErr && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)) {
			completionHandler(YES);
		}
		else {
			completionHandler(NO);
		}
	});
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	if (kEnableDDLogCInfo) DDLogCInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	if (kEnableDDLogCInfo) DDLogCInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    if ([sender.hostName isEqualToString:self.hostName]) {
        
  
        NSError *error = nil;
        
        if (![self.msgXmppStream authenticateWithPassword:self.password error:&error])
        {
            if (kEnableDDLogCInfo) DDLogCInfo(@"Error authenticating: %@", error);
        }
     
        [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:nil];
    } else if ([sender.hostName isEqualToString:self.pushHostName]) {
        NSError *error = nil;
        
        if (![self.pushXmppStream authenticateWithPassword:self.password error:&error])
        {
            if (kEnableDDLogCInfo) DDLogCInfo(@"Error authenticating: %@", error);
        }
    }
    
    if (self.loginBlock) {
        self.loginBlock(kIMLoginStateConnetToServerSucced);
    }
}

- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    if (self.self.loginBlock)
    {
        self.loginBlock(kIMLoginStateConnetToServerTimeout);
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	if (kEnableDDLogCInfo) DDLogCInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
    [self.messageCenter updateSendingState];
//张鑫 个人信息资料存储数据库
    NSMutableDictionary *friendBaseDict = [NSMutableDictionary dictionary];
    friendBaseDict[GYHDDataBaseCenterFriendBasicAccountID] = [NSString stringWithFormat:@"%@",globalData.loginModel.entResNo];
    friendBaseDict[GYHDDataBaseCenterFriendBasicCustID] = globalData.loginModel.custId;
    friendBaseDict[GYHDDataBaseCenterFriendUsetType]  = @"";
    friendBaseDict[GYHDDataBaseCenterFriendIcon] =globalData.loginModel.headPic;
    friendBaseDict[GYHDDataBaseCenterFriendBasicIcon]=globalData.loginModel.headPic;
    friendBaseDict[GYHDDataBaseCenterFriendBasicNikeName] = globalData.loginModel. operName;
    [[GYHDMessageCenter sharedInstance] updateFriendBaseWithDict:friendBaseDict];
    
    if (self.loginBlock)
    {
        self.loginBlock(kIMLoginStateAuthenticateSucced);
    }
	[self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	if (kEnableDDLogCInfo) DDLogCInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
    if (self.loginBlock)
    {
        self.loginBlock(kIMLoginStateAuthenticateFailure);
    }
   
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	if (kEnableDDLogCInfo) DDLogCInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
    DDLogCInfo(@"---%@: %@", sender, iq);
	
	return YES;
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
	if (kEnableDDLogCInfo) DDLogCInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    if ([message isChatMessageWithBody])
	{
        
        NSString *msgID = [[message attributeForName:@"id"] stringValue];

        [[GYHDMessageCenter sharedInstance] updateMessageStateWithMessageID:msgID State:GYHDDataBaseCenterMessageSentStateSuccess];
    }

}

- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{
    if ([message isChatMessageWithBody])
    {
        NSString *msgID = [[message attributeForName:@"id"] stringValue];
        
        [[GYHDMessageCenter sharedInstance] updateMessageStateWithMessageID:msgID State:GYHDDataBaseCenterMessageSentStateFailure];
    }
    
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    DDLogCInfo(@"收到消息：%@， %@", sender, message);
    
    NSString *toID=[[message attributeForName:@"to"] stringValue];
    
    //add by shiang,检查是否收到消息回执
    NSXMLElement *requestACK=[message elementForName:@"request" xmlnsPrefix:@"gy:abnormal:offline"];
    NSString *elementId=[[requestACK elementForName:@"id"] stringValue];
    
    if (requestACK) {
        //DDLogCInfo(@"收到用户消息后需要发送回执receipt");
        //组装发送的XMPPMessage
        XMPPMessage *message = [XMPPMessage message];
        NSXMLElement *element=[GYMessengeExtendElement GYExtendElementWithElementId:elementId withSender:toID];
        [message addChild:element];
        
        //        [xmp.xmppStream sendElement:message];
        [sender sendElement:message];
        
    }
    
    
    if (![message isErrorMessage])
    {

        [self.messageCenter ReceiveMessage:message];

    }
}



- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	if (kEnableDDLogCInfo) DDLogCInfo(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
    if (kEnableDDLogCInfo) DDLogCInfo(@"---%@: %@", sender, presence);
}


- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error
{
	if (kEnableDDLogCInfo) DDLogCInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSXMLElement *conflictE = [error elementForName:@"conflict"];
    if (conflictE)
    {
        DDLogCInfo(@"xmpp检测到你的账号在其它设备登录，你将被迫断开xmpp连接");
        globalData.isHdLogined = NO;
       dispatch_async(dispatch_get_main_queue(), ^{
           [UIAlertView showWithTitle:kLocalized(@"prompt") message:@"请重新登录!" cancelButtonTitle:kLocalized(@"Confirm") otherButtonTitles:@[] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                       if (buttonIndex == 0 )
                       {
                           [GYLoginViewModel logout];
                       }

                   }];

       });

    }else
    {
        //登录时的错误回调
        if (self.loginBlock)
        {
            self.loginBlock(kIMLoginStateUnknowError);
            
        }
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"xmppOtherLogin" object:nil];
    
}



- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	if (kEnableDDLogCInfo) DDLogCInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
	

    if (self.loginBlock)
    {
            self.loginBlock(kIMLoginStateConnetToServerFailure);
        
    }
    
//     [[NSNotificationCenter defaultCenter] postNotificationName:@"xmppOffline" object:nil];
  
   
    
}

/**连接成功*/
- (void)protoBufStreamDidConnect:(GYHDStream *)sender {
    
  
}
/**连接超时*/
- (void)protoBufStreamConnectDidTimeout:(GYHDStream *)sender {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([self.hdSocket isConnect]) {
        
//            [self setupProtoBufSocket];
            LoginReq*req=[[[[[[[[[[LoginReq builder]setCstId:globalData.loginModel.custId]setLoginToken:globalData.loginModel.token]setChannelType:8]setEntResNo:globalData.loginModel.entResNo]setStatus:1]setForceLogin:1]setDeviceType:6]setDeviceToken:@"11"]build];
            GYHDProtoBufHeader *buf = [[GYHDProtoBufHeader alloc] init];
            buf.cmdid = 0x3019;
            NSData *data = [buf DataWithProtobufData:[req data]];
            [self.hdSocket sendMessageWithData:data];
           
        }
        
    });
    
}
/**连接失败*/
- (void)protoBufStreamDidDisconnect:(GYHDStream *)sender withError:(NSError *)error {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([self.hdSocket isConnect]) {
        
//             [self setupProtoBufSocket];
            LoginReq*req=[[[[[[[[[[LoginReq builder]setCstId:globalData.loginModel.custId]setLoginToken:globalData.loginModel.token]setChannelType:8]setEntResNo:globalData.loginModel.entResNo]setStatus:1]setForceLogin:1]setDeviceType:6]setDeviceToken:@"11"]build];
            GYHDProtoBufHeader *buf = [[GYHDProtoBufHeader alloc] init];
            buf.cmdid = 0x3019;
            NSData *data = [buf DataWithProtobufData:[req data]];
            [self.hdSocket sendMessageWithData:data];
        
        }
        
    });
}
/**发送成功*/
- (void)protoBufStream:(GYHDStream *)sender didSendMessage:(NSData *)message {
    
}
/**发送失败*/
- (void)protoBufStream:(GYHDStream *)sender didFailToSendMessage:(NSData *)message error:(NSError *)error {
    
}

/**接收消息*/
- (void)protoBufStream:(GYHDStream *)sender didReceiveMessage:(NSData *)message{
    [[GYHDMessageCenter sharedInstance ] receiveProtobuf:message];
}

@end
