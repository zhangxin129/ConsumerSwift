//
//  GYAlertView.h
//  HSCompanyPad
//
//  Created by apple on 16/7/11.
//  Copyright © 2016年 wangbb. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *    确定取消2个按钮的弹出框
 */
@interface GYAlertView : UIView

/*!
 *    GYAlertView
 *
 *    @param title    默认温馨提示 可以问其他的
 *    @param message  弹出内容
 *    @param topColor TopColor类型
 *    @param block    dispatch_block_t
 *
 *    @return GYAlertView的对象
 */
+ (void)alertWithTitle:(NSString *)title Message:(NSString*)message topColor:(TopColor)topColor comfirmBlock:(dispatch_block_t)block;

@end
