//
//  GYAPI.h
//  company
//
//  Created by apple on 15/8/26.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *    设置交易密码控制器变化
 */
FOUNDATION_EXPORT NSString* const GYSetSafeChageVCNotification; 

/**
 *    积分比率注册，修改成功通知
 */
FOUNDATION_EXPORT NSString* const GYSetPointSuccesssNotification;
/**
 *     互生 添加/删除银行卡 或需要更新主界面
 */
FOUNDATION_EXPORT NSString* const GYChangeBankCardOrChageMainHSNotification;
/**
 *     上传开发许可证保存文件通知主界面
 */
FOUNDATION_EXPORT NSString* const GYBankOpenLicenseMainHSNotification;
/**
 *     删除所选的银行卡
 */
FOUNDATION_EXPORT NSString* const GYDeleteBankCardSNotification;
/**
 *     删除所选的快捷支付卡
 */
FOUNDATION_EXPORT NSString* const GYDeleteQuickCardSNotification;

/*!
 *    更换头像成功
 */
FOUNDATION_EXPORT NSString* const GYChangeHeadImageNotification;
/*!
 *    参与、停止积分活动、成员企业注销状态更新通知
 */
FOUNDATION_EXPORT NSString* const GYPointAndMemberCancelStatusNotification;

/*!
 *    全局退出登录通知
 */
FOUNDATION_EXPORT NSString* const GYCommonLogoutNotification;





/**
 *     刷卡器获取积分比例
 */
FOUNDATION_EXPORT NSString *const GYGetPointRateSuccessNotification;
/**
 *     开始刷卡通知
 */
FOUNDATION_EXPORT NSString *const GYPOSOperationStartNotification;
/**
 *     刷卡器操作出错通知
 */
FOUNDATION_EXPORT NSString *const GYPOSOperationErrorNotification;
/**
 *     刷卡器断开通知
 */
FOUNDATION_EXPORT NSString *const GYPOSDisconnectNotification;
/**
 *    要求输入 6位登录密码信息
 */
FOUNDATION_EXPORT NSString *const GYPOSShounldInputLoginPasswordNotification;
/**
 *     要求输入 8位交易密码
 */
FOUNDATION_EXPORT NSString *const GYPOSShounldInputTradingPasswordNotification;
/**
 *     刷卡器信息
 */
FOUNDATION_EXPORT NSString *const GYPosDeviceInfoNotification;
/**
 *     获取卡信息
 */
FOUNDATION_EXPORT NSString *const GYCardNumAndCipherNotification;

/**
 *  个性定制卡下单成功
 */
FOUNDATION_EXPORT NSString* const GYHSCardSubMitOrderSuccessNotification;




#pragma mark - 头部控制器相关
/**
 *     左侧历史菜单按钮点击事件
 */
FOUNDATION_EXPORT NSString *const GYCommonHistoryBtnClickNotification;
/**
 *     消息按钮点击事件
 */
FOUNDATION_EXPORT NSString *const GYCommonMessageBtnClickNotification;
/**
 *     回到根控制器事件
 */
FOUNDATION_EXPORT NSString *const GYCommonPopRootNotification;

/**
 *  登录成功事件
 */
FOUNDATION_EXPORT NSString* const GYCommonLoginSuccessNotification;






