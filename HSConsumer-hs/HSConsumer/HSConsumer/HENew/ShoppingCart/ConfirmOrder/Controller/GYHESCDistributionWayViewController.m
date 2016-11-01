//
//  GYHESCDistributionWayViewController.m
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/3/31.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kDistributionWayCell @"distributionWayCell"

#import "GYHESCDistributionWayViewController.h"
#import "GYHESCCartListModel.h"
#import "GYHESCDistributionWayTableViewCell.h"

@interface GYHESCDistributionWayViewController () <UITableViewDataSource, UITableViewDelegate, GYNetRequestDelegate>

@property (nonatomic, strong) UITableView* tabView;
@property (nonatomic, strong) NSMutableArray* dataSourceArray;
@property (nonatomic, strong) GYHESCDistributionWayModel* wayModel;
@end

@implementation GYHESCDistributionWayViewController
#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kLocalized(@"HE_SC_OrderDistributionWayTitle");
    [self.view addSubview:self.tabView];
    [self.tabView registerNib:[UINib nibWithNibName:@"GYHESCDistributionWayTableViewCell" bundle:nil] forCellReuseIdentifier:kDistributionWayCell];
    [self networkRequestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.wayModel.types.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHESCDistributionWayTableViewCell* wayCell = [tableView dequeueReusableCellWithIdentifier:kDistributionWayCell forIndexPath:indexPath];
    if (self.wayModel.types.count > indexPath.row) {
        [wayCell refreshDataWithModel:self.wayModel.types[indexPath.row] fee:kSaftToNSString(self.wayModel.fee)];
    }
    if([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
       [wayCell setLayoutMargins:UIEdgeInsetsZero];
    }
    [wayCell setSeparatorInset:UIEdgeInsetsZero]; //使分割线左边距为0
    return wayCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GYHESCDistributionTypeModel* typeModel = nil;
    if (self.wayModel.types.count > indexPath.row) {
        typeModel = self.wayModel.types[indexPath.row];
    }
    self.distributionBlock(typeModel);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - custom methods
//网络请求
- (void)networkRequestData
{
    NSMutableArray* mArray = [[NSMutableArray alloc] init];
    for (GYHESCCartListModel* listModel in self.orderModel.modelArray) {
        [mArray addObject:listModel.id];
    }
    NSString* itemIdList = [mArray componentsJoinedByString:@","]; //将数组元素按逗号合并成字符串

    NSDictionary* parameterDic = @{ @"amount" : self.orderModel.totalMoney,
        @"shopId" : self.orderModel.shopId,
        @"itemIdList" : itemIdList,
        @"token" : globalData.loginModel.token };
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self baseURL:nil URLString:EasyBuyGetExpressTypeUrl parameters:parameterDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}

- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    DDLogDebug(@"------success----");
    NSDictionary* dict = responseObject[@"data"];
    self.wayModel = [[GYHESCDistributionWayModel alloc] initWithDictionary:dict error:nil];
    [self.tabView reloadData];
}

#pragma mark - 懒加载
- (UITableView*)tabView
{
    if (!_tabView) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        [self.tabView setTableFooterView:[[UIView alloc] init]];
        _tabView.dataSource = self;
        _tabView.delegate = self;
        _tabView.rowHeight = 55;
        _tabView.backgroundColor = kCorlorFromRGBA(238, 238, 238, 1.0);

        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
        headerView.backgroundColor = [UIColor clearColor];
        _tabView.tableHeaderView = headerView;
    }
    return _tabView;
}

- (NSMutableArray*)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] init];
    }
    return _dataSourceArray;
}

/*
   #pragma mark - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   }
 */

@end
