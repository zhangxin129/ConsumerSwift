//
//  GYHDDataBaseCenter.m
//  HSConsumer
//
//  Created by shiang on 15/12/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDDataBaseCenter.h"

#import "FMDB.h"

static NSString const* inHushengString = @"1001,1002,1006,1007,1008,1009,1010";
static NSString const* inDingDanString = @"2001,2002,2003,2004,2005,2006,2007,2008,2021,2022,2023,2024,2025,2026,2027,2028,2029";
static NSString const* inapplicantString = @"4101";
static NSString const* inDingYueString = @"2901,2902,2903,2904";
@interface GYHDDataBaseCenter ()
@property (nonatomic, strong) FMDatabaseQueue* IMdatabaseQueue;
@end

@implementation GYHDDataBaseCenter

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

- (id)copyWithZone:(NSZone*)zone
{
    return instance;
}

//******************** by wangbiao ******************** //
//- (BOOL)saveMessageWithDict:(NSDictionary *)dict {
//
//    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
//
//        NSMutableString *sql1 = [NSMutableString stringWithFormat:@"INSERT INTO %@ (", GYHDDataBaseCenterMessageTableName ];
//        NSMutableString *sql2 = [NSMutableString stringWithString:@" VALUES ("];
//
//        for (NSString *field in [dict allKeys]) {
//            [sql1 appendFormat:@"%@,", field];
//            [sql2 appendFormat:@"'%@',", dict[field]];
//        }
//        NSMutableString *sql3 = [NSMutableString stringWithString:[sql1 substringToIndex:sql1.length - 1]];//删除最后一个逗号
//        [sql3 appendString:@")"];
//        [sql3 appendString:[sql2 substringToIndex:sql2.length - 1]];//删除最后一个逗号
//        [sql3 appendString:@")"];//组合完成
//        [db executeUpdate:sql3];
//
//
//    }];
//    return YES;
//}

