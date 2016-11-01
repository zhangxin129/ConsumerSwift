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
#define kEnableNSLog YES
#define kEnableXMPPLog NO

#define kIMDomain @"im.gy.com" //默认的后缀
#define kIMResource @"mobile_im" //移动终端固定使用此resource //[GYUtils getRandomString:5]
#define kIMNoCardUserPrefix @"m_nc_" //无卡用户前缀

#import "GYXMPP.h"
#import "DDTTYLogger.h"
//#import "IMMessageCenter.h"
//#import "GYDBCenter.h"
//#import "GYChatItem.h"
#import "GYHDMessageCenter.h"
#import "XMPPLogging.h"
//#import "GYMessengeExtendElement.h"
//#import "GYGenUUID.h"
#import "XMPPReconnect.h"

static dispatch_queue_t messageQueue = nil;

@interface GYXMPP () <GYHDMessageCenterDelegate>

    {
    BOOL customCertEvaluation;
}
#pragma mark - 主机参数部分
/**
 *  登录回调的block
 */
@property (nonatomic, copy) LoginBlock loginBlock;
/**连接状态*/
@property (nonatomic, assign) IMLoginState loginState;
/**
 *  用户名
 */
@property (nonatomic, copy) NSString* userName;
/**
 *  密码
 */
@property (nonatomic, copy) NSString* password;
/**
 *  域名
 */
@property (nonatomic, copy) NSString* hostName;
/**
 *  推送消息的连接
 */
@property (nonatomic, copy) NSString* domainString;
@property (nonatomic, copy) NSString* resource;
@property (nonatomic, copy) NSString* pushHostName;
/**
 *  即时消息端口
 */
@property (nonatomic, assign) UInt16 hostPort;
/**
 *  推送消息端口
 */
@property (nonatomic, assign) UInt16 pushHostPort;

@property (nonatomic, copy) NSString* myJID;

#pragma mark - 其他参数

/**
 *  即时聊天的自动连接
 */
@property (nonatomic, strong) XMPPReconnect* msgXmppReconnect;
/**
 *  推送消息的自动连接
 */
@property (nonatomic, strong) XMPPReconnect* pushXmppReconnect;

@property (nonatomic, weak) GYHDMessageCenter* messageCenter;

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

@end

@implementation GYXMPP

#pragma mark - xmpp单例
static id _instace;

+ (id)allocWithZone:(struct _NSZone*)zone
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

- (id)copyWithZone:(NSZone*)zone
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
    if (self = [super init]) {
        _connectTimeout = 15.f;
        if (kEnableXMPPLog)
            [DDLog addLogger:[DDTTYLogger sharedInstance] withLogLevel:XMPP_LOG_FLAG_SEND_RECV];
    }
    return self;
}

#pragma mark - 懒加载部分

- (GYHDMessageCenter*)messageCenter
{
    if (!_messageCenter) {
        _messageCenter = [GYHDMessageCenter sharedInstance];

        _messageCenter.delegate = self;
    }
    return _messageCenter;
}

- (BOOL)sendProtobufToServerWithData:(NSData*)data
{

    return YES;
}

