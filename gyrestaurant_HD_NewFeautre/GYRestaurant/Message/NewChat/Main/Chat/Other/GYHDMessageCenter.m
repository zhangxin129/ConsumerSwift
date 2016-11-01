//
//  GYHDMessageCenter.m
//  HSConsumer
//
//  Created by shiang on 15/12/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDMessageCenter.h"
#import "GYHDDataBaseCenter.h"
#import "GYHDNetWorkTool.h"
//#import "GYDBCenter.h"
//#import "GYFMDBCityManager.h"
#import "EmojiTextAttachment.h"
#import <AudioToolbox/AudioToolbox.h>
#pragma mark - push
NSString * const GYHDDataBaseCenterPushMessageTableName     = @"T_PUSH_MSG";
NSString * const GYHDDataBaseCenterPushMessageID            = @"PUSH_MSG_ID";
NSString * const GYHDDataBaseCenterPushMessageCode          = @"PUSH_MSG_Code";
NSString * const GYHDDataBaseCenterPushMessagePlantFromID   = @"PUSH_MSG_PlantFormID";
NSString * const GYHDDataBaseCenterPushMessageToID          = @"PUSH_MSG_ToID";
NSString * const GYHDDataBaseCenterPushMessageFromID        = @"PUSH_MSG_FromID";
NSString * const GYHDDataBaseCenterPushMessageContent       = @"PUSH_MSG_Content";
NSString * const GYHDDataBaseCenterPushMessageBody          = @"PUSH_MSG_Body";
NSString * const GYHDDataBaseCenterPushMessageSendTime      = @"PUSH_MSG_SendTime";
NSString * const GYHDDataBaseCenterPushMessageRevieTime     = @"PUSH_MSG_RecvTime";
NSString * const GYHDDataBaseCenterPushMessageIsRead        = @"PUSH_MSG_Read";
NSString * const GYHDDataBaseCenterPushMessageData          = @"PUSH_MSG_DataString";
NSString * const GYHDDataBaseCenterPushMessageUnreadLocation= @"PUSH_MSG_UnreadLocation";
NSString * const GYHDDataBaseCenterPushMessageMainType       = @"PUSH_MSG_MainType";
NSString * const GYHDDataBaseCenterPushMessageSummary       = @"Summary";

#pragma mark -- MessageSql
NSString * const GYHDDataBaseCenterMessageTableName     = @"T_MESSAGE";
NSString * const GYHDDataBaseCenterMessageID            = @"MSG_ID";
NSString * const GYHDDataBaseCenterMessageFromID        = @"MSG_FromID";
NSString * const GYHDDataBaseCenterMessageToID          = @"MSG_ToID";
NSString * const GYHDDataBaseCenterMessageBody          = @"MSG_Body";
NSString * const GYHDDataBaseCenterMessageContent       = @"MSG_Content";
NSString * const GYHDDataBaseCenterMessageCode          = @"MSG_Type";
NSString * const GYHDDataBaseCenterMessageSendTime      = @"MSG_SendTime";
NSString * const GYHDDataBaseCenterMessageRevieTime     = @"MSG_RecvTime";
NSString * const GYHDDataBaseCenterMessageIsSelf        = @"MSG_Self";
NSString * const GYHDDataBaseCenterMessageIsRead        = @"MSG_Read";
NSString * const GYHDDataBaseCenterMessageSentState     = @"MSG_State";
NSString * const GYHDDataBaseCenterMessageCard          = @"MSG_Card";
NSString * const GYHDDataBaseCenterMessageData          = @"MSG_DataString";
NSString * const GYHDDataBaseCenterMessageUserState     = @"MSG_UserState";
#pragma mark -- FriendSql

NSString * const GYHDDataBaseCenterFriendTableName      = @"T_FRIENDS";
NSString * const GYHDDataBaseCenterFriendID             = @"ID";
NSString * const GYHDDataBaseCenterFriendFriendID       = @"Friend_ID";
NSString * const GYHDDataBaseCenterFriendCustID         = @"Friend_CustID";
NSString * const GYHDDataBaseCenterFriendUsetType       = @"Friend_UserType";
NSString * const GYHDDataBaseCenterFriendMessageTop     = @"Friend_MessageTop";
NSString * const GYHDDataBaseCenterFriendBasic          = @"Friend_Basic";
NSString * const GYHDDataBaseCenterFriendDetailed       = @"Friend_detailed";
NSString * const GYHDDataBaseCenterFriendName           = @"Friend_Name";
NSString * const GYHDDataBaseCenterFriendIcon           = @"Friend_Icon";
#pragma mark -- Friendtream
NSString * const GYHDDataBaseCenterFriendTeamTableName = @"T_TREAMS";
NSString * const GYHDDataBaseCenterFriendTeamID         = @"ID";
NSString * const GYHDDataBaseCenterFriendTeamTeamID    = @"Tream_ID";
NSString * const GYHDDataBaseCenterFriendTeamName      = @"Tream_Name";
NSString * const GYHDDataBaseCenterFriendTeamDetail    = @"Tream_detal";

#pragma mark -- userSeting
NSString * const GYHDDataBaseCenterUserSetingTableName      = @"T_USERSETING";
NSString * const GYHDDataBaseCenterUserSetingID             = @"ID";
NSString * const GYHDDataBaseCenterUserSetingName           = @"User_Name";
NSString * const GYHDDataBaseCenterUserSetingMessageTop     = @"User_MessageTop";
NSString * const GYHDDataBaseCenterUserSetingMessageTopDefualt = @"-1";

#pragma mark -- friendBasic
NSString * const GYHDDataBaseCenterFriendBasicAccountID = @"accountId";
NSString * const GYHDDataBaseCenterFriendBasicCustID = @"custId";
NSString * const GYHDDataBaseCenterFriendBasicIcon      = @"headPic";
NSString * const GYHDDataBaseCenterFriendBasicNikeName  = @"nickname";
NSString * const GYHDDataBaseCenterFriendBasicSignature = @"sign";
NSString * const GYHDDataBaseCenterFriendBasicTeamId   =  @"teamId";
NSString * const GYHDDataBaseCenterFriendBasicTeamName   = @"teamName";
NSString * const GYHDDataBaseCenterFriendBasicTeamRemark = @"teamRemark";

NSString * const GYHDMessageCenterDataBaseChageNotification = @"com.hsec.database.change";


@interface GYHDMessageCenter ()
@property(nonatomic ,strong) GYHDNetWorkTool *netWorkTool;

@property(nonatomic,strong)NSMutableArray *emojiDicArray;

@end

@implementation GYHDMessageCenter

- (GYHDNetWorkTool *)netWorkTool
{
    if (!_netWorkTool) {
        
        _netWorkTool = [GYHDNetWorkTool sharedInstance];
    
    }
    return _netWorkTool;
}
static id instance;

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
        
    });
    return instance;
}


+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (void)updateSendingState
{
    //查询发送数据状态
   NSArray *sendArray = [[GYHDDataBaseCenter sharedInstance] selectSendState:GYHDDataBaseCenterMessageSentStateSending];
    
    
    for (NSDictionary *dict in sendArray) {
        [self sendMessageWithDictionary:dict resend:YES];

    }
}

