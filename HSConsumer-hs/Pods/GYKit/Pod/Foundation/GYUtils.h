//
//  Utils.h
//  HSConsumer
//
//  Created by apple on 14-10-9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//公共方法，常用工具类

#import <Foundation/Foundation.h>
#import "UIView+Toast.h"

@interface GYUtils : NSObject
/**
 *	判断是否为互生卡
 *
 *	@param  cardNo  要判断的互生号
 *
 *	@return	YES 是互生号 NO不是互生号
 */
+ (BOOL)isHSCardNo:(NSString*)cardNo;
/**
 *	格式化显示积分卡号：xx xxx xx xxxx
 *
 *	@param 	cardNo 	积分卡号
 *
 *	@return	格式化后的积分卡号
 */
+ (NSString*)formatCardNo:(NSString*)cardNo;

/**
 *	获取指定长度的随机字符串(0~9)
 *
 *	@param  length  指定获取长度
 *
 *	@return	随机字符串
 */
+ (NSString*)getRandomString:(int)length;
/**
 *	按国际货币显示数值，如：1,212,121.00
 *
 *	@param  val     要格式化的数值
 *
 *	@return	格式化后的显示字符
 */
+ (NSString*)formatCurrencyStyle:(double)val;
/**
 *  生成条形码
 *
 *  @param barCodeStr 条形码字符串
 *  @param size       大小
 *
 *  @return 图片
 */
+ (UIImage*)creatBarCodeWithString:(NSString*)barCodeStr size:(CGSize)size;
/**
 *  生成二维码
 *
 *  @param qrString 二维码字符串
 *  @param size     大小
 *
 *  @return 图片
 */
+ (UIImage*)createQRImageWithString:(NSString*)qrString size:(CGSize)size;
/**
 *  生成带logo的二维码
 *  二维码和logo都是正方形的
 *  @param urlString     二维码中的链接
 *  @param imageViewSize  二维码的CGRect
 *  @param logoImage     二维码中的logo
 *  @param logoImageSize logo的大小
 *  @param cornerRadius  logo的圆角值大小
 *
 *  @return 生成的二维码
 */
+ (UIImage*)creatQRCodeWithURLString:(NSString*)urlString imageViewSize:(CGSize)imageViewSize logoImage:(UIImage*)logoImage logoImageSize:(CGSize)logoImageSize logoImageWithCornerRadius:(CGFloat)cornerRadius;
/**
 *	NSDate 转换为字符串格式：yyyy-MM-dd HH:mm:ss
 *
 *	@param 	date 	要转换的NSDate
 *
 *	@return yyyy-MM-dd HH:mm:ss 格式的字符串时间
 */
+ (NSString*)dateToString:(NSDate*)date;

/**
 *	NSDate 转换为字符串格式
 *
 *	@param 	date 	要转换的NSDate
 *	@param 	dateFormat 	格式的字符串，如：yyyy-MM-dd HH:mm:ss 、yyyy-MM-dd
 *
 *	@return	格式化后的时间字符串
 */
+ (NSString*)dateToString:(NSDate*)date dateFormat:(NSString*)dateFormat;
/**
 *  拨打电话号码
 *
 *  @param phoneNumber 号码
 *  @param view        要将提示显示在哪个视图
 */
+ (void)callPhoneWithPhoneNumber:(NSString*)phoneNumber showInView:(UIView*)view;
/**
 *  吐司
 *
 *  @param text 提示信息
 */
+ (void)showToast:(NSString*)text;
+ (void)showToastOnKeyboard:(NSString*)text;

+ (void)showToast:(NSString*)text duration:(NSTimeInterval)duration position:(id)position;

+ (void)showToast:(UIView*)toast duration:(NSTimeInterval)duration position:(id)position completion:(void (^)(BOOL didTap))completion;

/**
 *	id类型安全转换成Integer
 *
 *	@param  idVaule         要转换的id值
 *
 *	@return	转换后的Integer
 */
+ (NSInteger)saftToNSInteger:(id)idVaule;

/**
 *	id类型安全转换成字符串
 *
 *	@param  idVaule         要转换的id值
 *
 *	@return	转换后的字符串
 */
+ (NSString*)saftToNSString:(id)idVaule;

/**
 *  精度较高的乘法计算
 *
 *  @param multiplierValue   一个值
 *  @param multiplicandValue 另一个值
 *
 *  @return 一个保留小数点后两位的字符串
 */
+ (NSString*)decimalNumberMutiplyWithString:(NSString*)multiplierValue othersString:(NSString*)multiplicandValue;

@end
