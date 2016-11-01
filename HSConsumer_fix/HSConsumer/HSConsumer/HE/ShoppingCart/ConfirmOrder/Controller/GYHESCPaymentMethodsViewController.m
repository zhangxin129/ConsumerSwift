//
//  GYHESCPaymentMethodsViewController.m
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kPaymentMethodCell @"paymentMethodCell"

#import "GYHESCPaymentMethodsViewController.h"
#import "GYHESCPaymentMethodTableViewCell.h"

@interface GYHESCPaymentMethodsViewController () <UITableViewDataSource, UITableViewDelegate, GYNetRequestDelegate>

@property (nonatomic, strong) UITableView* tabView;
@property (nonatomic, strong) NSMutableArray* dataSourceArray;
@end

@implementation GYHESCPaymentMethodsViewController
#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kCorlorFromHexcode(0xF0F0F0);
    self.title = kLocalized(@"HE_SC_OrderPaymentMethodTitle");
    [self.view addSubview:self.tabView];
    [self.tabView registerNib:[UINib nibWithNibName:@"GYHESCPaymentMethodTableViewCell" bundle:nil] forCellReuseIdentifier:kPaymentMethodCell];
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
    return self.dataSourceArray.count;
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHESCPaymentMethodTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kPaymentMethodCell forIndexPath:indexPath];
    GYHESCPaymentMethodModel* model = nil;
    if (self.dataSourceArray.count > indexPath.row) {
        model = self.dataSourceArray[indexPath.row];
    }
    [cell refreshDataWithModel:model];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GYHESCPaymentMethodModel* model = nil;
    if (self.dataSourceArray.count > indexPath.row) {
        model = self.dataSourceArray[indexPath.row];
    }
    self.paymentBlock(model);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - custom methods
//网络请求
- (void)networkRequestData
{

    NSDictionary* parameterDic = @{ @"key" : globalData.loginModel.token,
        @"shopIds" : self.shopIds,
        @"isDelivery" : self.isDelivery };
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self baseURL:nil URLString:EasyBuyGetPaymentTypeUrl parameters:parameterDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = 101;
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)accountInfoRequest
{
    NSDictionary* parameterDic = @{ @"accCategory" : @"2",
        @"systemType" : @"consumer",
        @"custId" : kSaftToNSString(globalData.loginModel.custId) };
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self baseURL:nil URLString:kAccountBalanceDetailUrlString parameters:parameterDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = 102;
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)loadPaymentTypeDataFromNet
{
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kGetPaymentTypeUrlString parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = 103;
    request.noShowErrorMsg = YES;
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error
{
    if (request.tag == 102) {
        for (GYHESCPaymentMethodModel* model in self.dataSourceArray) {
            if ([model.type isEqualToString:@"AC"]) {
                model.hsbBalance = @"-";
                break;
            }
        }
        [self.tabView reloadData];
    } else if (request.tag == 103) {
        for (GYHESCPaymentMethodModel* model in self.dataSourceArray) {
            if ([model.type isEqualToString:@"QU"]) {
                [self.dataSourceArray removeObject:model];
                break;
            }
        }
        [self accountInfoRequest];
    } else {
        DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
        ;
        [GYUtils parseNetWork:error resultBlock:nil];
    }
}

- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    DDLogDebug(@"------success----");
    if (request.tag == 101) {
        NSArray* array = responseObject[@"data"][@"types"];
        for (NSDictionary* dic in array) {
            GYHESCPaymentMethodModel* model = [[GYHESCPaymentMethodModel alloc] initWithDictionary:dic error:nil];
            //            if (!([model.type isEqualToString:@"EP"] || [model.type isEqualToString:@"QU"])) { //屏蔽网银和快捷支付
            [self.dataSourceArray addObject:model];
            //            }
        }
        [self loadPaymentTypeDataFromNet];
        //        [self.tabView reloadData];
    } else if (request.tag == 102) {
        NSString* xfbBalance = kSaftToNSString(responseObject[@"data"][@"xfbBalance"]);
        NSString* ltbBalance = kSaftToNSString(responseObject[@"data"][@"ltbBalance"]);
        for (GYHESCPaymentMethodModel* model in self.dataSourceArray) {
            if ([model.type isEqualToString:@"AC"]) {
                model.hsbBalance = [NSString stringWithFormat:@"%.2f", ([xfbBalance doubleValue] + [ltbBalance doubleValue])];
                break;
            }
        }
        [self.tabView reloadData];
    } else {
        NSArray* payType = responseObject[@"data"];
        for (GYHESCPaymentMethodModel* model in self.dataSourceArray) {
            if ([model.type isEqualToString:@"EP"]) {
                if (![payType containsObject:@"EP"]) {
                    [self.dataSourceArray removeObject:model];
                    break;
                }
            }
        }
        for (GYHESCPaymentMethodModel* model in self.dataSourceArray) {
            if ([model.type isEqualToString:@"QU"]) {
                if (![payType containsObject:@"QU"]) {
                    [self.dataSourceArray removeObject:model];
                    break;
                }
            }
        }
        [self accountInfoRequest];
    }
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

@end
