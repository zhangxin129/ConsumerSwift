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
#import "GYHDSDK.h"
#import "ImHxconn.pb.h"
#import "ImHxcommon.pb.h"
#import "ImHxfriend.pb.h"
#import "ImHxmessage.pb.h"
#import "ImHxbpn.pb.h"
#import "GYHDPushMsgModel.h"
#import "GYHDReceiveMessageModel.h"

typedef NS_ENUM(NSInteger, GYHDPopMessageState) {
    GYHDPopMessageStateTop = 0,          // 置顶
    GYHDPopMessageStateClearTop,         // 取消置顶
};

// 唯一作用是给后台分辨当前是哪个app，我们的apns推送时用到
typedef NS_ENUM(UInt32, IMAppType) {
    
    kIMCompanyPad = 1, //通用平板
    kIMCompany, //手机企业
    kIMConsumer //消费者
};

typedef NS_ENUM(UInt32, IMDeviceType) {
    
    IMDeviceTypeWeb = 0, //web端
    IMDeviceTypeWap, //Wap端
    IMDeviceTypeAndroidMobile, //安卓手机
    IMDeviceTypeAndroidConsumerPad, //IOS通用平板
    IMDeviceTypeAndroidPad, //安卓互生定制平板
    IMDeviceTypeIOSMobile, //iOS手机
    IMDeviceTypeIOSPad, //iOS平板
    IMDeviceTypePC, //PC电脑
    IMDeviceTypeMac //MAC电脑
};


/**主要消息类别*/
typedef NS_ENUM(NSInteger, GYHDMessageTpye) {
       GYHDMessageTpyePush= 9,                         // 推送消息
        GYHDMessageTpyeChat,                           // 即时聊天消息
};

/**推送类别*/
typedef NS_ENUM(NSInteger, GYHDPushMessageTpye) {
    GYHDPushMessageTpyeHuSheng = 1,                    // 互生消息
    GYHDPushMessageTpyeDingDan,                        // 订单消息
    GYHDPushMessageTpyeFuWu,                           // 服务消息
};

/**即时聊天消息类别*/
typedef NS_ENUM(NSInteger, GYHDDataBaseCenterMessageType) {
    
    GYHDDataBaseCenterMessageChatText   = 0,            //文本消息
    GYHDDataBaseCenterMessageChatPicture= 10,           //图片消息
    GYHDDataBaseCenterMessageChatMap = 11,              //地理消息
    GYHDDataBaseCenterMessageChatFile   = 12,           //文件消息
    GYHDDataBaseCenterMessageChatAudio  = 13,           //音频消息
    GYHDDataBaseCenterMessageChatVideo  = 14,           //视频消息
    GYHDDataBaseCenterMessageChatGoods = 15,            //商品消息
    GYHDDataBaseCenterMessageChatOrder = 16,            //订单消息
    GYHDDataBaseCenterMessageTypeChat,                  //聊天消息
    GYHDDataBaseCenterMessageTypeGreeting=20,           //提示语消息
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
FOUNDATION_EXPORT NSString * const GYHDDataBaseCenterPushMessageDelete;  // 推送消息删除

extern NSString * const GYHDDataBaseCenterMessageTableName;
extern NSString * const GYHDDataBaseCenterMessageID;
extern NSString * const GYHDDataBaseCenterMessageFromID;
extern NSString * const GYHDDataBaseCenterMessageToID;
extern NSString * const GYHDDataBaseCenterMessageBody;
extern NSString *const GYHDDataBaseCenterMessageContent;
extern NSString * const GYHDDataBaseCenterMessageCode;
extern NSString * const GYHDDataBaseCenterMessageSendTime;
extern NSString * const GYHDDataBaseCenterMessageRevieTime;
extern NSString * const GYHDDataBaseCenterMessageIsRight;
extern NSString * const GYHDDataBaseCenterMessageIsRead;
extern NSString * const GYHDDataBaseCenterMessageSendState;
extern NSString * const GYHDDataBaseCenterMessageCard;
extern NSString * const GYHDDataBaseCenterMessageData;//用户存放data数据，例如音频文件，视频文件
extern NSString * const GYHDDataBaseCenterMessageUserState;
/**聊天类型 和 @"MSG_Type" 却别在于 此这个是新的， @“MSG_type” 弃用*/
extern NSString * const GYHDDataBaseCenterMessageChatType;
extern NSString * const GYHDDataBaseCenterMessageFileBasePath;
extern NSString * const GYHDDataBaseCenterMessageFileDetailPath;
extern NSString * const GYHDDataBaseCenterMessageNetWorkBasePath;
extern NSString * const GYHDDataBaseCenterMessageNetWorkDetailPath;
extern NSString * const GYHDDataBaseCenterMessageFileRead;
extern NSString * const GYHDDataBaseCenterMessageDelete;  // 文件读取
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
extern NSString * const GYHDDataBaseCenterFriendSessionID;//好友对话id（只存在于客服）
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

/**快捷回复*/
extern NSString * const GYHDDataBaseCenterQuickReplyTableName;
extern NSString * const GYHDDataBaseCenterQuickReplyID;
extern NSString * const GYHDDataBaseCenterQuickReplyTitle;
extern NSString * const GYHDDataBaseCenterQuickReplyCreateTimeStr;
extern NSString * const GYHDDataBaseCenterQuickReplyUpdateTimeStr;
extern NSString * const GYHDDataBaseCenterQuickReplyContent;
extern NSString * const GYHDDataBaseCenterQuickReplyMsgId;
extern NSString * const GYHDDataBaseCenterQuickReplyIsDefault;
extern NSString * const GYHDDataBaseCenterQuickReplyCustId;

/*
 * 聊天消息 通知
 */
extern NSString * const GYHDMessageCenterDataBaseChageNotification;
/*
 * 主界面切换tabbar下表通知
 */
extern NSString * const GYHDHDMainChageTabBarIndexNotification;
/*
 * 平台推送消息通知
 */
extern NSString * const GYHDPushMessageChageNotification;

/*
 * 其他地方登录消息通知
 */
extern NSString * const GYHDOtherLoginNotification;



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
@property(nonatomic, assign) GYHDMessageLoginState state;
@property(nonatomic, copy)NSString *deviceToken;//设备token
@property(nonatomic, copy)NSString*deviceVersion;//设备系统版本号
@property (nonatomic, assign) UInt32 deviceType;
+ (instancetype)sharedInstance;

/**
 * 接收在线聊天消息
 */
- (void)ReceiveMessageModel:(GYHDReceiveMessageModel *)model;

/**
 * 接收在线平台推送消息
 */
- (void)receivePushMsg:(GYHDPushMsgModel *)model;

/**
 * 发送消息到服务器
 */
- (void)sendMessageWithDictionary:(NSDictionary *)dict resend:(BOOL)resend;


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
 * 更新消息状态
 */
- (void)updateSendingState;

/*拼接音频、视频、语音鉴权信息字段*/
-(NSString*)appendAuthenticationStr:(NSString*)AuthenticationStr;

@end


