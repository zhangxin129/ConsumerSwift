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
#import "GYHDUtils.h"
#import <FMDB/FMDB.h>

@interface GYHDDataBaseCenter()
@property (nonatomic,strong)FMDatabaseQueue *IMdatabaseQueue;
@end

@implementation GYHDDataBaseCenter

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

- (id)copyWithZone:(NSZone *)zone
{
    return instance;
}
//******************** by wangbiao ******************** //
- (BOOL)saveMessageWithDict:(NSDictionary *)dict
{
    
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {

        NSMutableString *sql1 = [NSMutableString stringWithFormat:@"INSERT INTO %@ (",GYHDDataBaseCenterMessageTableName ];
        NSMutableString *sql2 = [NSMutableString stringWithString:@" VALUES ("];
        
        for (NSString *field in [dict allKeys])
        {
            [sql1 appendFormat:@"%@,", field];
            
            if ([dict[field] isKindOfClass:[NSString class]]) {
                
                NSMutableString*va=[dict[field] mutableCopy];
                
                [sql2 appendFormat:@"'%@',",[va stringByReplacingOccurrencesOfString:@"'" withString:@"‘"]];
                
            }else{
                
            [sql2 appendFormat:@"'%@',", dict[field]];
                
            }
        }
        NSMutableString *sql3 = [NSMutableString stringWithString:[sql1 substringToIndex:sql1.length - 1]];//删除最后一个逗号
        [sql3 appendString:@")"];
        [sql3 appendString:[sql2 substringToIndex:sql2.length - 1]];//删除最后一个逗号
        [sql3 appendString:@")"];//组合完成
        [db executeUpdate:sql3];
        
    }];
    return  YES;
}


