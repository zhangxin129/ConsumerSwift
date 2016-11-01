//
//  GYInvestAccoutViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved
//投资账户主页面
#import "GYInvestAccoutViewController.h"
#import "GYBaseQueryListViewController.h"
#import "GYAlertView.h"
#import "GYHSLabelTwoTableViewCell.h"
#import "GYHSImageSixlabelCell.h"
#import "GYHSImageTowLabelCell.h"
#import "GYHSCellTypeImagelabel.h"
#import "GYHSLoginManager.h"

@interface GYInvestAccoutViewController () <UITableViewDataSource, UITableViewDelegate, GYNetRequestDelegate> {
    GlobalData* data; //全局单例
}

@property (nonatomic, strong) UITableView* investAccoutTableView;
@property (nonatomic, copy) NSMutableDictionary* dic;
@property (nonatomic, copy) NSArray* sectionTowArray;
@property (nonatomic, copy) NSArray* sectionthreeArray;
@end

@implementation GYInvestAccoutViewController
#pragma mark - 网络数据交换
- (void)get_invest_act_info
{ //同步账户信息

    NSMutableDictionary* allParas = [NSMutableDictionary dictionary];

    [allParas setValue:kSaftToNSString(data.loginModel.resNo) forKey:@"hsResNo"];
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kInvestBalanceDetailUrlString parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [GYGIFHUD show];
    [request start];
}
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    [GYGIFHUD dismiss];
    NSDictionary* dic = responseObject;
    self.dic = responseObject[@"data"];

    dic = dic[@"data"];
    data.user.investAccTotal = 0.0;
    if (![dic isKindOfClass:[NSNull class]] && dic && dic.count) {

        if (![dic[@"accumulativeInvestCount"] isKindOfClass:[NSNull class]] && dic[@"accumulativeInvestCount"] && ![dic[@"accumulativeInvestCount"] isEqualToString:@""]) {

            data.user.investAccTotal = [dic[@"accumulativeInvestCount"] doubleValue];
        }
    }
    data.user.investmentDividendsTotal = [dic[@"totalDividend"] doubleValue];
    data.user.investAccToHSDToCashAccTotal = [dic[@"normalDividend"] doubleValue];
    data.user.investAccToHSDToConAccTotal = [dic[@"directionalDividend"] doubleValue];
    [self.investAccoutTableView reloadData];
}
- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);

    WS(weakSelf)
        [GYUtils parseNetWork:error resultBlock:^(NSInteger retCode) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    data = globalData;
    [self get_invest_act_info];
    [self.investAccoutTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSLabelTwoTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSLabelTwoTableViewCell"];
    [self.investAccoutTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSImageSixlabelCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSImageSixlabelCell"];
    [self.investAccoutTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSImageTowLabelCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSImageTowLabelCell"];
    [self.investAccoutTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSCellTypeImagelabel class]) bundle:nil] forCellReuseIdentifier:@"GYHSCellTypeImagelabel"];
    self.investAccoutTableView.backgroundColor = kDefaultVCBackgroundColor;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else {
        return 2;
    }
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        GYHSLabelTwoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLabelTwoTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString* str = [NSString stringWithFormat:@"%@%@", kSaftToNSString(self.dic[@"dividendYear"]), kLocalized(@"GYHS_MyAccounts_last_invest_share")];
        cell.titleLabelWith.constant = 170;
        cell.titleLabel.text = str;
        cell.detLabel.text = [NSString stringWithFormat:@"%.2f%%", [self.dic[@"yearDividendRate"] floatValue] * 100];
        cell.detLabel.textColor = kValueRedCorlor;
        cell.detLabel.textAlignment = NSTextAlignmentRight;
        return cell;
    }
    else if (indexPath.section == 1) {
        NSDictionary* dic = self.sectionTowArray[indexPath.row];
        if (indexPath.row == 0) {
            GYHSImageTowLabelCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSImageTowLabelCell" forIndexPath:indexPath];
            cell.image.image = [UIImage imageNamed:dic[@"image"]];
            cell.titleLabel.text = dic[@"title"];
            cell.numberLabel.text = [GYUtils formatCurrencyStyle:[kSaftToNSString(self.dic[@"accumulativeInvestCount"]) doubleValue]];
            
            return cell;
        }
        else {
            GYHSImageSixlabelCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSImageSixlabelCell" forIndexPath:indexPath];
            cell.img.image = [UIImage imageNamed:dic[@"image"]];
            cell.toptitleLabel.text = dic[@"title"];
            cell.toptitleLabel.text = [NSString stringWithFormat:@"%@%@",self.dic[@"dividendYear"],dic[@"title"]];
            cell.bonusNumberLabel.text = [GYUtils formatCurrencyStyle:[kSaftToNSString(self.dic[@"totalDividend"]) doubleValue]];
            cell.circulationLabel.text = dic[@"title1"];
            cell.circulationNumberLabel.text = [GYUtils formatCurrencyStyle:[self.dic[@"normalDividend"] doubleValue]];
            cell.directionalLabel.text = dic[@"title2"];
            cell.directionalNumberLabel.text = [GYUtils formatCurrencyStyle:[kSaftToNSString(self.dic[@"directionalDividend"]) doubleValue]];

            return cell;
        }
    }
    else {
        GYHSCellTypeImagelabel* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSCellTypeImagelabel" forIndexPath:indexPath];
        NSDictionary* dic = self.sectionthreeArray[indexPath.row];
        cell.ivCellImage.image = [UIImage imageNamed:dic[@"image"]];
        if (indexPath.row == 0) {
            cell.bottomlb.hidden = YES;
        }
        cell.lbCellLabel.text = dic[@"title"];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 2) {
        UIViewController* vc = nil;
        GYBaseQueryListViewController* vcDetail = kLoadVcFromClassStringName(NSStringFromClass([GYBaseQueryListViewController class]));
        //积分投资分红明细查询 无显示查询条件修改
        vcDetail.isShowBtnDetail = YES;
        vcDetail.arrLeftParas = @[ @"0" ];
        vc = vcDetail;
        //积分投资
        if (indexPath.row == 0) {
            vcDetail.detailsCode = kDetailsCode_InvestPoint;
            vcDetail.arrRightParas = @[
                [GYBaseQueryListViewController getDateRangeFromTodayWithDays:29] //最近1月 要减1天
            ];
            vcDetail.navigationItem.title = kLocalized(@"GYHS_MyAccounts_point_invest_details_query");
        }
        else if (indexPath.row == 1) {
            vcDetail.detailsCode = kDetailsCode_InvestDividends;
            vcDetail.arrRightParas = @[
                [GYBaseQueryListViewController getDateRangeFromTodayWithDays:365 * 1 - 1], //最近1年 要减1天
                [GYBaseQueryListViewController getDateRangeFromTodayWithDays:365 * 3 - 1], //最近3年 要减1天
                [GYBaseQueryListViewController getDateRangeFromTodayWithDays:365 * 5 - 1] //最近5年 要减1天
            ];
            vcDetail.navigationItem.title = kLocalized(@"GYHS_MyAccounts_investment_dividends_details_query");
        }
        if (!vc)
            return;

        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 1) {
        return 100;
    }
    else {
        return 75.0f;
        //        return 55;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    view.backgroundColor = kDefaultVCBackgroundColor;
    return view;
}

