//
//  GYInvestmentAccountViewController.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYInvestmentAccountViewController.h"
#import "Masonry.h"
#import "GYHSAccountCell.h"
#import "GYHSAccountShowDetailCell.h"
#import "GYHSCentreLabCell.h"
#import "GYHSInvestRateCell.h"
#import "GYHSTools.h"
#import "GYBaseQueryListViewController.h"
#import "GYHSPopView.h"
#import "GYHSCoinAccountCell.h"

#define kGYHSAccountCell @"GYHSAccountCell"
#define kGYHSCoinAccountCell @"GYHSCoinAccountCell"
#define kGYHSCentreLabCell @"GYHSCentreLabCell"
#define kGYHSInvestRateCell @"GYHSInvestRateCell"

@interface GYInvestmentAccountViewController ()<UITableViewDelegate,UITableViewDataSource,GYNetRequestDelegate,GYHSCentreLabCellDelegate,GYHSInvestRateCellDelegate>

@property (nonatomic ,strong)UITableView *tabView;
//年度分红率
@property (nonatomic, copy)NSString *yearDividendRate;
//累计积分投资数
@property (nonatomic, copy)NSString *totalpvInvestment;
//年度投资分红互生币
@property (nonatomic, copy)NSString *yearDividendHSCoin;
//流通币
@property (nonatomic, copy)NSString *circulationCoin;
//定向消费币
@property (nonatomic, copy)NSString *onlyBuyCoin;

@property (nonatomic, copy)NSString *year;

@end

@implementation GYInvestmentAccountViewController


#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始值
    self.yearDividendRate = @"0.00";
    self.totalpvInvestment = @"0.00";
    self.yearDividendHSCoin = @"0.00";
    self.circulationCoin = @"0.00";
    self.onlyBuyCoin = @"0.00";
    
    [self setUpUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    NSDictionary* dic = responseObject;
    dic = dic[@"data"];
    if (![dic isKindOfClass:[NSNull class]] && dic && dic.count) {
    
        self.yearDividendRate = [NSString stringWithFormat:@"%.2f",[kSaftToNSString(dic[@"yearDividendRate"]) doubleValue] * 100];
        self.totalpvInvestment = kSaftToNSString(dic[@"accumulativeInvestCount"]) ;
        self.yearDividendHSCoin = kSaftToNSString(dic[@"totalDividend"]);
        self.circulationCoin = kSaftToNSString(dic[@"normalDividend"]);
        self.onlyBuyCoin = kSaftToNSString(dic[@"directionalDividend"]);
        self.year = kSaftToNSString(dic[@"dividendYear"]);
        [self.tabView reloadData];
    }
    
}
- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error
{
    [GYGIFHUD dismiss];
    [GYUtils parseNetWork:error resultBlock:nil];
}
#pragma mark - GYHSAccountShowDetailCellDelegate
//明细查询
- (void)searchAccountDetail:(GYHSAccountShowDetailCell *)cell {
    GYHSPopView *pop = [[GYHSPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [pop showView];
    
    GYBaseQueryListViewController* vcDetail = kLoadVcFromClassStringName(NSStringFromClass([GYBaseQueryListViewController class]));
    vcDetail.titleStr = [NSString stringWithFormat:@"%@%@",kLocalized(@"GYHS_HSAccount_pvInvestment"),kLocalized(@"GYHS_HSAccount_showDetail")];
    //积分投资分红明细查询 无显示查询条件修改
    vcDetail.isShowBtnDetail = YES;
    vcDetail.arrLeftParas = @[ @"0" ];
    vcDetail.detailsCode = kDetailsCode_InvestPoint;
    vcDetail.arrRightParas = @[
                               [GYBaseQueryListViewController getDateRangeFromTodayWithDays:29] //最近1月 要减1天
                               ];
    [pop.popView addSubview:vcDetail.view];
    [vcDetail.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(pop.popView);
    }];

}

#pragma mark - GYHSInvestRateCellDelegate
- (void)showYearInvestmentDetail:(GYHSInvestRateCell *)cell {
    NSMutableDictionary * paramters = [[NSMutableDictionary alloc]init];
    [paramters setValue:@"1" forKey:@"curPage"];
    [paramters setValue:@"10" forKey:@"pageSize"];
    GYNetRequest * request = [[GYNetRequest alloc]initWithBlock:kYearDividendRateListUrlString parameters:paramters requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            [GYUtils parseNetWork:error resultBlock:nil];
            
            return;
        }
        
    }];
//    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

