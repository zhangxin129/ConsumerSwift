//
//  GYSurroundGoodsViewController.m
//  GYHSConsumer_SurroundVisit
//
//  Created by apple on 16/3/17.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSurroundGoodsViewController.h"
#import "JSONModel+ResponseObject.h"
#import "GYSurroundGoodsMenuModel.h"
#import "GYSurroundGoodsListModel.h"
#import "GYSurroundGoodsListCell.h"
#import "GYSurroundGoodsMenuCell.h"
#import "GYSurroundGoodsListViewController.h"
#import "GYAroundGoodsListController.h"
#import "SearchGoodModel.h"
#import "GYHEUtil.h"

#define kGYSurroundGoodsListCell @"GYSurroundGoodsListCell"
#define kGYSurroundGoodsMenuCell @"GYSurroundGoodsMenuCell"

@interface GYSurroundGoodsViewController () <GYNetRequestDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate>

//左边类别数据源
@property (nonatomic, strong) NSMutableArray* menuData;
//右边对应类别分类的数据源
@property (nonatomic, strong) NSMutableArray* listData;
@property (nonatomic, strong) UITableView* tabView;
@property (nonatomic, strong) UICollectionView* collectionView;
// 记录选择的菜单
@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation GYSurroundGoodsViewController

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self tabView];
    [self collectionView];
    [self getGoodsMainInterfaceData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 数据请求
//请求商品主分类
- (void)getGoodsMainInterfaceData
{
    [self.menuData removeAllObjects];
    GYNetRequest* getGoodsMainRequest = [[GYNetRequest alloc] initWithDelegate:self URLString:GetGoodsMainInterfaceUrl parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    getGoodsMainRequest.tag = kGetGoodsMainTag;
    getGoodsMainRequest.cacheTimeInSeconds = 3600;
    [getGoodsMainRequest start];
}

//请求每种主分类商品下的子分类
- (void)getListDataWith:(GYSurroundGoodsMenuModel*)menuModel
{
    [self.listData removeAllObjects];
    NSDictionary* dict = @{ @"categoryId" : menuModel.id };
    GYNetRequest* getGoodsgetListRequest = [[GYNetRequest alloc] initWithDelegate:self URLString:GetChildCategoryByParentIdUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    getGoodsgetListRequest.tag = kGetGoodsgetListTag;
    getGoodsgetListRequest.cacheTimeInSeconds = 3600;
    [getGoodsgetListRequest start];
}

#pragma mark - GYNetRequestDelegate网络请求的代理

- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    if (netRequest.tag == kGetGoodsMainTag) {
        [self setGoodsMainData:responseObject];
    }
    else if (netRequest.tag == kGetGoodsgetListTag) {
        [self setGoodsListData:responseObject];
    }
}

- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuData.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYSurroundGoodsMenuCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYSurroundGoodsMenuCell];
    if(self.menuData.count > indexPath.row) {
        GYSurroundGoodsMenuModel* mod = self.menuData[indexPath.row];
        [cell refreshWithModel:mod];
    }
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (self.selectedIndex != indexPath.row && self.menuData.count > _selectedIndex) {
        GYSurroundGoodsMenuModel* mod = self.menuData[_selectedIndex];
        mod.isSelected = NO;
        if(self.menuData.count > indexPath.row) {
            GYSurroundGoodsMenuModel* model = self.menuData[indexPath.row];
            model.isSelected = YES;
        }
        
        [self.tabView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:indexPath.row inSection:0], [NSIndexPath indexPathForRow:_selectedIndex inSection:0] ] withRowAnimation:UITableViewRowAnimationFade];

        self.selectedIndex = indexPath.row;
        [self getListDataWith:self.menuData[self.selectedIndex]];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    GYSurroundGoodsListCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGYSurroundGoodsListCell forIndexPath:indexPath];
    if(self.listData.count > indexPath.row) {
        GYSurroundGoodsListModel* mod = self.listData[indexPath.row];
        [cell reloadData:mod];
    }
    return cell;
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    if (self.listData.count > indexPath.row) {
//        GYSurroundGoodsListViewController *vc = [[GYSurroundGoodsListViewController alloc] init];
//        if(self.listData.count > indexPath.row) {
//            vc.categoryName = [self.listData[indexPath.row] categoryName];
//            vc.categoryId = [self.listData[indexPath.row] id];
//        }
//        
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];

        GYAroundGoodsListController* vcGoodList = [[GYAroundGoodsListController alloc] init];
        SearchGoodModel* model = [[SearchGoodModel alloc] init];
        if(self.listData.count > indexPath.row) {
            model.name = [self.listData[indexPath.row] categoryName];
            model.uid = [self.listData[indexPath.row] id];
            vcGoodList.title = model.name;
            vcGoodList.modelCommins = model;
            NSUserDefaults* userDefaultGoods = [NSUserDefaults standardUserDefaults];
            [userDefaultGoods setObject:model.name forKey:@"surroundingGoodsTitle"];
            [userDefaultGoods synchronize];
        }
        vcGoodList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vcGoodList animated:YES];
    }
}

#pragma mark - 自定义方法
//请求到左边类别的数据源
- (void)setGoodsMainData:(NSDictionary*)responseObject
{
    NSError* error = nil;
    
    NSMutableArray* array = [GYSurroundGoodsMenuModel modelArrayWithResponseObject:responseObject error:&error].mutableCopy;
    if (array) {
        GYSurroundGoodsMenuModel* mod = array.firstObject;
        mod.isSelected = YES;
        self.menuData = array;
    }
    if (self.menuData.count > 0) {
        self.selectedIndex = 0;
        [self getListDataWith:self.menuData[0]];
    }
    [self.tabView reloadData];
}

//请求到右边类别对应的分类的数据源
- (void)setGoodsListData:(NSDictionary*)responseObject
{
    
    NSError* error = nil;
    NSMutableArray* array = [GYSurroundGoodsListModel modelArrayWithResponseObject:responseObject error:&error].mutableCopy;
    self.listData = array;
    [self.collectionView reloadData];
}

#pragma mark - 懒加载
- (NSMutableArray*)listData
{
    if (!_listData) {
        _listData = [NSMutableArray array];
    }
    return _listData;
}

- (NSMutableArray*)menuData
{
    if (!_menuData) {
        _menuData = [NSMutableArray array];
    }
    return _menuData;
}

- (UITableView*)tabView
{
    if (!_tabView) {
        CGFloat height = kScreenHeight - 49 - 64;
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 108, height) style:UITableViewStylePlain];
        _tabView.backgroundColor = [UIColor whiteColor];
        _tabView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tabView.rowHeight = 50;
        _tabView.dataSource = self;
        _tabView.delegate = self;
        _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tabView];

        [_tabView registerClass:[GYSurroundGoodsMenuCell class] forCellReuseIdentifier:kGYSurroundGoodsMenuCell];
    }
    return _tabView;
}

- (UICollectionView*)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tabView.frame), self.tabView.frame.origin.y, kScreenWidth - self.tabView.frame.size.width, self.tabView.frame.size.height) collectionViewLayout:layout];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;

        CGFloat goodWidth = (_collectionView.frame.size.width - 15 * (3 + 1)) / 3;
        CGFloat goodHeight = goodWidth * 1.6;
        layout.itemSize = CGSizeMake(goodWidth, goodHeight);
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 15;
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 0, 15);
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.opaque = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYSurroundGoodsListCell class]) bundle:nil] forCellWithReuseIdentifier:kGYSurroundGoodsListCell];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

@end
