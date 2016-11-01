//
//  GYHSPointTool.m
//  HSCompanyPad
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPointHttpTool.h"
#import "GYNetApiMacro.h"
#import "GYNetwork.h"
#import "GYUtilsConst.h"
#import <YYKit/NSString+YYAdd.h>

@implementation GYHSPointHttpTool
//获取交易流水号
+ (void)getSourceTransNoWithsuccess:(HTTPSuccess)success failure:(HTTPFailure)failure
{
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYPOSSourceTransNo)
        parameter:@{ @"entResNo" : globalData.loginModel.entResNo }
        success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue)) {
                NSString* sourceNo = [self getNewSourceNo:returnValue[GYNetWorkDataKey]];
                KExcuteBlock(success, sourceNo);
            } else {
                KExcuteBlock(failure, nil);
            }
        }
        failure:^(NSError* error) {
        
        }
        isIndicator:YES];
}

+ (NSString*)getNewSourceNo:(NSString*)sourceNo //转换交易流水号
{
    if ([sourceNo hasPrefix:@"9"]) {
        return [sourceNo stringByAppendingString:@"3"];
    } else {
        return [@"3" stringByAppendingString:sourceNo];
    }
}

/**
 *  查询平台设置的抵扣券使用配置参数
 *
 *  @param success <#success description#>
 *  @param err     <#err description#>
 */
+ (void)custGloabalCouponWithSuccess:(HTTPSuccess)success failure:(HTTPFailure)err
{
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYPOSCustGloabalCoupon)
         parameter:nil
           success:^(id returnValue) {
               if (kHTTPSuccessResponse(returnValue)) {
                   if ([returnValue[GYNetWorkDataKey] isKindOfClass:[NSDictionary class]]) {
                       success ? success(returnValue[GYNetWorkDataKey]) : nil;
                   } else {
                   
                       err ? err() : nil;
                   }
               } else {
               
                   err ? err() : nil;
               }
           }
           failure:^(NSError* error){
           
           }isIndicator:YES];
}

//消费积分
+ (void)newPointWithSourceTransNo:(NSString*)sourceTransNo sourceTransAmount:(NSString*)sourceTransAmount pointSum:(NSString*)pointSum transType:(NSString*)type transAmount:(NSString*)transAmount orderAmount:(NSString*)orderAmount deductionVoucher:(NSString*)number perResNo:(NSString*)perResNo equipmentNo:(NSString*)equipmentNo equipmentType:(NSString*)equipmentType sourceBatchNo:(NSString*)sourceBatchNo pointRate:(NSString*)pointRate termRunCode:(NSString*)termRunCode secretCode:(NSString*)secretCode transPwd:(NSString*)pwd success:(HTTPSuccess)success failure:(HTTPFailure)err
{
    if (pwd.length == 8) {
        pwd = pwd.md5String;
    }
    NSDictionary* paramter = @{ @"sourceTransNo" : sourceTransNo,
        @"sourceTransAmount" : sourceTransAmount,
        @"orderAmount" : orderAmount,
        @"deductionVoucher" : number,
        @"sourceCurrencyCode" : globalData.config.currencyCode,
        @"currCode" : globalData.config.currencyCode,
        @"transAmount" : transAmount,
        @"perResNo" : perResNo,
        @"termRunCode" : termRunCode,
        @"equipmentType" : equipmentType,
        @"entResNo" : globalData.loginModel.entResNo,
        @"equipmentNo" : equipmentNo,
        @"sourceBatchNo" : sourceBatchNo,
        @"pointRate" : pointRate ? [pointRate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] : @"",
        @"entCustId" : globalData.loginModel.entCustId,
        @"secretCode" : secretCode,
        @"tradePwd" : pwd ? pwd : @"",
        @"transType" : type,
        @"optCustId" : globalData.loginModel.custId,
        @"entName" : globalData.loginModel.entCustName,
        @"currencyRate" : globalData.config.currencyToHsbRate,
        @"operNo" : globalData.loginModel.userName };
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYPOSV3Point)
        parameter:paramter
        success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue) || [returnValue[GYNetWorkCodeKey] isEqualToNumber:@201]) { //只有201才需要冲正
                success ? success(returnValue) : nil;
            } else {
            
                [GYUtils showToast:kErrorReturncodeMsg];
                err ? err() : nil;
            }
        }
        failure:^(NSError* error) {
        
        }
        isIndicator:YES];
}