- (id)copyWithZone:(NSZone *)zone
{
    return instance;
}
// 互生消息 mestype 1
// 订单消息 mestype 2
// 互信消息 mestype 4;
// 订阅消息 mestype 2;
- (void)receiveProtobuf:(NSData *)protobuf {
    
    NSData *data = [NSData dataWithData:protobuf];
    DDLogCInfo(@"%@",protobuf);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        GYHDProtoBufHeader *header = [[GYHDProtoBufHeader alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 32)]];
        DDLogCInfo(@"cmd = %2x",header.cmdid);
        NSData *bodyData = [data subdataWithRange:NSMakeRange(32, header.pkLength - 32)];
        switch (header.cmdid) {
            case MsgCmdIDCidMessageLoginRes:{
                LoginRes *res = [LoginRes parseFromData:bodyData];
                DDLogCInfo(@"LoginRes = %d !=%@ 2=%llu",res.ret, res.errorInfo, res.userId);
                break;
            }
            case MsgCmdIDCidMessagePushNotify:{
                PushMsgNotify *push = [PushMsgNotify parseFromData:bodyData];
                NSMutableDictionary *pushMessageDict = [self saveWithPushMsgNotify:push];
                
                if ([[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:pushMessageDict TableName:GYHDDataBaseCenterPushMessageTableName]) {
                    PushMsgRecvedNotify *pushfy = [[[[[PushMsgRecvedNotify builder] setUserId:push.toid]setPlantformId:push.serverid]setMsgId:push.msgid] build];
                    GYHDProtoBufHeader *header = [[GYHDProtoBufHeader alloc] init];
                    header.cmdid = 0x3023;
                    NSData *sendData = [header DataWithProtobufData:[pushfy data]];
                    if ([self.delegate respondsToSelector:@selector(sendProtobufToServerWithData:)]) {
                        [self.delegate sendProtobufToServerWithData:sendData];
                    }
                }
                break;
            }
            case 0x3025: {
                RecentPushMsgsRsp *msgRsp = [RecentPushMsgsRsp parseFromData:bodyData];
                DDLogCInfo(@"RecentPushMsgsRs = %@ , %@\n\n",msgRsp.msgList, msgRsp.errorInfo);
                for (RecentPushMessage *message in msgRsp.msgList) {
            
                    if (message.unreads) {
                        GYHDProtoBufHeader *header = [[GYHDProtoBufHeader alloc] init];;
                        header.cmdid = 0x3026;
                        UInt64 userid =globalData.loginModel.custId.longLongValue;
                        GetOfflinePushMsgReq *req = [[[[[[GetOfflinePushMsgReq builder] setUserId:userid] setPlantformId:message.plantformId] setPullStart:message.msgId] setPullCount:message.unreads] build];
                        if ([self.delegate respondsToSelector:@selector(sendProtobufToServerWithData:)]) {
                            [self.delegate sendProtobufToServerWithData:[header DataWithProtobufData:[req data]]];
                        }
                    }
                }
                
                break;
            }
            case 0x3027: {
                GetOfflinePushMsgRsp *rsp = [GetOfflinePushMsgRsp parseFromData:bodyData];
                DDLogCInfo(@"GetOfflinePushMsgRsp = %@ , %@",rsp.msgList, rsp.errorInfo);
                for (PushMsgNotify *push in rsp.msgList) {
                    NSMutableDictionary *pushMessageDict = [self saveWithPushMsgNotify:push];
                    pushMessageDict[GYHDDataBaseCenterPushMessageData]          = [protobuf base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    
                    [[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:pushMessageDict TableName:GYHDDataBaseCenterPushMessageTableName];
                    
                    PushMsgRecvedNotify *pushfy = [[[[[PushMsgRecvedNotify builder] setUserId:push.toid] setPlantformId:push.serverid] setMsgId:push.msgid] build];
                    GYHDProtoBufHeader *header = [[GYHDProtoBufHeader alloc] init];
                    header.cmdid = 0x3023;
                    NSData *sendData = [header DataWithProtobufData:[pushfy data]];
                    if ([self.delegate respondsToSelector:@selector(sendProtobufToServerWithData:)]) {
                        [self.delegate sendProtobufToServerWithData:sendData];
                        
                    }
                    
                }
                
                break;
            }
            default:
                break;
        }
        
    });
}

- (NSMutableDictionary *)saveWithPushMsgNotify:(PushMsgNotify *)push {
    
    NSDictionary*contentDict=[NSJSONSerialization JSONObjectWithData:push.content options:NSJSONReadingMutableContainers error:nil];
    NSMutableDictionary *pushMessageDict = [NSMutableDictionary dictionary];
    NSString *sendTime = contentDict[@"time"];
    NSString *sendDateString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",
                                [sendTime substringWithRange:NSMakeRange(0, 4)],
                                [sendTime substringWithRange:NSMakeRange(4, 2)],
                                [sendTime substringWithRange:NSMakeRange(6, 2)],
                                [sendTime substringWithRange:NSMakeRange(8, 2)],
                                [sendTime substringWithRange:NSMakeRange(10, 2)],
                                [sendTime substringWithRange:NSMakeRange(12, 2)]];
    NSDate *nowdata = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *recvDateString = [formatter stringFromDate:nowdata];
    NSDictionary *bodyDict = contentDict[@"content"];
     pushMessageDict[GYHDDataBaseCenterPushMessageCode]         = @(push.msgtype);
    pushMessageDict[GYHDDataBaseCenterPushMessageID]            = [NSString stringWithFormat:@"%lld",push.msgid];
    pushMessageDict[GYHDDataBaseCenterPushMessagePlantFromID]   = [NSString stringWithFormat:@"%d",push.serverid];
    pushMessageDict[GYHDDataBaseCenterPushMessageFromID]        = [NSString stringWithFormat:@"%lld",push.fromuid];
    pushMessageDict[GYHDDataBaseCenterPushMessageToID]          = [NSString stringWithFormat:@"%lld",push.toid];
    pushMessageDict[GYHDDataBaseCenterPushMessageContent]       = bodyDict[@"msg_content"];
    pushMessageDict[GYHDDataBaseCenterPushMessageBody]       = [Utils dictionaryToString:bodyDict];
    pushMessageDict[GYHDDataBaseCenterPushMessageSendTime]      = sendDateString;
    pushMessageDict[GYHDDataBaseCenterPushMessageRevieTime]     = recvDateString;
    pushMessageDict[GYHDDataBaseCenterPushMessageIsRead]        =@(1);
    dispatch_async(dispatch_get_main_queue(), ^{
          [[NSNotificationCenter defaultCenter] postNotificationName:@"pushMessage" object:nil];
    });
  
    return pushMessageDict;
}


