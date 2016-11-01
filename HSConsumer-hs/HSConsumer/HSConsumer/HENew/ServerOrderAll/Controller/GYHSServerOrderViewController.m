//
//  GYHSServerOrderViewController.m
//  HSConsumer
//
//  Created by kuser on 16/9/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSServerOrderViewController.h"
#import "GYHSOrderViewForHeaderInSection.h"
#import "GYHSServerOrderAllModel.h"
#import "GYNetRequest.h"
#import "GYHSServerOrderCell.h"
#import "GYHSServerDetailsController.h"

#define kEachPageSizeStr 2
#define kGYHSServerOrderCellCellReuseId @"GYHSServerOrderCell"

@interface GYHSServerOrderViewController () <UITableViewDataSource, UITableViewDelegate, GYNetRequestDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, assign) BOOL isUpFresh; //是否刷新
@property (nonatomic, assign) int totalPage; //总共页数
@property (nonatomic, assign) int currentPageIndexStr; //当前页数
@property (nonatomic, strong) GYHSServerOrderAllModel* model;

@end

@implementation GYHSServerOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initView];
    if (self.shoppingListType == GYHSShopRetailingTypeList) {
        self.title = @"零售订单";
        //零售订单数据
        [self requestShopData];
    }
    else {
        self.title = @"服务订单";
        //服务订单数据
        [self requestData];
    }
    [self creatHeaderRefresh];
    [self creatFootReresh];
}

#pragma mark--privateMark
- (void)creatHeaderRefresh
{
    __weak __typeof(self) wself = self;
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        __strong GYHSServerOrderViewController *sself = wself;
        [sself headerRereshing];
    }];
    //单例 调用刷新图片
    self.tableView.mj_header = header;
}

- (void)creatFootReresh
{
    __weak __typeof(self) wself = self;
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        __strong GYHSServerOrderViewController *sself = wself;
        [sself footerRereshing];
    }];
    self.tableView.mj_footer = footer;
}

//开始进入刷新状态
- (void)headerRereshing
{
    _isUpFresh = YES;
    _currentPageIndexStr = 1;
    //开始网络请求
    if (self.shoppingListType == GYHSShopRetailingTypeList) {
        //零售订单数据
        [self requestShopData];
    }
    else {
        //服务订单数据
        [self requestData];
    }
}

- (void)footerRereshing
{
    _isUpFresh = NO;
    if (_currentPageIndexStr < _totalPage) {
        _currentPageIndexStr += 1;
        //开始网络请求
        if (self.shoppingListType == GYHSShopRetailingTypeList) {
            //零售订单数据
            [self requestShopData];
        }
        else {
            //服务订单数据
            [self requestData];
        }
    }
}

- (void)requestData
{
    NSLog(@"请求网络数据");
    if (_isUpFresh) {
        [self.dataArray removeAllObjects];
    }
    NSString* path = [[NSBundle mainBundle] pathForResource:@"GYHSPurchaseOrderAllModel" ofType:@"json"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    if (data) {
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSError* error = nil;
        self.model = [[GYHSServerOrderAllModel alloc] initWithDictionary:dict error:&error];
        if (self.model.data && [self.model.data isKindOfClass:[NSArray class]]) {
            [self.dataArray addObjectsFromArray:self.model.data];
        }
    }
    [self.tableView reloadData];
    if (_currentPageIndexStr < _totalPage) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
    else {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)requestShopData
{
    NSLog(@"请求网络数据");
    if (_isUpFresh) {
        [self.dataArray removeAllObjects];
    }
    NSString* path = [[NSBundle mainBundle] pathForResource:@"GYHSShopRetailOrderAllModel" ofType:@"json"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    if (data) {
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSError* error = nil;
        self.model = [[GYHSServerOrderAllModel alloc] initWithDictionary:dict error:&error];
        if (self.model.data && [self.model.data isKindOfClass:[NSArray class]]) {
            [self.dataArray addObjectsFromArray:self.model.data];
        }
    }
    [self.tableView reloadData];
    if (_currentPageIndexStr < _totalPage) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
    else {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)initView
{
    [self.view addSubview:self.tableView];
    //初始化当前页数为1
    _currentPageIndexStr = 1;
    _totalPage = 3;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    GYHSServerOrderCellSectionModel* sectionModel = self.dataArray[section];
    return sectionModel.items.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    GYHSOrderViewForHeaderInSection* headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHSOrderViewForHeaderInSection class]) owner:self options:nil] firstObject];
    headerView.section = section;
    [headerView setValue:self forKey:@"delegate"];
    [headerView setValue:self.dataArray[section] forKey:@"model"];
    return headerView;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHSServerOrderCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHSServerOrderCellCellReuseId forIndexPath:indexPath];
    GYHSServerOrderCellSectionModel* sectionModel = self.dataArray[indexPath.section];
    GYHSServerOrderCellModel* model = sectionModel.items[indexPath.row];
    [cell setValue:model forKey:@"model"];
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    // 1、消除cell被选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GYHSServerDetailsController* vc = [[GYHSServerDetailsController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - GYHSOrderViewForHeaderInSectionDelegate
- (void)didSelectedDetailsBtn:(GYHSOrderViewForHeaderInSection*)header
{
    NSLog(@"点击了酒店标题");
}

#pragma mark--delegate
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49) style:UITableViewStyleGrouped];
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSServerOrderCell class]) bundle:nil] forCellReuseIdentifier:kGYHSServerOrderCellCellReuseId];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 100;
    }
    return _tableView;
}

- (NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
