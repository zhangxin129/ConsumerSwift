//
//  GYMessageCenter.h
//  HSConsumer
//
//  Created by shiang on 15/12/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYXMPP.h"

#import "Masonry.h"
#import "GYHDProtoBufHeader.h"
#import "IMMessage.pb.h"
#import "GYHDProtoBufSocket.h"
#import "GYHDStream.h"

typedef NS_ENUM(NSInteger, GYHDPopMessageState) {
    GYHDPopMessageStateTop = 0,          // 置顶
    GYHDPopMessageStateClearTop,         // 取消置顶
};

typedef NS_ENUM(NSInteger, GYHDDataBaseCenterMessageSentStateOption) {
    GYHDDataBaseCenterMessageSentStateSuccess = 1,          // 发送成功
    GYHDDataBaseCenterMessageSentStateSending,              // 发送中
    GYHDDataBaseCenterMessageSentStateFailure               // 发送失败
};

typedef NS_ENUM(NSInteger, GYHDDataBaseCenterMessageType) {
    
    GYHDDataBaseCenterMessageChatText   = 0,                //文本消息
    GYHDDataBaseCenterMessageChatPicture= 10,               //图片消息
    GYHDDataBaseCenterMessageChatFile   = 12,               //文件消息
    GYHDDataBaseCenterMessageChatAudio  = 13,               //音频消息
    GYHDDataBaseCenterMessageChatVideo  = 14,               //视频消息
    GYHDDataBaseCenterMessageChatGoods = 15,                //商品消息
    GYHDDataBaseCenterMessageChatOrder = 16,                //订单消息
    GYHDDataBaseCenterMessageTypeChat,                      //聊天消息
    GYHDDataBaseCenterMessageTypeHuShengNews,               //互生新闻
    GYHDDataBaseCenterMessageTypeHuSheng,                   //互生消息
    GYHDDataBaseCenterMessageTypeFuWu,                      //服务消息
    GYHDDataBaseCenterMessageTypeDingDan  = 101,            //订单消息
    GYHDDataBaseCenterMessageTypeDingYue  = 102,            //订阅消息

    GYHDDataBaseCenterPush10101         = 10101,            //消费者个人消息 ----- 互生消息                                    y
    GYHDDataBaseCenterPush10102         = 10102,            //消费者个人消息 ----- 业务消息(总类)
    
    GYHDDataBaseCenterPush1010201       = 1010201,          //消费者个人消息 ----- 业务消息(小类)绑定互生卡                       y
    
    GYHDDataBaseCenterPush1010202       = 1010202,          //消费者个人消息 ----- 业务消息(小类)订单消息 -----订单支付成功
    GYHDDataBaseCenterPush1010203       = 1010203,          //消费者个人消息 ----- 业务消息(小类)订单消息 -----确认收货
    GYHDDataBaseCenterPush1010204       = 1010204,          //消费者个人消息 ----- 业务消息(小类)订单消息 -----待自提
    GYHDDataBaseCenterPush1010205       = 1010205,          //消费者个人消息 ----- 业务消息(小类)订单消息 -----取消订单
    GYHDDataBaseCenterPush1010206       = 1010206,          //消费者个人消息 ----- 业务消息(小类)订单消息 -----退款完成【订单取消】
    GYHDDataBaseCenterPush1010207       = 1010207,          //消费者个人消息 ----- 业务消息(小类)订单消息 -----退款完成【售后】
    
    GYHDDataBaseCenterPush1010208       = 1010208,          //消费者个人消息 ----- 业务消息(小类)订单消息 -----申领抵扣券消息       y
    GYHDDataBaseCenterPush1010209       = 1010209,          //消费者个人消息 ----- 意外伤害 您的互生意外伤害保障已生效              y
    GYHDDataBaseCenterPush1010210       = 1010210,          //消费者个人消息 ----- 意外伤害保障失效                              y
    GYHDDataBaseCenterPush1010211       = 1010211,          //消费者个人消息 ----- 积分投资达到10000 推送可以申请免费医疗           y
    
    GYHDDataBaseCenterPush1010212       = 1010212,          //消费者个人消息 ----- 订单消息 企业备货中
    GYHDDataBaseCenterPush1010213       = 1010213,          //消费者个人消息 ----- 订单消息 买家申请取消订单
    
    GYHDDataBaseCenterPush1010214       = 1010214,          //餐饮订单消息 -----店内订单确认
    GYHDDataBaseCenterPush1010215       = 1010215,          //餐饮订单消息 -----接单
    GYHDDataBaseCenterPush1010216       = 1010216,          //餐饮订单消息 -----拒接
    GYHDDataBaseCenterPush1010217       = 1010217,          //餐饮订单消息 -----送餐
    GYHDDataBaseCenterPush1010218       = 1010218,          //餐饮订单消息 -----打印预结单
    GYHDDataBaseCenterPush1010219       = 1010219,          //餐饮订单消息 -----商家取消预定
    GYHDDataBaseCenterPush1010220       = 1010220,          //餐饮订单消息 -----商家确认取消
    GYHDDataBaseCenterPush1010221       = 1010221,          //餐饮订单消息 -----店内订单定金支付成功
    GYHDDataBaseCenterPush1010222       = 1010222,          //餐饮订单消息 -----店内订单付款成功
    
    
    GYHDDataBaseCenterPush10201         = 10201,            //企业商品降价消息（企业-->系统-->消费者）
    GYHDDataBaseCenterPush10202         = 10202,            //企业商品下架、无货等消息（企业-->系统-->消费者）
    GYHDDataBaseCenterPush10203         = 10203,            //企业商品上新消息（企业-->系统-->消费者）
    GYHDDataBaseCenterPush10204         = 10204,            //企业的活动消息（企业-->系统-->消费者）
    
    GYHDDataBaseCenterPush10301         = 10301,            //企业商品上新消息（旧）（企业-->系统-->消费者）
    GYHDDataBaseCenterPush10302         = 10302,            //企业的活动消息  （旧）（企业-->系统-->消费者）
    
    GYHDDataBaseCenterPush50001         = 50001,            //强制用户登出指令
    GYHDDataBaseCenterPush50011         = 50011,            //好友添加请求
    GYHDDataBaseCenterPush50012         = 50012,            //好友确认
    GYHDDataBaseCenterPush50013         = 50013,            //好友拒绝
    GYHDDataBaseCenterPush50014         = 50014,            //删除好友
};