- (void)ReceiveMessage:(XMPPMessage *)message
{
    //1. 解析数据
    XMPPMessage *recvMessage = message;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *body = [[recvMessage elementForName:@"body"] stringValue];
        NSString *fromJID = [[recvMessage attributeForName:@"from"] stringValue];
//        NSString *jidString = [[[XMPPJID jidWithString:fromJID] bareJID] bare];
        NSString *messageId = [[recvMessage attributeForName:@"id"] stringValue];
        NSString *toID=[[recvMessage attributeForName:@"to"] stringValue];
        NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
//        NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithDictionary:[Utils stringToDictionary:body]];
        NSMutableDictionary *bodyDict = [NSMutableDictionary
                                         dictionaryWithDictionary:[Utils stringToDictionaryEscapseHtml:body]];
        [self checkDict:bodyDict];
        messageDict[GYHDDataBaseCenterMessageID] = messageId;
        messageDict[GYHDDataBaseCenterMessageFromID] = fromJID;
        messageDict[GYHDDataBaseCenterMessageToID] = toID;
        messageDict[GYHDDataBaseCenterMessageBody] = [Utils dictionaryToString:bodyDict];
        
        //消费者 及时聊天
        switch ([bodyDict[@"msg_code"]integerValue]) {
            case GYHDDataBaseCenterMessageChatText:     //文本消息
            case GYHDDataBaseCenterMessageChatPicture:  //图片消息
                

            {
                messageDict[GYHDDataBaseCenterMessageCode] = @(GYHDDataBaseCenterMessageTypeChat);
                if ([bodyDict[@"msg_code"] integerValue] ==
                    GYHDDataBaseCenterMessageChatText) {
                    messageDict[GYHDDataBaseCenterMessageContent] =
                    bodyDict[@"msg_content"];
                } else {
                    messageDict[GYHDDataBaseCenterMessageContent] = @"[图片]";
                }
                NSString *pattern = @"\\d+";
                NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
                // 2.测试字符串
                NSArray *results = [regex matchesInString:fromJID options:0 range:NSMakeRange(0,fromJID.length)];
                // 3.遍历结果
                NSTextCheckingResult *result =  [results firstObject];
                messageDict[GYHDDataBaseCenterMessageCard] = [fromJID substringWithRange:result.range];
                
                NSString *pattern1 = @"[a-zA-Z]_\\d{11}";
                NSRegularExpression *regex1 = [[NSRegularExpression alloc] initWithPattern:pattern1 options:0 error:nil];
                // 2.测试字符串
                NSArray *results1 = [regex1 matchesInString:fromJID options:0 range:NSMakeRange(0,fromJID.length)];
                // 3.遍历结果
                NSTextCheckingResult *result1 =  [results1 firstObject];
                NSMutableDictionary *friendBaseDict = [NSMutableDictionary dictionary];
                friendBaseDict[GYHDDataBaseCenterFriendBasicAccountID] = [fromJID substringWithRange:result1.range];
                friendBaseDict[GYHDDataBaseCenterFriendBasicCustID] = messageDict[GYHDDataBaseCenterMessageCard];
                friendBaseDict[GYHDDataBaseCenterFriendBasicIcon] = bodyDict[@"msg_icon"];
                friendBaseDict[GYHDDataBaseCenterFriendBasicNikeName] = bodyDict[@"msg_note"];
                
                
                break;
            }
            case GYHDDataBaseCenterMessageChatGoods:
            case GYHDDataBaseCenterMessageChatOrder://关联商品
            {
            
                messageDict[GYHDDataBaseCenterMessageCode] = @([bodyDict[@"msg_code"] integerValue]);
                
                if ([bodyDict[@"msg_code"] integerValue] ==
                    GYHDDataBaseCenterMessageChatGoods) {
                    messageDict[GYHDDataBaseCenterMessageContent] =
                    @"商品消息";
                } else {
                    messageDict[GYHDDataBaseCenterMessageContent] = @"订单消息";
                }
                NSString *pattern = @"\\d+";
                NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
                // 2.测试字符串
                NSArray *results = [regex matchesInString:fromJID options:0 range:NSMakeRange(0,fromJID.length)];
                // 3.遍历结果
                NSTextCheckingResult *result =  [results firstObject];
                messageDict[GYHDDataBaseCenterMessageCard] = [fromJID substringWithRange:result.range];
                
                NSString *pattern1 = @"[a-zA-Z]_\\d{11}";
                NSRegularExpression *regex1 = [[NSRegularExpression alloc] initWithPattern:pattern1 options:0 error:nil];
                // 2.测试字符串
                NSArray *results1 = [regex1 matchesInString:fromJID options:0 range:NSMakeRange(0,fromJID.length)];
                // 3.遍历结果
                NSTextCheckingResult *result1 =  [results1 firstObject];
                NSMutableDictionary *friendBaseDict = [NSMutableDictionary dictionary];
                friendBaseDict[GYHDDataBaseCenterFriendBasicAccountID] = [fromJID substringWithRange:result1.range];
                friendBaseDict[GYHDDataBaseCenterFriendBasicCustID] = messageDict[GYHDDataBaseCenterMessageCard];
                friendBaseDict[GYHDDataBaseCenterFriendBasicIcon] = bodyDict[@"msg_icon"];
                friendBaseDict[GYHDDataBaseCenterFriendBasicNikeName] = bodyDict[@"msg_note"];
                

            
            }
                break;
                
            case GYHDDataBaseCenterMessageChatAudio:    //音频消息
            {
                messageDict[GYHDDataBaseCenterMessageContent] = @"[音频]";
                messageDict[GYHDDataBaseCenterMessageCode] = @(GYHDDataBaseCenterMessageTypeChat);
                NSString *pattern = @"\\d+";
                NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
                // 2.测试字符串
                NSArray *results = [regex matchesInString:fromJID options:0 range:NSMakeRange(0,fromJID.length)];
                // 3.遍历结果
                NSTextCheckingResult *result =  [results firstObject];
                
                NSString *pattern1 = @"[a-zA-Z]_\\d{11}";
                NSRegularExpression *regex1 = [[NSRegularExpression alloc] initWithPattern:pattern1 options:0 error:nil];
                // 2.测试字符串
                NSArray *results1 = [regex1 matchesInString:fromJID options:0 range:NSMakeRange(0,fromJID.length)];
                // 3.遍历结果
                NSTextCheckingResult *result1 =  [results1 firstObject];

                
                messageDict[GYHDDataBaseCenterMessageCard] = [fromJID substringWithRange:result.range];
                NSInteger timeNumber = arc4random_uniform(1000)+[[NSDate date] timeIntervalSince1970];
                NSString *mp3Name = [NSString stringWithFormat:@"audio%ld.mp3",timeNumber];
                NSString *filePath = [NSString pathWithComponents:@[[[GYHDMessageCenter sharedInstance] mp3folderNameString],mp3Name]];
                [self.netWorkTool downloadDataWithUrlString:bodyDict[@"msg_content"] filePath:filePath];
                
                NSMutableDictionary *saveDict = [NSMutableDictionary dictionary];
                saveDict[@"mp3"] = mp3Name;
                saveDict[@"mp3Len"] = bodyDict[@"msg_fileSize"];
                saveDict[@"read"]= @"0";
                messageDict[GYHDDataBaseCenterMessageData] = [Utils dictionaryToString:saveDict];
                
                NSMutableDictionary *friendBaseDict = [NSMutableDictionary dictionary];
                friendBaseDict[GYHDDataBaseCenterFriendBasicAccountID] = [fromJID substringWithRange:result1.range];
                friendBaseDict[GYHDDataBaseCenterFriendBasicCustID] = messageDict[GYHDDataBaseCenterMessageCard];
                friendBaseDict[GYHDDataBaseCenterFriendBasicIcon] = bodyDict[@"msg_icon"];
                friendBaseDict[GYHDDataBaseCenterFriendBasicNikeName] = bodyDict[@"msg_note"];
                
                break;
            }
                
            case GYHDDataBaseCenterMessageChatVideo:    //视频消息
            {
                messageDict[GYHDDataBaseCenterMessageContent] = @"[视频]";
                messageDict[GYHDDataBaseCenterMessageCode] = @(GYHDDataBaseCenterMessageTypeChat);
                NSString *pattern = @"\\d+";
                NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
                // 2.测试字符串
                NSArray *results = [regex matchesInString:fromJID options:0 range:NSMakeRange(0,fromJID.length)];
                // 3.遍历结果
                NSTextCheckingResult *result =  [results firstObject];
                
                NSString *pattern1 = @"[a-zA-Z]_\\d{11}";
                NSRegularExpression *regex1 = [[NSRegularExpression alloc] initWithPattern:pattern1 options:0 error:nil];
                // 2.测试字符串
                NSArray *results1 = [regex1 matchesInString:fromJID options:0 range:NSMakeRange(0,fromJID.length)];
                // 3.遍历结果
                NSTextCheckingResult *result1 =  [results1 firstObject];
                
                messageDict[GYHDDataBaseCenterMessageCard] = [fromJID substringWithRange:result.range];
                NSInteger timeNumber = arc4random_uniform(1000)+[[NSDate date] timeIntervalSince1970];
                NSString *mp4Name = [NSString stringWithFormat:@"video%ld.mp4",timeNumber];
                NSString *filePath = [NSString pathWithComponents:@[[[GYHDMessageCenter sharedInstance] mp4folderNameString],mp4Name]];
                [self.netWorkTool downloadDataWithUrlString:bodyDict[@"msg_content"] filePath:filePath];
                
                NSMutableDictionary *saveDict = [NSMutableDictionary dictionary];
                saveDict[@"mp4Name"] = mp4Name;
                saveDict[@"thumbnailsName"] = bodyDict[@"msg_imageNail"];
                saveDict[@"read"]= @"0";
                messageDict[GYHDDataBaseCenterMessageData] = [Utils dictionaryToString:saveDict];
                
                NSMutableDictionary *friendBaseDict = [NSMutableDictionary dictionary];
                friendBaseDict[GYHDDataBaseCenterFriendBasicAccountID] = [fromJID substringWithRange:result1.range];
                friendBaseDict[GYHDDataBaseCenterFriendBasicCustID] = messageDict[GYHDDataBaseCenterMessageCard];
                friendBaseDict[GYHDDataBaseCenterFriendBasicIcon] = bodyDict[@"msg_icon"];
                friendBaseDict[GYHDDataBaseCenterFriendBasicNikeName] = bodyDict[@"msg_note"];
                
                break;
            }
            default:
                break;
        }
        NSDate *sendData = [[NSDate alloc] initWithTimeIntervalSince1970:messageId.longLongValue / 1000];;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *sendDateString = [formatter stringFromDate:sendData];
        NSString *recvDateString = [formatter stringFromDate:[NSDate date]];
        messageDict[GYHDDataBaseCenterMessageSendTime] = sendDateString;
        messageDict[GYHDDataBaseCenterMessageRevieTime] = recvDateString;
        messageDict[GYHDDataBaseCenterMessageIsSelf]    = @(0);
        messageDict[GYHDDataBaseCenterMessageIsRead]    = @(1);
        messageDict[GYHDDataBaseCenterMessageSentState] = @(GYHDDataBaseCenterMessageSentStateSuccess);
        
        if ([fromJID hasPrefix:@"m_c_"]||[fromJID hasPrefix:@"w_c_"] || [fromJID hasPrefix:@"m_nc_"]||[fromJID hasPrefix:@"w_nc_"]) {
            messageDict[GYHDDataBaseCenterMessageUserState] = @"c";
        }
        if ([fromJID hasPrefix:@"m_e_"]||[fromJID hasPrefix:@"w_e_"]){
            
            messageDict[GYHDDataBaseCenterMessageUserState] = @"e";
        }
     
            NSDictionary *dict =  [[GYHDMessageCenter sharedInstance] selectFriendBaseWithCardString:messageDict[GYHDDataBaseCenterMessageCard]];
        
            NSMutableDictionary *friendDict = [NSMutableDictionary dictionary];
//        if ([fromJID hasPrefix:@"nc"]) {
//            
//            friendDict[GYHDDataBaseCenterFriendFriendID]       = [fromJID substringWithRange:NSMakeRange(2, 13)];
//        }
            friendDict[GYHDDataBaseCenterFriendFriendID]       = [fromJID substringWithRange:NSMakeRange(0, 23)];
//            friendDict[GYHDDataBaseCenterFriendFriendID]       = fromJID;
            friendDict[GYHDDataBaseCenterFriendCustID]         =  messageDict[GYHDDataBaseCenterMessageCard];
            friendDict[GYHDDataBaseCenterFriendName]           = bodyDict[@"msg_note"];
            friendDict[GYHDDataBaseCenterFriendIcon]           = bodyDict[@"msg_icon"];
        if ([fromJID hasPrefix:@"nc"]) {
            friendDict[GYHDDataBaseCenterFriendUsetType]       = [fromJID substringWithRange:NSMakeRange(2, 2)];
        }else{
        
            friendDict[GYHDDataBaseCenterFriendUsetType]       = [fromJID substringWithRange:NSMakeRange(2, 1)];
        }
        
            friendDict[GYHDDataBaseCenterFriendMessageTop]     = @"-1";
        friendDict[GYHDDataBaseCenterFriendBasic]          = [Utils dictionaryToString:bodyDict];
        
            friendDict[GYHDDataBaseCenterFriendDetailed ] = [Utils dictionaryToString:bodyDict];
        
        
            if ([dict allKeys].count <=0) {
                
                [[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:friendDict TableName:GYHDDataBaseCenterFriendTableName];
                
            } else {
                NSMutableDictionary *conditionDict = [NSMutableDictionary dictionary];
                conditionDict[GYHDDataBaseCenterFriendCustID] =   messageDict[GYHDDataBaseCenterMessageCard];
                
                NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
                updateDict[GYHDDataBaseCenterFriendName]           = bodyDict[@"msg_note"];
                updateDict[GYHDDataBaseCenterFriendIcon]           = bodyDict[@"msg_icon"];
                if (updateDict.allKeys.count == 2) {
                    
                    [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterFriendTableName];
                
                }
            }
        
        if ( [[GYHDDataBaseCenter sharedInstance] saveMessageWithDict:messageDict]){
            [self postDataBaseChangeNotificationWithDict:messageDict];
//                AudioServicesPlaySystemSound(1002);
            NSArray *pushArray = [[NSUserDefaults standardUserDefaults]objectForKey:globalData.loginModel.custId];
            
            
            if (pushArray.count==4) {
                
                if ([pushArray[0]isEqualToNumber:@1]) {
                    
                    //全天不提示消息
                }
                
                else if ([pushArray[1]isEqualToNumber:@1]) {
                    //夜间不提示消息,白天提示消息
                    
                    if ([Utils isBetweenFromHour:8 toHour:22]) {
                        
                        if ([pushArray[3]isEqualToNumber:@1]) {
                            
                            //震动提示
                            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                            
                        }
                        if ([pushArray[2]isEqualToNumber:@1]){
                            //声音提示
                            AudioServicesPlaySystemSound(1007);
                        }
                    }
                }
                
                else if ([pushArray[0]isEqualToNumber:@0]) {
                    //默认全天提示消息
                    
                    if ([pushArray[3]isEqualToNumber:@1]) {
                        
                        //震动提示
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                        
                    }
                    if ([pushArray[2]isEqualToNumber:@1]){
                        //声音提示
                        AudioServicesPlaySystemSound(1007);
                    }
                }
                
                else if ([pushArray[1]isEqualToNumber:@0]) {
                    //默认夜间提示消息
                    
                    if ([pushArray[3]isEqualToNumber:@1]) {
                        
                        //震动提示
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                        
                    }
                    if ([pushArray[2]isEqualToNumber:@1]){
                        //声音提示
                        AudioServicesPlaySystemSound(1007);
                    }
                }
                
            }
            
//            [self postDataBaseChangeNotification];
        }

    });
}
/***/
/**
 * 发送消息到服务器
 */