#pragma mark - GYHSCentreLabCellDelegate
//查看历年投资明细
- (void)showInvestmentDetail:(GYHSCentreLabCell *)cell {
    
    
    GYHSPopView *pop = [[GYHSPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [pop showView];
    
    GYBaseQueryListViewController* vcDetail = kLoadVcFromClassStringName(NSStringFromClass([GYBaseQueryListViewController class]));
    vcDetail.titleStr = [NSString stringWithFormat:@"%@%@",kLocalized(@"GYHS_HSAccount_yearInvestment"),kLocalized(@"GYHS_HSAccount_showDetail")];
    //积分投资分红明细查询 无显示查询条件修改
    vcDetail.isShowBtnDetail = YES;
    vcDetail.arrLeftParas = @[ @"0" ];
    vcDetail.detailsCode = kDetailsCode_InvestDividends;
    vcDetail.noLeftDownBtnText = kLocalized(@"GYHS_HSAccount_yearInvestment");
    vcDetail.arrRightParas = @[
                               [GYBaseQueryListViewController getDateRangeFromTodayWithDays:365 * 1 - 1], //最近1年 要减1天
                               [GYBaseQueryListViewController getDateRangeFromTodayWithDays:365 * 3 - 1], //最近3年 要减1天
                               [GYBaseQueryListViewController getDateRangeFromTodayWithDays:365 * 5 - 1] //最近5年 要减1天
                               ];
    [pop.popView addSubview:vcDetail.view];
    [vcDetail.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(pop.popView);
    }];

}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 2;
    }else {
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            GYHSInvestRateCell * cell = [tableView dequeueReusableCellWithIdentifier:kGYHSInvestRateCell forIndexPath:indexPath];
            cell.delegate = self;
            cell.titleLab.text = [NSString stringWithFormat:@"%@%@",self.year,kLocalized(@"GYHS_HSAccount_yearDividendRate")];
            cell.textLab.text = [NSString stringWithFormat:@"%@%%",self.yearDividendRate];
            cell.separatorInset = UIEdgeInsetsMake(0, 30, 0, 30);
            return cell;

        }
        if(indexPath.row == 1) {
            GYHSCoinAccountCell * cell = [tableView dequeueReusableCellWithIdentifier:kGYHSCoinAccountCell forIndexPath:indexPath];
            cell.titleLab.font = kCellImportTextFont;
            cell.titleLab.text = kLocalized(@"GYHS_HSAccount_totalpvInvestment");
            
            cell.textLab.textColor = kSelectedRed;
            cell.textLab.font = kCellImportTextFont;
            cell.textLab.text = [GYUtils formatCurrencyStyle:[self.totalpvInvestment doubleValue]];
            [cell.showDetailBtn addTarget:self action:@selector(searchAccountDetail:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addBottomBorderWithBorderWidth:0.1 andBorderColor:kCellLineGary];
            [cell.contentView setBottomBorderInset:YES];
            return cell;

        }
    }else {
        if(indexPath.row == 0) {
            GYHSCentreLabCell *cell =[tableView dequeueReusableCellWithIdentifier:kGYHSCentreLabCell forIndexPath:indexPath];
            cell.titleLab1.text = [NSString stringWithFormat:@"%@",kLocalized(@"GYHS_HSAccount_yearDividendHSCoin")];
            cell.textLab1.text = [GYUtils formatCurrencyStyle:[self.yearDividendHSCoin doubleValue]];
            cell.textLab2.text = [GYUtils formatCurrencyStyle:[self.circulationCoin doubleValue]];
            cell.textLab3.text = [GYUtils formatCurrencyStyle:[self.onlyBuyCoin doubleValue]];
            cell.delegate = self;
            return cell;
        }
        
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return 38;
    }else {
        if(indexPath.row == 1) {
            return 38;
        }
        return 81;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return 0;
    }
    return 23;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 23)];
        view.backgroundColor = [UIColor whiteColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(65, 0, kScreenWidth - 130, 0.5)];
        lineView.backgroundColor = kCellLineGary;
        [view addSubview:lineView];
        return view;
    }
    return nil;
}

#pragma mark - 自定义方法
- (void)requestData {
    NSMutableDictionary* allParas = [NSMutableDictionary dictionary];
    [allParas setValue:kSaftToNSString(globalData.loginModel.resNo) forKey:@"hsResNo"];
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kInvestBalanceDetailUrlString parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
}
- (void)setUpUI {
    self.tabView = [[UITableView alloc] init];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    self.tabView.tableFooterView = [[UIView alloc] init];
    self.tabView.separatorColor = kCellLineGary;
    [self.view addSubview:self.tabView];
    
    
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(1);
    }];
    [self.tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSAccountCell class]) bundle:nil] forCellReuseIdentifier:kGYHSAccountCell];
    [self.tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSCoinAccountCell class]) bundle:nil] forCellReuseIdentifier:kGYHSCoinAccountCell];
    [self.tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSCentreLabCell class]) bundle:nil] forCellReuseIdentifier:kGYHSCentreLabCell];
    [self.tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSInvestRateCell class]) bundle:nil] forCellReuseIdentifier:kGYHSInvestRateCell];
}

@end
