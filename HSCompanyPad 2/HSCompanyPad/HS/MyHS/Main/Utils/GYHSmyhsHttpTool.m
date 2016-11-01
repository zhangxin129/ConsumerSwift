//
//  GYHSmyhsHttpTool.m
//  HSCompanyPad
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSmyhsHttpTool.h"
#import "GYGIFHUD.h"
#import "GYNetwork.h"
#import <GYKit/GYPinYinConvertTool.h>
#import <MJExtension/MJExtension.h>
@implementation GYHSmyhsHttpTool
/**
 *  获取企业资格状态
 */
+ (void)GetEntStatus:(HTTPSuccess)success
             failure:(HTTPFailure)err
{
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSGetEntStatus)
        parameter:@{ @"entCustId" : globalData.loginModel.entCustId }
        success:^(id returnValue) {
            if ([returnValue[GYNetWorkDataKey] isKindOfClass:[NSDictionary class]]) {
                KExcuteBlock(success, returnValue[GYNetWorkDataKey])
            } else {
                [GYUtils showToast:kErrorReturncodeMsg];
                KExcuteBlock(err, nil)
            }
            
        }
        failure:^(NSError* error) {
        
        }
        isIndicator:YES MaskType:kMaskViewType_Deault];
}

+ (void)uploadImageWithUrl:(NSString*)url params:(NSDictionary*)params imageData:(NSData*)imageData imageName:(NSString*)name success:(HTTPSuccess)success failure:(HTTPFailure)err
{
    [GYNetwork UPLOAD:url imageData:imageData imageName:name success:^(id returnValue) {
        KExcuteBlock(success,returnValue);
    } failure:^(NSError *error) {
        KExcuteBlock(err,nil);

    }];
}

+ (void)getCompanyBindAccountListWithSuccess:(HTTPSuccess)success failure:(HTTPFailure)err
{
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSListBindBank)
        parameter:@{ @"custId" : globalData.loginModel.entCustId,
            @"userType" : @"4" }
        success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue)) {
                KExcuteBlock(success, returnValue[GYNetWorkDataKey])
            } else {
                [GYUtils showToast:kErrorReturncodeMsg];
                KExcuteBlock(err, nil)
            }
            
        }
        failure:^(NSError* error) {
        
        }
        isIndicator:YES
        MaskType:kMaskViewType_Deault];
}

+ (void)createMemberQuitWithbankAcctId:(NSString*)bankAcctId
                           applyReason:(NSString*)reason
                             applyFile:(NSString*)file
                               success:(HTTPSuccess)success
                               failure:(HTTPFailure)err
{
    NSDictionary* paramters = @{ @"entCustName" : globalData.loginModel.entCustName,
        @"applyType" : @1,
        @"entResNo" : globalData.loginModel.entResNo,
        @"createdBy" : [NSString stringWithFormat:@"%@(%@)", globalData.loginModel.userName, globalData.loginModel.operName],
        @"bankAcctId" : bankAcctId,
        @"entCustId" : globalData.loginModel.entCustId,
        @"oldStatus" : @2,
        @"applyReason" : reason,
        @"bizApplyFile" : file
    };
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSCreateMemberQuit)
        parameter:paramters
        success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue)) {
                KExcuteBlock(success, returnValue[GYNetWorkDataKey]);
            } else {
                [GYUtils showToast:kErrorReturncodeMsg];
                KExcuteBlock(err, nil)
            }
            
        }
        failure:^(NSError* error) {
        
        }
        isIndicator:YES];
}

+ (void)createPointActivityApplyReason:(NSString*)applyReason
                             oldStatus:(NSNumber*)oldStatus
                             applyType:(NSNumber*)applyType
                          bizApplyFile:(NSString*)bizApplyFile
                               success:(HTTPSuccess)success
                               failure:(HTTPFailure)err
{
    NSDictionary* paramters = @{ @"entCustId" : globalData.loginModel.entCustId,
        @"entCustName" : globalData.loginModel.entCustName,
        @"createdBy" : [NSString stringWithFormat:@"%@(%@)", globalData.loginModel.userName, globalData.loginModel.operName],
        @"applyType" : applyType,
        @"applyReason" : applyReason,
        @"oldStatus" : oldStatus,
        @"entResNo" : globalData.loginModel.entResNo,
        @"bizApplyFile" : bizApplyFile
    };
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSCreatePointActivity)
        parameter:paramters
        success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue)) {
                KExcuteBlock(success, returnValue);
            } else {
                [GYUtils showToast:kErrorReturncodeMsg];
                KExcuteBlock(err, nil)
            }
            
        }
        failure:^(NSError* error) {
        
        }
        isIndicator:YES];
}

