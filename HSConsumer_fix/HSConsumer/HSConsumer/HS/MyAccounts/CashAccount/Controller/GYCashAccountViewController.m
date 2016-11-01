//
//  GYCashAccountViewController.m
//  HSConsumer
//
//  Created by 00 on 14-10-30.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYCashAccountViewController.h"
#import "GYCashTransfersViewController.h"
#import "GYBaseQueryListViewController.h"
#import "GYHSLoginManager.h"
#import "GYAlertView.h"
#import "GYHSLoginViewController.h"
#import "GYHSCurrencyAccountCell.h"
#import "GYHSCellTypeImagelabel.h"

@interface GYCashAccountViewController () <GYNetRequestDelegate, UITableViewDataSource, UITableViewDelegate> {
    //    IBOutlet UIView* vParentView; //第一栏，账户余额，用于设置其边框
    GlobalData* data; //单例
}
@property (nonatomic, strong) UITableView* cashAccountTableView;
@property (nonatomic, copy) NSString* accCategory; ///余额
@property (nonatomic, copy) NSArray* imgNameArray;
@property (nonatomic, copy) NSArray* titleArray;

@end

@implementation GYCashAccountViewController
#pragma mark
- (void)requestData
{
    NSDictionary* dic = @{ @"accCategory" : kTypeCashBalanceDetail,
        @"systemType" : kSystemTypeConsumer,
        @"custId" : kSaftToNSString(globalData.loginModel.custId)
    };
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kAccountBalanceDetailUrlString parameters:dic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
}

- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    NSDictionary* dataDic = responseObject[@"data"];
    if (![dataDic isKindOfClass:[NSNull class]] && dataDic && dataDic.count) {
        data.user.cashAccBal = [dataDic[@"accountBalance"] doubleValue];
        self.accCategory = dataDic[@"accountBalance"];
        
    }
    else {
        self.accCategory = @"0.0";
        data.user.cashAccBal = 0.0;
    }
    [self.cashAccountTableView reloadData];
}

- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);

    WS(weakSelf)
        [GYUtils parseNetWork:error resultBlock:^(NSInteger retCode) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //设置边框
    [self.cashAccountTableView addTopBorder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self requestData];
    //实例化单例
    data = globalData;
    //控制器背景色
    [self.cashAccountTableView setBackgroundColor:kDefaultVCBackgroundColor];
    [self.cashAccountTableView registerNib:[UINib nibWithNibName:@"GYHSCellTypeImagelabel" bundle:nil] forCellReuseIdentifier:@"kCellTypeImagelabel"];
    [self.cashAccountTableView registerNib:[UINib nibWithNibName:@"GYHSCurrencyAccountCell" bundle:nil] forCellReuseIdentifier:@"kGYHSCurrencyAccountCell"];
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else {
        return self.titleArray.count;
    }
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0) {
        GYHSCurrencyAccountCell* cell = [tableView dequeueReusableCellWithIdentifier:@"kGYHSCurrencyAccountCell" forIndexPath:indexPath];
        cell.topLabel.text = kLocalized(@"GYHS_MyAccounts_account_balance");
        if ([self.accCategory floatValue] <= 0) {
            self.accCategory = @"0.00";
        }
        [cell.numberLabel setTextColor:kValueRedCorlor];
        cell.numberLabel.text = [GYUtils formatCurrencyStyle:[self.accCategory doubleValue]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else {
        GYHSCellTypeImagelabel* cell = [tableView dequeueReusableCellWithIdentifier:@"kCellTypeImagelabel" forIndexPath:indexPath];
        if (self.imgNameArray.count > indexPath.row) {
            cell.ivCellImage.image = [UIImage imageNamed:self.imgNameArray[indexPath.row]];
        }
        if (self.titleArray.count > indexPath.row) {
            cell.lbCellLabel.text = self.titleArray[indexPath.row];
        }
        if (indexPath.row == 0) {
            cell.bottomlb.hidden  =YES;
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        return 85;
    }
    else {
        return 75.0f;
      
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

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    kCheckLogined
        UIViewController* vc = nil;
    if (indexPath.row == 0 && indexPath.section == 1) {
    
        vc = kLoadVcFromClassStringName(NSStringFromClass([GYCashTransfersViewController class]));
        vc.navigationItem.title = self.titleArray[0];
    }
    else {
        GYBaseQueryListViewController* vcDetail = kLoadVcFromClassStringName(NSStringFromClass([GYBaseQueryListViewController class]));
        vcDetail.isShowBtnDetail = YES;
        vcDetail.detailsCode = kDetailsCode_Cash;
        vcDetail.arrLeftParas = @[ @"0", @"2", @"1" ];
        vcDetail.arrRightParas = @[
            [GYBaseQueryListViewController getDateRangeFromTodayWithDays:0], //今天
            [GYBaseQueryListViewController getDateRangeFromTodayWithDays:6], //最近1周 要减1天
            [GYBaseQueryListViewController getDateRangeFromTodayWithDays:29] //最近1月 要减1天
        ];
        vc = vcDetail;
        vc.navigationItem.title = kLocalized(@"GYHS_MyAccounts_cashAccount_details");
    }
    if (!vc)
        return;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 懒加载
- (NSArray*)titleArray
{
    if (!_titleArray) {
        _titleArray = @[ kLocalized(@"GYHS_MyAccounts_cash_to_bank"), globalData.loginModel.cardHolder ? kLocalized(@"GYHS_MyAccounts_cashAccount_details") : kLocalized(@"GYHS_MyAccounts_check_account_details") ];
    }
    return _titleArray;
}

- (NSArray*)imgNameArray
{
    if (!_imgNameArray) {
        _imgNameArray = @[ @"hs_cell_img_cash_account_transfer", @"hs_cell_img_progress_check" ];
    }
    return _imgNameArray;
}
- (UITableView*)cashAccountTableView
{
    if (!_cashAccountTableView) {
        _cashAccountTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        _cashAccountTableView.dataSource = self;
        _cashAccountTableView.delegate = self;
        [self.view addSubview:_cashAccountTableView];
    }
    return _cashAccountTableView;
}
@end
