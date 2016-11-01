//
//  GYHDDataBaseCenter.h
//  HSConsumer
//
//  Created by shiang on 15/12/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYHDMessageCenter.h"

@interface GYHDDataBaseCenter : NSObject

+ (instancetype)sharedInstance;
/**
 * 根据字典更新数据
 */
- (BOOL)updateMessageWithDict:(NSDictionary *)dict;

- (BOOL)saveMessageWithDict:(NSDictionary *)dict;

/*
 查询订单类推送消息
 */
- (NSArray *)selectPushMsgWithselectCount:(NSInteger)selectCount;
/**
 * 查询push服务类型的所有消息
 */
- (NSArray *)selectPushAllFuWuMsgListWithselectCount:(NSInteger)selectCount;
/**
 * 查询push互生类型的所有消息
 */
- (NSArray *)selectPushAllHuShengMsgListWithselectCount:(NSInteger)selectCount;

//获取咨询中消费者最后一条消息数组
- (NSArray <NSArray <NSDictionary *>*>*)selectLastGroupChatMessage;

//获取咨询结束消费者最后一条消息数组
- (NSArray <NSArray <NSDictionary *>*>*)selectLastGroupChatMessageEndSession;

//获取推送消息最后一条数组
- (NSArray <NSArray <NSDictionary *>*>*)selectLastGroupPushMessage;
//获取聊天消息最后一条消息数组
- (NSArray <NSArray <NSDictionary *>*>*)selectLastGroupChatAllMessage;

//查询消费者最后一条商品或订单消息
- (NSDictionary*)selectLastGoodsAndOrderMessageWithCustid:(NSString*)custid;

/**
 * 查询某类推送消息未读统计
 */
- (NSString*)UnreadPushMessageCountWithMsgID:(NSString *)msgID;
/**
 * 查询某种种消息未读统计
 */
- (NSString *)UnreadMessageCountWithCard:(NSString *)CardStr;
/**
 * 查询所有消息未读统计
 */
- (NSString *)UnreadAllMessageCount;
/**
 * 保存数据库路劲
 */
- (void)savedbFull:(NSString *)dbFull;
/**
 * 清零已读信息
 */
- (BOOL)ClearUnreadMessageWithCard:(NSString *)CardStr;
/**
 * 清零消息
 */
- (BOOL)ClearUnreadMessage;
/**
 * 查询指定用户所有消息未读统计
 */
- (NSInteger)UnreadAllMessageCountWithCard:(NSString *)CardStr;

/**
 * 清零所有已读推送信息
 */
- (BOOL)ClearUnreadPushMessageWithCard:(NSString *)CardStr;

/**
 * 清零某类已读推送信息
 */
- (BOOL)ClearUnreadPushMessageWithCard:(NSString *)CardStr mainTpye:(NSString*)mainTpye;

/**
 * 清零某一条已读推送信息
 */
- (BOOL)ClearUnreadPushMessageWithCard:(NSString *)CardStr messageId:(NSString*)messageId;

/**
 * 查询所以聊天记录
 */
- (NSArray <NSDictionary *>*)selectAllChatWithCard:(NSString *)cardStr frome:(NSInteger)from to:(NSInteger)to;
/**
 * 更新好友基本信息
 */
- (void)updateFriendBaseWithDict:(NSDictionary *)dict;
/**插入好友基本信息*/
- (void)insertFriendBaseWithDict:(NSDictionary *)dict;
/**删除某个消息ID删除数据*/
- (BOOL)deleteWithMessage:(NSString *)message fieldName:(NSString *)fieldName TableName:(NSString *)tableName;

/**获取某个好友基本信息*/
- (NSDictionary *)selectfriendBaseWithCardStr:(NSString *)CardStr;

/**
 * 更新好友详细信息
 */
- (void)updateFriendDetailWithDict:(NSDictionary *)dict;
/**
 * 获取好友列表
 */
- (NSArray <NSArray <NSDictionary *>*>*)selectFriendList;

/**
 *  更改消息发送状态
 */
- (BOOL)updateMessageStateWithMessageID:(NSString *)messageID State:(GYHDDataBaseCenterMessageSendStateOption) state;
/**
 * 消息置顶
 */
- (BOOL)msgTopWithCustId:(NSString *)custId;
/**
 * 消息取消置顶
 */
- (BOOL)msgClearTopWhitCustId:(NSString *)custId;

//推送消息置顶
- (BOOL)pushMsgTopWithMessageType:(NSString *)messageMainType;

//推送消息清除置顶
- (BOOL)pushMsgClearTopWithMessageType:(NSString *)messageMainType;
/**
 * 删除消息
 */
- (BOOL)deleteMessageWithMessageCard:(NSString *)messageCard;
/**根据某个字段删除消息*/
- (BOOL)deleteMessageWithMessage:(NSString *)message fieldName:(NSString *)fieldName;
/**查询数据发送状态*/
- (NSArray <NSDictionary *>*)selectSendState:(GYHDDataBaseCenterMessageSendStateOption)option;
/**更新某个字段值*/
- (BOOL)updateMessageWithMessageID:(NSString *)messageID fieldName:(NSString *)fieldName updateString:(NSString *)updateString;
//查询所有未读消息
- (NSArray <NSDictionary *> *)selectallNoRelpyMessage;
//查询所有已读消息
- (NSArray <NSDictionary *> *)selectallRelpyMessage;

/**插入好友基本信息*/
- (BOOL)insertInfoWithDict:(NSDictionary *)dict TableName:(NSString *)tableName;
/*
 更新表信息
 */
- (BOOL)updateInfoWithDict:(NSDictionary *)dict conditionDict:(NSDictionary *)conditionDict TableName:(NSString *)tableName;

/**删除数据库 message为条件字符串， field条件字段， tablename为表名*/
- (BOOL)deleteInfoWithMessage:(NSString *)message fieldName:(NSString *)fieldName tableName:(NSString *)tableName;
/**依据关键字搜索所有推送消息*/
- (NSArray *)selectPushMssageByKeyStr:(NSString*)keyStr;
/**查询所有推送消息*/
- (NSArray *)selectPushMssage;

/**查询客户咨询消息*/
- (NSArray *)selectCustomerMessage;

/**查询所有客户资料*/
- (NSArray *)selectCustomerDeTail;

/**查询所有企业操作员*/
- (NSArray *)selectCompanyList;

/**查询所有操作员消息*/
- (NSArray *)selectCompanyMessage;
/**依据客户号查询所有聊天消息*/
- (NSArray *)selectAllChatMessageBYCustId:(NSString*)custId;
/**依据搜索条件搜索所有聊天消息*/
-(NSArray *)selectAllChatMessageByKeyString:(NSString*)keyStr;
//获取搜索消息所在行
-(NSArray*)selectChatListMessageByMessageId:(NSString*)mesId PrimaryId:(NSString*)primaryId FriendName:(NSString*)friendName IsHeaderRefresh:(BOOL)flag;

/**删除数据*/
- (BOOL)deleteInfoWithDict:(NSDictionary*)dict TableName:(NSString*)tableName;
/**查询所以快捷回复*/
- (NSArray*)selectAllQuickReply;
@end
