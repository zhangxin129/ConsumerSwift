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
#import "GYAddressData.h"
#import "GYXMPP.h"
#import <AudioToolbox/AudioToolbox.h>
#import "EmojiTextAttachment.h"





#pragma mark-- ProtobufMessageType
//*****************************protobuf推送消息*****************************//
/**聊天消息*/
NSInteger const GYHDProtobufMessageChat = 15;
/**互生消息*/
NSInteger const GYHDProtobufMessageHuSheng = 1;
/**电商消息*/
NSInteger const GYHDProtobufMessageDianShang = 2;
/**用户中心*/
NSInteger const GYHDProtobufMessageUserCenter = 3;
/**互信消息*/
NSInteger const GYHDProtobufMessageHuxin = 4;
#pragma mark-- 互生消息
/**互生公开信 1001*/
NSInteger const GYHDProtobufMessage01001 = 1001;
NSInteger const GYHDProtobufMessage01002 = 1002;
/**意外伤害保障生效 01006*/
NSInteger const GYHDProtobufMessage01006 = 1006;
/**意外伤害保障失效 01007*/
NSInteger const GYHDProtobufMessage01007 = 1007;
/**免费医疗计划 01008*/
NSInteger const GYHDProtobufMessage01008 = 1008;
/**企业操作员绑定消费者互生卡 01009*/
NSInteger const GYHDProtobufMessage01009 = 1009;
/**意外伤害保障过期失效 01010*/
NSInteger const GYHDProtobufMessage01010 = 1010;
#pragma mark-- 订单消息

/**订单支付成功 02001*/
NSInteger const GYHDProtobufMessage02001 = 2001;
/**订单退款完成【订单取消】 02002*/
NSInteger const GYHDProtobufMessage02002 = 2002;
/**订单退款完成【售后】 02003*/
NSInteger const GYHDProtobufMessage02003 = 2003;
/**订单确认收货 02004*/
NSInteger const GYHDProtobufMessage02004 = 2004;
/**订单待自提*/
NSInteger const GYHDProtobufMessage02005 = 2005;
/**卖家取消订单*/
NSInteger const GYHDProtobufMessage02006 = 2006;
/**订单企业备货中*/
NSInteger const GYHDProtobufMessage02007 = 2007;
/**买家申请取消订单*/
NSInteger const GYHDProtobufMessage02008 = 2008;

/**店内订单确认*/
NSInteger const GYHDProtobufMessage02021 = 2021;
/**店内订单付款成功*/
NSInteger const GYHDProtobufMessage02022 = 2022;
/**店内订单定金支付成功*/
NSInteger const GYHDProtobufMessage02023 = 2023;
/**接单*/
NSInteger const GYHDProtobufMessage02024 = 2024;
/**拒接*/
NSInteger const GYHDProtobufMessage02025 = 2025;
/**送餐*/
NSInteger const GYHDProtobufMessage02026 = 2026;
/**打预结单通知支付*/
NSInteger const GYHDProtobufMessage02027 = 2027;
/**商家取消预定*/
NSInteger const GYHDProtobufMessage02028 = 2028;
/**商家确认取消*/
NSInteger const GYHDProtobufMessage02029 = 2029;

#pragma mark-- 互信消息
/**强制用户登出指令*/
NSInteger const GYHDProtobufMessage04001 = 4001;
/**好友添加请求*/
NSInteger const GYHDProtobufMessage04101 = 4101;
/**好友确认*/
NSInteger const GYHDProtobufMessage04102 = 4102;
/**好友拒绝*/
NSInteger const GYHDProtobufMessage04103 = 4103;
/**删除好友*/
NSInteger const GYHDProtobufMessage04104 = 4104;
/**被移入黑名单*/
NSInteger const GYHDProtobufMessage04105 = 4105;
/**被移出黑名单*/
NSInteger const GYHDProtobufMessage04106 = 4106;
#pragma mark-- 订阅消息
/**商品降价*/
NSInteger const GYHDProtobufMessage02901 = 2901;
/**商品下架、无货等消息*/
NSInteger const GYHDProtobufMessage02902 = 2902;
/**商铺信息变动*/
NSInteger const GYHDProtobufMessage02903 = 2903;
/**商家发布的活动消息*/
NSInteger const GYHDProtobufMessage02904 = 2904;

//NSString * const GYHDDataBaseCenterMessageFriendID      = @"MSG_FirendID";
#pragma mark-- PushMessageSql
NSString* const GYHDDataBaseCenterPushMessageTableName = @"T_PUSH_MSG";
NSString* const GYHDDataBaseCenterPushMessageID = @"PUSH_MSG_ID";
NSString* const GYHDDataBaseCenterPushMessageCode = @"PUSH_MSG_Code";
NSString* const GYHDDataBaseCenterPushMessagePlantFromID = @"PUSH_MSG_PlantFormID";
NSString* const GYHDDataBaseCenterPushMessageToID = @"PUSH_MSG_ToID";
NSString* const GYHDDataBaseCenterPushMessageFromID = @"PUSH_MSG_FromID";
NSString* const GYHDDataBaseCenterPushMessageContent = @"PUSH_MSG_Content";
NSString* const GYHDDataBaseCenterPushMessageBody = @"PUSH_MSG_Body";
NSString* const GYHDDataBaseCenterPushMessageSendTime = @"PUSH_MSG_SendTime";
NSString* const GYHDDataBaseCenterPushMessageRevieTime = @"PUSH_MSG_RecvTime";
NSString* const GYHDDataBaseCenterPushMessageIsRead = @"PUSH_MSG_Read";
NSString* const GYHDDataBaseCenterPushMessageData = @"PUSH_MSG_DataString";
NSString* const GYHDDataBaseCenterPushMessageUnreadLocation = @"PUSH_MSG_UnreadLocation";
#pragma mark-- ChatMessageSql
NSString* const GYHDDataBaseCenterMessageTableName = @"T_MESSAGE";
NSString* const GYHDDataBaseCenterMessageID = @"MSG_ID";
NSString* const GYHDDataBaseCenterMessageFromID = @"MSG_FromID";
NSString* const GYHDDataBaseCenterMessageToID = @"MSG_ToID";
NSString* const GYHDDataBaseCenterMessageContent = @"MSG_Content";
NSString* const GYHDDataBaseCenterMessageFriendType = @"MSG_FirendType";
NSString* const GYHDDataBaseCenterMessageBody = @"MSG_Body";
NSString* const GYHDDataBaseCenterMessageCode = @"MSG_Type";
NSString* const GYHDDataBaseCenterMessageSendTime = @"MSG_SendTime";
NSString* const GYHDDataBaseCenterMessageRevieTime = @"MSG_RecvTime";
NSString* const GYHDDataBaseCenterMessageIsSelf = @"MSG_Self";
NSString* const GYHDDataBaseCenterMessageIsRead = @"MSG_Read";
NSString* const GYHDDataBaseCenterMessageSentState = @"MSG_State";
NSString* const GYHDDataBaseCenterMessageCard = @"MSG_Card";
NSString* const GYHDDataBaseCenterMessageData = @"MSG_DataString";
#pragma mark-- FriendSql

NSString* const GYHDDataBaseCenterFriendTableName = @"T_FRIENDS";
NSString* const GYHDDataBaseCenterFriendID = @"ID";
NSString* const GYHDDataBaseCenterFriendFriendID = @"Friend_ID";
NSString* const GYHDDataBaseCenterFriendCustID = @"Friend_CustID";
NSString* const GYHDDataBaseCenterFriendResourceID = @"Friend_ResourceID";
NSString* const GYHDDataBaseCenterFriendApplication = @"Friend_Application";
NSString* const GYHDDataBaseCenterFriendName = @"Friend_Name";
NSString* const GYHDDataBaseCenterFriendIcon = @"Friend_Icon";
NSString* const GYHDDataBaseCenterFriendUsetType = @"Friend_UserType";
NSString* const GYHDDataBaseCenterFriendInfoTeamID = @"Friend_TeamID";
NSString* const GYHDDataBaseCenterFriendTeamFriendSet = @"Friend_TeamIDFriendSet";
NSString* const GYHDDataBaseCenterFriendSign = @"Friend_Sign";
NSString* const GYHDDataBaseCenterFriendMessageType = @"Friend_MessageType";
NSString* const GYHDDataBaseCenterFriendMessageTop = @"Friend_MessageTop";
NSString* const GYHDDataBaseCenterFriendBasic = @"Friend_Basic";
NSString* const GYHDDataBaseCenterFriendDetailed = @"Friend_detailed";
#pragma mark-- Friendtream
NSString* const GYHDDataBaseCenterFriendTeamTableName = @"T_TREAMS";
NSString* const GYHDDataBaseCenterFriendTeamID = @"ID";
NSString* const GYHDDataBaseCenterFriendTeamTeamID = @"Tream_ID";
NSString* const GYHDDataBaseCenterFriendTeamName = @"Tream_Name";
NSString* const GYHDDataBaseCenterFriendTeamDetail = @"Tream_detal";

#pragma mark-- userSeting
NSString* const GYHDDataBaseCenterUserSetingTableName = @"T_USERSETING";
NSString* const GYHDDataBaseCenterUserSetingID = @"ID";
NSString* const GYHDDataBaseCenterUserSetingName = @"User_Name";
NSString* const GYHDDataBaseCenterUserSetingSelectCount = @"User_SelectCount";
NSString* const GYHDDataBaseCenterUserSetingMessageTop = @"User_MessageTop";
NSString* const GYHDDataBaseCenterUserSetingMessageHiden = @"User_MessageHiden";


NSString* const GYHDDataBaseCenterUserSetingMessageTopDefualt = @"-1";

#pragma mark-- friendBasic
NSString* const GYHDDataBaseCenterFriendBasicAccountID = @"accountId";
NSString* const GYHDDataBaseCenterFriendBasicCustID = @"custId";
NSString* const GYHDDataBaseCenterFriendBasicIcon = @"headPic";
NSString* const GYHDDataBaseCenterFriendBasicNikeName = @"nickname";
NSString* const GYHDDataBaseCenterFriendBasicSignature = @"sign";
NSString* const GYHDDataBaseCenterFriendBasicTeamId = @"teamId";
NSString* const GYHDDataBaseCenterFriendBasicTeamName = @"teamName";
NSString* const GYHDDataBaseCenterFriendBasicTeamRemark = @"teamRemark";

NSString* const GYHDMessageCenterDataBaseChageNotification = @"com.hsec.database.change";

/**关注企业*/
NSString* const GYHDDataBaseCenterFocusOnBusiness = @"Focus";
/**好友*/
NSString* const GYHDDataBaseCenterFriends = @"Friend";
/**企业临时聊天*/
NSString* const GYHDDataBaseCenterTemporaryBusiness = @"temporary";
/**我自己*/
NSString* const GYHDDataBaseCenterMy = @"self";
@interface GYHDMessageCenter ()
@property (nonatomic, strong) GYHDNetWorkTool* netWorkTool;
/**互生消息未读统计*/
@property (nonatomic, assign) NSInteger huShengUnreadCount;
/**平台2*/
@property (nonatomic, assign) NSInteger DianShangUnreadCount;
/**平台3*/
@property (nonatomic, assign) NSInteger UserCenterUnreadCount;
/**平台4*/
@property (nonatomic, assign) NSInteger HuxinUnreadCount;
@property (nonatomic, strong) NSTimer* IMtimer;

@property (nonatomic, strong) NSArray* emojiArray;
@end
@implementation GYHDMessageCenter

- (GYHDNetWorkTool*)netWorkTool
{
    if (!_netWorkTool) {
        _netWorkTool = [GYHDNetWorkTool sharedInstance];
    }
    return _netWorkTool;
}

static id instance;

+ (id)allocWithZone:(struct _NSZone*)zone
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
    NSArray* sendArray = [[GYHDDataBaseCenter sharedInstance] selectSendState:GYHDDataBaseCenterMessageSentStateSending];

    for (NSDictionary* dict in sendArray) {
        [self sendMessageWithDictionary:dict resend:YES];
    }
}

