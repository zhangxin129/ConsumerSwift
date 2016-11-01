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

//- (BOOL)saveMessageWithDict:(NSDictionary *)dict;
/**
 * 消息分两个数组， 一个数组为推送消息，一个数组为及时聊天消息，小数组里包含每条消息的最后一条记录的字典
 */
- (NSArray<NSDictionary*>*)selectLastGroupMessage;
/**查询推送消息*/
- (NSArray<NSDictionary*>*)selectPushWithMessageCode:(NSString*)messageCode from:(NSInteger)from to:(NSInteger)to;
/**
 * 查询每种消息未读统计
 */
- (NSString*)UnreadMessageCountWithCard:(NSString*)CardStr;
/**
 * 查询所有消息未读统计
 */
- (NSInteger)UnreadAllMessageCount;
/**
 * 保存数据库路劲
 */
- (void)savedbFull:(NSString*)dbFull;
/**
 * 清零已读信息
 */
- (BOOL)ClearUnreadMessageWithCard:(NSString*)CardStr;
/**
 * 查询所以聊天记录
 */
- (NSArray<NSDictionary*>*)selectAllChatWithCard:(NSString*)cardStr frome:(NSInteger)from to:(NSInteger)to;
/**插入好友基本信息*/
- (BOOL)insertInfoWithDict:(NSDictionary*)dict TableName:(NSString*)tableName;
/**更新好友分组信息*/
- (void)updateFriendTeamWtihDict:(NSDictionary*)dict;
/**查询好友分组信息*/
//- (NSArray *)selectFriendTeam;
/**删除某个消息ID删除数据*/
- (BOOL)deleteWithMessage:(NSString*)message fieldName:(NSString*)fieldName TableName:(NSString*)tableName;
/**查询未某内分组用户*/
- (NSArray*)selectFriendWithTeamID:(NSString*)teamID;
/**获取某个好友基本信息*/
- (NSDictionary*)selectfriendBaseWithCardStr:(NSString*)CardStr;
/**
 * 获取好友列表
 */
- (NSArray<NSArray<NSDictionary*>*>*)selectFriendList;
/**获取好友列表信息*/
- (NSArray<NSArray<NSDictionary*>*>*)selectFriendBaseList;
/**获取关注企业列表*/
- (NSArray<NSDictionary*>*)selectFocusCompanyList;

/**统计某种消息数量相关记录*/
- (NSInteger)countWithCustID:(NSString*)CustID searchString:(NSString*)string;

/**
 *  更改消息发送状态
 */
- (BOOL)updateMessageStateWithMessageID:(NSString*)messageID State:(GYHDDataBaseCenterMessageSendStateOption)state;
/**
 * 消息置顶
 */
- (BOOL)messageTopWithMessageCard:(NSString*)messageCard;
/**
 * 消息取消置顶
 */
- (BOOL)messageClearTopWithMessageCard:(NSString*)messageCard;
/**设置隐藏消息*/
- (BOOL)setMessageHidenWithCustID:(NSString *)CustID;
/**清除隐藏消息*/
- (BOOL)clearMessageHidenWithCustID:(NSString *)CustID;
/**查询置顶消息数量*/
- (NSInteger)selectCountMessageTop;
/**
 * 删除消息
 */
- (BOOL)deleteMessageWithMessageCard:(NSString*)messageCard;
/**根据某个字段删除消息*/
- (BOOL)deleteMessageWithMessage:(NSString*)message fieldName:(NSString*)fieldName;
/**查询数据发送状态*/
- (NSArray<NSDictionary*>*)selectSendState:(GYHDDataBaseCenterMessageSendStateOption)option;
/**更新某个字段值*/
- (BOOL)updateMessageWithMessageID:(NSString*)messageID fieldName:(NSString*)fieldName updateString:(NSString*)updateString;

- (BOOL)updateInfoWithDict:(NSDictionary*)dict conditionDict:(NSDictionary*)conditionDict TableName:(NSString*)tableName;
/**删除数据*/
- (BOOL)deleteInfoWithDict:(NSDictionary*)dict TableName:(NSString*)tableName;
/**
 *  根据关键字查找信息
 *
 *  @param string 关键字
 *
 *  @return 消息数组
 */
- (NSArray*)selectSearchMessageWithString:(NSString*)string;
/**查询自己信息*/
- (NSDictionary*)selectMyInfo;
/**查询咨询企业信息*/
//- (NSDictionary *)selectCompanyWithCustID:(NSString *)custID;
///**查询关注企业信息 多条件为AND*/
- (NSArray*)selectInfoWithDict:(NSDictionary*)condDict TableName:(NSString*)tableName;
/**查询消息条件= 等于状态*/
- (NSArray*)selectInfoEqualDict:(NSDictionary*)condDict TableName:(NSString*)tableName;
/**更新好友申请选择统计*/
- (BOOL)updataFriendSelectCount:(NSString*)count custID:(NSString*)custID;
- (NSArray *)selectApplicationFriend;
- (NSArray *)searchMessageListWithString:(NSString *)string custID:(NSString *)custID;
/**更新企业SessionID*/
- (BOOL)setMessageSessionID:(NSString *)sessionID resNO:(NSString *)resNO;
@end
///**
// * 查询每种消息最后一条记录
// */
//- (NSArray <NSDictionary *> *)selectGroupMessage;
/**
 * 更新好友基本信息
 */
//- (void)updateFriendBaseWithDict:(NSDictionary *)dict;
/**替换好友基本信息*/
//- (BOOL)ReplaceInfoWithDict:(NSDictionary *)dict TableName:(NSString *)tableName;
/**更新企业基本信息*/
//- (void)updateCompanyBaseWithDict:(NSDictionary *)dict;
/**插入好友基本信息*/
//- (void)insertFriendBaseWithDict:(NSDictionary *)dict;
/**
 * 更新好友详细信息
 */
//- (void)updateFriendDetailWithDict:(NSDictionary *)dict;

/**
 * 获取某个好友详细信息
 */
//- (NSDictionary *)selectFriendDetailWithAccountID:(NSString *)AccountID;
//- (NSArray <NSArray <NSDictionary *>*>*)selectFriendDetailWithAccountID:(NSString *)AccountID;
/**
 * 查询所有订单消息
 */
//- (NSArray *)selectAllDingDanList;
/**统计某种消息数量*/
//-(NSInteger)countWithCustID:(NSString *)CustID;
/**
 * 查询某种类型的所有消息
 */
//- (NSArray *)selectAllMessageListWithMessageCard:(NSString *)messageCard;