- (BOOL)sendToServerWithDict:(NSDictionary*)dict
{
    if (self.loginState != kIMLoginStateAuthenticateSucced && !globalData.isOnNet) {
        [[GYHDMessageCenter sharedInstance] updateMessageStateWithMessageID:dict[GYHDDataBaseCenterMessageID] State:GYHDDataBaseCenterMessageSentStateFailure];
        return NO;
    }
    //1. 在此组装xml发送到服务器
    XMPPJID* JID = [XMPPJID jidWithString:dict[GYHDDataBaseCenterMessageToID]];
    NSString* elementID = [NSString stringWithFormat:@"%@", dict[GYHDDataBaseCenterMessageID]];
    XMPPMessage* sendXpmmMsg = [XMPPMessage messageWithType:@"chat" to:JID elementID:elementID];

    NSString* uuid = [self gen_uuid];
    NSXMLElement* element = [self GYExtendElementWithID:uuid];
    [sendXpmmMsg addChild:element];

    [sendXpmmMsg addAttributeWithName:@"from" stringValue:dict[GYHDDataBaseCenterMessageFromID]];
    [sendXpmmMsg addBody:dict[GYHDDataBaseCenterMessageBody]];
    [self.msgXmppStream sendElement:sendXpmmMsg];

    return YES;
}
//iOS 生成 UUID（或者叫GUID）例子代码
- (NSString*)gen_uuid
{
    CFUUIDRef uuid_ref = CFUUIDCreate(nil);
    CFStringRef uuid_string_ref = CFUUIDCreateString(nil, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString* uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(uuid_string_ref);
    return uuid;
}

- (id)GYExtendElementWithID:(NSString*)id
{
    NSXMLElement* sub_node = [NSXMLElement elementWithName:@"id" stringValue:id];
    
    NSXMLElement* element = [NSXMLElement elementWithName:@"request" objectValue:nil];
    
    [element addAttributeWithName:@"xmlns" stringValue:@"gy:abnormal:offline"];
    
    [element addChild:sub_node];
    return element;
}

- (id)GYExtendElementWithElementId:(NSString*)elementID withSender:(NSString*)sender
{
    NSXMLElement* element = [NSXMLElement elementWithName:@"receipt" objectValue:nil];
    [element addAttributeWithName:@"xmlns" stringValue:@"gy:abnormal:offline"];
    
    NSXMLElement* sub_node_first = [NSXMLElement elementWithName:@"id" stringValue:elementID];
    NSXMLElement* sub_node_second = [NSXMLElement elementWithName:@"sender" stringValue:sender];
    
    [element addChild:sub_node_first];
    [element addChild:sub_node_second];
    
    return element;
    
}

- (dispatch_queue_t)getMessageQueue
{
    if (!messageQueue)
        messageQueue = dispatch_queue_create("com.gyist", DISPATCH_QUEUE_SERIAL);
    return messageQueue;
}

//设置主机参数
- (void)setParameterUserName:(NSString*)u
                    password:(NSString*)p
                      domain:(NSString*)d
                    resource:(NSString*)r
                    hostName:(NSString*)h
                    hostPort:(UInt16)pt
                pushHostName:(NSString*)pushName
                pushHostPort:(UInt16)pushPort
{
    self.pushHostName = @"192.168.228.109"; //pushName;
    self.pushHostPort = @"5222";
    pushPort;
    [self setParameterUserName:u password:p domain:d resource:r hostName:h hostPort:pt];
}

//设置主机参数
- (void)setParameterUserName:(NSString*)u
                    password:(NSString*)p
                      domain:(NSString*)d
                    resource:(NSString*)r
                    hostName:(NSString*)h
                    hostPort:(UInt16)pt
{
    self.userName = @"m_c_06119110999";
    u;
    @"m_c_06112110089";
    self.password = p;
    self.domainString = d;
    self.resource = r;
    self.hostName = @"192.168.228.101";
    h;
    @"192.168.41.8";
    self.hostPort = 5222;
    pt;
    self.myJID = [NSString stringWithFormat:@"%@@%@", self.userName, self.domainString];
    DDLogInfo(@"登录消息服务器用户：%@", self.myJID);
}

//登录
- (void)login:(LoginBlock)block
{

    GlobalData* data = [GlobalData shareInstance];
    NSString* urlstring = data.loginModel.hdDomain;
    if (globalData.loginModel.cardHolder) {
        self.userName = [NSString stringWithFormat:@"m_c_%@", globalData.loginModel.custId];
    }
    else {
        self.userName = [NSString stringWithFormat:@"m_nc_%@", globalData.loginModel.custId];
    }

    NSString* password = [NSString stringWithFormat:@"%@,4,%@", globalData.loginModel.custId, globalData.loginModel.token];
    self.password = password;

    if ([GYHSLoginEn sharedInstance].loginLine == kLoginEn_dev) {
        //        self.hostName = @"192.168.41.193";
        //        self.hostPort = 5222;
        self.hostName = [urlstring componentsSeparatedByString:@":"].firstObject;
        self.hostPort = [urlstring componentsSeparatedByString:@":"].lastObject.integerValue;
    }
    else {
        self.hostName = [urlstring componentsSeparatedByString:@":"].firstObject;
        self.hostPort = [urlstring componentsSeparatedByString:@":"].lastObject.integerValue;
    }

    self.domainString = @"im.gy.com";
    self.resource = @"mobile_im";
    self.myJID = [NSString stringWithFormat:@"%@@%@", self.userName, self.domainString];

    self.loginBlock = block;
    if (!self.hostName || !self.myJID) {

        if (self.loginBlock) {
            self.loginState = kIMLoginStateUnknowError;
            self.loginBlock(kIMLoginStateUnknowError);
        }
        self.messageCenter.state = GYHDMessageLoginStateUnknowError;
        return;
    }
    [self setupProtoBufSocket];
    [self setupStream];
    [self connect];
    //检查及创建数据库
    NSString* dbFullName = [[GYHDMessageCenter sharedInstance] getUserDBNameInDirectory:self.userName];
    if (![[GYHDMessageCenter sharedInstance] fileIsExists:dbFullName]) {
        DDLogInfo(@"用户数据库不存在，将创建");
        if (![[GYHDMessageCenter sharedInstance] createFile:dbFullName]) {
            //                [GYUtils alertViewOKbuttonWithTitle:nil message:@"sorry, create user's im db error."];
            return;
        }
    }

    DDLogInfo(@"im数据库完整路径:%@", dbFullName);
    _imFMDB = [[FMDatabase alloc] initWithPath:dbFullName];
    [self.messageCenter savedbFull:dbFullName];
//    BOOL isInitDB = [[GYHDMessageCenter sharedInstance] setDefaultTablesForImDB:_imFMDB];
//    if (isInitDB) {
//        DDLogInfo(@"用户数据库--表结构初始化完成");
//    }
//    else {
//        //            [GYUtils alertViewOKbuttonWithTitle:nil message:@"用户数据库--表结构初始化失败."];
//        return;
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameInitDB object:nil];
}