- (void)savedbFull:(NSString*)dbFull
{
    FMDatabaseQueue* IMdatabaseQueue = [[FMDatabaseQueue alloc] initWithPath:dbFull];
    _IMdatabaseQueue = IMdatabaseQueue;
    WS(weakSelf);
    [IMdatabaseQueue inTransaction:^(FMDatabase* db, BOOL* rollback) {

        //执行事务
        [db open];
        [db beginTransaction];
        //1. 创建消息数据库
        NSMutableString *messageSql = [NSMutableString stringWithFormat:
                                       @"CREATE TABLE IF NOT EXISTS %@ (", GYHDDataBaseCenterMessageTableName];
        [messageSql appendFormat:@"'%@' integer PRIMARY KEY AUTOINCREMENT,", @"ID"];
        [messageSql appendFormat:@"'%@' VARCHAR(50),", GYHDDataBaseCenterMessageID];
        [messageSql appendFormat:@"'%@' VARCHAR(50),", GYHDDataBaseCenterMessageFromID];
        [messageSql appendFormat:@"'%@' VARCHAR(50),", GYHDDataBaseCenterMessageToID];
        [messageSql appendFormat:@"'%@' VARCHAR(50),", GYHDDataBaseCenterMessageSessionID];
        [messageSql appendFormat:@"'%@' VARCHAR(50),", GYHDDataBaseCenterMessageCard];
        [messageSql appendFormat:@"'%@' TEXT       ,", GYHDDataBaseCenterMessageBody];
        [messageSql appendFormat:@"'%@' TEXT       ,", GYHDDataBaseCenterMessageContent];
        [messageSql appendFormat:@"'%@' TEXT       ,", GYHDDataBaseCenterMessageFriendType];
        [messageSql appendFormat:@"'%@' TEXT       ,", GYHDDataBaseCenterMessageData];
        [messageSql appendFormat:@"'%@' INTEGER    ,", GYHDDataBaseCenterMessageCode];
        [messageSql appendFormat:@"'%@' INTEGER    ,", GYHDDataBaseCenterMessageSendState];
        [messageSql appendFormat:@"'%@' INTEGER    ,", GYHDDataBaseCenterMessageIsRead];
        [messageSql appendFormat:@"'%@' INTEGER    ,", GYHDDataBaseCenterMessageIsSelf];
        [messageSql appendFormat:@"'%@' DATETIME   ,", GYHDDataBaseCenterMessageSendTime];
        [messageSql appendFormat:@"'%@' DATETIME   )", GYHDDataBaseCenterMessageRevieTime];
        //最后一个字段不要带逗号,带括号

        //2. 创建好友数据库
        NSMutableString *friendSql = [NSMutableString stringWithFormat:
                                      @"CREATE TABLE IF NOT EXISTS %@ (", GYHDDataBaseCenterFriendTableName];
        [friendSql appendFormat:@"'%@' integer PRIMARY KEY AUTOINCREMENT,", GYHDDataBaseCenterFriendID ];
        [friendSql appendFormat:@"'%@' VARCHAR(50) UNIQUE,", GYHDDataBaseCenterFriendCustID];
        [friendSql appendFormat:@"'%@' VARCHAR(50),", GYHDDataBaseCenterFriendResourceID];
        
        [friendSql appendFormat:@"'%@' VARCHAR(50)  DEFAULT '%@',", GYHDDataBaseCenterFriendName, GYHDDataBaseCenterUserSetingMessageTopDefualt];
        [friendSql appendFormat:@"'%@' VARCHAR(50)  DEFAULT '%@',", GYHDDataBaseCenterFriendIcon, GYHDDataBaseCenterUserSetingMessageTopDefualt];
        [friendSql appendFormat:@"'%@' VARCHAR(50)  DEFAULT '%@',",GYHDDataBaseCenterFriendApplication,GYHDDataBaseCenterUserSetingMessageTopDefualt];
        [friendSql appendFormat:@"'%@' VARCHAR(50)  DEFAULT '%@',", GYHDDataBaseCenterFriendFriendID, GYHDDataBaseCenterUserSetingMessageTopDefualt];
//        [friendSql appendFormat:@"'%@' VARCHAR(50)  DEFAULT '%@',", GYHDDataBaseCenterFriendSessionID, GYHDDataBaseCenterUserSetingMessageTopDefualt];
        
        [friendSql appendFormat:@"'%@' VARCHAR(50)  DEFAULT '%@',", GYHDDataBaseCenterFriendMessageType, GYHDDataBaseCenterUserSetingMessageTopDefualt];
        [friendSql appendFormat:@"'%@' VARCHAR(50)  DEFAULT '%@',", GYHDDataBaseCenterFriendUsetType, GYHDDataBaseCenterUserSetingMessageTopDefualt];
        [friendSql appendFormat:@"'%@' VARCHAR(50)  DEFAULT '%@',", GYHDDataBaseCenterFriendInfoTeamID, GYHDDataBaseCenterUserSetingMessageTopDefualt];
        [friendSql appendFormat:@"'%@' VARCHAR(50)  DEFAULT '%@',", GYHDDataBaseCenterFriendTeamFriendSet, GYHDDataBaseCenterUserSetingMessageTopDefualt];
        [friendSql appendFormat:@"'%@' VARCHAR(50)  DEFAULT '%@',", GYHDDataBaseCenterFriendSign, GYHDDataBaseCenterUserSetingMessageTopDefualt];
        [friendSql appendFormat:@"'%@' VARCHAR(50)  DEFAULT '%@',", GYHDDataBaseCenterFriendMessageTop, GYHDDataBaseCenterUserSetingMessageTopDefualt];
        [friendSql appendFormat:@"'%@' TEXT         DEFAULT '%@',", GYHDDataBaseCenterFriendBasic, GYHDDataBaseCenterUserSetingMessageTopDefualt];
        [friendSql appendFormat:@"'%@' TEXT         DEFAULT '%@' )", GYHDDataBaseCenterFriendDetailed, GYHDDataBaseCenterUserSetingMessageTopDefualt];

        //3. 创建好友分组数据
        NSMutableString *friendTeamSql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (", GYHDDataBaseCenterFriendTeamTableName ];
        [friendTeamSql appendFormat:@"'%@' integer PRIMARY KEY AUTOINCREMENT,", GYHDDataBaseCenterFriendTeamID];
        [friendTeamSql appendFormat:@"'%@' VARCHAR(50) UNIQUE,", GYHDDataBaseCenterFriendTeamTeamID ];
        [friendTeamSql appendFormat:@"'%@' VARCHAR(50) DEFAULT '-1',", GYHDDataBaseCenterFriendTeamName];
        [friendTeamSql appendFormat:@"'%@' TEXT       )", GYHDDataBaseCenterFriendTeamDetail ];

        //3. 用户基本信息设置
        NSMutableString *userSetingSql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (", GYHDDataBaseCenterUserSetingTableName ];
        [userSetingSql appendFormat:@"'%@' integer PRIMARY KEY AUTOINCREMENT,", GYHDDataBaseCenterUserSetingID];
        [userSetingSql appendFormat:@"'%@' VARCHAR(50) UNIQUE,", GYHDDataBaseCenterUserSetingName];
        [userSetingSql appendFormat:@"'%@' VARCHAR(50) DEFAULT '%@',", GYHDDataBaseCenterUserSetingMessageTop, GYHDDataBaseCenterUserSetingMessageTopDefualt ];
        [userSetingSql appendFormat:@"'%@' VARCHAR(50) DEFAULT '%@',", GYHDDataBaseCenterUserSetingSessionID, GYHDDataBaseCenterUserSetingMessageTopDefualt ];
        [userSetingSql appendFormat:@"'%@' VARCHAR(50) DEFAULT '%@')", GYHDDataBaseCenterUserSetingSelectCount, GYHDDataBaseCenterUserSetingMessageTopDefualt ];
        

        //4. 推送消息表
        NSMutableString *pushMessageSql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (", GYHDDataBaseCenterPushMessageTableName ];
        [pushMessageSql appendFormat:@"'%@' integer PRIMARY KEY AUTOINCREMENT,", @"ID" ];
        [pushMessageSql appendFormat:@"'%@' VARCHAR(50) ,", GYHDDataBaseCenterPushMessageID];

        [pushMessageSql appendFormat:@"'%@' VARCHAR(50) ,", GYHDDataBaseCenterPushMessagePlantFromID];
        [pushMessageSql appendFormat:@"'%@' TEXT   VARCHAR(50) DEFAULT '-1',", GYHDDataBaseCenterPushMessageFromID];
        [pushMessageSql appendFormat:@"'%@' TEXT   VARCHAR(50) DEFAULT '-1',", GYHDDataBaseCenterPushMessageToID];
        [pushMessageSql appendFormat:@"'%@' TEXT   VARCHAR(50) DEFAULT '-1',", GYHDDataBaseCenterPushMessageSendTime];
        [pushMessageSql appendFormat:@"'%@' TEXT   VARCHAR(50) DEFAULT '-1',", GYHDDataBaseCenterPushMessageRevieTime];
        [pushMessageSql appendFormat:@"'%@' TEXT   DEFAULT '-1',", GYHDDataBaseCenterPushMessageContent];
        [pushMessageSql appendFormat:@"'%@' TEXT   DEFAULT '-1',", GYHDDataBaseCenterPushMessageBody];
        [pushMessageSql appendFormat:@"'%@' INTEGER   DEFAULT '-1',", GYHDDataBaseCenterPushMessageCode];
        [pushMessageSql appendFormat:@"'%@' TEXT   DEFAULT '-1',", GYHDDataBaseCenterPushMessageData];
        [pushMessageSql appendFormat:@"'%@' INTEGER   DEFAULT '-1',", GYHDDataBaseCenterPushMessageIsRead];
        [pushMessageSql appendFormat:@"'%@' INTEGER   DEFAULT -1)", GYHDDataBaseCenterPushMessageUnreadLocation];

        [db executeUpdate:userSetingSql];
        [db executeUpdate:messageSql];
        [db executeUpdate:friendSql];
        [db executeUpdate:friendTeamSql];
        [db executeUpdate:pushMessageSql];
        
        
        // 追加表字段
        [weakSelf appendColumnWithdb:db TableName:GYHDDataBaseCenterUserSetingTableName columName:GYHDDataBaseCenterUserSetingMessageHiden tpeName:@" VARCHAR(50)"];
        [weakSelf appendColumnWithdb:db TableName:GYHDDataBaseCenterMessageTableName columName:GYHDDataBaseCenterMessageSessionID tpeName:@" VARCHAR(50)"];
        [weakSelf appendColumnWithdb:db TableName:GYHDDataBaseCenterUserSetingTableName columName:GYHDDataBaseCenterUserSetingSessionID tpeName:@" VARCHAR(50)"];
        
        [db commit];
    }];
}
- (BOOL)appendColumnWithdb:(FMDatabase*) db TableName:(NSString *)tableName columName:(NSString *)columName tpeName:(NSString *)typeName {
    BOOL retunBool = NO;
    if ([db tableExists:tableName]) {
        if (![db columnExists:columName inTableWithName:tableName]) {
            NSString *appdend = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@",tableName ,columName ,typeName];
          retunBool =  [db executeUpdate:appdend ];
        }
    }
    return retunBool;
}

- (NSArray<NSDictionary*>*)selectLastGroupMessage
{
    __block NSMutableArray* selectArray = [NSMutableArray array];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {

//        NSString *huShengSql  = [NSString stringWithFormat:@"SELECT * FROM T_PUSH_MSG"];
//        FMResultSet *huShengSet = [db executeQuery:huShengSql];
//        while (huShengSet.next) {
//            [selectArray addObject:[huShengSet resultDictionary]];
//        }
//        NSString *chatSql = [NSString stringWithFormat:@"SELECT * FROM T_MESSAGE"""];
//        FMResultSet *chatSet = [db executeQuery:chatSql];
//        while (chatSet.next) {
//            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[chatSet resultDictionary]];
//            [[GYHDMessageCenter sharedInstance] checkDict:dict];
//            [selectArray addObject:dict];
//        }
//        NSLog(@"%@",selectArray);
//        //互生
        NSString *huShengSql = [NSString stringWithFormat:@"SELECT * FROM (SELECT * FROM T_PUSH_MSG WHERE PUSH_MSG_Code IN ( %@ ) )TP LEFT JOIN T_USERSETING ON SUBSTR(TP.PUSH_MSG_Code,0,2)  = SUBSTR(T_USERSETING.User_Name,0,2) WHERE T_USERSETING.User_MessageHiden ISNULL  ORDER BY TP.PUSH_MSG_SendTime DESC LIMIT 0 ,1",inHushengString];
        FMResultSet *huShengSet = [db executeQuery:huShengSql];
        while (huShengSet.next) {
            [selectArray addObject:[huShengSet resultDictionary]];
        }

        // 订单
        NSString *dingdanSql = [NSString stringWithFormat:@"SELECT * FROM (SELECT * FROM T_PUSH_MSG WHERE PUSH_MSG_Code IN ( %@ ) )TP LEFT JOIN T_USERSETING ON SUBSTR(TP.PUSH_MSG_Code,0,2)  = SUBSTR(T_USERSETING.User_Name,0,2)  WHERE T_USERSETING.User_MessageHiden ISNULL ORDER BY TP.PUSH_MSG_SendTime DESC LIMIT 0 ,1",inDingDanString];
        FMResultSet *dingdanSet = [db executeQuery:dingdanSql];
        while (dingdanSet.next) {
            [selectArray addObject:[dingdanSet resultDictionary]];
        }
        // 订阅
        
        NSString *dingyueSql = [NSString stringWithFormat:@"SELECT * FROM (SELECT * FROM T_PUSH_MSG WHERE PUSH_MSG_Code IN ( %@ ) )TP LEFT JOIN T_USERSETING ON SUBSTR(TP.PUSH_MSG_Code,0,2)  = SUBSTR(T_USERSETING.User_Name,0,2)  WHERE T_USERSETING.User_MessageHiden ISNULL  ORDER BY TP.PUSH_MSG_SendTime DESC LIMIT 0 ,1",inDingYueString];
        FMResultSet *dingyueSet = [db executeQuery:dingyueSql];
        while (dingyueSet.next) {
            [selectArray addObject:[dingyueSet resultDictionary]];
        }
//        // 申请人
//        NSString *applicantSql = [NSString stringWithFormat:@"SELECT * FROM (SELECT * FROM T_PUSH_MSG WHERE PUSH_MSG_Code IN ( %@ ) )TP LEFT JOIN T_USERSETING ON SUBSTR(TP.PUSH_MSG_Code,0,2)  = SUBSTR(T_USERSETING.User_Name,0,2)  WHERE T_USERSETING.User_MessageHiden ISNULL ORDER BY TP.PUSH_MSG_SendTime DESC LIMIT 0 ,1",@"4101"];
//        FMResultSet *applicantSet = [db executeQuery:applicantSql];
//        while (applicantSet.next) {
//            [selectArray addObject:[applicantSet resultDictionary]];
//        }
// tm.MSG_Card = tu.User_Name
        // 聊天
        NSString *selectSql = @"select * from(SELECT * FROM 'T_MESSAGE' WHERE id IN ( SELECT max(id)FROM (SELECT T_MESSAGE.*,SUBSTR(T_MESSAGE.MSG_Card,0,11) MSGCardSub FROM T_MESSAGE) newTM GROUP BY newTM.MSGCardSub)) tm LEFT join (SELECT * FROM T_USERSETING) tu ON  SUBSTR(tm.MSG_Card,0,11)  = SUBSTR(tu.User_Name ,0,11)  LEFT JOIN T_FRIENDS tf ON SUBSTR(tm.MSG_Card,0,11)  = SUBSTR(tf.Friend_CustID,0,11)   WHERE tf.Friend_TeamIDFriendSet != 'blacklisted' AND tf.Friend_TeamID != 'blacklisted' AND tu.User_MessageHiden ISNULL GROUP BY tm.MSG_ID ORDER BY tu.User_MessageTop DESC, tm.MSG_ID DESC";
        FMResultSet *chatSet = [db executeQuery:selectSql];
        while (chatSet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[chatSet resultDictionary]];
            [[GYHDMessageCenter sharedInstance] checkDict:dict];
            [selectArray addObject:dict];
        }

    }];
    if (selectArray.count>50) {
        selectArray = [NSMutableArray  arrayWithArray:[selectArray subarrayWithRange:NSMakeRange(0,50)]];
    }

    return selectArray;
}

- (NSArray<NSDictionary*>*)selectPushWithMessageCode:(NSString*)messageCode from:(NSInteger)from to:(NSInteger)to
{
    __block NSMutableArray* pushSelectArray = [NSMutableArray array];

    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSString *sql = nil;
        if ([inHushengString rangeOfString:messageCode].location != NSNotFound) {
            sql = [NSString stringWithFormat:@"SELECT * FROM T_PUSH_MSG WHERE PUSH_MSG_Code IN ( %@ )  ORDER BY PUSH_MSG_SendTime DESC ,ID  DESC LIMIT %ld ,%ld", inHushengString, (long)from, (long)to];
        } else if ([inDingDanString rangeOfString:messageCode].location != NSNotFound) {
            sql = [NSString stringWithFormat:@"SELECT * FROM T_PUSH_MSG WHERE PUSH_MSG_Code IN ( %@ )  ORDER BY PUSH_MSG_SendTime DESC ,ID  DESC LIMIT %ld ,%ld", inDingDanString, (long)from, (long)to];
        } else if ([inapplicantString rangeOfString:messageCode].location != NSNotFound) {
            sql = [NSString stringWithFormat:@"SELECT * FROM T_PUSH_MSG WHERE PUSH_MSG_Code IN ( %@ )  ORDER BY PUSH_MSG_SendTime DESC ,ID  DESC LIMIT %ld ,%ld", inapplicantString, (long)from, (long)to];
        }
        FMResultSet *huShengSet = [db executeQuery:sql];
        while (huShengSet.next) {
            [pushSelectArray addObject:[huShengSet resultDictionary]];
        }
    }];

    return pushSelectArray;
}

/**
 * 查询每种消息未读统计
 */
