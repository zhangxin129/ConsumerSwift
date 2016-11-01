//
//  GYHESCChooseAreaViewController.m
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/3/24.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#define kChooseAreaCell @"chooseAreaCell"

#import "GYHESCChooseAreaViewController.h"
#import "GYHESCChooseAreaTableViewCell.h"
#import "GYHESCChooseAreaModel.h"
#import "JSONModel+ResponseObject.h"

@interface GYHESCChooseAreaViewController () <UITableViewDataSource, UITableViewDelegate, GYNetRequestDelegate>

@property (nonatomic, strong) UITableView* tabView;
@property (nonatomic, strong) NSMutableArray* dataSourceArray;
@end

@implementation GYHESCChooseAreaViewController
#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kLocalized(@"HE_SC_CartChooseAreaTitle");
    [self.view addSubview:self.tabView];
    [self.tabView registerNib:[UINib nibWithNibName:@"GYHESCChooseAreaTableViewCell" bundle:nil] forCellReuseIdentifier:kChooseAreaCell];
    [self networkRequestData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHESCChooseAreaTableViewCell* chooseCell = [tableView dequeueReusableCellWithIdentifier:kChooseAreaCell forIndexPath:indexPath];
    GYHESCChooseAreaModel* model = nil;
    if (self.dataSourceArray.count > indexPath.row) {
        model = self.dataSourceArray[indexPath.row];
    }
    [chooseCell refreshDataWithModel:model];
    return chooseCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    GYHESCChooseAreaModel *areaModel = nil;
    if (self.dataSourceArray.count > indexPath.row) {
        areaModel = self.dataSourceArray[indexPath.row];
    }
    self.chooseBlock(areaModel);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}

- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    DDLogDebug(@"------success----");
    NSArray* array = [GYHESCChooseAreaModel modelArrayWithResponseObject:responseObject error:nil];
    self.dataSourceArray = [NSMutableArray arrayWithArray:array];
    DDLogDebug(@"%@", self.dataSourceArray);
    [self.tabView reloadData];
}

- (void)networkRequestData
{

    NSDictionary* parameterDic = @{ @"vShopId" : self.vShopId,
        @"itemId" : self.itemId };
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self baseURL:nil URLString:EasyBuyGetShopsByItemIdUrl parameters:parameterDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

#pragma mark - 懒加载
- (UITableView*)tabView
{
    if (!_tabView) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        [self.tabView setTableFooterView:[[UIView alloc] init]];
        _tabView.dataSource = self;
        _tabView.delegate = self;
        _tabView.rowHeight = 80.0f;
        //        _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
