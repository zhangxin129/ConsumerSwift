//
//  GYBaseQueryListViewController.h
//  HSConsumer
//
//  Created by apple on 14-10-29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//明细查询类

#import <UIKit/UIKit.h>
#import "GYDetailsNextViewController.h"

@interface GYBaseQueryListViewController : GYViewController

@property (nonatomic, assign) BOOL isShowBtnDetail; //是否显示查看明细提示行 默认为YES;
@property (nonatomic, assign) EMDetailsCode detailsCode; //账户类型
@property (nonatomic, assign) int startPageNo; //从第几开始

@property (nonatomic, strong) NSArray* arrLeftParas; //左边的字符串参数
@property (nonatomic, strong) NSArray* arrRightParas; //右边的字符串参数

@property (nonatomic, copy) NSString* dividendYear; //年份
@property (nonatomic, copy) NSString* dividendNo; //分红号

@property (nonatomic, copy) NSString* titleStr;

@property (nonatomic, copy) NSString* noLeftDownBtnText;

/**
 *	按输入的天数拼合查询日期区间：daysAgo<0,返回 全部 0000-00-00~今天日期; daysAgo=0,返回 当天~当天，其它返回如:2015-01-04~2015-02-04
 *
 *	@param  daysAgo  至今多少天之前
 *
 *	@return	拼合后的字符串，daysAgo<0,返回 全部 0000-00-00~今天日期; daysAgo=0,返回 当天~当天，其它返回如:2015-01-04~2015-02-04
 */
+ (NSString *)getDateRangeFromTodayWithDays:(NSInteger)daysAgo;

@end