- (NSString*)UnreadMessageCountWithCard:(NSString*)CardStr;
{
    __block NSInteger unreadMessageCount;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {

        NSString *sql = nil;
        if ([inHushengString rangeOfString:CardStr].location != NSNotFound) {
            sql = [NSString stringWithFormat:@"SELECT sum(PUSH_MSG_Read) unread FROM T_PUSH_MSG WHERE  PUSH_MSG_Code IN (%@)", inHushengString];
        } else if ([inDingDanString rangeOfString:CardStr].location != NSNotFound) {
            sql = [NSString stringWithFormat:@"SELECT sum(PUSH_MSG_Read) unread FROM T_PUSH_MSG WHERE  PUSH_MSG_Code IN (%@)", inDingDanString];
        } else if ([inapplicantString rangeOfString:CardStr].location != NSNotFound) {
            sql = [NSString stringWithFormat:@"SELECT sum(PUSH_MSG_Read) unread FROM T_PUSH_MSG WHERE  PUSH_MSG_Code IN (%@)", inapplicantString];
        } else if (CardStr.length > 11) {
            sql = [NSString stringWithFormat:@"SELECT sum(%@) unread FROM %@ WHERE MSG_Card = '%@'", GYHDDataBaseCenterMessageIsRead, GYHDDataBaseCenterMessageTableName, CardStr];

        }
        FMResultSet *unreadSet = [db executeQuery:sql];
        while (unreadSet.next) {
            unreadMessageCount = [unreadSet intForColumn:@"unread"];
        }
    }];

    if (unreadMessageCount > 99) {
        return @"99+";
    }
    if (unreadMessageCount < 1) {
        return nil;
    }
    return [NSString stringWithFormat:@"%ld", (long)unreadMessageCount];
}

/**
 * 查询所有消息未读统计
 */
- (NSInteger)UnreadAllMessageCount;
{
    __block int unreadAll = 0;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSString *unreadAllMessageCountSql = [NSString stringWithFormat:@"SELECT sum(%@) as unread  FROM %@", GYHDDataBaseCenterMessageIsRead, GYHDDataBaseCenterMessageTableName];
        int chatCount = 0;
        FMResultSet *unreadSet = [db executeQuery:unreadAllMessageCountSql];
        while (unreadSet.next) {
            chatCount = [unreadSet intForColumn:@"unread"];
        }

        NSString *unreadPushSql = [NSString stringWithFormat:@"SELECT sum(%@) as unread  FROM %@", GYHDDataBaseCenterPushMessageIsRead, GYHDDataBaseCenterPushMessageTableName];
        int PushCount = 0;
        FMResultSet *unreadPushSet = [db executeQuery:unreadPushSql];
        while (unreadPushSet.next) {
            PushCount = [unreadPushSet intForColumn:@"unread"];
        }
        unreadAll = PushCount + chatCount;
    }];
    return unreadAll;
}

/**
 * 清零已读信息
 */
- (BOOL)ClearUnreadMessageWithCard:(NSString*)CardStr
{
    if (!CardStr) {
        return NO;
    }
    __block NSInteger clearUnread = YES;
    ;

    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSString *sql = nil;
        if ([inHushengString rangeOfString:CardStr].location != NSNotFound) {
            sql = [NSString stringWithFormat:@"UPDATE T_PUSH_MSG SET PUSH_MSG_Read = 0 WHERE PUSH_MSG_Code IN (%@)", inHushengString];
        } else if ([inDingDanString rangeOfString:CardStr].location != NSNotFound) {
            sql = [NSString stringWithFormat:@"UPDATE T_PUSH_MSG SET PUSH_MSG_Read = 0 WHERE PUSH_MSG_Code IN (%@)", inDingDanString];
        } else if ([inapplicantString rangeOfString:CardStr].location != NSNotFound) {
            sql = [NSString stringWithFormat:@"UPDATE T_PUSH_MSG SET PUSH_MSG_Read = 0 WHERE PUSH_MSG_Code IN (%@)", inapplicantString];
        } else if (CardStr.length > 11) {
            sql = [NSString stringWithFormat:@"UPDATE T_MESSAGE SET MSG_Read = 0 WHERE MSG_Card LIKE '%%%@%%'", [CardStr substringToIndex:11]];
        }
        clearUnread = [db executeUpdate:sql];

    }];

    return clearUnread;
}

/**
 * 查询所以聊天记录
 */
- (NSArray<NSDictionary*>*)selectAllChatWithCard:(NSString*)cardStr frome:(NSInteger)from to:(NSInteger)to
{
    __block NSMutableArray* chatArrayM = [NSMutableArray array];
    cardStr = [cardStr substringToIndex:11];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSString *selectChatSql = [NSString stringWithFormat:@"SELECT * FROM (SELECT * FROM T_MESSAGE WHERE MSG_Card like '%%%@%%' ORDER BY MSG_SendTime DESC  LIMIT %ld, %ld) t ORDER BY t.MSG_SendTime ASC", cardStr, (long)from, (long)to];
//        NSString *selectChatSql = [NSString stringWithFormat:@"SELECT * FROM\
//                                   (SELECT * FROM T_MESSAGE WHERE MSG_Card = '%@' ORDER BY ID DESC  LIMIT %ld, %ld) t LEFT JOIN T_FRIENDS ON t.MSG_Card = T_FRIENDS.Friend_CustID ORDER BY t.ID ASC ",cardStr,from,to];
//        NSString *selectChatSql = [NSString stringWithFormat:@"SELECT * FROM (SELECT * FROM (SELECT * FROM T_MESSAGE WHERE MSG_Card like '%%%@%%' ORDER BY MSG_ID DESC  LIMIT %ld, %ld)  tt ORDER BY tt.MSG_ID ASC ) tm ,(SELECT * FROM T_FRIENDS WHERE Friend_CustID like '%%%@%%') tf WHERE tm.MSG_Card = tf.Friend_CustID",cardStr,from,to,cardStr];
        FMResultSet *allChatSet = [db executeQuery:selectChatSql];
        while (allChatSet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[allChatSet resultDictionary]];
            [[GYHDMessageCenter sharedInstance] checkDict:dict];
            [chatArrayM addObject:dict];
        }

    }];
    return chatArrayM;
}

/**插入好友基本信息*/
- (BOOL)insertInfoWithDict:(NSDictionary*)dict TableName:(NSString*)tableName
{

    __block BOOL insetBool = NO;

    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {

        NSMutableString *sql1 = [NSMutableString stringWithFormat:@"INSERT INTO %@ (", tableName];
        NSMutableString *sql2 = [NSMutableString stringWithString:@" VALUES ("];
        for (NSString *field in [dict allKeys]) {
            [sql1 appendFormat:@"%@,", field];
            if ([dict[field] isKindOfClass:[NSString class]]) {
                NSMutableString *va =  [dict[field] mutableCopy];
                [sql2 appendFormat:@"'%@',",  [va stringByReplacingOccurrencesOfString:@"'" withString:@"‘"]];
            }else {
                [sql2 appendFormat:@"'%@',", dict[field]];
            }

        }
        NSMutableString *sql3 = [NSMutableString stringWithString:[sql1 substringToIndex:sql1.length - 1]];//删除最后一个逗号
        [sql3 appendString:@")"];
        [sql3 appendString:[sql2 substringToIndex:sql2.length - 1]];//删除最后一个逗号
        sql2 =  [sql2 stringByReplacingOccurrencesOfString:@"'" withString:@"‘"].mutableCopy;
        [sql3 appendString:@")"];//组合完成

      insetBool = [db executeUpdate:sql3];

    }];
    return insetBool;
}

/**更新好友分组信息*/
- (void)updateFriendTeamWtihDict:(NSDictionary*)dict
{
    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSString *teamID = dict[@"teamId"];
        NSString *teamName = dict[@"teamName"];
        NSString *teamDetal = [self dictionaryToString:dict];

        NSString *updateTeamSql = [NSString stringWithFormat:@"REPLACE INTO T_TREAMS (Tream_ID,Tream_Name,Tream_detal)VALUES('%@','%@','%@')", teamID, teamName, teamDetal];
        //        [db executeUpdate:DeleteSql,updateSql];
        [db executeUpdate:updateTeamSql];
    }];
}

/**查询未某内分组用户*/
- (NSArray*)selectFriendWithTeamID:(NSString*)teamID
{

    __block NSMutableArray* chatArrayM = [NSMutableArray array];

    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSString *selectChatSql = nil;
        if (teamID) {
            selectChatSql = [NSString stringWithFormat:@"SELECT * FROM T_FRIENDS WHERE Friend_TeamID LIKE '%%%@%%' AND  Friend_Application != '1' AND Friend_TeamIDFriendSet !='blacklisted' ", teamID];
        } else {
            selectChatSql = [NSString stringWithFormat:@"SELECT * FROM T_FRIENDS WHERE Friend_MessageType = 'Friend' AND Friend_TeamIDFriendSet !='blacklisted' AND Friend_TeamID != 'blacklisted' AND Friend_Application == '2'"];
        }

        FMResultSet *allChatSet = [db executeQuery:selectChatSql];
        while (allChatSet.next) {
            [chatArrayM addObject:[allChatSet resultDictionary]];
        }

    }];
    return chatArrayM;
}

- (NSDictionary*)selectfriendBaseWithCardStr:(NSString*)CardStr
{
    __block NSMutableDictionary* friendDetailDict = [NSMutableDictionary dictionary];
    CardStr = [CardStr substringToIndex:11];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {

//        NSString *selectFriendDetailSql = [NSString stringWithFormat:@"SELECT * FROM T_FRIENDS WHERE Friend_CustID LIKE '%%%@%%'",CardStr];
        NSString *selectFriendDetailSql = [NSString stringWithFormat:@"SELECT * FROM T_FRIENDS WHERE Friend_CustID LIKE '%%%@%%'   AND Friend_Basic !=''", CardStr];
        FMResultSet *friendDetalSet = [db executeQuery:selectFriendDetailSql];
        while (friendDetalSet.next) {
            friendDetailDict = [NSMutableDictionary dictionaryWithDictionary:[friendDetalSet resultDictionary]];
        }
    }];
    [[GYHDMessageCenter sharedInstance] checkDict:friendDetailDict];
    return friendDetailDict;
}

/**
 * 字典转文字
 */
