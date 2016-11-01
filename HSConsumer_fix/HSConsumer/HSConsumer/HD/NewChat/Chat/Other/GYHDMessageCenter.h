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
#import "UIColor+HEX.h"
#import "Masonry.h"
#import "GYHDStream.h"
#import "GYHDProtoBufHeader.h"
#import "IMMessage.pb.h"
#import "GYHDProtoBufSocket.h"
typedef NS_ENUM(NSInteger, GYHDPopMessageState) {
    GYHDPopMessageStateTop = 0, // 置顶
    GYHDPopMessageStateClearTop, // 取消置顶
};

typedef NS_ENUM(NSInteger, GYHDDataBaseCenterMessageSentStateOption) {
    GYHDDataBaseCenterMessageSentStateSuccess = 1, // 发送成功
    GYHDDataBaseCenterMessageSentStateSending, // 发送中
    GYHDDataBaseCenterMessageSentStateFailure // 发送失败
};

typedef NS_ENUM(NSInteger, GYHDDataBaseCenterMessageType) {

    GYHDDataBaseCenterMessageChatText = 0, //文本消息
    GYHDDataBaseCenterMessageTypeDingDan = 101, //订单消息
    GYHDDataBaseCenterMessageChatPicture = 10, //图片消息
    GYHDDataBaseCenterMessageChatMap = 11, //地理消息
    GYHDDataBaseCenterMessageChatFile = 12, //文件消息
    GYHDDataBaseCenterMessageChatAudio = 13, //音频消息
    GYHDDataBaseCenterMessageChatVideo = 14, //视频消息
    GYHDDataBaseCenterMessageChatGoods = 15, //商品消息
    GYHDDataBaseCenterMessageChatOrder = 16, //订单消息
    GYHDDataBaseCenterMessageTypeChat, //聊天消息
    GYHDDataBaseCenterMessageTypeHuShengNews, //互生新闻
    GYHDDataBaseCenterMessageTypeHuSheng, //互生消息
    GYHDDataBaseCenterMessageTypeFuWu, //服务消息

    GYHDDataBaseCenterMessageTypeDingYue = 102, //订阅消息

    GYHDDataBaseCenterPush10101 = 10101, //消费者个人消息 ----- 互生消息                                    y
    GYHDDataBaseCenterPush10102 = 10102, //消费者个人消息 ----- 业务消息(总类)

    GYHDDataBaseCenterPush1010201 = 1010201, //消费者个人消息 ----- 业务消息(小类)绑定互生卡                       y

    GYHDDataBaseCenterPush1010202 = 1010202, //消费者个人消息 ----- 业务消息(小类)订单消息 -----订单支付成功
    GYHDDataBaseCenterPush1010203 = 1010203, //消费者个人消息 ----- 业务消息(小类)订单消息 -----确认收货
    GYHDDataBaseCenterPush1010204 = 1010204, //消费者个人消息 ----- 业务消息(小类)订单消息 -----待自提
    GYHDDataBaseCenterPush1010205 = 1010205, //消费者个人消息 ----- 业务消息(小类)订单消息 -----取消订单
    GYHDDataBaseCenterPush1010206 = 1010206, //消费者个人消息 ----- 业务消息(小类)订单消息 -----退款完成【订单取消】
    GYHDDataBaseCenterPush1010207 = 1010207, //消费者个人消息 ----- 业务消息(小类)订单消息 -----退款完成【售后】

    GYHDDataBaseCenterPush1010208 = 1010208, //消费者个人消息 ----- 业务消息(小类)订单消息 -----申领抵扣券消息       y
    GYHDDataBaseCenterPush1010209 = 1010209, //消费者个人消息 ----- 意外伤害 您的互生意外伤害保障已生效              y
    GYHDDataBaseCenterPush1010210 = 1010210, //消费者个人消息 ----- 意外伤害保障失效                              y
    GYHDDataBaseCenterPush1010211 = 1010211, //消费者个人消息 ----- 积分投资达到10000 推送可以申请免费医疗           y

    GYHDDataBaseCenterPush1010212 = 1010212, //消费者个人消息 ----- 订单消息 企业备货中
    GYHDDataBaseCenterPush1010213 = 1010213, //消费者个人消息 ----- 订单消息 买家申请取消订单

    GYHDDataBaseCenterPush1010214 = 1010214, //餐饮订单消息 -----店内订单确认
    GYHDDataBaseCenterPush1010215 = 1010215, //餐饮订单消息 -----接单
    GYHDDataBaseCenterPush1010216 = 1010216, //餐饮订单消息 -----拒接
    GYHDDataBaseCenterPush1010217 = 1010217, //餐饮订单消息 -----送餐
    GYHDDataBaseCenterPush1010218 = 1010218, //餐饮订单消息 -----打印预结单
    GYHDDataBaseCenterPush1010219 = 1010219, //餐饮订单消息 -----商家取消预定
    GYHDDataBaseCenterPush1010220 = 1010220, //餐饮订单消息 -----商家确认取消
    GYHDDataBaseCenterPush1010221 = 1010221, //餐饮订单消息 -----店内订单定金支付成功
    GYHDDataBaseCenterPush1010222 = 1010222, //餐饮订单消息 -----店内订单付款成功

    GYHDDataBaseCenterPush10201 = 10201, //企业商品降价消息（企业-->系统-->消费者）
    GYHDDataBaseCenterPush10202 = 10202, //企业商品下架、无货等消息（企业-->系统-->消费者）
    GYHDDataBaseCenterPush10203 = 10203, //企业商品上新消息（企业-->系统-->消费者）
    GYHDDataBaseCenterPush10204 = 10204, //企业的活动消息（企业-->系统-->消费者）

    GYHDDataBaseCenterPush10301 = 10301, //企业商品上新消息（旧）（企业-->系统-->消费者）
    GYHDDataBaseCenterPush10302 = 10302, //企业的活动消息  （旧）（企业-->系统-->消费者）

    GYHDDataBaseCenterPush50001 = 50001, //强制用户登出指令
    GYHDDataBaseCenterPush50011 = 50011, //好友添加请求
    GYHDDataBaseCenterPush50012 = 50012, //好友确认
    GYHDDataBaseCenterPush50013 = 50013, //好友拒绝
    GYHDDataBaseCenterPush50014 = 50014, //删除好友
};
/**聊天消息*/
extern NSInteger const GYHDProtobufMessageChat;
/**互生消息*/
extern NSInteger const GYHDProtobufMessageHuSheng;
/**订单消息*/
extern NSInteger const GYHDProtobufMessageDianShang;
/**互信消息*/
extern NSInteger const GYHDProtobufMessageHuxin;

