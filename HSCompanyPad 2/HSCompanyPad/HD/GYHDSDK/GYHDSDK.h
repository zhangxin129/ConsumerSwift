//
//  GYHDSDK.h
//  HSConsumer
//
//  Created by Yejg on 16/8/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImHxkefu.pb.h"
typedef NS_ENUM(NSUInteger, IMLoginState) {
    
    kIMLoginStateUnknowError = 0,
    kIMLoginStateConnetToServerSucced, //连接服务器成功
    kIMLoginStateConnetToServerTimeout, //连接服务器超时
    kIMLoginStateConnetToServerFailure, //连接服务器失败
    kIMLoginStateAuthenticateSucced, //登录验证成功
    kIMLoginStateAuthenticateFailure //登录验证失败，可以提示检查用户和密码
};

typedef NS_ENUM(UInt32, IMChannelType) {
    
    IMChannelTypeWeb = 1, //web端
    IMChannelTypePos, //pos机
    IMChannelTypeMcr, //刷卡器
    IMChannelTypeMobile, //手机
    IMChannelTypeHSPad, //互生平板
    IMChannelTypeSys, //互生平台接入
    IMChannelTypeIvr, //呼叫中心
    IMChannelTypeThirdpart //第三方接入
};


typedef void (^overSizeBlock)(); //包超过2k的回调
typedef void (^LoginBlock)(IMLoginState state);
typedef void (^createP2CBlock)(CreateP2CSessionRsp *sessionRsp);
@interface GYHDSDK : NSObject

/**
 *  登录回调的block
 */
@property (nonatomic, copy) LoginBlock loginBlock;
/**连接状态*/
@property (nonatomic, assign) IMLoginState loginState;

@property (nonatomic, copy)overSizeBlock overBlock;
/**
 *  创建客服对话返回状态
 */
@property (nonatomic, copy) createP2CBlock sessionBlock;
//GYHDSDK的单例方法
+ (instancetype)sharedInstance;
//登录
- (void)loginWithChannelType:(UInt32)channelType
                  DeviceType:(UInt32)deviceType
                 entResNoStr:(NSString *)entResNoStr
                 deviceToken:(NSString *)deviceToken
                       block:(LoginBlock)block;
//用用户名和密码登录的方法
//- (void)loginWithUsername:(NSString *)username password:(NSString *)password;
//注销的方法
- (void)logout;

//发消息
- (void)sendMessageToFriendID:(NSString *)friendID guid:(NSString*)guid content:(NSString *)content;

//加好友
- (void)addFriendWithFriendID:(NSString *)friendID content:(NSString *)content verify:(NSString *)verify;
//验证好友
- (void)verifyFriendWithFriendID:(NSString *)friendID agree:(int)agree;
//删好友
- (void)deleteFriendWithFriendID:(NSString *)friendID;
//修改好友备注
- (void)modifyFriendWithFriendID:(NSString *)friendID remark:(NSString *)remark;
//拉黑好友
- (void)shieldFriendWithFriendID:(NSString *)friendID;


#pragma mark - 客服模块
/**
 *  消费者创建客服对话
 *  selfCustid :消费者id,格式为:(w/m/p)_(nc/c/e)_custID
 *  entCustid  :企业19位custid 不带前缀
 *  companyname :企业名称
 *  companylog  ：企业logo
 */
- (void)creatPersonToCompanySessionReqWithSelfCustid:(NSString*)selfCustid entCustid:(NSString*)entCustid companyname:(NSString*)companyname companylogo:(NSString*)companylogo;
/**
 *  发起客服对话
 *  sessionid :会话id创建时返回
 *  guid  :自定义消息id 用来标记消息发送状态
 *  toid  :接收方，消费者是kefuid  企业是消费者id 格式为:(w/m/p)_(nc/c/e)_custID
 */
- (void)sendMessageToKefuWithSessionid:(NSString*)sessionid guid:(NSString*)guid toid:(NSString*)toid content:(NSString*)content;

/**
 *  消费者或企业主动结束咨询会话
 * string consumerid   = 1; // 消费者id,格式为:(w/m/p)_(nc/c/e)_custID
 * string kefuid       = 2; // 客服id,格式为:(w/m/p)_(nc/c/e)_custID
 * string sessionid    = 3; // 会话id 创建会话时得到
 * string userid       = 1; // 结束会话发起方 (w/m/p)_(nc/c/e)_custID
 * string entid        = 2; // 企业ID，格式为:custID,19位的纯数字
 * string consumername  = 4; // 消费者昵称
 * string consumerhead  = 4; // 消费者头像
 * string companyname  = 4; // 企业昵称
 * string companylogo  = 4; // 企业头像
 */
- (void)closePersonToCompanySessionWithUserid:(NSString*)userid entid:(NSString*)entid sessionid :(NSString*)sessionid kefuid:(NSString*)kefuid consumerid:(NSString*)consumerid consumername:(NSString*)consumername consumerhead:(NSString*)consumerhead companyname:(NSString*)companyname companylogo:(NSString*)companylogo;

/**
 *   企业客服转移会话
 * 	 string consumerid  = 1; // 消费者id，格式为:(w/m/p)_(nc/c/e)_custID
 *	 string consumername= 2; // 消费者的名字,utf8编码
 *   string newkefuid   = 3; // 新客服id，格式为:(w/m/p)_(nc/c/e)_custID
 *	 string newkefuname = 4; // 新客服的名字,utf8编码
 *	 string oldkefuid   = 5; // 老客服id，格式为:(w/m/p)_(nc/c/e)_custID
 *	 string oldkefuname = 6; // 老客服的名字,uft8编码
 *	 string sessionid   = 7; // 会话id
 *   string consumerhead  ; 消费者头像
 *   string companyname  ; 企业名称
 *   string companylogo  ; 企业logo
 */

- (void)swicthP2CReqWithConsumerid:(NSString*)consumerid consumername:(NSString*)consumername newkefuid:(NSString*)newkefuid newkefuname:(NSString*)newkefuname oldkefuid:(NSString*)oldkefuid oldkefuname:(NSString*)oldkefuname sessionid:(NSString*)sessionid consumerhead:(NSString*)consumerhead companyname:(NSString*)companyname companylogo:(NSString*)companylogo;

/**
 *   消费者给企业留言 （当咨询客服时，先调用接口查询在线客服，如所有客服均不在线时调用此方法，否则创建客服对话）
 *  string  fromid		  = 1;  // 发送者id，格式为:(w/m/p)_(nc/c/e)_custID
 *	string  entid		  = 2;  // 企业id，格式为:custID,19位的纯数字
 *	string  sessionid  = 3;  // 会话id
 *	string  content    = 4;  // json格式的消息内容,utf8编码 包括订单信息和商品信息
 *  string  guid       = 5;  // 客户端填写，服务端回传
 */

- (void)LeaveMessageToCompanyWithFromid:(NSString*)fromid entid:(NSString*)entid content:(NSString*)content guid:(NSString*)guid sessionid:(NSString*)sessionid;
@end