- (NSString*)dictionaryToString:(NSDictionary*)dic
{
    if (!dic)
        return nil;
    NSError* error = nil;
    NSData* data = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&error];
    NSString* string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    if (error) {
        return nil;
    }
    return string;
}

- (NSArray<NSArray<NSDictionary*>*>*)selectFriendList
{
    __block NSMutableArray* chatArrayM = [NSMutableArray array];

    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSString *selectChatSql = [NSString stringWithFormat:@"SELECT * FROM T_FRIENDS WHERE Friend_MessageType = 'Friend' AND Friend_TeamIDFriendSet !='blacklisted' AND Friend_TeamID != 'blacklisted' AND Friend_Application == '2'"];
        FMResultSet *allChatSet = [db executeQuery:selectChatSql];
        while (allChatSet.next) {
            if ([GYUtils stringToDictionary:[allChatSet stringForColumn:@"Friend_Basic"]]) {
                [chatArrayM addObject:[GYUtils stringToDictionary:[allChatSet stringForColumn:@"Friend_Basic"]]];
            }
        }

    }];
    return chatArrayM;
}

/**获取好友列表信息*/
- (NSArray<NSArray<NSDictionary*>*>*)selectFriendBaseList
{

    __block NSMutableArray* chatArrayM = [NSMutableArray array];

    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSString *selectChatSql = [NSString stringWithFormat:@"SELECT * FROM T_FRIENDS WHERE Friend_MessageType = 'Friend' AND Friend_TeamIDFriendSet !='blacklisted' AND Friend_TeamID != 'blacklisted' AND Friend_Application == '2'"];
        FMResultSet *allChatSet = [db executeQuery:selectChatSql];
        while (allChatSet.next) {
            [chatArrayM addObject:[allChatSet resultDictionary]];
        }

    }];
    return chatArrayM;
}

- (NSArray<NSDictionary*>*)selectFocusCompanyList
{
    __block NSMutableArray* chatArrayM = [NSMutableArray array];

    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSString *selectChatSql = [NSString stringWithFormat:@"SELECT * FROM T_FRIENDS WHERE %@ = '%@'", GYHDDataBaseCenterFriendMessageType, GYHDDataBaseCenterFocusOnBusiness];
        FMResultSet *allChatSet = [db executeQuery:selectChatSql];
        while (allChatSet.next) {
            [chatArrayM addObject:[allChatSet resultDictionary]];
//            [chatArrayM addObject:[GYUtils stringToDictionary:[allChatSet stringForColumn:@"Friend_Basic"]]];
        }

    }];
    return chatArrayM;
}

- (NSInteger)countWithCustID:(NSString*)CustID searchString:(NSString*)string
{
    __block NSInteger count = 0;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSString *countString = [NSString stringWithFormat:@"SELECT COUNT(1) count FROM T_MESSAGE WHERE MSG_Card = '%@' AND MSG_Content LIKE '%%%@%%'",CustID,string];
        FMResultSet *countSet = [db executeQuery:countString];
        while (countSet.next) {
            count = [countSet intForColumn: @"count"];
        }
    }];
    return count;
}

- (BOOL)updateMessageStateWithMessageID:(NSString*)messageID State:(GYHDDataBaseCenterMessageSendStateOption)state;
{
    __block BOOL sendState = YES;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSString *clearUnreadSql = [NSString stringWithFormat:@"UPDATE T_MESSAGE SET MSG_State = %ld WHERE MSG_ID  = '%@'", (long)state, messageID];
        sendState = [db executeUpdate:clearUnreadSql];
    }];
    return sendState;
}
/**
 * 消息置顶
 */
- (BOOL)messageTopWithMessageCard:(NSString*)messageCard
{
    
    __block BOOL hiden = YES;
    if (messageCard.length < 11  && messageCard.length > 2) {
        messageCard = [messageCard substringToIndex:2];
    }else if(messageCard.length >11){
        messageCard = [messageCard substringToIndex:11];
    }
    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM T_USERSETING WHERE User_Name = '%@'",messageCard];
        FMResultSet *set = [db executeQuery:selectSql];
        NSMutableArray *setArray = [NSMutableArray array];
        while (set.next) {
            [setArray addObject:[set resultDictionary]];
        }
        NSString *clearTopSql = nil;
        
        if (setArray.count) {
            clearTopSql = [NSString stringWithFormat:@"UPDATE 'T_USERSETING' SET User_MessageTop =   strftime('%%Y-%%m-%%d %%H:%%M:%%S','now','localtime') WHERE User_Name = '%@'",messageCard];
        } else {
            clearTopSql = [NSString stringWithFormat:@"INSERT INTO  T_USERSETING (User_Name ,User_MessageTop) VALUES ('%@',strftime('%%Y-%%m-%%d %%H:%%M:%%S','now','localtime'))",messageCard];
        }
        
        
        hiden = [db executeUpdate:clearTopSql];
    }];
    return hiden;
    
}

//{
//    __block BOOL Top = YES;
//    if (messageCard.length < 11) {
//        messageCard = [messageCard substringToIndex:2];
//    }
//    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
//        NSString *TopSql = [NSString stringWithFormat:
//                            @"REPLACE INTO T_USERSETING(User_Name,User_SelectCount,User_MessageTop)VALUES('%@',(SELECT User_SelectCount FROM T_USERSETING WHERE User_Name = '%@'),strftime('%%Y-%%m-%%d %%H:%%M:%%S','now','localtime'))",messageCard, messageCard];
//
//        Top = [db executeUpdate:TopSql];
//    }];
//    return Top;
//}

/**
 * 消息取消置顶
 */
- (BOOL)messageClearTopWithMessageCard:(NSString*)messageCard
{
    __block BOOL clearTop = YES;
    if (messageCard.length < 11  && messageCard.length > 2) {
        messageCard = [messageCard substringToIndex:2];
    }else if(messageCard.length >11){
        messageCard = [messageCard substringToIndex:11];
    }
    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
//        NSString *clearTopSql = [NSString stringWithFormat:@"DELETE FROM T_USERSETING WHERE User_Name = '%@'", messageCard];
        NSString *clearTopSql = [NSString stringWithFormat:@"UPDATE 'T_USERSETING' SET User_MessageTop = NULL WHERE User_Name = '%@'",messageCard];
        clearTop = [db executeUpdate:clearTopSql];
    }];
    return clearTop;
}
/**设置隐藏消息*/
- (BOOL)setMessageHidenWithCustID:(NSString *)CustID {
    
    __block BOOL hiden = YES;
    if (CustID.length < 11  && CustID.length > 2) {
        CustID = [CustID substringToIndex:2];
    }else if(CustID.length >11){
        CustID = [CustID substringToIndex:11];
    }
    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM T_USERSETING WHERE User_Name = '%@'",CustID];
       FMResultSet *set = [db executeQuery:selectSql];
        NSMutableArray *setArray = [NSMutableArray array];
        while (set.next) {
          [setArray addObject:[set resultDictionary]];
        }
        NSString *clearTopSql = nil;
        
        if (setArray.count) {
             clearTopSql = [NSString stringWithFormat:@"UPDATE 'T_USERSETING' SET User_MessageHiden = '1' WHERE User_Name = '%@'",CustID];
        } else {
            clearTopSql = [NSString stringWithFormat:@"INSERT INTO  T_USERSETING (User_Name ,User_MessageHiden) VALUES ('%@','1')",CustID];
        }
        

        hiden = [db executeUpdate:clearTopSql];
    }];
    return hiden;
    
}
/**清除隐藏消息*/
- (BOOL)clearMessageHidenWithCustID:(NSString *)CustID  {
    __block BOOL hiden = YES;
    if (CustID.length < 11  && CustID.length > 2) {
        CustID = [CustID substringToIndex:2];
    }else if(CustID.length >11){
        CustID = [CustID substringToIndex:11];
    }
    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSString *clearTopSql = [NSString stringWithFormat:@"UPDATE 'T_USERSETING' SET User_MessageHiden = NULL WHERE User_Name = '%@'",CustID];
        hiden = [db executeUpdate:clearTopSql];
    }];
    return hiden;
}
/**查询置顶消息数量*/
- (NSInteger)selectCountMessageTop {
    __block NSInteger count = 0;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *countString = [NSString stringWithFormat:@"SELECT  COUNT(1) count  FROM T_USERSETING WHERE User_MessageTop IS NOT NULL"];
        FMResultSet *countSet = [db executeQuery:countString];
        while (countSet.next) {
            count = [countSet intForColumn: @"count"];
        }
    }];
    return count;
}
/**
 * 删除消息
 */
- (BOOL)deleteMessageWithMessageCard:(NSString*)messageCard
{
    __block BOOL deleteState = YES;

    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSString *sql = nil;
        if ([inHushengString rangeOfString:messageCard].location != NSNotFound) {
            sql = [NSString stringWithFormat:@"DELETE FROM T_PUSH_MSG WHERE PUSH_MSG_Code IN (%@)", inHushengString];
        } else if ([inDingDanString rangeOfString:messageCard].location != NSNotFound) {
            sql = [NSString stringWithFormat:@"DELETE FROM T_PUSH_MSG  WHERE PUSH_MSG_Code IN (%@)", inDingDanString];
        } else if ([inapplicantString rangeOfString:messageCard].location != NSNotFound) {
            sql = [NSString stringWithFormat:@"DELETE FROM T_PUSH_MSG  WHERE PUSH_MSG_Code IN (%@)", inapplicantString];
        } else if (messageCard.length > 11) {
            sql = [NSString stringWithFormat:@"DELETE FROM  T_MESSAGE  WHERE MSG_Card LIKE '%%%@%%'", messageCard];
        }
        deleteState = [db executeUpdate:sql];

    }];

    return deleteState;
}

- (BOOL)deleteMessageWithMessage:(NSString*)message fieldName:(NSString*)fieldName
{
    __block BOOL deleteState = YES;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE %@ = '%@'", GYHDDataBaseCenterMessageTableName, fieldName, message];
        deleteState = [db executeUpdate:deleteSql];
    }];
    return deleteState;
}

