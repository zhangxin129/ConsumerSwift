//
//  CellViewDetailCell.h
//  HSConsumer
//
//  Created by apple on 14-11-19.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//明细查询

#define kCellViewDetailCellIdentifier @"CellViewDetailCellIdentifier"

#import <UIKit/UIKit.h>

@interface CellViewDetailCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray* arrDataSource;
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) UILabel* labelShowDetails;
@property (assign, nonatomic) CGFloat cellSubCellRowHeight;
@property (strong, nonatomic) NSArray* rowValueHighlightedProperty;
@property (strong, nonatomic) NSArray* rowTitleHighlightedProperty;
@property (assign,nonatomic) CGFloat labelheight;
@property (nonatomic,copy)NSString *type;

@end