- (void)sendMessageWithDictionary:(NSDictionary *)dict resend:(BOOL)resend {
    //1.保存到数据库
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!resend) {
            
            [[GYHDDataBaseCenter sharedInstance] saveMessageWithDict:dict];
        }
        NSDictionary *bodyDict =  [Utils stringToDictionary:dict[@"MSG_Body"]];
        NSDictionary *saveDict = [Utils stringToDictionary:dict[GYHDDataBaseCenterMessageData]];
        switch ([bodyDict[@"msg_code"] integerValue]) {
                case GYHDDataBaseCenterMessageChatText:
            {
                if ([self.delegate respondsToSelector:@selector(sendToServerWithDict:)]) {
                    [self.delegate sendToServerWithDict:dict];
                }
                break;
            }
            case GYHDDataBaseCenterMessageChatPicture://图片消息
            {

                NSString *iamgePath = [NSString pathWithComponents:@[[self imagefolderNameString],saveDict[@"originalName"]]];
                NSData *imageData = [NSData dataWithContentsOfFile:iamgePath];
                [self.netWorkTool postImageWithData:imageData RequetResult:^(NSDictionary *resultDict) {
                    
                    if (resultDict||[resultDict allKeys].count>0) {
                        NSMutableDictionary *sendDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                        NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithDictionary:[Utils stringToDictionary:dict[GYHDDataBaseCenterMessageBody]]];
                        NSString *bigImageUrlStr = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"bigImgUrl"]];
                        NSString *smallImageUrlStr = nil;
                        if ([[resultDict allKeys] containsObject:@"smallImgUrl"]) {
                            smallImageUrlStr = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"smallImgUrl"]];
                        } else {
                            smallImageUrlStr = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"bigImgUrl"]];
                        }
                        bodyDict[@"msg_imageNailsUrl"] =  smallImageUrlStr;;
                        bodyDict[@"msg_content"] = bigImageUrlStr;;
                        bodyDict[@"msg_imageNails_width"] = @"150";
                        bodyDict[@"msg_imageNails_height"] = @"150";
                        sendDict[GYHDDataBaseCenterMessageBody] = [Utils dictionaryToString:bodyDict];
                        if ([self.delegate respondsToSelector:@selector(sendToServerWithDict:)]) {
                            [self.delegate sendToServerWithDict:sendDict];
                        }
                    } else {
                        [[GYHDMessageCenter sharedInstance] updateMessageStateWithMessageID:dict[GYHDDataBaseCenterMessageID] State:GYHDDataBaseCenterMessageSentStateFailure];
                    }
       
                }];
                break;
            }
                
            case GYHDDataBaseCenterMessageChatAudio://音频消息
            {
                
                
                NSString *audioPath = [NSString pathWithComponents:@[[self mp3folderNameString],saveDict[@"mp3"]]];
                NSData *audioData = [NSData dataWithContentsOfFile:audioPath];
                [self.netWorkTool postAudioWithData:audioData RequetResult:^(NSDictionary *resultDict) {
                    
                    if (resultDict||[resultDict allKeys].count>0) {
                        NSMutableDictionary *sendDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                        NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithDictionary:[Utils stringToDictionary:dict[GYHDDataBaseCenterMessageBody]]];
              
                        NSString *mp3Url = [NSString stringWithFormat:@"%@%@",resultDict[@"tfsServerUrl"],resultDict[@"audioUrl"]];
                        bodyDict[@"msg_content"] = mp3Url;
//                        bodyDict[@"msg_fileSize"] = resultDict[@"timelen"];
                        sendDict[GYHDDataBaseCenterMessageBody] = [Utils dictionaryToString:bodyDict];
                        if ([self.delegate respondsToSelector:@selector(sendToServerWithDict:)]) {
                            [self.delegate sendToServerWithDict:sendDict];
                        }
                    } else {
                        [[GYHDMessageCenter sharedInstance] updateMessageStateWithMessageID:dict[GYHDDataBaseCenterMessageID] State:GYHDDataBaseCenterMessageSentStateFailure];
                    }
                    
                }];
                break;
            }
                case GYHDDataBaseCenterMessageChatVideo:
            {
                if (saveDict==nil) {
                    
                    return ;
                }
                NSString *videoPath = [NSString pathWithComponents:@[[self mp4folderNameString],saveDict[@"mp4Name"]]];
                NSData *videoData = [NSData dataWithContentsOfFile:videoPath];
                
                [self.netWorkTool postVideoWithData:videoData RequetResult:^(NSDictionary *resultDict) {
                    
                    if (resultDict||[resultDict allKeys].count>0) {
                        NSMutableDictionary *sendDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                        NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithDictionary:[Utils stringToDictionary:dict[GYHDDataBaseCenterMessageBody]]];
                        NSString *mp4VideoPath =[NSString stringWithFormat:@"%@%@",resultDict[@"tfsServerUrl"],resultDict[@"videoUrl"]];
                        NSString *mp4ImagePath = [NSString stringWithFormat:@"%@%@",resultDict[@"tfsServerUrl"],resultDict[@"firstFrameUrl"]];
                        bodyDict[@"msg_content"] = mp4VideoPath;
                        bodyDict[@"msg_imageNail"] = mp4ImagePath;
 
                        sendDict[GYHDDataBaseCenterMessageBody] = [Utils dictionaryToString:bodyDict];
                        if ([self.delegate respondsToSelector:@selector(sendToServerWithDict:)]) {
                            [self.delegate sendToServerWithDict:sendDict];
                        }
                    } else {
                        [[GYHDMessageCenter sharedInstance] updateMessageStateWithMessageID:dict[GYHDDataBaseCenterMessageID] State:GYHDDataBaseCenterMessageSentStateFailure];
                    }
                    
                }];
                
                break;
            }
            default:
                break;
        }

    });
    
    
    
}