- (BOOL)deleteWithMessage:(NSString*)message fieldName:(NSString*)fieldName TableName:(NSString*)tableName
{
    __block BOOL deleteState = YES;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSString *deleteSql = nil;
        if (!message || !fieldName) {
            deleteSql = [NSString stringWithFormat:@"DELETE FROM '%@'", tableName];
        } else {
            deleteSql = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE %@ like '%%%@%%'", tableName, fieldName, message];
        }
        deleteState = [db executeUpdate:deleteSql];
    }];
    return deleteState;
}

/**更新某个字段值*/
/**更新某个字段值*/
- (BOOL)updateMessageWithMessageID:(NSString*)messageID fieldName:(NSString*)fieldName updateString:(NSString*)updateString
{
    __block BOOL deleteState = YES;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSString *deleteSql = [NSString stringWithFormat:@"UPDATE T_MESSAGE SET %@ = '%@' WHERE MSG_ID = '%@' ", fieldName, updateString, messageID];
        deleteState = [db executeUpdate:deleteSql];
    }];
    return deleteState;
}

/**查询数据发送状态*/
- (NSArray<NSDictionary*>*)selectSendState:(GYHDDataBaseCenterMessageSendStateOption)option
{
    __block NSMutableArray* sendStateArray = [NSMutableArray array];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSString *selectDingdanListSql = [NSString stringWithFormat:@"SELECT * FROM T_MESSAGE WHERE MSG_State = %ld ", (long)option];
        FMResultSet *dingDanListSet = [db executeQuery:selectDingdanListSql];
        while (dingDanListSet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[dingDanListSet resultDictionary]];

            [[GYHDMessageCenter sharedInstance] checkDict:dict];
            [sendStateArray addObject:dict];
        }

    }];
    return sendStateArray;
}

- (BOOL)updateInfoWithDict:(NSDictionary*)dict conditionDict:(NSDictionary*)conditionDict TableName:(NSString*)tableName
{

    __block BOOL updateState = YES;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {

        NSString *updateHeaderSql = [NSString stringWithFormat:@"UPDATE %@ SET ", tableName];
        NSMutableString *updatebodySql = [NSMutableString string];
        NSMutableString *updateFooterSql = [NSMutableString string];

        for (NSString *key in [dict allKeys]) {
            [updatebodySql appendString:[NSString stringWithFormat:@"%@ = '%@',", key, dict[key]]];
        }
        ;
        for (NSString *key in [conditionDict allKeys]) {
            [updateFooterSql appendString:[NSString stringWithFormat:@"%@ = '%@' AND ", key, conditionDict[key]]];
        }

        NSString *updateSql = [NSString stringWithFormat:@" %@ %@ WHERE %@ 1=1", updateHeaderSql, [updatebodySql substringToIndex:updatebodySql.length - 1], updateFooterSql];

        updateState = [db executeUpdate:updateSql];
    }];
    return updateState;
}

/**删除数据*/
- (BOOL)deleteInfoWithDict:(NSDictionary*)dict TableName:(NSString*)tableName
{
    __block BOOL updateState = YES;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSMutableString *valueName = [NSMutableString string];

        for (NSString *key in dict.allKeys) {
            [valueName appendFormat:@" %@ = '%@' AND", key, dict[key]];
        }
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ 1=1", tableName, valueName];
        updateState = [db executeUpdate:deleteSql];
    }];
    return updateState;
    return YES;
}

- (NSArray*)selectSearchMessageWithString:(NSString*)string
{
    __block NSMutableArray* selectArray = [NSMutableArray array];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {

        NSMutableArray *messageArray = [NSMutableArray array];

        //push
//       //互生
// 
        NSString *huShengSql = [NSString stringWithFormat:@"SELECT *  , COUNT(*) tp_count  FROM (SELECT * FROM T_PUSH_MSG WHERE PUSH_MSG_Code IN ( %@ ) )TP LEFT JOIN T_USERSETING ON SUBSTR(TP.PUSH_MSG_Code,0,2)  = SUBSTR(T_USERSETING.User_Name,0,2) WHERE TP.PUSH_MSG_Content LIKE '%%%@%%'  ORDER BY TP.PUSH_MSG_SendTime DESC ",inHushengString,string];
        FMResultSet *huShengSet = [db executeQuery:huShengSql];
        while (huShengSet.next) {
            NSDictionary *dict = [huShengSet resultDictionary];
            if ([dict[@"tp_count"] intValue]) {
                [messageArray addObject:dict];
            }
   
        }
//
        // 订单
        NSString *dingdanSql = [NSString stringWithFormat:@"SELECT *  , COUNT(*) tp_count  FROM (SELECT * FROM T_PUSH_MSG WHERE PUSH_MSG_Code IN ( %@ ) )TP LEFT JOIN T_USERSETING ON SUBSTR(TP.PUSH_MSG_Code,0,2)  = SUBSTR(T_USERSETING.User_Name,0,2)  WHERE TP.PUSH_MSG_Content LIKE '%%%@%%'  ORDER BY TP.PUSH_MSG_SendTime DESC ",inDingDanString,string];
        FMResultSet *dingdanSet = [db executeQuery:dingdanSql];
        while (dingdanSet.next) {
            NSDictionary *dict = [dingdanSet resultDictionary];
            if ([dict[@"tp_count"] intValue]) {
                [messageArray addObject:dict];
            }
        }
//        // 订阅
//        
        NSString *dingyueSql = [NSString stringWithFormat:@"SELECT * , COUNT(*) tp_count FROM (SELECT * FROM T_PUSH_MSG WHERE PUSH_MSG_Code IN ( %@ ) )TP LEFT JOIN T_USERSETING ON SUBSTR(TP.PUSH_MSG_Code,0,2)  = SUBSTR(T_USERSETING.User_Name,0,2)  WHERE  TP.PUSH_MSG_Content LIKE '%%%@%%'  ORDER BY TP.PUSH_MSG_SendTime DESC",inDingYueString,string];
        FMResultSet *dingyueSet = [db executeQuery:dingyueSql];
        while (dingyueSet.next) {
            NSDictionary *dict = [dingyueSet resultDictionary];
            if ([dict[@"tp_count"] intValue]) {
                [messageArray addObject:dict];
            }
        }
        
        
        //message
        NSString *messageSelectSql = [NSString stringWithFormat:@"SELECT\
                                      *\
                                      FROM\
                                      T_MESSAGE,\
                                      T_FRIENDS,\
                                      (\
                                       SELECT\
                                       COUNT(*)tp_count,\
                                       MSG_Card\
                                       FROM\
                                       T_MESSAGE\
                                       WHERE\
                                       MSG_Content LIKE '%%%@%%'\
                                       GROUP BY\
                                       SUBSTR(T_MESSAGE.MSG_Card, 0, 11)\
                                       )tc\
                                      WHERE\
                                      SUBSTR(T_MESSAGE.MSG_Card, 0, 11)= SUBSTR(T_FRIENDS.Friend_CustID, 0, 11)\
                                      AND SUBSTR(T_MESSAGE.MSG_Card, 0, 11)= SUBSTR(tc.MSG_Card, 0, 11)\
                                      GROUP BY\
                                      SUBSTR(T_MESSAGE.MSG_Card, 0, 11)",string];
        FMResultSet *pushSet = [db executeQuery:messageSelectSql];
        while (pushSet.next) {
            NSDictionary *dict = [pushSet resultDictionary];
            if ([dict[@"tp_count"] intValue]) {
                [messageArray addObject:dict];
            }
        }

        NSMutableArray *friendArray = [NSMutableArray array];
        NSString *fiendSelectSql = [NSString stringWithFormat:@"SELECT * FROM (SELECT * FROM  (SELECT * FROM T_FRIENDS WHERE  Friend_MessageType = 'Friend' AND Friend_Application == 2  AND Friend_Name LIKE '%%%@%%') tf LEFT JOIN T_MESSAGE ON T_MESSAGE.MSG_Card = tf.Friend_CustID ) tx GROUP BY tx.Friend_CustID", string];
        FMResultSet *friendSet = [db executeQuery:fiendSelectSql];
        while (friendSet.next) {
            [friendArray addObject:[friendSet resultDictionary]];
        }
        NSMutableArray *companyArray = [NSMutableArray array];
        NSString *companySelectSql = [NSString stringWithFormat:@"SELECT * FROM (SELECT * FROM  (SELECT * FROM T_FRIENDS WHERE  Friend_MessageType = 'Focus' AND Friend_Name LIKE '%%%@%%') tf LEFT JOIN T_MESSAGE ON T_MESSAGE.MSG_Card = tf.Friend_CustID ) tx GROUP BY tx.Friend_CustID", string];
        FMResultSet *companySet = [db executeQuery:companySelectSql];
        while (companySet.next) {
            [companyArray addObject:[companySet resultDictionary]];
        }

        [selectArray addObject:messageArray];
        [selectArray addObject:friendArray];
        [selectArray addObject:companyArray];

    }];

    return selectArray;
}

- (NSDictionary*)selectMyInfo
{
    __block NSDictionary* myInfoDict = [NSDictionary dictionary];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSString *selectInfoSql = [NSString stringWithFormat:@"SELECT * FROM T_FRIENDS WHERE Friend_MessageType = 'self'"];
        FMResultSet *infoSet = [db executeQuery:selectInfoSql];
        while (infoSet.next) {
            myInfoDict = [infoSet resultDictionary];;
        }
    }];
    return myInfoDict;
}

/**查询咨询企业信息*/
- (NSDictionary*)selectCompanyWithCustID:(NSString*)custID
{
    __block NSDictionary* myInfoDict = [NSDictionary dictionary];
    NSString* card = [custID substringToIndex:11];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSString *selectInfoSql = [NSString stringWithFormat:@"SELECT *\
                                   FROM T_FRIENDS\
                                   WHERE Friend_CustID LIKE '%%%@%%'\
                                   AND Friend_MessageType = 'temporary'\
                                   AND Friend_Basic !=''", card];
        FMResultSet *infoSet = [db executeQuery:selectInfoSql];
        while (infoSet.next) {
            myInfoDict = [infoSet resultDictionary];;
        }
    }];
    return myInfoDict;
}

