//
//  GYPointAccoutViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//积分账户主页面

#import "GYPointAccoutViewController.h"
#import "GYBaseQueryListViewController.h"
#import "GYPointToHSDViewController.h"
#import "GYGIFHUD.h"
//提示框
#import "GYAlertView.h"
#import "GYHSAccountHeaderCell.h"
#import "GYHSCellTypeImagelabel.h"
#import "GYHSHeaderModel.h"
#import "GYHSTableViewWarmCell.h"
#import "GYHSLoginManager.h"
#import "GYNetRequest.h"

@interface GYPointAccoutViewController () <GYNetRequestDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* pointTableView;
@property (nonatomic, copy) NSArray* cellImageArray;
@property (nonatomic, copy) NSArray* cellTitleArray;
@property (nonatomic, copy) NSArray* cellWarArray;
@property (nonatomic, strong) GYHSHeaderModel* headerModel;
@property (nonatomic, copy) NSDictionary* requestDic;

@end

@implementation GYPointAccoutViewController

- (void)integralQuery
{
    NSDictionary* allFixParas = @{
        @"accCategory" : kTypePointBalanceDetail,
        @"systemType" : kSystemTypeConsumer,
        @"custId" : kSaftToNSString(globalData.loginModel.custId),
    };
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kAccountBalanceDetailUrlString parameters:allFixParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
}
- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    self.requestDic = responseObject;
    self.headerModel = [[GYHSHeaderModel alloc] init];
    if (![responseObject isKindOfClass:[NSNull class]] && responseObject && responseObject.count) {
        self.headerModel.IntegralBalance = kSaftToNSString(self.requestDic[@"data"][@"accountBalance"]);
        self.headerModel.AvailableIntegral = kSaftToNSString(self.requestDic[@"data"][@"canUsePoints"]);
        self.headerModel.TodayIntegral = kSaftToNSString(self.requestDic[@"data"][@"todayPoints"]);
    }
    else {
    }
    NSIndexPath* indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.pointTableView reloadRowsAtIndexPaths:@[ indexpath ] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.pointTableView registerNib:[UINib nibWithNibName:@"GYHSAccountHeaderCell" bundle:Nil] forCellReuseIdentifier:@"GYHSAccountHeaderCell"];
    [self.pointTableView registerNib:[UINib nibWithNibName:@"GYHSCellTypeImagelabel" bundle:Nil] forCellReuseIdentifier:@"GYHSCellTypeImagelabel"];
    [self.pointTableView registerNib:[UINib nibWithNibName:@"GYHSTableViewWarmCell" bundle:nil] forCellReuseIdentifier:@"GYHSTableViewWarmCell"];
    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    [self integralQuery];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self integralQuery];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (1 == section) {
        return self.cellTitleArray.count;
    }
    else {
        return self.cellWarArray.count;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (0 == indexPath.section) {
        GYHSAccountHeaderCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSAccountHeaderCell" forIndexPath:indexPath];
        cell.headerModel = self.headerModel;
        return cell;
    }
    else if (1 == indexPath.section) {
        GYHSCellTypeImagelabel* typeCell = [tableView dequeueReusableCellWithIdentifier:@"GYHSCellTypeImagelabel" forIndexPath:indexPath];
        if (self.cellImageArray.count > indexPath.row) {
            typeCell.ivCellImage.image = [UIImage imageNamed:self.cellImageArray[indexPath.row]];
        }
        if (self.cellTitleArray.count > indexPath.row) {
            typeCell.lbCellLabel.text = self.cellTitleArray[indexPath.row];
        }
        if (indexPath.row != 2) {
            typeCell.bottomlb.hidden = YES;
        }
        return typeCell;
    }
    else {
        GYHSTableViewWarmCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSTableViewWarmCell" forIndexPath:indexPath];

        cell.backgroundColor = kDefaultVCBackgroundColor;

        if (indexPath.row == 0) {
            cell.redImage.hidden = YES;
            cell.labelspacing.constant = -10;
        }
        [cell.label setTextColor:kCellItemTextColor];
        cell.label.lineBreakMode = NSLineBreakByWordWrapping;
        cell.label.numberOfLines = 0;
        if (self.cellWarArray.count > indexPath.row) {
            cell.label.text = self.cellWarArray[indexPath.row];
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        return 130;
    }
    else if (indexPath.section == 1) {
        return 75.0f;
    }
    else {
        if (indexPath.row == 0) {
            return 25;
        }
        else {
            return 27;
        }
    }
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 0.1;
    }
    return 15;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    view.backgroundColor = kDefaultVCBackgroundColor;
    return view;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1 && indexPath.row == 0) {
        GYPointToHSDViewController* HSBVC = [[GYPointToHSDViewController alloc] init];
        HSBVC.title = kLocalized(@"GYHS_MyAccounts_points_to_hsCoin");
        HSBVC.type = @"0";
        HSBVC.integral = kSaftToNSString(self.requestDic[@"data"][@"canUsePoints"]);
        [self.navigationController pushViewController:HSBVC animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {
        GYPointToHSDViewController* HSBVC = [[GYPointToHSDViewController alloc] init];
        HSBVC.title = kLocalized(@"GYHS_MyAccounts_points_of_investment");
        HSBVC.type = @"1";
        HSBVC.integral = kSaftToNSString(self.requestDic[@"data"][@"canUsePoints"]);
        [self.navigationController pushViewController:HSBVC animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 2) {
        GYBaseQueryListViewController* vcDetail = kLoadVcFromClassStringName(NSStringFromClass([GYBaseQueryListViewController class]));
        vcDetail.isShowBtnDetail = YES;
        vcDetail.detailsCode = kDetailsCode_Point;
        vcDetail.arrLeftParas = @[ @"0", @"2", @"1" ];
        vcDetail.arrRightParas = @[
            [GYBaseQueryListViewController getDateRangeFromTodayWithDays:0], //今天
            [GYBaseQueryListViewController getDateRangeFromTodayWithDays:6], //最近1周 要减1天
            [GYBaseQueryListViewController getDateRangeFromTodayWithDays:29] //最近1月 要减1天
        ];
        //        vcDetail.arrLeftDropMenu = @[[GYUtils localizedStringWithKey:@"GYHD_all"], @"消费积分", @"消费积分撤单", @"积分转现", @"积分投资"];
        //        vcDetail.arrRightDropMenu = @[[GYUtils localizedStringWithKey:@"GYHD_all"], @"最近一月", @"最近三月", @"最近半年", @"最近一年"];
        vcDetail.title = kLocalized(@"GYHS_MyAccounts_point_acc_details");
        [self.navigationController pushViewController:vcDetail animated:YES];
    }
}

#pragma mark 懒加载

- (NSArray*)cellImageArray
{
    if (!_cellImageArray) {
        _cellImageArray = [NSArray arrayWithObjects:@"hs_cell_img_points_to_hsd", @"hs_cell_img_points_to_invest", @"hs_points_account_details_query", nil];
    }
    return _cellImageArray;
}

- (NSArray*)cellTitleArray
{
    if (!_cellTitleArray) {
        _cellTitleArray = [NSArray arrayWithObjects:kLocalized(@"GYHS_MyAccounts_points_to_hsCoin"), kLocalized(@"GYHS_MyAccounts_points_of_investment"), kLocalized(@"GYHS_MyAccounts_point_acc_details"), nil];
    }
    return _cellTitleArray;
}
- (NSArray*)cellWarArray
{
    if (!_cellWarArray) {
        _cellWarArray = [NSArray arrayWithObjects:kLocalized(@"GYHS_MyAccounts_WellTip"), kLocalized(@"GYHS_MyAccounts_integralNumberAvailable"), kLocalized(@"GYHS_MyAccounts_integralWarnTwo"), nil];
    }
    return _cellWarArray;
}
- (UITableView*)pointTableView
{
    if (!_pointTableView) {
        _pointTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
        _pointTableView.delegate = self;
        _pointTableView.dataSource = self;
        [self.view addSubview:_pointTableView];
    }
    return _pointTableView;
}
@end
