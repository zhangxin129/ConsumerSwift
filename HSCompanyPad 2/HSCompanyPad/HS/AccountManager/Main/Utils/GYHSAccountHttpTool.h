//
//  GYHSAccountHttpTool.h
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/15.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GYHSAccountHttpTool : NSObject
#pragma mark - 公共
+ (void)getAccountDetailListWithBusinessType:(NSString *)businessType accType:(NSString *)accType dateFlag:(NSString *)dateFlag currentPage:(NSString *)currentPage pageSize:(NSString *)pageSize success:(HTTPSuccess)success failure:(HTTPFailure)failure;
// businessType(0：全部，1：收入，2：支出)  dateFlag(今天：today，最近一周：week，最近一月：month)  accType(流通币(20110),定向消费币(20120),积分账户(10110),投资账户(10410),货币账户(30110) 慈善救助基金(20130))明细查询
+ (void)getCustomAccountDetailListWithBusinessType:(NSString *)businessType accType:(NSString *)accType dateFlag:(NSString *)dateFlag startDate:(NSString *)startDate endDate:(NSString *)endDate currentPage:(NSString *)currentPage pageSize:(NSString *)pageSize success:(HTTPSuccess)success failure:(HTTPFailure)failure;//多提供了两个日期接口 查询自定义日期数据

#pragma mark - 查询账户余额
+ (void)getAccountBalanceDetailWithAccCategory:(NSString *)accCategory success:(HTTPSuccess)success failure:(HTTPFailure)failure; //查询(积分(accCategory=1),互生币(accCategory=2),货币(accCategory=3))账户余额详情

//投资账户余额详情
+ (void)getInvestBalanceDetailWithSuccess:(HTTPSuccess)success failure:(HTTPFailure)failure;



#pragma mark - 互生币账户
+ (void)paymentBycurrencyWithTransNo:(NSString *)transNo password:(NSString *)pwd success:(HTTPSuccess)success failure:(HTTPFailure)failure; //企业 兑换互生币货币支付
+ (void)paymentByNetBankWithTransNo:(NSString *)transNo jumpUrl:(NSString *)jumpUrl success:(HTTPSuccess)success failure:(HTTPFailure)failure; //企业 兑换互生币银联支付
+ (void)hsbToCashWithFromHsbAmt:(NSString *)fromHsbAmt toCashAmt:(NSString *)toCashAmt password:(NSString *)password success:(HTTPSuccess)success failure:(HTTPFailure)failure;
+ (void)exchangeHsbWithBuyHsbAmt:(NSString *)buyHsbAmt success:(HTTPSuccess)success failure:(HTTPFailure)failure; //兑换互生币
+ (void)paymentByQuickPayWithTransNo:(NSString *)transNo bindingNo:(NSString *)bindingNo smsCode:(NSString *)smsCode success:(HTTPSuccess)success failure:(HTTPFailure)failure; //快捷支付
#pragma mark - 吴冰冰增加快捷支付接口
+ (void)paymentByQuickPayWithTransNo:(NSString *)transNo bindingNo:(NSString *)bindingNo smsCode:(NSString *)smsCode bindingChannel:(NSString *)bindingChannel success:(HTTPSuccess)success failure:(HTTPFailure)failure; //快捷支付
+ (void)getEntHsbAccountDetailWithTransNo:(NSString *)transNo transType:(NSString *)transType transSys:(NSString *)transSys success:(HTTPSuccess)success failure:(HTTPFailure)failure; //互生币账户查询明细详情

#pragma mark - 积分账户
+ (void)createPointInvestWithInvestAmount:(NSString *)investAmount passWord:(NSString *)password success:(HTTPSuccess)success failure:(HTTPFailure)failure; //积分转投资
+ (void)createPvToHsbWithAmount:(NSString *)amount passWord:(NSString *)password success:(HTTPSuccess)success failure:(HTTPFailure)failure; //积分转互生币
+ (void)getEntPointAccountDetailUrlWithTransNo:(NSString *)transNo transType:(NSString *)transType success:(HTTPSuccess)success failure:(HTTPFailure)failure; //积分账户列表明细详情
//+ (void)getBonusPointDistributionInfoWithTransDate:(NSString *)

+ (void)getConsumptionIntegralDetailWithTransDate:(NSString *)transDate transNo:(NSString *)transNo batchNo:(NSString *)batchNo custId:(NSString *)custId resNo:(NSString *)resNo count:(NSInteger)count number:(NSInteger)number success:(HTTPSuccess)success failure:(HTTPFailure)failure; //消费积分分配详单

