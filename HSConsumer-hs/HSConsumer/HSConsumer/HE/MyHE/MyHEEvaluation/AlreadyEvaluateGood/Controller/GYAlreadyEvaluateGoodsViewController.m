//
//  GYEvaluationGoodsViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAlreadyEvaluateGoodsViewController.h"
#import "GYEvaluationTableViewCell.h"
#import "GYEvaluateGoodModel.h"
#import "GYEasybuyMainViewController.h"
#import "GYGIFHUD.h"
//#import "GYEasyBuyModel.h"

#define Count 10

@interface GYAlreadyEvaluateGoodsViewController () <UITableViewDataSource, UITableViewDelegate, GYNetRequestDelegate>

@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) int totalCount;
@property (nonatomic, assign) int totalPage;
@property (nonatomic, assign) BOOL isUpFresh;
@property (nonatomic, retain) UIImageView* iconImage;
@property (nonatomic, strong) UIView* viewTipBkg;
@property (nonatomic, strong)NSMutableArray *array;


@end

@implementation GYAlreadyEvaluateGoodsViewController

-(NSMutableArray *)marrDataSource
{
    if (!_marrDataSource) {
        _marrDataSource = [NSMutableArray array];
    }
    return _marrDataSource;
}

-(NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createBGTip];
    [self initView];
    [self loadDataFromNetwork];
    [self headerReresh];
    [self footReresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRereshing) name:@"refreshData" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createBGTip
{
    _currentPage = 1;
    _viewTipBkg = [[UIView alloc]init];
    _viewTipBkg.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.5 - 29, 110, 58, 67)];
    self.iconImage.image = [UIImage imageNamed:@"img_no_result"];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 170, kScreenWidth - 40, 67)];
    titleLabel.text = @"您还没有相关评价记录!";
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.numberOfLines = 2;
    [_viewTipBkg addSubview:titleLabel];
    [_viewTipBkg addSubview:self.iconImage];
    [self.view addSubview:_viewTipBkg];
}

-(void)initView
{
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.backgroundColor = kDefaultVCBackgroundColor;
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYEvaluationTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 16)];
    header.backgroundColor = kDefaultVCBackgroundColor;
    self.tableView.tableHeaderView = header;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView* footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 14)];
    footer.backgroundColor = kDefaultVCBackgroundColor;
    self.tableView.tableFooterView = footer;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //只有返回首页才隐藏NavigationBarHidden
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) { //返回
        if ([self.navigationController.topViewController isKindOfClass:[GYEasybuyMainViewController class]]) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)headerReresh
{
    __weak __typeof(self) wself = self;
    GYRefreshHeader* headerFresh = [GYRefreshHeader headerWithRefreshingBlock:^{
        __strong GYAlreadyEvaluateGoodsViewController *sself = wself;
        [sself headerRereshing];
    }];
    self.tableView.mj_header = headerFresh;
}

- (void)footReresh
{
    __weak __typeof(self) wself = self;
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        __strong GYAlreadyEvaluateGoodsViewController *sself = wself;
        [sself footerRereshing];
    }];
    self.tableView.mj_footer = footer;
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _isUpFresh = YES;
    _currentPage = 1;
    [self loadDataFromNetwork];
}

- (void)footerRereshing
{
    _isUpFresh = NO;
    if (_currentPage <= _totalPage) {
        _currentPage += 1;
        [self loadDataFromNetwork];
    }
}

- (void)loadDataFromNetwork
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:globalData.loginModel.token forKey:@"key"];
    [dict setValue:@"1" forKey:@"status"];
    [dict setValue:[NSString stringWithFormat:@"%d", Count] forKey:@"count"];
    [dict setValue:[NSString stringWithFormat:@"%d", _currentPage] forKey:@"currentPage"];
    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuyGetEvaluationGoodsListUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:(GYNetRequestSerializerHTTP)];
    [request start];
}

#pragma mark -GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    [GYGIFHUD dismiss];
    
    NSString *strCount = [NSString stringWithFormat:@"%@", responseObject[@"rows"]];
    if ([GYUtils checkStringInvalid:strCount]) {
        strCount = @"0";
    }
    _totalCount = [strCount intValue];
    _totalPage = [responseObject[@"totalPage"] intValue];
    if (_isUpFresh) {
        [self.marrDataSource removeAllObjects];
    }
    
    if(_currentPage > 1) {
        self.array = [GYEvaluateGoodModel modelArrayWithResponseObject:responseObject error:nil].mutableCopy;
        [self.marrDataSource addObjectsFromArray:self.array];
    }else{
        self.marrDataSource = [GYEvaluateGoodModel modelArrayWithResponseObject:responseObject error:nil].mutableCopy;
    }
    self.tableView.hidden = (self.marrDataSource && self.marrDataSource.count > 0 ? NO : YES);
    _viewTipBkg.hidden = !self.tableView.hidden;
    
    [self.tableView reloadData];
    if (_currentPage <= _totalPage) {

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
    else {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - failDelegate
-(void)netRequest:(GYNetRequest *)request didFailureWithError:(NSError *)error {
    
    [GYGIFHUD dismiss];
    [GYUtils parseNetWork:error resultBlock:nil];
}

#pragma mark DataSourceDelegate

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _marrDataSource.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 118.0f;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifer = @"cell";
    GYEvaluationTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[GYEvaluationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    cell.btnMakeEvalutaion.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.btnMakeEvalutaion setTitle:kLocalized(@"GYHE_MyHE_AlreadyEvaluate") forState:UIControlStateNormal];
    GYEvaluateGoodModel *EvaluateGoodModel = _marrDataSource[indexPath.row];
    [cell refreshUIWithModel:EvaluateGoodModel WithType:1];
    return cell;
}

@end