#pragma mark - push

FOUNDATION_EXPORT NSString * const GYHDDataBaseCenterPushMessageTableName;
FOUNDATION_EXPORT NSString * const GYHDDataBaseCenterPushMessageID;
FOUNDATION_EXPORT NSString * const GYHDDataBaseCenterPushMessageCode;
FOUNDATION_EXPORT NSString * const GYHDDataBaseCenterPushMessagePlantFromID;
FOUNDATION_EXPORT NSString * const GYHDDataBaseCenterPushMessageToID;
FOUNDATION_EXPORT NSString * const GYHDDataBaseCenterPushMessageFromID;
FOUNDATION_EXPORT NSString * const GYHDDataBaseCenterPushMessageContent;
FOUNDATION_EXPORT NSString * const GYHDDataBaseCenterPushMessageBody;
FOUNDATION_EXPORT NSString * const GYHDDataBaseCenterPushMessageSendTime;
FOUNDATION_EXPORT NSString * const GYHDDataBaseCenterPushMessageRevieTime;
FOUNDATION_EXPORT NSString * const GYHDDataBaseCenterPushMessageIsRead;
FOUNDATION_EXPORT NSString * const GYHDDataBaseCenterPushMessageData;
FOUNDATION_EXPORT NSString * const GYHDDataBaseCenterPushMessageUnreadLocation;
FOUNDATION_EXPORT NSString * const GYHDDataBaseCenterPushMessageMainType;
FOUNDATION_EXPORT NSString * const GYHDDataBaseCenterPushMessageSummary;

extern NSString * const GYHDDataBaseCenterMessageTableName;
extern NSString * const GYHDDataBaseCenterMessageID;
extern NSString * const GYHDDataBaseCenterMessageFromID;
extern NSString * const GYHDDataBaseCenterMessageToID;
extern NSString * const GYHDDataBaseCenterMessageBody;
extern NSString *const GYHDDataBaseCenterMessageContent;
extern NSString * const GYHDDataBaseCenterMessageCode;
extern NSString * const GYHDDataBaseCenterMessageSendTime;
extern NSString * const GYHDDataBaseCenterMessageRevieTime;
extern NSString * const GYHDDataBaseCenterMessageIsSelf;
extern NSString * const GYHDDataBaseCenterMessageIsRead;
extern NSString * const GYHDDataBaseCenterMessageSentState;
extern NSString * const GYHDDataBaseCenterMessageCard;
extern NSString * const GYHDDataBaseCenterMessageData;//用户存放data数据，例如音频文件，视频文件
extern NSString * const GYHDDataBaseCenterMessageUserState;
#pragma mark -- friendSql
extern NSString * const GYHDDataBaseCenterFriendTableName;
extern NSString * const GYHDDataBaseCenterFriendID;
extern NSString * const GYHDDataBaseCenterFriendMessageTop;
extern NSString * const GYHDDataBaseCenterFriendFriendID;
extern NSString * const GYHDDataBaseCenterFriendCustID;
extern NSString * const GYHDDataBaseCenterFriendUsetType;
extern NSString * const GYHDDataBaseCenterFriendBasic;
extern NSString * const GYHDDataBaseCenterFriendDetailed;
extern NSString * const GYHDDataBaseCenterFriendIcon;
extern NSString * const GYHDDataBaseCenterFriendName;

