//
//  GYHSPayTool.h
//  company
//
//  Created by sqm on 16/7/17.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
//企业类型
typedef NS_ENUM(NSUInteger, GYHSPayMentViewControllerType) {
    
    GYHSPayMentViewControllerTypeHSCardPurchase, //消费者资源申购确认
    GYHSPayMentViewControllerTypeHSToolPurchase,//工具申购
    GYHSPayMentViewControllerTypePersonalityCarPurchase,//个性卡定制
    GYHSPayMentViewControllerTypeBehalf,//兑换互生币
    GYHSPayMentViewControllerTypeFee,//缴纳年费
};





@interface GYHSPayTool : NSObject
+ (void)ylPayWithOrderParameter:(NSDictionary *)parameter  success:(HTTPSuccess) success failure :(HTTPFailure) failure cancel:(HTTPCancel) cancel;//易联支付，参数为json字符串
+ (void)payOperateForYiPaymentWithOperateCode:(NSString *)code orderNo:(NSString *)orderNo transAmount:(NSString *) transAmount success:(HTTPSuccess) success  failure :(HTTPFailure) failure;
//查询银行卡列表
+ (void)getListQkBanksByBindingChannelWithCustId:(NSString *)custId UserType:(NSString *)userType BindingChannel:(NSString *)bindingChannel success:(HTTPSuccess)success failure:(HTTPFailure)failure;
//快捷支付接口
+ (void)getPinganQuickBindBankUrlWithCustId:(NSString *)custId success:(HTTPSuccess)success failure:(HTTPFailure)failure;
//短信验证码接口
+ (void)QuickPaymentSmsCodeTransNo:(NSString*)transNo
                         bindingNo:(NSString*)bindingNo bindingChannel:(NSString *)bindingChannel
                           success:(HTTPSuccess)success
                           failure:(HTTPFailure)failure;
//快捷支付接口（工具申购）
+ (void)PaymentByQuickPayOrderNo:(NSString*)orderNo
                         smsCode:(NSString*)smsCode
                       bindingNo:(NSString*)bindingNo
                      payChannel:(NSString*)payChannel bindingChannel:(NSString *)bindingChannel success:(HTTPSuccess)success failure:(HTTPFailure)failure;
//快捷支付接口(申购工具)
+ (void)paymentByQuickPayWithTransNo:(NSString*)transNo bindingNo:(NSString*)bindingNo smsCode:(NSString*)smsCode bindingChannel:(NSString *)bindingChannel success:(HTTPSuccess)success failure:(HTTPFailure)failure;
/**
 *  缴纳年费
 */
+ (void)payAnnualFeeOrderOrderNo:(NSString*)orderNo
                      payChannel:(NSString*)payChannel
                       bindingNo:(NSString*)bindingNo
                         smsCode:(NSString*)smsCode
                        tradePwd:(NSString*)tradePwd
                         success:(HTTPSuccess)success
                         failure:(HTTPFailure)failure;

+ (void)deleteQiuckBankWithAccId:(NSString*)accId success:(HTTPSuccess)success failure:(HTTPFailure)failure;

#pragma mark - 修改删除快捷卡接口
+ (void)getDeleteQiuckBankWithAccId:(NSString*)accId bindingNo:(NSString*)bindingNo success:(HTTPSuccess)success failure:(HTTPFailure)failure;

+ (void)paymentBycurrencyWithTransNo:(NSString*)transNo password:(NSString*)pwd success:(HTTPSuccess)success failure:(HTTPFailure)failure; //企业 兑换互生币货币支付
@end
