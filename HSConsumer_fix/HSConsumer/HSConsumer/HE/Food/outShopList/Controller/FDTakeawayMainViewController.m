//
//  FDTakeawayMainViewController.m
//  HSConsumer
//
//  Created by zhangqy on 15/9/19.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#define FDTAKEAWAYCELLREUSEID @"FDTakeawayCellReuseId"
#define FDTakeawayMainCellREUSEID @"FDTakeawayMainCellReuseId"
#import "FDTakeawayMainViewController.h"
#import "FDSearchShopAndFoodViewController.h"
#import "FDSearchShopViewController.h"
#import "FDSelectFoodViewController.h"
#import "FDShopModel.h"
#import "FDTakeawayMainCell.h"
#import "GYAroundLocationChooseController.h"
#import "GYGIFHUD.h"

@interface FDTakeawayMainViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView* historySeperateView;
@property (weak, nonatomic) IBOutlet UIView* tagLocationView;
@property (weak, nonatomic) IBOutlet UILabel* loactionAddressLabel;
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (weak, nonatomic) IBOutlet UIButton* backBtn;
@property (weak, nonatomic) IBOutlet UIButton* searchBtnRight;
@property (weak, nonatomic) IBOutlet UIScrollView* headerCenterView;
@property (weak, nonatomic) IBOutlet UIView* headerCenterSearchView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* historyShopViewConstraintHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* separterSpaceConstraintHeight;
//定位显示相关
@property (strong, nonatomic) IBOutlet UIView* locationView;
@property (weak, nonatomic) IBOutlet UILabel* locationLabel;

@property (strong, nonatomic) NSMutableArray* dataSource;
@property (strong, nonatomic) NSMutableArray* favDataSource;
@property (assign, nonatomic) NSInteger currentPageIndex;

@property (assign, nonatomic) CLLocationCoordinate2D currentlocationCorrrdinate;
@property (copy, nonatomic) NSString* landmark;
@property (copy, nonatomic) NSString* locationAddress;

@property (strong, nonatomic) IBOutlet UIView* noResultView;

//add  zhangx 国际化
@property (weak, nonatomic) IBOutlet UIButton* deliveryTimeBtn; //送餐时间
@property (weak, nonatomic) IBOutlet UIButton* evaluateBtn; //评价

@property (weak, nonatomic) IBOutlet UIButton* distanceBtn; //距离
@property (weak, nonatomic) IBOutlet UILabel* noSearchLabel; //无法搜到外卖信息

@end

@implementation FDTakeawayMainViewController

- (void)initParams
{
    _currentPageIndex = 1;
    _params = [[NSMutableDictionary alloc] init];
    [_params setObject:@"10" forKey:@"pageSize"];
    [_params setObject:@"" forKey:@"key"];
    [_params setObject:@"2" forKey:@"type"];
    [_params setObject:@"2" forKey:@"everFlag"];
    if (globalData.selectedCityCoordinate) {
        [_params setObject:globalData.selectedCityName forKey:@"city"];
        [_params setObject:globalData.selectedCityCoordinate forKey:@"landmark"];
    } else {
        if (globalData.locationCity == nil) {

            [_params setObject:@"" forKey:@"city"];
        } else {

            [_params setObject:globalData.locationCity forKey:@"city"];
        }
        [_params setObject:[NSString stringWithFormat:@"%f,%f", globalData.locationCoordinate.latitude, globalData.locationCoordinate.longitude] forKey:@"landmark"];
    }
    _landmark = _params[@"landmark"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataSource = [[NSMutableArray alloc] init];
    _favDataSource = [[NSMutableArray alloc] init];
    [_tagLocationView addAllBorder];
    [self initParams];
    if (!globalData.isOnNet) {
        [self showNoNetworkView];
    } else {
    }
    [self.deliveryTimeBtn setTitle:kLocalized(@"GYHE_Food_DeliveryTime") forState:UIControlStateNormal];
    [self.evaluateBtn setTitle:kLocalized(@"GYHE_Food_Appraise") forState:UIControlStateNormal];
    [self.distanceBtn setTitle:kLocalized(@"GYHE_Food_Distance") forState:UIControlStateNormal];
    [self.backBtn setTitle:kLocalized(@"GYHE_Food_TakeAway") forState:UIControlStateNormal];
    self.noSearchLabel.text = kLocalized(@"GYHE_Food_NoSearchTakeAwayInfomation");
    _backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //    导航栏改变change by zhangx
    _locationView.layer.cornerRadius = 5.0f;
    self.navigationItem.titleView = _locationView;
    _locationView.backgroundColor = [UIColor clearColor];

    self.navigationItem.titleView = _locationView;
    UITapGestureRecognizer* tapNav = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagLocationViewtapped:)];

    [_locationView addGestureRecognizer:tapNav];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];

    UIButton* bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setImage:[UIImage imageNamed:@"gyhe_search_white"] forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(btnSerarchClicked) forControlEvents:UIControlEventTouchUpInside];
    bt.frame = CGRectMake(0, 0, 20, 20);

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bt];

    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        _currentPageIndex = 1;

        [_dataSource removeAllObjects];
        [self loadData];
    }];
    [_tableView addLegendFooterWithRefreshingBlock:^{
        _currentPageIndex++;

        [self loadData];
    }];

    [_tableView registerNib:[UINib nibWithNibName:@"FDTakeawayMainCell" bundle:nil] forCellReuseIdentifier:FDTakeawayMainCellREUSEID];

    [self clearAndLoadData];
}