#pragma mark -- friendBase

extern NSString * const GYHDDataBaseCenterFriendTeamTableName;
extern NSString * const GYHDDataBaseCenterFriendTeamID;
extern NSString * const GYHDDataBaseCenterFriendTeamTeamID;
extern NSString * const GYHDDataBaseCenterFriendTeamName;
extern NSString * const GYHDDataBaseCenterFriendTeamDetail;
#pragma mark -- 用户设置信息
/**用户设置表名*/
extern NSString * const GYHDDataBaseCenterUserSetingTableName;
extern NSString * const GYHDDataBaseCenterUserSetingID;
/**用户名*/
extern NSString * const GYHDDataBaseCenterUserSetingName;
/**用户消息置顶*/
extern NSString * const GYHDDataBaseCenterUserSetingMessageTop;
/**用户消息默认值 -1*/
extern NSString * const GYHDDataBaseCenterUserSetingMessageTopDefualt;

extern NSString * const GYHDDataBaseCenterFriendBasicAccountID;
extern NSString * const GYHDDataBaseCenterFriendBasicCustID;
extern NSString * const GYHDDataBaseCenterFriendBasicIcon;
extern NSString * const GYHDDataBaseCenterFriendBasicNikeName;
extern NSString * const GYHDDataBaseCenterFriendBasicSignature;
extern NSString * const GYHDDataBaseCenterFriendBasicTeamId;
extern NSString * const GYHDDataBaseCenterFriendBasicTeamName;
extern NSString * const GYHDDataBaseCenterFriendBasicTeamRemark;
// 通知
extern NSString * const GYHDMessageCenterDataBaseChageNotification;
typedef void (^RequetResultWithDict)(NSDictionary *resultDict);
typedef void (^RequetResultWithArray)(NSArray *resultArry);
@protocol GYHDMessageCenterDelegate <NSObject>

- (BOOL)sendToServerWithDict:(NSDictionary *)dict;
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
/**
 * 像素转字体
 */
#define KFontSizePX(originSize)     ((originSize)/(2))
#define KchannelTypeWithIphone 4
/**发送protobuf*/
- (BOOL)sendProtobufToServerWithData:(NSData *)data;
typedef NS_ENUM (NSUInteger, GYHDMessageLoginState){
    
    GYHDMessageLoginStateUnknowError = 0,
    GYHDMessageLoginStateConnetToServerSucced,//连接服务器成功
    GYHDMessageLoginStateConnetToServerTimeout,//连接服务器超时
    GYHDMessageLoginStateConnetToServerFailure,//连接服务器失败
    GYHDMessageLoginStateOtherLogin,//登录验证失败，可以提示检查用户和密码
    GYHDMessageLoginStateAuthenticateSucced,//登录验证成功
    GYHDMessageLoginStateAuthenticateFailure//登录验证失败，可以提示检查用户和密码
    
};
@end




@interface GYHDMessageCenter : NSObject
@property(nonatomic, weak)id<GYHDMessageCenterDelegate> delegate;
@property(nonatomic, copy)NSString *accountNumber;
@property(nonatomic, copy)XMPPMessage *message;
@property(nonatomic, assign) GYHDMessageLoginState state;
@property(nonatomic, copy)NSString *deviceToken;
+ (instancetype)sharedInstance;

/**接收到protobuf*/
- (void)receiveProtobuf:(NSData *)protobuf;
/**
 * 保存数据库路劲
 */
- (void)savedbFull:(NSString *)dbFull;
- (void)ReceiveMessage:(XMPPMessage *)message;

/**
 * 发送消息到服务器
 */
- (void)sendMessageWithDictionary:(NSDictionary *)dict resend:(BOOL)resend;
/**
 * 消息分两个数组， 一个数组为推送消息，一个数组为及时聊天消息，小数组里包含每条消息的最后一条记录的字典
 */
- (NSArray <NSArray <NSDictionary *>*>*)selectLastGroupMessage;

/**
 * 查询订单类消息
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
/**

*/
- (NSArray <NSDictionary *>*)selectGroupMessage;
/**
 * 查询每种消息未读统计
 */
- (NSString *)UnreadMessageCountWithCard:(NSString *)CardStr;
/**
 * 查询所有消息未读统计
 */
- (NSString *)UnreadAllMessageCount;
/**
 * 清零已读信息
 */