#pragma mark -- sql 语句查询
- (NSArray <NSDictionary *>*)selectAllChatWithCard:(NSString *)cardStr frome:(NSInteger)from to:(NSInteger)to
{
    return [[GYHDDataBaseCenter sharedInstance] selectAllChatWithCard:cardStr frome:from to:to];
}
- (NSArray <NSDictionary *>*)selectGroupMessage
{
    return [[GYHDDataBaseCenter sharedInstance] selectGroupMessage];
}
- (NSString *)UnreadMessageCountWithCard:(NSString *)CardStr;
{
    return [[GYHDDataBaseCenter sharedInstance] UnreadMessageCountWithCard:CardStr];
}

- (NSString *)UnreadAllMessageCount
{
    return [[GYHDDataBaseCenter sharedInstance] UnreadAllMessageCount];
}
- (void)savedbFull:(NSString *)dbFull
{
    return [[GYHDDataBaseCenter sharedInstance] savedbFull:dbFull];
}

- (BOOL)ClearUnreadMessageWithCard:(NSString *)CardStr
{
    if ([[GYHDDataBaseCenter sharedInstance] ClearUnreadMessageWithCard:CardStr]) {
        [self postDataBaseChangeNotificationWithDict:nil];
        return YES;
    }
    return NO;
}
/**
 * 消息分两个数组， 一个数组为推送消息，一个数组为及时聊天消息，小数组里包含每条消息的最后一条记录的字典
 */
