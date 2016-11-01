//
//  GYHSAccountHttpTool.m
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/15.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSAccountHttpTool.h"
#import "GYNetwork.h"
#import <YYKit/YYKit.h>

#define GY_SYSTEMTYPE  @("ent")
@interface GYHSAccountHttpTool ()
@property (strong, nonatomic) NSDictionary* dicHsConfig; //互生详情的配置文件
@end
@implementation GYHSAccountHttpTool

#pragma mark-----账户余额
+ (void)getAccountBalanceDetailWithAccCategory:(NSString *)accCategory success:(HTTPSuccess)success failure:(HTTPFailure)failure
{
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSAccountBalanceDetail)
         parameter:@{ @"custId": globalData.loginModel.entCustId,
                      @"accCategory": accCategory,
                      @"systemType": GY_SYSTEMTYPE }
           success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue))
        {
            KExcuteBlock(success, returnValue[GYNetWorkDataKey])
        }
        else
        {
        }
    }
           failure:^(NSError *failureor) {
    }
       isIndicator:YES];
}

//查询投资账户余额详情
+ (void)getInvestBalanceDetailWithSuccess:(HTTPSuccess)success failure:(HTTPFailure)failure
{
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSInvestBalanceDetail)
         parameter:@{ @"hsResNo": globalData.loginModel.entResNo }
           success:^(id returnValue) {
        //
//        success(returnValue);
        if (kHTTPSuccessResponse(returnValue))
        {
            KExcuteBlock(success, returnValue)//[GYNetWorkDataKey]
        }
        else
        {
        }
    }
           failure:^(NSError *failureor) {
        //
    }
       isIndicator:YES];
}




+ (void)createPointInvestWithInvestAmount:(NSString *)investAmount passWord:(NSString *)password success:(HTTPSuccess)success failure:(HTTPFailure)err
{
    password = password.md5String;

    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSCreatePointInvest)
          parameter:@{ @"custId": globalData.loginModel.entCustId,
                       @"hsResNo": globalData.loginModel.entResNo,
                       @"custType": globalData.loginModel.entResType,
                       @"investAmount": investAmount,
                       @"custName": globalData.loginModel.entCustName,
                       @"transPwd": password,
                       @"userType": GYUserTypeCompany,
                       @"channel": GYChannelType }
            success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue))
        {
            KExcuteBlock(success, returnValue[GYNetWorkDataKey])
        }
        else if ([returnValue[GYNetWorkCodeKey]
                  isEqualToNumber:@12476])
        {
            NSString *busnessStr = kLocalized(@"GYHS_Account_Integral_Investment_Business_Temporarily_Can_Not_Be_Accepted_Reason");
            NSString *tipStr = [busnessStr stringByAppendingString:[returnValue[@"msg"]
                                                                    stringByReplacingOccurrencesOfString:kLocalized(@"GYHS_Account_Error_Code_12476")
                                                                                              withString:@""] ];
        }
        KExcuteBlock(err, nil)
    }
            failure:^(NSError *error) {
    }
        isIndicator:YES];
}

+ (void)createPvToHsbWithAmount:(NSString *)amount passWord:(NSString *)password success:(HTTPSuccess)success failure:(HTTPFailure)failure
{
    password = password.md5String;
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSCreatePvToHsb)
          parameter:@{ @"custName": globalData.loginModel.entCustName,
                       @"channel": GYChannelType,
                       @"custType": globalData.loginModel.entResType,
                       @"amount": amount,
                       @"hsResNo": globalData.loginModel.entResNo,
                       @"transPwd": password,
                       @"custId": globalData.loginModel.entCustId,
                       @"optCustId": globalData.loginModel.custId,
                       @"userType": GYUserTypeCompany }
            success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue))
        {
            KExcuteBlock(success, returnValue[GYNetWorkDataKey])
        }
        else if ([returnValue[GYNetWorkCodeKey]
                  isEqualToNumber:@43268])
        {
            NSString *busnessStr = kLocalized(@"GYHS_Account_Integral_Alternate_Currency_Business_Temporarily_Can_Not_Be_Accepted_Reason");
            NSString *tipStr = [busnessStr stringByAppendingString:[returnValue[@"msg"]
                                                                    stringByReplacingOccurrencesOfString:kLocalized(@"GYHS_Account_Error_Code_43268")
                                                                                              withString:@""]];
        }
        KExcuteBlock(failure, nil)
    }
            failure:^(NSError *error) {
    }
        isIndicator:YES];
}

