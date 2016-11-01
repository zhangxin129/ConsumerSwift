//
//  UITextField+GYHSPointTextField.h
//  HSCompanyPad
//
//  Created by apple on 16/7/28.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (GYHSPointTextField)

/**
 *  输入框有误显示
 *
 *  @param content  提示内容
 *  @param animated 是否设置动画
 */
- (void)tipWithContent:(NSString *)content animated:(BOOL)animated;

/**
 *  输入金额格式化（如1,000）
 *
 *  @return 格式化后金额
 */
- (NSString *)inputEditField;
/**
 *  输入整数金额格式化（如1,000）
 *
 *  @return 格式化后整数金额
 */
- (NSString *)inputIntegerField;
/**
 *  不可编辑的输入框格式化（入1,000.00）
 *
 *  @param string 要格式化的金额
 *
 *  @return 格式化后的金额
 */
+ (NSString *)keepTwoDeciaml:(NSString *)string;
/**
 *  去除格式化的金额（如1,000转1000）
 *
 *  @return 去除格式化后的金额
 */
- (NSString *)deleteFormString;
/**
 *  输入互生卡的格式化（如06 032 12 0000）
 *
 *  @return 格式化后的互生卡
 */
- (NSString *)inputCardField;
/**
 *  移除空格
 *
 *  @return 没空格字符串
 */
- (NSString *)deleteSpaceField;
/**
 *  交易密码限制8位数
 *
 *  @return 不超过8位数的交易密码
 */
- (NSString *)subPassField;
/**
 *  登录密码6位数
 *
 *  @return 不超过6位数的登录密码
 */
- (NSString *)subLoginField;
/*!
 *    截取UITextField的text的长度
 *
 *    @param length 长度
 *
 *    @return 长度为length的text
 */
- (NSString *)subTextToLength:(NSInteger)length;

- (NSString*)moneyField;

@end
