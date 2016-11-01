//
//  GYHDMsgListView.h
//  HSEnterprise
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDMsgListViewController.h"
@interface GYHDMsgListView : UIView
/**
 *数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/**
 *消息类别
 */
@property (nonatomic, copy) NSString *title;
/**
 *消息类别图片
 */
@property (nonatomic, copy) NSString *image;
/**
 *颜色
 */
@property (nonatomic, strong) UIColor *color;
@property(nonatomic,strong)GYHDMsgListViewController*showPage;
@property (nonatomic, strong) UITableView *tableView;
@end