- (id)copyWithZone:(NSZone*)zone
{
    return instance;
}
// 互生消息
// 订单消息
// 互信消息
// 订阅消息
- (void)receiveProtobuf:(NSData*)protobuf
{

    NSData* data = [NSData dataWithData:protobuf];
    //    NSLog(@"%@", protobuf);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        GYHDProtoBufHeader *header = [[GYHDProtoBufHeader alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 32)]];
//        NSLog(@"cmd = %2x", header.cmdid);
        NSData *bodyData = [data subdataWithRange:NSMakeRange(32, header.pkLength - 32)];
        switch (header.cmdid) {
            case MsgCmdIDCidMessageLoginRes: {
                LoginRes *res = [LoginRes parseFromData:bodyData];
//                NSLog(@"LoginRes = %d !=%@ 2=%llu", (int)res.ret, res.errorInfo, res.userId);
                break;
            }
            case MsgCmdIDCidMessagePushNotify: {
                PushMsgNotify *push = [PushMsgNotify parseFromData:bodyData];
                NSMutableDictionary *pushMessageDict = [self saveWithPushMsgNotify:push];
                NSDictionary *bodyDict = [GYUtils stringToDictionary:pushMessageDict[GYHDDataBaseCenterPushMessageBody]];
                pushMessageDict[GYHDDataBaseCenterPushMessageData] = [protobuf base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                if ([[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:pushMessageDict TableName:GYHDDataBaseCenterPushMessageTableName]) {
                    if (push.msgtype == GYHDProtobufMessage04102) {          // 好友确认
                        NSDictionary *chatDict = [self saveChatMessageWithPushMsgNotify:push];
//                        [[GYHDDataBaseCenter sharedInstance] saveMessageWithDict:chatDict];
                        [[GYHDMessageCenter sharedInstance] insertInfoWithDict:chatDict TableName:GYHDDataBaseCenterMessageTableName];
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        dict[GYHDDataBaseCenterPushMessageIsRead] = @0;
                        NSMutableDictionary *condDict = [NSMutableDictionary dictionary];
                        condDict[GYHDDataBaseCenterPushMessageCode] = @(push.msgtype);
                        [self updateInfoWithDict:dict conditionDict:condDict TableName:GYHDDataBaseCenterPushMessageTableName];
                        [self getFriendListRequetResult:^(NSArray *resultArry) {
                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                            dict[@"friendChange"] = @(GYHDProtobufMessage04102);
                            dict[@"toID"] = [NSString stringWithFormat:@"0%lld",push.fromuid];
                            [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:dict];
                        }];
                    }
                    if (push.msgtype == GYHDProtobufMessage04104) {
//                        [self getFriendListRequetResult:nil isNetwork:YES];
                        [self getFriendListRequetResult:^(NSArray *resultArry) {
                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                            dict[@"friendChange"] = @(GYHDProtobufMessage04104);
                            dict[@"toID"] = bodyDict[@"fromId"];
                            [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:dict];
                        }];
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        dict[GYHDDataBaseCenterPushMessageIsRead] = @(0);
                        NSMutableDictionary *condDict = [NSMutableDictionary dictionary];
                        condDict[GYHDDataBaseCenterPushMessageCode] = @(push.msgtype);
                        [self updateInfoWithDict:dict conditionDict:condDict TableName:GYHDDataBaseCenterPushMessageTableName];
                        [self deleteMessageWithMessageCard:[NSString stringWithFormat:@"%llu", push.fromuid]];
                    }
                    [self postDataBaseChangeNotificationWithDict:pushMessageDict];
                    PushMsgRecvedNotify *pushfy = [[[[[PushMsgRecvedNotify builder] setUserId:push.toid] setPlantformId:push.serverid] setMsgId:push.msgid] build];
                    GYHDProtoBufHeader *header = [[GYHDProtoBufHeader alloc] init];
                    header.cmdid = 0x3023;
                    NSData *sendData = [header DataWithProtobufData:[pushfy data]];
                    if ([self.delegate respondsToSelector:@selector(sendProtobufToServerWithData:)]) {
                        [self.delegate sendProtobufToServerWithData:sendData];
                        //                            [self deleteMessageWithMessageCard:[NSString stringWithFormat:@"%u",push.msgtype]];
                    }
                }
                
                break;
            }
            case 0x3025: {
                RecentPushMsgsRsp *msgRsp = [RecentPushMsgsRsp parseFromData:bodyData];
//                NSLog(@"RecentPushMsgsRs = %@ , %@\n\n", msgRsp.msgList, msgRsp.errorInfo);
                for (RecentPushMessage *message in msgRsp.msgList) {


                    NSDictionary *contentDict = [GYUtils stringToDictionary:message.content];
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
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *recvDateString = [formatter stringFromDate:nowdata];
                    NSDictionary *bodyDict = contentDict[@"content"];
                    
                    pushMessageDict[GYHDDataBaseCenterPushMessageID] = [NSString stringWithFormat:@"%lld", message.msgId];
                    pushMessageDict[GYHDDataBaseCenterPushMessagePlantFromID] = [NSString stringWithFormat:@"%llu", message.plantformId];
                    pushMessageDict[GYHDDataBaseCenterPushMessageFromID] = @"-1";
                    pushMessageDict[GYHDDataBaseCenterPushMessageToID] = @"-1";
                    pushMessageDict[GYHDDataBaseCenterPushMessageContent] = bodyDict[@"msg_content"];
                    pushMessageDict[GYHDDataBaseCenterPushMessageBody] = [GYUtils dictionaryToString:bodyDict];
                    pushMessageDict[GYHDDataBaseCenterPushMessageSendTime] = sendDateString;
                    pushMessageDict[GYHDDataBaseCenterPushMessageRevieTime] = recvDateString;
                    pushMessageDict[GYHDDataBaseCenterPushMessageIsRead] = @(message.unreads);
                    pushMessageDict[GYHDDataBaseCenterPushMessageData] = [protobuf base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    NSMutableDictionary *deleteDict = [NSMutableDictionary dictionary];
                    deleteDict[GYHDDataBaseCenterPushMessageID] = pushMessageDict[GYHDDataBaseCenterPushMessageID];
                    deleteDict[GYHDDataBaseCenterPushMessagePlantFromID] = pushMessageDict[GYHDDataBaseCenterPushMessagePlantFromID];
                    
                    if (message.unreads) {
                        
                        NSInteger unreadCount = 0;
                        switch (message.plantformId) {
                            case GYHDProtobufMessageHuSheng:
                            {
                    
                                if (unreadCount > 10) {
                                    self.huShengUnreadCount = message.unreads - 10;
                                    unreadCount = 10;
                                }else {
                                    self.huShengUnreadCount = 0;
                                    unreadCount = message.unreads;
                                }
                                break;
                            }
                            case GYHDProtobufMessageDianShang:
                            {

                                if (unreadCount > 10) {
                                    self.DianShangUnreadCount = message.unreads - 10;
                                    unreadCount = 10;
                                }else {
                                    self.DianShangUnreadCount = 0;
                                    unreadCount = message.unreads;
                                }
                                break;
                            }
                            case GYHDProtobufMessageUserCenter:
                            {
                                if (unreadCount > 10) {
                                    self.UserCenterUnreadCount = message.unreads - 10;
                                    unreadCount = 10;
                                }else {
                                    self.UserCenterUnreadCount = 0;
                                    unreadCount = message.unreads;
                                }
                                break;
                            }
                            case GYHDProtobufMessageHuxin :
                            {
                                if (unreadCount > 10) {
                                    self.HuxinUnreadCount = message.unreads - 10;
                                    unreadCount = 10;
                                }else {
                                    self.HuxinUnreadCount = 0;
                                    unreadCount = message.unreads;
                                }
                                break;
                            }
                            default:
                                break;
                        }
                        
    
                        GYHDProtoBufHeader *header = [[GYHDProtoBufHeader alloc] init];;
                        header.cmdid = 0x3026;
                        UInt64 userid = [GlobalData shareInstance].loginModel.custId.longLongValue;
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
//                NSLog(@"GetOfflinePushMsgRsp = %@ , %@", rsp.msgList, rsp.errorInfo);
                for (PushMsgNotify *push in rsp.msgList) {
                    NSMutableDictionary *pushMessageDict = [self saveWithPushMsgNotify:push];
                    NSDictionary *bodyDict = [GYUtils stringToDictionary:pushMessageDict[GYHDDataBaseCenterPushMessageBody]];
                    pushMessageDict[GYHDDataBaseCenterPushMessageData] = [protobuf base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    [[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:pushMessageDict TableName:GYHDDataBaseCenterPushMessageTableName];
                    if (push.msgtype == GYHDProtobufMessage04102) {          // 好友确认
                        NSDictionary *chatDict = [self saveChatMessageWithPushMsgNotify:push];
//                        [[GYHDDataBaseCenter sharedInstance] saveMessageWithDict:chatDict];
                          [[GYHDMessageCenter sharedInstance] insertInfoWithDict:chatDict TableName:GYHDDataBaseCenterMessageTableName];
                        [self getFriendListRequetResult:^(NSArray *resultArry) {
                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                            dict[@"friendChange"] = @(GYHDProtobufMessage04102);
                            dict[@"toID"] = [NSString stringWithFormat:@"0%lld",push.fromuid];
                            [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:dict];
                        }];
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        dict[GYHDDataBaseCenterPushMessageIsRead] = @0;
                        NSMutableDictionary *condDict = [NSMutableDictionary dictionary];
                        condDict[GYHDDataBaseCenterPushMessageCode] = @(push.msgtype);
                        [self updateInfoWithDict:dict conditionDict:condDict TableName:GYHDDataBaseCenterPushMessageTableName];
                    }
                    if (push.msgtype == GYHDProtobufMessage04104) {
                        [self getFriendListRequetResult:^(NSArray *resultArry) {
                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                            dict[@"friendChange"] = @(GYHDProtobufMessage04104);
                            dict[@"toID"] =  bodyDict[@"fromId"];
                            [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:dict];
                        }];
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        dict[GYHDDataBaseCenterPushMessageIsRead] = @0;
                        NSMutableDictionary *condDict = [NSMutableDictionary dictionary];
                        condDict[GYHDDataBaseCenterPushMessageCode] = @(push.msgtype);
                        [self updateInfoWithDict:dict conditionDict:condDict TableName:GYHDDataBaseCenterPushMessageTableName];
                        [self deleteMessageWithMessageCard:[NSString stringWithFormat:@"%llu", push.fromuid]];
                    }
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

- (NSMutableDictionary*)saveChatMessageWithPushMsgNotify:(PushMsgNotify*)push
{

    NSDictionary* contentDict = [NSJSONSerialization JSONObjectWithData:push.content options:NSJSONReadingMutableContainers error:nil];
    NSString* sendTime = contentDict[@"time"];
    NSString* sendDateString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",
                                         [sendTime substringWithRange:NSMakeRange(0, 4)],
                                         [sendTime substringWithRange:NSMakeRange(4, 2)],
                                         [sendTime substringWithRange:NSMakeRange(6, 2)],
                                         [sendTime substringWithRange:NSMakeRange(8, 2)],
                                         [sendTime substringWithRange:NSMakeRange(10, 2)],
                                         [sendTime substringWithRange:NSMakeRange(12, 2)]];
    NSDate* nowdata = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* recvDateString = [formatter stringFromDate:nowdata];
    NSMutableDictionary* insertMessageDict = [NSMutableDictionary dictionary];

    insertMessageDict[GYHDDataBaseCenterMessageFromID] = [NSString stringWithFormat:@"m_%@@im.gy.com", contentDict[@"content"][@"fromId"]];
    insertMessageDict[GYHDDataBaseCenterMessageToID] = [NSString stringWithFormat:@"m_%@@im.gy.com", contentDict[@"content"][@"toId"]];
    insertMessageDict[GYHDDataBaseCenterMessageContent] = [NSString stringWithFormat:@"您和%@已经成为好友，现在可以聊天了噢", contentDict[@"content"][@"msg_note"]];
    insertMessageDict[GYHDDataBaseCenterMessageFriendType] = @"c";
    ;
    insertMessageDict[GYHDDataBaseCenterMessageBody] = @"-1";
    insertMessageDict[GYHDDataBaseCenterMessageCode] = @(GYHDDataBaseCenterMessageTypeChat);
    ;
    insertMessageDict[GYHDDataBaseCenterMessageSendTime] = sendDateString;
    insertMessageDict[GYHDDataBaseCenterMessageRevieTime] = recvDateString;
    insertMessageDict[GYHDDataBaseCenterMessageIsSelf] = @(0);
    insertMessageDict[GYHDDataBaseCenterMessageIsRead] = @(1);
    insertMessageDict[GYHDDataBaseCenterMessageSentState] = @(GYHDDataBaseCenterMessageSentStateSuccess);
    ;

    NSString* fromJID = insertMessageDict[GYHDDataBaseCenterMessageFromID];
    NSString* pattern = @"\\d+";
    NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    // 2.测试字符串
    NSArray* results = [regex matchesInString:fromJID options:0 range:NSMakeRange(0, fromJID.length)];
    // 3.遍历结果
    NSTextCheckingResult* result = [results firstObject];
    insertMessageDict[GYHDDataBaseCenterMessageCard] = [fromJID substringWithRange:result.range];

    insertMessageDict[GYHDDataBaseCenterMessageData] = @"-1";

    NSMutableDictionary* friendDict = [NSMutableDictionary dictionary];
    friendDict[GYHDDataBaseCenterFriendFriendID] = [insertMessageDict[GYHDDataBaseCenterMessageFromID] substringWithRange:NSMakeRange(2, 13)];
    friendDict[GYHDDataBaseCenterFriendCustID] = insertMessageDict[GYHDDataBaseCenterMessageCard];
    friendDict[GYHDDataBaseCenterFriendName] = contentDict[@"content"][@"msg_note"];
    friendDict[GYHDDataBaseCenterFriendIcon] = contentDict[@"content"][@"msg_icon"];
    friendDict[GYHDDataBaseCenterFriendUsetType] = [insertMessageDict[GYHDDataBaseCenterMessageFromID] substringWithRange:NSMakeRange(2, 1)];
    friendDict[GYHDDataBaseCenterFriendMessageType] = GYHDDataBaseCenterFriends;
    friendDict[GYHDDataBaseCenterFriendMessageTop] = @"-1";
    friendDict[GYHDDataBaseCenterFriendInfoTeamID] = @"unteamed";
    friendDict[GYHDDataBaseCenterFriendBasic] = @"-1";
    friendDict[GYHDDataBaseCenterFriendDetailed] = @"-1";
    [[GYHDMessageCenter sharedInstance] insertInfoWithDict:friendDict TableName:GYHDDataBaseCenterFriendTableName];

    return insertMessageDict;
}

- (NSMutableDictionary*)saveWithPushMsgNotify:(PushMsgNotify*)push
{

    NSDictionary* contentDict = [NSJSONSerialization JSONObjectWithData:push.content options:NSJSONReadingMutableContainers error:nil];
    NSMutableDictionary* pushMessageDict = [NSMutableDictionary dictionary];
    NSString* sendTime = contentDict[@"time"];
    NSString* sendDateString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",
                                         [sendTime substringWithRange:NSMakeRange(0, 4)],
                                         [sendTime substringWithRange:NSMakeRange(4, 2)],
                                         [sendTime substringWithRange:NSMakeRange(6, 2)],
                                         [sendTime substringWithRange:NSMakeRange(8, 2)],
                                         [sendTime substringWithRange:NSMakeRange(10, 2)],
                                         [sendTime substringWithRange:NSMakeRange(12, 2)]];
    NSDate* nowdata = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* recvDateString = [formatter stringFromDate:nowdata];
    NSDictionary* bodyDict = contentDict[@"content"];
    pushMessageDict[GYHDDataBaseCenterPushMessageCode] = @(push.msgtype);
    pushMessageDict[GYHDDataBaseCenterPushMessageID] = [NSString stringWithFormat:@"%lld", push.msgid];
    pushMessageDict[GYHDDataBaseCenterPushMessagePlantFromID] = [NSString stringWithFormat:@"%u", (unsigned int)push.serverid];
    pushMessageDict[GYHDDataBaseCenterPushMessageFromID] = [NSString stringWithFormat:@"%lld", push.fromuid];
    pushMessageDict[GYHDDataBaseCenterPushMessageToID] = [NSString stringWithFormat:@"%lld", push.toid];
    pushMessageDict[GYHDDataBaseCenterPushMessageContent] = bodyDict[@"msg_content"];
    pushMessageDict[GYHDDataBaseCenterPushMessageBody] = [GYUtils dictionaryToString:bodyDict];
    pushMessageDict[GYHDDataBaseCenterPushMessageSendTime] = sendDateString;
    pushMessageDict[GYHDDataBaseCenterPushMessageRevieTime] = recvDateString;
    pushMessageDict[GYHDDataBaseCenterPushMessageIsRead] = @(1);
    return pushMessageDict;
}

- (void)ReceiveMessage:(XMPPMessage*)message
{
    //1. 解析数据
    XMPPMessage* recvMessage = message;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSString *body = [[recvMessage elementForName:@"body"] stringValue];
        NSString *fromJID = [[recvMessage attributeForName:@"from"] stringValue];
//        NSString *jidString = [[[XMPPJID jidWithString:fromJID] bareJID] bare];
        NSString *messageId = [[recvMessage attributeForName:@"id"] stringValue];
        NSString *toID = [[recvMessage attributeForName:@"to"] stringValue];
        NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
        NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithDictionary:[GYUtils stringToDictionary:body]];
        [self checkDict:bodyDict];
        messageDict[GYHDDataBaseCenterMessageID] = messageId;
        messageDict[GYHDDataBaseCenterMessageFromID] = fromJID;
        messageDict[GYHDDataBaseCenterMessageToID] = toID;
        messageDict[GYHDDataBaseCenterMessageBody] = [GYUtils dictionaryToString:bodyDict];

//        NSString *pattern1 = @"\\d{11}";
//        NSRegularExpression *regex1 = [[NSRegularExpression alloc] initWithPattern:pattern1 options:0 error:nil];
//        // 2.测试字符串
//        NSArray *results1 = [regex1 matchesInString:fromJID options:0 range:NSMakeRange(0,fromJID.length)];
//        // 3.遍历结果
//        NSTextCheckingResult *result1 =  [results1 firstObject];
//        messageDict[GYHDDataBaseCenterMessageFriendID] = [fromJID substringWithRange:result1.range];;

        if ([fromJID rangeOfString:@"_c_"].location != NSNotFound) {
            messageDict[GYHDDataBaseCenterMessageFriendType] = @"c";
        } else {
            messageDict[GYHDDataBaseCenterMessageFriendType] = @"e";
        }

//        NSInteger subMsgCode = [bodyDict[@"sub_msg_code"] integerValue];

        NSString *pattern = @"\\d+";
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
        // 2.测试字符串
        NSArray *results = [regex matchesInString:fromJID options:0 range:NSMakeRange(0, fromJID.length)];
        // 3.遍历结果
        NSTextCheckingResult *result = [results firstObject];
        messageDict[GYHDDataBaseCenterMessageCard] = [fromJID substringWithRange:result.range];

        //消费者 及时聊天
        switch ([bodyDict[@"msg_code"] integerValue]) {
        case GYHDDataBaseCenterMessageChatText:         //文本消息
        case GYHDDataBaseCenterMessageChatPicture:      //图片消息
        case GYHDDataBaseCenterMessageChatMap:

            {
                messageDict[GYHDDataBaseCenterMessageCode] = @(GYHDDataBaseCenterMessageTypeChat);
                if ([bodyDict[@"msg_code"] integerValue] == GYHDDataBaseCenterMessageChatText) {
                    messageDict[GYHDDataBaseCenterMessageContent] = bodyDict[@"msg_content"];
                }else if ([bodyDict[@"msg_code"] integerValue] == GYHDDataBaseCenterMessageChatPicture) {
                    messageDict[GYHDDataBaseCenterMessageContent] = [GYUtils localizedStringWithKey:@"GYHD_Chat_image_message"];
                }else if ([bodyDict[@"msg_code"] integerValue] == GYHDDataBaseCenterMessageChatMap) {
                    messageDict[GYHDDataBaseCenterMessageContent] = [GYUtils localizedStringWithKey:@"GYHD_Chat_GPS_message"];
                }
                break;
            }

        case GYHDDataBaseCenterMessageChatAudio:        //音频消息
            {
                messageDict[GYHDDataBaseCenterMessageCode] = @(GYHDDataBaseCenterMessageTypeChat);



                NSString *timeNumber = [NSString stringWithFormat:@"%u_%d", arc4random_uniform(1000), (int)[[NSDate date] timeIntervalSince1970]];
                NSString *mp3Name = [NSString stringWithFormat:@"audio%@.mp3", timeNumber];
                NSString *filePath = [NSString pathWithComponents:@[[[GYHDMessageCenter sharedInstance] mp3folderNameString], mp3Name]];
                [self.netWorkTool downloadDataWithUrlString:bodyDict[@"msg_content"] filePath:filePath];

                NSMutableDictionary *saveDict = [NSMutableDictionary dictionary];
                saveDict[@"mp3"] = mp3Name;
                saveDict[@"mp3Len"] = bodyDict[@"msg_fileSize"];
                saveDict[@"read"] = @"0";
                messageDict[GYHDDataBaseCenterMessageData] = [GYUtils dictionaryToString:saveDict];
                messageDict[GYHDDataBaseCenterMessageContent] = [GYUtils localizedStringWithKey:@"GYHD_Chat_audio_message"];

                break;
            }

        case GYHDDataBaseCenterMessageChatVideo:        //视频消息
            {
                messageDict[GYHDDataBaseCenterMessageCode] = @(GYHDDataBaseCenterMessageTypeChat);


  
                NSString *timeNumber = [NSString stringWithFormat:@"%u_%d", arc4random_uniform(1000), (int)[[NSDate date] timeIntervalSince1970]];
                NSString *mp4Name = [NSString stringWithFormat:@"video%@.mp4", timeNumber];
                NSString *filePath = [NSString pathWithComponents:@[[[GYHDMessageCenter sharedInstance] mp4folderNameString], mp4Name]];
                [self.netWorkTool downloadDataWithUrlString:bodyDict[@"msg_content"] filePath:filePath];

                NSMutableDictionary *saveDict = [NSMutableDictionary dictionary];
                saveDict[@"mp4Name"] = mp4Name;
                saveDict[@"thumbnailsName"] = bodyDict[@"msg_imageNail"];
                saveDict[@"read"] = @"0";
                messageDict[GYHDDataBaseCenterMessageData] = [GYUtils dictionaryToString:saveDict];
                messageDict[GYHDDataBaseCenterMessageContent] = [GYUtils localizedStringWithKey:@"GYHD_Chat_video_message"];
                break;
            }
        default:
            break;
        }
        NSDate *sendData = [[NSDate alloc] initWithTimeIntervalSince1970:messageId.longLongValue / 1000];;

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *sendDateString = [formatter stringFromDate:sendData];
        NSString *recvDateString = [formatter stringFromDate:[NSDate date]];
        messageDict[GYHDDataBaseCenterMessageSendTime] = sendDateString;
        messageDict[GYHDDataBaseCenterMessageRevieTime] = recvDateString;
        messageDict[GYHDDataBaseCenterMessageIsSelf] = @(0);
        messageDict[GYHDDataBaseCenterMessageIsRead] = @(1);
        messageDict[GYHDDataBaseCenterMessageSentState] = @(GYHDDataBaseCenterMessageSentStateSuccess);
        
        if ([fromJID rangeOfString:@"c_"].location != NSNotFound) {
            NSDictionary *userdict = [self selectFriendBaseWithCardString:messageDict[GYHDDataBaseCenterMessageCard] ];
            if (userdict.allKeys.count == 0 ||
                [userdict[@"Friend_TeamIDFriendSet"] isEqualToString:@"blacklisted"] ||
                [userdict[@"Friend_TeamID"] isEqualToString:@"blacklisted"] ) {
                return ;
            }
        }
        
//        if ([[GYHDDataBaseCenter sharedInstance] saveMessageWithDict:messageDict]) {
        if (  [[GYHDMessageCenter sharedInstance] insertInfoWithDict:messageDict TableName:GYHDDataBaseCenterMessageTableName]) {
            [self clearMessageHidenWithCustID:messageDict[GYHDDataBaseCenterMessageCard]];
        
            [self postDataBaseChangeNotificationWithDict:messageDict];
            NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
            NSArray *accountArray =  [accountDefaults objectForKey:KUserDefaultAccount];
            if (!accountArray) {
                AudioServicesPlaySystemSound(1002);
            }else {
                NSDate *date = [NSDate date];
                NSDateFormatter *matter = [[NSDateFormatter alloc] init];
                [matter setDateFormat:@"HH"];
                NSString *timeString =  [matter stringFromDate:date];
                NSLog(@"%d",timeString.intValue);
                if ((![(NSNumber *)accountArray[0][0] boolValue] && ![(NSNumber *)accountArray[0][1] boolValue] )||([(NSNumber *)accountArray[0][1] boolValue] &&  timeString.integerValue < 22 && timeString.integerValue  > 8)) {
                    if ([(NSNumber *)accountArray[0][2] boolValue]) {
                        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"recvMessage.caf" withExtension:nil];
                        if (fileURL) {
                            SystemSoundID theSoundID;
                            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &theSoundID);
                            if (error == kAudioServicesNoError) {
                                AudioServicesPlaySystemSound(theSoundID);
                            }
                        }
             
                    }
                    if ([(NSNumber *)accountArray[0][3] boolValue]) {
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    }
                }
            }
        }
        if ([fromJID rangeOfString:@"_e_"].location != NSNotFound) {
            NSDictionary *dict = [[GYHDMessageCenter sharedInstance] selectFriendBaseWithCardString:messageDict[GYHDDataBaseCenterMessageCard]];
            
            
            NSMutableDictionary *friendDict = [NSMutableDictionary dictionary];
            friendDict[GYHDDataBaseCenterFriendFriendID] = [fromJID substringWithRange:NSMakeRange(2, 21)];
            friendDict[GYHDDataBaseCenterFriendCustID] = messageDict[GYHDDataBaseCenterMessageCard];
            friendDict[GYHDDataBaseCenterFriendResourceID] = [fromJID substringWithRange:NSMakeRange(4, 11)];
            friendDict[GYHDDataBaseCenterFriendName] = bodyDict[@"msg_note"];
            friendDict[GYHDDataBaseCenterFriendIcon] = bodyDict[@"msg_icon"];
            friendDict[GYHDDataBaseCenterFriendUsetType] = [fromJID substringWithRange:NSMakeRange(2, 1)];
            friendDict[GYHDDataBaseCenterFriendMessageType] = GYHDDataBaseCenterTemporaryBusiness;
            friendDict[GYHDDataBaseCenterFriendMessageTop] = @"-1";
            friendDict[GYHDDataBaseCenterFriendInfoTeamID] = @"-1";
            friendDict[GYHDDataBaseCenterFriendBasic] = @"-1";
            friendDict[GYHDDataBaseCenterFriendDetailed] = @"-1";
            if ([dict allKeys].count <= 0) {
                [[GYHDMessageCenter sharedInstance] insertInfoWithDict:friendDict TableName:GYHDDataBaseCenterFriendTableName];
            }
        }
        NSMutableDictionary *conditionDict = [NSMutableDictionary dictionary];
        conditionDict[GYHDDataBaseCenterFriendCustID] = messageDict[GYHDDataBaseCenterMessageCard];
        
        NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
        if ([fromJID rangeOfString:@"_e_"].location != NSNotFound) {
            updateDict[GYHDDataBaseCenterFriendName] = bodyDict[@"msg_note"];
        }
        updateDict[GYHDDataBaseCenterFriendIcon] = bodyDict[@"msg_icon"];
        if (updateDict.allKeys.count == 2) {
            [[GYHDMessageCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterFriendTableName];
        }
        
        if (![[UIApplication sharedApplication] applicationState] == UIApplicationStateActive){
            
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            
            localNotification.alertAction = @"Ok";
            localNotification.fireDate = [NSDate new];
            localNotification.timeZone=[NSTimeZone defaultTimeZone];
            
            localNotification.alertBody= messageDict[GYHDDataBaseCenterMessageContent] ;
            
            localNotification.soundName = UILocalNotificationDefaultSoundName;//通知声音
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }

    });
}

/***/
/**
 * 发送消息到服务器
 */
- (void)sendMessageWithDictionary:(NSDictionary*)dict resend:(BOOL)resend
{
    //1.保存到数据库
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!resend) {
//            [[GYHDDataBaseCenter sharedInstance] saveMessageWithDict:dict];
            [[GYHDMessageCenter sharedInstance] insertInfoWithDict:dict TableName:GYHDDataBaseCenterMessageTableName];
        }
        NSDictionary *bodyDict = [GYUtils stringToDictionary:dict[GYHDDataBaseCenterMessageBody]];
        NSDictionary *saveDict = [GYUtils stringToDictionary:dict[GYHDDataBaseCenterMessageData]];
        switch ([bodyDict[@"msg_code"] integerValue]) {
        case GYHDDataBaseCenterMessageChatText:
        case GYHDDataBaseCenterMessageChatGoods:
        case GYHDDataBaseCenterMessageChatOrder:
        case GYHDDataBaseCenterMessageChatMap:
            {
                if ([self.delegate respondsToSelector:@selector(sendToServerWithDict:)]) {
                    [self.delegate sendToServerWithDict:dict];
                }
                break;
            }
        case GYHDDataBaseCenterMessageChatPicture:    //图片消息
            {

                NSString *iamgePath = [NSString pathWithComponents:@[[self imagefolderNameString], saveDict[@"originalName"]]];
                NSData *imageData = [NSData dataWithContentsOfFile:iamgePath];
                [self.netWorkTool postImageWithData:imageData RequetResult:^(NSDictionary *resultDict) {

                    if (resultDict || [resultDict allKeys].count > 0) {
                        NSMutableDictionary *sendDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                        NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithDictionary:[GYUtils stringToDictionary:dict[GYHDDataBaseCenterMessageBody]]];
                        NSString *bigImageUrlStr = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"bigImgUrl"]];
                        NSString *smallImageUrlStr = nil;
                        if ([[resultDict allKeys] containsObject:@"smallImgUrl"]) {
                            smallImageUrlStr = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"smallImgUrl"]];
                        } else {
                            smallImageUrlStr = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"bigImgUrl"]];
                        }
                        bodyDict[@"msg_imageNailsUrl"] = smallImageUrlStr;;
                        bodyDict[@"msg_content"] = bigImageUrlStr;;
                        bodyDict[@"msg_imageNails_width"] = @"150";
                        bodyDict[@"msg_imageNails_height"] = @"150";
                        sendDict[GYHDDataBaseCenterMessageBody] = [GYUtils dictionaryToString:bodyDict];
                        
                        NSDictionary *params=@{
                                             @"fileRefPath":resultDict[@"bigImgUrl"],
                                             @"receiver":dict[@"MSG_Card"]?dict[@"MSG_Card"]:@"",
                                             @"sender":globalData.loginModel.custId
                                               
                                               };
                        
                        //add by jianglincen
                        //先文件绑定用户，绑定之后再发送文件信息 10月份跟新协议一起上
//                        [[GYHDNetWorkTool sharedInstance]bindFileToUserWithDict:params RequestResult:^(NSDictionary *resultDict) {
//                           
//                        if([resultDict[@"state"]intValue]==200) {
//                                //200成功
//                                
//                                if ([self.delegate respondsToSelector:@selector(sendToServerWithDict:)]) {
//                                    [self.delegate sendToServerWithDict:sendDict];
//                                }
//                            }
//                            
//                            else{
//                             [[GYHDMessageCenter sharedInstance] updateMessageStateWithMessageID:dict[GYHDDataBaseCenterMessageID] State:GYHDDataBaseCenterMessageSentStateFailure];
//                            }
//                        }];
                        
                        if ([self.delegate respondsToSelector:@selector(sendToServerWithDict:)]) {
                            [self.delegate sendToServerWithDict:sendDict];
                        }
                    }
                    
                    else {
                        [[GYHDMessageCenter sharedInstance] updateMessageStateWithMessageID:dict[GYHDDataBaseCenterMessageID] State:GYHDDataBaseCenterMessageSentStateFailure];
                    }

                }];
                break;
            }

        case GYHDDataBaseCenterMessageChatAudio:    //音频消息
            {


                NSString *audioPath = [NSString pathWithComponents:@[[self mp3folderNameString], saveDict[@"mp3"]]];
                NSData *audioData = [NSData dataWithContentsOfFile:audioPath];
                [self.netWorkTool postAudioWithData:audioData RequetResult:^(NSDictionary *resultDict) {

                    if (resultDict || [resultDict allKeys].count > 0) {
                        NSMutableDictionary *sendDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                        NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithDictionary:[GYUtils stringToDictionary:dict[GYHDDataBaseCenterMessageBody]]];

                        NSString *mp3Url = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"audioUrl"]];
                        bodyDict[@"msg_content"] = mp3Url;
//                        bodyDict[@"msg_fileSize"] = resultDict[@"timelen"];
                        sendDict[GYHDDataBaseCenterMessageBody] = [GYUtils dictionaryToString:bodyDict];
                        
                        //add by jianglincen
                        //先文件绑定用户，绑定之后再发送文件信息 10月份跟新协议一起上
                        NSDictionary *params=@{
                                               @"fileRefPath":resultDict[@"audioUrl"],
                                               @"receiver":dict[@"MSG_Card"]?dict[@"MSG_Card"]:@"",
                                               @"sender":globalData.loginModel.custId
                                               
                                               };
                        
//                        [[GYHDNetWorkTool sharedInstance]bindFileToUserWithDict:params RequestResult:^(NSDictionary *resultDict) {
//                            
//                            if([resultDict[@"state"]intValue]==200) {
//                                //200成功
//                                
//                                if ([self.delegate respondsToSelector:@selector(sendToServerWithDict:)]) {
//                                    [self.delegate sendToServerWithDict:sendDict];
//                                }
//                            }
//                            
//                            else{
//                                [[GYHDMessageCenter sharedInstance] updateMessageStateWithMessageID:dict[GYHDDataBaseCenterMessageID] State:GYHDDataBaseCenterMessageSentStateFailure];
//                            }
//                        }];
                    
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
                NSString *videoPath = [NSString pathWithComponents:@[[self mp4folderNameString], saveDict[@"mp4Name"]]];
                NSData *videoData = [NSData dataWithContentsOfFile:videoPath];

                [self.netWorkTool postVideoWithData:videoData RequetResult:^(NSDictionary *resultDict) {

                    if (resultDict || [resultDict allKeys].count > 0) {
                        NSMutableDictionary *sendDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                        NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithDictionary:[GYUtils stringToDictionary:dict[GYHDDataBaseCenterMessageBody]]];
                        NSString *mp4VideoPath = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"videoUrl"]];
                        NSString *mp4ImagePath = [NSString stringWithFormat:@"%@%@", resultDict[@"tfsServerUrl"], resultDict[@"firstFrameUrl"]];
                        bodyDict[@"msg_content"] = mp4VideoPath;
                        bodyDict[@"msg_imageNail"] = mp4ImagePath;

                        sendDict[GYHDDataBaseCenterMessageBody] = [GYUtils dictionaryToString:bodyDict];
                        
                        //add by jianglincen
                        //先文件绑定用户，绑定之后再发送文件信息 10月份一起上
                        NSDictionary *params=@{
                                               @"fileRefPath":resultDict[@"videoUrl"],
                                               @"receiver":dict[@"MSG_Card"]?dict[@"MSG_Card"]:@"",
                                               @"sender":globalData.loginModel.custId
                                               
                                               };
//                        
//                        [[GYHDNetWorkTool sharedInstance]bindFileToUserWithDict:params RequestResult:^(NSDictionary *resultDict) {
//                            
//                            if([resultDict[@"state"]intValue]==200) {
//                                //200成功
//                                
//                                if ([self.delegate respondsToSelector:@selector(sendToServerWithDict:)]) {
//                                    [self.delegate sendToServerWithDict:sendDict];
//                                }
//                            }
//                            
//                            else{
//                                [[GYHDMessageCenter sharedInstance] updateMessageStateWithMessageID:dict[GYHDDataBaseCenterMessageID] State:GYHDDataBaseCenterMessageSentStateFailure];
//                            }
//                        }];
//    
                    
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
        [self clearMessageHidenWithCustID:dict[GYHDDataBaseCenterMessageCard]];
    });
}

