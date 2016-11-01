//
//  GYLoginModel.h
//  company
//
//  Created by sqm on 15/12/22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

//企业状态
typedef NS_ENUM(NSUInteger, companyStatu) {

    companyStatu_nomorl = 1, //正常（成员企业，托管企业）
    companyStatu_warning, //预警（成员企业。托管企业）
    companyStatu_sleep, //休眠（成员企业）
    companyStatu_longSleep, //长眠（成员企业）
    companyStatu_logout, //已注销（成员企业）
    companyStatu_request_stopPointAct, //申请停止积分活动中（托管企业）
    companyStatu_stopPointAct, // 停止积分活动（托管企业）
    companyStatu_request_logout, // 注销申请中（成员企业）
    
};

//积分活动状态
typedef NS_ENUM(NSUInteger, companyPointActStatu) {

    companyPointActStatu_waitApproval = 0, //未审批
    companyPointActStatu_SCApproval, //服务公司审批通过
    companyPointActStatu_LApproval, //地区平台初审通过
    companyPointActStatu_LSecApproval, //地区平台复审通过
    companyPointActStatu_SCApprovalDeny, //服务公司审批未通过
    companyPointActStatu_LApprovalDeny, //地区平台初审未通过
    companyPointActStatu_LSecApprovalDeny, //地区平台复审未通过

};

//成员企业注销状态
typedef NS_ENUM(NSUInteger, companyLogoutStatu) {

    companyLogoutStatu_waitApproval = 0, //未审批
    companyLogoutStatu_SCApproval, //服务公司审批通过
    companyLogoutStatu_LApproval, //地区平台初审通过
    companyLogoutStatu_LSecApproval, //地区平台复审通过
    companyLogoutStatu_ApprovalDeny, //初审 审批未通过n
    companyLogoutStatu_LApprovalDeny, //初审 地区平台审批驳回
    companyLogoutStatu_LSecApprovalDeny, //地区平台复核驳回

};

@class Role;
@interface GYLoginModel : NSObject

@property (nonatomic, copy) NSString* custId; //操作员客户id
@property (nonatomic, copy) NSString* entCustId; //企业客户id
@property (nonatomic, copy) NSString* entResType; //企业类型 服务公司 托管企业 成员企业
@property (nonatomic, copy) NSString* entCustName; //企业名称
@property (nonatomic, copy) NSString* headPic; //头像
@property (nonatomic, copy) NSString* isAuthEmail; //是否绑定邮箱
@property (nonatomic, copy) NSString* isAuthMobile; //是否绑定联系电话
@property (nonatomic, copy) NSString* isBindBank; //是否绑定银行卡
@property (nonatomic, copy) NSString* isMaininfoChanged;
@property (nonatomic, copy) NSString* isRealnameAuth; //是否实名认证
@property (nonatomic, copy) NSString* lastLoginDate; //上次登录时间
@property (nonatomic, copy) NSString* token;
@property (nonatomic, copy) NSString* userName; //用户
@property (nonatomic, copy) NSString* isSettingTradePwd; //是否设置交易密码
@property (nonatomic, copy) NSString* operName; //操作员名称
@property (nonatomic, copy) NSString* countryCode; //国家代码
@property (nonatomic, copy) NSString* provinceCode; //省份代码
@property (nonatomic, copy) NSString* cityCode; //城市代码
@property (nonatomic, copy) NSString* nickName; //昵称 需要返回
@property (nonatomic, copy) NSString* entResNo; //企业号
@property (nonatomic, copy) NSString* taxRate;
@property (nonatomic, copy) NSString* contactPerson;
@property (nonatomic, copy) NSString* contactPhone;
@property (nonatomic, copy) NSString* shopType; //*互商营业点类型
@property (nonatomic, copy) NSString* picUrl; //图片服务域名
@property (nonatomic, copy) NSString* phapiUrl; //零售域名
@property (nonatomic, copy) NSString* foodUrl; //餐饮域名
@property (nonatomic, strong) NSArray<Role*>* roles; //角色集合
@property (nonatomic, copy) NSString* hdDomain; //互动域名
@property (nonatomic, copy) NSString* hdbizDomain; //互动域名
@property (nonatomic, copy) NSString* ttMsgServer; //protobuf
@property (nonatomic, copy) NSString* deliverId; //送餐员登录的id
@property (nonatomic, copy) NSString* shopId;
@property (nonatomic, copy) NSString* vshopStatus; //是否开通商城
@property (nonatomic, copy) NSString* vshopId;
@property (nonatomic, copy) NSString* vshopName; //商城名称
@property (nonatomic, copy) NSString* vshopLogo; //商城logo
@property (nonatomic, copy) NSString* virtualShopPage; //商城主页
@property (nonatomic, copy) NSString* hsecTfsUrl;
@property (nonatomic, copy) NSString* startResType;
@property (nonatomic, copy) NSString* hdimImgcAddr;
//hdimImgcAddr
@property (nonatomic, copy) NSString* hdimPsiServer;
//hdimPsiServer
/*_*********服务公司*******_*/
/**经营类型 0、普通 1、连锁*/
@property (nonatomic, copy) NSString* businessType;
/**所属管理公司资源号*/
@property (nonatomic, copy) NSString* superEntResNo;