//冲正
+ (void)correctWithTransType:(NSString*)transType transNo:(NSString*)transNo returnReason:(NSString*)reason equitpmentType:(NSString*)equitpmentType initiate:(NSString*)initiate termRunCode:(NSString*)termRunCode perResNo:(NSString*)perResNo equipmentNo:(NSString*)equipmentNo secretCode:(NSString*)secretCode sourceBatchNo:(NSString*)batchNo success:(HTTPSuccess)success failure:(HTTPFailure)err
{
    NSDictionary* paramter = @{ @"transType" : transType,
        @"returnReason" : reason,
        @"sourceTransNo" : transNo,
        @"equipmentType" : equitpmentType,
        @"initiate" : initiate,
        @"termRunCode" : termRunCode,
        @"perResNo" : perResNo,
        @"entResNo" : globalData.loginModel.entResNo,
        @"equipmentNo" : equipmentNo,
        @"secretCode" : secretCode,
        @"sourceBatchNo" : batchNo };
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYPOSCorrect)
          parameter:paramter
            success:^(id returnValue) {
                if (kHTTPSuccessResponse(returnValue)) {
                    success ? success(returnValue[GYNetWorkDataKey]) : nil;
                } else {
                    err ? err() : nil;
                }
                
            }
            failure:^(NSError* error){
            
            }isIndicator:YES];
}

//查询二维码支付结果
+ (void)checkScanPayWithTermRunCode:(NSString*)termRunCode batchNo:(NSString*)batchNo equipmentNo:(NSString*)equipmentNo entCustId:(NSString*)entCustId entResNo:(NSString*)entResNo sourcePosDate:(NSString*)sourcePosDate success:(HTTPSuccess)success failure:(HTTPFailure)err
{
    NSDictionary* paramter = @{ @"termRunCode" : termRunCode,
        @"batchNo" : batchNo,
        @"equipmentNo" : equipmentNo,
        @"entCustId" : entCustId,
        @"entResNo" : entResNo,
        @"sourcePosDate" : sourcePosDate };
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYPOSScanPosQuery)
        parameter:paramter
        success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue)) {
                success ? success(returnValue) : nil;
            } else {
                [GYUtils showToast:kErrorReturncodeMsg];
                err ? err() : nil;
            }
            
        }
        failure:^(NSError* error) {
        
        }
        isIndicator:YES];
}

//积分流水查询
+ (void)pointQueryWithEntResNo:(NSString*)entResNo perResNo:(NSString*)perResNo startDate:(NSString*)startDate endDate:(NSString*)endDate queryType:(NSString*)queryType curPage:(NSString*)curPage pageSize:(NSString*)pageSize success:(HTTPSuccess)success failure:(HTTPFailure)err
{
    NSDictionary* paramter = @{ @"entResNo" : entResNo,
        @"perResNo" : perResNo,
        @"startDate" : startDate,
        @"endDate" : endDate,
        @"queryType" : queryType,
        @"curPage" : curPage,
        @"pageSize" : pageSize };
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYPointWaterQuery)
        parameter:paramter
        success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue)) {
                success ? success(returnValue) : nil;
            } else {
                [GYUtils showToast:kErrorReturncodeMsg];
                err ? err() : nil;
            }
            
        }
        failure:^(NSError* error) {
        
        }
        isIndicator:YES MaskType:kMaskViewType_Deault];
}

//互生币预付定金
+ (void)prePointWithSourceTransNo:(NSString*)sourceTransNo transType:(NSString*)type sourceTransAmount:(NSString*)sourceTransAmount transAmount:(NSString*)transAmount perResNo:(NSString*)perResNo channelType:(NSString*)channelType equipmentNo:(NSString*)equipmentNo equipmentType:(NSString*)equipmentType sourceBatchNo:(NSString*)sourceBatchNo termRunCode:(NSString*)termRunCode secretCode:(NSString*)secretCode transPwd:(NSString*)pwd success:(HTTPSuccess)success failure:(HTTPFailure)err
{
    NSDictionary* paramter = @{ @"sourceTransNo" : sourceTransNo,
        @"sourceCurrencyCode" : globalData.config.currencyCode,
        @"currCode" : globalData.config.currencyCode,
        @"perResNo" : perResNo,
        @"termRunCode" : termRunCode,
        @"equipmentType" : equipmentType,
        @"entResNo" : globalData.loginModel.entResNo,
        @"equipmentNo" : equipmentNo,
        @"sourceBatchNo" : sourceBatchNo,
        @"entCustId" : globalData.loginModel.entCustId,
        @"secretCode" : secretCode,
        @"tradePwd" : pwd ? pwd.md5String : @"",
        @"transType" : type,
        @"optCustId" : globalData.loginModel.custId,
        @"entName" : globalData.loginModel.entCustName,
        @"currencyRate" : globalData.config.currencyToHsbRate,
        @"channelType" : channelType,
        @"sourceTransAmount" : sourceTransAmount,
        @"transAmount" : transAmount };
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYPOSPrePoint)
        parameter:paramter
        success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue) || [returnValue[GYNetWorkCodeKey] isEqualToNumber:@201]) { //只有201才需要冲正
                success ? success(returnValue) : nil;
            } else {
                [GYUtils showToast:kErrorReturncodeMsg];
                err ? err() : nil;
            }
        }
        failure:^(NSError* error) {
        
        }
        isIndicator:YES];
}