- (NSArray <NSArray <NSDictionary *>*>*)selectLastGroupMessage
{
     return [[GYHDDataBaseCenter sharedInstance] selectLastGroupMessage];
}
#warning 消息列表新界面修改
//获取推送消息最后一条数组
- (NSArray <NSArray <NSDictionary *>*>*)selectLastGroupPushMessage{

    return [[GYHDDataBaseCenter sharedInstance]selectLastGroupPushMessage];
}
//获取聊天消息最后一条消息数组
- (NSArray <NSArray <NSDictionary *>*>*)selectLastGroupChatAllMessage{

    return [[GYHDDataBaseCenter sharedInstance]selectLastGroupChatAllMessage];
}
/**
 * 查询某类推送消息未读统计
 */
- (NSString*)UnreadPushMessageCountWithMsgID:(NSString *)msgID{

    return [[GYHDDataBaseCenter sharedInstance]UnreadPushMessageCountWithMsgID:msgID];
}
/**
 * 查询指定用户所有消息未读统计
 */
- (NSInteger)UnreadAllMessageCountWithCard:(NSString *)CardStr{


    return [[GYHDDataBaseCenter sharedInstance]UnreadAllMessageCountWithCard:CardStr];
}
/**
 * 清零消息
 */
- (BOOL)ClearUnreadMessage{

    return [[GYHDDataBaseCenter sharedInstance] ClearUnreadMessage];
}
/**
 * 清零所有已读推送信息
 */
- (BOOL)ClearUnreadPushMessageWithCard:(NSString *)CardStr{


    return [[GYHDDataBaseCenter sharedInstance]ClearUnreadPushMessageWithCard:CardStr];

}
/**
 * 清零某一条已读推送信息
 */
- (BOOL)ClearUnreadPushMessageWithCard:(NSString *)CardStr messageId:(NSString*)messageId{


    return [[GYHDDataBaseCenter sharedInstance]ClearUnreadPushMessageWithCard:CardStr messageId:messageId];


}
/**
 * 查询订单类推送消息
 */
- (NSArray *)selectPushMsgWithselectCount:(NSInteger)selectCount {
    return [[GYHDDataBaseCenter sharedInstance] selectPushMsgWithselectCount:selectCount];
}
/**
 * 查询push互生类型的所有消息
 */
- (NSArray *)selectPushAllHuShengMsgListWithselectCount:(NSInteger)selectCount {
    return  [[GYHDDataBaseCenter sharedInstance] selectPushAllHuShengMsgListWithselectCount:selectCount];
}
/**
 * 查询push服务类型的所有消息
 */
- (NSArray *)selectPushAllFuWuMsgListWithselectCount:(NSInteger)selectCount {
    return  [[GYHDDataBaseCenter sharedInstance] selectPushAllFuWuMsgListWithselectCount:selectCount];
}

/**
 * 查询所有订单消息
 */
- (NSArray *)selectAllDingDanList
{
    return [[GYHDDataBaseCenter sharedInstance] selectAllDingDanList];
}
/**
 * 查询某种类型的所有消息
 */
- (NSArray *)selectAllMessageListWithMessageCard:(NSString *)messageCard
{
    return  [[GYHDDataBaseCenter sharedInstance] selectAllMessageListWithMessageCard:messageCard];
}

- (BOOL)updateMessageStateWithMessageID:(NSString *)messageID State:(GYHDDataBaseCenterMessageSentStateOption) state {
    if (![[GYHDDataBaseCenter sharedInstance] updateMessageStateWithMessageID:messageID State:state])return NO;
    
    NSDictionary *dict = @{@"msgID":messageID,@"State":@(state)};
    [self postDataBaseChangeNotificationWithDict:dict];
//   [self postDataBaseChangeNotification];
    return YES;
}

/**查询某个好友基本信息*/
- (NSDictionary *)selectFriendBaseWithCardString:(NSString *)card
{
    return [[GYHDDataBaseCenter sharedInstance] selectfriendBaseWithCardStr:card];
}
#pragma mark -置顶消息and清除消息
/**
 * 消息置顶
 */
- (BOOL)msgTopWithCustId:(NSString *)custId {
    
    if (![[GYHDDataBaseCenter sharedInstance] msgTopWithCustId:custId]) return NO;
    
    [self postDataBaseChangeNotificationWithDict:nil];
    
    return YES;
}
/**
 * 消息取消置顶
 */
- (BOOL)msgClearTopWhitCustId:(NSString *)custId {
    if (![[GYHDDataBaseCenter sharedInstance] msgClearTopWhitCustId:custId])
        return NO;
    [self postDataBaseChangeNotificationWithDict:nil];
    return YES;
}

//推送消息置顶
- (BOOL)pushMsgTopWithMessageType:(NSString *)messageMainType{
    
    if (![[GYHDDataBaseCenter sharedInstance]pushMsgTopWithMessageType:messageMainType]) {
        
        return NO;
    }
    
    [self postDataBaseChangeNotificationWithDict:nil];
    
    return YES;
}

//推送消息清除置顶
- (BOOL)pushMsgClearTopWithMessageType:(NSString *)messageMainType{
    
    if (![[GYHDDataBaseCenter sharedInstance]pushMsgClearTopWithMessageType:messageMainType]) {
        
        return NO;
    }
    
    [self postDataBaseChangeNotificationWithDict:nil];
    
    
    return YES;
}
/**
 * 删除消息
 */
- (BOOL)deleteMessageWithMessageCard:(NSString *)messageCard
{
    if (![[GYHDDataBaseCenter sharedInstance] deleteMessageWithMessageCard:messageCard]) return NO;
    [self postDataBaseChangeNotificationWithDict:nil];
    return YES;
}
/**根据某个删除消息*/
- (BOOL)deleteMessageWithMessage:(NSString *)message fieldName:(NSString *)fieldName {
    if (![[GYHDDataBaseCenter sharedInstance] deleteMessageWithMessage:message fieldName:fieldName])
        return NO;
    return YES;
}
#pragma mark -- 发通知

