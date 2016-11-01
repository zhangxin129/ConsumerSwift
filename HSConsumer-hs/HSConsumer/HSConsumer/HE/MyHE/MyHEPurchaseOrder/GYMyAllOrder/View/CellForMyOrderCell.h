//
//  CellForMyOrderCell.h
//  HSConsumer
//
//  Created by apple on 14-11-19.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kCellForMyOrderCellIdentifier @"CellForMyOrderCellIdentifier"
#import "GYEPMyOrderViewController.h"
#import <UIKit/UIKit.h>

@interface CellForMyOrderCell : UITableViewCell
@property (strong, nonatomic) NSDictionary* dicDataSource;
//@property (strong, nonatomic) NSMutableArray *arrDataSource;
@property (strong, nonatomic) UITableView* tableView;
@property (assign, nonatomic) CGFloat cellSubCellRowHeight;
@property (nonatomic, strong) UINavigationController* nav;
@property (nonatomic, assign) BOOL isQueryRefundRecord; //YES:查询售后申请记录列表，NO：查询订单列表
@property (nonatomic, assign) BOOL isSaleAfter; //是否为售后
@property (nonatomic, weak) GYEPMyOrderViewController* delegate;
- (void)reloadData;//更新数据源，刷新数据

@end
