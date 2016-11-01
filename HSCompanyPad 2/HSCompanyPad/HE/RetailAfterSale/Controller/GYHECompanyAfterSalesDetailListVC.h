//
//  GYHECompanyAfterSalesDetailListVC.h
//
//  Created by 吴文超 on 16/8/10.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//


//制作售后列表表格视图控制器
#import "GYBaseViewController.h"
/**
 *    @业务标题 : 售后列表 表格视图控制器
 *
 *    @Created : 吴文超
 *    @Modify  : 1.初步搭建好表格视图的ui界面 尚需完成全部下拉菜单下 全部 小方框的下拉菜单制作
 *               2.
 *               3.
 */
typedef NS_ENUM(NSUInteger, kListViewCheck) {  //存在四种状态
    kUntreatedAfterSaleOrder = 1,  //未处理售后订单
    kDidtreatedAfterSaleOrder = 2,  //已处理售后订单
    kAllAfterSaleOrder = 3,  //全部售后单
    kOfflineTransactionReturnGoods = 4  //线下交易退货
    
};

@interface GYHECompanyAfterSalesDetailListVC: GYBaseViewController
@property (nonatomic,assign) kListViewCheck checkType;
@property (nonatomic,assign) NSInteger checkTypeInt;





@end