+ (void)hsbToCashWithFromHsbAmt:(NSString *)fromHsbAmt toCashAmt:(NSString *)toCashAmt password:(NSString *)password success:(HTTPSuccess)success failure:(HTTPFailure)failure
{
    password = password.md5String;
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSHsbToCash)
          parameter:@{ @"custId": globalData.loginModel.entCustId,
                       @"hsResNo": globalData.loginModel.entResNo,
                       @"custName": globalData.loginModel.entCustName,
                       @"custType": globalData.loginModel.entResType,
                       @"fromHsbAmt": fromHsbAmt,
                       @"optCustId": globalData.loginModel.custId,
                       @"optCustName": globalData.loginModel.operName,
                       @"channel": GYChannelType,
                       @"transPwd": password,
                       @"toCashAmt": toCashAmt,
                       @"userType": GYUserTypeCompany }
            success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue))
        {
            KExcuteBlock(success, returnValue)
        }
        else if ([returnValue[GYNetWorkCodeKey]
                  isEqualToNumber:@43268])
        {
            NSString *busnessStr = kLocalized(@"GYHS_Account_Alternate_Currency_Currency_Business_Can_Not_Be_Accepted_Reason");
            NSString *tipStr = [busnessStr stringByAppendingString:[returnValue[@"msg"]
                                                                    stringByReplacingOccurrencesOfString:kLocalized(@"GYHS_Account_Error_Code_43268")
                                                                                              withString:@""]];
        }
        KExcuteBlock(failure, nil)
    }
            failure:^(NSError *error) {
    }
        isIndicator:YES];
}

+ (void)saveTransOutWithBankProvinceNo:(NSString *)bankProvinceNo transReason:(NSString *)transReason bankNo:(NSString *)bankNo bankAcctNo:(NSString *)bankAcctNo bankCityNo:(NSString *)bankCityNo isVerify:(NSString *)isVeriry transPwd:(NSString *)transPwd amount:(NSString *)amount bankAcctName:(NSString *)bankAcctName reqOptId:(NSString *)reqOptId bankBranch:(NSString *)bankBranch accId:(NSString *)accId feeAmt:(NSString *)feeAmt success:(HTTPSuccess)success failure:(HTTPFailure)failure //货币转银行成功后给后台保存数据
{
    transPwd = transPwd.md5String;

    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSSaveTransOut)
          parameter:@{ @"custId": globalData.loginModel.entCustId,
                       @"bankBranch": bankBranch,
                       @"userType": GYUserTypeCompany,
                       @"amount": amount,
                       @"isVerify": isVeriry,
                       @"bankAcctName": bankAcctName,
                       @"bankCityNo": bankCityNo,
                       @"bankAcctNo": bankAcctNo,
                       @"custType": globalData.loginModel.entResType,
                       @"bankNo": bankNo,
                       @"transPwd": transPwd,
                       @"channel": GYChannelType,
                       @"bankProvinceNo": bankProvinceNo,
                       @"custName": globalData.loginModel.entCustName,
                       @"accId": accId,
                       @"hsResNo": globalData.loginModel.entResNo,
                       @"feeAmt": feeAmt,
                       @"reqOptName": globalData.loginModel.operName,
                       @"reqOptId": globalData.loginModel.userName }
            success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue))
        {
            KExcuteBlock(success, returnValue)
        }
        else
        {
            if ([returnValue[GYNetWorkCodeKey]
                 isEqualToNumber:@(43272)])
            {

            }
            else if ([returnValue[GYNetWorkCodeKey]
                      isEqualToNumber:@43268])
            {
                NSString *busnessStr = kLocalized(@"GYHS_Account_Money_Transferred_To_The_Banking_Business_Temporarily_Can_Not_Be_Accepted_Reason");
                NSString *tipStr = [busnessStr stringByAppendingString:[returnValue[@"msg"]
                                                                        stringByReplacingOccurrencesOfString:kLocalized(@"GYHS_Account_Error_Code_43268")
                                                                                                  withString:@""]];
            }
            else
            {
            }

            KExcuteBlock(failure, nil)
        }
    }
            failure:^(NSError *error) {
    }isIndicator:YES];
}

#pragma mark-----通用表单的数据请求
// businessType(0：全部，1：收入，2：支出)  dateFlag(今天：today，最近一周：week，最近一月：month)  accType(流通币(20110),定向消费币(20120),积分账户(10110),投资账户(10410),货币账户(30110) 慈善救助基金(20130))明细查询
+ (void)getAccountDetailListWithBusinessType:(NSString *)businessType accType:(NSString *)accType dateFlag:(NSString *)dateFlag currentPage:(NSString *)currentPage pageSize:(NSString *)pageSize success:(HTTPSuccess)success failure:(HTTPFailure)failure
{
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSGetAccountDetailList)
          parameter:@{ @"custID": globalData.loginModel.entCustId,
                       @"businessType": businessType,
                       @"accType": accType,
                       @"dateFlag": dateFlag,
                       @"currentPage": currentPage,
                       @"pageSize": pageSize }
            success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue))
        {
            KExcuteBlock(success, returnValue)
        }
        else
        {
        }
    }
            failure:^(NSError *failureor) {
        //
    }
        isIndicator:YES MaskType:kMaskViewType_Deault];
}

+ (void)getDividendRateListWithTime:(NSString *)time pageSize:(NSString *)size curPage:(NSString *)curpage success:(HTTPSuccess)success failure:(HTTPFailure)failure
{
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSGetDividendRateList)
         parameter:@{@"time": time, @"pageSize": size, @"curPage": curpage}
           success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue))
        {
            KExcuteBlock(success, returnValue[GYNetWorkDataKey]);
        }
    }
           failure:^(NSError *error) {
        KExcuteBlock(failure, nil);
    }
       isIndicator:YES
          MaskType:kMaskViewType_Deault];
}