- (NSArray*)selectInfoWithDict:(NSDictionary*)condDict TableName:(NSString*)tableName
{
    __block NSMutableArray* selectArray = [NSMutableArray array];

    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSMutableString *bodySql = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE", tableName];
        for (NSString *key in [condDict allKeys]) {
            [bodySql appendString:[NSString stringWithFormat:@" %@ LIKE '%%%@%%' AND", key, condDict[key]] ];
        }
        [bodySql appendString:@" 1 = 1"];
        FMResultSet *resultSet = [db executeQuery:bodySql];
        while (resultSet.next) {
            [selectArray addObject:[resultSet resultDictionary]];
        }
    }];
    return selectArray;
}

- (NSArray*)selectInfoEqualDict:(NSDictionary*)condDict TableName:(NSString*)tableName
{
    __block NSMutableArray* selectArray = [NSMutableArray array];

    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSMutableString *bodySql = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE", tableName];
        for (NSString *key in [condDict allKeys]) {
            [bodySql appendString:[NSString stringWithFormat:@" %@ = '%@' AND", key, condDict[key]]];
        }
        [bodySql appendString:@" 1 = 1"];
        FMResultSet *resultSet = [db executeQuery:bodySql];
        while (resultSet.next) {
            [selectArray addObject:[resultSet resultDictionary]];
        }
    }];
    return selectArray;
}

- (BOOL)updataFriendSelectCount:(NSString*)count custID:(NSString*)custID
{
    __block BOOL update = YES;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSString *TopSql = [NSString stringWithFormat:
                            @"REPLACE INTO T_USERSETING(\
                            User_Name,\
                            User_SelectCount,\
                            User_MessageTop\
                            )VALUES(\
                            '%@',\
                            '%@',\
                            (SELECT User_MessageTop  FROM T_USERSETING WHERE User_Name = '%@'))",custID,count, custID];
        update = [db executeUpdate:TopSql];
    }];
    return update;
}
- (NSArray *)selectApplicationFriend {
    __block NSMutableArray* selectArray = [NSMutableArray array];
    
    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSString *bodySql = [NSString stringWithFormat:@"SELECT * FROM T_FRIENDS WHERE Friend_Application IN (1,-1) AND Friend_MessageType = 'Friend'"];
        FMResultSet *resultSet = [db executeQuery:bodySql];
        while (resultSet.next) {
            [selectArray addObject:[resultSet resultDictionary]];
        }
    }];
    return selectArray;
}
- (NSArray *)searchMessageListWithString:(NSString *)string custID:(NSString *)custID {
    
    __block NSMutableArray *messageArray = [NSMutableArray array];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        if ([inHushengString rangeOfString:custID].location != NSNotFound) {
            NSString *huShengSql = [NSString stringWithFormat:@"SELECT * FROM (SELECT * FROM T_PUSH_MSG WHERE PUSH_MSG_Code IN ( %@ ) )TP LEFT JOIN T_USERSETING ON SUBSTR(TP.PUSH_MSG_Code,0,2)  = SUBSTR(T_USERSETING.User_Name,0,2) WHERE TP.PUSH_MSG_Content LIKE '%%%@%%'  ORDER BY TP.PUSH_MSG_SendTime DESC ",inHushengString,string];
            FMResultSet *huShengSet = [db executeQuery:huShengSql];
            while (huShengSet.next) {
                [messageArray addObject:[huShengSet resultDictionary]];
            }
        }else if ([inDingDanString rangeOfString:custID].location != NSNotFound) {
            NSString *dingdanSql = [NSString stringWithFormat:@"SELECT *  FROM (SELECT * FROM T_PUSH_MSG WHERE PUSH_MSG_Code IN ( %@ ) )TP LEFT JOIN T_USERSETING ON SUBSTR(TP.PUSH_MSG_Code,0,2)  = SUBSTR(T_USERSETING.User_Name,0,2)  WHERE TP.PUSH_MSG_Content LIKE '%%%@%%'  ORDER BY TP.PUSH_MSG_SendTime DESC ",inDingDanString,string];
            FMResultSet *dingdanSet = [db executeQuery:dingdanSql];
            while (dingdanSet.next) {
                [messageArray addObject:[dingdanSet resultDictionary]];
            }
        }else if ([inDingYueString rangeOfString:custID].location != NSNotFound) {
            NSString *dingyueSql = [NSString stringWithFormat:@"SELECT *  FROM (SELECT * FROM T_PUSH_MSG WHERE PUSH_MSG_Code IN ( %@ ) )TP LEFT JOIN T_USERSETING ON SUBSTR(TP.PUSH_MSG_Code,0,2)  = SUBSTR(T_USERSETING.User_Name,0,2)  WHERE  TP.PUSH_MSG_Content LIKE '%%%@%%'  ORDER BY TP.PUSH_MSG_SendTime DESC",inDingYueString,string];
            FMResultSet *dingyueSet = [db executeQuery:dingyueSql];
            while (dingyueSet.next) {
                [messageArray addObject:[dingyueSet resultDictionary]];
            }
        }else if (custID.length > 10 ) {
            NSString *messageSql = [NSString stringWithFormat:@"SELECT  * FROM T_MESSAGE,T_FRIENDS WHERE  SUBSTR(T_MESSAGE.MSG_Card ,0,11) =  SUBSTR(T_FRIENDS.Friend_CustID,0,11 ) AND  SUBSTR(T_FRIENDS.Friend_CustID,0,11 ) =  SUBSTR('%@',0,11 ) AND MSG_Content LIKE '%%%@%%' ",custID,string];
            FMResultSet *messageSet = [db executeQuery:messageSql];
            while (messageSet.next) {
                [messageArray addObject:[messageSet resultDictionary]];
            }
        }
    }];
    return messageArray;
}
/**更新企业SessionID*/
- (BOOL)setMessageSessionID:(NSString *)sessionID resNO:(NSString *)resNO {
    __block BOOL hiden = YES;

    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM T_USERSETING WHERE User_Name = '%@'",resNO];
        FMResultSet *set = [db executeQuery:selectSql];
        NSMutableArray *setArray = [NSMutableArray array];
        while (set.next) {
            [setArray addObject:[set resultDictionary]];
        }
        NSString *clearTopSql = nil;
        
        if (setArray.count) {
            clearTopSql = [NSString stringWithFormat:@"UPDATE 'T_USERSETING' SET User_SessionID = '%@' WHERE User_Name = '%@'",sessionID,resNO];
        } else {
            clearTopSql = [NSString stringWithFormat:@"INSERT INTO  T_USERSETING (User_Name ,User_SessionID) VALUES ('%@','%@')",resNO,sessionID];
        }
        
        
        hiden = [db executeUpdate:clearTopSql];
    }];
    return hiden;
}
@end
//{
//    __block NSInteger unreadMessageCount;
//    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
//
//        NSString *sql = nil;
//        if ([inHushengString rangeOfString:CardStr].location != NSNotFound) {
//            sql = [NSString stringWithFormat:@"SELECT sum(PUSH_MSG_Read) unread FROM T_PUSH_MSG WHERE  PUSH_MSG_Code IN (%@)",inHushengString] ;
//        }else if ([inDingDanString rangeOfString:CardStr].location != NSNotFound) {
//            sql = [NSString stringWithFormat:@"SELECT sum(PUSH_MSG_Read) unread FROM T_PUSH_MSG WHERE  PUSH_MSG_Code IN (%@)",inDingDanString] ;
//        }else if ([inapplicantString rangeOfString:CardStr].location != NSNotFound) {
//            sql = [NSString stringWithFormat:@"SELECT sum(PUSH_MSG_Read) unread FROM T_PUSH_MSG WHERE  PUSH_MSG_Code IN (%@)",inapplicantString] ;
//        }else if (CardStr.length > 11) {
//            sql = [NSString stringWithFormat:@"SELECT sum(%@) unread FROM %@ WHERE MSG_Card = '%@'",GYHDDataBaseCenterMessageIsRead,GYHDDataBaseCenterMessageTableName,CardStr];
//
//        }
//        FMResultSet *unreadSet =  [db executeQuery:sql];
//        while (unreadSet.next) {
//            unreadMessageCount = [unreadSet intForColumn: @"unread"];
//        }
//    }];
//
//    if (unreadMessageCount > 99 ) {
//        return @"99+";
//    }
//    if (unreadMessageCount < 1) {
//        return nil;
//    }
//    return [NSString stringWithFormat:@"%ld",unreadMessageCount];
//
//}

//{
//    __block BOOL clearUnread = YES;
//
//    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
////        NSString *clearUnreadSql = [NSString stringWithFormat:@"UPDATE T_MESSAGE SET MSG_Read = 0 WHERE MSG_Card = '%@'",CardStr];
//        NSString *custID = nil;
//        if (CardStr.length > 11) {
//            custID = [CardStr substringToIndex:11];
//        }else {
//            custID = CardStr;
//        }
//      NSString *clearUnreadSql = [NSString stringWithFormat:@"UPDATE T_MESSAGE SET MSG_Read = 0 WHERE MSG_Card LIKE '%%%@%%'",custID];
//        clearUnread = [db executeUpdate:clearUnreadSql];
//    }];
//    return clearUnread;
//}
//
//        //1.查询互生新闻
//        [pushSelectLastArray addObject:  [weakSelf selePushWith:db messageType:GYHDDataBaseCenterMessageTypeHuShengNews]];
//        //2.查询互生消息
//        [pushSelectLastArray addObject:  [weakSelf selePushWith:db messageType:GYHDDataBaseCenterMessageTypeHuSheng]];
//        //3.查询订单消息
//        [pushSelectLastArray addObject:  [weakSelf selePushWith:db messageType:GYHDDataBaseCenterMessageTypeDingDan]];
//        //4.查询订阅消息
//        [pushSelectLastArray addObject:  [weakSelf selePushWith:db messageType:GYHDDataBaseCenterMessageTypeDingYue]];
//        //5.查询服务消息
//        [pushSelectLastArray addObject:  [weakSelf selePushWith:db messageType:GYHDDataBaseCenterMessageTypeFuWu]];
//
//5.查询及时聊天
//        NSString *chatSelectSql = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE id IN(SELECT max(id) FROM '%@' WHERE(MSG_Type == %ld) GROUP BY %@) ORDER BY id desc",GYHDDataBaseCenterMessageTableName,GYHDDataBaseCenterMessageTableName,GYHDDataBaseCenterMessageTypeChat,GYHDDataBaseCenterMessageCard];
//        NSString *chatSelectSql = [NSString stringWithFormat:@"select * from\
//                                   (SELECT * FROM 'T_MESSAGE' WHERE id IN(SELECT max(id) FROM 'T_MESSAGE' WHERE(MSG_Type == 15) GROUP BY MSG_Card)) tm,(SELECT * FROM T_USERSETING) tu\
//                                   WHERE tm.MSG_Card = tu.User_Name ORDER BY tu.User_MessageTop, tm.MSG_Card"];