- (void)savedbFull:(NSString *)dbFull
{
    FMDatabaseQueue *IMdatabaseQueue = [[FMDatabaseQueue alloc] initWithPath:dbFull];
    _IMdatabaseQueue = IMdatabaseQueue;
    [IMdatabaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
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
        [messageSql appendFormat:@"'%@' VARCHAR(50),", GYHDDataBaseCenterMessageCard];
        [messageSql appendFormat:@"'%@' VARCHAR(50),", GYHDDataBaseCenterMessageUserState];
        [messageSql appendFormat:@"'%@' VARCHAR(50),", GYHDDataBaseCenterMessageChatType];
        [messageSql appendFormat:@"'%@' VARCHAR(50),", GYHDDataBaseCenterMessageFileBasePath];
        [messageSql appendFormat:@"'%@' VARCHAR(50),", GYHDDataBaseCenterMessageFileDetailPath];
        [messageSql appendFormat:@"'%@' VARCHAR(50),", GYHDDataBaseCenterMessageNetWorkBasePath];
        [messageSql appendFormat:@"'%@' VARCHAR(50),", GYHDDataBaseCenterMessageNetWorkDetailPath];
        [messageSql appendFormat:@"'%@' VARCHAR(50),", GYHDDataBaseCenterMessageFileRead];
        [messageSql appendFormat:@"'%@' TEXT       ,", GYHDDataBaseCenterMessageBody];
        
        [messageSql appendFormat:@"'%@' TEXT       ,", GYHDDataBaseCenterMessageData];
        [messageSql appendFormat:@"'%@' INTEGER    ,", GYHDDataBaseCenterMessageCode];
        [messageSql appendFormat:@"'%@' INTEGER    ,", GYHDDataBaseCenterMessageSendState];
        [messageSql appendFormat:@"'%@' INTEGER    ,", GYHDDataBaseCenterMessageIsRead];
        [messageSql appendFormat:@"'%@' INTEGER    ,", GYHDDataBaseCenterMessageIsRight];
        [messageSql appendFormat:@"'%@' INTEGER    ,", GYHDDataBaseCenterMessageDelete];
        [messageSql appendFormat:@"'%@' DATETIME   ,", GYHDDataBaseCenterMessageSendTime];
        [messageSql appendFormat:@"'%@' DATETIME   )", GYHDDataBaseCenterMessageRevieTime];
        
        //2. 创建好友数据库
        NSMutableString *friendSql = [NSMutableString stringWithFormat:
                                       @"CREATE TABLE IF NOT EXISTS %@ (", GYHDDataBaseCenterFriendTableName];
        [friendSql appendFormat:@"'%@' integer PRIMARY KEY AUTOINCREMENT,",GYHDDataBaseCenterFriendID ];
        [friendSql appendFormat:@"'%@' VARCHAR(50) UNIQUE,", GYHDDataBaseCenterFriendCustID];
        [friendSql appendFormat:@"'%@' VARCHAR(50) ,", GYHDDataBaseCenterFriendFriendID];
        [friendSql appendFormat:@"'%@' VARCHAR(50) ,", GYHDDataBaseCenterFriendUsetType];
        [friendSql appendFormat:@"'%@' VARCHAR(50),",GYHDDataBaseCenterFriendTeamTeamID ];
        [friendSql appendFormat:@"'%@' VARCHAR(50),", GYHDDataBaseCenterFriendMessageTop];
        [friendSql appendFormat:@"'%@' VARCHAR(50) ,", GYHDDataBaseCenterFriendName];
        [friendSql appendFormat:@"'%@' VARCHAR(50) ,", GYHDDataBaseCenterFriendIcon];
        [friendSql appendFormat:@"'%@' VARCHAR(50) ,", GYHDDataBaseCenterFriendSessionID];
        [friendSql appendFormat:@"'%@' TEXT       ,", GYHDDataBaseCenterFriendBasic];
        [friendSql appendFormat:@"'%@' TEXT       )", GYHDDataBaseCenterFriendDetailed];

        //3. 创建好友分组数据
        NSMutableString *friendTeamSql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",GYHDDataBaseCenterFriendTeamTableName ];
        [friendTeamSql appendFormat:@"'%@' integer PRIMARY KEY AUTOINCREMENT,", GYHDDataBaseCenterFriendTeamID];
        [friendTeamSql appendFormat:@"'%@' VARCHAR(50) UNIQUE,",GYHDDataBaseCenterFriendTeamTeamID ];
        [friendTeamSql appendFormat:@"'%@' TEXT       )",GYHDDataBaseCenterFriendTeamDetail ];
        
        //3. 用户基本信息设置
        NSMutableString *userSetingSql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",GYHDDataBaseCenterUserSetingTableName ];
        [userSetingSql appendFormat:@"'%@' integer PRIMARY KEY AUTOINCREMENT,", GYHDDataBaseCenterUserSetingID];
        [userSetingSql appendFormat:@"'%@' VARCHAR(50) UNIQUE,",GYHDDataBaseCenterUserSetingName];
        [userSetingSql appendFormat:@"'%@' VARCHAR(50) DEFAULT '%@')",GYHDDataBaseCenterUserSetingMessageTop,GYHDDataBaseCenterUserSetingMessageTopDefualt ];
        
        NSMutableString *pushMessageSql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",GYHDDataBaseCenterPushMessageTableName ];
        [pushMessageSql appendFormat:@"'%@' integer PRIMARY KEY AUTOINCREMENT,",@"ID" ];
        [pushMessageSql appendFormat:@"'%@' VARCHAR(50) ,",GYHDDataBaseCenterPushMessageID];
        [pushMessageSql appendFormat:@"'%@' VARCHAR(50) ,",GYHDDataBaseCenterPushMessagePlantFromID];
        [pushMessageSql appendFormat:@"'%@' TEXT   VARCHAR(50) DEFAULT '-1',", GYHDDataBaseCenterPushMessageFromID];
        [pushMessageSql appendFormat:@"'%@' TEXT   VARCHAR(50) DEFAULT '-1',", GYHDDataBaseCenterPushMessageToID];
        [pushMessageSql appendFormat:@"'%@' TEXT   VARCHAR(50) DEFAULT '-1',", GYHDDataBaseCenterPushMessageSendTime];
        [pushMessageSql appendFormat:@"'%@' TEXT   VARCHAR(50) DEFAULT '-1',", GYHDDataBaseCenterPushMessageRevieTime];
        [pushMessageSql appendFormat:@"'%@' TEXT   DEFAULT '-1',", GYHDDataBaseCenterPushMessageContent];
        
        [pushMessageSql appendFormat:@"'%@' TEXT   DEFAULT '-1',",GYHDDataBaseCenterPushMessageBody];
        [pushMessageSql appendFormat:@"'%@' INTEGER   DEFAULT '-1',", GYHDDataBaseCenterPushMessageCode];
        [pushMessageSql appendFormat:@"'%@' TEXT   DEFAULT '-1',", GYHDDataBaseCenterPushMessageData];
        [pushMessageSql appendFormat:@"'%@' INTEGER   DEFAULT '-1',", GYHDDataBaseCenterPushMessageIsRead];
        [pushMessageSql appendFormat:@"'%@' INTEGER   DEFAULT '-1',", GYHDDataBaseCenterPushMessageDelete];
        [pushMessageSql appendFormat:@"'%@' INTEGER   DEFAULT -1)", GYHDDataBaseCenterPushMessageUnreadLocation];
        
        // 增加推送消息设置表
        NSString *pushSetSql = @"CREATE TABLE IF NOT EXISTS t_pushSet ('id' integer PRIMARY KEY AUTOINCREMENT,'messageMainType' VARCHAR(50) UNIQUE,'topStatus' INTEGER DEFAULT 0,'topTime' DATETIME DEAULT '')";
//        extern NSString * const ;
//        extern NSString * const ;
//        extern NSString * const ;
//        extern NSString * const ;
//        extern NSString * const ;
//        extern NSString * const ;
//        extern NSString * const ;
//        extern NSString * const ;
        NSMutableString *QuickReplySql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",GYHDDataBaseCenterQuickReplyTableName];
        [QuickReplySql appendFormat:@"'%@' integer PRIMARY KEY AUTOINCREMENT,",GYHDDataBaseCenterQuickReplyID ];
        [QuickReplySql appendFormat:@"'%@' TEXT   VARCHAR(50) DEFAULT '-1',", GYHDDataBaseCenterQuickReplyTitle];
        [QuickReplySql appendFormat:@"'%@' TEXT   VARCHAR(50) DEFAULT '-1',", GYHDDataBaseCenterQuickReplyCreateTimeStr];
        [QuickReplySql appendFormat:@"'%@' TEXT   VARCHAR(50) DEFAULT '-1',", GYHDDataBaseCenterQuickReplyUpdateTimeStr];
        [QuickReplySql appendFormat:@"'%@' TEXT   TEXT        DEFAULT '-1',", GYHDDataBaseCenterQuickReplyContent];
        [QuickReplySql appendFormat:@"'%@' TEXT   VARCHAR(50) DEFAULT '-1',", GYHDDataBaseCenterQuickReplyMsgId];
        [QuickReplySql appendFormat:@"'%@' TEXT   VARCHAR(50) DEFAULT '-1',", GYHDDataBaseCenterQuickReplyIsDefault];
        [QuickReplySql appendFormat:@"'%@' TEXT   VARCHAR(50) DEFAULT '-1')", GYHDDataBaseCenterQuickReplyCustId];
        
        [db executeUpdate:QuickReplySql];
        [db executeUpdate:pushSetSql];
        [db executeUpdate:pushMessageSql];
        [db executeUpdate:userSetingSql];
        [db executeUpdate:messageSql];
        [db executeUpdate:friendSql];
        [db executeUpdate:friendTeamSql];
        
        [self appendColumnWithdb:db TableName:GYHDDataBaseCenterMessageTableName columName:GYHDDataBaseCenterMessageContent tpeName:@"TEXT"];
        [self appendColumnWithdb:db TableName:GYHDDataBaseCenterPushMessageTableName columName:GYHDDataBaseCenterPushMessageSummary tpeName:@"TEXT"];
        
        [self appendColumnWithdb:db TableName:GYHDDataBaseCenterPushMessageTableName columName:GYHDDataBaseCenterPushMessageMainType tpeName:@"INTEGER"];
        
        [self appendColumnWithdb:db TableName:GYHDDataBaseCenterUserSetingTableName columName:@"topTime" tpeName:@"DATETIME"];

        [db commit];
    }];
}
#pragma mark 增加追加字段方法

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

/*查询订单类推送消息*/
- (NSArray *)selectPushMsgWithselectCount:(NSInteger)selectCount{
    
    NSMutableArray *messageSelectLastArray = [NSMutableArray array];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        
        long long custId = [globalData.loginModel.custId longLongValue];
        NSString*pushSelectSql=nil;
           pushSelectSql = [NSString stringWithFormat:@"SELECT * FROM T_PUSH_MSG WHERE PUSH_MSG_ToID = '%lld' AND ID IN (SELECT max(ID) FROM T_PUSH_MSG GROUP BY PUSH_MSG_ID) AND PUSH_MSG_Code IN('2501','2502','2503','2504','2505','2506','2507','2508','2509','2510','2511','2512','2513','2514','2541','2542','2543','2544','2545','2546','2547') ORDER BY PUSH_MSG_SendTime DESC,ID DESC limit 0,%ld",custId,selectCount];
        FMResultSet *pushSet =  [db executeQuery:pushSelectSql];
        while (pushSet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[pushSet resultDictionary]];
              [GYHDUtils checkDict:dict];
            [messageSelectLastArray addObject:dict];
        }
        
    }];
    
    return messageSelectLastArray;
}

