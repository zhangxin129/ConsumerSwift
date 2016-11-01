//
//  GYHEReAfSaleHttpTool.m
//  HSCompanyPad
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHEReAfSaleHttpTool.h"
#import "GYNetwork.h"
#import "GYNetApiMacro.h"
#import "GYUtilsConst.h"
#import <MJExtension/MJExtension.h>
#import "GYUtils+companyPad.h"

@implementation GYHEReAfSaleHttpTool

//获取交易流水号
+ (void)getSourceTransNoWithsuccess:(HTTPSuccess)success failure:(HTTPFailure)failure
{
    NSDictionary* paramar = @{ @"entResNo" : globalData.loginModel.entResNo };
    
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYPOSSourceTransNo) parameter:paramar success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue)) {
            NSString *sourceNo = [self getNewSourceNo:returnValue[GYNetWorkDataKey]];
            KExcuteBlock(success,sourceNo);
            
        }else {
        
            KExcuteBlock(failure,nil);
        }
        
    } failure:^(NSError* error){
    
    }isIndicator:YES];
}

+ (NSString*)getNewSourceNo:(NSString*)sourceNo //转换交易流水号
{
    if ([sourceNo hasPrefix:@"9"]) {
        return [sourceNo stringByAppendingString:@"3"];
    }
    else {
        return [@"3" stringByAppendingString:sourceNo];
    }
}
//退货
+ (void)returnGoodsWithOldTransNo:(NSString*)oldTransNo sourceTransNo:(NSString*)sourceTransNo sourceTransAmount:(NSString*)sourceTransAmount transAmount:(NSString*)transAmount termRunCode:(NSString*)termRunCode equipmentNo:(NSString*)equipmentNo secretCode:(NSString*)secretCode transPwd:(NSString*)pwd transType:(NSString*)transType perResNo:(NSString*)perResNo strBatchNo:(NSString*)strBatchNo success:(HTTPSuccess)success failure:(HTTPFailure)err
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