#pragma mark-- sql 语句查询
- (NSArray<NSDictionary*>*)selectAllChatWithCard:(NSString*)cardStr frome:(NSInteger)from to:(NSInteger)to
{
    return [[GYHDDataBaseCenter sharedInstance] selectAllChatWithCard:cardStr frome:from to:to];
}

- (NSString*)UnreadMessageCountWithCard:(NSString*)CardStr;
{
    return [[GYHDDataBaseCenter sharedInstance] UnreadMessageCountWithCard:CardStr];
}

- (NSInteger)UnreadAllMessageCount
{
    return [[GYHDDataBaseCenter sharedInstance] UnreadAllMessageCount];
}

- (void)savedbFull:(NSString*)dbFull
{
    return [[GYHDDataBaseCenter sharedInstance] savedbFull:dbFull];
}

- (BOOL)ClearUnreadMessageWithCard:(NSString*)CardStr
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
- (NSArray<NSDictionary*>*)selectLastGroupMessage
{
    return [[GYHDDataBaseCenter sharedInstance] selectLastGroupMessage];
}

- (NSArray<NSDictionary*>*)selectPushWithMessageCode:(NSString*)messageCode from:(NSInteger)from to:(NSInteger)to
{
    return [[GYHDDataBaseCenter sharedInstance] selectPushWithMessageCode:messageCode from:from to:to];
}
//
///**
// * 查询所有订单消息
// */
//- (NSArray *)selectAllDingDanList {
//    return [[GYHDDataBaseCenter sharedInstance] selectAllDingDanList];
//}
/**某种消息统计*/
//-(NSInteger)countWithCustID:(NSString *)CustID {
//    return [[GYHDDataBaseCenter sharedInstance] countWithCustID:CustID];
//}
- (NSInteger)countWithCustID:(NSString*)CustID searchString:(NSString*)string
{
    return [[GYHDDataBaseCenter sharedInstance] countWithCustID:CustID searchString:string];
}
/**
 * 查询某种类型的所有消息
 */