/**
 * 查询push服务类型的所有消息
 */
- (NSArray *)selectPushAllFuWuMsgListWithselectCount:(NSInteger)selectCount{
    NSMutableArray *messageSelectLastArray = [NSMutableArray array];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        
        long long custId = [globalData.loginModel.custId longLongValue];
        
        NSString *pushSelectSql = [NSString stringWithFormat:@"SELECT * FROM T_PUSH_MSG WHERE PUSH_MSG_ToID = '%lld' AND ID IN (SELECT max(ID) FROM T_PUSH_MSG GROUP BY PUSH_MSG_ID) AND PUSH_MSG_Code IN('2801','2802','2803') ORDER BY PUSH_MSG_SendTime DESC,ID DESC limit 0,%ld",custId,selectCount];
        FMResultSet *pushSet =  [db executeQuery:pushSelectSql];
        while (pushSet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[pushSet resultDictionary]];
            [GYHDUtils checkDict:dict];
            [messageSelectLastArray addObject:dict];
        }
    }];
    
    return messageSelectLastArray;
}

/**
 * 查询push互生类型的所有消息
 */
- (NSArray *)selectPushAllHuShengMsgListWithselectCount:(NSInteger)selectCount{
    NSMutableArray *messageSelectLastArray = [NSMutableArray array];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        
        long long custId = [globalData.loginModel.custId longLongValue];;
        
        NSString *pushSelectSql = [NSString stringWithFormat:@"SELECT * FROM T_PUSH_MSG WHERE PUSH_MSG_ToID = '%lld' AND ID IN (SELECT max(ID) FROM T_PUSH_MSG GROUP BY PUSH_MSG_ID) AND PUSH_MSG_Code IN('1001','1002','1003','1004','1005','2531','2532','2533','1011','1012','1013','1014','1015','1016') ORDER BY PUSH_MSG_SendTime DESC,ID DESC limit 0,%ld",custId,selectCount];
        FMResultSet *pushSet =  [db executeQuery:pushSelectSql];
        while (pushSet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[pushSet resultDictionary]];
             [GYHDUtils checkDict:dict];
            [messageSelectLastArray addObject:dict];
        }
    }];
    
    return messageSelectLastArray;
}

//获取咨询中消费者最后一条消息数组
- (NSArray <NSArray <NSDictionary *>*>*)selectLastGroupChatMessage
{
    __block NSMutableArray *selectArray = [NSMutableArray array];
    
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
     
//        NSString *chatSelectSql = @"select * from(SELECT * FROM 'T_MESSAGE' WHERE id IN(SELECT max(id) FROM 'T_MESSAGE' WHERE(MSG_UserState = 'c') GROUP BY MSG_Card)) tm LEFT join (SELECT * FROM T_USERSETING) tu ON tm.MSG_Card = tu.User_Name LEFT JOIN T_FRIENDS ON tm.MSG_Card = T_FRIENDS.Friend_CustID ORDER BY tu.User_MessageTop DESC, tm.MSG_ID DESC";
        
                NSString *chatSelectSql = @"select * from(SELECT * FROM 'T_MESSAGE' WHERE id IN(SELECT max(id) FROM 'T_MESSAGE' WHERE(MSG_UserState = 'c') GROUP BY MSG_Card)) tm LEFT join (SELECT * FROM T_USERSETING) tu ON tm.MSG_Card = tu.User_Name LEFT JOIN T_FRIENDS ON tm.MSG_Card = T_FRIENDS.Friend_CustID WHERE T_FRIENDS.Friend_SessionID != '-1'  ORDER BY tu.User_MessageTop DESC, tm.MSG_ID DESC";
        
        FMResultSet *chatSet =  [db executeQuery:chatSelectSql];
        while (chatSet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[chatSet resultDictionary]];
            
             [GYHDUtils checkDict:dict];
            [selectArray addObject:dict];
        }
    }];
    
    return selectArray;
}

//获取咨询结束消费者最后一条消息数组
- (NSArray <NSArray <NSDictionary *>*>*)selectLastGroupChatMessageEndSession
{
    __block NSMutableArray *selectArray = [NSMutableArray array];
    
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        
        NSString *chatSelectSql = @"select * from(SELECT * FROM 'T_MESSAGE' WHERE id IN(SELECT max(id) FROM 'T_MESSAGE' WHERE(MSG_UserState = 'c') GROUP BY MSG_Card)) tm LEFT join (SELECT * FROM T_USERSETING) tu ON tm.MSG_Card = tu.User_Name LEFT JOIN T_FRIENDS ON tm.MSG_Card = T_FRIENDS.Friend_CustID WHERE T_FRIENDS.Friend_SessionID = '-1'  ORDER BY tu.User_MessageTop DESC, tm.MSG_ID DESC";
        FMResultSet *chatSet =  [db executeQuery:chatSelectSql];
        while (chatSet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[chatSet resultDictionary]];
            
            [GYHDUtils checkDict:dict];
            [selectArray addObject:dict];
        }
    }];
    
    return selectArray;
}


//获取推送消息最后一条数组
- (NSArray <NSArray <NSDictionary *>*>*)selectLastGroupPushMessage
{
    __block NSMutableArray *selectArray = [NSMutableArray array];
    
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        
//        联合置顶查询数据
        NSString *pushSelectSql = @"select * from T_PUSH_MSG t1 left join t_pushSet t2 ON t1.PUSH_MSG_MainType = t2.messageMainType GROUP BY t1.PUSH_MSG_MainType order by t1.ID";
        
        FMResultSet *chatSet =  [db executeQuery:pushSelectSql];
        while (chatSet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[chatSet resultDictionary]];
            
             [GYHDUtils checkDict:dict];
            [selectArray addObject:dict];
        }
    }];
    
    return selectArray;
}

//获取聊天消息最后一条消息数组
- (NSArray <NSArray <NSDictionary *>*>*)selectLastGroupChatAllMessage
{
    __block NSMutableArray *selectArray = [NSMutableArray array];
    
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
//        联合置顶查询数据
        
        NSString *chatSelectSql = @"select * from(SELECT * FROM 'T_MESSAGE' WHERE id IN(SELECT max(id) FROM 'T_MESSAGE' GROUP BY MSG_Card)) tm LEFT join (SELECT * FROM T_USERSETING) tu ON tm.MSG_Card = tu.User_Name LEFT JOIN T_FRIENDS ON tm.MSG_Card = T_FRIENDS.Friend_CustID ORDER BY tu.User_MessageTop DESC, tm.MSG_ID DESC";
        
        FMResultSet *chatSet =  [db executeQuery:chatSelectSql];
        while (chatSet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[chatSet resultDictionary]];
            
             [GYHDUtils checkDict:dict];
            [selectArray addObject:dict];
        }
    }];
    
    return selectArray;
}

