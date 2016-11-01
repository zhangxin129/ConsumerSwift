//
//  GYHSDToCashAccoutViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//互生币转现账户主页面

#import "GYHSDToCashAccoutViewController.h"
#import "ViewCellStyle.h"

#import "GYBuyHSBViewController.h"
#import "GYBaseQueryListViewController.h"
#import "GYGIFHUD.h"
#import "GYPayLimitationSettingController.h"
#import "GYAlertView.h"
#import "GYHSAccountHSBHeaderCell.h"
#import "CellTypeImagelabel.h"
#import "GYPointToHSDViewController.h"

@interface GYHSDToCashAccoutViewController () <UITableViewDelegate, UITableViewDataSource, GYNetRequestDelegate>

@property (weak, nonatomic) IBOutlet UITableView* maytable;
@property (nonatomic, copy) NSDictionary* requestDic;
@property (nonatomic, copy) NSArray* cellTitleArray;
@property (nonatomic, copy) NSArray* cellImageArray;
@property (nonnull, copy) NSString* hsb;
@property (nonnull, copy) NSString* ltB;
@end

@implementation GYHSDToCashAccoutViewController
#pragma mark - 获取个人的账户信息
- (void)get_user_info
{
    NSDictionary* allFixParas = @{
        @"accCategory" : kTypeHSDBalanceDetail,
        @"systemType" : kSystemTypeConsumer
    };
    NSMutableDictionary* allParas = [NSMutableDictionary dictionaryWithDictionary:allFixParas];
    [allParas setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"custId"];
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kAccountBalanceDetailUrlString parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [GYGIFHUD show];
    [request start];
}
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    [GYGIFHUD dismiss];
    self.requestDic = responseObject;
    NSDictionary* dataDic = responseObject[@"data"];
    if ([responseObject[@"retCode"] integerValue] == 200) {
        if (![dataDic isKindOfClass:[NSNull class]] && dataDic && dataDic.count) {
            NSString* ltbBalance = dataDic[@"ltbBalance"];
            double HSDToCashAccBal = [ltbBalance doubleValue];
            self.hsb = dataDic[@"xfbBalance"];
            self.ltB = dataDic[@"ltbBalance"];
            globalData.user.HSDToCashAccBal = HSDToCashAccBal;
            globalData.user.HSDConAccBal = [kSaftToNSString(dataDic[@"xfbBalance"]) doubleValue];
            globalData.user.hsdToCashCurrencyConversionFee = [kSaftToNSString(dataDic[@"hsbChangeHbRatio"]) doubleValue];
        }
        else {
            self.hsb = @"0.00";
            self.ltB = @"0.00";
            globalData.user.HSDToCashAccBal = 0.0;
            globalData.user.HSDConAccBal = 0.0;
            globalData.user.hsdToCashCurrencyConversionFee = 0.0;
        }
        [self.maytable reloadData];
    }
}
- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error
{
    [GYGIFHUD dismiss];
     DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);

    WS(weakSelf)
        [GYUtils parseNetWork:error resultBlock:^(NSInteger retCode) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
}
#pragma mark - 系统方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    self.maytable.backgroundColor = kDefaultVCBackgroundColor;
    [self.maytable registerNib:[UINib nibWithNibName:@"GYHSAccountHSBHeaderCell" bundle:nil] forCellReuseIdentifier:@"GYHSAccountHSBHeaderCell"];
    [self.maytable registerNib:[UINib nibWithNibName:@"CellTypeImagelabel" bundle:nil] forCellReuseIdentifier:@"CellTypeImagelabel"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self get_user_info];
}

