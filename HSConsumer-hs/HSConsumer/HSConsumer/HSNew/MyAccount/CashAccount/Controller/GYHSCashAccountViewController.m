//
//  GYHSCashAccountViewController.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSCashAccountViewController.h"
#import "Masonry.h"
#import "GYHSCoinAccountCell.h"
#import "GYHSTools.h"
#import "GYBaseQueryListViewController.h"
#import "GYHSPopView.h"
#import "GYHDSetingViewController.h"

#define kGYHSCoinAccountCell @"GYHSCoinAccountCell"

@interface GYHSCashAccountViewController ()<UITableViewDelegate,UITableViewDataSource,GYNetRequestDelegate>

@property (nonatomic ,strong)UITableView *tabView;
//货币
@property (nonatomic, copy)NSString *cashCoinBalance;

@end

@implementation GYHSCashAccountViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始值
    self.cashCoinBalance = @"0.00";
    
    [self setUpUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    NSDictionary* dataDic = responseObject[@"data"];
    if (![dataDic isKindOfClass:[NSNull class]] && dataDic && dataDic.count) {
        self.cashCoinBalance = kSaftToNSString(dataDic[@"accountBalance"]) ;
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
- (void)searchAccountDetail:(UIButton *)btn {
    
    GYHSPopView *pop = [[GYHSPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [pop showView];
    
    GYBaseQueryListViewController* vcDetail = kLoadVcFromClassStringName(NSStringFromClass([GYBaseQueryListViewController class]));
    vcDetail.titleStr = [NSString stringWithFormat:@"%@%@",kLocalized(@"GYHS_HSAccount_cashAccount"),kLocalized(@"GYHS_HSAccount_showDetail")];
    vcDetail.isShowBtnDetail = YES;
    vcDetail.detailsCode = kDetailsCode_Cash;
    vcDetail.arrLeftParas = @[ @"0", @"2", @"1" ];
    vcDetail.arrRightParas = @[
           [GYBaseQueryListViewController getDateRangeFromTodayWithDays:0], //今天
           [GYBaseQueryListViewController getDateRangeFromTodayWithDays:6], //最近1周 要减1天
           [GYBaseQueryListViewController getDateRangeFromTodayWithDays:29] //最近1月 要减1天
           ];
    [pop.popView addSubview:vcDetail.view];
    [vcDetail.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(pop.popView);
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        
        
        GYHSCoinAccountCell * cell = [tableView dequeueReusableCellWithIdentifier:kGYHSCoinAccountCell forIndexPath:indexPath];
        cell.titleLab.textColor = kSelectedRed;
        cell.titleLab.font = kCellImportTextFont;
        cell.titleLab.text = kLocalized(@"GYHS_HSAccount_cashAccountBalance");
        
        cell.textLab.textColor = kSelectedRed;
        cell.textLab.font = kCellImportTextFont;
        cell.textLab.text = [GYUtils formatCurrencyStyle:[self.cashCoinBalance doubleValue]];
        [cell.showDetailBtn addTarget:self action:@selector(searchAccountDetail:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    return nil;
}

#pragma mark - 自定义方法
- (void)requestData {
    NSDictionary* dic = @{ @"accCategory" : kTypeCashBalanceDetail,
                           @"systemType" : kSystemTypeConsumer,
                           @"custId" : kSaftToNSString(globalData.loginModel.custId)
                           };
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kAccountBalanceDetailUrlString parameters:dic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
}
- (void)setUpUI {
    self.tabView = [[UITableView alloc] init];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    self.tabView.rowHeight = 37;
    self.tabView.tableFooterView = [[UIView alloc] init];
    self.tabView.separatorColor = kCellLineGary;
    [self.view addSubview:self.tabView];
    
    
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(1);

    }];
    [self.tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSCoinAccountCell class]) bundle:nil] forCellReuseIdentifier:kGYHSCoinAccountCell];
    
}

@end