//查询消费者最后一条商品或订单消息
- (NSDictionary*)selectLastGoodsAndOrderMessageWithCustid:(NSString *)custid{
    
    __block NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        
        NSString *chatSelectSql =[NSString stringWithFormat:@"SELECT  *,max(MSG_SendTime) FROM T_MESSAGE WHERE (MSG_Type = '16' or MSG_Type = '15') AND MSG_Card = '%@'",custid];
        
        FMResultSet *chatSet =  [db executeQuery:chatSelectSql];
        while (chatSet.next) {
            dict = [NSMutableDictionary dictionaryWithDictionary:[chatSet resultDictionary]];
            
            [GYHDUtils checkDict:dict];
        }
    }];
    return dict;
}

/**
 * 查询某类推送消息未读统计
 */
- (NSString *)UnreadPushMessageCountWithMsgID:(NSString *)msgID;
{
   
    __block int unreadPushMessageCount= 0;
    
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *unreadPushMessageCountSql = [NSString stringWithFormat:@"SELECT sum(%@) unread FROM %@ WHERE PUSH_MSG_MainType = '%@'",GYHDDataBaseCenterPushMessageIsRead,GYHDDataBaseCenterPushMessageTableName,msgID];
        FMResultSet *unreadPushSet =  [db executeQuery:unreadPushMessageCountSql];
        while (unreadPushSet.next) {
            unreadPushMessageCount = [unreadPushSet intForColumn: @"unread"];
        }
    }];
    
    if (unreadPushMessageCount < 1) {
        return nil;
    }
    
    return [NSString stringWithFormat:@"%d",unreadPushMessageCount];
}

/**
 * 查询所有聊天消息未读统计
 */
- (NSString *)UnreadAllMessageCount;
{
    __block int unreadAll = 0;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *unreadAllMessageCountSql = [NSString stringWithFormat:@"SELECT sum(%@) as unread  FROM %@",GYHDDataBaseCenterMessageIsRead,GYHDDataBaseCenterMessageTableName];
        
        FMResultSet *unreadSet =  [db executeQuery:unreadAllMessageCountSql];
        while (unreadSet.next) {
            unreadAll =  [unreadSet intForColumn:@"unread"];
        }
    }];

    if (unreadAll > 99) {
    return @"99+";
    }
    if (unreadAll < 1) {
        return nil;
    }
    return [NSString stringWithFormat:@"%d",unreadAll];
}

/**
 * 查询某个人聊天消息未读统计
 */
- (NSString *)UnreadMessageCountWithCard:(NSString *)CardStr;
{
    __block int unreadMessageCount = 0;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *unreadMessageCountSql = [NSString stringWithFormat:@"SELECT sum(%@) unread FROM %@ WHERE MSG_Card = '%@'",GYHDDataBaseCenterMessageIsRead,GYHDDataBaseCenterMessageTableName,CardStr];
        FMResultSet *unreadSet =  [db executeQuery:unreadMessageCountSql];
        while (unreadSet.next) {
            unreadMessageCount = [unreadSet intForColumn: @"unread"];
        }
    }];
    
    if (unreadMessageCount < 1) {
        return nil;
    }
    return [NSString stringWithFormat:@"%d",unreadMessageCount];
}

/**
 * 查询指定用户所有消息未读统计
 */
- (NSInteger)UnreadAllMessageCountWithCard:(NSString *)CardStr;
{
    __block int unreadMessageCount = 0;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *unreadMessageCountSql = [NSString stringWithFormat:@"SELECT sum(%@) unread FROM %@",GYHDDataBaseCenterMessageIsRead,GYHDDataBaseCenterMessageTableName];
        FMResultSet *unreadSet =  [db executeQuery:unreadMessageCountSql];
        while (unreadSet.next) {
            unreadMessageCount = [unreadSet intForColumn: @"unread"];
        }
    }];
    
    __block int unreadPushMessageCount= 0;
    long long custId= [CardStr longLongValue];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *unreadPushMessageCountSql = [NSString stringWithFormat:@"SELECT sum(%@) unread FROM %@ WHERE PUSH_MSG_ToID = '%lld'",GYHDDataBaseCenterPushMessageIsRead,GYHDDataBaseCenterPushMessageTableName,custId];
        FMResultSet *unreadPushSet =  [db executeQuery:unreadPushMessageCountSql];
        while (unreadPushSet.next) {
            unreadPushMessageCount = [unreadPushSet intForColumn: @"unread"];
        }
    }];
    
    NSInteger totalMessageCount =unreadMessageCount + unreadPushMessageCount;
    
    return totalMessageCount;
}

/**
 * 清零所有已读推送信息
 */
- (BOOL)ClearUnreadPushMessageWithCard:(NSString *)CardStr
{
    __block BOOL clearUnread = YES;
    long long custId=[CardStr longLongValue];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *clearUnreadSql = [NSString stringWithFormat:@"UPDATE T_PUSH_MSG SET PUSH_MSG_Read = 0 WHERE PUSH_MSG_ToID = '%lld'",custId];
        clearUnread = [db executeUpdate:clearUnreadSql];
    }];
    return clearUnread;
}

/**
 * 清零某类已读推送信息
 */
- (BOOL)ClearUnreadPushMessageWithCard:(NSString *)CardStr mainTpye:(NSString*)mainTpye{
    
    
    __block BOOL clearUnread = YES;
    long long custId=[CardStr longLongValue];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *clearUnreadSql = [NSString stringWithFormat:@"UPDATE T_PUSH_MSG SET PUSH_MSG_Read = 0 WHERE PUSH_MSG_ToID = '%lld' AND PUSH_MSG_MainType = '%@'",custId,mainTpye];
        clearUnread = [db executeUpdate:clearUnreadSql];
    }];
    return clearUnread;
    
}

/**
 * 清零某个人已读信息
 */
- (BOOL)ClearUnreadMessageWithCard:(NSString *)CardStr
{
    __block BOOL clearUnread = YES;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *clearUnreadSql = [NSString stringWithFormat:@"UPDATE T_MESSAGE SET MSG_Read = 0 WHERE MSG_Card = '%@'",CardStr];
        clearUnread = [db executeUpdate:clearUnreadSql];
    }];
    return clearUnread;
}

/**
 * 清零某一条已读推送信息
 */
