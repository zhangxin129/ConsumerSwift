//
//  GYHSPayTool.m
//  company
//
//  Created by sqm on 16/7/17.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSPayTool.h"
#import "libPayecoPayPlugin.h"
#import <GYKit/NSDictionary+GYJSONString.h>
#import "GYNetwork.h"
#import <YYKit/NSDictionary+YYAdd.h>
#import <YYKit/NSString+YYAdd.h>
#import <YYKit/NSData+YYAdd.h>
#define kYLPayPluginMode ((kisReleaseEn ||[GYLoginEn sharedInstance].loginLine == kLoginEn_preRelease ||[GYLoginEn sharedInstance].loginLine == kLoginEn_test_realPay || [GYLoginEn sharedInstance].loginLine == kLoginEn_release)?@"01":@"00")//00测试环境 01生产环境 //预生产环境与生产环境配置一样
#define  GYYLPayOrientationConfig  @"00"
@interface GYHSPayTool ()<PayEcoPpiDelegate>
@property (nonatomic, copy) HTTPFailure failureBlock;
@property (nonatomic, copy) HTTPSuccess successBlock;
@property (nonatomic, copy) HTTPCancel cancelBlock;
@end

@implementation GYHSPayTool
/**
 *  易联支付获取支付要素接口
 *
 *  @param code        操作码
 *  @param orderNo     订单号
 *  @param transAmount 订单金额
 */
+ (void)payOperateForYiPaymentWithOperateCode:(NSString *)code orderNo:(NSString *)orderNo transAmount:(NSString *) transAmount success:(HTTPSuccess) success  failure :(HTTPFailure) failure {
    
    
    [GYNetwork POST:GY_ReDOMAINAPPENDING(GYCommonYiPay)  parameter:@{@"operateCode":code,@"orderNo":orderNo,@"transAmount":[NSString stringWithFormat:@"%.2f", transAmount.doubleValue],@"":@"",@"key":globalData.loginModel.token} success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue)) {
            KExcuteBlock(success,returnValue[GYNetWorkDataKey]);
        }
    } failure:^(NSError *error) {
        
    } isIndicator:YES];
   
    
}

/**
 *  易联支付
 *
 *  @param parameter 参数字典
 */
+ (void)ylPayWithOrderParameter:(NSDictionary *)parameter  success:(HTTPSuccess) success failure :(HTTPFailure) failure cancel:(HTTPCancel)cancel
{

    
    NSString *parameterS = parameter.toJSONString;
  
    GYHSPayTool *payTool = [[GYHSPayTool alloc]init];
    payTool.failureBlock = failure;
    payTool.successBlock = success;
    payTool.cancelBlock =  cancel;
    
    PayEcoPpi * payEcoPpi = [[PayEcoPpi alloc] init];
    [payEcoPpi startPay:parameterS delegate:payTool env:kYLPayPluginMode orientation:GYYLPayOrientationConfig];
}


#pragma mark - PayEcoPpiDelegate

- (void)payResponse:(NSString *)respJsonStr{
 
    NSData *data = [respJsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data
                                                          options:kNilOptions
                                                            error:nil];
    NSString *respCode  = [dict objectForKey:@"respCode"];

    if ([respCode isEqualToString:@"0000"]) {
        if (self.successBlock) {
            self.successBlock(dict);
        }
    }else if ([respCode isEqualToString:@"w101"]){
        if (self.cancelBlock) {
            self.cancelBlock();
        }
        
    }else {
        if (self.failureBlock) {
            self.failureBlock();
        }
    
    }
}
/**
 *  查询银行卡列表
 *
 *  @param custId         操作员客户id
 *  @param userType       企业类型
 *  @param bindingChannel 支付类型
*/
+ (void)getListQkBanksByBindingChannelWithCustId:(NSString *)custId UserType:(NSString *)userType BindingChannel:(NSString *)bindingChannel success:(HTTPSuccess)success failure:(HTTPFailure)failure{
    
    NSDictionary *paramer = @{@"custId":custId,
                              @"userType":userType,
                              @"bindingChannel":bindingChannel};
    [GYNetwork GET:GY_ReDOMAINAPPENDING(GYHSGETListQkBanksUrl) parameter:paramer success:^(id returnValue) {
        KExcuteBlock(success,returnValue);
    } failure:^(NSError *error) {
        
    }isIndicator:YES];
    
}

/**
 *  绑定快捷卡接口
 *
 *  @param custId  操作员客户id
 */