//- (NSArray *)selectAllMessageListWithMessageCard:(NSString *)messageCard {
//    return [[GYHDDataBaseCenter sharedInstance] selectAllMessageListWithMessageCard:messageCard];
//}

- (BOOL)updateMessageStateWithMessageID:(NSString*)messageID State:(GYHDDataBaseCenterMessageSentStateOption)state
{
    if (![[GYHDDataBaseCenter sharedInstance] updateMessageStateWithMessageID:messageID State:state])
        return NO;

    NSDictionary* dict = @{ @"msgID" : messageID,
        @"State" : @(state) };
    [self postDataBaseChangeNotificationWithDict:dict];
    //   [self postDataBaseChangeNotification];
    return YES;
}

/**查询某个好友基本信息*/
- (NSDictionary*)selectFriendBaseWithCardString:(NSString*)card
{
    return [[GYHDDataBaseCenter sharedInstance] selectfriendBaseWithCardStr:card];
}

/**删除好友分组*/
- (void)deleteFriendTeamID:(NSString*)teamID RequetResult:(RequetResultWithDict)handler
{
    [self.netWorkTool deleteFriendTeamID:teamID RequetResult:^(NSDictionary* resultDict) {
        handler(resultDict);
        NSString *retCode = resultDict[@"retCode"];
        if ([retCode isEqualToString:@"200"]) {
            [[GYHDDataBaseCenter sharedInstance] deleteWithMessage:teamID fieldName:GYHDDataBaseCenterFriendTeamTeamID TableName:GYHDDataBaseCenterFriendTeamTableName];
        }
    }];
}

- (void)MovieFriendWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler
{
    //     WS(weakSelf)
    [self.netWorkTool MovieFriendWithDict:dict RequetResult:^(NSDictionary* resultDict) {
        handler(resultDict);
        //        [weakSelf getFriendListRequetResult:^(NSArray *resultArry) {
        //
        //            NSMutableDictionary *frienddeletedict = [NSMutableDictionary dictionary];
        //            frienddeletedict[@"friendChange"] = @(GYHDProtobufMessage04102);
        //            frienddeletedict[@"toID"] =  dict[@"friendId"];
        //            [weakSelf postDataBaseChangeNotificationWithDict:frienddeletedict];
        //        }];

    }];
}

- (void)updateFriendTeamWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler
{

    [self.netWorkTool updateFriendTeamWithDict:dict RequetResult:^(NSDictionary* resultDict) {
        handler(resultDict);

    }];
}

/**
 * 消息置顶
 */
- (BOOL)messageTopWithMessageCard:(NSString*)messageCard
{
    if (![[GYHDDataBaseCenter sharedInstance] messageTopWithMessageCard:messageCard])
        return NO;
    [self postDataBaseChangeNotificationWithDict:nil];
    return YES;
}

/**
 * 消息取消置顶
 */
