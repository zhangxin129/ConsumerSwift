//
//  GYHEEasyBuyMainViewController.m
//  HSConsumer
//
//  Created by admin on 16/9/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEEasyBuyMainViewController.h"
#import "GYHEEasyBuyClassTableViewCell.h"
#import "GYHEEasyBuySubclassCollectionViewCell.h"
#import "GYHEEasyBuyHeaderCollectionReusableView.h"
#import "GYSurroundGoodsMenuModel.h"
#import "GYSurroundGoodsListModel.h"
#import "GYDynamicMenuView.h"
#import "GYHEDynamicMenuViewController.h"
#import "GYHENavTitleView.h"
#import "GYHEListSearchViewController.h"
#import "GYFullScreenPopView.h"
#import "GYHEShoppingCartListViewController.h"
#import "GYHEEasyBuyListViewController.h"

#define kEasyBuyClassCell @"GYHEEasyBuyClassTableViewCell"
#define kSubclassCollectionViewCell @"GYHEEasyBuySubclassCollectionViewCell"
#define kHeaderCollectionView @"GYHEEasyBuyHeaderCollectionReusableView"

#define kTableViewWidth 77.0f

@interface GYHEEasyBuyMainViewController () <UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,GYDynamicMenuViewDelegate,GYHENavTitleViewDelegate,GYFullScreenPopDelegate>

@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) GYHENavTitleView *navTitleView;
@property (nonatomic, strong) NSMutableArray *menuArray;//左边类别菜单数组
@property (nonatomic, strong) NSMutableArray *listArray;//右边子类数组

@property (nonatomic, assign) NSInteger selectedIndex;//默认选中项
@property (nonatomic, assign) NSInteger oldSelectedIndex;//记录旧的选中项，目的是避免重复点击下的请求

@end

@implementation GYHEEasyBuyMainViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.oldSelectedIndex = 9999;//先将其设为一个和第一次选中不同的数，使得第一次能够请求数据
    [self setNavigationBar];
    [self.view addSubview:self.tabView];
    [self.view addSubview:self.collectionView];
    [self getMainClassInfoNetworkRequest];
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kScreenWidth - 40, (kScreenHeight - 64 - 49) / 2, 40, 40);
    [btn setImage:[UIImage imageNamed:@"gyhe_dynamic_menu"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dynamicMenubtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYHEEasyBuyClassTableViewCell *classCell = [tableView dequeueReusableCellWithIdentifier:kEasyBuyClassCell forIndexPath:indexPath];
    
    classCell.selectionStyle = UITableViewCellSelectionStyleNone;
    GYSurroundGoodsMenuModel *menuModel = self.menuArray[indexPath.row];
    classCell.titleLabel.text = menuModel.categoryName;
    if (self.oldSelectedIndex == indexPath.row) {
        [classCell updateStateWithIndex:YES];
    } else {
        [classCell updateStateWithIndex:NO];
    }
    return classCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.oldSelectedIndex) {
        return;
    }
    GYHEEasyBuyClassTableViewCell *classCell = [tableView cellForRowAtIndexPath:indexPath];

    [classCell updateStateWithIndex:YES];
    GYSurroundGoodsMenuModel *menuModel = self.menuArray[indexPath.row];
    [self getGoodsListDataNetworkRequest:menuModel];
    self.oldSelectedIndex = indexPath.row;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    GYHEEasyBuyClassTableViewCell *classCell = [tableView cellForRowAtIndexPath:indexPath];
    [classCell updateStateWithIndex:NO];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GYHEEasyBuySubclassCollectionViewCell *subclassCell = [collectionView dequeueReusableCellWithReuseIdentifier:kSubclassCollectionViewCell forIndexPath:indexPath];
    GYSurroundGoodsListModel *listModel = self.listArray[indexPath.row];
    [subclassCell.pictureImageView setImageWithURL:[NSURL URLWithString:listModel.picAddr] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"]];
    subclassCell.titleLabel.text = listModel.categoryName;
    return subclassCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    GYHEEasyBuyHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderCollectionView forIndexPath:indexPath];
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GYHEEasyBuyListViewController *vc = [[GYHEEasyBuyListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- GYHENavTitleViewDelegate
//搜索
-(void)search
{
    GYHEListSearchViewController* vcSearch = [[GYHEListSearchViewController alloc] init];
    vcSearch.searchType = GYHESearchTypeGoods;
    vcSearch.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcSearch animated:YES];
}

//城市选择
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

#pragma mark - Private Methods
- (void)setNavigationBar {
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 32, 32);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"gyhs_orange_shopping_car"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(shoppingCartButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    //往右偏移10
    negativeSpacer.width = -10;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btnRight, nil];

    
    self.navigationItem.titleView = self.navTitleView;
    
}

- (void)shoppingCartButtonClick {
    GYHEShoppingCartListViewController *vc = [[GYHEShoppingCartListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//请求到左边类别对应的分类的数据源
- (void)getMainClassInfoNetworkRequest {
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:GetGoodsMainInterfaceUrl parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            [GYUtils parseNetWork:error resultBlock:nil];
            return;
        }
        self.menuArray = [GYSurroundGoodsMenuModel modelArrayWithResponseObject:responseObject error:&error].mutableCopy;
        [self.tabView reloadData];
        if (self.menuArray.count > 0) {
            //默认选中第一行
            self.selectedIndex = 0;
            [self.tabView selectRowAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]animated:YES scrollPosition:UITableViewScrollPositionTop];
            if ([self.tabView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
            {
                [self.tabView.delegate tableView:self.tabView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]];
            }
        }
    }];
    request.cacheTimeInSeconds = 3600;
    [request commonParams:[GYUtils netWorkHECommonParams]];
    [request start];
}

//请求到右边类别对应的分类的数据源
- (void)getGoodsListDataNetworkRequest:(GYSurroundGoodsMenuModel*)menuModel
{
    [self.listArray removeAllObjects];
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
    [mDict setValue:menuModel.id forKey:@"categoryId"];
    
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:GetChildCategoryByParentIdUrl parameters:mDict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            [GYUtils parseNetWork:error resultBlock:nil];
            return;
        }
        self.listArray = [GYSurroundGoodsListModel modelArrayWithResponseObject:responseObject error:&error].mutableCopy;
        [self.collectionView reloadData];
        
    }];
    request.cacheTimeInSeconds = 3600;
    [request commonParams:[GYUtils netWorkHECommonParams]];
    [request start];
}

#pragma mark - Lazy Load
- (UITableView *)tabView {
    if (!_tabView) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kTableViewWidth, kScreenHeight - 49 - 64) style:UITableViewStylePlain];
        _tabView.rowHeight = 74;
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.backgroundColor = kCorlorFromRGBA(238, 238, 238, 1);
        _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabView.showsVerticalScrollIndicator = NO;
        _tabView.directionalLockEnabled = YES;
        //_tabView.bounces = NO;
        _tabView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEEasyBuyClassTableViewCell class]) bundle:nil] forCellReuseIdentifier:kEasyBuyClassCell];
    }
    return _tabView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((kScreenWidth - kTableViewWidth - 20) / 4, (kScreenWidth - kTableViewWidth - 20) / 4 * 15 / 13);
        //横向间距
        flowLayout.minimumLineSpacing = 0;
        //纵向间距
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
        flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth - kTableViewWidth, 32);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kTableViewWidth, 0, kScreenWidth - kTableViewWidth, kScreenHeight - 49 -64) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        //_collectionView.bounces = NO;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEEasyBuySubclassCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kSubclassCollectionViewCell];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEEasyBuyHeaderCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderCollectionView];
        
    }
    return _collectionView;
}

- (NSMutableArray *)menuArray {
    if (!_menuArray) {
        _menuArray = [[NSMutableArray alloc] init];
    }
    return _menuArray;
}

- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc] init];
    }
    return _listArray;
}

-(GYHENavTitleView*)navTitleView
{
    if (!_navTitleView) {
        _navTitleView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHENavTitleView class]) owner:self options:nil].lastObject;
        _navTitleView.frame = CGRectMake(0, 0, kScreenWidth, 48);
        _navTitleView.delegate = self;
    }
    return _navTitleView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
