//
//  GYHSCompanyGeneralDetailCheckVC.h
//
//  Created by 吴文超 on 16/8/2.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

// 通用的明细查询视图
#import "GYBaseViewController.h"
/**
 *    @业务标题 : 企业账户 通用的明细查询表格视图控制器
 *
 *    @Created : 吴文超
 *    @Modify  : 1.初步搭建好表格视图的ui界面 根据选择子菜单数量API来区分显示
 *               2.
 *               3.
 */
typedef NS_ENUM (NSUInteger, kListViewCheck)
{
    kListViewCheckFiveItems = 1,
    kListViewCheckFourItems = 2
};

typedef NS_ENUM (NSUInteger, kDetailCheckType)
{
    kPointDetailCheckType      = 1, //积分账户的明细查询
    kCashDetailCheckType       = 2, //货币账户明细查询
    kHsbDetailCheckType        = 3, //互生币账户明细查询?
    kInvestmentDetailCheckType = 4 //投资账户下明细查询
};



@interface GYHSCompanyGeneralDetailCheckVC : GYBaseViewController
@property (nonatomic, assign) kListViewCheck checkType;
@property (nonatomic, assign) kDetailCheckType detailType;
@end