- (BOOL)messageClearTopWithMessageCard:(NSString*)messageCard
{
    if (![[GYHDDataBaseCenter sharedInstance] messageClearTopWithMessageCard:messageCard])
        return NO;
    [self postDataBaseChangeNotificationWithDict:nil];
    return YES;
}

/**设置隐藏消息*/
- (BOOL)setMessageHidenWithCustID:(NSString *)CustID {
    if (![[GYHDDataBaseCenter sharedInstance] setMessageHidenWithCustID:CustID])
        return NO;
    [self postDataBaseChangeNotificationWithDict:nil];
    return YES;
}
/**清除隐藏消息*/
- (BOOL)clearMessageHidenWithCustID:(NSString *)CustID {
    if (![[GYHDDataBaseCenter sharedInstance] clearMessageHidenWithCustID:CustID])
        return NO;
    [self postDataBaseChangeNotificationWithDict:nil];
    return YES;
}
- (NSInteger)selectCountMessageTop {
    return [[GYHDDataBaseCenter sharedInstance] selectCountMessageTop];
}
/**
 * 删除消息
 */
- (BOOL)deleteMessageWithMessageCard:(NSString*)messageCard
{
    if (![[GYHDDataBaseCenter sharedInstance] deleteMessageWithMessageCard:messageCard])
        return NO;
    [self postDataBaseChangeNotificationWithDict:nil];
    return YES;
}

/**根据某个删除消息*/
- (BOOL)deleteMessageWithMessage:(NSString*)message fieldName:(NSString*)fieldName
{
    if (![[GYHDDataBaseCenter sharedInstance] deleteMessageWithMessage:message fieldName:fieldName])
        return NO;
    return YES;
}

#pragma mark-- 发通知

- (void)postDataBaseChangeNotificationWithDict:(NSDictionary*)dict
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:GYHDMessageCenterDataBaseChageNotification object:dict];
    });
}

/**
 * 发送即时聊天通知
 */
- (void)postDataBaseChangeNotification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:GYHDMessageCenterDataBaseChageNotification object:nil];
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
 * 获得好友基本信息
 */
- (NSArray*)getFriendListRequetResult:(RequetResultWithArray)handler isNetwork:(BOOL)isNetwork;
{

    //2. 从bending数据库获取数据
    NSArray* DataBaseArray = [[GYHDDataBaseCenter sharedInstance] selectFriendList];
    return DataBaseArray;
}

- (NSArray*)getFriendListRequetResult:(RequetResultWithArray)handler
{
    //1. 从网络获取数据
    if (handler) {
        [self.netWorkTool getFriendListRequetResult:^(NSDictionary* resultDict) {
            if ([resultDict[@"retCode"] isEqualToString:@"200"]) {
                NSMutableArray *recvArray = [NSMutableArray array];
                [[GYHDDataBaseCenter sharedInstance] deleteWithMessage: GYHDDataBaseCenterFriends  fieldName:GYHDDataBaseCenterFriendMessageType  TableName:GYHDDataBaseCenterFriendTableName];
                for (NSDictionary *dict1 in resultDict[@"rows"] ) {
                    NSMutableDictionary *dict = dict1.mutableCopy;
                    NSMutableDictionary *friendDict = [NSMutableDictionary dictionary];
                    friendDict[GYHDDataBaseCenterFriendFriendID] = dict[@"accountId"];
                    friendDict[GYHDDataBaseCenterFriendCustID] = dict[@"custId"];
                    if ( dict[@"resNo"]) {
                        friendDict[GYHDDataBaseCenterFriendResourceID] = dict[@"resNo"];
                    }else {
                        friendDict[GYHDDataBaseCenterFriendResourceID] = [friendDict[GYHDDataBaseCenterFriendCustID] substringToIndex:11];
                    }
    
                    NSString *name = nil;
                    if (dict[@"remark"] && ![dict[@"remark"] isEqual:[NSNull class]] && dict[@"remark"] != nil && ![dict[@"remark"] isEqualToString:@""]) {
                        name = dict[@"remark"];
                    } else {
                        name = dict[@"nickname"];
                    }
                    friendDict[GYHDDataBaseCenterFriendName] = name;
                    if ([friendDict[GYHDDataBaseCenterFriendFriendID] hasPrefix:@"nc_"] &&
                        [friendDict[GYHDDataBaseCenterFriendName] isEqualToString:friendDict[GYHDDataBaseCenterFriendResourceID]]) {
                        NSMutableString *nameAtt = [NSMutableString stringWithString:name];
                        [nameAtt replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                        friendDict[GYHDDataBaseCenterFriendName]= nameAtt;
                        
                        if (dict[@"remark"] && ![dict[@"remark"] isEqual:[NSNull class]] && dict[@"remark"] != nil && ![dict[@"remark"] isEqualToString:@""]) {
                            dict[@"remark"] = nameAtt;
                        } else {
                            dict[@"nickname"] = nameAtt;
                        }
                        
                    }else {
                        friendDict[GYHDDataBaseCenterFriendName] = name;
                    }
                    
          
                    if ([ dict[@"headPic"] hasPrefix:@"http"]) {
                        friendDict[GYHDDataBaseCenterFriendIcon] = dict[@"headPic"];
                    }else {
                        friendDict[GYHDDataBaseCenterFriendIcon] = [NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl, dict[@"headPic"]];
                    }
                    
    
                    friendDict[GYHDDataBaseCenterFriendApplication] = dict[@"friendStatus"];
                    friendDict[GYHDDataBaseCenterFriendUsetType] = @"c";
                    friendDict[GYHDDataBaseCenterFriendMessageType] = GYHDDataBaseCenterFriends;
                    friendDict[GYHDDataBaseCenterFriendMessageTop] = @"-1";
                    friendDict[GYHDDataBaseCenterFriendInfoTeamID] = dict[@"teamId"];
                    friendDict[GYHDDataBaseCenterFriendTeamFriendSet] = dict[@"teamIdFreindSet"];
                    friendDict[GYHDDataBaseCenterFriendSign] = dict[@"sign"];
                    friendDict[GYHDDataBaseCenterFriendBasic] = [GYUtils dictionaryToString:dict];
                    friendDict[GYHDDataBaseCenterFriendDetailed] = [GYUtils dictionaryToString:dict];
                    [[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:friendDict TableName:GYHDDataBaseCenterFriendTableName];
                    if ([dict[@"teamIdFreindSet"] isEqualToString:@"blacklisted"] ||
                        [dict[@"teamId"] isEqualToString:@"blacklisted"] ||
                        [dict[@"friendStatus"] isEqualToString:@"1"]||
                        [dict[@"friendStatus"] isEqualToString:@"-1"]) {
                 
                    }else {
                        [recvArray addObject:friendDict];
                    }
    
                }
                handler(recvArray);
            }else if ([resultDict[@"retCode"] isEqualToString:@"204"]) {
                [[GYHDDataBaseCenter sharedInstance] deleteWithMessage: GYHDDataBaseCenterFriends  fieldName:GYHDDataBaseCenterFriendMessageType  TableName:GYHDDataBaseCenterFriendTableName];
                handler(nil);
            }
        }];
    }
    //2. 从bending数据库获取数据
    NSArray* DataBaseArray = [[GYHDDataBaseCenter sharedInstance] selectFriendBaseList];
    return DataBaseArray;
}

/**查询未某内分组用户*/
- (NSArray*)selectFriendWithTeamID:(NSString*)teamID
{
    return [[GYHDDataBaseCenter sharedInstance] selectFriendWithTeamID:teamID];
}

/**
 * 获得好友分组,此发送有两返回值1. 直接返回的是通过数据库得到的， 2.block返回的是从服务器获取的
 */
- (NSArray*)getFriendTeamRequetResult:(RequetResultWithArray)handler
{
    if (handler) {
        [self.netWorkTool getFriendTeamRequetResult:^(NSDictionary* resultDict) {
            if ([resultDict[@"retCode"]integerValue] == 200 ) {
                
             handler(resultDict[@"rows"]);
                [[GYHDDataBaseCenter sharedInstance] deleteWithMessage:nil fieldName:nil TableName:GYHDDataBaseCenterFriendTeamTableName];
                for (NSDictionary *dict in resultDict[@"rows"]) {
                    [[GYHDDataBaseCenter sharedInstance] updateFriendTeamWtihDict:dict];
                }
            }



        }];
    }
    return [[GYHDDataBaseCenter sharedInstance] selectInfoEqualDict:nil TableName:@"T_TREAMS"];
    //    return [[GYHDDataBaseCenter sharedInstance] selectFriendTeam];
}

/**创建好友分组*/
- (void)createFriendTeamWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler
{
    [self.netWorkTool createFriendTeamWithDict:dict RequetResult:^(NSDictionary* resultDict) {
        if (resultDict) {
            
            handler(resultDict);
            [[GYHDDataBaseCenter sharedInstance] updateFriendTeamWtihDict:resultDict];
        }
    }];
}
//
///**
// * 获得朋友基本信息返回字典
// */
//- (NSDictionary *)getFriendDetailWithAccountID:(NSString *)accountID RequetResultWithDict:(RequetResultWithDict)handler {
//    [self.netWorkTool getFriendDetailWithAccountID:accountID RequetResult:^(NSDictionary *resultDict) {
//        if (!resultDict) return;
//        handler(resultDict);
//        [[GYHDDataBaseCenter sharedInstance] updateFriendDetailWithDict:resultDict];
//    }];
//    return [[GYHDDataBaseCenter sharedInstance] selectFriendDetailWithAccountID:accountID];
//}

/**
 * 朋友字典 转 数组
 */
- (NSArray*)FriendarrayWithDict:(NSDictionary*)dict
{
    NSMutableArray* arrayM = [NSMutableArray array];

    for (NSString* field in [dict allKeys]) {
        NSMutableDictionary* Childdict = [NSMutableDictionary dictionary];
        Childdict[field] = dict[field];
        [arrayM addObject:Childdict];
    }
    NSMutableArray* retunarrayM = [NSMutableArray array];
    [retunarrayM addObject:arrayM];
    return retunarrayM;
}

/**
 * 把字典所以值转换成字符串
 */
- (void)checkDict:(NSMutableDictionary*)dict
{
    for (NSString* key in [dict allKeys]) {
        if ([dict[key] isEqual:[NSNull null]] || dict[key] == nil) {
            dict[key] = @"";
        }
        if ([dict[key] isKindOfClass:[NSNumber class]]) {
            dict[key] = [NSString stringWithFormat:@"%@", dict[key]];
        }
        if ([dict[key] isKindOfClass:[NSMutableDictionary class]]) {
            [self checkDict:dict[key]];
        }
        //        if ([dict[key] isKindOfClass:[NSMutableArray class]]) {
        //            for (NSMutableDictionary *chilidDict in dict[key]) {
        //                [self checkDict:chilidDict];
        //            }
        //            //            for (NSString *chilidKey in [dict[key] allKeys]) {
        //            //                [ self checkDict:dict[key][chilidKey]];
        //            //            }
        //        }
    }
}

- (void)readAudioMessageID:(NSString*)messageID RequetResultWithDictBlock:(RequetResultWithDict)block
{
    //1.下载音频
    //2.回传block
}

/** 
 * 根据时间字符串返回需要的文字
 */
- (NSString*)messageTimeStrFromTimerString:(NSString*)timeString
{
    if (!timeString || [timeString isEqualToString:@""])
        return @"";
    //    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    //
    //    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSMutableDictionary* threadDictionary = [[NSThread currentThread] threadDictionary];

    NSDateFormatter* fmt = threadDictionary[@"mydateformatter"];

    if (!fmt) {
        @synchronized(self)
        {
            if (!fmt) {
                fmt = [[NSDateFormatter alloc] init];
                [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            }
        }
    }
    //    _created_at = @"Tue Sep 30 17:06:25 +0600 2014";
    NSDate* createDate = [fmt dateFromString:timeString];
    //    NSDate *now = [NSDate date];
    //    NSCalendar *calendar = [NSCalendar currentCalendar];
    //    // NSCalendarUnit枚举代表想获得哪些差值
    //    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    //    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];

    if ([self isThisYearWithData:createDate]) { // 今年
        if ([self isTheDayBeforeYesterdayWithData:createDate]) {
//            fmt.dateFormat = @"前天 HH:mm";
//            return [fmt stringFromDate:createDate];
            return @"前天";
        }
        else if ([self isYesterdayData:createDate]) { // 昨天
//            fmt.dateFormat = @"昨天 HH:mm";
//            return [fmt stringFromDate:createDate];
            return @"昨天";
        }
        else if ([self isTodayData:createDate]) { // 今天
            fmt.dateFormat = @"HH:mm";
            return [fmt stringFromDate:createDate];
        }
        else { // 今年的其他日子
            fmt.dateFormat = @"yyyy-MM-dd";
            return [fmt stringFromDate:createDate];
        }
    }
    else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }
    return @"";
}

/**
 *  判断某个时间是否为今年
 */
- (BOOL)isThisYearWithData:(NSDate*)oldData
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    // 获得某个时间的年月日时分秒
    NSDateComponents* dateCmps = [calendar components:NSCalendarUnitYear fromDate:oldData];
    NSDateComponents* nowCmps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    return dateCmps.year == nowCmps.year;
}

/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterdayData:(NSDate*)oldData
{
    NSDate* now = [NSDate date];

    // date ==  2014-04-30 10:05:28 --> 2014-04-30 00:00:00
    // now == 2014-05-01 09:22:10 --> 2014-05-01 00:00:00
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";

    // 2014-04-30
    NSString* dateStr = [fmt stringFromDate:oldData];
    // 2014-10-18
    NSString* nowStr = [fmt stringFromDate:now];

    // 2014-10-30 00:00:00
    NSDate* date = [fmt dateFromString:dateStr];
    // 2014-10-18 00:00:00
    now = [fmt dateFromString:nowStr];

    NSCalendar* calendar = [NSCalendar currentCalendar];

    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* cmps = [calendar components:unit fromDate:date toDate:now options:0];

    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}

/**
 * 判断某个时间是否为前天
 */
- (BOOL)isTheDayBeforeYesterdayWithData:(NSDate*)oldData
{
    NSDate* now = [NSDate date];

    // date ==  2014-04-30 10:05:28 --> 2014-04-30 00:00:00
    // now == 2014-05-01 09:22:10 --> 2014-05-01 00:00:00
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";

    // 2014-04-30
    NSString* dateStr = [fmt stringFromDate:oldData];
    // 2014-10-18
    NSString* nowStr = [fmt stringFromDate:now];

    // 2014-10-30 00:00:00
    NSDate* date = [fmt dateFromString:dateStr];
    // 2014-10-18 00:00:00
    now = [fmt dateFromString:nowStr];

    NSCalendar* calendar = [NSCalendar currentCalendar];

    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* cmps = [calendar components:unit fromDate:date toDate:now options:0];

    return cmps.year == 0 && cmps.month == 0 && cmps.day == 2;
}

/**
 *  判断某个时间是否为今天
 */
- (BOOL)isTodayData:(NSDate*)oldData
{
    NSDate* now = [NSDate date];
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";

    NSString* dateStr = [fmt stringFromDate:oldData];
    NSString* nowStr = [fmt stringFromDate:now];

    return [dateStr isEqualToString:nowStr];
}

/**
 * 取得图片
 */
- (void)messageContentAttributedStringWithString:(NSString*)string AttrString:(NSMutableAttributedString*)messageAttrStr
{
    NSString* pattern = @"\\[[0-9]{3}\\]";
    NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    // 2.测试字符串
    NSArray* results = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    // 3.遍历结果
    [results enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult* result, NSUInteger idx, BOOL* _Nonnull stop) {
        NSString *imageName = [[string substringWithRange:result.range] substringWithRange:NSMakeRange(1, 3)];
        EmojiTextAttachment *textAtt =
        [[EmojiTextAttachment alloc] init];
        
//        UIImage *image = [UIImage imageNamed:imageName];
//        NSTextAttachment *textAtt = [[NSTextAttachment alloc] init];
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            textAtt.emojiName = [NSString stringWithFormat:@"[%@]",imageName];
            textAtt.image = image;
            textAtt.bounds = CGRectMake(0, -3, 13, 13);
            NSAttributedString *att = [NSAttributedString attributedStringWithAttachment:textAtt];
            [messageAttrStr replaceCharactersInRange:result.range withAttributedString:att];
        }
    }];
}

