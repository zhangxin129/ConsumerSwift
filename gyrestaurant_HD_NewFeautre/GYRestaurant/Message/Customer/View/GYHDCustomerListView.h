//
//  GYHDCustomerListView.h
//  HSEnterprise
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "GYHDChatViewController.h"
//#import "GYHDCustomerViewController.h"
@class GYHDCustomerViewController;
@class GYHDChatViewController;

@interface GYHDCustomerListView : UIView
/**
 *数据源
 */
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong) GYHDCustomerViewController *delegate;
@property (nonatomic, strong) GYHDChatViewController *dele;
@property (nonatomic, weak) UITableView *tableView;

@end