+ (void)getCustomAccountDetailListWithBusinessType:(NSString *)businessType accType:(NSString *)accType dateFlag:(NSString *)dateFlag startDate:(NSString *)startDate endDate:(NSString *)endDate currentPage:(NSString *)currentPage pageSize:(NSString *)pageSize success:(HTTPSuccess)success failure:(HTTPFailure)failure
{
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSGetAccountDetailList)
          parameter:@{ @"custID": globalData.loginModel.entCustId,
                       @"businessType": businessType,
                       @"accType": accType,
                       @"dateFlag": dateFlag,
                       @"currentPage": currentPage,
                       @"pageSize": pageSize,
                       @"startDate":
                       startDate,

                       @"endDate":
                       endDate                                      }
            success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue))
        {
            KExcuteBlock(success, returnValue)
        }
        else
        {
        }
    }
            failure:^(NSError *failureor) {
        //
    }
        isIndicator:YES MaskType:kMaskViewType_Deault];
}

#pragma mark-----获取默认银行卡情况
//获得默认银行卡

+ (void)getListBindBank:(HTTPSuccess)success failure:(HTTPFailure)failure
{
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSListBindBank)
         parameter:@{ @"custId": globalData.loginModel.entCustId,
                      @"userType": GYUserTypeCompany }
           success:^(id returnValue) {
        //
        if (kHTTPSuccessResponse(returnValue))
        {
            KExcuteBlock(success, returnValue[GYNetWorkDataKey])
        }
        else
        {
        }
    }
           failure:^(NSError *failureor) {
        //
    }
       isIndicator:YES];
}

#pragma mark-----货币账户
+ (void)getBankTransFeeWithTransAmount:(NSString *)transAmount inAccBankCode:(NSString *)inAccBankCode inAccCityCode:(NSString *)inAccCityCode success:(HTTPSuccess)success failure:(HTTPFailure)failure //查询货币转银行汇率
{
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSGetBankTransFee)
         parameter:@{ @"transAmount": transAmount,
                      @"inAccBankNode": inAccBankCode,
                      @"inAccCityCode": inAccCityCode,
                      @"sysFlag": @"N" }
           success:^(id returnValue) {
        //
        if (kHTTPSuccessResponse(returnValue))
        {
            KExcuteBlock(success, returnValue[GYNetWorkDataKey])
        }
        else
        {
        }
    }
           failure:^(NSError *failureor) {
        //
    }
       isIndicator:YES];
}

+ (void)getBankCardCityWithCountryCode:(NSString *)countryCode andProvinceCode:(NSString *)provinceCode success:(HTTPSuccess)success failure:(HTTPFailure)err
{
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSQueryCity)
         parameter:@{ @"countryNo": countryCode,
                      @"provinceNo": provinceCode, }
           success:^(id returnValue) {
        //
        if (kHTTPSuccessResponse(returnValue))
        {
            KExcuteBlock(success, returnValue[GYNetWorkDataKey])
        }
        else
        {
        }
    }
           failure:^(NSError *error) {
        //
    }
       isIndicator:YES];
}

#pragma mark-----投资分红详情
+ (void)viewInvestDividendInfoWithDividendYear:(NSString *)dividendYear curPage:(NSNumber *)curPage success:(HTTPSuccess)success failure:(HTTPFailure)err;
{
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSViewInvestDividendInfo)
         parameter:@{ @"hsResNo": globalData.loginModel.entResNo, @"dividendYear": dividendYear, @"curPage": curPage, @"pageSize": @(10) }
           success:^(id returnValue) {
        //
        if (kHTTPSuccessResponse(returnValue))
        {
            KExcuteBlock(success, returnValue[GYNetWorkDataKey])
        }
        else
        {
        }
    }
           failure:^(NSError *error) {
        //
    }
       isIndicator:YES];
}


#pragma mark-----投资分红明细
//投资分红明细
+ (void)queryPointDividendListWithDateFalg:(NSString *)dateFlag pageSize:(NSString *)size curPage:(NSString *)curPage success:(HTTPSuccess)success failure:(HTTPFailure)failure
{
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSViewInvestDividendInfo)
         parameter:@{ @"hsResNo": globalData.loginModel.entResNo,

                      @"dividendYear": dateFlag,
                      @"curPage": curPage,


                      @"pageSize": size }
           success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue))
        {
            KExcuteBlock(success, returnValue[GYNetWorkDataKey])
        }
        else
        {
        }
    }
           failure:^(NSError *failureor) {
        //
    }
       isIndicator:YES MaskType:kMaskViewType_Deault];
}


- (NSDictionary*)dicHsConfig
{
    if (_dicHsConfig)
    {
        return _dicHsConfig;
    }
    NSString* configFilePath = [[NSBundle mainBundle] pathForResource:@"HSAccountQueryConfig"
                                                               ofType:@"plist"];
    if (!configFilePath)
    {
        return nil;
    }
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:configFilePath];
    _dicHsConfig = dic[[GYUtils getAppLanguage]];
    return _dicHsConfig;
}





@end