//预付定金撤销，结算查询
+ (void)searchPosEarnestWithperResNo:(NSString*)perNo curPage:(NSString*)curPage pageSize:(NSString*)size startDate:(NSString*)startDate success:(HTTPSuccess)success failure:(HTTPFailure)err
{
    NSDictionary* paramter = @{ @"entCustId" : globalData.loginModel.entCustId,
        @"perResNo" : perNo,
        @"curPage" : curPage,
        @"pageSize" : size,
        @"dateFlag" : startDate,
    };
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYPOSSearchPosEarnest)
        parameter:paramter
        success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue)) {
                success ? success(returnValue) : nil;
            } else {
                [GYUtils showToast:kErrorReturncodeMsg];
                err ? err() : nil;
            }
            
        }
        failure:^(NSError* error) {
        
        }
        isIndicator:YES];
}

//预付定金撤销
+ (void)cancelEarnestWithOldTransNo:(NSString*)oldTransNo sourceTransNo:(NSString*)sourceTransNo sourceTransDt:(NSString*)sourceTransDt termRunCode:(NSString*)termRunCode ecretCode:(NSString*)secretCode transPwd:(NSString*)pwd transType:(NSString*)transType perResNo:(NSString*)perResNo equipmentNo:(NSString*)equipmentNo sourceBatchNo:(NSString*)sourceBatchNo frag:(NSString*)frag success:(HTTPSuccess)success failure:(HTTPFailure)err
{
    NSMutableDictionary* paramter = @{ @"oldTransNo" : oldTransNo,
        @"sourceTransNo" : sourceTransNo,
        @"sourceTransDt" : sourceTransDt,
        @"termRunCode" : termRunCode,
        @"entResNo" : globalData.loginModel.entResNo,
        @"secretCode" : secretCode,
        @"transType" : transType,
        @"perResNo" : perResNo,
        @"equipmentNo" : equipmentNo,
        @"sourceBatchNo" : sourceBatchNo,
        @"currencyRate" : globalData.config.currencyToHsbRate,
        @"entName" : globalData.loginModel.entCustName,
        @"operNo" : globalData.loginModel.userName,
        @"frag" : frag }.mutableCopy;
    if (pwd) {
        [paramter addEntriesFromDictionary:@{ @"loginPwd" : [pwd encodeWithKey:globalData.loginModel.entResNo] }];
    }
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYPOSCancel)
        parameter:paramter
        success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue) || [returnValue[GYNetWorkCodeKey] isEqualToNumber:@201]) {
                success ? success(returnValue) : nil;
            } else {
                [GYUtils showToast:kErrorReturncodeMsg];
                err ? err() : nil;
            }
        }
        failure:^(NSError* error) {
        
        }
        isIndicator:YES];
}

//积分流水查询(可以撤单和退货的记录)
+ (void)checkPointWithEntCustId:(NSString*)entCustId hsResNo:(NSString*)hsResNo startDate:(NSString*)startDate businessType:(NSString*)businessType curPage:(NSString*)curPage pageSize:(NSString*)pageSize success:(HTTPSuccess)success failure:(HTTPFailure)err;
{
    NSDictionary* paramter = @{ @"entCustId" : entCustId, @"hsResNo" : hsResNo, @"startDate" : startDate, @"businessType" : businessType, @"curPage" : curPage, @"pageSize" : pageSize, @"secretCode" : @"", @"entResNo" : globalData.loginModel.entCustName, @"readerNo" : @"" };
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYPOSPointRecord)
        parameter:paramter
        success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue)) {
                success ? success(returnValue) : nil;
            } else {
                [GYUtils showToast:kErrorReturncodeMsg];
                err ? err() : nil;
            }
            
        }
        failure:^(NSError* error) {
        
        }
        isIndicator:YES MaskType:kMaskViewType_Deault];
}