- (BOOL)ClearUnreadPushMessageWithCard:(NSString *)CardStr messageId:(NSString*)messageId{


    __block BOOL clearUnread = YES;
    long long custId=[CardStr longLongValue];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *clearUnreadSql = [NSString stringWithFormat:@"UPDATE T_PUSH_MSG SET PUSH_MSG_Read = 0 WHERE PUSH_MSG_ToID = '%lld' AND ID = '%@'",custId,messageId];
        clearUnread = [db executeUpdate:clearUnreadSql];
    }];
    return clearUnread;

}
/**
 * 清零消息
 */
- (BOOL)ClearUnreadMessage
{
    __block BOOL clearUnread = YES;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *clearUnreadSql =@"UPDATE T_MESSAGE SET MSG_Read = 0";
        clearUnread = [db executeUpdate:clearUnreadSql];
    }];
    return clearUnread;
}
/**
 * 查询所以聊天记录
 */
- (NSArray <NSDictionary *>*)selectAllChatWithCard:(NSString *)cardStr frome:(NSInteger)from to:(NSInteger)to
{
    __block NSMutableArray *chatArrayM = [NSMutableArray array];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *selectChatSql = [NSString stringWithFormat:@"SELECT * FROM (SELECT * FROM T_MESSAGE WHERE MSG_Card = '%@' ORDER BY MSG_SendTime DESC  LIMIT %ld, %ld) t ORDER BY t.MSG_SendTime ASC",cardStr,from,to];
        FMResultSet *allChatSet  = [db executeQuery:selectChatSql];
        while (allChatSet.next) {
            NSMutableDictionary *dict =  [NSMutableDictionary dictionaryWithDictionary:[allChatSet resultDictionary]];
              [GYHDUtils checkDict:dict];
            [chatArrayM addObject:dict];
        }

    }];
    return chatArrayM;
}
- (BOOL)updateMessageWithDict:(NSDictionary *)dict
{
    return YES;
}

/**
 * 更新好友基本信息
 */
- (void)updateFriendBaseWithDict:(NSDictionary *)dict
{
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *friendID   =dict[GYHDDataBaseCenterFriendBasicAccountID];
        NSString *custID     = dict[GYHDDataBaseCenterFriendBasicCustID];
        NSString *teamID     = dict[GYHDDataBaseCenterFriendBasicTeamId];
        NSString*friendIcon = dict[GYHDDataBaseCenterFriendIcon];
        NSString*type=dict[GYHDDataBaseCenterFriendUsetType];
       
        NSString*friendName=dict[GYHDDataBaseCenterFriendName];
        
        NSString *friendBase = [GYHDUtils dictionaryToString:dict];
        NSString *updateFriendSql = [NSString stringWithFormat:
                                     @"REPLACE INTO T_FRIENDS(\
                                     Friend_ID,\
                                     Friend_CustID,\
                                     Friend_Name,\
                                     Friend_Icon,\
                                     Friend_UserType,\
                                     Tream_ID,\
                                     Friend_MessageTop,\
                                     Friend_Basic,\
                                     Friend_detailed\
                                     )VALUES(\
                                     '%@',\
                                     '%@',\
                                     '%@',\
                                     '%@',\
                                     '%@',\
                                     '%@',\
                                     (SELECT Friend_MessageTop FROM T_FRIENDS WHERE Friend_ID = '%@'),\
                                     '%@',\
                                     (SELECT Friend_detailed FROM T_FRIENDS WHERE Friend_ID = '%@')\
                                     )",friendID,custID,friendName,friendIcon,type,teamID,friendID,friendBase,friendID];
        
        [db executeUpdate:updateFriendSql];
    }];
}

/**插入好友基本信息*/
- (void)insertFriendBaseWithDict:(NSDictionary *)dict {
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableString *sql1 = [NSMutableString stringWithFormat:@"INSERT INTO %@ (",GYHDDataBaseCenterFriendTableName];
        NSMutableString *sql2 = [NSMutableString stringWithString:@" VALUES ("];
        for (NSString *field in [dict allKeys])
        {
            [sql1 appendFormat:@"%@,", field];
            [sql2 appendFormat:@"'%@',", dict[field]];
        }
        NSMutableString *sql3 = [NSMutableString stringWithString:[sql1 substringToIndex:sql1.length - 1]];//删除最后一个逗号
        [sql3 appendString:@")"];
        [sql3 appendString:[sql2 substringToIndex:sql2.length - 1]];//删除最后一个逗号
        [sql3 appendString:@")"];//组合完成
        [db executeUpdate:sql3];
    }];
}

- (NSDictionary *)selectfriendBaseWithCardStr:(NSString *)CardStr
{
    __block NSMutableDictionary *friendDetailDict = [NSMutableDictionary dictionary];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {

        NSString *selectFriendDetailSql = [NSString stringWithFormat:@"SELECT * FROM T_FRIENDS WHERE Friend_CustID LIKE '%%%@%%'",CardStr];
        FMResultSet *friendDetalSet  = [db executeQuery:selectFriendDetailSql];
        while (friendDetalSet.next) {
            friendDetailDict  = [NSMutableDictionary dictionaryWithDictionary:[friendDetalSet resultDictionary]];
        }
    }];
    [GYHDUtils checkDict:friendDetailDict];
    return friendDetailDict;
}

- (void)updateFriendDetailWithDict:(NSDictionary *)dict
{
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *friendID = dict[GYHDDataBaseCenterFriendBasicAccountID];
        NSString *friendDetail = [GYHDUtils dictionaryToString:dict];
        NSString *friendDetailSql = [NSString stringWithFormat:@"UPDATE T_FRIENDS SET Friend_detailed = '%@' WHERE Friend_ID = '%@'",friendDetail,friendID];
        
        [db executeUpdate:friendDetailSql];
    }];
}

- (NSArray <NSArray <NSDictionary *>*>*)selectFriendList
{
    __block NSMutableArray *chatArrayM = [NSMutableArray array];

    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *selectChatSql = [NSString stringWithFormat:@"SELECT Friend_Basic FROM T_FRIENDS WHERE Friend_UserType = 'e' and Friend_CustID !=%@",globalData.loginModel.custId];
        FMResultSet *allChatSet  = [db executeQuery:selectChatSql];
        while (allChatSet.next) {
            [chatArrayM addObject:[GYHDUtils stringToDictionary:[allChatSet stringForColumn:@"Friend_Basic"]]];
        }
        
    }];
    return chatArrayM;
}

- (BOOL)updateMessageStateWithMessageID:(NSString *)messageID State:(GYHDDataBaseCenterMessageSendStateOption) state;
{
    __block BOOL sendState = YES;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *clearUnreadSql = [NSString stringWithFormat:@"UPDATE T_MESSAGE SET MSG_State = %ld WHERE MSG_ID  = '%@'",state,messageID];
        sendState = [db executeUpdate:clearUnreadSql];
    }];
    return sendState;
}
/**
 * 消息置顶
 */