+ (void)getPinganQuickBindBankUrlWithCustId:(NSString *)custId success:(HTTPSuccess)success failure:(HTTPFailure)failure{

    NSDictionary* paramer = @{ @"custId" : custId
                               };
    
    [GYNetwork GET:GY_ReDOMAINAPPENDING(GYHSGetPinganQuickBindBankUrl) parameter:paramer success:^(id returnValue) {
        if(kHTTPSuccessResponse(returnValue)){
            KExcuteBlock(success,returnValue)
        }else{
    
        }

    } failure:^(NSError *error) {
        
    }isIndicator:YES];
}

/**
 *  短信验证码接口
 *
 *  @param transNo        订单号
 *  @param bindingNo      绑定银行卡号
 *  @param bindingChannel 签约渠道
 */
+ (void)QuickPaymentSmsCodeTransNo:(NSString*)transNo
                         bindingNo:(NSString*)bindingNo bindingChannel:(NSString *)bindingChannel
                           success:(HTTPSuccess)success
                           failure:(HTTPFailure)failure{
    NSDictionary *paramer = @{@"transNo" : transNo,
                              @"bindingNo" : bindingNo,
                              @"bindingChannel":bindingChannel};
    
    [GYNetwork GET:GY_ReDOMAINAPPENDING(GYHSGetQuickPaySmsCode) parameter:paramer success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue)) {
            KExcuteBlock(success,returnValue[GYNetWorkDataKey])
            
        }else {

        }

    } failure:^(NSError *error) {
        
    }isIndicator:YES];
}

/**
 *  快捷支付接口(申购工具)
 *
 *  @param orderNo        订单号
 *  @param smsCode        短信验证码
 *  @param bindingNo      银行卡号
 *  @param payChannel     支付方式
 *  @param bindingChannel 签约渠道
 */
+ (void)PaymentByQuickPayOrderNo:(NSString*)orderNo
                         smsCode:(NSString*)smsCode
                       bindingNo:(NSString*)bindingNo
                      payChannel:(NSString*)payChannel bindingChannel:(NSString *)bindingChannel success:(HTTPSuccess)success failure:(HTTPFailure)failure{
    NSDictionary *paramar = @{ @"orderNo" : orderNo,
                               @"smsCode" : smsCode,
                               @"bindingNo" : bindingNo,
                               @"custId" : globalData.loginModel.entCustId,
                               @"userType" : GYUserTypeCompany,
                               @"payChannel" : payChannel,
                               @"bindingChannel": bindingChannel
                               };
    [GYNetwork POST:GY_ReDOMAINAPPENDING(GYHSPayPurchaseToolOrder) parameter:paramar success:^(id returnValue) {
        if(kHTTPSuccessResponse(returnValue) || [returnValue[GYNetWorkCodeKey] isEqualToNumber:@50086]){//如果验证码错误需要特殊处理故此返回
            KExcuteBlock(success,returnValue);
            
        }else{
        }

    } failure:^(NSError *error) {
        
    }isIndicator:YES];
   
}
//快捷支付接口(兑换互生币)
+ (void)paymentByQuickPayWithTransNo:(NSString*)transNo bindingNo:(NSString*)bindingNo smsCode:(NSString*)smsCode bindingChannel:(NSString *)bindingChannel success:(HTTPSuccess)success failure:(HTTPFailure)failure{
    [GYNetwork POST:GY_ReDOMAINAPPENDING(GYHSPaymentByQuickPay) parameter:@{ @"transNo" : transNo,
                                                                             @"bindingNo" : bindingNo,
                                                                             @"smsCode" : smsCode,
                                                                             @"custId" : globalData.loginModel.entCustId,
                                                                             @"userType" : GYUserTypeCompany,
                                                                             @"bindingChannel":bindingChannel
                                                                             } success:^(id returnValue) {
                                                                                 if(kHTTPSuccessResponse(returnValue) || [returnValue[GYNetWorkCodeKey] isEqualToNumber:@50086]){
                                                                                     KExcuteBlock(success,returnValue)
                                                                                 }
                                                                             }failure:^(NSError *failure) {
                                            }];
}

/**
 *   缴纳年费
 *
 *  @param orderNo    订单号
 *  @param payChannel 支付方式
 *  @param bindingNo  银行卡号
 *  @param smsCode    短信验证码
 *  @param tradePwd   交易密码
 */
