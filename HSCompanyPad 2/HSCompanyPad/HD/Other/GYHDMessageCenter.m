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
#import "GYHDUtils.h"
#import "GYHDNetWorkTool.h"
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
NSString * const GYHDDataBaseCenterPushMessageDelete        = @"PUSH_MSG_Delete";  // 推送消息删除

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
NSString * const GYHDDataBaseCenterMessageIsRight        = @"MSG_IsRight";
NSString * const GYHDDataBaseCenterMessageIsRead        = @"MSG_Read";  //消息读取
NSString * const GYHDDataBaseCenterMessageSendState     = @"MSG_State";
NSString * const GYHDDataBaseCenterMessageCard          = @"MSG_Card";
NSString * const GYHDDataBaseCenterMessageData          = @"MSG_DataString";
NSString * const GYHDDataBaseCenterMessageUserState     = @"MSG_UserState";
/**聊天类型 和 @"MSG_Type" 却别在于 此这个是新的， @“MSG_type” 弃用*/
NSString * const GYHDDataBaseCenterMessageChatType     = @"MSG_ChatType";
NSString * const GYHDDataBaseCenterMessageFileBasePath     = @"MSG_FileBasePath";
NSString * const GYHDDataBaseCenterMessageFileDetailPath     = @"MSG_FileDetailPath";
NSString * const GYHDDataBaseCenterMessageNetWorkBasePath  = @"MSG_NetWorkBasePath";
NSString * const GYHDDataBaseCenterMessageNetWorkDetailPath  = @"MSG_NetWorkDetailPath";
NSString * const GYHDDataBaseCenterMessageFileRead  = @"MSG_FileRead";  // 文件读取
NSString * const GYHDDataBaseCenterMessageDelete  = @"MSG_Delete";  // 聊天消息删除
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
NSString * const GYHDDataBaseCenterFriendSessionID      = @"Friend_SessionID";
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


/**快捷回复*/
NSString * const GYHDDataBaseCenterQuickReplyTableName = @"T_QUICKREPLY";
NSString * const GYHDDataBaseCenterQuickReplyID             = @"ID";
NSString * const GYHDDataBaseCenterQuickReplyTitle          = @"Reply_Title";
NSString * const GYHDDataBaseCenterQuickReplyCreateTimeStr  = @"Reply_CreateTimeStr";
NSString * const GYHDDataBaseCenterQuickReplyUpdateTimeStr  = @"Reply_UpdateTimeStr";
NSString * const GYHDDataBaseCenterQuickReplyContent        = @"Reply_Content";
NSString * const GYHDDataBaseCenterQuickReplyMsgId          = @"Reply_MsgId";
NSString * const GYHDDataBaseCenterQuickReplyIsDefault      = @"Reply_IsDefault";
NSString * const GYHDDataBaseCenterQuickReplyCustId         = @"Reply_CustId";

// 聊天消息 通知
NSString * const GYHDMessageCenterDataBaseChageNotification = @"com.hsec.database.change";
// 主界面切换tabbar下表通知
NSString * const GYHDHDMainChageTabBarIndexNotification     =@"tabarIndex";
//推送消息通知
NSString * const GYHDPushMessageChageNotification           =@"pushMessage";

//其他地方登录消息通知
NSString * const GYHDOtherLoginNotification
    =@"otherLogin";


@interface GYHDMessageCenter ()
@property(nonatomic ,strong) GYHDNetWorkTool *netWorkTool;
@end

@implementation GYHDMessageCenter

static id instance;

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
        
    });
    return instance;
}

