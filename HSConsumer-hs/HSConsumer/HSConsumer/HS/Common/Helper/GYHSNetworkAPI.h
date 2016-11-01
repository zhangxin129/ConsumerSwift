//
//  GYHSNetworkAPI.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/23.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#ifndef GYHSNetworkAPI_h
#define GYHSNetworkAPI_h

// --------与后台接口部分---------------
#define kCertypeIdentify @"1" // 身份证
#define kCertypePassport @"2" // 护照
#define kCertypeBusinessLicence @"3" // 营业执照

#define kRealNameStatusNoRes @"1" // 未实名注册
#define kRealNameStatusHadRes @"2" // 已实名注册
#define kRealNameStatusHadCertify @"3" // 已实名认证

#define kreplyTypeAccidt @0 //(意外伤害、身故保障)
#define kreplyTypeCare @1 //免费医疗

#define kreplyNoQualification @0 //没资格
#define kreplyHaveQualification @1 //有资格

#define kAuthNo @"0" //未绑定
#define kAuthHad @"1" //已绑定

#define kRealNameAuthStatusApproveWait @"0" //审批中
#define kRealNameAuthStatusApproveRefuse @"3" //驳回
#define kRealNameAuthStatusApproveLastRefuse @"4" //复核驳回
#define kRealNameAuthStatusApproveFistSuccuss @"1" //初审通过
#define kRealNameAuthStatusApproveLastSuccuss @"2" //复审通过，复审通过即审核通过

//查询哪个账户的余额
#define kTypePointBalanceDetail @"1" //积分余额详情
#define kTypeHSDBalanceDetail @"2" //互生币余额详情
#define kTypeCashBalanceDetail @"3" //货币余额详情

//查询哪个类型的账户余额
#define kSystemTypeConsumer @"consumer" //消费者
#define kSystemTypeEnt @"ent" //企业
#define kSystemTypeCompany @"company"

#define kAccTypeCashQueryDetail @"20110" //流通币
#define kAccTypeDirectionalCashQueryDetail @"20120" //定向消费币
#define kAccTypePointAccoutDetail @"10110" //积分账户
#define kAccTypeInvestAccoutDetail @"10410" //投资账户
#define kAccTypeCashAccoutDetail @"30110" //货币账户
#define kAccTypeCharityFundDetail @"20130" //慈善救助基金

//通道
#define kChannelWEB @"1"
#define kChannelPOS @"2"
#define kChannelMCR @"3"
#define kChannelMOBILE @"4"
#define kChannelHSPAD @"5"
#define kChannelSYS @"6"
#define kChannelIVR @"7"
#define kChannelPAD @"8"

//用户类型 ----
#define kUserTypeNoCard @"1" //非持卡人
#define kUserTypeCard @"2" //持卡人
#define kUserTypeCompany @"3" //企业用户
#define kUserTypeSystem @"4" //系统用户

//客户类型
#define kCustTypeCard @"1" //持卡人
#define kCustTypeNoCard @"51" //非持卡人

#define kHSCardStatusUnlock @"1"
#define kHSCardStatusLoss @"2"

//支付方式
#define kPayFromOnlineBank @"101" //网银支付
#define kPayFromQuickPay @"102" //快捷支付
#define kPayFromHSCash @"200" //互生币支付

#define kWelfareTypeHealthBenefitsDetail @"1" //免费医疗
#define kWelfareTypeAccidentHarmSecurityDetail @"0" //意外伤害
#define kWelfareTypeSubstituteApplyDieSecurityDetail @"2" //身故保障

#define kPointWelfareCheckHealthBenefitsType @"1" //积分福利查询 -> 互生医疗补贴计划详情 - 左菜单
#define kPointWelfareCheckAccidentHarmSecurityType @"0" //积分福利查询 -> 互生意外伤害保障详情 - 左菜单
#define kPointWelfareCheckSubstituteApplyDieSecurityType    @"2" //积分福利查询 -> 代他人申请身故保障金详情 - 左菜单

#define kPointWelfareCheckAcceptSuccessType                 @"1" //积分福利查询 -> 受理成功 - 右菜单
#define kPointWelfareCheckAcceptWaitType                    @"0"  //积分福利查询 -> 受理中 - 右菜单
#define kPointWelfareCheckAcceptRefuseType                  @"2"  //积分福利查询 -> 驳回 - 右菜单

//性别
#define kSexMan @1 //男
#define kSexWoman @0 //女

// 易支付时 operateCode支付业务，对应的支付方式
// 互生币支付
#define kGYHSXT_AO_0001   @"HSXT_AO_0001"
// 互生积分二唯码
#define kGYHSXT_PS_0001   @"HSXT_PS_0001"
// 互生卡补办
#define kGYHSXT_BS_0001   @"HSXT_BS_0001"
// 互生卡定制申购
#define kGYHSXT_BS_0002   @"HSXT_BS_0002"
// 互生年缴
#define kGYHSXT_BS_0003   @"HSXT_BS_0003"
// 互生申购工具
#define kGYHSXT_BS_0004   @"HSXT_BS_0004"
// 互商零售
#define kGY_HSEC_TMS_001  @"HSEC_TMS_001"
// 互商餐饮
#define kGY_HSEC_TMS_002  @"HSEC_TMS_002"

#endif /* GYHSNetworkAPI_h */
