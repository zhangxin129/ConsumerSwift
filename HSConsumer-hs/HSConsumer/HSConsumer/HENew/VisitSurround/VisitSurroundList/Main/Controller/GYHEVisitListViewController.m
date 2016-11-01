//
//  GYHEVisitListViewController.m
//  HSConsumer
//
//  Created by kuser on 16/9/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEVisitListViewController.h"
#import "GYHEVisitListCell.h"
#import "GYHEVisitListModel.h"
#import "GYHEListSearchViewController.h"
#import "GYPullDownMenu.h"
#import "GYMenuButton.h"
#import "GYHEListSortViewController.h"
#import "GYHENearLocationViewController.h"
#import "GYHECategoryViewController.h"
#import "GYHEMoreMenusCell.h"
#import "GYHEMoreMenusViewController.h"
#import "GYHEAroundLocationChooseController.h"
#import "GYDynamicMenuView.h"
#import "GYHEDynamicMenuViewController.h"
#import "GYHEShopDetailViewController.h"
#import "YYKit.h"
#import "GYFullScreenPopView.h"
#import "GYMapLocationViewController.h"
#import "GYHEMapSelectAddressViewController.h"

#define kGYHEVisitListCellIdentifier @"GYHEVisitListCell"
#define kEachPageSizeStr 2

@interface GYHEVisitListViewController ()<UITableViewDataSource, UITableViewDelegate, GYNetRequestDelegate,GYPullDownMenuDataSource,GYAroundLocationChooseControllerDelegate,GYDynamicMenuViewDelegate,GYFullScreenPopDelegate,GYMapLocationViewControllerDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArry; //数据源
@property (nonatomic, strong)GYHEVisitListModel *model;
@property (nonatomic, assign) BOOL isUpFresh;          //是否刷新
@property (nonatomic, assign) int totalPage;           //总共页数
@property (nonatomic, assign) int currentPageIndexStr; //当前页数
@property (nonatomic, strong) NSArray *titles;         //头部标题
@property (nonatomic, strong)UILabel *locationLabel;   //定位地区
@property (nonatomic, strong)UILabel *cityLabel;       //定位城市

@end

@implementation GYHEVisitListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xfb7d00);
    [self setNav];
    [self initView];
    GYPullDownMenu *menu = [[GYPullDownMenu alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, 40)];
    [self.view addSubview:menu];
    menu.dataSource = self;
    _titles = @[@"附近",@"分类",@"排序",@"服务"];
    // 添加子控制器
    [self setupAllChildViewController];
    [self requestData];
    [self creatHeaderRefresh];
    [self creatFootReresh];
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kScreenWidth-40, (kScreenHeight-64-49)/2, 40, 40);
    [btn setImage:[UIImage imageNamed:@"gyhe_dynamic_menu"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dynamicMenubtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!globalData.selectedCityCoordinate) {
        NSString*string = globalData.selectedCityAddress;
        NSArray *array = [string componentsSeparatedByString:globalData.selectedCityName];
        if (array.count < 1) {
            return;
        }
        _locationLabel.text = array.lastObject;
    }
    else {
        _locationLabel.text = globalData.locaitonAddress;
    }
}

-(void)setupAllChildViewController
{
    GYHENearLocationViewController *vc1 = [[GYHENearLocationViewController alloc]init];
    vc1.dataArray = _childsQu;
    [self addChildViewController:vc1];
    GYHECategoryViewController *vc2 = [[GYHECategoryViewController alloc]init];
    [self addChildViewController:vc2];
    GYHEListSortViewController *vc3 = [[GYHEListSortViewController alloc]init];
    [self addChildViewController:vc3];
    GYHEMoreMenusViewController *vc4 = [[GYHEMoreMenusViewController alloc]init];
    [self addChildViewController:vc4];
}

#pragma mark -- 动态菜单弹出视图
-(void)dynamicMenubtnClick:(UIButton*)btn
{
    GYDynamicMenuView *view = [[GYDynamicMenuView alloc] initWithBtn:btn];
    view.menuViewDelegate = self;
    [view show];
}

#pragma mark --GYDynamicMenuViewDelegate 动态菜单点击
-(void)imageIndex:(NSInteger)index
{
    kCheckLoginedToRoot
    GYHEDynamicMenuViewController *menuVC = [[GYHEDynamicMenuViewController alloc] init];
    menuVC.entranceType = GYEntranceVisitSurroundType;
    if (index == 0) {
        menuVC.dynamicMenuType = GYVisitRecordType;     //光顾纪录
    }else if (index == 1){
        menuVC.dynamicMenuType = GYFocuStoreType;       //关注店铺
    }else if (index == 2){
        menuVC.dynamicMenuType = GYCollectionGoodsType; //收藏商品
    }else{
        menuVC.dynamicMenuType = GYBrowseRecordsType;   //浏览记录
    }
    [self.navigationController pushViewController:menuVC animated:YES];
}