#pragma mark-- 互生消息
/**互生公开信 1001*/
extern NSInteger const GYHDProtobufMessage01001;
extern NSInteger const GYHDProtobufMessage01002;
/**意外伤害保障生效 01006*/
extern NSInteger const GYHDProtobufMessage01006;
/**意外伤害保障失效 01007*/
extern NSInteger const GYHDProtobufMessage01007;
/**免费医疗计划 01008*/
extern NSInteger const GYHDProtobufMessage01008;
/**企业操作员绑定消费者互生卡 01009*/
extern NSInteger const GYHDProtobufMessage01009;
/**意外伤害保障过期失效 01010*/
extern NSInteger const GYHDProtobufMessage01010;
#pragma mark-- 订单消息

/**订单支付成功 02001*/
extern NSInteger const GYHDProtobufMessage02001;
/**订单退款完成【订单取消】 02002*/
extern NSInteger const GYHDProtobufMessage02002;
/**订单退款完成【售后】 02003*/
extern NSInteger const GYHDProtobufMessage02003;
/**订单确认收货 02004*/
extern NSInteger const GYHDProtobufMessage02004;
/**订单待自提*/
extern NSInteger const GYHDProtobufMessage02005;
/**卖家取消订单*/
extern NSInteger const GYHDProtobufMessage02006;
/**订单企业备货中*/
extern NSInteger const GYHDProtobufMessage02007;
/**买家申请取消订单*/
extern NSInteger const GYHDProtobufMessage02008;