/**protobuf 登录*/
- (void)setupProtoBufSocket
{

    [[GYHDMessageCenter sharedInstance] getOfflinePushMsg];
    //
    //    GYHDProtoBufSocket *hdSocket = [[GYHDProtoBufSocket alloc] init];
    //    hdSocket.delegate = self;
    //    self.hdSocket = hdSocket;
    //    GYHDStream *stream = [[GYHDStream alloc] init];
    //    NSString *imUrl = globalData.loginModel.ttMsgServer;
    //
    //
    //    if ([LoginEn sharedInstance].loginLine == kLoginEn_dev) {
    //        stream.hostName = @"192.168.229.139";
    //        stream.hostPort = 13000;
    ////        stream.hostName = [imUrl componentsSeparatedByString:@":"].firstObject;
    ////        stream.hostPort = [imUrl componentsSeparatedByString:@":"].lastObject.integerValue;
    //    } else {
    //        stream.hostName = @"192.168.229.60";
    //        stream.hostPort = 13000;
    ////        stream.hostName = [imUrl componentsSeparatedByString:@":"].firstObject;
    ////        stream.hostPort = [imUrl componentsSeparatedByString:@":"].lastObject.integerValue;
    //    }
    //
    //    [self.hdSocket setloginStream:stream];
    //    [self.hdSocket Login];
    //    LoginReq *req = [[[[[[[[[[LoginReq builder] setCstId:globalData.loginModel.custId] setLoginToken:globalData.loginModel.token] setChannelType:4] setEntResNo:@""] setStatus:1] setForceLogin:1] setDeviceType:5] setDeviceToken:@"11"] build];
    //    GYHDProtoBufHeader *buf = [[GYHDProtoBufHeader alloc] init];
    //    buf.cmdid = 0x3019;
    //    NSData *data = [buf DataWithProtobufData:[req data]];
    //    [self.hdSocket sendMessageWithData:data];
    //    NSLog(@"%@", data);
}

//退出登录
- (void)Logout
{
    [self goOffline];
    [self disconnect];
    [self teardownStream];

}


- (XMPPJID*)reGetJID:(NSString*)jidString
{
    //重组合法的XMPPJID
    XMPPJID* _jid = [[XMPPJID jidWithString:jidString] bareJID];
    NSString* u = _jid.user;
    if (!u) {
        u = _jid.domain;
    }
    XMPPJID* jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", u, self.domainString]];
    return jid;
}