+ (void)payAnnualFeeOrderOrderNo:(NSString*)orderNo
                      payChannel:(NSString*)payChannel
                       bindingNo:(NSString*)bindingNo
                         smsCode:(NSString*)smsCode
                        tradePwd:(NSString*)tradePwd
                         success:(HTTPSuccess)success
                         failure:(HTTPFailure)failure{
    tradePwd = tradePwd.md5String;
    NSDictionary* paramters = [NSDictionary dictionary];
    
    if ([payChannel isEqualToString:GYPayChannelMobliePay]) {
        paramters = @{ @"orderNo" : orderNo,
                       @"payChannel" : payChannel,
                       @"custId" : globalData.loginModel.entCustId,
                       @"orderOperator" : globalData.loginModel.custId,
                       @"userType" : GYUserTypeCompany
                       };
    }
    else if ([payChannel isEqualToString:GYPayChannelHSBPay]) {
        paramters = @{ @"orderNo" : orderNo,
                       @"payChannel" : payChannel,
                       @"custId" : globalData.loginModel.entCustId,
                       @"orderOperator" : globalData.loginModel.custId,
                       @"tradePwd" : tradePwd,
                       @"userType" : GYUserTypeCompany
                       };
    }
    else if ([payChannel isEqualToString:GYPayChannelQuickPay]) {
        paramters = @{ @"orderNo" : orderNo,
                       @"payChannel" : payChannel,
                       @"custId" : globalData.loginModel.entCustId,
                       @"orderOperator" : globalData.loginModel.custId,
                       @"bindingNo" : bindingNo,
                       @"smsCode" : smsCode,
                       @"userType" : GYUserTypeCompany
                       };
    }
    
    
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSPayAnnualFeeOrder) parameter:paramters success:^(id returnValue) {
        if ([payChannel isEqualToString:GYPayChannelQuickPay]) {
            if (kHTTPSuccessResponse(returnValue)|| [returnValue[GYNetWorkCodeKey] isEqualToNumber:@50086]) {
                KExcuteBlock(success,returnValue)
            }else {

            }
        }else {
            
            if (kHTTPSuccessResponse(returnValue)) {
                KExcuteBlock(success,returnValue[GYNetWorkDataKey])
            }else {
            }
        }
    } failure:^(NSError *error) {
        
    }isIndicator:YES];
}

/**
 *  删除快捷支付卡
 *
 *  @param accId   账户ID
 */
+ (void)deleteQiuckBankWithAccId:(NSString*)accId success:(HTTPSuccess)success failure:(HTTPFailure)failure
{
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSUnBindQKBank)
         parameter:@{ @"accId" : accId}
           success:^(id returnValue) {
               if (kHTTPSuccessResponse(returnValue)) {
                   KExcuteBlock(success, returnValue[GYNetWorkDataKey])
               } else {
                   [GYUtils showToast:kErrorReturncodeMsg];
                   KExcuteBlock(failure, nil)
               }
           }
           failure:^(NSError* error) {
               
           }
       isIndicator:YES];
}

#pragma mark - 修改删除快捷卡接口
+ (void)getDeleteQiuckBankWithAccId:(NSString*)accId bindingNo:(NSString*)bindingNo success:(HTTPSuccess)success failure:(HTTPFailure)failure
{
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSUnBindQKBank)
         parameter:@{ @"accId" : accId,
                      @"custId":globalData.loginModel.entCustId,
                      @"bindingNo":bindingNo}
           success:^(id returnValue) {
               if (kHTTPSuccessResponse(returnValue)) {
                   KExcuteBlock(success, returnValue[GYNetWorkDataKey])
               } else {
                   [GYUtils showToast:kErrorReturncodeMsg];
                   KExcuteBlock(failure, nil)
               }
           }
           failure:^(NSError* error) {
               
           }
       isIndicator:YES];
}

+ (void)paymentBycurrencyWithTransNo:(NSString*)transNo password:(NSString*)pwd success:(HTTPSuccess)success failure:(HTTPFailure)failure{
    pwd = pwd.md5String;
    NSDictionary *paramar = @{ @"transNo" : transNo,
                               @"userType" : GYUserTypeCompany,
                               @"pwd" : pwd,
                               @"custId" : globalData.loginModel.entCustId };
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSPaymentByCurrency) parameter:paramar success:^(id returnValue) {
        KExcuteBlock(success,returnValue);
    } failure:^(NSError *error) {
        
    }isIndicator:YES];
    
}
@end
