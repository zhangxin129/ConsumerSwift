//
//  GYTicketAccountViewController.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYTicketAccountViewController.h"
#import "Masonry.h"
#import "GYTicketAccountCell.h"
#import "GYHSTools.h"
#import "GYTicketAccountModel.h"
#import "GYTicketAccountDetailViewController.h"
#import "GYHSPopView.h"

#define kGYTicketAccountCell @"GYTicketAccountCell"

@interface GYTicketAccountViewController ()<UITableViewDelegate,UITableViewDataSource,GYNetRequestDelegate,GYTicketAccountCellDelegate>

@property (nonatomic ,strong)UITableView *tabView;

@property (nonatomic ,strong)GYTicketAccountModel *model;

@end

@implementation GYTicketAccountViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    if (responseObject[@"data"] && [responseObject[@"data"] isKindOfClass:[NSArray class]]) {
        NSArray *arr = [GYTicketAccountModel modelArrayWithResponseObject:responseObject error:nil];
        _model = arr.firstObject;
        [self.tabView reloadData];
            
        
    }
}
- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error
{
    [GYGIFHUD dismiss];
    [GYUtils parseNetWork:error resultBlock:nil];
}
#pragma mark - GYTicketAccountCellDelegate
//明细查询
- (void)showDidUseTicket:(GYTicketAccountCell *)cell {
    GYHSPopView *pop = [[GYHSPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [pop showView];
    
//    GYEPMyCouponsViewController * tmpVc = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyCouponsViewController class]));
//    tmpVc.firstTipsErr = NO;
//    tmpVc.couponsType = kCouponsTypeUsed;
    GYTicketAccountDetailViewController *vc = [[GYTicketAccountDetailViewController alloc] init];
    
    [pop.popView addSubview:vc.view];
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(pop.popView);
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GYTicketAccountCell * cell = [tableView dequeueReusableCellWithIdentifier:kGYTicketAccountCell forIndexPath:indexPath];
    cell.ticketTypeTextLab.text = [NSString stringWithFormat:@"(%@)",[kSaftToNSString(self.model.couponName) isEqualToString:@""] ? kLocalized(@"GYHS_HSAccount_firstGiven") : self.model.couponName];
    
    cell.ticketValueTextLab.text = [GYUtils formatCurrencyStyle:[kSaftToNSString(self.model.faceValue) doubleValue]];
    cell.canUseTextLab.text = [kSaftToNSString(self.model.surplusNumber) isEqualToString:@""] ? @"0" : self.model.surplusNumber;
    cell.didUseTextLab.text = [kSaftToNSString(self.model.usedNumber)  isEqualToString:@""] ? @"0" : (self.model.usedNumber);
    
    NSDate* cdate = [NSDate dateWithTimeIntervalSince1970:[self.model.expEnd longLongValue] / 1000];
    NSString* exEndTime = [GYUtils dateToString:cdate];
    if ([exEndTime hasPrefix:@"1970"]) {
        exEndTime = kLocalized(@"GYHS_HSAccount_long_time");
    }
    cell.timeTextLab.text = exEndTime;
    
    cell.delegate = self;
    
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
    return cell;
    
}

#pragma mark - 自定义方法
- (void)requestData {
    
    NSMutableDictionary* allParas = [@{ @"key" : globalData.loginModel.token,@"count" : @"10",@"currentPage" : @"1"} mutableCopy];
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuyGetMyVoucherUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    [request start];
}
- (void)setUpUI {
    self.tabView = [[UITableView alloc] init];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    self.tabView.rowHeight = 185;
    self.tabView.tableFooterView = [[UIView alloc] init];
    self.tabView.separatorColor = kCellLineGary;
    [self.view addSubview:self.tabView];
    
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(1);

    }];
    [self.tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYTicketAccountCell class]) bundle:nil] forCellReuseIdentifier:kGYTicketAccountCell];
    
}


@end