- (BOOL)ClearUnreadMessageWithCard:(NSString *)CardStr;
#warning 消息列表新界面修改
//获取推送消息最后一条数组
- (NSArray <NSArray <NSDictionary *>*>*)selectLastGroupPushMessage;
//获取聊天消息最后一条消息数组
- (NSArray <NSArray <NSDictionary *>*>*)selectLastGroupChatAllMessage;
/**
 * 查询某类推送消息未读统计
 */
- (NSString*)UnreadPushMessageCountWithMsgID:(NSString *)msgID;
/**
 * 查询指定用户所有消息未读统计
 */
- (NSInteger)UnreadAllMessageCountWithCard:(NSString *)CardStr;
/**
 * 清零消息
 */
- (BOOL)ClearUnreadMessage;
/**
 * 清零已读推送信息
 */
- (BOOL)ClearUnreadPushMessageWithCard:(NSString *)CardStr;
/**
 * 清零某一条已读推送信息
 */
- (BOOL)ClearUnreadPushMessageWithCard:(NSString *)CardStr messageId:(NSString*)messageId;
/**
 * 查询所以聊天记录
 */
- (NSArray <NSDictionary *>*)selectAllChatWithCard:(NSString *)cardStr frome:(NSInteger)from to:(NSInteger)to;
/**
 * 查询所有订单消息
 */
- (NSArray *)selectAllDingDanList;
/**
 * 查询某种类型的所有消息
 */
- (NSArray *)selectAllMessageListWithMessageCard:(NSString *)messageCard;
/**
 * 读取音频信息
 */
- (void) readAudioMessageID:(NSString *)messageID RequetResultWithDictBlock:(RequetResultWithDict)block;
- (void)checkDict:(NSMutableDictionary *)dict;
/**
 * 更改消息状态
 */
- (BOOL)updateMessageStateWithMessageID:(NSString *)messageID State:(GYHDDataBaseCenterMessageSentStateOption) state;
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
/**根据某个删除消息*/
- (BOOL)deleteMessageWithMessage:(NSString *)message fieldName:(NSString *)fieldName;
/**
 * 发送即时聊天通知
 */
- (void)postDataBaseChangeNotification;
- (void)postDataBaseChangeNotificationWithDict:(NSDictionary *)dict;
/**
 * 添加通知
 */
- (void)addDataBaseChangeNotificationObserver:(id)observer selector:(SEL)aSelector;
/**
 * 移除通知
 */
- (void)removeDataBaseChangeNotificationWithObserver:(id)observer;
/**
 * 根据时间字符串返回需要的文字
 */
- (NSString *)messageTimeStrFromTimerString:(NSString *)timeString;
/**
 *  判断某个时间是否为今年
 */
- (BOOL)isThisYearWithData:(NSDate *)oldData;
/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterdayData:(NSDate *)oldData;
/**
 * 判断某个时间是否为前天
 */
- (BOOL)isTheDayBeforeYesterdayWithData:(NSDate *)oldData;
/**
 *  判断某个时间是否为今天
 */
- (BOOL)isTodayData:(NSDate *)oldData;
/**
 * 取得图片
 */
- (void)messageContentAttributedStringWithString:(NSString *)string AttrString:(NSMutableAttributedString *)messageAttrStr;
/**普通文字转富文本*/
- (NSMutableAttributedString *)attStringWithString:(NSString *)string imageFrame:(CGRect)imageFrame attributes:(NSDictionary *)dict;
/**将富文本转换普通文字*/
- (NSString *)stringWithAttString:(NSAttributedString *)AttString;
/**查询某个好友基本信息*/
- (NSDictionary *)selectFriendBaseWithCardString:(NSString *)card;
/**更新好友信息*/
- (void)updateFriendBaseWithDict:(NSDictionary *)dict;
/**更新发送中数据*/
- (void)updateSendingState;
/**获取MP4文件夹*/
- (NSString *)mp4folderNameString;
/**获取MP3文件夹*/
- (NSString *)mp3folderNameString;
/**获取Image文夹*/
- (NSString *)imagefolderNameString;
/**下载文件返回block*/
- (void)downloadDataWithUrlString:(NSString *)urlstring RequetResult:(RequetResultWithDict)handler;
- (BOOL)updateMessageWithMessageID:(NSString *)messageID fieldName:(NSString *)fieldName updateString:(NSString *)updateString ;

/**插入好友基本信息*/
- (BOOL)insertInfoWithDict:(NSDictionary *)dict TableName:(NSString *)tableName;

/*
 更新表信息
 */
- (BOOL)updateInfoWithDict:(NSDictionary *)dict conditionDict:(NSDictionary *)conditionDict TableName:(NSString *)tableName;
#warning 搜索相关
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
@end