#pragma mark - 私有方法

- (void)setupStream
{

    if (self.msgXmppStream && self.pushXmppStream) {
        [self Logout];
    };
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
    [self.pushXmppReconnect activate:self.pushXmppStream];
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
    [self.msgXmppReconnect deactivate];
    [self.pushXmppReconnect deactivate];

    [self.msgXmppStream disconnect];
    [self.pushXmppStream disconnect];

    self.msgXmppStream = nil;
    self.msgXmppReconnect = nil;

    self.pushXmppStream = nil;
    self.pushXmppReconnect = nil;
}

- (void)goOnline
{
    XMPPPresence* msgPresence = [XMPPPresence presence];
    [self.msgXmppStream sendElement:msgPresence];

    XMPPPresence* pushPresence = [XMPPPresence presence];
    [self.pushXmppStream sendElement:pushPresence];
}

- (void)goOffline
{
    XMPPPresence* presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.msgXmppStream sendElement:presence];

    XMPPPresence* pushPresence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.pushXmppStream sendElement:pushPresence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)connect
{
    if (![self.msgXmppStream isDisconnected]) {
        return YES;
    }

    if (self.userName == nil || self.password == nil) {
        return NO;
    }

    //两种登录方式
    self.msgXmppStream.myJID = [XMPPJID jidWithUser:self.userName domain:self.domainString resource:self.resource];
    //	[xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
    //    [self.pushXmppStream setMyJID:[XMPPJID jidWithUser:userName domain:domainString resource:resource]];
    //    [self.pushXmppStream connectWithTimeout:_connectTimeout error:nil];
    NSError* error = nil;
    if (![self.msgXmppStream connectWithTimeout:_connectTimeout error:&error]) { //XMPPStreamTimeoutNone
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
                                                            message:@"See console for error details."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];

        if (kEnableNSLog)
            NSLog(@"Error connecting: %@", error);

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

- (void)xmppStream:(XMPPStream*)sender socketDidConnect:(GCDAsyncSocket*)socket
{
    if (kEnableNSLog)
        NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream*)sender willSecureWithSettings:(NSMutableDictionary*)settings
{
    if (kEnableNSLog)
        NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
    if ([sender.hostName isEqualToString:self.hostName]) {

        NSString* expectedCertName = [self.msgXmppStream.myJID domain];
        if (expectedCertName) {
            [settings setObject:expectedCertName forKey:(NSString*)kCFStreamSSLPeerName];
        }

        if (customCertEvaluation) {
            [settings setObject:@(YES) forKey:GCDAsyncSocketManuallyEvaluateTrust];
        }
    }
    else if ([sender.hostName isEqualToString:self.pushHostName]) {

        NSString* expectedCertName = [self.pushXmppStream.myJID domain];
        if (expectedCertName) {
            [settings setObject:expectedCertName forKey:(NSString*)kCFStreamSSLPeerName];
        }

        if (customCertEvaluation) {
            [settings setObject:@(YES) forKey:GCDAsyncSocketManuallyEvaluateTrust];
        }
    }
}

- (void)xmppStream:(XMPPStream*)sender didReceiveTrust:(SecTrustRef)trust
    completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
    if (kEnableNSLog)
        NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);

    dispatch_queue_t bgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(bgQueue, ^{

        SecTrustResultType result = kSecTrustResultDeny;
        OSStatus status = SecTrustEvaluate(trust, &result);

        if (status == noErr && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)) {
            completionHandler(YES);
        } else {
            completionHandler(NO);
        }
    });
}

- (void)xmppStreamDidSecure:(XMPPStream*)sender
{
    if (kEnableNSLog)
        NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream*)sender
{
    if (kEnableNSLog)
        NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);

    if ([sender.hostName isEqualToString:self.hostName]) {

        NSError* error = nil;

        if (![self.msgXmppStream authenticateWithPassword:self.password error:&error]) {
            if (kEnableNSLog)
                NSLog(@"Error authenticating: %@", error);
        }

        //        [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:nil];
    }
    else if ([sender.hostName isEqualToString:self.pushHostName]) {
        NSError* error = nil;

        if (![self.pushXmppStream authenticateWithPassword:self.password error:&error]) {
            if (kEnableNSLog)
                NSLog(@"Error authenticating: %@", error);
        }
    }

    if (self.loginBlock) {
        self.loginState = kIMLoginStateConnetToServerSucced;
        self.loginBlock(kIMLoginStateConnetToServerSucced);
    }
    self.messageCenter.state = GYHDMessageLoginStateConnetToServerSucced;
}