/**店内订单确认*/
extern NSInteger const GYHDProtobufMessage02021;
/**店内订单付款成功*/
extern NSInteger const GYHDProtobufMessage02022;
/**店内订单定金支付成功*/
extern NSInteger const GYHDProtobufMessage02023;
/**接单*/
extern NSInteger const GYHDProtobufMessage02024;
/**拒接*/
extern NSInteger const GYHDProtobufMessage02025;
/**送餐*/
extern NSInteger const GYHDProtobufMessage02026;
/**打预结单通知支付*/
extern NSInteger const GYHDProtobufMessage02027;
/**商家取消预定*/
extern NSInteger const GYHDProtobufMessage02028;
/**商家确认取消*/
extern NSInteger const GYHDProtobufMessage02029;

#pragma mark-- 互信消息
/**强制用户登出指令*/
extern NSInteger const GYHDProtobufMessage04001;
/**好友添加请求*/
extern NSInteger const GYHDProtobufMessage04101;
/**好友确认*/
extern NSInteger const GYHDProtobufMessage04102;
/**好友拒绝*/
extern NSInteger const GYHDProtobufMessage04103;
/**删除好友*/
extern NSInteger const GYHDProtobufMessage04104;
/**被移入黑名单*/
extern NSInteger const GYHDProtobufMessage04105;
/**被移出黑名单*/
extern NSInteger const GYHDProtobufMessage04106;
#pragma mark-- 订阅消息
/**商品降价*/
extern NSInteger const GYHDProtobufMessage02901;
/**商品下架、无货等消息*/
extern NSInteger const GYHDProtobufMessage02902;
/**商铺信息变动*/
extern NSInteger const GYHDProtobufMessage02903;
/**商家发布的活动消息*/
extern NSInteger const GYHDProtobufMessage02904;

#pragma mark-- PushMessageSql
extern NSString* const GYHDDataBaseCenterPushMessageTableName;
extern NSString* const GYHDDataBaseCenterPushMessageID;
extern NSString* const GYHDDataBaseCenterPushMessageCode;
extern NSString* const GYHDDataBaseCenterPushMessagePlantFromID;
extern NSString* const GYHDDataBaseCenterPushMessageFromID;
extern NSString* const GYHDDataBaseCenterPushMessageToID;
extern NSString* const GYHDDataBaseCenterPushMessageContent;
extern NSString* const GYHDDataBaseCenterPushMessageBody;
extern NSString* const GYHDDataBaseCenterPushMessageSendTime;
extern NSString* const GYHDDataBaseCenterPushMessageRevieTime;
extern NSString* const GYHDDataBaseCenterPushMessageIsRead;
extern NSString* const GYHDDataBaseCenterPushMessageData;
extern NSString* const GYHDDataBaseCenterPushMessageUnreadLocation;

extern NSString* const GYHDDataBaseCenterMessageTableName;
extern NSString* const GYHDDataBaseCenterMessageID;
extern NSString* const GYHDDataBaseCenterMessageFromID;
extern NSString* const GYHDDataBaseCenterMessageToID;
extern NSString* const GYHDDataBaseCenterMessageContent;
extern NSString* const GYHDDataBaseCenterMessageFriendType;
extern NSString* const GYHDDataBaseCenterMessageBody;
extern NSString* const GYHDDataBaseCenterMessageCode;
extern NSString* const GYHDDataBaseCenterMessageSendTime;
extern NSString* const GYHDDataBaseCenterMessageRevieTime;
extern NSString* const GYHDDataBaseCenterMessageIsSelf;
extern NSString* const GYHDDataBaseCenterMessageIsRead;
extern NSString* const GYHDDataBaseCenterMessageSentState;
extern NSString* const GYHDDataBaseCenterMessageCard;
extern NSString* const GYHDDataBaseCenterMessageData; //用户存放data数据，例如音频文件，视频文件
#pragma mark-- friendSql
extern NSString* const GYHDDataBaseCenterFriendTableName;
extern NSString* const GYHDDataBaseCenterFriendID;
extern NSString* const GYHDDataBaseCenterFriendMessageTop;
extern NSString* const GYHDDataBaseCenterFriendFriendID;
extern NSString* const GYHDDataBaseCenterFriendCustID;
extern NSString* const GYHDDataBaseCenterFriendResourceID;
extern NSString* const GYHDDataBaseCenterFriendApplication; //好友申请