- (NSMutableAttributedString*)attStringWithString:(NSString*)string imageFrame:(CGRect)imageFrame attributes:(NSDictionary*)dict
{
    NSMutableAttributedString* attString = nil;
    if (!dict) {
        attString = [[NSMutableAttributedString alloc] initWithString:string];
    }
    else {
        attString = [[NSMutableAttributedString alloc] initWithString:string attributes:dict];
    }

    NSString* pattern = @"\\[[0-9]{3}\\]";
    NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    // 2.测试字符串
    NSArray* results = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    // 3.遍历结果
    [results enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult* result, NSUInteger idx, BOOL* _Nonnull stop) {
        NSString *imageName = [[string substringWithRange:result.range] substringWithRange:NSMakeRange(1, 3)];
        NSTextAttachment *textAtt = [[NSTextAttachment alloc] init];
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            textAtt.image = image;
            textAtt.bounds = imageFrame;
            NSAttributedString *att = [NSAttributedString attributedStringWithAttachment:textAtt];
            NSMutableAttributedString *attM = [[NSMutableAttributedString alloc] initWithAttributedString:att];
//            NSAttributedString *att2 = [[NSAttributedString alloc] initWithString:@" "];
//            [attM appendAttributedString:att2];
            [attString replaceCharactersInRange:result.range withAttributedString:attM];
        }
    }];

    return attString;
}

