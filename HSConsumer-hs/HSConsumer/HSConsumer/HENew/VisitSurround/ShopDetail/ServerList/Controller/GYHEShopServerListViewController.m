//
//  GYHEShopServerListViewController.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEShopServerListViewController.h"
#import "GYHETools.h"
#import "Masonry.h"
#import "GYHEShopServerListCell.h"
#import "GYShopFoodDetailViewController.h"
#import "GYShopFoodDetailView.h"
#import "GYHEServiceOrderListVC.h"
#import "GYHEShopDetailServerListModel.h"
#import "GYHEShopDetailViewController.h"
#import "GYHEShopDetailGoodListModel.h"

#define kGYHEShopServerListCell @"GYHEShopServerListCell"

@interface GYHEShopServerListViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,GYHEShopServerListCellDelegate>

@property (nonatomic ,strong)UITableView *tabView;
@property (nonatomic ,strong)NSMutableArray *dataArr;
@property (nonatomic ,strong)GYShopFoodDetailView *popView;
@property (nonatomic, copy)NSString * vShopId;

@end

@implementation GYHEShopServerListViewController

#pragma mark - cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    GYHEShopDetailViewController *vc = (GYHEShopDetailViewController *)self.parentViewController;
    _vShopId = vc.vShopId;
    [self getServerInfo];
    [self setUI];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_popView dismissView];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(self.tabView.contentOffset.y < 0) {
        self.tabView.scrollEnabled = NO;
        for(UITableView *tabV in self.parentViewController.view.subviews) {
            if([tabV isKindOfClass:[UITableView class]]) {
                tabV.scrollEnabled = YES;
            }
        }
        
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYHEShopServerListCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEShopServerListCell forIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    if([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if(self.dataArr.count > indexPath.row) {
        cell.model = self.dataArr[indexPath.row];
    }
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showDetailWithIndex:0];
}

#pragma mark - 自定义方法
- (void)getServerInfo {
    NSMutableDictionary * paramters = [[NSMutableDictionary alloc]init];
    //商品零售1  信息服务2  外卖送货3
    [paramters setValue:@"2" forKey:@"type"];
    [paramters setValue:@"" forKey:@"keyword"];
    [paramters setValue:_vShopId forKey:@"vshopId"];
    [paramters setValue:@"" forKey:@"categoryId"];
    [paramters setValue:@"" forKey:@"supportServices"];
    [paramters setValue:@"" forKey:@"city"];
    [paramters setValue:@"" forKey:@"sortType"];
    [paramters setValue:@"1" forKey:@"currentPageIndex"];
    [paramters setValue:@"10" forKey:@"pageSize"];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kGetShopDetailListUrl parameters:paramters requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            [GYUtils parseNetWork:error resultBlock:nil];
            return;
        }
        if(responseObject[@"data"]) {
            for(NSDictionary *dict in responseObject[@"data"]) {
                GYHEShopDetailGoodListModel *mod = [[GYHEShopDetailGoodListModel alloc] initWithDictionary:dict error:nil];
                [self.dataArr addObject:mod];
                [_tabView reloadData];
            }
        }
        
    }];
    [request commonParams:[GYUtils netWorkHECommonParams]];
    [request start];
}

- (void)showDetailWithIndex:(NSInteger)index {
    GYShopFoodDetailViewController *vc = [[GYShopFoodDetailViewController alloc] init];
    _popView = [[GYShopFoodDetailView alloc] init];
    [_popView createViewWithVC:vc];
}

- (void)setUI {
    _tabView = [[UITableView alloc] init];
    _tabView.delegate = self;
    _tabView.dataSource = self;
    _tabView.rowHeight = 140;
    _tabView.tableFooterView = [[UIView alloc] init];
    _tabView.separatorColor = kCellLineGary;
    _tabView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    [self.view addSubview:_tabView];
    [_tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
        
    }];
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEShopServerListCell class]) bundle:nil] forCellReuseIdentifier:kGYHEShopServerListCell];
}

-(void)clickServiceOrder:(GYHEShopServerListCell *)cell{
    GYHEServiceOrderListVC* vc = [[GYHEServiceOrderListVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - setter,getter
- (NSMutableArray *)dataArr {
    if(!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}


@end