extern NSString* const GYHDDataBaseCenterFriendName;
extern NSString* const GYHDDataBaseCenterFriendIcon;
extern NSString* const GYHDDataBaseCenterFriendUsetType;
extern NSString* const GYHDDataBaseCenterFriendInfoTeamID;
extern NSString* const GYHDDataBaseCenterFriendTeamFriendSet;
extern NSString* const GYHDDataBaseCenterFriendSign;
extern NSString* const GYHDDataBaseCenterFriendMessageType;
extern NSString* const GYHDDataBaseCenterFriendBasic;
extern NSString* const GYHDDataBaseCenterFriendDetailed;
#pragma mark-- friendBase

extern NSString* const GYHDDataBaseCenterFriendTeamTableName;
extern NSString* const GYHDDataBaseCenterFriendTeamID;
extern NSString* const GYHDDataBaseCenterFriendTeamTeamID;
extern NSString* const GYHDDataBaseCenterFriendTeamName;
extern NSString* const GYHDDataBaseCenterFriendTeamDetail;
#pragma mark-- 用户设置信息
/**用户设置表名*/
extern NSString* const GYHDDataBaseCenterUserSetingTableName;
extern NSString* const GYHDDataBaseCenterUserSetingID;
/**用户名*/
extern NSString* const GYHDDataBaseCenterUserSetingName;
/**用户消息置顶*/
extern NSString* const GYHDDataBaseCenterUserSetingMessageTop;
/**好友申请点击数量*/
extern NSString* const GYHDDataBaseCenterUserSetingSelectCount;
/**用户消息默认值 -1*/
extern NSString* const GYHDDataBaseCenterUserSetingMessageTopDefualt;
/**消息隐藏*/
extern NSString* const GYHDDataBaseCenterUserSetingMessageHiden;

extern NSString* const GYHDDataBaseCenterFriendBasicAccountID;
extern NSString* const GYHDDataBaseCenterFriendBasicCustID;
extern NSString* const GYHDDataBaseCenterFriendBasicIcon;
extern NSString* const GYHDDataBaseCenterFriendBasicNikeName;
extern NSString* const GYHDDataBaseCenterFriendBasicSignature;
extern NSString* const GYHDDataBaseCenterFriendBasicTeamId;
extern NSString* const GYHDDataBaseCenterFriendBasicTeamName;
extern NSString* const GYHDDataBaseCenterFriendBasicTeamRemark;

/**关注企业*/
extern NSString* const GYHDDataBaseCenterFocusOnBusiness;
/**好友*/
extern NSString* const GYHDDataBaseCenterFriends;
/**企业临时聊天*/
extern NSString* const GYHDDataBaseCenterTemporaryBusiness;
extern NSString* const GYHDDataBaseCenterMy;
// 通知
extern NSString* const GYHDMessageCenterDataBaseChageNotification;
typedef void (^RequetResultWithDict)(NSDictionary* resultDict);
typedef void (^RequetResultWithArray)(NSArray* resultArry);
@protocol GYHDMessageCenterDelegate <NSObject>