/*
   修改主界面返回时tabBar不显示问题 add by zhangx
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)reloadNetworkData
{
    [super reloadNetworkData];
    if (globalData.isOnNet) {
        [self clearAndLoadData];
        //        [self startLocation];
        [self dismissNoNetworkView];
    }
}

- (void)tagLocationViewtapped:(UITapGestureRecognizer*)tap
{

    GYAroundLocationChooseController* arount = [[GYAroundLocationChooseController alloc] init];

    arount.block = ^() {

        [self initParams];

        [self clearAndLoadData];

    };
    [self.navigationController pushViewController:arount animated:YES];
}

- (void)loadHistoryShops
{
    //    if (!_landmark || _favDataSource.count>0) {
    //        return;
    //    }
    //    [_favDataSource removeAllObjects];

    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    NSString* userKey = globalData.loginModel.token;
    if (globalData.isLogined) {

        //        更改接口后 传入参数修改

        [dict setObject:userKey forKey:@"key"];

        [dict setObject:_landmark forKey:@"landmark"];

        [GYGIFHUD show];
        [FDShopModel modelArrayNetURL:GetFoodBeforeListUrl
                           parameters:dict
                               option:GYM_GetJson
                           completion:^(NSArray* modelArray, id responseObject, NSError* error) {

                               [_favDataSource removeAllObjects];
                               [GYGIFHUD dismiss];
                               if (modelArray.count > 0) {
                                   [_favDataSource addObjectsFromArray:modelArray];

                                   if (_favDataSource.count > 0) {
                                       [self setupScrollView];
                                   }
                               }
                           }];
    }
}

- (void)loadData
{
    [_params setObject:@"2" forKey:@"everFlag"];
    [_params setObject:@(_currentPageIndex).stringValue forKey:@"currentPageIndex"];

    [GYGIFHUD show];
    [FDShopModel modelArrayNetURL:GetFoodMainPageUrl
                       parameters:_params
                           option:GYM_GetJson
                       completion:^(NSArray* modelArray, id responseObject, NSError* error) {

                           [GYGIFHUD dismiss];
                           [_tableView.mj_header endRefreshing];
                           [_tableView.mj_footer endRefreshing];
                           if (modelArray.count > 0) {
                               [_dataSource addObjectsFromArray:modelArray];
                           }
                           if (_dataSource.count > 0) {
                               _tableView.tableFooterView = [[UIView alloc] init];
                               _tableView.mj_footer.hidden = NO;
                           } else if (_dataSource.count == 0) {
                               _tableView.tableFooterView = _noResultView;
                               _noResultView.hidden = !globalData.isOnNet ? YES : NO;

                               _tableView.mj_footer.hidden = YES;
                           } else {
                               _tableView.mj_footer.hidden = NO;
                           }

                           if (_currentPageIndex >= [[responseObject objectForKey:@"totalPage"] integerValue]) {
                               [_tableView.mj_footer endRefreshingWithNoMoreData];
                           } else {
                               [_tableView.mj_footer resetNoMoreData];
                           }

                           [_tableView reloadData];
                       }];
}

- (void)clearAndLoadData
{

    _currentPageIndex = 1;
    [_dataSource removeAllObjects];
    [self loadData];
}

- (void)setupScrollView
{
    [_historySeperateView addTopBorderAndBottomBorder];
    //    add zhangxin 解决外卖历史视图重叠 问题
    for (UIView* view in [_headerCenterView subviews]) {

        [view removeFromSuperview];
    }
    [UIView animateWithDuration:0.25
                     animations:^{
                         _historyShopViewConstraintHeight.constant = 100;
                         _separterSpaceConstraintHeight.constant = 35;
                         [self.view layoutIfNeeded];
                     }];
    for (int i = 0; i < _favDataSource.count; i++) {
        FDTakeawayMainCell* headerCell = [[[NSBundle mainBundle] loadNibNamed:@"FDTakeawayMainCell" owner:self options:nil] lastObject];

        FDShopModel* model = _favDataSource[i];
        headerCell.model = model;
        headerCell.frame = CGRectMake(i * kScreenWidth, 0, kScreenWidth, 100);
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerCellDidTapped:)];
        headerCell.tag = 7000 + i;
        [headerCell addGestureRecognizer:tap];
        [_headerCenterView addSubview:headerCell];
    }
    [_headerCenterView addTopBorderAndBottomBorder];
    _headerCenterView.pagingEnabled = YES;

    _headerCenterView.contentSize = CGSizeMake(kScreenWidth * _favDataSource.count, 0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (globalData.selectedCityCoordinate) {
        _locationLabel.text = globalData.selectedCityAddress;
        [self initParams];
    } else {
        _locationLabel.text = globalData.locaitonAddress;
    }
    //    [self clearAndLoadData];
    _headerCenterView.contentSize = CGSizeMake(kScreenWidth * _favDataSource.count, 0);
    [self loadHistoryShops];
    //    [self startLocation];
    //用于接收重新定位发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateByLocation) name:kGYHSLoginManagerCityAddressNotification object:nil];
}

- (void)updateByLocation
{

    [self initParams];

    [self clearAndLoadData];
}

- (void)dealloc
{
    // 销毁通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnSerarchClicked
{

    //    跳转新的搜索界面
    FDSearchShopAndFoodViewController* vc = [[FDSearchShopAndFoodViewController alloc] init];
    vc.landmark = _params[@"landmark"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark UITableViewDataSource UITableViewDelegate

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    FDTakeawayMainCell* cell = [tableView dequeueReusableCellWithIdentifier:FDTakeawayMainCellREUSEID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FDTakeawayMainCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (_dataSource.count > indexPath.row) {
        cell.model = _dataSource[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FDSelectFoodViewController* chooseVC = [[FDSelectFoodViewController alloc] init];
    if (_dataSource.count > indexPath.row) {
        chooseVC.shopModel = _dataSource[indexPath.row];
    }
    chooseVC.isTakeaway = YES;
    chooseVC.landMark = _landmark;
    [self.navigationController pushViewController:chooseVC animated:YES];
}

- (void)headerCellDidTapped:(UITapGestureRecognizer*)tap
{
    FDSelectFoodViewController* chooseVC = [[FDSelectFoodViewController alloc] init];
    chooseVC.isTakeaway = YES;
    chooseVC.shopModel = _favDataSource[tap.view.tag - 7000];
    [self.navigationController pushViewController:chooseVC animated:YES];
}

- (void)setTagLocationLabel:(NSString*)text
{
    _locationLabel.text = text;
}

- (IBAction)tagScoreClicked:(UIButton*)sender
{
    [_params setObject:@"scoreAvg" forKey:@"sortName"];
    [self clearAndLoadData];
}

- (IBAction)tagSendtimeClicked:(UIButton*)sender
{
    [_params setObject:@"sendTimeConsume" forKey:@"sortName"];
    [self clearAndLoadData];
}

- (IBAction)tagDistanceClicked:(id)sender {
    [_params setObject:@"" forKey:@"sortName"];
    [self clearAndLoadData];
}

@end