- (BOOL)msgTopWithCustId:(NSString *)custId {
    __block BOOL Top = NO;
    
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {

        NSString *TopSql =
        [NSString stringWithFormat:@"REPLACE INTO "
         @"T_USERSETING(User_Name,User_MessageTop,topTime)"
         @"VALUES('%@','0',strftime('%%Y-%%m-%%d "
         @"%%H:%%M:%%S','now','localtime'))",
         custId];
        Top = [db executeUpdate:TopSql];
    }];
    return Top;
}
/**
 * 消息取消置顶
 */
- (BOOL)msgClearTopWhitCustId:(NSString *)custId {
    __block BOOL clearTop = NO;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *clearTopSql =
        [NSString stringWithFormat:@"UPDATE 'T_USERSETING' SET User_MessageTop "
         @"= null ,topTime =null WHERE User_Name = '%@'",
         custId];
        clearTop = [db executeUpdate:clearTopSql];
    }];
    return clearTop;
}

//推送消息置顶
- (BOOL)pushMsgTopWithMessageType:(NSString *)messageMainType{
    
    __block BOOL flag = NO;
    
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        
        
        NSString *TopSql =
        [NSString stringWithFormat:@"REPLACE INTO "
         @"t_pushSet(messageMainType,topStatus,topTime)"
         @"VALUES('%@','1',strftime('%%Y-%%m-%%d "
         @"%%H:%%M:%%S','now','localtime'))",
         messageMainType];
        flag = [db executeUpdate:TopSql];
    }];
    return flag;
    
}

//推送消息清除置顶
- (BOOL)pushMsgClearTopWithMessageType:(NSString *)messageMainType{
    
    
    __block BOOL clearTop = NO;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *clearTopSql =
        [NSString stringWithFormat:@"delete from 't_pushSet' where messageMainType =%@",
         messageMainType];
        clearTop = [db executeUpdate:clearTopSql];
    }];
    return clearTop;
}

/**
 * 删除消息
 */
- (BOOL)deleteMessageWithMessageCard:(NSString *)messageCard
{
    __block BOOL deleteState = YES;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE %@ = '%@'",GYHDDataBaseCenterMessageTableName,GYHDDataBaseCenterMessageCard,messageCard];
        deleteState = [db executeUpdate:deleteSql];
    }];
    return deleteState;
}

- (BOOL)deleteMessageWithMessage:(NSString *)message fieldName:(NSString *)fieldName {
    __block BOOL deleteState = YES;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE %@ = '%@'",GYHDDataBaseCenterMessageTableName,fieldName,message];
        deleteState = [db executeUpdate:deleteSql];
    }];
    return deleteState;
}
- (BOOL)deleteWithMessage:(NSString *)message fieldName:(NSString *)fieldName TableName:(NSString *)tableName {
    __block BOOL deleteState = YES;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *deleteSql = nil;
        if (!message || !fieldName) {
            deleteSql = [NSString stringWithFormat:@"DELETE FROM '%@'",tableName];
        }else {
            deleteSql = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE %@ = '%@'",tableName,fieldName,message];
        }
        deleteState = [db executeUpdate:deleteSql];
    }];
    return deleteState;
}

/**更新某个字段值*/
- (BOOL)updateMessageWithMessageID:(NSString *)messageID fieldName:(NSString *)fieldName updateString:(NSString *)updateString {
    __block BOOL deleteState = YES;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *deleteSql = [NSString stringWithFormat:@"UPDATE T_MESSAGE SET %@ = '%@' WHERE MSG_ID = '%@' ",fieldName,updateString,messageID];
        deleteState = [db executeUpdate:deleteSql];
    }];
    return deleteState;
}

/**查询数据发送状态*/
- (NSArray <NSDictionary *>*)selectSendState:(GYHDDataBaseCenterMessageSendStateOption)option
{
    __block NSMutableArray *sendStateArray = [NSMutableArray array];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *selectDingdanListSql = [NSString stringWithFormat:@"SELECT * FROM T_MESSAGE WHERE MSG_State = %ld ",option];
        FMResultSet *dingDanListSet = [db executeQuery:selectDingdanListSql];
        while (dingDanListSet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[dingDanListSet resultDictionary]];
            
            [GYHDUtils checkDict:dict];
            [sendStateArray addObject:dict];
        }
        
    }];
    return sendStateArray;
}
/**查询所有回复信息*/
- (NSArray <NSDictionary *> *)selectallRelpyMessage {
    // SELECT * FROM 'T_MESSAGE' WHERE id IN(SELECT max(id) FROM 'T_MESSAGE' WHERE(MSG_Type == 15) GROUP BY MSG_Card) AND MSG_Card IN ( SELECT User_Name FROM T_USERSETING WHERE User_Relp = '1');
    // SELECT * FROM  (SELECT * FROM 'T_MESSAGE' WHERE id IN(SELECT max(id) FROM 'T_MESSAGE' WHERE(MSG_Type == 15) GROUP BY MSG_Card) AND MSG_Card  IN ( SELECT User_Name FROM T_USERSETING WHERE User_Relp = '1')) tmsg LEFT JOIN T_USERSETING ON tmsg.MSG_Card = T_USERSETING.User_Name
    
    __block NSMutableArray *relpyArray = [NSMutableArray array];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        //        NSString *relpySql = @"SELECT * FROM 'T_MESSAGE' WHERE id IN(SELECT max(id) FROM 'T_MESSAGE' WHERE(MSG_Type == 15) GROUP BY MSG_Card) AND MSG_Card IN ( SELECT User_Name FROM T_USERSETING WHERE User_Relp = '1')";
        NSString *relpySql = @"SELECT\
        *\
        FROM\
        (\
        SELECT\
        *\
        FROM\
        'T_MESSAGE'\
        WHERE\
        id IN (\
        SELECT\
        max(id)\
        FROM\
        'T_MESSAGE'\
        WHERE\
        MSG_Type == 15\
        AND\
        MSG_UserState !='e'\
        GROUP BY\
        MSG_Card\
        )\
        AND MSG_Card IN (\
        SELECT\
        User_Name\
        FROM\
        T_USERSETING\
        WHERE\
        User_Relp = '1'\
        )\
        ) tmsg\
        LEFT JOIN T_FRIENDS tf ON tmsg.MSG_Card = tf.Friend_CustID LEFT JOIN T_USERSETING ON  tmsg.MSG_Card = T_USERSETING.User_Name";
        FMResultSet *relpySet =  [db executeQuery:relpySql];
        while (relpySet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[relpySet resultDictionary]];
            //            [[GYHDMessageCenter sharedInstance] checkDict:dict];
            [relpyArray addObject:dict];
        }
    }];
    return relpyArray;
}
/**查询所有未回复信息*/
- (NSArray <NSDictionary *> *)selectallNoRelpyMessage {
    //  SELECT * FROM 'T_MESSAGE' WHERE id IN(SELECT max(id) FROM 'T_MESSAGE' WHERE(MSG_Type == 15) GROUP BY MSG_Card) AND MSG_Card NOT IN ( SELECT User_Name FROM T_USERSETING WHERE User_Relp = '1');
    //           NSString *relpySql = @"SELECT * FROM 'T_MESSAGE' WHERE id IN(SELECT max(id) FROM 'T_MESSAGE' WHERE(MSG_Type == 15) GROUP BY MSG_Card) AND MSG_Card NOT IN ( SELECT User_Name FROM T_USERSETING WHERE User_Relp = '1')";
    __block NSMutableArray *relpyArray = [NSMutableArray array];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *relpySql = @"SELECT\
        *\
        FROM\
        (\
        SELECT\
        *\
        FROM\
        'T_MESSAGE'\
        WHERE\
        id IN (\
        SELECT\
        max(id)\
        FROM\
        'T_MESSAGE'\
        WHERE\
        MSG_Type == 15\
        AND\
        MSG_UserState !='e'\
        GROUP BY\
        MSG_Card\
        )\
        AND MSG_Card NOT IN (\
        SELECT\
        User_Name\
        FROM\
        T_USERSETING\
        WHERE\
        User_Relp = '1'\
        )\
        ) tmsg\
        LEFT JOIN T_FRIENDS tf ON tmsg.MSG_Card = tf.Friend_CustID LEFT JOIN T_USERSETING ON  tmsg.MSG_Card = T_USERSETING.User_Name";
        FMResultSet *relpySet =  [db executeQuery:relpySql];
        while (relpySet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[relpySet resultDictionary]];
            
            [relpyArray addObject:dict];
        }
    }];
    return relpyArray;
}