+ (void)unBindBankWithAccId:(NSString*)accId success:(HTTPSuccess)success failure:(HTTPFailure)err
{
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSUnBindBank)
        parameter:@{ @"accId" : accId,
            @"userType" : GYUserTypeCompany }
        success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue)) {
                KExcuteBlock(success, returnValue[GYNetWorkDataKey])
            } else {
                [GYUtils showToast:kErrorReturncodeMsg];
                KExcuteBlock(err, nil)
            }
        }
        failure:^(NSError* error) {
        
        }
        isIndicator:YES];
}

+ (void)deleteQiuckBankWithAccId:(NSString*)accId bindingNo:(NSString*)bindingNo success:(HTTPSuccess)success failure:(HTTPFailure)err
{
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSUnBindQKBank)
        parameter:@{@"accId" : accId,
                    @"custId":globalData.loginModel.entCustId,
                    @"bindingNo":bindingNo}
        success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue)) {
                KExcuteBlock(success, returnValue[GYNetWorkDataKey])
            } else {
                [GYUtils showToast:kErrorReturncodeMsg];
                KExcuteBlock(err, nil)
            }
        }
        failure:^(NSError* error) {
        
        }
        isIndicator:YES];
}

+ (void)bindBankInfoWithBankCode:(NSString*)bankCode bankName:(NSString*)bankName bankAcctNo:(NSString*)bankAcctNo countryCode:(NSString*)countryCode provinceCode:(NSString*)provinceCode cityCode:(NSString*)cityCode isDefault:(NSString*)isDefault success:(HTTPSuccess)success failure:(HTTPFailure)err
{
    NSDictionary* paramer = @{ @"bankCode" : bankCode,
        @"bankName" : bankName,
        @"bankAcctNo" : bankAcctNo,
        @"isDefault" : isDefault,
        @"userType" : GYUserTypeCompany,
        @"custId" : globalData.loginModel.entCustId,
        @"bankBranch" : bankName,
        @"countryCode" : countryCode,
        @"provinceCode" : provinceCode,
        @"cityCode" : cityCode,
        @"acctType" : @"4",
        @"bankAccName" : globalData.loginModel.entCustName,
        @"hsResNo" : globalData.loginModel.entResNo };
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSBindBank)
        parameter:paramer
        success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue)) {
                KExcuteBlock(success, returnValue[GYNetWorkDataKey])
            } else {
                [GYUtils showToast:kErrorReturncodeMsg];
                KExcuteBlock(err, nil)
            }
        }
        failure:^(NSError* error) {
        
        }
        isIndicator:YES];
}

+ (void)ListQkBanks:(HTTPSuccess)success failure:(HTTPFailure)err
{
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSListQkBanks)
        parameter:@{ @"custId" : globalData.loginModel.entCustId,
            @"userType" : GYUserTypeCompany }
        success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue)) {
                KExcuteBlock(success, returnValue[GYNetWorkDataKey])
            } else {
                [GYUtils showToast:kErrorReturncodeMsg];
                KExcuteBlock(err, nil)
            }
        }
        failure:^(NSError* error) {
        
        }
        isIndicator:YES
        MaskType:kMaskViewType_Deault];
}

+ (void)getEntRealnameAuthByCustId:(HTTPSuccess)success failure:(HTTPFailure)err
{
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSGetEntRealnameAuthByCustId)
        parameter:@{ @"custId" : globalData.loginModel.entCustId }
        success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue)) {
                KExcuteBlock(success, returnValue[GYNetWorkDataKey])
            } else {
                [GYUtils showToast:kErrorReturncodeMsg];
                KExcuteBlock(err, nil)
            }
        }
        failure:^(NSError* error) {
        
        }
        isIndicator:YES];
}

+ (void)getEntRealnameAuthByhsResNo:(HTTPSuccess)success failure:(HTTPFailure)err
{
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSGetEntRealnameAuthByhsResNo)
        parameter:@{ @"hsResNo" : globalData.loginModel.entResNo }
        success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue)) {
                KExcuteBlock(success, returnValue[GYNetWorkDataKey])
            } else {
                [GYUtils showToast:kErrorReturncodeMsg];
                KExcuteBlock(err, nil)
            }
        }
        failure:^(NSError* error) {
        
        }
        isIndicator:YES];
}

