//
//  GYHETakeawayListViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHETakeawayListViewController.h"
#import "GYPullDownMenu.h"
#import "GYMenuButton.h"
#import "GYHEVisitListCell.h"
#import "GYHEVisitListModel.h"
#import "GYHEClassificationViewController.h"
#import "GYHEPaymentViewController.h"
#import "GYHESellerServiceViewController.h"
#import "GYDynamicMenuView.h"
#import "GYHEListSearchViewController.h"
#import "GYHEAroundLocationChooseController.h"
#import "GYHEDynamicMenuViewController.h"
#import "GYHEShopDetailViewController.h"
#import "GYHEMapSelectAddressViewController.h"


#define kGYHETakeawayListCellIdentifier @"GYHEVisitListCell"

#define kEachPageSizeStr 2
@interface GYHETakeawayListViewController ()<UITableViewDelegate,UITableViewDataSource,GYPullDownMenuDataSource,GYDynamicMenuViewDelegate,GYAroundLocationChooseControllerDelegate>
@property(nonatomic,strong)NSArray *titleArray;//头部数组
@property (nonatomic,strong)UITableView *listTableView;

@property(nonatomic, strong)NSMutableArray *dataArry;//数据源

@property (nonatomic, assign) BOOL isUpFresh;//是否刷新

@property (nonatomic, assign) int totalPage;//总共页数

@property (nonatomic, assign) int currentPageIndexStr;//当前页数

@property (nonatomic,strong)UILabel *locationLabel;
@end

@implementation GYHETakeawayListViewController
#pragma mark -- The life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xfb7d00);
    [self setNav];
    [self initUI];
    GYPullDownMenu *menu = [[GYPullDownMenu alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, 40)];
    [self.view addSubview:menu];
    menu.dataSource = self;
    self.titleArray = @[@"分类",@"支付方式",@"卖家服务"];
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
    if (globalData.selectedCityCoordinate) {
        _locationLabel.text = globalData.selectedCityAddress;
    }
    else {
        _locationLabel.text = globalData.locaitonAddress;
    }
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
#pragma mark -- The custom method
-(void)setNav
{
    //1：中间地图背景
    UIView* view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, kScreenWidth - 120, 25);
    UIButton* btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSearch addTarget:self action:@selector(mapClickBtn) forControlEvents:UIControlEventTouchUpInside];
    btnSearch.frame = CGRectMake(0, 0, kScreenWidth - 120, 25);
    [view addSubview:btnSearch];
    //2：地址地位图标image
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(btnSearch.frame), 4, 15, 18)];
    imgView.image = [UIImage imageNamed:@"gy_he_map_localtion"];
    [view addSubview:imgView];
    //2.1：地址地位图标image
    UIImageView* rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnSearch.frame) - 10,CGRectGetMaxY(btnSearch.frame) - 10, 10, 10)];
    rightIcon.image = [UIImage imageNamed:@"gy_he_address_end"];
    [view addSubview:rightIcon];
    //3：地图显示位置label
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) + 2, 5, kScreenWidth - 140, 17)];
    _locationLabel.textAlignment = NSTextAlignmentCenter;
    if (globalData.selectedCityCoordinate) {
        _locationLabel.text = globalData.selectedCityAddress;
        //[self initParams];
    }
    else {
        _locationLabel.text = globalData.locaitonAddress;
    }
    _locationLabel.textColor = [UIColor whiteColor];
    _locationLabel.font = [UIFont systemFontOfSize:12];
    [view addSubview:_locationLabel];
    self.navigationItem.titleView = view;
    //4: 左侧返回图标image
    UIImageView* leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    leftImage.contentMode = UIViewContentModeScaleAspectFit;
    leftImage.image = [UIImage imageNamed:@"gy_he_back_arrow"];
    leftImage.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapSetting = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backClickBtn)];
    [leftImage addGestureRecognizer:tapSetting];
    UIBarButtonItem* leftBackBtn = [[UIBarButtonItem alloc] initWithCustomView:leftImage];
    self.navigationItem.leftBarButtonItem = leftBackBtn;
    //5 :右侧搜索图标
    UIImageView* searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    searchImage.contentMode = UIViewContentModeScaleAspectFit;
    searchImage.image = [UIImage imageNamed:@"gy_he_search_icon"];
    searchImage.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapRightMessage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchClickBtn)];
    [searchImage addGestureRecognizer:tapRightMessage];
    UIBarButtonItem* rightMessageBtn = [[UIBarButtonItem alloc] initWithCustomView:searchImage];
    self.navigationItem.rightBarButtonItem = rightMessageBtn;
}