//        NSString *chatSelectSql = @"select * from\
//        (SELECT * FROM 'T_MESSAGE' WHERE id IN(SELECT max(id) FROM 'T_MESSAGE' WHERE(MSG_Type == 15) GROUP BY MSG_Card)) tm LEFT join\ (SELECT * FROM T_USERSETING) tu\
//        ON tm.MSG_Card = tu.User_Name ORDER BY tu.User_MessageTop DESC, tm.MSG_ID DESC";
//        NSString *chatSelectSql = @"select * from\
//        (SELECT * FROM 'T_MESSAGE' WHERE id IN(SELECT max(id) FROM 'T_MESSAGE' WHERE(MSG_Type == 15) GROUP BY MSG_Card)) tm LEFT join (SELECT * FROM T_USERSETING) tu\
//        ON tm.MSG_Card = tu.User_Name LEFT JOIN T_FRIENDS ON tm.MSG_Card = T_FRIENDS.Friend_CustID ORDER BY tu.User_MessageTop DESC, tm.MSG_ID DESC";
//        NSString *chatSelectSql = @"select * from\
//        (SELECT * FROM 'T_MESSAGE' WHERE id IN ( SELECT max(id)FROM (SELECT T_MESSAGE.*,SUBSTR(T_MESSAGE.MSG_Card,0,11) MSGCardSub FROM T_MESSAGE) newTM WHERE (MSG_Type == 15)GROUP BY newTM.MSGCardSub)) tm LEFT join (SELECT * FROM T_USERSETING) tu\
//        ON tm.MSG_Card = tu.User_Name LEFT JOIN T_FRIENDS ON tm.MSG_Card = T_FRIENDS.Friend_CustID ORDER BY tu.User_MessageTop DESC, tm.MSG_ID DESC";
//        NSString *chatSelectSql = @"select * from(SELECT * FROM 'T_MESSAGE' WHERE id IN ( SELECT max(id)FROM (SELECT T_MESSAGE.*,SUBSTR(T_MESSAGE.MSG_Card,0,11) MSGCardSub FROM T_MESSAGE) newTM GROUP BY newTM.MSGCardSub)) tm LEFT join (SELECT * FROM T_USERSETING) tu ON tm.MSG_Card = tu.User_Name LEFT JOIN T_FRIENDS ON tm.MSG_Card = T_FRIENDS.Friend_CustID ORDER BY tu.User_MessageTop DESC, tm.MSG_ID DESC";
//        FMResultSet *chatSet =  [db executeQuery:chatSelectSql];
//        NSMutableArray *messageSelectLastArray = [NSMutableArray array];
//        while (chatSet.next) {
//            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[chatSet resultDictionary]];
//            [messageSelectLastArray addObject:dict];
//        }
//        [selectArray addObject:pushSelectLastArray];
//        [selectArray addObject:messageSelectLastArray];
//        selectArray = messageSelectLastArray;

//- (NSArray <NSDictionary *> *)selectGroupMessage {
//    __block NSMutableArray *selectArray = [NSMutableArray array];
//    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
//
////        NSString *pushSelectSql = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE id IN(SELECT max(id) FROM '%@' WHERE(MSG_Type <> %ld) GROUP BY %@)",
////                                   GYHDDataBaseCenterMessageTableName,GYHDDataBaseCenterMessageTableName,GYHDDataBaseCenterMessageTypeChat,GYHDDataBaseCenterMessageCode];
//        NSString *pushSelectSql = @"SELECT * FROM T_PUSH_MSG WHERE PUSH_MSG_ID IN(SELECT MAX(PUSH_MSG_ID) FROM T_PUSH_MSG WHERE PUSH_MSG_Code != 4101 GROUP BY PUSH_MSG_PlantFormID)";
//        FMResultSet *pushSet = [db executeQuery:pushSelectSql];
//        while (pushSet.next) {
//            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[pushSet resultDictionary]];
//            [[GYHDMessageCenter sharedInstance] checkDict:dict];
//            [selectArray addObject:dict];
//        }
//
//        NSString *friendApplicantdSql = @"SELECT * FROM T_PUSH_MSG WHERE PUSH_MSG_ID IN(SELECT MAX(PUSH_MSG_ID) FROM T_PUSH_MSG WHERE PUSH_MSG_Code = 4101 GROUP BY PUSH_MSG_PlantFormID)";
//        FMResultSet *friendApplicantdSet = [db executeQuery:friendApplicantdSql];
//        while (friendApplicantdSet.next) {
//            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[pushSet resultDictionary]];
//            [[GYHDMessageCenter sharedInstance] checkDict:dict];
//            [selectArray addObject:dict];
//        }
//
//        NSString *chatSelectSql = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE id IN(SELECT max(id) FROM '%@' WHERE(MSG_Type == %ld) GROUP BY %@) ORDER BY id desc", GYHDDataBaseCenterMessageTableName, GYHDDataBaseCenterMessageTableName, (long)GYHDDataBaseCenterMessageTypeChat, GYHDDataBaseCenterMessageCard];
//
//        FMResultSet *chatSet = [db executeQuery:chatSelectSql];
//        while (chatSet.next) {
//            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[chatSet resultDictionary]];
//            [[GYHDMessageCenter sharedInstance] checkDict:dict];
//            [selectArray addObject:dict];
//        }
//
//
//    }];
//
//    return selectArray;
//}

//NSInteger const GYHDProtobufMessage01001    = ;
///**意外伤害保障生效 01006*/
//NSInteger const GYHDProtobufMessage01006    = ;
///**意外伤害保障失效 01007*/
//NSInteger const GYHDProtobufMessage01007    = ;
///**免费医疗计划 01008*/
//NSInteger const GYHDProtobufMessage01008    = ;
///**企业操作员绑定消费者互生卡 01009*/
//NSInteger const GYHDProtobufMessage01009    = ;
/**
 * 更新好友基本信息
 */
//- (void)updateFriendBaseWithDict:(NSDictionary *)dict {
//    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
//        NSString *friendID = dict[GYHDDataBaseCenterFriendBasicAccountID];
//        NSString *custID = dict[GYHDDataBaseCenterFriendBasicCustID];
//        NSString *teamID = dict[GYHDDataBaseCenterFriendBasicTeamId];
//        NSString *mssagetyep = dict[GYHDDataBaseCenterFriendMessageType];
//
//        NSString *pattern = @"[a-zA-Z]+_";
//        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
//        // 2.测试字符串
//        NSArray *results = [regex matchesInString:friendID options:0 range:NSMakeRange(0, friendID.length)];
//        // 3.遍历结果
//        NSTextCheckingResult *result = [results firstObject];
//        NSString *type = [friendID substringWithRange:result.range];
//
//
//        NSString *friendBase = [self dictionaryToString:dict];
//        NSString *updateFriendSql = [NSString stringWithFormat:
//                                     @"REPLACE INTO T_FRIENDS(\
//                                     Friend_ID,\
//                                     Friend_CustID,\
//                                     Friend_UserType,\
//                                     'Friend_MessageType',\
//                                     Tream_ID,\
//                                     Friend_MessageTop,\
//                                     Friend_Basic,\
//                                     Friend_detailed\
//                                     )VALUES(\
//                                     '%@',\
//                                     '%@',\
//                                     '%@',\
//                                     '%@',\
//                                     '%@',\
//                                     (SELECT Friend_MessageTop FROM T_FRIENDS WHERE Friend_ID = '%@'),\
//                                     '%@',\
//                                     '%@'\
//                                     )", friendID, custID, type, mssagetyep, teamID, friendID, friendBase, friendBase];
//
//        [db executeUpdate:updateFriendSql];
//    }];
//}
//- (BOOL)ReplaceInfoWithDict:(NSDictionary *)dict TableName:(NSString *)tableName {
//    __block BOOL reBool = NO;
//    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
//        NSMutableString *FieldString = [NSMutableString string];
//        NSMutableString *valueString = [NSMutableString string];
//
//        for (NSString *key in dict.allKeys) {
//            [FieldString appendFormat:@" %@ ,", key];
//            [valueString appendFormat:@" %@ ,", dict[key]];
//        }
//        if (FieldString.length > 1) {
//            [FieldString substringToIndex:FieldString.length-1];
//            [valueString substringToIndex:valueString.length-1];
//        }
//        NSString *replaceSql = [NSString stringWithFormat:@"REPLACE INTO T_FRIENDS %@ ( %@ )VALUES( %@ )", tableName, FieldString, valueString];
//        reBool = [db executeUpdate:replaceSql];
//    }];
//    return reBool;
//}