#pragma mark - tableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if (!globalData.loginModel.cardHolder) {
        return 4;
    }
    else
        return 3;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1 && globalData.loginModel.cardHolder) {
        return 4;
    }
    else if (section == 1 && !globalData.loginModel.cardHolder) {
        return 2;
    }
    else {
        return 1;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        GYHSAccountHSBHeaderCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSAccountHSBHeaderCell" forIndexPath:indexPath];
        if (globalData.loginModel.cardHolder) { ///持卡人
            cell.topLeftLabel.text = kLocalized(@"GYHS_MyAccounts_circulationcoin_balance");
            cell.bottomLeftLabel.text = kLocalized(@"GYHS_MyAccounts_coins_consumer_account_balance");
            cell.topRightLabel.text = [GYUtils formatCurrencyStyle:self.ltB.doubleValue];
            cell.bottomRightlabel.text = [GYUtils formatCurrencyStyle:self.hsb.doubleValue];
        }
        else {
            cell.topLeftLabel.text = kLocalized(@"GYHS_MyAccounts_account_balance");
            cell.bottomLeftLabel.text = [GYUtils formatCurrencyStyle:[self.ltB doubleValue]];
            cell.bottomLeftLabel.textColor = [UIColor redColor];
            cell.bottomLeftLabel.textAlignment = NSTextAlignmentLeft;
            cell.bottomRightlabel.hidden = YES;

            cell.topRightLabel.hidden = YES;
            cell.line.hidden = YES;
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        CellTypeImagelabel* cell = [tableView dequeueReusableCellWithIdentifier:@"CellTypeImagelabel"];
        if (self.cellImageArray.count > indexPath.row) {
            cell.ivCellImage.image = [UIImage imageNamed:self.cellImageArray[indexPath.row]];
        }
        if (self.cellTitleArray.count > indexPath.row) {
            cell.lbCellLabel.text = self.cellTitleArray[indexPath.row];
        }
        
        if ((globalData.loginModel.cardHolder && indexPath.section == 2) || (!globalData.loginModel.cardHolder && indexPath.section == 3)) { ///持卡人 和非持卡人的 支付限额
            cell.ivCellImage.image = [UIImage imageNamed:[self.cellImageArray lastObject]];
            cell.lbCellLabel.text = [self.cellTitleArray lastObject];
        }
        if (!globalData.loginModel.cardHolder && indexPath.section == 2) { ///非持卡人的互生币明细查询
            cell.ivCellImage.image = [UIImage imageNamed:self.cellImageArray[2]];
            cell.lbCellLabel.text = self.cellTitleArray[2];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    UIViewController* vc = nil;
    if (indexPath.row == 0 && indexPath.section == 1) { ///互生币转货币
        GYPointToHSDViewController* CashAccountvc = [[GYPointToHSDViewController alloc] init];
        if (self.cellTitleArray.count > indexPath.row) {
            CashAccountvc.title = kLocalized(self.cellTitleArray[indexPath.row]);
        }
        CashAccountvc.type = @"2";
        CashAccountvc.integral = kSaftToNSString(self.requestDic[@"data"][@"ltbBalance"]);
        vc = CashAccountvc;
    }
    else if (indexPath.row == 1 && indexPath.section == 1) { ///兑换互生币
        GYBuyHSBViewController* HSBvc = [[GYBuyHSBViewController alloc] init];
        if (self.cellTitleArray.count > indexPath.row) {
            HSBvc.title = kLocalized(self.cellTitleArray[indexPath.row]);
        }
        vc = HSBvc;
    }
    else if ((indexPath.row == 2 && globalData.loginModel.cardHolder) || (indexPath.row == 0 && indexPath.section == 2 && !globalData.loginModel.cardHolder)) { ///流通币明细查询 持卡人 非持卡人
        GYBaseQueryListViewController* QueryListvc = [[GYBaseQueryListViewController alloc] init];
        QueryListvc.isShowBtnDetail = YES;
        QueryListvc.detailsCode = kDetailsCode_HSDToCash;
        QueryListvc.arrLeftParas = @[ @"0", @"2", @"1" ];
        QueryListvc.arrRightParas = @[
            [GYBaseQueryListViewController getDateRangeFromTodayWithDays:0], //今天
            [GYBaseQueryListViewController getDateRangeFromTodayWithDays:6], //最近1周 要减1天
            [GYBaseQueryListViewController getDateRangeFromTodayWithDays:29], //最近1月 要减1天
            [GYBaseQueryListViewController getDateRangeFromTodayWithDays:30 * 3 - 1] //最近3月 要减1天
        ];
        QueryListvc.navigationItem.title = indexPath.row == 2 ? self.cellTitleArray[indexPath.row] : self.cellTitleArray[2];
        vc = QueryListvc;
    }
    else if (indexPath.row == 3 && globalData.loginModel.cardHolder) { ////定向比明细查询
        GYBaseQueryListViewController* QueryListvc = [[GYBaseQueryListViewController alloc] init];
        QueryListvc.isShowBtnDetail = YES;
        QueryListvc.detailsCode = kDetailsCode_HSDToCon;
        QueryListvc.arrLeftParas = @[ @"0", @"2", @"1" ];
        QueryListvc.arrRightParas = @[
            [GYBaseQueryListViewController getDateRangeFromTodayWithDays:0], //今天
            [GYBaseQueryListViewController getDateRangeFromTodayWithDays:6], //最近1周 要减1天
            [GYBaseQueryListViewController getDateRangeFromTodayWithDays:29], //最近1月 要减1天
            [GYBaseQueryListViewController getDateRangeFromTodayWithDays:30 * 3 - 1] //最近3月 要减1天
        ];
        if (self.cellTitleArray.count > indexPath.row) {
            QueryListvc.navigationItem.title = self.cellTitleArray[indexPath.row];
        }
        vc = QueryListvc;
    }
    else if ((indexPath.row == 0 && indexPath.section == 3) || (indexPath.row == 0 && indexPath.section == 2)) { ///支付限额
        GYPayLimitationSettingController* CashAccountvc = [[GYPayLimitationSettingController alloc] init];
        CashAccountvc.title = kLocalized([self.cellTitleArray lastObject]);
        vc = CashAccountvc;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        return 130;
    }
    else {
        return 75.0f;
        //        return 60;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark -  lazyLoad
- (NSArray*)cellTitleArray
{
    if (!_cellTitleArray) {
        if (!globalData.loginModel.cardHolder) { ///非持卡人
            _cellTitleArray = @[ kLocalized(@"GYHS_MyAccounts_coins_to_cash_toCash_account"), kLocalized(@"GYHS_MyAccounts_buy_hsb"), kLocalized(@"GYHS_MyAccounts_query_HSCoin_detail"), kLocalized(@"GYHS_MyAccounts_pay_limit_setup") ];
        }
        else {
            _cellTitleArray = @[ kLocalized(@"GYHS_MyAccounts_coins_to_cash_toCash_account"), kLocalized(@"GYHS_MyAccounts_buy_hsb"), kLocalized(@"GYHS_MyAccounts_cashDetailQuery"), kLocalized(@"GYHS_MyAccounts_directionalCashQuery"), kLocalized(@"GYHS_MyAccounts_pay_limit_setup") ];
        }
    }
    return _cellTitleArray;
}

- (NSArray*)cellImageArray
{
    if (!_cellImageArray) {
        if (!globalData.loginModel.cardHolder) { ///非持卡人
            _cellImageArray = @[ @"hs_coin_cash", @"hs_online_shopping_hsb", @"hs_points_account_details_query", @"gyhs_pay_limitation_setting" ];
        }
        else {
            _cellImageArray = @[ @"hs_coin_cash", @"hs_online_shopping_hsb", @"hs_points_account_details_query", @"hs_points_account_details_query", @"gyhs_pay_limitation_setting" ];
        }
    }
    return _cellImageArray;
}

@end
