//
//  GYAccounTradeAlertView.h
//  HSConsumer
//
//  Created by ios007 on 15/12/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  账户交易提示框的封装View

#import <UIKit/UIKit.h>

//账户交易确认提示框->一个确定按钮和一个取消按钮
#import "GYAccounTradeConfirmAlertView.h"
//账户交易结果提示框->只有一个确定按钮
#import "GYAccounTradeResultAlertView.h"

typedef void (^buttonClickBlock)(NSInteger buttonIndex);

@interface GYAccounTradeAlertView : UIView

//GYAccounTradeConfirmAlertView(类)
@property (nonatomic, weak) GYAccounTradeConfirmAlertView* alertViewAccounTradeConfirm;
/**
 *  弹出简单的交易前确认框，有“取消”和“确定”按钮。需设置GYAccounTradeConfirmAlertView(类)控件的属性
 */
- (void)showAccounTradeConfirmAlertView;

/**
 *  弹出简单的交易前确认框，有“取消”和“确定”按钮。需传入contentText参数来简单设置正文的内容alertContentLabel.text
 *  @param: GYAccounTradeConfirmAlertView(类) : contentText
 */
- (void)showAccounTradeConfirmAlertViewWithcontentText:(NSString*)contentText;

//GYAccounTradeResultAlertView(类)
@property (nonatomic, weak) GYAccounTradeResultAlertView* alertViewAccounTradeResult;
/**
 *  弹出交易后结果确认框，有确定”按钮。需设置GYAccounTradeResultAlertView(类)控件的属性
 */
- (void)showAccounTradeResultAlertView;

/**
 *  弹出简单的交易后结果确认框，有确定”按钮。需传入contentText参数和contentDetailTex(可为空)参数来简单设置正文的内容alertContentLabel.text和正文详细信息内容alertContentDetailLabel.text
 *  @param: GYAccounTradeResultAlertView(类) : contentText,contentDetailTex
 */
- (void)showAccounTradeResultAlertViewWithSuccess:(BOOL)isSuccess contentText:(NSString *)contentText contentDetailText:(NSString *)contentDetailText;


//按钮点击回调
- (void)setButtonClickBlock:(buttonClickBlock)buttonClickBlock;

//提示框消失
- (void)accounTradeAlertViewDismiss;

@end
