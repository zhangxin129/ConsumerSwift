//
//  GYPvAccountViewController.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYPvAccountViewController.h"
#import "Masonry.h"
#import "GYHSAccountCell.h"
#import "GYHSTools.h"
#import "GYBaseQueryListViewController.h"
#import "GYHSPopView.h"
#import "GYHSCoinAccountCell.h"

#define kGYHSAccountCell @"GYHSAccountCell"
#define kGYHSCoinAccountCell @"GYHSCoinAccountCell"
#define kGYHSAccountShowDetailCell @"GYHSAccountShowDetailCell"

@interface GYPvAccountViewController ()<UITableViewDelegate,UITableViewDataSource,GYNetRequestDelegate>

@property (nonatomic ,strong)UITableView *tabView;
//积分账户余额
@property (nonatomic, copy)NSString * pvAccountBalance;
//可以积分
@property (nonatomic, copy)NSString * canUsePv;
//今日积分数
@property (nonatomic, copy)NSString * todayUsePv;

@end

@implementation GYPvAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始值
    _pvAccountBalance = @"0.00";
    _canUsePv = @"0.00";
    _todayUsePv = @"0.00";
    
    [self setUpUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    if ([responseObject[@"retCode"] integerValue] == 200) {
        if (![responseObject isKindOfClass:[NSNull class]] && responseObject && responseObject.count) {
            self.pvAccountBalance = kSaftToNSString(responseObject[@"data"][@"accountBalance"]);
            self.canUsePv = kSaftToNSString(responseObject[@"data"][@"canUsePoints"]);
            self.todayUsePv = kSaftToNSString(responseObject[@"data"][@"todayPoints"]);
            
            [self.tabView reloadData];
        }
    }
}
- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error
{
    [GYUtils parseNetWork:error resultBlock:nil];
}


#pragma mark - GYHSAccountShowDetailCellDelegate
//明细查询
- (void)searchAccountDetail:(UIButton *)btn {
    
    GYHSPopView *pop = [[GYHSPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [pop showView];

    GYBaseQueryListViewController* vcDetail = kLoadVcFromClassStringName(NSStringFromClass([GYBaseQueryListViewController class]));
    vcDetail.titleStr =[NSString stringWithFormat:@"%@%@",kLocalized(@"GYHS_HSAccount_pvAccountBtn"),kLocalized(@"GYHS_HSAccount_showDetail")] ;
    vcDetail.isShowBtnDetail = YES;
    vcDetail.detailsCode = kDetailsCode_Point;
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        GYHSCoinAccountCell * cell = [tableView dequeueReusableCellWithIdentifier:kGYHSCoinAccountCell forIndexPath:indexPath];
        cell.titleLab.textColor = kSelectedRed;
        cell.titleLab.font = kCellImportTextFont;
        cell.titleLab.text = kLocalized(@"GYHS_HSAccount_pvAccountBalance");
        
        cell.textLab.textColor = kSelectedRed;
        cell.textLab.font = kCellImportTextFont;
        cell.textLab.text = [GYUtils formatCurrencyStyle:[self.pvAccountBalance doubleValue]];
        [cell.showDetailBtn addTarget:self action:@selector(searchAccountDetail:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    if(indexPath.row == 1) {
        GYHSAccountCell * cell = [tableView dequeueReusableCellWithIdentifier:kGYHSAccountCell forIndexPath:indexPath];
        cell.titleLab.textColor = kCellTitleBlack;
        cell.titleLab.font = kCellOtherTextFont;
        cell.titleLab.text = kLocalized(@"GYHS_HSAccount_canUsePv");
        
        cell.textLab.textColor = kCellTitleBlack;
        cell.textLab.font = kCellOtherTextFont;
        cell.textLab.text = [GYUtils formatCurrencyStyle:[self.canUsePv doubleValue]];
        return cell;
    }
    if(indexPath.row == 2) {
        GYHSAccountCell * cell = [tableView dequeueReusableCellWithIdentifier:kGYHSAccountCell forIndexPath:indexPath];
        cell.titleLab.textColor = kCellTitleBlack;
        cell.titleLab.font = kCellOtherTextFont;
        cell.titleLab.text = kLocalized(@"GYHS_HSAccount_todayUsePv");
        cell.textLab.textColor = kCellTitleBlack;
        cell.textLab.font = kCellOtherTextFont;
        cell.textLab.text = [GYUtils formatCurrencyStyle:[self.todayUsePv doubleValue]];
        return cell;
    }
    
    return nil;
}

#pragma mark - 自定义方法
- (void)requestData {
    NSDictionary* allFixParas = @{
                                  @"accCategory" : kTypePointBalanceDetail,
                                  @"systemType" : kSystemTypeConsumer,
                                  @"custId" : kSaftToNSString(globalData.loginModel.custId),
                                  };
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kAccountBalanceDetailUrlString parameters:allFixParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
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
    [self.tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSAccountCell class]) bundle:nil] forCellReuseIdentifier:kGYHSAccountCell];
    [self.tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSCoinAccountCell class]) bundle:nil] forCellReuseIdentifier:kGYHSCoinAccountCell];
    
}



@end