- (BOOL)sendToServerWithDict:(NSDictionary*)dict;
/**发送protobuf*/
- (BOOL)sendProtobufToServerWithData:(NSData*)data;
//#define WS(weakSelf)  __weak __typeof(&*self) weakSelf = self;
/**
 * 像素转字体
 */
#define KFontSizePX(originSize) ((originSize) / (2))
#define KchannelTypeWithIphone 4
#define KUserDefaultAccount [NSString stringWithFormat:@"hd_%@",globalData.loginModel.custId]
typedef NS_ENUM(NSUInteger, GYHDMessageLoginState) {

    GYHDMessageLoginStateUnknowError = 0,
    GYHDMessageLoginStateConnetToServerSucced, //连接服务器成功
    GYHDMessageLoginStateConnetToServerTimeout, //连接服务器超时
    GYHDMessageLoginStateConnetToServerFailure, //连接服务器失败
    GYHDMessageLoginStateOtherLogin, //登录验证失败，可以提示检查用户和密码
    GYHDMessageLoginStateAuthenticateSucced, //登录验证成功
    GYHDMessageLoginStateAuthenticateFailure //登录验证失败，可以提示检查用户和密码

};
@end

@interface GYHDMessageCenter : NSObject
@property (nonatomic, weak) id<GYHDMessageCenterDelegate> delegate;
@property (nonatomic, copy) NSString* accountNumber;
@property (nonatomic, copy) XMPPMessage* message;
@property (nonatomic, assign) GYHDMessageLoginState state;
@property (nonatomic, copy) NSString* deviceToken;
+ (instancetype)sharedInstance;

/**
 * 保存数据库路劲
 */
- (void)savedbFull:(NSString*)dbFull;
- (void)ReceiveMessage:(XMPPMessage*)message;
/**接收到protobuf*/
- (void)receiveProtobuf:(NSData*)protobuf;
/**
 * 发送消息到服务器
 */
- (void)sendMessageWithDictionary:(NSDictionary*)dict resend:(BOOL)resend;
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
 * 清零已读信息
 */
- (BOOL)ClearUnreadMessageWithCard:(NSString*)CardStr;
/**
 * 查询所以聊天记录
 */
- (NSArray<NSDictionary*>*)selectAllChatWithCard:(NSString*)cardStr frome:(NSInteger)from to:(NSInteger)to;
/**
 * 获得好友基本信息,此发送有两返回值1. 直接返回的是通过数据库得到的， 2.block返回的是从服务器获取的
 */
- (NSArray*)getFriendListRequetResult:(RequetResultWithArray)handler isNetwork:(BOOL)isNetwork;
/**获取好友列表信息*/
- (NSArray*)getFriendListRequetResult:(RequetResultWithArray)handler;

/**查询未某内分组用户*/
- (NSArray*)selectFriendWithTeamID:(NSString*)teamID;

/**
 * 获得好友分组,此发送有两返回值1. 直接返回的是通过数据库得到的， 2.block返回的是从服务器获取的
 */
- (NSArray*)getFriendTeamRequetResult:(RequetResultWithArray)handler;
/**
 * 获得某个好友的详细信息返回数组
 */
//- (NSArray *)getFriendDetailWithAccountID:(NSString *)accountID RequetResult:(RequetResultWithArray)handler;
/**创建好友分组*/
- (void)createFriendTeamWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler;
/**
 * 获得朋友基本信息返回字典
 */
//- (NSDictionary *)getFriendDetailWithAccountID:(NSString *)accountID RequetResultWithDict:(RequetResultWithDict)handler;
/**
 * 查询所有订单消息
 */
//- (NSArray *)selectAllDingDanList;
/**某种消息统计*/
//-(NSInteger)countWithCustID:(NSString *)CustID;
/**搜索CustID的相关记录*/
- (NSInteger)countWithCustID:(NSString*)CustID searchString:(NSString*)string;
/**
 * 查询某种类型的所有消息
 */
//- (NSArray *)selectAllMessageListWithMessageCard:(NSString *)messageCard;
/**
 * 读取音频信息
 */