#pragma mark 懒加载
- (NSArray*)sectionTowArray
{
    if (!_sectionTowArray) {
        _sectionTowArray = @[ @{ @"image" : @"hs_img_investment_account_big",
            @"title" : kLocalized(@"GYHS_MyAccounts_point_invest_total_amount") },
             @{ @"image"  : @"hs_img_HSC_to_cash_big",
                @"title"  :  kLocalized(@"GYHS_MyAccounts_investment_dividends_total"),
                @"title1" : kLocalized(@"GYHS_MyAccounts_investment_available_to_HSCoin"),
                @"title2" : kLocalized(@"GYHS_MyAccounts_investment_HSCoin") } ];
    }
    return _sectionTowArray;
}

- (NSArray*)sectionthreeArray
{
    if (!_sectionthreeArray) {
        _sectionthreeArray = @[ @{ @"image" : @"hs_cell_img_progress_check",
            @"title" : kLocalized(@"GYHS_MyAccounts_point_invest_details_query") },
            @{ @"image" : @"hs_cell_img_progress_check",
                @"title" : kLocalized(@"GYHS_MyAccounts_investment_dividends_details_query") } ];
    }
    return _sectionthreeArray;
}
- (UITableView*)investAccoutTableView
{
    if (!_investAccoutTableView) {
        _investAccoutTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        _investAccoutTableView.delegate = self;
        _investAccoutTableView.dataSource = self;
        [self.view addSubview:_investAccoutTableView];
    }
    return _investAccoutTableView;
}
@end
