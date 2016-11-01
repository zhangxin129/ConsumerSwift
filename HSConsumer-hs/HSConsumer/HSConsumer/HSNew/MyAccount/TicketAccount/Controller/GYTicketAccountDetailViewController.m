//
//  GYTicketAccountDetailViewController.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYTicketAccountDetailViewController.h"
#import "Masonry.h"
#import "GYHSTools.h"
#import "GYHSPopView.h"
#import "GYTicketAccountDetailCell.h"
#import "GYTicketAccountDetailModel.h"

#define kGYTicketAccountDetailCell @"GYTicketAccountDetailCell"

@interface GYTicketAccountDetailViewController ()<UITableViewDelegate,UITableViewDataSource,GYNetRequestDelegate>

@property (nonatomic ,strong)UITableView *tabView;
@property (nonatomic, assign)NSString * page;
@property (nonatomic, strong)NSMutableArray *dataArr;

@end

@implementation GYTicketAccountDetailViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    _page = @"1";
    [self setUpUI];
    [self refreshUI];
    [self.tabView.mj_header beginRefreshing];
}
#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    
    if (responseObject[@"data"] && [responseObject[@"data"] isKindOfClass:[NSArray class]]) {
        NSArray *arr =[GYTicketAccountDetailModel modelArrayWithResponseObject:responseObject error:nil];
        if([self.tabView.mj_header isRefreshing]) {
            [self.tabView.mj_footer resetNoMoreData];
            [self.tabView.mj_header endRefreshing];
            self.dataArr = arr.mutableCopy;
        }
        if([self.tabView.mj_footer isRefreshing]) {
            [self.tabView.mj_footer endRefreshing];
            [self.dataArr addObjectsFromArray:arr];
        }
        
        [self.tabView reloadData];
        
    }
    if([kSaftToNSString(responseObject[@"currentPageIndex"]) isEqualToString:kSaftToNSString(responseObject[@"totalPage"]) ]) {
        [self.tabView.mj_footer endRefreshingWithNoMoreData];
    }
    
}
- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error
{
    [GYGIFHUD dismiss];
    [GYUtils parseNetWork:error resultBlock:nil];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYTicketAccountDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYTicketAccountDetailCell forIndexPath:indexPath];
    if(self.dataArr.count > indexPath.row) {
        cell.model = self.dataArr[indexPath.row];
    }
    
    cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    return cell;
}
#pragma mark - 自定义方法
- (void)refreshUI {
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        
        [self requestData];
        self.page = [NSString stringWithFormat:@"%d",[self.page intValue] + 1];
    }];
    self.tabView.mj_footer = footer;
    
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        
        [self requestData];
        self.page = @"1";
        
    }];
    self.tabView.mj_header = header;
}
- (void)requestData {
    
    NSMutableDictionary* allParas = [@{ @"key" : globalData.loginModel.token,@"count" : @"10",@"currentPage" : _page} mutableCopy];
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuyGetUsedVoucherUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];

}

- (void)setUpUI {
    UILabel *lab = [[UILabel alloc] init];
    lab.backgroundColor = [UIColor whiteColor];
    lab.text = kLocalized(@"GYHS_HSAccount_didUse");
    lab.font = kAlterTitleFont;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = kCellTitleBlack;
    [self.view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    self.tabView = [[UITableView alloc] init];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    self.tabView.rowHeight = 123;
    self.tabView.tableFooterView = [[UIView alloc] init];
    self.tabView.separatorColor = kCellLineGary;
    [self.view addSubview:self.tabView];
    
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(41);
    }];
    [self.tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYTicketAccountDetailCell class]) bundle:nil] forCellReuseIdentifier:kGYTicketAccountDetailCell];

}
- (NSMutableArray *)dataArr {
    if(!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

@end