- (void)readAudioMessageID:(NSString*)messageID RequetResultWithDictBlock:(RequetResultWithDict)block;
- (void)checkDict:(NSMutableDictionary*)dict;
/**
 * 更改消息状态
 */
- (BOOL)updateMessageStateWithMessageID:(NSString*)messageID State:(GYHDDataBaseCenterMessageSentStateOption)state;
/**
 * 消息置顶
 */
- (BOOL)messageTopWithMessageCard:(NSString*)messageCard;
/**
 * 消息取消置顶
 */
- (BOOL)messageClearTopWithMessageCard:(NSString*)messageCard;
/**统计置顶消息数量*/
- (NSInteger)selectCountMessageTop;
/**
 * 删除消息
 */
- (BOOL)deleteMessageWithMessageCard:(NSString*)messageCard;
/**根据某个删除消息*/
- (BOOL)deleteMessageWithMessage:(NSString*)message fieldName:(NSString*)fieldName;
/**
 * 发送即时聊天通知
 */
- (void)postDataBaseChangeNotification;
- (void)postDataBaseChangeNotificationWithDict:(NSDictionary*)dict;
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
- (NSString*)messageTimeStrFromTimerString:(NSString*)timeString;
/**
 *  判断某个时间是否为今年
 */
- (BOOL)isThisYearWithData:(NSDate*)oldData;
/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterdayData:(NSDate*)oldData;
/**
 * 判断某个时间是否为前天
 */
- (BOOL)isTheDayBeforeYesterdayWithData:(NSDate*)oldData;
/**
 *  判断某个时间是否为今天
 */
- (BOOL)isTodayData:(NSDate*)oldData;
/**
 * 取得图片
 */
- (void)messageContentAttributedStringWithString:(NSString*)string AttrString:(NSMutableAttributedString*)messageAttrStr;
/**普通文字转富文本*/
- (NSMutableAttributedString*)attStringWithString:(NSString*)string imageFrame:(CGRect)imageFrame attributes:(NSDictionary*)dict;
/**将富文本转换普通文字*/
- (NSString*)stringWithAttString:(NSAttributedString*)AttString;
/**
 * 绑定企业账号
 */
- (void)bindCompanyWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler;
/**查询某个好友基本信息*/
- (NSDictionary*)selectFriendBaseWithCardString:(NSString*)card;

/**更新发送中数据*/
- (void)updateSendingState;
/**获取MP4文件夹*/
- (NSString*)mp4folderNameString;
/**获取MP3文件夹*/
- (NSString*)mp3folderNameString;
/**获取Image文夹*/
- (NSString*)imagefolderNameString;
/**下载文件返回block*/
- (void)downloadDataWithUrlString:(NSString*)urlstring RequetResult:(RequetResultWithDict)handler;
- (BOOL)updateMessageWithMessageID:(NSString*)messageID fieldName:(NSString*)fieldName updateString:(NSString*)updateString;