+ (void)createEntRealNameAuthWithparamters:(NSDictionary*)paramters success:(HTTPSuccess)success failure:(HTTPFailure)err
{
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSCreateEntRealNameAuth)
        parameter:paramters
        success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue)) {
                KExcuteBlock(success, returnValue)
            } else {
                [GYUtils showToast:kErrorReturncodeMsg];
                KExcuteBlock(err, nil)
            }
            
        }
        failure:^(NSError* error) {
        
        }
        isIndicator:YES];
}

+ (void)getQueryBank:(HTTPSuccess)success failure:(HTTPFailure)err
{
    NSString* bankPath = @"GYHSBankListKey";
    NSMutableDictionary* bankInfoDictM = (NSMutableDictionary*)[GYUtils readFromPath:bankPath];
    if (bankInfoDictM.allKeys.count > 0) {
        KExcuteBlock(success, bankInfoDictM);
        return;
    }
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSQueryBank)
        parameter:nil
        success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue)) {
                NSMutableArray* bankListArrM = @[].mutableCopy;
                for (NSDictionary* dict in returnValue[GYNetWorkDataKey]) {
                    BankModel* model = [BankModel mj_objectWithKeyValues:dict];
                    [bankListArrM addObject:model];
                }
                NSMutableDictionary* dictM = @{}.mutableCopy;
                [self fetchBankListDeal:bankListArrM nameDict:dictM];
                [GYUtils writeModel:dictM toPath:bankPath];
                
                KExcuteBlock(success, dictM)
                
            } else {
                KExcuteBlock(err, nil)
            }
            
        }
        failure:^(NSError* error) {
        
        }
        isIndicator:YES];
}

#define ALPHA_ARRAY [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil]

+ (void)fetchBankListDeal:(NSArray*)array nameDict:(NSMutableDictionary*)dictionary
{

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [ALPHA_ARRAY enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
            NSString* string = [ALPHA_ARRAY objectAtIndex:idx];
            NSMutableArray* temp = [[NSMutableArray alloc] init];
            __block BOOL realExist = NO;
            [array enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
                NSString* tempStr = [NSString string];
                BankModel* mod = [array objectAtIndex:idx];
                if ([GYPinYinConvertTool isIncludeChineseInString:mod.bankName]) {
                    if ([mod.bankName hasPrefix:@"长"] || [mod.bankName hasPrefix:@"重"]) {
                        tempStr = @"c";
                    } else {
                        tempStr = [GYPinYinConvertTool chineseConvertToPinYinHead:mod.bankName];
                    };
                    if ([tempStr hasPrefix:string] || [tempStr hasPrefix:[string lowercaseString]]) {
                        [temp addObject:mod];
                        realExist = YES;
                    }
                }
                
                if ([mod.bankName hasPrefix:string] || [mod.bankName hasPrefix:[string lowercaseString]]) {
                    [temp addObject:mod];
                    realExist = YES;
                }
            }];
            if (realExist) {
                [dictionary setObject:temp forKey:string];
            }
        }];
    });
}

+ (void)queryImageDocListWithSuccess:(HTTPSuccess)success failure:(HTTPFailure)failure
{
    
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSQueryDocExampleList) parameter:nil success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue) && [returnValue[GYNetWorkDataKey] isKindOfClass:[NSArray class]]) {
            KExcuteBlock(success,returnValue[GYNetWorkDataKey])
            
        }else {
            if (failure) {
                failure();
            }
        }
        
        
    } failure:^(NSError *error) {
        
    }isIndicator:YES];
    
}

//查询示例图片
+ (void)getQueryImageDocListWithSuccess:(HTTPSuccess)success failure:(HTTPFailure)failure
{
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSQueryImageExampleList) parameter:nil success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue) && [returnValue[GYNetWorkDataKey] isKindOfClass:[NSArray class]]) {
            KExcuteBlock(success,returnValue[GYNetWorkDataKey])
            
        }else {
            if (failure) {
                failure();
            }
        }
        
        
    } failure:^(NSError *error) {
        
    }isIndicator:YES];
}

+ (void)saveBankOpenLiceseWithFile:(NSString *)file success:(HTTPSuccess)success failure:(HTTPFailure)err
{
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSBankUpdateInfo)
         parameter:@{@"entCustId":globalData.loginModel.entCustId,
                     @"accountLicenseImg": file,
                     @"operatorCustId":globalData.loginModel.custId}
           success:^(id returnValue) {
               if (kHTTPSuccessResponse(returnValue)) {
                        KExcuteBlock(success, returnValue)
               } else {
                   [GYUtils showToast:kErrorReturncodeMsg];
                        KExcuteBlock(err, nil)
               }
           } failure:^(NSError *error) {
               
           }];
}
@end
