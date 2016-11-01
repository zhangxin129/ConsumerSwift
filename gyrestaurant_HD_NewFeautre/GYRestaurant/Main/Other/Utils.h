//
//  Utils.h
//  GYCompany
//
//  Created by cook on 15/9/19.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYEnum.h"
#import "UIAlertView+Blocks.h"



//#define kBlueFontColor [UIColor blueColor]



@interface Utils : NSObject
/**
 *	国际化接口，内容国际化统一接口。【鉴于后续可能做对app内部国际化，故留此接口】
 *
 *	@param 	key 	内容在表中对应的键值
 *
 *	@return	国际化内容
 */
+ (NSString *)localizedStringWithKey:(NSString *)key;


/**
 *	获取指定长度的随机字符串(0~9,A~z)
 *
 *	@param 	length 	指定获取长度
 *
 *	@return	随机字符串
 */
+ (NSString *)getRandomString:(int)length;

/**
 *	格式化显示积分卡号：xx xxx xx xxxx
 *
 *	@param 	cardNo 	积分卡号
 *
 *	@return	格式化后的积分卡号
 */
+ (NSString *)formatCardNo:(NSString *)cardNo;
/**
 *	按国际货币显示数值，如：1,212,121.00
 *
 *	@param 	val 	要格式化的数值
 *
 *	@return	格式化后的显示字符
 */
+ (NSString *)formatCurrencyStyle:(double)val;

/**
 *功能：判断字符串是否为null
 *@param
 *NSString     string    要判断的字符串
 *返回：字符串
 */
+ (BOOL)isBlankString:(NSString *)string;

/**
 *	id类型安全转换成字符串
 *
 *	@param 	idVaule 	要转换的id值
 *
 *	@return	转换后的字符串
 */
+ (NSString *)saftToNSString:(id)idVaule;
/**
 *	将string转换成字典
 *
 *	@param 	string  入参：字符串
 *
 *	@return	字典
 */
+ (NSDictionary *)stringToDictionary:(NSString *)string;

/**
 *	将字典转换成string
 *
 *	@param 	dic   入参：字典
 *
 *	@return	字符串
 */
+ (NSString *)dictionaryToString:(NSDictionary *)dic;

/**
 *	创建本地通知
 *
 *	@param 	timeInterval 	延迟响应时间
 *	@param 	zone 	时区
 *	@param 	userDic 	传递的info信息，字典对象
 *	@param 	body 	显示推送的内容
 */
+(void)creatLocalNotification:(NSTimeInterval)timeInterval timeZone:(NSTimeZone*)zone userInfor:(NSDictionary*)userDic alertBody:(NSString*)body;

/**
 *	id类型安全转换成Integer
 *
 *	@param 	idVaule 	要转换的id值
 *
 *	@return	转换后的Integer
 */
+ (NSInteger)saftToNSInteger:(id)idVaule;
/**
 *	创建一个自定义的返回按钮
 *
 *	@param 	title 	返回按钮跟的名字
 *  @param  target  响应对象
 *  @param  popBack 点击事件
 */
+ (UIBarButtonItem *)createBackButtonWithTitle:(NSString *)title withTarget:(id)target withAction:(SEL)popBack;

/**
 *  判断是否是互生卡号
 *
 *  @param HSCard 互生卡号
 *  @param type  数字类型
 */
+(BOOL)checkHSCardIsNotServicesCompany:(NSString *)HSCard;
/**
 * 判断字符串是否是纯数字
 *
 *  @param strNumber 要判断的字符串
 */
+ (BOOL)checkIsNumber:(NSString*)strNumber;
/**
 * 通过指定宽度裁剪图片
 * @param 要裁剪的图片
 * @param 定义的宽度
 *
 */
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

/**
 *  拨打号码
 *
 */
+ (void)callPhoneWithPhoneNumber:(NSString *)phoneNumber showInView:(UIView *)view;

/** add by zhangx 根据字体和宽度返回高度
 *
 *  @return 高度
 */
+ (CGFloat)heightForString:(NSString *)str font:(UIFont *)font width:(CGFloat)width;

+ (void) showToastMessage: (NSString *)message;

/**
 *  将string转换成字典,过滤html标签
 *
 *  @param NSString
 *
 *  @return 字典
 */
+ (NSDictionary *)stringToDictionaryEscapseHtml:(NSString *)string;

+ (BOOL)checkArrayInvalid:(id)param;
+ (BOOL)checkObjectInvalid:(id)param;
/**
 * 校验时间点 设置免打扰
 */
+(BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour;
@end
