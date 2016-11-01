//
//  GYAlertShowDataWithOKButtonView.h
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 *    对OK按钮的点击后视图进行修改 增加新的自定义的显示内容
 */

@interface GYAlertShowDataWithOKButtonView : UIView
//之前自定义的方法
+ (GYAlertShowDataWithOKButtonView *)alertWithMessage:(NSString *)message topColor:(TopColor)topColor canUseNum:(NSString *)strOne turnOutNum:(NSString *)strTwo changeCoinNum:(NSString *)strThree comfirmBlock:(dispatch_block_t)block;  //积分转互生币界面的点击OK跳转方法

//再自定义一个在积分投资界面的跳转方法
+ (GYAlertShowDataWithOKButtonView *)alertPointInvestment:(NSString *)message topColor:(TopColor)topColor canUseNum:(NSString *)strOne turnOutNum:(NSString *)strTwo comfirmBlock:(dispatch_block_t)block;


//定义一个在货币转银行界面的OK点击
+ (GYAlertShowDataWithOKButtonView *)alertCoinToBank:(NSString *)message topColor:(TopColor)topColor canUseNum:(NSString *)strOne cardName:(NSString *)strTwo cardNum:(NSString *)strThree turnOutNum:(NSString *)strFour turnFee:(NSString *)strFive isValidAccount:(NSString *)isValidAccount bankAccName:(NSString *)bankAccName cityName:(NSString *)cityName comfirmBlock:(dispatch_block_t)block;

//定义一个在互生币转货币界面的OK点击
+ (GYAlertShowDataWithOKButtonView *)alertHSBToCoin:(NSString *)message topColor:(TopColor)topColor canUseNum:(NSString *)strOne inputNum:(NSString *)strTwo feeNum:(NSString *)strThree addNum:(NSString *)strFour comfirmBlock:(dispatch_block_t)block;


//定义一个提示界面 在发生情况的时候有提示框
+ (GYAlertShowDataWithOKButtonView *)oneTipAlertWithComfirmTitle:(NSString *)comfirmTitle isBlueTopColor:(BOOL)isBlue comfirmBlock:(dispatch_block_t)block;

@end
