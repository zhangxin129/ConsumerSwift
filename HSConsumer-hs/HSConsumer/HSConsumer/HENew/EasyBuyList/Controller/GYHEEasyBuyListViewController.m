//
//  GYHEEasyBuyListViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEEasyBuyListViewController.h"
#import "GYPullDownMenu.h"
#import "GYMenuButton.h"
#import "GYHEClassificationViewController.h"
#import "GYHEPaymentViewController.h"
#import "GYHESellerServiceViewController.h"
#import "GYHEEasyBuyListCell.h"
#import "GYHEEasyBuyListModel.h"
#import "GYDynamicMenuView.h"
#import "GYHEShoppingCartListViewController.h"
#import "GYHENavTitleView.h"
#import "GYFullScreenPopView.h"
#import "GYHEListSearchViewController.h"
#import "GYHEDynamicMenuViewController.h"

#define kGYHEEasyBuyListCellIdentifier @"GYHEEasyBuyListCell"
#define kEachPageSizeStr 2
@interface GYHEEasyBuyListViewController ()<UITableViewDataSource,UITableViewDelegate,GYPullDownMenuDataSource,GYDynamicMenuViewDelegate,GYHENavTitleViewDelegate,GYFullScreenPopDelegate>
@property(nonatomic,strong)NSArray *titleArray;//头部数组
@property (nonatomic,strong)UITableView *listTableView;
@property(nonatomic, strong)NSMutableArray *dataArry;//数据源
@property (nonatomic, assign) BOOL isUpFresh;//是否刷新
@property (nonatomic, assign) int totalPage;//总共页数
@property (nonatomic, assign) int currentPageIndexStr;//当前页数
@property (nonatomic,strong)GYHENavTitleView *navTitleView;
@end

@implementation GYHEEasyBuyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self initUI];
    GYPullDownMenu *menu = [[GYPullDownMenu alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, 40)];
    [self.view addSubview:menu];
    menu.dataSource = self;
    self.titleArray = @[@"分类",@"智能排序",@"卖家服务"];
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
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [super viewWillAppear:animated];
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
    menuVC.entranceType = GYEntranceEasyBuyType;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)setNav
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //左侧返回图标
    UIImageView* leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    leftImage.contentMode = UIViewContentModeScaleAspectFit;
    leftImage.image = [UIImage imageNamed:@"gyhe_orange_right"];
    leftImage.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapSetting = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backClickBtn)];
    [leftImage addGestureRecognizer:tapSetting];
    UIBarButtonItem* leftBackBtn = [[UIBarButtonItem alloc] initWithCustomView:leftImage];
    self.navigationItem.leftBarButtonItem = leftBackBtn;
    //右侧购物车图标
    UIImageView* shoppingImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    shoppingImage.contentMode = UIViewContentModeScaleAspectFit;
    shoppingImage.image = [UIImage imageNamed:@"gyhs_orange_shopping_car"];
    shoppingImage.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapRightMessage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shoppingClickBtn)];
    [shoppingImage addGestureRecognizer:tapRightMessage];
    UIBarButtonItem* rightMessageBtn = [[UIBarButtonItem alloc] initWithCustomView:shoppingImage];
    self.navigationItem.rightBarButtonItem = rightMessageBtn;
    self.navigationItem.titleView = self.navTitleView;
}
#pragma mark -- GYHENavTitleViewDelegate搜索
-(void)search
{
    GYHEListSearchViewController* vcSearch = [[GYHEListSearchViewController alloc] init];
    vcSearch.searchType = GYHESearchTypeGoods;
    vcSearch.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcSearch animated:YES];
}
#pragma mark -- GYHENavTitleViewDelegate城市选择
-(void)cityBtn
{
    
    GYFullScreenPopView *view = [[GYFullScreenPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    view.delegate = self;
    [view show];
}
#pragma mark -- GYFullScreenPopDelegate
-(void)fullcityName:(NSString *)cityName
{
    [self.navTitleView.cityBtn setTitle:cityName forState:UIControlStateNormal];
}
-(void)initUI
{
    [self.view addSubview:self.listTableView];
    //初始化当前页数为1
    _currentPageIndexStr = 1;
    _totalPage = 3;
}
#pragma mark -- 返回
-(void)backClickBtn
{
    NSLog(@"返回按钮点击");
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 购物车
-(void)shoppingClickBtn
{
    GYHEShoppingCartListViewController *vc = [[GYHEShoppingCartListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark --privateMark
-(void)creatHeaderRefresh
{
    WS(weakSelf);
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        __strong GYHEEasyBuyListViewController *sself = weakSelf;
        [sself headerRereshing];
    }];
    //单例 调用刷新图片
    self.listTableView.mj_header = header;
    
}
-(void)creatFootReresh
{
    WS(weakSelf);
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        __strong GYHEEasyBuyListViewController *sself = weakSelf;
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
    NSLog(@"请求网络数据");
    if (_isUpFresh) {
        [self.dataArry removeAllObjects];
    }
    if (_currentPageIndexStr > 1) {//请求数据源
        for (NSInteger i = 0; i < kEachPageSizeStr; i++) {
            GYHEEasyBuyListModel *model = [[GYHEEasyBuyListModel alloc] init];
            model.title = @"欧洲站秋装欧货潮套装裙两件套春秋连衣裙";
            model.price = @"138.80";
            model.pv = @"13.80";
            model.companyName = @"深圳市福田区爽翻天美范天服饰服装有限公司";
            model.city = @"深圳";
            [self.dataArry addObject:model];
        }
    }else{//数据源重新刷新
        for (NSInteger i = 0; i < kEachPageSizeStr; i++) {
            GYHEEasyBuyListModel *model = [[GYHEEasyBuyListModel alloc] init];
            model.title = @"韩版潮套装裙两件套春秋连衣裙";
            model.price = @"125.23";
            model.pv = @"12.50";
            model.companyName = @"杭州市西湖区爽翻天美范天服饰服装有限公司";
            model.city = @"杭州";
            [self.dataArry addObject:model];
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
    GYHEEasyBuyListCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEEasyBuyListCellIdentifier];
    if (!cell) {
        cell = [[GYHEEasyBuyListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHEEasyBuyListCellIdentifier];
    }
    [cell setModel:self.dataArry[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择了=====%ld",(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        [_listTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEEasyBuyListCell class]) bundle:nil] forCellReuseIdentifier:kGYHEEasyBuyListCellIdentifier];
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
-(GYHENavTitleView*)navTitleView
{
    if (!_navTitleView) {
        _navTitleView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHENavTitleView class]) owner:self options:nil].lastObject;
        _navTitleView.delegate = self;
    }
    return _navTitleView;
}
@end