- (void)postDataBaseChangeNotificationWithDict:(NSDictionary *)dict
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:GYHDMessageCenterDataBaseChageNotification  object:dict];
    });
}
/**
 * 发送即时聊天通知
 */
- (void)postDataBaseChangeNotification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:GYHDMessageCenterDataBaseChageNotification  object:nil];
    });
}
/**
 * 添加通知
 */

- (void)addDataBaseChangeNotificationObserver:(id)observer selector:(SEL)aSelector
{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:GYHDMessageCenterDataBaseChageNotification object:nil];
}
/**
 * 移除通知
 */
- (void)removeDataBaseChangeNotificationWithObserver:(id)observer
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}


/**
 * 把字典所以值转换成字符串
 */
- (void)checkDict:(NSMutableDictionary *)dict
{
    for (NSString *key in [dict allKeys]) {
        if([dict[key] isEqual:[NSNull null]] || dict[key] == nil)
        {
            dict[key] = @"";
        }
        if ([dict[key] isKindOfClass:[NSNumber class]]) {
            dict[key] = [NSString stringWithFormat:@"%@",dict[key]];
            
        }
        if ([dict[key] isKindOfClass:[NSDictionary class]]) {
            [ self checkDict:dict[key]];
        }
        if ([dict[key] isKindOfClass:[NSArray class]]) {
            for (NSMutableDictionary *chilidDict in dict[key]) {
                [self checkDict:chilidDict];
            }
//            for (NSString *chilidKey in [dict[key] allKeys]) {
//                [ self checkDict:dict[key][chilidKey]];
//            }
        }
    }
    
}
- (void) readAudioMessageID:(NSString *)messageID RequetResultWithDictBlock:(RequetResultWithDict)block
{
    //1.下载音频
    //2.回传block
}


/**
 * 根据时间字符串返回需要的文字
 */
- (NSString *)messageTimeStrFromTimerString:(NSString *)timeString
{
    if (!timeString || [timeString isEqualToString:@""]) return @"";
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];

    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //    _created_at = @"Tue Sep 30 17:06:25 +0600 2014";
    
    // 微博的创建日期
    NSDate *createDate = [fmt dateFromString:timeString];
    // 当前时间
//    NSDate *now = [NSDate date];
    
    // 日历对象（方便比较两个日期之间的差距）
//    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
//    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
//    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
    
    if ( [self isThisYearWithData:createDate]) { // 今年
        if ([self isTheDayBeforeYesterdayWithData:createDate]) {
            fmt.dateFormat = @"前天";
        } else if ([self isYesterdayData:createDate]) { // 昨天
            fmt.dateFormat = @"昨天";
            return [fmt stringFromDate:createDate];
        } else if ([self isTodayData:createDate]) { // 今天
            fmt.dateFormat = @"HH:mm";
            return [fmt stringFromDate:createDate];
        } else { // 今年的其他日子
            fmt.dateFormat = @"yyyy-MM-dd";
            return [fmt stringFromDate:createDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }
    return @"";
}
/**
 *  判断某个时间是否为今年
 */
- (BOOL)isThisYearWithData:(NSDate *)oldData
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 获得某个时间的年月日时分秒
    NSDateComponents *dateCmps = [calendar components:NSCalendarUnitYear fromDate:oldData];
    NSDateComponents *nowCmps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    return dateCmps.year == nowCmps.year;
}

/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterdayData:(NSDate *)oldData
{
    NSDate *now = [NSDate date];
    
    // date ==  2014-04-30 10:05:28 --> 2014-04-30 00:00:00
    // now == 2014-05-01 09:22:10 --> 2014-05-01 00:00:00
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    // 2014-04-30
    NSString *dateStr = [fmt stringFromDate:oldData];
    // 2014-10-18
    NSString *nowStr = [fmt stringFromDate:now];
    
    // 2014-10-30 00:00:00
    NSDate *date = [fmt dateFromString:dateStr];
    // 2014-10-18 00:00:00
    now = [fmt dateFromString:nowStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:now options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}
/**
 * 判断某个时间是否为前天
 */
- (BOOL)isTheDayBeforeYesterdayWithData:(NSDate *)oldData
{
    NSDate *now = [NSDate date];
    
    // date ==  2014-04-30 10:05:28 --> 2014-04-30 00:00:00
    // now == 2014-05-01 09:22:10 --> 2014-05-01 00:00:00
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    // 2014-04-30
    NSString *dateStr = [fmt stringFromDate:oldData];
    // 2014-10-18
    NSString *nowStr = [fmt stringFromDate:now];
    
    // 2014-10-30 00:00:00
    NSDate *date = [fmt dateFromString:dateStr];
    // 2014-10-18 00:00:00
    now = [fmt dateFromString:nowStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:now options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 2;
}
/**
 *  判断某个时间是否为今天
 */
- (BOOL)isTodayData:(NSDate *)oldData
{
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [fmt stringFromDate:oldData];
    NSString *nowStr = [fmt stringFromDate:now];
    
    return [dateStr isEqualToString:nowStr];
}
/**
 * 取得图片
 */
- (void)messageContentAttributedStringWithString:(NSString *)string AttrString:(NSMutableAttributedString *)messageAttrStr
{
    NSString *pattern = @"\\[[0-9]{3}\\]";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    // 2.测试字符串
    NSArray *results = [regex matchesInString:string options:0 range:NSMakeRange(0,string.length)];
    // 3.遍历结果
    [results enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult *result, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *imageName = [[string substringWithRange:result.range] substringWithRange:NSMakeRange(1, 3)];
        NSTextAttachment *textAtt = [[NSTextAttachment alloc] init];
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            textAtt.image = image;
            textAtt.bounds = CGRectMake(0, -3, 13, 13);
            NSAttributedString *att = [NSAttributedString attributedStringWithAttachment:textAtt];
            [messageAttrStr replaceCharactersInRange:result.range withAttributedString:att];
        }
    }];

}
- (NSMutableAttributedString *)attStringWithString:(NSString *)string imageFrame:(CGRect)imageFrame attributes:(NSDictionary *)dict {
    NSMutableAttributedString *attString = nil;
    if (!dict) {
        attString = [[NSMutableAttributedString alloc] initWithString:string];
    } else {
        attString = [[NSMutableAttributedString alloc] initWithString:string attributes:dict];
    }

    NSString *pattern = @"\\[[0-9]{3}\\]";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    // 2.测试字符串
    NSArray *results = [regex matchesInString:string options:0 range:NSMakeRange(0,string.length)];
    // 3.遍历结果
    [results enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult *result, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *imageName = [[string substringWithRange:result.range] substringWithRange:NSMakeRange(1, 3)];
        NSTextAttachment *textAtt = [[NSTextAttachment alloc] init];
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            textAtt.image = image;
            textAtt.bounds = imageFrame;
            NSAttributedString *att = [NSAttributedString attributedStringWithAttachment:textAtt];
            NSMutableAttributedString *attM = [[NSMutableAttributedString alloc] initWithAttributedString:att];
            NSAttributedString *att2 = [[NSAttributedString alloc] initWithString:@" "];
            [attM appendAttributedString:att2];
            [attString replaceCharactersInRange:result.range withAttributedString:attM];
        }
    }];
    
    return attString;
}
- (NSString *)stringWithAttString:(NSAttributedString *)AttString {
#if 1
    NSMutableAttributedString *att =
    [[NSMutableAttributedString alloc] initWithAttributedString:AttString];
    
    __block NSMutableString *messageString = [NSMutableString string];
    
    NSMutableArray *array = [NSMutableArray array];
    
    // add by jianglincen 减少无谓的for循环
    if (!self.emojiDicArray) {
        for (int i = 1; i <= 60; i++) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"emojiName"] = [NSString stringWithFormat:@"[%03d]", i];
            dict[@"emoji"] =
            [UIImage imageNamed:[NSString stringWithFormat:@"%03d", i]];
            
            //            [dict
            //            setObject:[NSValuevalueWithRange:range]forKey:@"range"];
            [array addObject:dict];
        }
        self.emojiDicArray = [[NSMutableArray alloc] initWithArray:array];
    } else {
        array = [[NSMutableArray alloc] initWithArray:self.emojiDicArray];
    }
    
    [att
     enumerateAttributesInRange:NSMakeRange(0, att.length)
     options:0
     usingBlock:^(NSDictionary<NSString *, id> *_Nonnull attrs,
                  NSRange range, BOOL *_Nonnull stop) {
         
         // add by jianglincen
         if (1) {
             EmojiTextAttachment *attChment =
             attrs[@"NSAttachment"];
             
             // DDLogInfo(@"attChment.emojiName=%@",attChment.emojiName);
             if (attChment) {
                 if ([attChment isKindOfClass:
                      [EmojiTextAttachment class]]) {
                     for (NSDictionary *dic in array) {
                         NSString *emojiName = dic[@"emojiName"];
                         
                         if ([emojiName
                              isEqualToString:attChment.emojiName]) {
                             [messageString
                              appendString:dic[@"emojiName"]];
                             break;
                         }
                     }
                 }
                 
                 else {
                     //为什么这么判断呢,因为复制粘贴的时候转换过一次，返回的是NSTextAttachment类,故而用此低级方法先应急一下
                     for (NSDictionary *dict in array) {
                         UIImage *image = dict[@"emoji"];
                         
                         if ([image isEqual:attChment.image]) {
                             [messageString
                              appendString:dict[@"emojiName"]];
                             break;
                         }
                     }
                 }
                 
             }
             
             else {
                 [messageString
                  appendString:
                  [att attributedSubstringFromRange:range]
                  .string];
             }
         }
        
    }];

    return messageString;
