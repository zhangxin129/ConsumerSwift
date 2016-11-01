//
//  UIView+CustomBorder.h
//  HSConsumer
//
//  Created by apple on 14-11-28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (CustomBorder)

/**
 *	移动一个视图的起点位置，即 x , y
 *
 *	@param  x       原来x的基础上+ x
 *	@param  y       原来y的基础上+ y
 */
- (void)moveX:(CGFloat)x moveY:(CGFloat)y;

/**
 *	自定义添加默认的上边框  显示在view的fram内
 */
- (void)addTopBorder;

/**
 *	添加指定宽度和颜色的上边框 显示在view的fram内
 *
 *	@param  borderWidth     边框宽度
 *	@param  color   边框颜色
 */
- (void)addTopBorderWithBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor*)color;

/**
 *	自定义添加默认的下边框 显示在view的fram外
 */
- (void)addBottomBorder;

/**
 *	添加指定宽度和颜色的下边框 显示在view的fram外
 *
 *	@param  borderWidth     边框宽度
 *	@param  color   边框颜色
 */
- (void)addBottomBorderWithBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor*)color;

/**
 *	自定义添加默认的左边框  显示在view的fram内
 */
- (void)addLeftBorder;

/**
 *	添加指定宽度和颜色的左边框  显示在view的fram内
 *
 *	@param  borderWidth     边框宽度
 *	@param  color   边框颜色
 */
- (void)addLeftBorderWithBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor*)color;

/**
 *	自定义添加默认的右边框 显示在view的fram外
 */
- (void)addRightBorder;

/**
 *	添加指定宽度和颜色的右边框 显示在view的fram外
 *
 *	@param  borderWidth     边框宽度
 *	@param  color   边框颜色
 */
- (void)addRightBorderWithBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor*)color;

/**
 *	自定义添加默认的 上、下、左、右 边框  （上/左显示在view的fram内；下/右显示在view的fram外）
 */
- (void)addAllBorder;

/**
 *	自定义添加默认的 上、下（上显示在view的fram内；下显示在view的fram外）
 */
- (void)addTopBorderAndBottomBorder;

/**
 *	添加指定宽度和颜色的 上、下、左、右 边框  （上/左显示在view的fram内；下/右显示在view的fram外）
 *
 *	@param  borderWidth     边框宽度
 *	@param  color   边框颜色
 */
- (void)addAllBorderWithBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)color;

/**
 *	移除自定义的上边框
 */
- (void)removeTopBorder;

/**
 *	移除自定义的下边框
 */
- (void)removeBottomBorder;

/**
 *	移除自定义的左边框
 */
- (void)removeLeftBorder;

/**
 *	移除自定义的右边框
 */
- (void)removeRightBorder;

/**
 *	移除自定义的 上、下、左、右 边框
 */
- (void)removeAllBorder;

/**
 *	设置下边框是否显示在view的fram内
 *
 *	@param  isInset         YES/NO
 */
- (void)setBottomBorderInset:(BOOL)isInset;

/**
 *	设置右边框是否显示在view的fram内
 *
 *	@param  isInset         YES/NO
 */
- (void)setRightBorderInset:(BOOL)isInset;

@end