- (BOOL)updateInfoWithDict:(NSDictionary *)dict conditionDict:(NSDictionary *)conditionDict TableName:(NSString *)tableName {
    
    __block BOOL updateState = YES;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        
        NSString *updateHeaderSql = [NSString stringWithFormat:@"UPDATE %@ SET ",tableName];
        NSMutableString *updatebodySql = [NSMutableString string];
        NSMutableString *updateFooterSql = [NSMutableString string];
        
        for (NSString *key in [dict allKeys]) {
            [updatebodySql appendString:[NSString stringWithFormat:@"%@ = '%@',",key,dict[key]]];
        }
        ;
        for (NSString *key in [conditionDict allKeys]) {
            [updateFooterSql appendString: [NSString stringWithFormat:@"%@ = '%@'", key,conditionDict[key]]];
        }
        
        NSString *updateSql = [NSString stringWithFormat:@" %@ %@ WHERE %@",updateHeaderSql, [updatebodySql substringToIndex:updatebodySql.length - 1], updateFooterSql];
        
        updateState = [db executeUpdate:updateSql];
    }];
    return updateState;
    
}
/**插入好友基本信息*/
- (BOOL)insertInfoWithDict:(NSDictionary *)dict TableName:(NSString *)tableName {
    
    
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        
        NSMutableString *sql1 = [NSMutableString stringWithFormat:@"INSERT INTO %@ (",tableName];
        NSMutableString *sql2 = [NSMutableString stringWithString:@" VALUES ("];
        for (NSString *field in [dict allKeys])
        {
            [sql1 appendFormat:@"%@,", field];
            [sql2 appendFormat:@"'%@',", dict[field]];
        }
        NSMutableString *sql3 = [NSMutableString stringWithString:[sql1 substringToIndex:sql1.length - 1]];//删除最后一个逗号
        [sql3 appendString:@")"];
        [sql3 appendString:[sql2 substringToIndex:sql2.length - 1]];//删除最后一个逗号
        [sql3 appendString:@")"];//组合完成
        [db executeUpdate:sql3];
        
    }];
    return  YES;
}

- (BOOL)deleteInfoWithMessage:(NSString *)message fieldName:(NSString *)fieldName tableName:(NSString *)tableName {
    __block BOOL deleteState = YES;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE %@ like '%%%@%%'",GYHDDataBaseCenterFriendTableName,fieldName,message];
        deleteState = [db executeUpdate:deleteSql];
    }];
    return deleteState;
}

/**依据关键字搜索所有推送消息*/
- (NSArray *)selectPushMssageByKeyStr:(NSString*)keyStr{
    
    NSMutableArray *messageSelectLastArray = [NSMutableArray array];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        
        long long custId = [globalData.loginModel.custId longLongValue];
        
        NSString*pushSelectSql = [NSString stringWithFormat:@"SELECT pm.*,count(*)countrow FROM T_PUSH_MSG pm WHERE pm.PUSH_MSG_ToID = '%lld' AND ((pm.PUSH_MSG_Content LIKE '%%%@%%' AND PUSH_MSG_Code  NOT IN ('1001','1002','1003','1004','1005'))  OR pm.Summary LIKE '%%%@%%') GROUP BY PUSH_MSG_MainType ORDER BY pm.PUSH_MSG_SendTime DESC",custId,keyStr,keyStr];
        
        FMResultSet *pushSet =  [db executeQuery:pushSelectSql];
        while (pushSet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[pushSet resultDictionary]];
            [GYHDUtils checkDict:dict];
            [messageSelectLastArray addObject:dict];
        }
        
    }];
    
    return messageSelectLastArray;
}

/**查询所有推送消息*/
- (NSArray *)selectPushMssage{
    
    NSMutableArray *messageSelectLastArray = [NSMutableArray array];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        
        long long custId = [globalData.loginModel.custId longLongValue];
        NSString*pushSelectSql=nil;
        pushSelectSql = [NSString stringWithFormat:@"SELECT * FROM T_PUSH_MSG WHERE PUSH_MSG_ToID = '%lld' ORDER BY PUSH_MSG_SendTime DESC",custId];
        
        FMResultSet *pushSet =  [db executeQuery:pushSelectSql];
        while (pushSet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[pushSet resultDictionary]];
            [GYHDUtils checkDict:dict];
            [messageSelectLastArray addObject:dict];
        }
        
    }];
    
    return messageSelectLastArray;
}