#pragma mark - YZPullDownMenuDataSource
-(NSInteger)numberOfColsInMenu:(GYPullDownMenu *)pullDownMenu
{
    return 4;
}

// 返回下拉菜单每列按钮
- (UIButton *)pullDownMenu:(GYPullDownMenu *)pullDownMenu buttonForColAtIndex:(NSInteger)index
{
    GYMenuButton *button = [GYMenuButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:_titles[index] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:@"gy_he_up_arrow"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"gy_he_down_arrow"] forState:UIControlStateSelected];
    return button;
}

// 返回下拉菜单每列对应的控制器
- (UIViewController *)pullDownMenu:(GYPullDownMenu *)pullDownMenu viewControllerForColAtIndex:(NSInteger)index
{
    return self.childViewControllers[index];
}

// 返回下拉菜单每列对应的高度
- (CGFloat)pullDownMenu:(GYPullDownMenu *)pullDownMenu heightForColAtIndex:(NSInteger)index
{
    // 第1列 高度
    if (index == 0) {
        return kScreenHeight - 64 - 40 - 49;
    }
    // 第2列 高度
    if (index == 1) {
        return kScreenHeight - 64 - 40 - 49;
    }
    // 第3列 高度
    if (index == 2) {
        return 180;
    }
    // 第4列 高度
    return 90;
}

#pragma mark --UItableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYHEVisitListCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEVisitListCellIdentifier];
    if (!cell) {
        cell = [[GYHEVisitListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHEVisitListCellIdentifier];
    }
    GYHEVisitListModel* model = self.dataArry[indexPath.row];
    [cell setModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择了=====%ld",(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GYHEShopDetailViewController* vc = [[GYHEShopDetailViewController alloc] init];
    if(self.dataArry.count > indexPath.row) {
        GYHEVisitListModel *mode = self.dataArry[indexPath.row];
        vc.vShopId = mode.vshopId;
    }
    //传商铺id
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --privateMark
-(void)creatHeaderRefresh
{
    __weak __typeof(self) wself = self;
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        __strong GYHEVisitListViewController *sself = wself;
        [sself headerRereshing];
    }];
    //单例 调用刷新图片
    self.tableView.mj_header = header;
}

-(void)creatFootReresh
{
    __weak __typeof(self) wself = self;
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        __strong GYHEVisitListViewController *sself = wself;
        [sself footerRereshing];
    }];
    self.tableView.mj_footer = footer;
}

//开始进入刷新状态
-(void)headerRereshing
{
    _isUpFresh = YES;
    _currentPageIndexStr = 1;
    //开始网络请求
    [self requestData];
}

-(void)footerRereshing
{
    _isUpFresh = NO;
    if (_currentPageIndexStr < _totalPage) {
        _currentPageIndexStr += 1;
      //开始网络请求
        [self requestData];
    }
}

-(void)requestData
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"1" forKey:@"currentPageIndex"];
    [dict setObject:@"10" forKey:@"pageSize"];
    if (globalData.selectedCityCoordinate) {
        [dict setObject:globalData.selectedCityCoordinate forKey:@"landmark"];
    } else {
        [dict setObject:[NSString stringWithFormat:@"%f,%f", globalData.locationCoordinate.latitude, globalData.locationCoordinate.longitude] forKey:@"landmark"];
    }
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kshopControllerFindVShopsUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return;
        }
        if (_isUpFresh) {
            [self.dataArry removeAllObjects];
        }
        if (_currentPageIndexStr > 1) {//请求数据源
            for (NSInteger i = 0; i < kEachPageSizeStr; i++) {
                
                for (NSInteger j = 0;j < [responseObject[@"data"] count]; j++) {
                    NSDictionary *dic = responseObject[@"data"][j];
                    GYHEVisitListModel *model = [[GYHEVisitListModel alloc] initWithDictionary:dic error:nil];
                    [self.dataArry addObject:model];
                }
            }
        }else{//数据源重新刷新
            
            for (NSInteger i = 0; i < kEachPageSizeStr; i++) {

                for (NSInteger j = 0;j < [responseObject[@"data"] count]; j++) {
                    NSDictionary *dic = responseObject[@"data"][j];
                    GYHEVisitListModel *model = [[GYHEVisitListModel alloc] initWithDictionary:dic error:nil];
                    [self.dataArry addObject:model];
                }
            }
        }
        [self.tableView reloadData];
        if (_currentPageIndexStr < _totalPage) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        else {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    [request commonParams:[GYUtils netWorkHECommonParams]];
    [request start];
}

-(void)initView
{
    [self.view addSubview:self.tableView];
    //初始化当前页数为1
    _currentPageIndexStr = 1;
    _totalPage = 2;
}

