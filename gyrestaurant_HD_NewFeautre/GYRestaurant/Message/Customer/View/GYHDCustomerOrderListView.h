//
//  GYHDCustomerOrderListView.h
//  HSEnterprise
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDCustomerInfoViewController.h"
@interface GYHDCustomerOrderListView : UIView
/**
 *数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic,strong)GYHDCustomerInfoViewController*delegate;
@end