#pragma mrk - 城市税收账户
+ (void)getCityTaxJontAccount:(HTTPSuccess)success failure:(HTTPFailure)failure; //城市税收对接账户余额查询
+ (void)createTaxRateWithApplyTaxrate:(NSString *)rate provematerialFile:(NSString *)file applyReason:(NSString *)reason taxpayerType:(NSString *)taxType success:(HTTPSuccess)success failure:(HTTPFailure)failure; //调整税率;
+ (void)listTaxRateWithCurpage:(NSString *)page pageSize:(NSString *)size dateFlag:(NSString *)flag success:(HTTPSuccess)success failure:(HTTPFailure)failure; //税率调整列表
+ (void)accBalanceWithCurpage:(NSString *)page pageSize:(NSString *)size dateFlag:(NSString *)flag businessType:(NSString *)type success:(HTTPSuccess)success failure:(HTTPFailure)failure; //明细列表
+ (void)entCityTaxWithApplyId:(NSString *)applyId success:(HTTPSuccess)success failure:(HTTPFailure)failure; //税率调整详情
+ (void)cheackTaxrateChangePending:(HTTPSuccess)success failure:(HTTPFailure)failure; //查询是否存在审批中的税率申请

#pragma mark - 货币账户
+ (void)getBankTransFeeWithTransAmount:(NSString *)transAmount inAccBankCode:(NSString *)inAccBankCode inAccCityCode:(NSString *)inAccCityCode success:(HTTPSuccess)success failure:(HTTPFailure)failure; //查询货币转银行汇率

+ (void)saveTransOutWithBankProvinceNo:(NSString *)bankProvinceNo transReason:(NSString *)transReason bankNo:(NSString *)bankNo bankAcctNo:(NSString *)bankAcctNo bankCityNo:(NSString *)bankCityNo isVerify:(NSString *)isVeriry transPwd:(NSString *)transPwd amount:(NSString *)amount bankAcctName:(NSString *)bankAcctName reqOptId:(NSString *)reqOptId bankBranch:(NSString *)bankBranch accId:(NSString *)accId feeAmt:(NSString *)feeAmt success:(HTTPSuccess)success failure:(HTTPFailure)failure; //货币转银行

/**
 *  货币账户列表明细详情
 */

+ (void)getEntCashAccountDetailTransNo:(NSString *)transNo
                             transType:(NSString *)transType
                               success:(HTTPSuccess)success
                               failure:(HTTPFailure)failure;

#pragma mark - 投资账户
+ (void)queryPointDividendListWithDateFalg:(NSString *)dateFlag pageSize:(NSString *)size curPage:(NSString *)curPage success:(HTTPSuccess)success failure:(HTTPFailure)failure;

+ (void)viewInvestDividendInfoWithDividendYear:(NSString *)dividendYear curPage:(NSNumber *)curPage success:(HTTPSuccess)success failure:(HTTPFailure)failure;//投资分红详情
+ (void)entAccBalanceDetailWithTransType:(NSString *)transType transNo:(NSString *)transNo success:(HTTPSuccess)success failure:(HTTPFailure)failure;//城市对接账号 投资明细查询  详单

+ (void)getDividendRateListWithTime:(NSString *)time pageSize:(NSString *)size curPage:(NSString *)curpage success:(HTTPSuccess)success failure:(HTTPFailure)failure; //历年投资回报率



#pragma mark - 兑换互生币限额数据
+ (void)queryExchangHSBTipWithSuccess:(HTTPSuccess)success failure:(HTTPFailure)failure;//查询互生币的限额数据
#pragma mark - 吴冰冰增加调试快捷支付接口
+ (void)getPinganQuickBindBankUrlWithCustId:(NSString *)custId success:(HTTPSuccess)success failure:(HTTPFailure)failure;//快捷开通卡
+ (void)getListQkBanksByBindingChannelWithCustId:(NSString *)custId UserType:(NSString *)userType BindingChannel:(NSString *)bindingChannel success:(HTTPSuccess)success failure:(HTTPFailure)failure;//快捷已开通银行列表



#pragma mark-----20160823添加
//绑定银行卡列表
+ (void)getListBindBank:(HTTPSuccess)success failure:(HTTPFailure)failure;
//获取城市列表
+ (void)getBankCardCityWithCountryCode:(NSString *)countryCode andProvinceCode:(NSString *)provinceCode success:(HTTPSuccess)success failure:(HTTPFailure)err;
/**
 *  读取plist得到字典
 *
 *  @return 返回字典
 */
- (NSDictionary*)dicHsConfig;
@end