-(void)initUI
{
    [self.view addSubview:self.listTableView];
    //初始化当前页数为1
    _currentPageIndexStr = 1;
    _totalPage = 3;
}
#pragma mark -- 加载菜单视图控制器
-(void)setupAllChildViewController
{
    GYHEClassificationViewController *OneVC = [[GYHEClassificationViewController alloc] init];
    [self addChildViewController:OneVC];
    GYHEPaymentViewController *TwoVC = [[GYHEPaymentViewController alloc] init];
    [self addChildViewController:TwoVC];
    GYHESellerServiceViewController *ThreeVC = [[GYHESellerServiceViewController alloc] init];
    [self addChildViewController:ThreeVC];
}
-(void)backClickBtn
{
    NSLog(@"返回按钮点击");
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 点击地图
-(void)mapClickBtn
{
    NSLog(@"点击地图按钮");
    GYHEMapSelectAddressViewController *vc = [[GYHEMapSelectAddressViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 搜索
-(void)searchClickBtn
{
    NSLog(@"搜索点击");
    GYHEListSearchViewController* vcSearch = [[GYHEListSearchViewController alloc] init];
    vcSearch.searchType = GYHESearchTypeShops;
    vcSearch.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcSearch animated:YES];
}
#pragma mark --privateMark
-(void)creatHeaderRefresh
{
    WS(weakSelf);
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        __strong GYHETakeawayListViewController *sself = weakSelf;
        [sself headerRereshing];
    }];
    //单例 调用刷新图片
    self.listTableView.mj_header = header;
}

-(void)creatFootReresh
{
    WS(weakSelf);
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        __strong GYHETakeawayListViewController *sself = weakSelf;
        [sself footerRereshing];
    }];
    self.listTableView.mj_footer = footer;
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
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GYHEVisitListModel *model = [[GYHEVisitListModel alloc] initWithDictionary:dic error:nil];
                    [self.dataArry addObject:model];
                }
            }
        }else{//数据源重新刷新
            
            for (NSInteger i = 0; i < kEachPageSizeStr; i++) {
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GYHEVisitListModel *model = [[GYHEVisitListModel alloc] initWithDictionary:dic error:nil];
                    [self.dataArry addObject:model];
                }

            }
        }
        [self.listTableView reloadData];
        if (_currentPageIndexStr < _totalPage) {
            [self.listTableView.mj_header endRefreshing];
            [self.listTableView.mj_footer endRefreshing];
        }
        else {
            [self.listTableView.mj_header endRefreshing];
            [self.listTableView.mj_footer endRefreshing];
            [self.listTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    [request commonParams:[GYUtils netWorkHECommonParams]];
    [request start];
}

#pragma mark - YZPullDownMenuDataSource

-(NSInteger)numberOfColsInMenu:(GYPullDownMenu *)pullDownMenu
{
    return 3;
}

// 返回下拉菜单每列按钮
- (UIButton *)pullDownMenu:(GYPullDownMenu *)pullDownMenu buttonForColAtIndex:(NSInteger)index
{
    GYMenuButton *button = [GYMenuButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:self.titleArray[index] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:25 /255.0 green:143/255.0 blue:238/255.0 alpha:1] forState:UIControlStateSelected];
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
    return 60;
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
    GYHEVisitListCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHETakeawayListCellIdentifier];
    if (!cell) {
        cell = [[GYHEVisitListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHETakeawayListCellIdentifier];
    }
    [cell setModel:self.dataArry[indexPath.row]];
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

#pragma mark --lazy mark
-(UITableView *)listTableView
{
    if (!_listTableView) {
        _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - 40 - 60) style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.rowHeight = 140;
        _listTableView.backgroundColor = kDefaultVCBackgroundColor;
        [_listTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEVisitListCell class]) bundle:nil] forCellReuseIdentifier:kGYHETakeawayListCellIdentifier];
    }
    return _listTableView;
}

-(NSMutableArray *)dataArry
{
    if (!_dataArry) {
        _dataArry = [NSMutableArray array];
    }
    return _dataArry;
}

@end