-(void)backClickBtn
{
    NSLog(@"返回按钮点击");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)mapClickBtn
{
    GYMapLocationViewController* newview = [[GYMapLocationViewController alloc] init];
    newview.delegate = self;
    newview.city = self.cityLabel.text;
    [self presentViewController:newview animated:YES completion:nil];
}

-(void)searchClickBtn
{
    NSLog(@"搜索点击");
    GYHEListSearchViewController* vcSearch = [[GYHEListSearchViewController alloc] init];
    vcSearch.searchType = GYHESearchTypeShops;
    vcSearch.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcSearch animated:YES];
}

-(void)setNav
{
    //1：中间地图背景
    UIView* view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, kScreenWidth - 100, 25);
    UIButton* btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSearch addTarget:self action:@selector(mapClickBtn) forControlEvents:UIControlEventTouchUpInside];
    btnSearch.frame = CGRectMake(90, 0, kScreenWidth - 190, 25);
    [view addSubview:btnSearch];
    //定位城市
    UIControl *cityControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    cityControl.backgroundColor = [UIColor clearColor];
    [cityControl addTarget:self action:@selector(cityLocation) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cityControl];
    self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 59, 25)];
    self.cityLabel.font = [UIFont systemFontOfSize:14];
    self.cityLabel.textColor = UIColorFromRGB(0xffffff);
    self.cityLabel.textAlignment = NSTextAlignmentLeft;
    self.cityLabel.text = globalData.selectedCityName;
    [cityControl addSubview:self.cityLabel];
    //向下箭头
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.cityLabel.right, 8, 11, 11)];
    arrowImageView.image = [UIImage imageNamed:@"gyhe_main_downArrow"];
    arrowImageView.backgroundColor   = [UIColor clearColor];
    [cityControl addSubview:arrowImageView];
    //3：地址地位图标image
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(btnSearch.frame), 4, 15, 18)];
    imgView.image = [UIImage imageNamed:@"gy_he_map_localtion"];
    [view addSubview:imgView];
    //3.1：地址地位图标image
    UIImageView* rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnSearch.frame) - 10,CGRectGetMaxY(btnSearch.frame) - 10, 10, 10)];
    rightIcon.image = [UIImage imageNamed:@"gy_he_address_end"];
    [view addSubview:rightIcon];
    //4：地图显示位置label
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) + 2, 5, kScreenWidth - 210, 17)];
    _locationLabel.textAlignment = NSTextAlignmentLeft;
    if (globalData.selectedCityCoordinate) {
        _locationLabel.text = globalData.selectedCityAddress;
    }
    else {
        _locationLabel.text = globalData.locaitonAddress;
    }
    _locationLabel.textColor = [UIColor whiteColor];
    _locationLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:_locationLabel];
    self.navigationItem.titleView = view;
    //5: 左侧返回图标image
    UIImageView* leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    leftImage.contentMode = UIViewContentModeScaleAspectFit;
    leftImage.image = [UIImage imageNamed:@"gy_he_back_arrow"];
    leftImage.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapSetting = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backClickBtn)];
    [leftImage addGestureRecognizer:tapSetting];
    UIBarButtonItem* leftBackBtn = [[UIBarButtonItem alloc] initWithCustomView:leftImage];
    self.navigationItem.leftBarButtonItem = leftBackBtn;
    //5 :右侧搜索图标
    UIImageView* searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 18, 18)];
    searchImage.contentMode = UIViewContentModeScaleAspectFit;
    searchImage.image = [UIImage imageNamed:@"gy_he_search_icon"];
    searchImage.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapRightMessage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchClickBtn)];
    [searchImage addGestureRecognizer:tapRightMessage];
    UIBarButtonItem* rightMessageBtn = [[UIBarButtonItem alloc] initWithCustomView:searchImage];
    self.navigationItem.rightBarButtonItem = rightMessageBtn;
}

-(void)cityLocation
{
    DDLogInfo(@"城市定位选择");
    //获取定位城市
    GYFullScreenPopView *view = [[GYFullScreenPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    view.delegate = self;
    [view show];
}

#pragma mark -- GYFullScreenPopDelegate
-(void)fullcityName:(NSString *)cityName nsAray:(NSMutableArray *)array
{
    self.cityLabel.text = cityName;
    [_childsQu removeAllObjects];
    _childsQu = array;
    [self setupAllChildViewController];
}

#pragma mark --lazy mark
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - 40 - 60) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 140;
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        [_tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEVisitListCell class]) bundle:nil] forCellReuseIdentifier:kGYHEVisitListCellIdentifier];
    }
    return _tableView;
}

-(NSMutableArray *)dataArry
{
    if (!_dataArry) {
        _dataArry = [NSMutableArray array];
    }
    return _dataArry;
}

-(NSArray *)childsQu
{
    if (!_childsQu) {
        _childsQu = [NSMutableArray array];
    }
    return _childsQu;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
