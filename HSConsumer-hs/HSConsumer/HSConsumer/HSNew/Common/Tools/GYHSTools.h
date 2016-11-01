//
//  GYHSTools.h
//  HSConsumer
//
//  Created by xiongyn on 16/9/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#ifndef GYHSTools_h
#define GYHSTools_h


//颜色--------------------------------------------------
#define kSelectedRed UIColorFromRGB(0xef4136)
#define kSecondTitleBlack UIColorFromRGB(0x000000)
#define kCellTitleBlack UIColorFromRGB(0x333333)
#define kBtnBlue UIColorFromRGB(0x1d7dd6)
#define kCellLineGary UIColorFromRGB(0xebebeb)
#define kWhite UIColorFromRGB(0xffffff)
//主界面头部中间lb  点击时颜色
#define kMainYellowCorlor UIColorFromRGB(0xffff00)
#define kotherPayBtnCorlor UIColorFromRGB(0x1d7dd6)
#define kcurrencyBalanceCorlor UIColorFromRGB(0x666666)
//支出
#define kPayForBlue UIColorFromRGB(0x009B4C)
//按钮颜色
#define kButtonCellBtnCorlor UIColorFromRGB(0xef4136)

#define kSuccessLbCorlor UIColorFromRGB(0x999999)

#define kGrayLbCorlor UIColorFromRGB(0xcccccc)


//字号--------------------------------------------------
////不同屏幕的缩放控制
//#define kfont(size) kScreenWidth > 320 ? (kScreenWidth > 375 ? [UIFont systemFontOfSize:size * 1.2] : [UIFont systemFontOfSize:size * 1.1]):[UIFont systemFontOfSize:size]
//
//#define kboldfont(size) kScreenWidth > 320 ? (kScreenWidth > 375 ? [UIFont boldSystemFontOfSize:size * 1.2] : [UIFont systemFontOfSize:size * 1.1]):[UIFont boldSystemFontOfSize:size]

//UI变更的控制

//二级菜单字体
#define kSecondTitleFont kfont(11)
//cell中重要的字体12
#define kCellImportTextFont kfont(14)
//cell中次要的字体11
#define kCellOtherTextFont kfont(13)
//明细列表
#define kAlterDetailCellFont kfont(14)
#define kAlterOtherCellFont kfont(13)
#define kAlterTitleFont kfont(15)

//兑换互生币
#define kExchangeHSBOneCellFont kfont(12)
#define kExchangeHSBTwoCellFont kfont(14)
//选择其他支付方式
#define kOtherPayCellFont kfont(11)

//PointInvestment 积分投资 积分转互生币  互生币转货币
#define kPointInvestmentCellFont kfont(14)
//温馨提示内容
#define kWarmCellFont kfont(12)
//下一步按钮标题
#define kButtonCellFont kfont(16)

//
#define kHeaderViewFont kfont(15)

//互生意外伤害
#define kQualificationlbFont kfont(18)

#define kContentlbFont kfont(16)

#define kAttributedFont kfont(13)


//货币转银行

//货币转银行余额界面底部提示语
#define kCashToBalanceFooterFont kfont(12)
//货币转银行余额界面cell
#define kCashToBankBalanceCellFont kfont(14)
//地区选择cell
#define KSelectAreaCellFont kfont(14)
//银行卡列表显示无数据
#define kBankCardNoDataFont kfont(11)
//银行卡列表cell
#define kBankCardListCellFont kfont(12)
//银行卡列表 银行名称cell
#define kBankCardListCellNameFont kfont(11)
//银行卡添加cell
#define kBankCardAddCell kfont(14)
//选择银行cell
#define kSelectBankListCell kfont(14)



//医疗补贴
#define kHealthUploadImgFont kfont(13)
#define kMedicalInstructionTitleBoldFont kboldfont(16)
#define kMedicalInstructionContentFont kfont(13)
#define kMedicalInstructionContentBoldFont kboldfont(13)
#define kHealthPlanFont kfont(11)
#define kUploadImgFooterFont kfont(13)
#define kCollectionFooterFont kfont(13)
#define kHealthPlanViewCellFont kfont(13)


//积分福利
#define kScoreWealNoDataFont kfont(13)
#define kScoreWealMenuFont kfont(11)
#define kScoreWealQueryViewCellFont kfont(11)
#define kScoreWealQueryFont kfont(14)
#define kScoreWealQueryDetailTitleFont kfont(16)
#define kScoreWealQueryDetailItemFont kfont(12)


//地址管理
#define kAreaChooseFont kfont(15)
#define kAddressModelMobileFont kfont(16)
#define kAddressModelAddressFont kfont(14)
#define kGetGoodCellNameFont kfont(16)
#define kGetGoodCellAddressFont kfont(14)
#define kAddAddressCellFont kfont(16)
#define kAddAddressCellAddressFont kfont(14)
#define kGetGoodsCellFont kfont(16)
#define kGetGoodsCellAddressFont kfont(14)
#define kGetGoodViewControllerBoldFont kboldfont(25)
#define kAddAddressViewControllerFont kfont(16)

//状态码-------------------------------------------------
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


#endif /* GYHSTools_h */