/**查询客户咨询消息*/
- (NSArray *)selectCustomerMessage{
    
    NSMutableArray *messageSelectArray = [NSMutableArray array];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        
        NSString*pushSelectSql=nil;
        
        pushSelectSql = [NSString stringWithFormat:@"SELECT * FROM T_MESSAGE  WHERE MSG_UserState != 'e' ORDER BY MSG_SendTime DESC"];
        
        FMResultSet *pushSet =  [db executeQuery:pushSelectSql];
        while (pushSet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[pushSet resultDictionary]];
            [GYHDUtils checkDict:dict];
            [messageSelectArray addObject:dict];
        }
        
    }];
    
    return messageSelectArray;
}

/**查询所有企业操作员*/

- (NSArray *)selectCompanyList{
    
    NSMutableArray *SelectArray = [NSMutableArray array];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        
        NSString*pushSelectSql=nil;
        
        pushSelectSql = [NSString stringWithFormat:@"SELECT * FROM T_FRIENDS  WHERE Friend_UserType = 'e'"];
        
        FMResultSet *pushSet =  [db executeQuery:pushSelectSql];
        while (pushSet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[pushSet resultDictionary]];
            [GYHDUtils checkDict:dict];
            [SelectArray addObject:dict];
        }
        
    }];
    
    return SelectArray;
}

/**查询所有客户资料*/
- (NSArray *)selectCustomerDeTail{
    
    NSMutableArray *messageSelectArray = [NSMutableArray array];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        
        NSString*pushSelectSql=nil;
        
        pushSelectSql = [NSString stringWithFormat:@"SELECT * FROM T_FRIENDS  WHERE Friend_UserType != 'e' and Friend_UserType != ''"];
        
        FMResultSet *pushSet =  [db executeQuery:pushSelectSql];
        while (pushSet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[pushSet resultDictionary]];
            [GYHDUtils checkDict:dict];
            [messageSelectArray addObject:dict];
        }
        
    }];
    
    return messageSelectArray;
}

/**查询所有操作员消息*/
- (NSArray *)selectCompanyMessage{
    
    NSMutableArray *messageSelectArray = [NSMutableArray array];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        
        NSString*pushSelectSql=nil;
        
        pushSelectSql = [NSString stringWithFormat:@"SELECT * FROM T_MESSAGE  WHERE MSG_UserState = 'e' ORDER BY MSG_SendTime DESC"];
        
        FMResultSet *pushSet =  [db executeQuery:pushSelectSql];
        while (pushSet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[pushSet resultDictionary]];
            [GYHDUtils checkDict:dict];
            [messageSelectArray addObject:dict];
        }
        
    }];
    
    return messageSelectArray;
}

/**依据客户号查询所有聊天消息*/
- (NSArray *)selectAllChatMessageBYCustId:(NSString*)custId{
    
    NSMutableArray *messageSelectArray = [NSMutableArray array];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        
        NSString*pushSelectSql=nil;
        
        pushSelectSql = [NSString stringWithFormat:@"SELECT * FROM T_MESSAGE Where MSG_Card = '%@' ORDER BY MSG_SendTime DESC",custId];
        
        FMResultSet *pushSet =  [db executeQuery:pushSelectSql];
        while (pushSet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[pushSet resultDictionary]];
            [GYHDUtils checkDict:dict];
            [messageSelectArray addObject:dict];
        }
        
    }];
    
    return messageSelectArray;
}

/**依据搜索条件搜索所有聊天消息*/
-(NSArray *)selectAllChatMessageByKeyString:(NSString*)keyStr{
    
    NSMutableArray *messageSelectArray = [NSMutableArray array];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {

        NSString*pushSelectSql = [NSString stringWithFormat:@" SELECT * FROM (SELECT t.*,count(*)countrow  FROM T_MESSAGE t WHERE t.MSG_Content LIKE '%%%@%%' GROUP BY t.MSG_Card) tm LEFT JOIN T_FRIENDS ON tm.MSG_Card =\
                                  T_FRIENDS.Friend_CustID  ORDER BY MSG_SendTime DESC",keyStr];
        
        FMResultSet *pushSet =  [db executeQuery:pushSelectSql];
        while (pushSet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[pushSet resultDictionary]];
            [GYHDUtils checkDict:dict];
            [messageSelectArray addObject:dict];
        }
        
    }];
    
    return messageSelectArray;
}
//获取搜索消息所在行
-(NSArray*)selectChatListMessageByMessageId:(NSString*)mesId PrimaryId:(NSString*)primaryId FriendName:(NSString*)friendName IsHeaderRefresh:(BOOL)flag{

    NSMutableArray *messageSelectArray = [NSMutableArray array];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        
        NSString*pushSelectSql =nil;
        
        if (flag==YES) {
            pushSelectSql = [NSString stringWithFormat:@"SELECT * FROM (SELECT * FROM T_MESSAGE  tm WHERE MSG_Card = '%@' AND tm.ID>=%@ ORDER BY ID   LIMIT 0, 20) t  ORDER BY t.MSG_SendTime ASC",mesId,primaryId];
            
        }else {
            
            pushSelectSql = [NSString stringWithFormat:@"SELECT * FROM (SELECT * FROM T_MESSAGE  tm WHERE MSG_Card = '%@' AND tm.ID<%@ ORDER BY ID   LIMIT 0, 20) t  ORDER BY t.MSG_SendTime ASC",mesId,primaryId];

        }
    
        FMResultSet *pushSet =  [db executeQuery:pushSelectSql];
        while (pushSet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[pushSet resultDictionary]];
            [GYHDUtils checkDict:dict];
            [messageSelectArray addObject:dict];
        }
        
    }];
    
    return messageSelectArray;
    
}

/**删除数据*/
- (BOOL)deleteInfoWithDict:(NSDictionary*)dict TableName:(NSString*)tableName
{
    __block BOOL updateState = YES;
    [self.IMdatabaseQueue inDatabase:^(FMDatabase* db) {
        NSMutableString *valueName = [NSMutableString stringWithString:@""];
        if (dict) {
            for (NSString *key in dict.allKeys) {
                [valueName appendFormat:@" %@ = '%@' AND", key, dict[key]];
            }
        }
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ 1=1", tableName, valueName];
        updateState = [db executeUpdate:deleteSql];
    }];
    return updateState;
    return YES;
}

- (NSArray*)selectAllQuickReply {
    __block NSMutableArray *Array = [NSMutableArray array];
    [self.IMdatabaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sqlString = @"SELECT * FROM T_QUICKREPLY";
        FMResultSet *pushSet =  [db executeQuery:sqlString];
        while (pushSet.next) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[pushSet resultDictionary]];
            [GYHDUtils checkDict:dict];
            [Array addObject:dict];
        }
    }];
    return Array;
}

@end