@end

#pragma mark - 角色
@interface Role : NSObject

@property (nonatomic, copy) NSString* entCustId;
@property (nonatomic, copy) NSString* platformCode;
@property (nonatomic, copy) NSString* roleDesc;
@property (nonatomic, copy) NSString* roleId;
@property (nonatomic, copy) NSString* roleName;
@property (nonatomic, copy) NSString* roleType; //1.全局 2.平台 3.私有
@property (nonatomic, copy) NSString* subSystemCode;

@end

@interface GYEntGlobalData : NSObject

@property (nonatomic, copy) NSString* pointSave; //企业积分保底
@property (nonatomic, copy) NSString* investPointMin; //企业单笔积分投资最小限额
@property (nonatomic, copy) NSString* hbToBankMax; //企业单笔货币转银行最大限额
@property (nonatomic, copy) NSString* hbToBankMin; //企业单比货币转银行最小限额
@property (nonatomic, copy) NSString* pointMin; //企业单笔积分汇兑最小限额
@property (nonatomic, copy) NSString* dayHbToBankMax; //企业单日货币转银行最大限额
@property (nonatomic, copy) NSString* hsbToHbRate; //互生币转货币手续费比例
@property (nonatomic, copy) NSString* hbToBankCheckMin; //互生币转现最小交易金额
@property (nonatomic, copy) NSString* regDayBuyHsbMax;//单日购买最大互生币数量
@property (nonatomic, copy) NSString* hsbToHbMin; //互生币转货币单次最低限额
@property (nonatomic, copy) NSString* currencyToHsbRate; //货币转互生币比率
@property (nonatomic, copy) NSString* bankCardBindCount; //银行卡最大数量
@property (nonatomic, copy) NSString* currencyEnName; //货币英文名称
@property (nonatomic, copy) NSString* currencyName; //货币中文名称
@property (nonatomic, copy) NSString* currencyCode; //货币代码
@property (nonatomic, copy) NSString* pointRateMax; //积分比率最大值
@property (nonatomic, copy) NSString* pointRateMin; //积分比率最小值
@property (nonatomic, copy) NSString* regBuyHsbMin; //代兑互生币实名注册最小值
@property (nonatomic, copy) NSString* regBuyHsbMax; //代兑互生币实名注册最大值
@property (nonatomic, copy) NSString* notRegBuyHsbMin; //代兑互生币未实名注册最小值
@property (nonatomic, copy) NSString* notRegBuyHsbMax;  //代兑互生币未实名注册最大值
@end

@interface PlatInfo : NSObject
@property (nonatomic, copy) NSString* countryName;
@property (nonatomic, copy) NSString* countryNameCn;
@property (nonatomic, copy) NSString* countryNo;
@property (nonatomic, copy) NSString* platNameCn;
@property (nonatomic, copy) NSString* platNo;
@end

@interface BankModel : NSObject

@property (nonatomic, copy) NSString* bankName;
@property (nonatomic, copy) NSString* bankNo;
@property (nonatomic, copy) NSString* delFlag;

@end

@interface pointActivityStatus : NSObject
@property (nonatomic, copy) NSString *applyId;//审批编号
@property (nonatomic, assign) companyPointActStatu status;//审批结果
@property (nonatomic, copy) NSString *statusS;
@property (nonatomic, copy) NSString *apprRemark;//审批意见
@property (nonatomic, copy) NSString *apprDate;//审批时间


@end
@interface memberQuitStatus : NSObject
@property (nonatomic, copy) NSString *applyId;//审批编号
@property (nonatomic, assign) companyLogoutStatu status;//审批结果
@property (nonatomic, copy) NSString *statusS;
@property (nonatomic, copy) NSString *apprRemark;//审批意见
@property (nonatomic, copy) NSString *apprDate;//审批时间

@end

@interface companyStatuModel : NSObject
@property (nonatomic, copy) NSString *baseStatus;
@property (nonatomic, strong) pointActivityStatus *pointStatus;
@property (nonatomic, strong) memberQuitStatus *quitStatus;

@property (nonatomic, assign) companyStatu appStatu;


@end