- (void)xmppStreamConnectDidTimeout:(XMPPStream*)sender
{
    if (self.self.loginBlock) {
        self.loginState = kIMLoginStateConnetToServerTimeout;
        self.loginBlock(kIMLoginStateConnetToServerTimeout);
    }
    self.messageCenter.state = GYHDMessageLoginStateConnetToServerTimeout;
}

- (void)xmppStreamDidAuthenticate:(XMPPStream*)sender
{
    if (kEnableNSLog)
        NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
    [self.messageCenter updateSendingState];

    GlobalData* dateModel = [GlobalData shareInstance];
    //    NSString *custID = nil;
    //    if (dateModel.loginModel.cardHolder) {
    //        custID = [NSString stringWithFormat:@"c_%@",dateModel.loginModel.custId ];
    //    }else {
    //        custID = [NSString stringWithFormat:@"nc_%@",dateModel.loginModel.custId ];
    //    }

    [[GYHDMessageCenter sharedInstance] searchFriendWithCustId:dateModel.loginModel.custId RequetResult:^(NSDictionary* resultDict){

    }];
    if (self.loginBlock) {
        self.loginState = kIMLoginStateAuthenticateSucced;
        self.loginBlock(kIMLoginStateAuthenticateSucced);
    }
    self.messageCenter.state = GYHDMessageLoginStateAuthenticateSucced;

    [self goOnline];
}

- (void)xmppStream:(XMPPStream*)sender didNotAuthenticate:(NSXMLElement*)error
{
    if (kEnableNSLog)
        NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
    if (self.loginBlock) {
        self.loginState = kIMLoginStateAuthenticateFailure;
        self.loginBlock(kIMLoginStateAuthenticateFailure);
    }
    self.messageCenter.state = GYHDMessageLoginStateAuthenticateFailure;
}

- (BOOL)xmppStream:(XMPPStream*)sender didReceiveIQ:(XMPPIQ*)iq
{
    if (kEnableNSLog)
        NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSLog(@"---%@: %@", sender, iq);

    return YES;
}

- (void)xmppStream:(XMPPStream*)sender didSendMessage:(XMPPMessage*)message
{
    if (kEnableNSLog)
        NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);

    if ([message isChatMessageWithBody]) {
        NSString* msgID = [[message attributeForName:@"id"] stringValue];
//        if (msgID && [GYChatItem changeSendMsgStatusWithMsgID:msgID WithStatus:kMessagSentState_Sent]) {
//            NSDictionary* dic = @{ @"msgID" : msgID,
//                @"State" : @(kMessagSentState_Sent) };
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameSendResult object:dic];
//        }

        [[GYHDMessageCenter sharedInstance] updateMessageStateWithMessageID:msgID State:GYHDDataBaseCenterMessageSentStateSuccess];
    }
    //add by shiang
    //    if ([message isChatMessageWithBody])
    //    {
    //        NSXMLElement *request=[message elementForName:@"request" xmlnsPrefix:@"gy:abnormal:offline"];
    //        NSString *ACKID = [[request elementForName:@"id"] stringValue];
    //        if (ACKID && [GYChatItem changeSendMsgStatusWithACKID:ACKID WithStatus:kMessagSentState_Sending])
    //        {
    //            NSDictionary *dic = @{@"ACKID":ACKID,@"State":@(kMessagSentState_Sending)};
    //            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameSendResult object:dic];
    //        }
    //    }
}