#endif
    
#if 0
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:AttString];
    __block NSMutableString *messageString = [NSMutableString string];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 1; i <= 60; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"emojiName"] = [NSString stringWithFormat:@"[%03d]", i];
        dict[@"emoji"] = [UIImage imageNamed:[NSString stringWithFormat:@"%03d", i]];
        [array addObject:dict];
    }
    [att enumerateAttributesInRange:NSMakeRange(0, att.length) options:0 usingBlock:^(NSDictionary < NSString *, id > *_Nonnull attrs, NSRange range, BOOL *_Nonnull stop) {
        NSTextAttachment *attChment = attrs[@"NSAttachment"];
        if (attChment) {
            for (NSDictionary *dict in array) {
                UIImage *image = dict[@"emoji"];
                if ([UIImagePNGRepresentation(image) isEqual:UIImagePNGRepresentation(attChment.image)]) {
                    [messageString appendString:dict[@"emojiName"]];
                    break;
                }
            }
        } else {
            [messageString appendString:[att attributedSubstringFromRange:range].string];
        }
    }];
    
    return messageString;
#endif
}

/**更新好友信息*/
- (void)updateFriendBaseWithDict:(NSDictionary *)dict
{
    return [[GYHDDataBaseCenter sharedInstance] updateFriendBaseWithDict:dict];
}

/**获取MP4文件夹*/
- (NSString *)mp4folderNameString
{
//    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"HDmp4"];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HDmp4"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return path;
}
/**获取MP3文件夹*/
- (NSString *)mp3folderNameString
{
    
    

//    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"HDmp3"];
      NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HDmp3"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}
/**获取Image文夹*/
- (NSString *)imagefolderNameString
{
//    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"HDimage"];
      NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HDimage"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}
- (void)downloadDataWithUrlString:(NSString *)urlstring RequetResult:(RequetResultWithDict)handler
{
    return [self.netWorkTool downloadDataWithUrlString:urlstring RequetResult:handler];
}
/**更新某个字段值*/
- (BOOL)updateMessageWithMessageID:(NSString *)messageID fieldName:(NSString *)fieldName updateString:(NSString *)updateString {
    return [[GYHDDataBaseCenter sharedInstance] updateMessageWithMessageID:messageID fieldName:fieldName updateString:updateString];
}

- (BOOL)insertInfoWithDict:(NSDictionary *)dict TableName:(NSString *)tableName {
    return [[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:dict TableName:tableName];
}

- (BOOL) updateInfoWithDict:(NSDictionary *)dict conditionDict:(NSDictionary *)conditionDict TableName:(NSString *)tableName {
    return [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:dict conditionDict:conditionDict TableName:tableName];
    
}
#warning 搜索相关
/**依据关键字搜索所有推送消息*/
- (NSArray *)selectPushMssageByKeyStr:(NSString*)keyStr{

    return [[GYHDDataBaseCenter sharedInstance] selectPushMssageByKeyStr:keyStr];
}
/**查询所有推送消息*/
- (NSArray *)selectPushMssage{
    return [[GYHDDataBaseCenter sharedInstance] selectPushMssage];
}

/**查询客户咨询消息*/
- (NSArray *)selectCustomerMessage{
    
    return [[GYHDDataBaseCenter sharedInstance] selectCustomerMessage];
}
/**查询所有客户资料*/
- (NSArray *)selectCustomerDeTail{

    return [[GYHDDataBaseCenter sharedInstance] selectCustomerDeTail];
}
/**查询所有企业操作员*/

- (NSArray *)selectCompanyList{
    
    return [[GYHDDataBaseCenter sharedInstance] selectCompanyList];
}

/**查询所有操作员消息*/
- (NSArray *)selectCompanyMessage{
    
    return  [[GYHDDataBaseCenter sharedInstance] selectCompanyMessage];
}
/**依据客户号查询所有聊天消息*/
- (NSArray *)selectAllChatMessageBYCustId:(NSString*)custId{

    return  [[GYHDDataBaseCenter sharedInstance] selectAllChatMessageBYCustId:custId];
}
/**依据搜索条件搜索所有聊天消息*/
-(NSArray *)selectAllChatMessageByKeyString:(NSString*)keyStr{

    return  [[GYHDDataBaseCenter sharedInstance] selectAllChatMessageByKeyString:keyStr];

}
//获取搜索消息所在行
-(NSArray*)selectChatListMessageByMessageId:(NSString*)mesId PrimaryId:(NSString*)primaryId FriendName:(NSString*)friendName IsHeaderRefresh:(BOOL)flag{
    
    return  [[GYHDDataBaseCenter sharedInstance] selectChatListMessageByMessageId:mesId PrimaryId:primaryId FriendName:friendName IsHeaderRefresh:flag];
}
@end