//预付定金结算
+ (void)earnestSettleWithTransType:(NSString*)transType pointSum:(NSString*)pointSum perResNO:(NSString*)perResNo sourceTransAmount:(NSString*)sourceTransAmount equipmentNo:(NSString*)equipmentNo equipmentType:(NSString*)equipmentType sourceBatchNo:(NSString*)sourceBatchNo transAmount:(NSString*)transAmount pointRate:(NSString*)pointRate termRunCode:(NSString*)termRunCode oldSourceTransNo:(NSString*)oldSourceTransNo sourceTransNo:(NSString*)sourceTransNo orderAmount:(NSString*)orderAmount deductionVoucher:(NSString*)deductionVoucher success:(HTTPSuccess)success failure:(HTTPFailure)err
{
    NSDictionary* paramter = @{ @"transType" : transType,
        @"pointSum" : pointSum,
        @"sourceTransNo" : sourceTransNo,
        @"entResNo" : globalData.loginModel.entResNo,
        @"perResNo" : perResNo,
        @"channelType" : GYChannelType,
        @"sourceCurrencyCode" : globalData.config.currencyCode,
        @"sourceTransAmount" : sourceTransAmount,
        @"entCustId" : globalData.loginModel.entCustId,
        @"entName" : globalData.loginModel.entCustName,
        @"equipmentNo" : equipmentNo,
        @"equipmentType" : equipmentType,
        @"sourceBatchNo" : sourceBatchNo,
        @"transAmount" : transAmount,
        @"pointRate" : pointRate,
        @"termRunCode" : termRunCode,
        @"termTypeCode" : @"",
        @"termTradeCode" : @"",
        @"posToPsCount" : @"",
        @"currencyRate" : globalData.config.currencyToHsbRate,
        @"mallName" : @"",
        @"sourcePosDate" : @"",
        @"remark" : @"",
        @"oldSourceTransNo" : oldSourceTransNo,
        @"operNo" : globalData.loginModel.userName,
        @"orderAmount" : orderAmount,
        @"deductionVoucher" : deductionVoucher };
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYPOSEarnestSettle)
        parameter:paramter
        success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue) || [returnValue[GYNetWorkCodeKey] isEqualToNumber:@201]) { //只有201才需要冲正
                success ? success(returnValue) : nil;
            } else {
                [GYUtils showToast:kErrorReturncodeMsg];
                err ? err() : nil;
            }
            
        }
        failure:^(NSError* error) {
        
        }
        isIndicator:YES];
}

//退货
+ (void)returnGoodsWithOldTransNo:(NSString*)oldTransNo sourceTransNo:(NSString*)sourceTransNo sourceTransAmount:(NSString*)sourceTransAmount transAmount:(NSString*)transAmount termRunCode:(NSString*)termRunCode equipmentNo:(NSString*)equipmentNo secretCode:(NSString*)secretCode transPwd:(NSString*)pwd transType:(NSString*)transType perResNo:(NSString*)perResNo strBatchNo:(NSString*)strBatchNo success:(HTTPSuccess)success failure:(HTTPFailure)failure
{
    
    pwd = [pwd encodeWithKey:globalData.loginModel.entResNo];
    
    NSDictionary* paramar = @{ @"oldTransNo" : oldTransNo,
                               @"sourceTransNo" : sourceTransNo,
                               @"sourceTransAmount" : sourceTransAmount,
                               @"transAmount" : transAmount,
                               @"termRunCode" : termRunCode,
                               @"entResNo" : globalData.loginModel.entResNo,
                               @"equipmentNo" : equipmentNo,
                               @"loginPwd" : pwd,
                               @"transType" : transType,
                               @"perResNo" : perResNo,
                               @"sourceBatchNo" : strBatchNo,
                               @"currencyRate" : globalData.config.currencyToHsbRate,
                               @"operNo" : globalData.loginModel.userName,
                               @"sourceCurrencyCode" : globalData.config.currencyCode,
                               @"operNo" : globalData.loginModel.custId };
    
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYPOSBack) parameter:paramar success:^(id returnValue) {
        if(kHTTPSuccessResponse(returnValue) || [returnValue[GYNetWorkCodeKey] isEqualToNumber:@201]){
            success ? success(returnValue) : nil;
        }else{
            //            [GYUtils alertWithContext:kErrorReturncodeMsg buttonTitle:kLocalized(@"POS_Confirm") dismiss:^{
            //                err ? err() :nil;
            //            }];
        }
        
    } failure:^(NSError* error){
        
    }isIndicator:YES];
}

@end
