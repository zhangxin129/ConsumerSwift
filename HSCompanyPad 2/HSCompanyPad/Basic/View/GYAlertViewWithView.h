//
//  GYAlertViewWithView.h
//  HSCompanyPad
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GYdispatch_block_t)(void);

@interface GYAlertViewWithView : UIView

/*!
 *    返回一个包含自定义的view的弹出框，最小弹出大小为height = 180.0f， weight = 325.0f，需要设置更大可以设置contentSize的大小
 *
 *    @param contentView 自定义的view
 *    @param contentSize 自定义的view大小,使用最小弹出框设为CGSizeZero
 *    @param title       按钮的title
 *    @param topColor    顶部颜色
 *    @param block       确定按钮点击事件
 *
 *    @return GYAlertViewWithView的弹出框对象
 */
+ (GYAlertViewWithView*)alertWithView:(UIView*)contentView size:(CGSize)contentSize buttonTitle:(NSString*)title topColor:(TopColor)topColor comfirmBlock:(GYdispatch_block_t)block;

@end
