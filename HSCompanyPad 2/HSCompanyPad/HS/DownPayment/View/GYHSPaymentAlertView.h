//
//  GYHSPaymentAlertView.h
//  HSCompanyPad
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHSPaymentAlertView : UIView
/**
 *  预付定金结算提示框
 *
 *  @param title          顶部提示内容
 *  @param message        提示主题
 *  @param leftAttribute  左边属性文字
 *  @param rightAttribute 右边属性文字
 *  @param topColor       顶部颜色
 *  @param block          确定按钮回调
 *
 *  @return 提示view
 */
+ (GYHSPaymentAlertView*)alertWithTitle:(NSString*)title Message:(NSString*)message leftAttribute:(NSMutableAttributedString*)leftAttribute rightAttribute:(NSMutableAttributedString*)rightAttribute topColor:(TopColor)topColor comfirmBlock:(dispatch_block_t)block;

@end
