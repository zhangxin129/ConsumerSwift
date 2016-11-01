//
//  GYAPI.m
//  company
//
//  Created by apple on 15/8/26.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYNotificationConst.h"

NSString* const GYSetSafeChageVCNotification = @"haveSetTracePassWord";
NSString* const GYSetPointSuccesssNotification =
@"GYSetPointSuccesssNotification";
NSString* const GYChangeBankCardOrChageMainHSNotification = @"GYChangeBankCardOrChageMainHSNotification";
NSString* const GYBankOpenLicenseMainHSNotification = @"GYBankOpenLicenseMainHSNotification";
NSString* const GYDeleteBankCardSNotification = @"GYDeleteBankCardSNotification";
NSString* const GYDeleteQuickCardSNotification = @"GYDeleteQuickCardSNotification";
NSString* const GYChangeHeadImageNotification = @"GYChangeHeadImageNotification";
NSString* const GYPointAndMemberCancelStatusNotification = @"GYPointAndMemberCancelStatusNotification";


/*!
 *    全局退出登录通知
 */
NSString* const GYCommonLogoutNotification = @"GYCommonLogoutNotification";


/**
 *     刷卡器获取积分比例
 */
NSString* const GYGetPointRateSuccessNotification = @"GYGetPointRateSuccessNotification";
/**
 *     开始刷卡通知
 */
NSString* const GYPOSOperationStartNotification = @"GYPOSOperationStartNotification";
/**
 *     刷卡器操作出错通知
 */
NSString* const GYPOSOperationErrorNotification = @"GYPOSOperationErrorNotification";
/**
 *     刷卡器断开通知
 */
NSString* const GYPOSDisconnectNotification = @"GYPOSDisconnectNotification";
/**
 *    要求输入 6位登录密码信息
 */
NSString* const GYPOSShounldInputLoginPasswordNotification = @"GYPOSShounldInputLoginPasswordNotification";
/**
 *     要求输入 8位交易密码
 */
NSString* const GYPOSShounldInputTradingPasswordNotification = @"GYPOSShounldInputTradingPasswordNotification";
/**
 *     刷卡器信息
 */
NSString* const GYPosDeviceInfoNotification = @"GYPosDeviceInfoNotification";
/**
 *     获取卡信息
 */
NSString *const GYCardNumAndCipherNotification = @"GYCardNumAndCipherNotification";

/**
 *  个性定制卡下单成功
 */
NSString* const GYHSCardSubMitOrderSuccessNotification = @"GYHSCardSubMitOrderSuccessNotification";




#pragma mark - 头部控制器相关
/**
 *     左侧历史菜单按钮点击事件
 */
 NSString *const GYCommonHistoryBtnClickNotification = @"GYCommonHistoryBtnClickNotification";
/**
 *     消息按钮点击事件
 */
 NSString *const GYCommonMessageBtnClickNotification = @"GYCommonMessageBtnClickNotification";
/**
 *     回到根控制器事件
 */
 NSString *const GYCommonPopRootNotification = @"GYCommonPopRootNotification";

/**
 *  登录成功事件
 */
NSString* const GYCommonLoginSuccessNotification = @"GYCommonLoginSuccessNotification";





#define kNotifyHeadRefresh @"headRefresh"




