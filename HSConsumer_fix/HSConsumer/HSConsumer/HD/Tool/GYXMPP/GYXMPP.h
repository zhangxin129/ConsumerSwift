//
//  GYXMPP.h
//  IMXMPPPro
//

//  Created by liangzm on 15-1-7.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

typedef NS_ENUM(NSUInteger, IMLoginState) {

    kIMLoginStateUnknowError = 0,
    kIMLoginStateConnetToServerSucced, //连接服务器成功
    kIMLoginStateConnetToServerTimeout, //连接服务器超时
    kIMLoginStateConnetToServerFailure, //连接服务器失败
    kIMLoginStateAuthenticateSucced, //登录验证成功
    kIMLoginStateAuthenticateFailure //登录验证失败，可以提示检查用户和密码
};

#define kNotificationNameSendResult @"SendResult"
#define kNotificationNameFromJIDPrefix @"refreshMessageFor_"
#define kNotificationNameForSystemPushPersonMsg @"refreshMessageForSystemPushPersonMsg"
#define kNotificationNameInitDB @"InitDB" //初始化数据库后

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "XMPPFramework.h"

typedef void (^LoginBlock)(IMLoginState state);

@interface GYXMPP : NSObject
/**
 *  与服务器交互消息的核心 即时消息
 */
@property (nonatomic, strong) XMPPStream* msgXmppStream;
/**
 *  与服务器交互消息的核心 推送消息
 */
@property (nonatomic, strong) XMPPStream* pushXmppStream;

@property (nonatomic, strong, readonly) FMDatabase* imFMDB;

/**
 *  xmpp单例
 */
+ (instancetype)sharedInstance;
/**
 *  登录消息服务器
 */
- (void)login:(LoginBlock)block;
/**
 *  退出登录
 */
- (void)Logout;



- (dispatch_queue_t)getMessageQueue;



@end
