//
//  GYHSLoginModel.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/22.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface GYHSLoginModel : JSONModel <NSCoding>

/**姓名*/
@property (nonatomic, copy) NSString* userName;
/**已登录的token备注：异地登录不生成*/
@property (nonatomic, copy) NSString* token;
/**1：男 2：女*/
@property (nonatomic, copy) NSString* sex;
/**预留信息*/
@property (nonatomic, copy) NSString* reserveInfo;
/**互生号*/
@property (nonatomic, copy) NSString* resNo;
/**昵称*/
@property (nonatomic, copy) NSString* nickName;
/**网络信息版本号*/
@property (nonatomic, copy) NSString* netWorkVer;
/**手机号*/
@property (nonatomic, copy) NSString* mobile;
/**主要信息状态*/
@property (nonatomic, copy) NSString* mainInfoStatus;
/**上次登录IP*/
@property (nonatomic, copy) NSString* lastLoginIp;
/**上次登录时间*/
@property (nonatomic, copy) NSString* lastLoginDate;
/**职业*/
@property (nonatomic, copy) NSString* job;
/**1：未实名注册、2：已实名注册（有名字和身份证）、3:已实名认证*/
@property (nonatomic, copy) NSString* isRealnameAuth;
/**是否本地登录（1：本地登录 0：异地登录）*/
@property (nonatomic, copy) NSString* isLocal;
/**是否绑定银行卡（1:已绑定 0: 未绑定）*/
@property (nonatomic, copy) NSString* isBindBank;
/**是否验证手机（1:已验证 0: 未验证)*/
@property (nonatomic, copy) NSString* isAuthMobile;
/**是否验证邮件（1:已验证 0: 未验证）*/
@property (nonatomic, copy) NSString* isAuthEmail;
/**常住地址*/
@property (nonatomic, copy) NSString* homeAddress;
/**头像*/
@property (nonatomic, copy) NSString* headPic;
/**隶属托管企业资源号*/
@property (nonatomic, copy) NSString* entResNo;
/**邮箱*/
@property (nonatomic, copy) NSString* email;
/**消费者名称*/
@property (nonatomic, copy) NSString* custName;
/**客户号*/
@property (nonatomic, copy) NSString* custId;
/**证件类型 1 2 3*/
@property (nonatomic, copy) NSString* creType;
/**证件号码*/
@property (nonatomic, copy) NSString* creNo;
/**证件有效期*/
@property (nonatomic, copy) NSString* creExpiryDate;
/**户籍地址*/
@property (nonatomic, copy) NSString* birthAddress;
/**注册地址*/
@property (nonatomic, copy) NSString* entRegAddr;
/**1：启用、2：曾经登录、3：激活、4：活跃、5：休眠、6：沉淀、7：注销*/
@property (nonatomic, copy) NSString* baseStatus;
/***/
@property (nonatomic, copy) NSString* webUrl;
/**互生图片服务器URL*/
@property (nonatomic, copy) NSString* picUrl;
/**零售URL*/
@property (nonatomic, copy) NSString* phapiUrl;
/**餐饮URL*/
@property (nonatomic, copy) NSString* foodUrl;
/**电商图片服务器*/
@property (nonatomic, copy) NSString* tfsDomain;

@property (nonatomic, copy) NSString* hdbizDomain;
/**互生的域名*/
@property (nonatomic, copy) NSString* hsUrl;

@property (nonatomic, copy) NSString* hdimVhosts;

@property (nonatomic, copy) NSString* pushDomain;
@property (nonatomic, copy) NSString* hdDomain;
@property (copy, nonatomic) NSString* hdhost; //互动主机或ip地址不含端口 ldev04.dev.gyist.com  从登录鉴权："hdDomain": "ldev04.dev.gyist.com:5222" 中截取
@property (assign, nonatomic) int hdPort; //互动端口 5222  从登录鉴权："hdDomain": "ldev04.dev.gyist.com:5222" 中截取
@property (copy, nonatomic) NSString *pushHdhost;     //互动主机或ip地址不含端口 ldev04.dev.gyist.com  从登录鉴权："hdDomain": "ldev04.dev.gyist.com:5222" 中截取
@property (assign, nonatomic) int pusHdPort;        //互动端口 5222  从登录鉴权："hdDomain": "ldev04.dev.gyist.com:5222" 中截取

@property (nonatomic, assign) BOOL cardHolder;

@property (nonatomic, copy) NSString* ttMsgServer;
@property (nonatomic, copy) NSString* hdimPsiServer;
@property (nonatomic, copy) NSString* hdimImgcAddr;

@property (nonatomic, copy) NSString* secretKey;

@property (nonatomic,assign) long  timeDifference;//时间差
@end