- (void)setDeviceToken:(NSString *)deviceToken {
    _deviceToken = [NSString stringWithFormat:@"%d_%@",kIMCompanyPad,deviceToken];
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (GYHDNetWorkTool *)netWorkTool {
    if (!_netWorkTool) {
        _netWorkTool = [GYHDNetWorkTool sharedInstance];
    }
    return _netWorkTool;
}
- (void)updateSendingState
{
    //查询发送数据状态
   NSArray *sendArray = [[GYHDDataBaseCenter sharedInstance] selectSendState:GYHDDataBaseCenterMessageSendStateSending];
    
    for (NSDictionary *dict in sendArray) {
    
        //    获取消息id更新消息发送状态
        NSString *msgID = dict[@"MSG_ID"];
        
        [[GYHDDataBaseCenter sharedInstance] updateMessageStateWithMessageID:msgID State:GYHDDataBaseCenterMessageSendStateFailure];
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    return instance;
}
//1. 解析即时聊天数据
- (void)ReceiveMessageModel:(GYHDReceiveMessageModel *)model
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if ([model.messageType isEqualToString:@"20"]) {
            
            NSString *fromJID =model.fromid;
            NSString *messageId = model.sendtime;
            NSString *toID=model.toid;
            NSString *sessionid=model.sessionid;// 会话id（只存在于客服对话）
            NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
            
            messageDict[GYHDDataBaseCenterMessageID] = messageId;
            messageDict[GYHDDataBaseCenterMessageFromID] = fromJID;
            messageDict[GYHDDataBaseCenterMessageToID] = toID;
            messageDict[GYHDDataBaseCenterMessageChatType] =model.messageType;
            messageDict[GYHDDataBaseCenterMessageContent] =model.content;
            
            NSString *pattern = @"\\d+";
            NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
            // 2.测试字符串
            NSArray *results = [regex matchesInString:fromJID options:0 range:NSMakeRange(0,fromJID.length)];
            // 3.遍历结果
            NSTextCheckingResult *result =  [results firstObject];
            messageDict[GYHDDataBaseCenterMessageCard] = [fromJID substringWithRange:result.range];
            
            NSDate *sendData = [[NSDate alloc] initWithTimeIntervalSince1970:messageId.longLongValue / 1000];;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *sendDateString = [formatter stringFromDate:sendData];
            NSString *recvDateString = [formatter stringFromDate:[NSDate date]];
            messageDict[GYHDDataBaseCenterMessageSendTime] = sendDateString;
            messageDict[GYHDDataBaseCenterMessageRevieTime] = recvDateString;
            messageDict[GYHDDataBaseCenterMessageIsRight]    = @(0);
            messageDict[GYHDDataBaseCenterMessageIsRead]    = @(1);
            messageDict[GYHDDataBaseCenterMessageSendState] = @(GYHDDataBaseCenterMessageSendStateSuccess);
            
            if ([fromJID hasPrefix:@"m_c_"]||[fromJID hasPrefix:@"w_c_"] || [fromJID hasPrefix:@"m_nc_"]||[fromJID hasPrefix:@"w_nc_"] || [fromJID hasPrefix:@"p_c_"]) {
                messageDict[GYHDDataBaseCenterMessageUserState] = @"c";
            }
            if ([fromJID hasPrefix:@"m_e_"]||[fromJID hasPrefix:@"w_e_"]||[fromJID hasPrefix:@"p_e_"]){
                
                messageDict[GYHDDataBaseCenterMessageUserState] = @"e";
            }
            
            NSDictionary *dict =  [[GYHDDataBaseCenter sharedInstance] selectfriendBaseWithCardStr:messageDict[GYHDDataBaseCenterMessageCard]];
            
            NSMutableDictionary *friendDict = [NSMutableDictionary dictionary];
            
            friendDict[GYHDDataBaseCenterFriendFriendID]       = fromJID;
            
            friendDict[GYHDDataBaseCenterFriendSessionID]      = sessionid;
            
            friendDict[GYHDDataBaseCenterFriendCustID]         =  messageDict[GYHDDataBaseCenterMessageCard];
            friendDict[GYHDDataBaseCenterFriendName]           = model.name;
            friendDict[GYHDDataBaseCenterFriendIcon]           = model.icon;
            
            if ([fromJID containsString:@"nc"]) {
                friendDict[GYHDDataBaseCenterFriendUsetType]       = [fromJID substringWithRange:NSMakeRange(2, 2)];
            }else{
                
                friendDict[GYHDDataBaseCenterFriendUsetType]       = [fromJID substringWithRange:NSMakeRange(2, 1)];
            }
            
            friendDict[GYHDDataBaseCenterFriendMessageTop]     = @"-1";
            
            if ([dict allKeys].count <=0) {
                
                [[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:friendDict TableName:GYHDDataBaseCenterFriendTableName];
                
            } else {
                
                NSMutableDictionary *conditionDict = [NSMutableDictionary dictionary];
                conditionDict[GYHDDataBaseCenterFriendCustID] =   messageDict[GYHDDataBaseCenterMessageCard];
                
                NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
                updateDict[GYHDDataBaseCenterFriendName]           = model.name;
                updateDict[GYHDDataBaseCenterFriendIcon]           = model.icon;
                updateDict[GYHDDataBaseCenterFriendSessionID]      = sessionid;
                
                [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterFriendTableName];
            }
            
            if ( [[GYHDDataBaseCenter sharedInstance] saveMessageWithDict:messageDict]){
                [self postDataBaseChangeNotificationWithDict:messageDict];
                
                //声音提示
                AudioServicesPlaySystemSound(1007);
//                
//                NSArray *pushArray = [[NSUserDefaults standardUserDefaults]objectForKey:globalData.loginModel.custId];
//                
//                if (pushArray.count==4) {
//                    
//                    if ([pushArray[0]isEqualToNumber:@1]) {
//                        
//                        //全天不提示消息
//                    }
//                    
//                    else if ([pushArray[1]isEqualToNumber:@1]) {
//                        //夜间不提示消息,白天提示消息
//                        
//                        if ([GYHDUtils isBetweenFromHour:8 toHour:22]) {
//                            //                        免打扰不提示
//                            
//                        }
//                    }
//                    
//                    else if ([pushArray[0]isEqualToNumber:@0]) {
//                        //默认全天提示消息
//                        
//                        if ([pushArray[3]isEqualToNumber:@1]) {
//                            
//                            //震动提示
//                            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//                            
//                        }
//                        if ([pushArray[2]isEqualToNumber:@1]){
//                            //声音提示
//                            AudioServicesPlaySystemSound(1007);
//                        }
//                    }
//                    
//                    else if ([pushArray[1]isEqualToNumber:@0]) {
//                        //默认夜间提示消息
//                        
//                        if ([pushArray[3]isEqualToNumber:@1]) {
//                            
//                            //震动提示
//                            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//                            
//                        }
//                        if ([pushArray[2]isEqualToNumber:@1]){
//                            //声音提示
//                            AudioServicesPlaySystemSound(1007);
//                        }
//                    }
//                    
//                }
                
            }
            
            return ;
        }
        
        NSString *body =model.content;
        NSString *fromJID =model.fromid;
        NSString *messageId = model.sendtime;
        NSString *toID=model.toid;
        NSString *sessionid=model.sessionid;// 会话id（只存在于客服对话）
        NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
        NSMutableDictionary *bodyDict = [NSMutableDictionary
                                         dictionaryWithDictionary:[GYHDUtils stringToDictionaryEscapseHtml:body]];
        [GYHDUtils checkDict:bodyDict];
        messageDict[GYHDDataBaseCenterMessageID] = messageId;
        messageDict[GYHDDataBaseCenterMessageFromID] = fromJID;
        messageDict[GYHDDataBaseCenterMessageToID] = toID;
        messageDict[GYHDDataBaseCenterMessageBody] = [GYHDUtils dictionaryToString:bodyDict];
        messageDict[GYHDDataBaseCenterMessageChatType] = bodyDict[@"msg_code"];
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
                    messageDict[GYHDDataBaseCenterMessageContent] = kLocalized(@"GYHD_Picture");
                    messageDict[GYHDDataBaseCenterMessageNetWorkBasePath] = bodyDict[@"msg_imageNailsUrl"];
                    messageDict[GYHDDataBaseCenterMessageNetWorkDetailPath]=bodyDict[@"msg_content"];
                }
                NSString *pattern = @"\\d+";
                NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
                // 2.测试字符串
                NSArray *results = [regex matchesInString:fromJID options:0 range:NSMakeRange(0,fromJID.length)];
                // 3.遍历结果
                NSTextCheckingResult *result =  [results firstObject];
                messageDict[GYHDDataBaseCenterMessageCard] = [fromJID substringWithRange:result.range];
                
                break;
            }
            case GYHDDataBaseCenterMessageChatGoods:
            case GYHDDataBaseCenterMessageChatOrder://关联商品
            {
                
                messageDict[GYHDDataBaseCenterMessageCode] = @([bodyDict[@"msg_code"] integerValue]);
                
                if ([bodyDict[@"msg_code"] integerValue] ==
                    GYHDDataBaseCenterMessageChatGoods) {
                    messageDict[GYHDDataBaseCenterMessageContent] =
                    kLocalized(@"GYHD_GoodsMessage");
                    
                } else {
                    messageDict[GYHDDataBaseCenterMessageContent] = kLocalized(@"GYHD_OrderMessage");
                    
                }
                NSString *pattern = @"\\d+";
                NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
                // 2.测试字符串
                NSArray *results = [regex matchesInString:fromJID options:0 range:NSMakeRange(0,fromJID.length)];
                // 3.遍历结果
                NSTextCheckingResult *result =  [results firstObject];
                messageDict[GYHDDataBaseCenterMessageCard] = [fromJID substringWithRange:result.range];
                
            }break;
                
            case GYHDDataBaseCenterMessageChatMap:
            {
                
                messageDict[GYHDDataBaseCenterMessageCode] = @([bodyDict[@"msg_code"] integerValue]);
                messageDict[GYHDDataBaseCenterMessageContent] = kLocalized(@"GYHD_Location");
                NSString *pattern = @"\\d+";
                NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
                // 2.测试字符串
                NSArray *results = [regex matchesInString:fromJID options:0 range:NSMakeRange(0,fromJID.length)];
                // 3.遍历结果
                NSTextCheckingResult *result =  [results firstObject];
                messageDict[GYHDDataBaseCenterMessageCard] = [fromJID substringWithRange:result.range];
                
            }break;
                
            case GYHDDataBaseCenterMessageChatAudio:    //音频消息
            {
                messageDict[GYHDDataBaseCenterMessageContent] = kLocalized(@"GYHD_Audio");
                
                messageDict[GYHDDataBaseCenterMessageCode] = @(GYHDDataBaseCenterMessageTypeChat);
                NSString *pattern = @"\\d+";
                NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
                // 2.测试字符串
                NSArray *results = [regex matchesInString:fromJID options:0 range:NSMakeRange(0,fromJID.length)];
                // 3.遍历结果
                NSTextCheckingResult *result =  [results firstObject];
                messageDict[GYHDDataBaseCenterMessageCard] = [fromJID substringWithRange:result.range];
                
                NSString *timeNumber = [NSString stringWithFormat:@"%u_%d", arc4random_uniform(1000), (int)[[NSDate date] timeIntervalSince1970]];
                NSString *mp3Name = [NSString stringWithFormat:@"audio%@.mp3", timeNumber];
                NSString *mp3Path = [NSString pathWithComponents:@[[GYHDUtils mp3folderNameString], mp3Name]];
                [self.netWorkTool downloadDataWithUrlString:[[GYHDMessageCenter sharedInstance]appendAuthenticationStr:bodyDict[@"msg_content"]] filePath:mp3Path];
                
                NSMutableDictionary *saveDict = [NSMutableDictionary dictionary];
                saveDict[@"mp3"] = mp3Name;
                saveDict[@"mp3Len"] = bodyDict[@"msg_fileSize"];
                saveDict[@"read"]= @"0";
                messageDict[GYHDDataBaseCenterMessageData] = [GYHDUtils dictionaryToString:saveDict];
                
                messageDict[GYHDDataBaseCenterMessageNetWorkDetailPath] = bodyDict[@"msg_content"];
                messageDict[GYHDDataBaseCenterMessageNetWorkBasePath] = bodyDict[@"msg_fileSize"];
                messageDict[GYHDDataBaseCenterMessageFileDetailPath] = mp3Name;
                messageDict[GYHDDataBaseCenterMessageFileBasePath] = bodyDict[@"msg_fileSize"];
                messageDict[GYHDDataBaseCenterMessageFileRead] = @"0";
                
                break;
            }
                
            case GYHDDataBaseCenterMessageChatVideo:    //视频消息
            {
                messageDict[GYHDDataBaseCenterMessageContent] = kLocalized(@"GYHD_Video");
                
                messageDict[GYHDDataBaseCenterMessageCode] = @(GYHDDataBaseCenterMessageTypeChat);
                NSString *pattern = @"\\d+";
                NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
                // 2.测试字符串
                NSArray *results = [regex matchesInString:fromJID options:0 range:NSMakeRange(0,fromJID.length)];
                // 3.遍历结果
                NSTextCheckingResult *result =  [results firstObject];
                
                messageDict[GYHDDataBaseCenterMessageCard] = [fromJID substringWithRange:result.range];
                NSString *timeNumber = [NSString stringWithFormat:@"%u_%d", arc4random_uniform(1000), (int)[[NSDate date] timeIntervalSince1970]];
                NSString *mp4Name = [NSString stringWithFormat:@"video%@.mp4",timeNumber];
                NSString *filePath = [NSString pathWithComponents:@[[GYHDUtils mp4folderNameString],mp4Name]];
                [self.netWorkTool downloadDataWithUrlString:[[GYHDMessageCenter sharedInstance]appendAuthenticationStr:bodyDict[@"msg_content"]] filePath:filePath];
                
                NSMutableDictionary *saveDict = [NSMutableDictionary dictionary];
                saveDict[@"mp4Name"] = mp4Name;
                saveDict[@"thumbnailsName"] = bodyDict[@"msg_imageNail"];
                saveDict[@"read"]= @"0";
                messageDict[GYHDDataBaseCenterMessageData] = [GYHDUtils dictionaryToString:saveDict];
                
                messageDict[GYHDDataBaseCenterMessageNetWorkBasePath] = bodyDict[@"msg_imageNail"];
                messageDict[GYHDDataBaseCenterMessageNetWorkDetailPath] = bodyDict[@"msg_content"];
                messageDict[GYHDDataBaseCenterMessageFileDetailPath] = mp4Name;
                messageDict[GYHDDataBaseCenterMessageFileRead] = @"0";
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
        messageDict[GYHDDataBaseCenterMessageIsRight]    = @(0);
        messageDict[GYHDDataBaseCenterMessageIsRead]    = @(1);
        messageDict[GYHDDataBaseCenterMessageSendState] = @(GYHDDataBaseCenterMessageSendStateSuccess);
        
        if ([fromJID hasPrefix:@"m_c_"]||[fromJID hasPrefix:@"w_c_"] || [fromJID hasPrefix:@"m_nc_"]||[fromJID hasPrefix:@"w_nc_"]) {
            messageDict[GYHDDataBaseCenterMessageUserState] = @"c";
        }
        if ([fromJID hasPrefix:@"m_e_"]||[fromJID hasPrefix:@"w_e_"]||[fromJID hasPrefix:@"p_e_"]){
            
            messageDict[GYHDDataBaseCenterMessageUserState] = @"e";
        }
        
        NSDictionary *dict =  [[GYHDDataBaseCenter sharedInstance] selectfriendBaseWithCardStr:messageDict[GYHDDataBaseCenterMessageCard]];
        
        NSMutableDictionary *friendDict = [NSMutableDictionary dictionary];
        
        friendDict[GYHDDataBaseCenterFriendFriendID]       = fromJID;
        
        friendDict[GYHDDataBaseCenterFriendSessionID]      = sessionid;
        
        friendDict[GYHDDataBaseCenterFriendCustID]         =  messageDict[GYHDDataBaseCenterMessageCard];
        friendDict[GYHDDataBaseCenterFriendName]           = bodyDict[@"msg_note"];
        friendDict[GYHDDataBaseCenterFriendIcon]           = bodyDict[@"msg_icon"];
        if ([fromJID containsString:@"nc"]) {
            friendDict[GYHDDataBaseCenterFriendUsetType]       = [fromJID substringWithRange:NSMakeRange(2, 2)];
        }else{
            
            friendDict[GYHDDataBaseCenterFriendUsetType]       = [fromJID substringWithRange:NSMakeRange(2, 1)];
        }
        
        friendDict[GYHDDataBaseCenterFriendMessageTop]     = @"-1";
        friendDict[GYHDDataBaseCenterFriendBasic]          = [GYHDUtils dictionaryToString:bodyDict];
        
        friendDict[GYHDDataBaseCenterFriendDetailed ] = [GYHDUtils dictionaryToString:bodyDict];
        
        
        if ([dict allKeys].count <=0) {
            
            [[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:friendDict TableName:GYHDDataBaseCenterFriendTableName];
            
        } else {
            
            NSMutableDictionary *conditionDict = [NSMutableDictionary dictionary];
            conditionDict[GYHDDataBaseCenterFriendCustID] =   messageDict[GYHDDataBaseCenterMessageCard];
            
            NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
            updateDict[GYHDDataBaseCenterFriendName]           = bodyDict[@"msg_note"];
            updateDict[GYHDDataBaseCenterFriendIcon]           = bodyDict[@"msg_icon"];
            updateDict[GYHDDataBaseCenterFriendSessionID]      = sessionid;
            
            [[GYHDDataBaseCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterFriendTableName];
            
            
        }
        
        if ( [[GYHDDataBaseCenter sharedInstance] saveMessageWithDict:messageDict]){
            [self postDataBaseChangeNotificationWithDict:messageDict];
            
            //声音提示
            AudioServicesPlaySystemSound(1007);
            
//            NSArray *pushArray = [[NSUserDefaults standardUserDefaults]objectForKey:globalData.loginModel.custId];
            
//            if (pushArray.count==4) {
//                
//                if ([pushArray[0]isEqualToNumber:@1]) {
//                    
//                    //全天不提示消息
//                }
//                
//                else if ([pushArray[1]isEqualToNumber:@1]) {
//                    //夜间不提示消息,白天提示消息
//                    
//                    if ([GYHDUtils isBetweenFromHour:8 toHour:22]) {
//                        //                        免打扰不提示
//                        
//                    }
//                }
//                
//                else if ([pushArray[0]isEqualToNumber:@0]) {
//                    //默认全天提示消息
//                    
//                    if ([pushArray[3]isEqualToNumber:@1]) {
//                        
//                        //震动提示
//                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//                        
//                    }
//                    if ([pushArray[2]isEqualToNumber:@1]){
//                        //声音提示
//                        AudioServicesPlaySystemSound(1007);
//                    }
//                }
//                
//                else if ([pushArray[1]isEqualToNumber:@0]) {
//                    //默认夜间提示消息
//                    
//                    if ([pushArray[3]isEqualToNumber:@1]) {
//                        
//                        //震动提示
//                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//                        
//                    }
//                    if ([pushArray[2]isEqualToNumber:@1]){
//                        //声音提示
//                        AudioServicesPlaySystemSound(1007);
//                    }
//                }
//                
//            }
            
        }
        
    });
}

#pragma mark- 解析在线推送消息
/**
 * 接收在线平台推送消息
 */
- (void)receivePushMsg:(GYHDPushMsgModel *)model{
    
    NSDictionary*contentDict=[GYHDUtils stringToDictionary:model.content]
    ;
    NSMutableDictionary *pushMessageDict = [NSMutableDictionary dictionary];
    
    NSString* sendTime = contentDict[@"time"];
    
    NSString *sendDateString = [NSString
                                stringWithFormat:
                                @"%@-%@-%@ %@:%@:%@",
                                [sendTime substringWithRange:NSMakeRange(0, 4)],
                                [sendTime substringWithRange:NSMakeRange(4, 2)],
                                [sendTime substringWithRange:NSMakeRange(6, 2)],
                                [sendTime substringWithRange:NSMakeRange(8, 2)],
                                [sendTime substringWithRange:NSMakeRange(10, 2)],
                                [sendTime substringWithRange:NSMakeRange(12, 2)]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSDate *nowdata = [NSDate date];

    NSString *recvDateString = [formatter stringFromDate:nowdata];
    NSDictionary *bodyDict = contentDict[@"content"];
    
    pushMessageDict[GYHDDataBaseCenterPushMessageCode]          = [NSString stringWithFormat:@"%ld",[model.msgtype integerValue]];
    pushMessageDict[GYHDDataBaseCenterPushMessageID]            =model.msgid;
    
    pushMessageDict[GYHDDataBaseCenterPushMessageFromID]        = model.fromid;
    
    pushMessageDict[GYHDDataBaseCenterPushMessageToID]          = [NSString stringWithFormat:@"%lld",globalData.loginModel.custId.longLongValue];
    pushMessageDict[GYHDDataBaseCenterPushMessageContent]       = bodyDict[@"msg_content"];
    
    pushMessageDict[GYHDDataBaseCenterPushMessageBody]       = [GYHDUtils dictionaryToString:bodyDict];
    pushMessageDict[GYHDDataBaseCenterPushMessageSendTime]      = sendDateString;
    pushMessageDict[GYHDDataBaseCenterPushMessageRevieTime]     = recvDateString;
    pushMessageDict[GYHDDataBaseCenterPushMessageIsRead]        =@(1);
    
    //    屏蔽不该收到的消息类型
    /*
     互生消息： '1001','1002','1003','1004','1005','02531','2533','2532','1011','1012','1013','1014','1015','1016'
     
     订单消息： '2501','2502','2503','2504','2505','2506','2507','2508','2509','2510','2511','2512','2513','2514','2514','2541','2542','2543','2544','2545','2546','2547'
     
     服务消息： '2801','2802','2803'
     */
    NSArray *msgTypeArr=@[@"01001",@"01002",@"01003",@"01004",@"01005",@"02531",@"02532",@"02533",@"01011",@"01012",@"01013",@"01014",@"01015",@"01016",@"02501",@"02502",@"02503",@"02504",@"02505",@"02506",@"02507",@"02508",@"02509",@"02510",@"02511",@"02512",@"02513",@"02514",@"02541",@"02542",@"02543",@"02544",@"02545",@"02546",@"02547",@"02801",@"02802",@"02803"];
    
    NSArray*hsMsgTypeArr=@[@"01001",@"01002",@"01003",@"01004",@"01005",@"02531",@"02532",@"02533",@"01011",@"01012",@"01013",@"01014",@"01015",@"01016"];
    NSArray*ddMsgTypeArr=@[@"02501",@"02502",@"02503",@"02504",@"02505",@"02506",@"02507",@"02508",@"02509",@"02510",@"02511",@"02512",@"02513",@"02514",@"02541",@"02542",@"02543",@"02544",@"02545",@"02546",@"02547"];
    
    NSArray*fuMsgTypeArr=@[@"02801",@"02802",@"02803"];
    
    for (NSString*msgType in hsMsgTypeArr) {
        
        if ([model.msgtype isEqualToString:msgType]) {
            
            pushMessageDict[GYHDDataBaseCenterPushMessageMainType] =@"1";//系统消息
            
            if ([msgType isEqualToString:@"01001"]||[msgType isEqualToString:@"01002"]||[msgType isEqualToString:@"01003"]||[msgType isEqualToString:@"01004"]||[msgType isEqualToString:@"01005"]) {

                id  msg_contentDic =bodyDict[@"msg_content"];
                
                if ([msg_contentDic isKindOfClass:[NSString class]]) {
                    
                    NSDictionary *dic = [GYHDUtils stringToDictionary:msg_contentDic];
                    
                    if ([dic isKindOfClass:[NSNull class]]||!dic) {
                        return;
                    }
                    
                    NSString *summary =dic[@"summary"];
                    pushMessageDict[GYHDDataBaseCenterPushMessageSummary] =
                    summary;
                    
                }else if ([msg_contentDic isKindOfClass:[NSDictionary class]]){
                
                
                    NSString *summary =msg_contentDic[@"summary"];
                    pushMessageDict[GYHDDataBaseCenterPushMessageSummary] =
                    summary;
                
                }
                
            }
            
        }
        
    }
    
    for (NSString*msgType in ddMsgTypeArr) {
        
        
        if ([model.msgtype isEqualToString:msgType]) {
            
            pushMessageDict[GYHDDataBaseCenterPushMessageMainType] =@"2";//订单消息
            
        }
        
    }
    
    for (NSString*msgType in fuMsgTypeArr) {
        
        
        if ([model.msgtype isEqualToString:msgType]) {
            
            pushMessageDict[GYHDDataBaseCenterPushMessageMainType] =@"3";//服务消息
            
        }
        
    }
    
    
    for (NSString*msgType in msgTypeArr) {
        
        if ([model.msgtype isEqualToString:msgType]) {

                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:GYHDPushMessageChageNotification object:nil];
                });
                
                [[GYHDDataBaseCenter sharedInstance] insertInfoWithDict:pushMessageDict TableName:GYHDDataBaseCenterPushMessageTableName];
            
            //声音提示
            AudioServicesPlaySystemSound(1007);
            
//                NSArray *pushArray = [[NSUserDefaults standardUserDefaults]objectForKey:globalData.loginModel.custId];

//                if (pushArray.count==4) {
//                    
//                    if ([pushArray[0]isEqualToNumber:@1]) {
//                        
//                        //全天不提示消息
//                    }
//                    
//                    else if ([pushArray[1]isEqualToNumber:@1]) {
//                        //夜间不提示消息,白天提示消息
//                        
//                        if ([GYHDUtils isBetweenFromHour:8 toHour:22]) {
//                            //                        免打扰不提示
//                            
//                        }
//                    }
//                    
//                    else if ([pushArray[0]isEqualToNumber:@0]) {
//                        //默认全天提示消息
//                        
//                        if ([pushArray[3]isEqualToNumber:@1]) {
//                            
//                            //震动提示
//                            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//                            
//                        }
//                        if ([pushArray[2]isEqualToNumber:@1]){
//                            //声音提示
//                            AudioServicesPlaySystemSound(1007);
//                        }
//                    }
//                    
//                    else if ([pushArray[1]isEqualToNumber:@0]) {
//                        //默认夜间提示消息
//                        
//                        if ([pushArray[3]isEqualToNumber:@1]) {
//                            
//                            //震动提示
//                            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//                            
//                        }
//                        if ([pushArray[2]isEqualToNumber:@1]){
//                            //声音提示
//                            AudioServicesPlaySystemSound(1007);
//                        }
//                    }
//                    
//                }
            
                
            }
            
        }
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
        NSDictionary *bodyDict =  [GYHDUtils stringToDictionary:dict[@"MSG_Body"]];
        NSDictionary *saveDict = [GYHDUtils stringToDictionary:dict[GYHDDataBaseCenterMessageData]];
        switch ([bodyDict[@"msg_code"] integerValue]) {
                case GYHDDataBaseCenterMessageChatText:
                case GYHDDataBaseCenterMessageChatMap:
            {
                if ([self.delegate respondsToSelector:@selector(sendToServerWithDict:)]) {
                    [self.delegate sendToServerWithDict:dict];
                }
                break;
            }
            case GYHDDataBaseCenterMessageChatPicture://图片消息
            {

                NSString *iamgePath = [NSString pathWithComponents:@[[GYHDUtils imagefolderNameString],saveDict[@"originalName"]]];
                NSData *imageData = [NSData dataWithContentsOfFile:iamgePath];
                [self.netWorkTool postImageWithData:imageData RequetResult:^(NSDictionary *resultDict) {
                    
                    if (resultDict||[resultDict allKeys].count>0) {
                        NSMutableDictionary *sendDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                        NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithDictionary:[GYHDUtils stringToDictionary:dict[GYHDDataBaseCenterMessageBody]]];
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
                        sendDict[GYHDDataBaseCenterMessageBody] = [GYHDUtils dictionaryToString:bodyDict];
                        if ([self.delegate respondsToSelector:@selector(sendToServerWithDict:)]) {
                            [self.delegate sendToServerWithDict:sendDict];
                        }
                    } else {
                        [[GYHDDataBaseCenter sharedInstance] updateMessageStateWithMessageID:dict[GYHDDataBaseCenterMessageID] State:GYHDDataBaseCenterMessageSendStateFailure];
                    }
       
                }];
                break;
            }
                
            case GYHDDataBaseCenterMessageChatAudio://音频消息
            {
                NSString *audioPath = [NSString pathWithComponents:@[[GYHDUtils mp3folderNameString],saveDict[@"mp3"]]];
                NSData *audioData = [NSData dataWithContentsOfFile:audioPath];
                [self.netWorkTool postAudioWithData:audioData RequetResult:^(NSDictionary *resultDict) {
                    
                    if (resultDict||[resultDict allKeys].count>0) {
                        NSMutableDictionary *sendDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                        NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithDictionary:[GYHDUtils stringToDictionary:dict[GYHDDataBaseCenterMessageBody]]];
              
                        NSString *mp3Url = [NSString stringWithFormat:@"%@%@",resultDict[@"tfsServerUrl"],resultDict[@"audioUrl"]];
                        bodyDict[@"msg_content"] = mp3Url;
                        sendDict[GYHDDataBaseCenterMessageBody] = [GYHDUtils dictionaryToString:bodyDict];
                        if ([self.delegate respondsToSelector:@selector(sendToServerWithDict:)]) {
                            [self.delegate sendToServerWithDict:sendDict];
                        }
                    } else {
                        [[GYHDDataBaseCenter sharedInstance] updateMessageStateWithMessageID:dict[GYHDDataBaseCenterMessageID] State:GYHDDataBaseCenterMessageSendStateFailure];
                    }
                    
                }];
                break;
            }
                case GYHDDataBaseCenterMessageChatVideo:
            {
                if (saveDict==nil) {
                    
                    return ;
                }
                NSString *videoPath = [NSString pathWithComponents:@[[GYHDUtils mp4folderNameString],saveDict[@"mp4Name"]]];
                NSData *videoData = [NSData dataWithContentsOfFile:videoPath];
                
                [self.netWorkTool postVideoWithData:videoData RequetResult:^(NSDictionary *resultDict) {
                    
                    if (resultDict||[resultDict allKeys].count>0) {
                        NSMutableDictionary *sendDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                        NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithDictionary:[GYHDUtils stringToDictionary:dict[GYHDDataBaseCenterMessageBody]]];
                        NSString *mp4VideoPath =[NSString stringWithFormat:@"%@%@",resultDict[@"tfsServerUrl"],resultDict[@"videoUrl"]];
                        NSString *mp4ImagePath = [NSString stringWithFormat:@"%@%@",resultDict[@"tfsServerUrl"],resultDict[@"firstFrameUrl"]];
                        bodyDict[@"msg_content"] = mp4VideoPath;
                        bodyDict[@"msg_imageNail"] = mp4ImagePath;
 
                        sendDict[GYHDDataBaseCenterMessageBody] = [GYHDUtils dictionaryToString:bodyDict];
                        if ([self.delegate respondsToSelector:@selector(sendToServerWithDict:)]) {
                            [self.delegate sendToServerWithDict:sendDict];
                        }
                    } else {
                        [[GYHDDataBaseCenter sharedInstance] updateMessageStateWithMessageID:dict[GYHDDataBaseCenterMessageID] State:GYHDDataBaseCenterMessageSendStateFailure];
                    }
                    
                }];
                
                break;
            }
            default:
                break;
        }

    });
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

/*拼接音频、视频、语音鉴权信息字段*/
-(NSString*)appendAuthenticationStr:(NSString*)AuthenticationStr{
    
    NSString*newStr=[NSString stringWithFormat:@"%@&custId=%@&channelType=%@&loginToken=%@", AuthenticationStr,globalData.loginModel.custId,@"5",globalData.loginModel.token];
    
    return newStr;

}

@end
