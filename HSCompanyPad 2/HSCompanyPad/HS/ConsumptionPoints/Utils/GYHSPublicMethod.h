//
//  GYHSPublicMethod.h
//
//  Created by apple on 16/8/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHSPublicMethod : NSObject
/**
 *  转为12位数金额
 *
 *  @param amountString 转换字符串
 *
 *  @return 12位数金额
 */
+ (NSString*)transAmount:(NSString*)amountString;

/**
 *  抵扣券转为6位数
 *
 *  @param ticket 转换字符串
 *
 *  @return 6位数抵扣券
 */
+ (NSString*)transferTicket:(NSString*)ticket;

/**
 *  找到view所在的控制器
 *
 *  @param view 视图
 *
 *  @return 控制器
 */
+ (UIViewController*)viewControllerWithView:(UIView *)view;

/**
 *  判断日期时间是否大于当前时间，如果大于当前时间返回当前时间
 *
 *  @param timeString 日期字符串
 *
 *  @return 日期字符串
 */
+ (NSString *)compareWithTimeString:(NSString *)timeString;

/**
 *  比较两个时间大小，第二个时间大于第一个时间返回yes否则返回no
 *
 *  @param dateString      时间字符串
 *  @param otherDateString 时间字符串
 *
 *  @return BOOL
 */
+ (BOOL)compareWithDateString:(NSString *)dateString ohterDateString:(NSString *)otherDateString;
/**
 *  判断日期时间是否在当前日期n天范围内，如果不在范围内返回当前日期-n
 *
 *  @param timeString 日期字符串
 *
 *  @return 日期字符串
 */
+ (NSString *)compareWithLimitString:(NSString *)timeString days:(NSInteger)days;

/**
 *  渠道类型
 *
 *  @param chanelType 类型字符串
 *
 *  @return 类型
 */
+ (NSString *)transWithChannelType:(NSString *)chanelType;

/**
 *  时间转换(将20160817163448转为2016-08-17 16:34:48)
 *
 *  @param stringDate 时间字符串
 *
 *  @return 时间字符串
 */
+ (NSString*)transDate:(NSString*)stringDate;

/**
 *  金额保留两位小数，并格式化
 *
 *  @param string 金额字符串
 *
 *  @return 格式化字符串
 */
+ (NSString *)keepTwoDecimal:(NSString *)string;

/**
 *  积分比率保留四位小数
 *
 *  @param string 积分字符串
 *
 *  @return 四位数字符串
 */
+ (NSString *)keepPointDecimal:(NSString *)string;

/**
 *  无数据显示
 *
 *  @param superView 覆盖的view
 *
 *  @return 无数据view
 */
+ (UIView *)noDataTipWithSuperView:(UIView *)superView;
//注释同上 可以加盖到不同的父视图上
+ (UIView*)addNoDataTipViewWithSuperView:(UIView*)superView;
/**
 *  成员企业注销状态
 *
 *  @param status 状态字符串
 *
 *  @return 字符串
 */
+ (NSString*)explainStatus:(NSString*)status;

/**
 *  图片显示合适大小
 *
 *  @param imagename 图片名称
 *
 *  @return 转换后的图片
 */
+ (UIImage*)buttonImageStrech:(NSString*)imagename;

@end
                                                