- (NSString*)stringWithAttString:(NSAttributedString*)AttString
{

    NSMutableAttributedString* att = [[NSMutableAttributedString alloc] initWithAttributedString:AttString];
    __block NSMutableString* messageString = [NSMutableString string];

    if (!self.emojiArray) {
        NSMutableArray* array = [NSMutableArray array];
        for (int i = 1; i <= 60; i++) {
            NSMutableDictionary* dict = [NSMutableDictionary dictionary];
            dict[@"emojiName"] = [NSString stringWithFormat:@"[%03d]", i];
            dict[@"emoji"] = [UIImage imageNamed:[NSString stringWithFormat:@"%03d", i]];
            [array addObject:dict];
        }
        self.emojiArray = array;
    }
    [att enumerateAttributesInRange:NSMakeRange(0, att.length) options:0 usingBlock:^(NSDictionary<NSString*, id>* _Nonnull attrs, NSRange range, BOOL* _Nonnull stop) {
        NSTextAttachment *attChment = attrs[@"NSAttachment"];
        if (attChment) {
            {
                EmojiTextAttachment *attChment =
                attrs[@"NSAttachment"];
                
                // DDLogInfo(@"attChment.emojiName=%@",attChment.emojiName);
                if (attChment) {
                    if ([attChment isKindOfClass:
                         [EmojiTextAttachment class]]) {
                        for (NSDictionary *dic in self.emojiArray) {
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
                        for (NSDictionary *dict in self.emojiArray) {
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
//            for (NSDictionary *dict in self.emojiArray) {
//                UIImage *image = dict[@"emoji"];
//                if ([UIImagePNGRepresentation(image) isEqual:UIImagePNGRepresentation(attChment.image)]) {
//                    [messageString appendString:dict[@"emojiName"]];
//                    break;
//                }
//            }
        } else {
            [messageString appendString:[att attributedSubstringFromRange:range].string];
        }
    }];

    return messageString;
}

/**
 * 绑定企业账号
 */
- (void)bindCompanyWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler
{
    [[GYHDNetWorkTool sharedInstance] bindCompanyWithDict:dict RequetResult:^(NSDictionary* resultDict) {
        handler(resultDict);
    }];
}

/**获取MP4文件夹*/
- (NSString*)mp4folderNameString
{
    //    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"HDmp4"];
    NSString* path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HDmp4"];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }

    return path;
}

/**获取MP3文件夹*/
- (NSString*)mp3folderNameString
{

    //    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"HDmp3"];
    NSString* path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HDmp3"];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

/**获取Image文夹*/
- (NSString*)imagefolderNameString
{
    //    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"HDimage"];
    NSString* path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HDimage"];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

- (void)downloadDataWithUrlString:(NSString*)urlstring RequetResult:(RequetResultWithDict)handler
{
    return [self.netWorkTool downloadDataWithUrlString:urlstring RequetResult:handler];
}

/**更新某个字段值*/
- (BOOL)updateMessageWithMessageID:(NSString*)messageID fieldName:(NSString*)fieldName updateString:(NSString*)updateString
{
    return [[GYHDDataBaseCenter sharedInstance] updateMessageWithMessageID:messageID fieldName:fieldName updateString:updateString];
}

//- (void)searchFriendWithString:(NSString *)string page:(NSString *)page RequetResult:(RequetResultWithDict)handler {
//    [self.netWorkTool searchFriendWithString:string Page:page RequetResult:handler];
//}

/**搜索好友*/
- (void)searchFriendWithDict:(NSDictionary*)dict Page:(NSString*)page RequetResult:(RequetResultWithDict)handler
{
    [self.netWorkTool searchFriendWithDict:dict Page:page RequetResult:handler];
}

- (NSArray*)selectCityWithString:(NSString*)string
{
    //    return [[GYFMDBCityManager shareInstance] selectAddressWithString:string];
    return [[GYAddressData shareInstance] selectAddressWithString:string];
}

- (void)loadTopicFromNetworkRequetResult:(RequetResultWithDict)handler
{
    return [self.netWorkTool loadTopicFromNetworkRequetResult:handler];
}

/**搜索好友信息*/
- (NSDictionary*)searchFriendWithCustId:(NSString*)custID RequetResult:(RequetResultWithDict)handler
{
    if (handler) {
        [self.netWorkTool searchFriendWithCustId:custID RequetResult:^(NSDictionary* resultDict) {
            NSMutableDictionary *friendDict = [NSMutableDictionary dictionary];
                friendDict[GYHDDataBaseCenterFriendName] = resultDict[@"nickName"];
            if ([resultDict[@"userType"] integerValue]) {
                friendDict[GYHDDataBaseCenterFriendFriendID] = [NSString stringWithFormat:@"c_%@", resultDict[@"custId"]];
                friendDict[GYHDDataBaseCenterFriendUsetType] = @"c";

            }else {
                friendDict[GYHDDataBaseCenterFriendFriendID] = [NSString stringWithFormat:@"nc_%@", resultDict[@"custId"]];
                friendDict[GYHDDataBaseCenterFriendUsetType] = @"nc";
                if ([resultDict[@"nickName"] isEqualToString:resultDict[@"resNo"]]) {
                    NSMutableString *name = [NSMutableString stringWithString:resultDict[@"nickName"]];
                    [name replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                    friendDict[GYHDDataBaseCenterFriendName] = name;
//                    resultDict[@"nickName"] = name;
                    [resultDict setValue:name forKey:@"nickName"];
                }

            }
    
            friendDict[GYHDDataBaseCenterFriendCustID] = resultDict[@"custId"];
            friendDict[GYHDDataBaseCenterFriendResourceID] = resultDict[@"resNo"];

            if ([resultDict[@"headImage"] hasPrefix:@"http"]) {
                friendDict[GYHDDataBaseCenterFriendIcon] = resultDict[@"headImage"];
            }else {
                if ([resultDict[@"headImage"] length] > 5) {
                    friendDict[GYHDDataBaseCenterFriendIcon] =  [NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,resultDict[@"headImage"]] ;
                }else {
                    friendDict[GYHDDataBaseCenterFriendIcon] = @"" ;
                }

            }


            if ([custID isEqualToString:globalData.loginModel.custId]) {
                friendDict[GYHDDataBaseCenterFriendMessageType] = GYHDDataBaseCenterMy;
            } else {
                friendDict[GYHDDataBaseCenterFriendMessageType] = GYHDDataBaseCenterFocusOnBusiness;
            }
            friendDict[GYHDDataBaseCenterFriendMessageTop] = @"-1";
            friendDict[GYHDDataBaseCenterFriendInfoTeamID] = @"";
            friendDict[GYHDDataBaseCenterFriendBasic] = [GYUtils dictionaryToString:resultDict];
            friendDict[GYHDDataBaseCenterFriendDetailed] = [GYUtils dictionaryToString:resultDict];
            handler(friendDict);
//            [[GYHDMessageCenter sharedInstance] deleteWithMessage:GYHDDataBaseCenterMy fieldName:GYHDDataBaseCenterFriendMessageType TableName:GYHDDataBaseCenterFriendTableName];
            [[GYHDMessageCenter sharedInstance] deleteWithMessage:custID fieldName:GYHDDataBaseCenterFriendCustID TableName:GYHDDataBaseCenterFriendTableName];
            [[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:friendDict TableName:GYHDDataBaseCenterFriendTableName];
        }];
    }
    return [[GYHDDataBaseCenter sharedInstance] selectfriendBaseWithCardStr:custID];
    ;
}

/**关注商品信息*/
- (NSArray*)EasyBuyGetMyConcernShopUrlRequetResult:(RequetResultWithArray)handler
{
    if (handler) {
        [self.netWorkTool EasyBuyGetMyConcernShopUrlRequetResult:^(NSArray* resultArry) {
//            handler(resultArry);
            if (!resultArry) return;
            NSMutableArray *array = [NSMutableArray array];
            [[GYHDDataBaseCenter sharedInstance] deleteWithMessage:GYHDDataBaseCenterFocusOnBusiness fieldName:GYHDDataBaseCenterFriendMessageType TableName:GYHDDataBaseCenterFriendTableName];
            for (NSDictionary *dict in resultArry) {
                if (dict[@"entCustId"]) {
                    NSMutableDictionary *friendDict = [NSMutableDictionary dictionary];
                    friendDict[GYHDDataBaseCenterFriendFriendID] = [NSString stringWithFormat:@"e_%@", dict[@"entCustId"]];
                    friendDict[GYHDDataBaseCenterFriendCustID] = dict[@"entCustId"];
                    friendDict[GYHDDataBaseCenterFriendName] = dict[@"vShopName"];
                    friendDict[GYHDDataBaseCenterFriendResourceID] = dict[@"entResourceNo"];
                    friendDict[GYHDDataBaseCenterFriendIcon] = dict[@"url"];
                    friendDict[GYHDDataBaseCenterFriendUsetType] = @"e";
                    friendDict[GYHDDataBaseCenterFriendMessageType] = GYHDDataBaseCenterFocusOnBusiness;
                    friendDict[GYHDDataBaseCenterFriendMessageTop] = @"-1";
                    friendDict[GYHDDataBaseCenterFriendInfoTeamID] = dict[@"id"];;
                    friendDict[GYHDDataBaseCenterFriendBasic] = [GYUtils dictionaryToString:dict];
                    friendDict[GYHDDataBaseCenterFriendDetailed] = [GYUtils dictionaryToString:dict];
          
                    [[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:friendDict TableName:GYHDDataBaseCenterFriendTableName];
                    [array addObject:friendDict];
                }
            }
            handler(array);
        }];
    }
    NSArray* array = [[GYHDDataBaseCenter sharedInstance] selectFocusCompanyList];
    return array;
}

- (BOOL)insertInfoWithDict:(NSDictionary*)dict TableName:(NSString*)tableName
{
    return [[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:dict TableName:tableName];
}

- (BOOL)updateInfoWithDict:(NSDictionary*)dict conditionDict:(NSDictionary*)conditionDict TableName:(NSString*)tableName
{
    
//    NSMutableDictionary *frienddeletedict = [NSMutableDictionary dictionary];
//    frienddeletedict[@"friendChange"] = @(100);
//    frienddeletedict[@"toID"] =  dict[@"friendId"];
//    [self postDataBaseChangeNotificationWithDict:frienddeletedict];
    return [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:dict conditionDict:conditionDict TableName:tableName];
    
}

- (BOOL)deleteWithMessage:(NSString*)message fieldName:(NSString*)fieldName TableName:(NSString*)tableName
{
    return [[GYHDDataBaseCenter sharedInstance] deleteWithMessage:message fieldName:fieldName TableName:tableName];
}

- (void)updateSelfInfoWith:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler
{
    NSData* data = dict[@"imageData"];
    [GYGIFHUD show];
    if (data) {
        [self.netWorkTool postHeaderWithData:data RequetResult:^(NSDictionary* resultDict) {
            
            NSString *imageStr = resultDict[@"data"];
            NSMutableDictionary *sendDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [sendDict removeObjectForKey:@"imageData"];
            //        sendDict[@"headShot"] = [NSString stringWithFormat:@"%@%@.%@",globalData.loginModel.picUrl,resultDict[@"data"],resultDict[@"msg"]];
            sendDict[@"headShot"] = imageStr;
            
            
            NSMutableDictionary* dict = [NSMutableDictionary dictionary];
            [dict setValue:globalData.loginModel.token forKey:@"token"];
            [dict setValue:imageStr forKey:@"headPic"];
            GYNetRequest *requestHeadPic = [[GYNetRequest alloc]initWithBlock:EasyBuyUpdateNewPicUrl parameters:dict requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
                
            }];
            [requestHeadPic start];
            
            [[GYHDNetWorkTool sharedInstance] updateNetworkInfoWithDict:sendDict RequetResult:^(NSDictionary *resultDict) {
                [GYGIFHUD dismiss];
                handler(resultDict);
                
                if ([resultDict[@"retCode"] integerValue] == 200) {
                    globalData.loginModel.headPic = imageStr;
                    NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
                    updateDict[GYHDDataBaseCenterFriendName] = sendDict[@"nickname"];
                    updateDict[GYHDDataBaseCenterFriendIcon] = [NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,sendDict[@"headShot"]];
                    NSMutableDictionary *condDict = [NSMutableDictionary dictionary];
                    condDict[GYHDDataBaseCenterFriendMessageType] = GYHDDataBaseCenterMy;
                    [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:condDict TableName:GYHDDataBaseCenterFriendTableName];
                }
            }];
            
        }];
    }else {
        NSMutableDictionary *sendDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        [sendDict removeObjectForKey:@"imageData"];
        [sendDict removeObjectForKey:@"headShot"];
        [[GYHDNetWorkTool sharedInstance] updateNetworkInfoWithDict:sendDict RequetResult:^(NSDictionary *resultDict) {
            [GYGIFHUD dismiss];
            handler(resultDict);
            
            if ([resultDict[@"retCode"] integerValue] == 200) {
                NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
                updateDict[GYHDDataBaseCenterFriendName] = sendDict[@"nickname"];
                NSMutableDictionary *condDict = [NSMutableDictionary dictionary];
                condDict[GYHDDataBaseCenterFriendMessageType] = GYHDDataBaseCenterMy;
                [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:condDict TableName:GYHDDataBaseCenterFriendTableName];
            }
        }];

    }

}

/**搜索某条消息*/
- (NSArray*)selectSearchMessageWithString:(NSString*)string
{
    return [[GYHDDataBaseCenter sharedInstance] selectSearchMessageWithString:string];
}

/**好友*/
- (void)deleteFriendWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler
{
    WS(weakSelf);
    [self.netWorkTool deleteFriendWithDict:dict RequetResult:^(NSDictionary* resultDict) {
        handler(resultDict);
        
        NSMutableDictionary *frienddeletedict = [NSMutableDictionary dictionary];
        frienddeletedict[@"friendChange"] = @(100);
        frienddeletedict[@"toID"] =  dict[@"friendId"];
        [weakSelf postDataBaseChangeNotificationWithDict:frienddeletedict];
    }];
}

- (NSDictionary*)selectMyInfo
{
    return [[GYHDDataBaseCenter sharedInstance] selectMyInfo];
}

- (NSArray*)selectInfoWithDict:(NSDictionary*)condDict TableName:(NSString*)tableName
{
    return [[GYHDDataBaseCenter sharedInstance] selectInfoWithDict:condDict TableName:tableName];
}

- (void)loadUnreadMessageData:(NSData*)data
{
    if ([self.delegate respondsToSelector:@selector(sendProtobufToServerWithData:)]) {
        [self.delegate sendProtobufToServerWithData:data];
    }
}

- (BOOL)deleteInfoWithDict:(NSDictionary*)dict TableName:(NSString*)tableName
{
    return [[GYHDDataBaseCenter sharedInstance] deleteInfoWithDict:dict TableName:tableName];
}

/**好友添加状态*/
- (void)queryWhoAddMeListRequetResult:(RequetResultWithDict)handler
{
    [self.netWorkTool queryWhoAddMeListRequetResult:handler];
}

//- (NSDictionary *)selectCompanyWithCustID:(NSString *)custID{
//    return [[GYHDDataBaseCenter sharedInstance] selectCompanyWithCustID:custID];
//
- (void)searchCompanyWithString:(NSString*)string currentPage:(NSString*)currentPage RequetResult:(RequetResultWithDict)handler
{
    [self.netWorkTool searchCompanyWithString:string currentPage:currentPage RequetResult:handler];
}

- (void)searchCompanyWithcity:(NSString*)city currentPage:(NSString*)currentPage RequetResult:(RequetResultWithDict)handler
{
    [self.netWorkTool searchCompanyWithcity:city currentPage:currentPage RequetResult:handler];
}

/**取消关注*/
- (void)CancelConcernShopUrlWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler
{
    [self.netWorkTool CancelConcernShopUrlWithDict:dict RequetResult:handler];
}

//- (BOOL)saveMessageWithDict:(NSDictionary *)dict {
//    return [[GYHDDataBaseCenter sharedInstance] saveMessageWithDict:dict];
//}

- (void)updateFriendNickNameWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler
{
    [self.netWorkTool updateFriendNickNameWithDict:dict RequetResult:handler];
}
- (NSArray*)selectInfoEqualDict:(NSDictionary*)condDict TableName:(NSString*)tableName
{
    return [[GYHDDataBaseCenter sharedInstance] selectInfoEqualDict:condDict TableName:tableName];
}
- (void)getOfflinePushMsg
{
    [self.IMtimer invalidate];
    self.IMtimer = nil;
    self.IMtimer = [NSTimer scheduledTimerWithTimeInterval:29 target:self selector:@selector(getOfflin) userInfo:nil repeats:YES];
}
- (void)getOfflin
{
    [self.netWorkTool postOffLinePushMessageRequetResult:^(NSArray* resultArry){
        //        NSLog(@"%@",resultArry);
    }];
}

- (BOOL)updataFriendSelectCount:(NSString*)count custID:(NSString*)custID
{
    return [[GYHDDataBaseCenter sharedInstance] updataFriendSelectCount:count custID:custID];
}
- (void)deleteRedundantFriendVerifyDataWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler {
    return[[GYHDNetWorkTool sharedInstance] deleteRedundantFriendVerifyDataWithDict:dict RequetResult:handler];
}
- (NSArray *)selectApplicationFriend{
    return [[GYHDDataBaseCenter sharedInstance] selectApplicationFriend];
}

- (NSString*)getUserDBNameInDirectory:(NSString*)userName
{
    //在cache目录下创建
    //    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    //    NSString *dbName = [NSString stringWithFormat:@"%@_%@",version, kImDBName];
    NSString* dbName = @"data.db";
    NSString* dbFullName = [NSString pathWithComponents:@[ NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0], [@"in" stringByAppendingString:userName], dbName ]];
    //    DDLogInfo(@"get dbFullName:%@ for user:%@", dbFullName, userName);
    return dbFullName;
}


- (BOOL)fileIsExists:(NSString*)fileFullName
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileFullName];
}

- (BOOL)createFile:(NSString*)fileFullName;
{
    NSString* directoriesPath = [self getDirectoriesPathFromFileFullName:fileFullName];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;
    if (![self fileIsExists:directoriesPath]) { //判断目录是否存在 没有就创建
        if (![fileManager createDirectoryAtPath:directoriesPath
                    withIntermediateDirectories:YES
                                     attributes:nil
                                          error:&error]) {
            DDLogInfo(@"创建目录出错:%@ directoriesPath:%@", error, directoriesPath);
            return NO;
        }
        else {
            DDLogInfo(@"创建目录成功：%@", directoriesPath);
        }
    }
    
    //创建文件
    if (![fileManager createFileAtPath:fileFullName contents:nil attributes:nil]) {
        DDLogInfo(@"创建数据库出错:%@", fileFullName);
        return NO;
    }
    else {
        DDLogInfo(@"创建数据库成功：%@", fileFullName);
    }
    return YES;
}
//从文件路径取得文件的目录
- (NSString*)getDirectoriesPathFromFileFullName:(NSString*)fileFullName
{
    NSString* fileName = [fileFullName lastPathComponent]; //文件名
    NSRange range = [fileFullName rangeOfString:fileName options:NSBackwardsSearch];
    NSString* directoriesPath = [fileFullName substringToIndex:range.location];
    return directoriesPath;
}
- (NSArray *)searchMessageListWithString:(NSString *)string custID:(NSString *)custID {
    return [[GYHDDataBaseCenter sharedInstance] searchMessageListWithString:string custID:custID];
}

/**个人设置*/
-(void)updatePrivacyWithString:(NSString *)string RequetResult:(RequetResultWithDict)handler {
    [self.netWorkTool updatePrivacyWithString:string RequetResult:handler];
}
/**查询个人设置*/
- (void)searchPrivacyRequetResult:(RequetResultWithDict)handler {
    [self.netWorkTool searchPrivacyRequetResult:handler];
}
/**根据互生卡 返回分段互生卡*/
- (NSString *)segmentationHuShengCardWithCard:(NSString *)card {
    if (card.length > 10) {
        NSString *sub1 = [card substringWithRange:NSMakeRange(0, 2)];
        NSString *sub2 = [card substringWithRange:NSMakeRange(2, 3)];
        NSString *sub3 = [card substringWithRange:NSMakeRange(5, 2)];
        NSString *sub4 = [card substringWithRange:NSMakeRange(7, 4)];
        card = [NSString stringWithFormat:@"%@ %@ %@ %@",sub1,sub2,sub3,sub4];
    }
    return card;
}
/**查询企业类型*/
- (void)searchCompanyTypeRequetResult:(RequetResultWithDict)handler {
    [self.netWorkTool searchCompanyTypeRequetResult:handler];
}
- (void)getTopicListWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler {
    [self.netWorkTool getTopicListWithDict:dict RequetResult:handler];
}
- (void)GetFoodMainPageUrlWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler;
{
    [self.netWorkTool GetFoodMainPageUrlWithDict:dict RequetResult:handler];
}
- (void)EasyBuySearchShopUrlWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler {
    [self.netWorkTool EasyBuySearchShopUrlWithDict:dict RequetResult:handler];
}
@end
//switch (subMsgCode) {
//#pragma mark -- 互生消息
//    case GYHDDataBaseCenterPush1010201:          //消费者个人消息 ----- 业务消息(小类)绑定互生卡
//    case GYHDDataBaseCenterPush1010208:          //消费者个人消息 ----- 业务消息(小类)订单消息 -----申领抵扣券消息       y
//    case GYHDDataBaseCenterPush1010209:          //消费者个人消息 ----- 意外伤害 您的互生意外伤害保障已生效              y
//    case GYHDDataBaseCenterPush1010210:          //消费者个人消息 ----- 意外伤害保障失效                              y
//    case GYHDDataBaseCenterPush1010211:          //消费者个人消息 ----- 积分投资达到10000 推送可以申请免费医疗           y
//    {
//        messageDict[GYHDDataBaseCenterMessageCode] = [NSString stringWithFormat:@"%ld",GYHDDataBaseCenterMessageTypeHuSheng];
//        messageDict[GYHDDataBaseCenterMessageCard] =[NSString stringWithFormat:@"%ld",GYHDDataBaseCenterMessageTypeHuSheng];
//        break;
//    }
//#pragma mark -- 订单消息
//    case GYHDDataBaseCenterPush1010202:          //消费者个人消息 ----- 业务消息(小类)订单消息 -----订单支付成功
//    case GYHDDataBaseCenterPush1010203:          //消费者个人消息 ----- 业务消息(小类)订单消息 -----确认收货
//    case GYHDDataBaseCenterPush1010204:          //消费者个人消息 ----- 业务消息(小类)订单消息 -----待自提
//    case GYHDDataBaseCenterPush1010205:          //消费者个人消息 ----- 业务消息(小类)订单消息 -----取消订单
//    case GYHDDataBaseCenterPush1010206:          //消费者个人消息 ----- 业务消息(小类)订单消息 -----退款完成【订单取消】
//    case GYHDDataBaseCenterPush1010207:          //消费者个人消息 ----- 业务消息(小类)订单消息 -----退款完成【售后】
//    case GYHDDataBaseCenterPush1010212:          //消费者个人消息 ----- 订单消息 企业备货中
//    case GYHDDataBaseCenterPush1010213:          //消费者个人消息 ----- 订单消息 买家申请取消订单
//
//    case GYHDDataBaseCenterPush1010214:          //餐饮订单消息 -----店内订单确认
//    case GYHDDataBaseCenterPush1010215:          //餐饮订单消息 -----接单
//    case GYHDDataBaseCenterPush1010216:          //餐饮订单消息 -----拒接
//    case GYHDDataBaseCenterPush1010217:          //餐饮订单消息 -----送餐
//    case GYHDDataBaseCenterPush1010218:          //餐饮订单消息 -----打印预结单
//    case GYHDDataBaseCenterPush1010219:          //餐饮订单消息 -----商家取消预定
//    case GYHDDataBaseCenterPush1010220:          //餐饮订单消息 -----商家确认取消
//    case GYHDDataBaseCenterPush1010221:          //餐饮订单消息 -----店内订单定金支付成功
//    case GYHDDataBaseCenterPush1010222:          //餐饮订单消息 -----店内订单付款成功: //订单消息
//    {
//        messageDict[GYHDDataBaseCenterMessageCode] = [NSString stringWithFormat:@"%ld",GYHDDataBaseCenterMessageTypeDingDan];
//        messageDict[GYHDDataBaseCenterMessageCard] =[NSString stringWithFormat:@"%ld",GYHDDataBaseCenterMessageTypeDingDan];
//
//        break;
//    }
//#pragma mark -- 订阅消息
//    case GYHDDataBaseCenterPush10201:           //企业商品降价消息（企业-->系统-->消费者）
//    case GYHDDataBaseCenterPush10202:           //企业商品下架、无货等消息（企业-->系统-->消费者）
//    case GYHDDataBaseCenterPush10203:           //企业商品上新消息（企业-->系统-->消费者）
//    case GYHDDataBaseCenterPush10204:            //企业的活动消息（企业-->系统-->消费者）
//    {
//        messageDict[GYHDDataBaseCenterMessageCode] = [NSString stringWithFormat:@"%ld",GYHDDataBaseCenterMessageTypeDingYue];
//        messageDict[GYHDDataBaseCenterMessageCard] =[NSString stringWithFormat:@"%ld",GYHDDataBaseCenterMessageTypeDingYue];
//        break;
//    }
//        // 及时聊天消息
//    case GYHDDataBaseCenterPush10101:            //消费者个人消息 ----- 互生消息
//    {
//        switch ([bodyDict[@"msg_code"]integerValue]) {
//            case 101:
//            {
//                messageDict[GYHDDataBaseCenterMessageCode] = [NSString stringWithFormat:@"%ld",GYHDDataBaseCenterMessageTypeHuSheng];
//                messageDict[GYHDDataBaseCenterMessageCard] =[NSString stringWithFormat:@"%ld",GYHDDataBaseCenterMessageTypeHuSheng];
//                break;
//            }
//            case GYHDDataBaseCenterMessageChatText:     //文本消息
//            case GYHDDataBaseCenterMessageChatPicture:  //图片消息
//            case GYHDDataBaseCenterMessageChatAudio:    //音频消息
//            case GYHDDataBaseCenterMessageChatVideo:    //视频消息
//            {
//                break;
//            }
//            default:
//                break;
//        }
//        break;
//    }
//
//    case 2: //服务消息
//        messageDict[GYHDDataBaseCenterMessageCode] = @(GYHDDataBaseCenterMessageTypeFuWu);
//        break;
//    default:
//        break;
//}
//            case :{
//                break;
//                    PushMsgNotify *push = [PushMsgNotify parseFromData:bodyData];
////                NSLog(@"fromuid = %llu, serverid = %u, msgtype = %u, toid = %lld,msgid = %lld, devicetype = %u msgtime = %lld",push.fromuid,(unsigned int)push.serverid,(unsigned int)push.msgtype, push.toid, push.msgid,(unsigned int)push.devicetype,push.msgtime);
//                NSDictionary*contentStr=[NSJSONSerialization JSONObjectWithData:push.content options:NSJSONReadingMutableContainers error:nil];
//                NSMutableDictionary *pushMessageDict = [NSMutableDictionary dictionary];
//                NSString *sendTime = contentStr[@"time"];
//                NSString *sendDateString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",
//                                            [sendTime substringWithRange:NSMakeRange(0, 4)],
//                                            [sendTime substringWithRange:NSMakeRange(4, 2)],
//                                            [sendTime substringWithRange:NSMakeRange(6, 2)],
//                                            [sendTime substringWithRange:NSMakeRange(8, 2)],
//                                            [sendTime substringWithRange:NSMakeRange(10, 2)],
//                                            [sendTime substringWithRange:NSMakeRange(12, 2)]];
//                NSDate *nowdata = [NSDate date];
//                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//                NSString *recvDateString = [formatter stringFromDate:nowdata];
//                NSDictionary *bodyDict = contentStr[@"content"];
//
//                pushMessageDict[GYHDDataBaseCenterMessageID]            = [NSString stringWithFormat:@"%lld",push.msgid];
//                pushMessageDict[GYHDDataBaseCenterMessageFromID]        = [NSString stringWithFormat:@"%lld",push.fromuid];
//                pushMessageDict[GYHDDataBaseCenterMessageToID]          = [NSString stringWithFormat:@"%lld",push.toid];
//                pushMessageDict[GYHDDataBaseCenterMessageContent]       = bodyDict[@"msg_content"];
//                pushMessageDict[GYHDDataBaseCenterMessageFriendType]    = @"-1";
//                pushMessageDict[GYHDDataBaseCenterMessageBody]          = [GYUtils dictionaryToString:contentStr];
//                pushMessageDict[GYHDDataBaseCenterMessageCode]          = [NSString stringWithFormat:@"%d",push.serverid];
//                pushMessageDict[GYHDDataBaseCenterMessageSendTime]      = sendDateString;
//                pushMessageDict[GYHDDataBaseCenterMessageRevieTime]     = recvDateString;
//                pushMessageDict[GYHDDataBaseCenterMessageIsSelf]        = @(0);
//                pushMessageDict[GYHDDataBaseCenterMessageIsRead]        = @(1);
//                pushMessageDict[GYHDDataBaseCenterMessageSentState]     = @(GYHDDataBaseCenterMessageSentStateSuccess);
//                pushMessageDict[GYHDDataBaseCenterMessageCard]          = [NSString stringWithFormat:@"%d",push.serverid];
//                pushMessageDict[GYHDDataBaseCenterMessageData]          = [protobuf base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//                if ( [[GYHDDataBaseCenter sharedInstance] saveMessageWithDict:pushMessageDict]){
//                    [self postDataBaseChangeNotificationWithDict:pushMessageDict];
//                    AudioServicesPlaySystemSound(1016);
//                }
//                    break;
//                }
//                    NSDictionary*contentDict=[NSJSONSerialization JSONObjectWithData:push.content options:NSJSONReadingMutableContainers error:nil];
//                    NSMutableDictionary *pushMessageDict = [NSMutableDictionary dictionary];
//                    NSString *sendTime = contentDict[@"time"];
//                    NSString *sendDateString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",
//                                                [sendTime substringWithRange:NSMakeRange(0, 4)],
//                                                [sendTime substringWithRange:NSMakeRange(4, 2)],
//                                                [sendTime substringWithRange:NSMakeRange(6, 2)],
//                                                [sendTime substringWithRange:NSMakeRange(8, 2)],
//                                                [sendTime substringWithRange:NSMakeRange(10, 2)],
//                                                [sendTime substringWithRange:NSMakeRange(12, 2)]];
//                    NSDate *nowdata = [NSDate date];
//                    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//                    NSString *recvDateString = [formatter stringFromDate:nowdata];
//                    NSDictionary *bodyDict = contentDict[@"content"];
//                    pushMessageDict[GYHDDataBaseCenterPushMessageID]            = [NSString stringWithFormat:@"%lld",push.msgid];
//                    pushMessageDict[GYHDDataBaseCenterPushMessagePlantFromID]   = [NSString stringWithFormat:@"%d",push.serverid];
//                    pushMessageDict[GYHDDataBaseCenterPushMessageFromID]        = [NSString stringWithFormat:@"%lld",push.fromuid];
//                    pushMessageDict[GYHDDataBaseCenterPushMessageToID]          = [NSString stringWithFormat:@"%lld",push.toid];
//                    pushMessageDict[GYHDDataBaseCenterPushMessageContent]       = bodyDict[@"msg_content"];
//                    pushMessageDict[GYHDDataBaseCenterPushMessageBody]       = [GYUtils dictionaryToString:bodyDict];
//                    pushMessageDict[GYHDDataBaseCenterPushMessageSendTime]      = sendDateString;
//                    pushMessageDict[GYHDDataBaseCenterPushMessageRevieTime]     = recvDateString;
//                    pushMessageDict[GYHDDataBaseCenterPushMessageIsRead]        =@(1);
//- (NSArray <NSDictionary *> *)selectGroupMessage {
//    return [[GYHDDataBaseCenter sharedInstance] selectGroupMessage];
//}
/**更新好友信息*/
//- (void)updateFriendBaseWithDict:(NSDictionary *)dict {
//    return [[GYHDDataBaseCenter sharedInstance] updateFriendBaseWithDict:dict];
//}
//- (NSArray *)getFriendDetailWithAccountID:(NSString *)accountID RequetResult:(RequetResultWithArray)handler {
//    __weak typeof(self) weakSelf = self;
//    [self.netWorkTool getFriendDetailWithAccountID:accountID RequetResult:^(NSDictionary *dict) {
//        if (!dict) return;
//        handler([weakSelf FriendarrayWithDict:dict]);
//
//        [[GYHDDataBaseCenter sharedInstance] updateFriendDetailWithDict:dict];
//    }];
//    NSDictionary *dict = [[GYHDDataBaseCenter sharedInstance] selectFriendDetailWithAccountID:accountID];
//    return [self FriendarrayWithDict:dict];
//
//}
//1. 从网络获取数据
//    if (isNetwork) {
//        [self.netWorkTool getFriendListRequetResult:^(NSArray *arry) {
//            if (handler) {
//                handler(arry);
//            }
//
//            if (!arry) return;
//            for (NSDictionary *dict in arry) {
//                NSMutableDictionary *friendDict = [NSMutableDictionary dictionary];
//                friendDict[GYHDDataBaseCenterFriendFriendID]       = dict[@"accountId"];
//                friendDict[GYHDDataBaseCenterFriendCustID]         = dict[@"custId"];
//                NSString *custID = dict[@"custId"];
//                if (custID.length > 11) {
//                    friendDict[GYHDDataBaseCenterFriendResourceID] = [custID substringToIndex:11];
//                }else {
//                    friendDict[GYHDDataBaseCenterFriendResourceID] = custID;
//                }
//
//                NSString *name = nil;
//                if (dict[@"remark"] && ![dict[@"remark"] isEqual:[NSNull class]] && dict[@"remark"] != nil && ![dict[@"remark"] isEqualToString:@""]) {
//                    name = dict[@"remark"];
//                } else {
//                    name = dict[@"nickname"];
//                }
//                friendDict[GYHDDataBaseCenterFriendName] = name;
//
//
//                if ([ dict[@"headPic"] hasPrefix:@"http://"]) {
//                    friendDict[GYHDDataBaseCenterFriendIcon] = dict[@"headPic"];
//                }else {
//                    friendDict[GYHDDataBaseCenterFriendIcon] = [NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl, dict[@"headPic"]];
//                }
//                friendDict[GYHDDataBaseCenterFriendUsetType] = @"c";
//                friendDict[GYHDDataBaseCenterFriendMessageType] = GYHDDataBaseCenterFriends;
//                friendDict[GYHDDataBaseCenterFriendMessageTop] = @"-1";
//                friendDict[GYHDDataBaseCenterFriendInfoTeamID] = dict[@"teamId"];
//                friendDict[GYHDDataBaseCenterFriendTeamFriendSet] = dict[@"teamIdFreindSet"];
//                friendDict[GYHDDataBaseCenterFriendSign] = dict[@"sign"];
//                friendDict[GYHDDataBaseCenterFriendBasic] = [GYUtils dictionaryToString:dict];
//                friendDict[GYHDDataBaseCenterFriendDetailed] = [GYUtils dictionaryToString:dict];
//                [[GYHDDataBaseCenter sharedInstance] deleteWithMessage: friendDict[GYHDDataBaseCenterFriendCustID]  fieldName:GYHDDataBaseCenterFriendCustID TableName:GYHDDataBaseCenterFriendTableName];
//
//                [[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:friendDict TableName:GYHDDataBaseCenterFriendTableName];
//            }
//        }];
//    }