- (void)xmppStream:(XMPPStream*)sender didFailToSendMessage:(XMPPMessage*)message error:(NSError*)error
{
    if ([message isChatMessageWithBody]) {
        NSString* msgID = [[message attributeForName:@"id"] stringValue];
//        if (msgID && [GYChatItem changeSendMsgStatusWithMsgID:msgID WithStatus:kMessagSentState_Send_Failed]) {
//            NSDictionary* dic = @{ @"msgID" : msgID,
//                @"State" : @"3" };
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameSendResult object:dic];
//        }
        [[GYHDMessageCenter sharedInstance] updateMessageStateWithMessageID:msgID State:GYHDDataBaseCenterMessageSentStateFailure];
    }
}

- (void)xmppStream:(XMPPStream*)sender didReceiveMessage:(XMPPMessage*)message
{
    NSLog(@"收到消息：%@， %@", sender, message);

    NSString* toID = [[message attributeForName:@"to"] stringValue];

    //add by shiang,检查是否收到消息回执
    NSXMLElement* requestACK = [message elementForName:@"request" xmlnsPrefix:@"gy:abnormal:offline"];
    NSString* elementId = [[requestACK elementForName:@"id"] stringValue];

    if (requestACK) {
        //NSLog(@"收到用户消息后需要发送回执receipt");
        //组装发送的XMPPMessage
        //XMPPMessage *message = [XMPPMessage messageWithType:nil to:nil elementID:messageId];
        XMPPMessage* message = [XMPPMessage message];
        NSXMLElement* element = [self GYExtendElementWithElementId:elementId withSender:toID];
        [message addChild:element];

        //        [xmp.xmppStream sendElement:message];
        [sender sendElement:message];
    }

    if (![message isErrorMessage]) {
        //add by xiangss,解析ack元素,此回复ack是没有msgID的而是用另外一个新添加的字段id。
        //        NSXMLElement *ack=[message elementForName:@"ack" xmlnsPrefix:@"gy:clinentToServer:online"];
        //        NSString *ACKID = [[ack elementForName:@"id"] stringValue];
        //        if (ack&&ACKID) {
        //            //消息发送成功
        //            //NSLog(@"~~收到服务器回执ack说明消息发送成功，修改数据库并且更新表格");
        //            //修改数据库里的消息发送状态
        //            [GYChatItem changeSendMsgStatusWithACKID:ACKID WithStatus:kMessagSentState_Sent];
        //            NSDictionary *dic = @{@"ACKID":ACKID,@"State":@(kMessagSentState_Sent)};
        //            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameSendResult object:dic];
        //
        //        }
        [self.messageCenter ReceiveMessage:message];
        //        dispatch_async([self getMessageQueue], ^{
        //            IMMessageCenter *msgCent = [[IMMessageCenter alloc] initWithReceiveXMPPMessage:message];
        //            [msgCent forwardedReceiveMessage];
        //        });
    }
}

- (void)xmppStream:(XMPPStream*)sender didReceivePresence:(XMPPPresence*)presence
{
    if (kEnableNSLog)
        NSLog(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
    if (kEnableNSLog)
        NSLog(@"---%@: %@", sender, presence);
}

- (void)xmppStream:(XMPPStream*)sender didReceiveError:(NSXMLElement*)error
{
    if (kEnableNSLog)
        NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSXMLElement* conflictE = [error elementForName:@"conflict"];
    if (conflictE) {
        DDLogInfo(@"xmpp检测到你的账号在其它设备登录，你将被迫断开xmpp连接");
        globalData.isHdLogined = NO;
        self.messageCenter.state = GYHDMessageLoginStateOtherLogin;

            }
    else {
        //登录时的错误回调
        if (self.loginBlock) {
            self.loginState = kIMLoginStateUnknowError;
            self.loginBlock(kIMLoginStateUnknowError);
        }
        self.messageCenter.state = GYHDMessageLoginStateUnknowError;
    }
}

- (void)xmppStreamDidDisconnect:(XMPPStream*)sender withError:(NSError*)error
{
    if (kEnableNSLog)
        NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);

    if (self.loginBlock) {
        self.loginState = kIMLoginStateConnetToServerFailure;
        self.loginBlock(kIMLoginStateConnetToServerFailure);
    }
    if (self.messageCenter.state != GYHDMessageLoginStateOtherLogin) {
        self.messageCenter.state = GYHDMessageLoginStateConnetToServerFailure;
    }
}


@end