//- (void)searchFriendWithString:(NSString *)string page:(NSString *)page RequetResult:(RequetResultWithDict)handler;
/**搜索好友*/
- (void)searchFriendWithDict:(NSDictionary *)dict Page:(NSString *)page RequetResult:(RequetResultWithDict)handler;
/**查找包含某个字的所有市*/
- (NSArray *)selectCityWithString:(NSString *)string;
/**获取商品分类*/
- (void)loadTopicFromNetworkRequetResult:(RequetResultWithDict)handler;
/**删除好友分组*/
- (void)deleteFriendTeamID:(NSString *)teamID RequetResult:(RequetResultWithDict)handler;
/**移动好友分组*/
- (void)MovieFriendWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler;
/**编辑好友分组*/
- (void)updateFriendTeamWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler;
/**搜索好友信息*/
- (NSDictionary *)searchFriendWithCustId:(NSString *)custID RequetResult:(RequetResultWithDict)handler;
/**关注商品信息*/
- (NSArray *)EasyBuyGetMyConcernShopUrlRequetResult:(RequetResultWithArray)handler;
/**插入信息*/
- (BOOL)insertInfoWithDict:(NSDictionary *)dict TableName:(NSString *)tableName;
/**更新信息*/
- (BOOL)updateInfoWithDict:(NSDictionary *)dict conditionDict:(NSDictionary *)conditionDict TableName:(NSString *)tableName;
/**message 删除信息 fileName 字段名 tablename 表名*/
- (BOOL)deleteWithMessage:(NSString *)message fieldName:(NSString *)fieldName TableName:(NSString *)tableName;
/**上传自己信息*/
- (void)updateSelfInfoWith:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler;
/**搜索某条消息*/
- (NSArray *)selectSearchMessageWithString:(NSString *)string;
/**好友*/
- (void)deleteFriendWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler;
/**查询自己信息*/
- (NSDictionary *)selectMyInfo;
///**查询咨询企业信息*/
//- (NSDictionary *)selectCompanyWithCustID:(NSString *)custID;
- (NSArray *)selectInfoWithDict:(NSDictionary *)condDict TableName:(NSString *)tableName;
/**加载未读消息*/
- (void)loadUnreadMessageData:(NSData *)data;
- (BOOL)deleteInfoWithDict:(NSDictionary *)dict TableName:(NSString *)tableName;
/**好友添加状态*/
- (void)queryWhoAddMeListRequetResult:(RequetResultWithDict)handler;
- (void)searchCompanyWithString:(NSString *)string currentPage:(NSString *)currentPage RequetResult:(RequetResultWithDict)handler;

- (void)searchCompanyWithcity:(NSString *)city currentPage:(NSString *)currentPage RequetResult:(RequetResultWithDict)handler;

/**取消关注*/
- (void)CancelConcernShopUrlWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler;
//- (BOOL)saveMessageWithDict:(NSDictionary *)dict;
/**更新好友昵称*/
- (void)updateFriendNickNameWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler;
- (NSArray *)selectInfoEqualDict:(NSDictionary *)condDict TableName:(NSString *)tableName ;

/**获取离线*/
- (void)getOfflinePushMsg;
/**好友选择统计*/
- (BOOL)updataFriendSelectCount:(NSString *)count custID:(NSString *)custID;
/**忽略好友*/
- (void)deleteRedundantFriendVerifyDataWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler;
/**查询等待好友*/
- (NSArray *)selectApplicationFriend;

- (NSString*)getUserDBNameInDirectory:(NSString*)userName;
- (BOOL)fileIsExists:(NSString*)fileFullName;
- (BOOL)createFile:(NSString*)fileFullName;
/**设置隐藏消息*/
- (BOOL)setMessageHidenWithCustID:(NSString *)CustID;
/**清除隐藏消息*/
- (BOOL)clearMessageHidenWithCustID:(NSString *)CustID;
/**string:搜索关键字， CustID 聊天消息为 用户CustID 推送消息为 消息分类数字*/
- (NSArray *)searchMessageListWithString:(NSString *)string custID:(NSString *)custID;

/**个人设置*/
-(void)updatePrivacyWithString:(NSString *)string RequetResult:(RequetResultWithDict)handler;
/**查询个人设置*/
- (void)searchPrivacyRequetResult:(RequetResultWithDict)handler;
/**根据互生卡 返回分段互生卡*/
- (NSString *)segmentationHuShengCardWithCard:(NSString *)card;
/**查询企业类型*/
- (void)searchCompanyTypeRequetResult:(RequetResultWithDict)handler;
- (void)getTopicListWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler ;
- (void)GetFoodMainPageUrlWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler;
- (void)EasyBuySearchShopUrlWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler;
@end
//- (NSArray <NSDictionary *> *)selectGroupMessage;
/**更新好友信息*/
//- (void)updateFriendBaseWithDict:(NSDictionary *)dict;