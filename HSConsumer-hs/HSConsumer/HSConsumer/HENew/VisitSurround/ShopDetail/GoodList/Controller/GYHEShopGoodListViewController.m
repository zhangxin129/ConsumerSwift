//
//  GYHEShopGoodListViewController.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEShopGoodListViewController.h"
#import "GYHETools.h"
#import "Masonry.h"
#import "GYHEShopGoodListCell.h"
#import "GYHEGoodsDetailsViewController.h"
#import "GYHEShopDetailGoodListModel.h"
#import "GYHEShopDetailViewController.h"

#define kGYHEShopGoodListCell @"GYHEShopGoodListCell"

@interface GYHEShopGoodListViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic ,strong)UITableView *tabView;
@property (nonatomic ,strong)NSMutableArray *dataArr;
@property (nonatomic, copy)NSString * vShopId;


@end

@implementation GYHEShopGoodListViewController

#pragma mark - cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    GYHEShopDetailViewController *vc = (GYHEShopDetailViewController *)self.parentViewController;
    _vShopId = vc.vShopId;
//    [self getShopInfo];
    [self setUI];
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
    GYHEShopGoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEShopGoodListCell forIndexPath:indexPath];
    if(self.dataArr.count > indexPath.row) {
        cell.model = self.dataArr[indexPath.row];
    }
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    if([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GYHEGoodsDetailsViewController *vc = [[GYHEGoodsDetailsViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 自定义方法
- (void)getShopInfo {
    NSMutableDictionary * paramters = [[NSMutableDictionary alloc]init];
    //商品零售1  信息服务2  外卖送货3
    [paramters setValue:@"1" forKey:@"type"];
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
                NSError *err;
                GYHEShopDetailGoodListModel *mod = [[GYHEShopDetailGoodListModel alloc] initWithDictionary:dict error:&err];
                [self.dataArr addObject:mod];
                [_tabView reloadData];
            }
        }
        
    }];
    [request commonParams:[GYUtils netWorkHECommonParams]];
    [request start];
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
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEShopGoodListCell class]) bundle:nil] forCellReuseIdentifier:kGYHEShopGoodListCell];
}
#pragma mark - setter,getter
- (NSMutableArray *)dataArr {
    if(!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

@end