/**更新企业基本信息*/
//- (void)updateCompanyBaseWithDict:(NSDictionary *)dict {
//
//    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
//        NSString *friendID = dict[GYHDDataBaseCenterFriendBasicAccountID];
//        NSString *custID = dict[GYHDDataBaseCenterFriendBasicCustID];
//        NSString *teamID = dict[GYHDDataBaseCenterFriendBasicTeamId];
//
//
//        NSString *pattern = @"[a-zA-Z]+_";
//        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
//        // 2.测试字符串
//        NSArray *results = [regex matchesInString:friendID options:0 range:NSMakeRange(0, friendID.length)];
//        // 3.遍历结果
//        NSTextCheckingResult *result = [results firstObject];
//        NSString *type = [friendID substringWithRange:result.range];
//
//
//        NSString *friendBase = [self dictionaryToString:dict];
//        NSString *updateFriendSql = [NSString stringWithFormat:
//                                     @"REPLACE INTO T_FRIENDS(\
//                                     Friend_ID,\
//                                     Friend_CustID,\
//                                     Friend_UserType,\
//                                     Tream_ID,\
//                                     Friend_MessageTop,\
//                                     Friend_Basic,\
//                                     Friend_detailed\
//                                     )VALUES(\
//                                     '%@',\
//                                     '%@',\
//                                     '%@',\
//                                     '%@',\
//                                     (SELECT Friend_MessageTop FROM T_FRIENDS WHERE Friend_ID = '%@'),\
//                                     '%@',\
//                                     (SELECT Friend_detailed FROM T_FRIENDS WHERE Friend_ID = '%@')\
//                                     )", friendID, custID, type, teamID, friendID, friendBase, friendID];
//
//        [db executeUpdate:updateFriendSql];
//    }];
//}
//
/**插入好友基本信息*/
//- (void)insertFriendBaseWithDict:(NSDictionary *)dict {
//    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
//        NSMutableString *sql1 = [NSMutableString stringWithFormat:@"INSERT INTO %@ (", GYHDDataBaseCenterFriendTableName];
//        NSMutableString *sql2 = [NSMutableString stringWithString:@" VALUES ("];
//        for (NSString *field in [dict allKeys]) {
//            [sql1 appendFormat:@"%@,", field];
//            [sql2 appendFormat:@"'%@',", dict[field]];
//        }
//        NSMutableString *sql3 = [NSMutableString stringWithString:[sql1 substringToIndex:sql1.length - 1]];//删除最后一个逗号
//        [sql3 appendString:@")"];
//        [sql3 appendString:[sql2 substringToIndex:sql2.length - 1]];//删除最后一个逗号
//        [sql3 appendString:@")"];//组合完成
//        [db executeUpdate:sql3];
//    }];
//}

//{
//    __block int unreadMessageCount = 0;
//    if (CardStr.integerValue != GYHDDataBaseCenterMessageTypeChat) {
//
//        [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
//            NSString *unreadMessageCountSql = [NSString stringWithFormat:@"SELECT sum(%@) unread FROM %@ WHERE PUSH_MSG_PlantFormID = '%@'",GYHDDataBaseCenterPushMessageIsRead,GYHDDataBaseCenterPushMessageTableName,CardStr];
//            FMResultSet *unreadSet =  [db executeQuery:unreadMessageCountSql];
//            while (unreadSet.next) {
//                unreadMessageCount = [unreadSet intForColumn: @"unread"];
//            }
//        }];
//    } else {
//        [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
//            NSString *unreadMessageCountSql = [NSString stringWithFormat:@"SELECT sum(%@) unread FROM %@ WHERE MSG_Card = '%@'",GYHDDataBaseCenterMessageIsRead,GYHDDataBaseCenterMessageTableName,CardStr];
//            FMResultSet *unreadSet =  [db executeQuery:unreadMessageCountSql];
//            while (unreadSet.next) {
//                unreadMessageCount = [unreadSet intForColumn: @"unread"];
//            }
//        }];
//    }
//
//    if (unreadMessageCount > 99 ) {
//        return @"99+";
//    }
//    if (unreadMessageCount < 1) {
//        return nil;
//    }
//    return [NSString stringWithFormat:@"%d",unreadMessageCount];
//}
//    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
//        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE %@ like '%%%@%%'",GYHDDataBaseCenterMessageTableName,GYHDDataBaseCenterMessageCard,messageCard];
//        deleteState = [db executeUpdate:deleteSql];
//    }];
//SELECT * FROM T_PUSH_MSG,T_USERSETING WHERE
//PUSH_MSG_Code IN ( 2001,2002,2003,2004,2005,2006,2007,2008,2021,2022,2023,2024,2025,2026,2027,2028,2029  )
//AND SUBSTR(T_PUSH_MSG.PUSH_MSG_Code,0,2)  = SUBSTR(T_USERSETING.User_Name,0,2)
//ORDER BY PUSH_MSG_ID,User_Name DESC LIMIT 0 ,1
/**
 * 查询某种类型的所有消息
 */
//- (NSArray *)selectAllMessageListWithMessageCard:(NSString *)messageCard {
//    __block NSMutableArray *messageListArray = [NSMutableArray array];
//    if (messageCard.integerValue != GYHDDataBaseCenterMessageTypeChat) {
//
//        [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
//            NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM T_PUSH_MSG WHERE PUSH_MSG_PlantFormID = '%@' ORDER BY PUSH_MSG_PlantFormID DESC ", messageCard ];
//            FMResultSet *set = [db executeQuery:selectSql];
//            while (set.next) {
//                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[set resultDictionary]];
//                [[GYHDMessageCenter sharedInstance] checkDict:dict];
//                [messageListArray addObject:dict];
//            }
//        }];
//    } else {
//        [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
//
//        }];
//    }
//
////    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
////        NSString
////    }];
////    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
////        NSString *selectDingdanListSql = [NSString stringWithFormat:@"SELECT * FROM T_MESSAGE WHERE MSG_Type = '%@' ORDER BY MSG_ID DESC ",messageCard];
////        FMResultSet *dingDanListSet = [db executeQuery:selectDingdanListSql];
////        while (dingDanListSet.next) {
////            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[dingDanListSet resultDictionary]];
////
////            [[GYHDMessageCenter sharedInstance] checkDict:dict];
////            [messageListArray addObject:dict];
////        }
////
////    }];
////    NSMutableArray *GroupMessageArray = [NSMutableArray array];
////    [GroupMessageArray addObject:messageListArray];
////    return GroupMessageArray;
//    return messageListArray;
//}

//- (NSDictionary *)selectFriendDetailWithAccountID:(NSString *)AccountID {
//    __block NSMutableDictionary *friendDetailDict = [NSMutableDictionary dictionary];
//    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
//        NSString *selectFriendDetailSql = [NSString stringWithFormat:@"SELECT Friend_detailed FROM T_FRIENDS WHERE Friend_ID = '%@'", AccountID];
//        FMResultSet *friendDetalSet = [db executeQuery:selectFriendDetailSql];
//        while (friendDetalSet.next) {
//            friendDetailDict = [NSMutableDictionary dictionaryWithDictionary:[GYUtils stringToDictionary:[friendDetalSet stringForColumn:@"Friend_detailed"]]];
//        }
//    }];
//    [[GYHDMessageCenter sharedInstance] checkDict:friendDetailDict];
//    return friendDetailDict;
//}
//
//- (NSArray *)selectAllDingDanList {
//    __block NSMutableArray *dingDanListArray = [NSMutableArray array];
//    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
//        NSString *selectDingdanListSql = [NSString stringWithFormat:@"SELECT * FROM T_MESSAGE WHERE MSG_Type = '%ld'", (long)GYHDDataBaseCenterMessageTypeDingDan];
//        FMResultSet *dingDanListSet = [db executeQuery:selectDingdanListSql];
//        while (dingDanListSet.next) {
//            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[dingDanListSet resultDictionary]];
//
//            [[GYHDMessageCenter sharedInstance] checkDict:dict];
//            [dingDanListArray addObject:dict];
//        }
//
//    }];
//
//    NSMutableArray *GroupDingdanArray = [NSMutableArray array];
//    [GroupDingdanArray addObject:dingDanListArray];
//    return GroupDingdanArray;
//}
//-(NSInteger)countWithCustID:(NSString *)CustID {
//    __block NSInteger count = 0;
//    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
//        NSString *countString = [NSString stringWithFormat:@"SELECT COUNT(1) count FROM T_MESSAGE WHERE MSG_Card = '%@'",CustID];
//        FMResultSet *countSet = [db executeQuery:countString];
//        while (countSet.next) {
//            count = [countSet intForColumn: @"count"];
//        }
//    }];
//    return count;
//}

//- (void)updateFriendDetailWithDict:(NSDictionary *)dict {
//    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
//        NSString *friendID = dict[GYHDDataBaseCenterFriendBasicAccountID];
//        NSString *friendDetail = [self dictionaryToString:dict];
//        NSString *friendDetailSql = [NSString stringWithFormat:@"UPDATE T_FRIENDS SET Friend_detailed = '%@' WHERE Friend_ID = '%@'", friendDetail, friendID];
//
//        [db executeUpdate:friendDetailSql];
//    }];
//}
//- (NSDictionary *)selePushWith:(FMDatabase *)db messageType:(GYHDDataBaseCenterMessageType)messageType {
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    NSString *pushSelectDYSql = [NSString stringWithFormat:@"SELECT * FROM T_MESSAGE WHERE MSG_Card = '%ld' ORDER by  MSG_ID DESC LIMIT 0,1", (long)messageType];
//    FMResultSet *pushSelectDYSet = [db executeQuery:pushSelectDYSql];
//    while (pushSelectDYSet.next) {
//        dict = [NSMutableDictionary dictionaryWithDictionary:[pushSelectDYSet resultDictionary]];
//        [[GYHDMessageCenter sharedInstance] checkDict:dict];
//    }
//
//
//    if (![dict count]) {
//        NSMutableDictionary *zeroDict = [NSMutableDictionary dictionary];
//
//        zeroDict[@"ID"] = @"";
//        zeroDict[@""] = [NSString stringWithFormat:@"{\"msg_code\":\"101\",\"msg_content\":\"\",\"msg_id\":\"170\",\"msg_subject\":\"\",\"msg_type\":\"1\",\"sub_msg_code\":\"1010208\"}"];
//        zeroDict[@"MSG_Body"] = @"";
//        zeroDict[@"MSG_Card"] = [NSString stringWithFormat:@"%ld", (long)messageType];
//        zeroDict[@"MSG_DataString"] = @"";
//        zeroDict[@"MSG_FromID"] = @"";
//        zeroDict[@"MSG_ID"] = @"";
//        zeroDict[@"MSG_Read"] = @"0";
//        zeroDict[@"MSG_RecvTime"] = @"";
//        zeroDict[@"MSG_Self"] = @"0";
//        zeroDict[@"MSG_SendTime"] = @"";
//        zeroDict[@"MSG_State"] = @"";
//        zeroDict[@"MSG_ToID"] = @"";
//        zeroDict[@"MSG_Type"] = [NSString stringWithFormat:@"%ld", (long)messageType];
//        dict = zeroDict;
//    }
//
//    return dict;
//}
