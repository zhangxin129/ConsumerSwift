//
//  GYHSCoinAccountViewController.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSCoinAccountViewController.h"
#import "Masonry.h"
#import "GYHSCoinAccountCell.h"
#import "GYHSTools.h"
#import "GYHSPopView.h"
#import "GYBaseQueryListViewController.h"

#define kGYHSCoinAccountCell @"GYHSCoinAccountCell"

@interface GYHSCoinAccountViewController ()<UITableViewDelegate,UITableViewDataSource,GYNetRequestDelegate>

@property (nonatomic ,strong)UITableView *tabView;
//流通币
@property (nonatomic, copy)NSString * circulationCoinCount;
//定向消费币
@property (nonatomic, copy)NSString * onlyBuyCoinCount;

@end

@implementation GYHSCoinAccountViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始值
    self.circulationCoinCount = @"0.00";
    self.onlyBuyCoinCount = @"0.00";
    globalData.user.HSDToCashAccBal = 0.0;
    globalData.user.HSDConAccBal = 0.0;
    globalData.user.hsdToCashCurrencyConversionFee = 0.0;
    
    [self setUpUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
//    [GYGIFHUD dismiss];
    NSDictionary* dataDic = responseObject[@"data"];
    if ([responseObject[@"retCode"] integerValue] == 200) {
        if (![dataDic isKindOfClass:[NSNull class]] && dataDic && dataDic.count) {
            NSString* ltbBalance = dataDic[@"ltbBalance"];
            double HSDToCashAccBal = [ltbBalance doubleValue];
            self.onlyBuyCoinCount = kSaftToNSString(dataDic[@"xfbBalance"]) ;
            self.circulationCoinCount = kSaftToNSString(dataDic[@"ltbBalance"]);
            globalData.user.HSDToCashAccBal = HSDToCashAccBal;
            globalData.user.HSDConAccBal = [kSaftToNSString(dataDic[@"xfbBalance"]) doubleValue];
            globalData.user.hsdToCashCurrencyConversionFee = [kSaftToNSString(dataDic[@"hsbChangeHbRatio"]) doubleValue];
        }
        
        [self.tabView reloadData];
    }
}
- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error
{
    [GYGIFHUD dismiss];
    [GYUtils parseNetWork:error resultBlock:nil];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        GYHSCoinAccountCell * cell = [tableView dequeueReusableCellWithIdentifier:kGYHSCoinAccountCell forIndexPath:indexPath];
        cell.titleLab.textColor = kSelectedRed;
        cell.titleLab.font = kCellImportTextFont;
        cell.titleLab.text = kLocalized(@"GYHS_HSAccount_circulationCoin");
        
        cell.textLab.textColor = kSelectedRed;
        cell.textLab.font = kCellImportTextFont;
        cell.textLab.text = [GYUtils formatCurrencyStyle:[self.circulationCoinCount doubleValue]];
        cell.showDetailBtn.tag = GYShowCirculationCoinDetail;
        [cell.showDetailBtn addTarget:self action:@selector(searchAccountDetail:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    if(indexPath.row == 1) {
        GYHSCoinAccountCell * cell = [tableView dequeueReusableCellWithIdentifier:kGYHSCoinAccountCell forIndexPath:indexPath];
        cell.titleLab.textColor = kCellTitleBlack;
        cell.titleLab.font = kCellOtherTextFont;
        cell.titleLab.text = kLocalized(@"GYHS_HSAccount_onlyBuyCoin");
        
        cell.textLab.textColor = kCellTitleBlack;
        cell.textLab.font = kCellOtherTextFont;
        cell.textLab.text = [GYUtils formatCurrencyStyle:[self.onlyBuyCoinCount doubleValue]];
        cell.showDetailBtn.tag = GYShowOnlyBuyCoinCountDetail;
        [cell.showDetailBtn addTarget:self action:@selector(searchAccountDetail:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
}
#pragma mark - 点击事件
//明细查询
- (void)searchAccountDetail:(UIButton *)btn {
    GYHSPopView *pop = [[GYHSPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [pop showView];
    
    GYBaseQueryListViewController* QueryListvc = [[GYBaseQueryListViewController alloc] init];
    
    if(btn.tag == GYShowCirculationCoinDetail) {
        QueryListvc.detailsCode = kDetailsCode_HSDToCash;
        QueryListvc.titleStr =[NSString stringWithFormat:@"%@%@",kLocalized(@"GYHS_HSAccount_circulationCoin"),kLocalized(@"GYHS_HSAccount_showDetail")];
    }else if (btn.tag == GYShowOnlyBuyCoinCountDetail) {
        QueryListvc.detailsCode = kDetailsCode_HSDToCon;
        QueryListvc.titleStr =[NSString stringWithFormat:@"%@%@",kLocalized(@"GYHS_HSAccount_onlyBuyCoin"),kLocalized(@"GYHS_HSAccount_showDetail")];
    }
    
    QueryListvc.isShowBtnDetail = YES;
    QueryListvc.arrLeftParas = @[ @"0", @"2", @"1" ];
    QueryListvc.arrRightParas = @[
              [GYBaseQueryListViewController getDateRangeFromTodayWithDays:0], //今天
              [GYBaseQueryListViewController getDateRangeFromTodayWithDays:6], //最近1周 要减1天
              [GYBaseQueryListViewController getDateRangeFromTodayWithDays:29], //最近1月 要减1天
              [GYBaseQueryListViewController getDateRangeFromTodayWithDays:30 * 3 - 1] //最近3月 要减1天
                                  ];
    [pop.popView addSubview:QueryListvc.view];
    [QueryListvc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(pop.popView);
    }];
}

#pragma mark - 自定义方法
- (void)requestData {
    NSDictionary* allFixParas = @{
                                  @"accCategory" : kTypeHSDBalanceDetail,
                                  @"systemType" : kSystemTypeConsumer
                                  };
    NSMutableDictionary* allParas = [NSMutableDictionary dictionaryWithDictionary:allFixParas];
    [allParas setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"custId"];
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kAccountBalanceDetailUrlString parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
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
    self.tabView.separatorInset = UIEdgeInsetsMake(0, 65, 0, 65);
    [self.view addSubview:self.tabView];
    
    
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(1);

    }];
    [self.tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSCoinAccountCell class]) bundle:nil] forCellReuseIdentifier:kGYHSCoinAccountCell];
}

@end
