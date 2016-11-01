//
//  GYHDCompanyListView.h
//  HSEnterprise
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDSaleListGrounpModel.h"
@protocol GYHDCompanyListViewDelegate <NSObject>

-(void)refreshSaleListViewWithModel:(GYHDSaleListGrounpModel*)model;

-(void)refreshSaleListViewWithArry:(NSArray*)arry;

@end

@interface GYHDCompanyListView : UIView
/**
 *数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray*companyOperatorArr;
@property(nonatomic,weak)id<GYHDCompanyListViewDelegate> delegate;
@property (nonatomic, weak) UITableView *tableView;
@end
