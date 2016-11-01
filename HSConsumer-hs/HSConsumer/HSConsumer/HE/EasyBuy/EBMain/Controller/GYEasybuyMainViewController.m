//
//  GYEasybuyMainViewController.m
//  HSConsumer
//
//  Created by zhangqy on 15/11/9.
//  Copyright © 2015年 GYKJ. All rights reserved.
//

#import "GYEasybuyMainViewController.h"
#import "GYEasybuyMainModel.h"
#import "GYEasybuyHomeCollectionViewCell.h"
#import "GYNetRequest.h"
#import "JSONModel+ResponseObject.h"
#import "MJRefresh.h"
#import "GYHESCShoppingCartViewController.h"
#import "GYEPMyHEViewController.h"
#import "GYHSLoginViewController.h"

#import "GYEasybuySearchMainController.h"
#import "GYEasybuyGoodsListViewController.h"
#import "GYHSLoginManager.h"
#import "GYHEUtil.h"

#define GYEasybuyHomeCollectionViewCellReuseId @"GYEasybuyHomeCollectionViewCellReuseId"

@interface GYEasybuyMainViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GYNetRequestDelegate>
@property (strong, nonatomic) UICollectionView* collectionView;
@property (strong, nonatomic) NSMutableArray* dataSource;
@property (strong, nonatomic) UIButton* toCartBtn;
@property (strong, nonatomic) UIButton* myHEBtn;

@end

@implementation GYEasybuyMainViewController

#pragma mark - 系统方法
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    globalData.isOnNet = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"";
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    [self.view addSubview:self.collectionView];
    [self loadData];
}

#pragma mark - collectionView代理

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    GYEasybuyHomeCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:GYEasybuyHomeCollectionViewCellReuseId forIndexPath:indexPath];
    if (self.dataSource.count > indexPath.item) {
        cell.model = self.dataSource[indexPath.item];
    }
    return cell;
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if(self.dataSource.count > indexPath.item) {
        GYEasybuyMainModel* model = self.dataSource[indexPath.item];
        GYEasybuyGoodsListViewController* vc = [[GYEasybuyGoodsListViewController alloc] init];
        vc.categoryId = model.id;
        vc.categoryName = model.title;
        vc.title = model.title;
        vc.index = indexPath.row;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    [self getMainWithDict:responseObject];
}

- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    [_collectionView.mj_header endRefreshing];

    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}

#pragma mark - 点击事件
//进入我的互商
- (void)gotoMyHushang:(UIButton*)btn
{

    kCheckLogined

    GYEPMyHEViewController* vcCart = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyHEViewController class]));
    vcCart.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcCart animated:YES];
}

//购物车
- (void)gotoCart:(UIButton*)btn
{
    kCheckLogined

    UIViewController* heVC = [[GYHESCShoppingCartViewController alloc] init];
    heVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:heVC animated:YES];
}

//搜索
- (void)search:(UIButton*)btn
{
    GYEasybuySearchMainController* vc = [[GYEasybuySearchMainController alloc] init];
    vc.searchType = kGoods;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 自定义方法
- (void)setNav
{
    UIButton* myHSButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect Hsframe = CGRectMake(0, 0, 23, 26);
    myHSButton.frame = Hsframe;
    [myHSButton setBackgroundImage:kLoadPng(@"gycommon_nav_myHE") forState:UIControlStateNormal];
    [myHSButton setTitle:@"" forState:UIControlStateNormal];
    [myHSButton addTarget:self action:@selector(gotoMyHushang:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* btnSetting1 = [[UIBarButtonItem alloc] initWithCustomView:myHSButton];

    UIImage* image = kLoadPng(@"gycommon_nav_cart");
    CGRect backframe = CGRectMake(0, 0, 27, 27);
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = backframe;
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(gotoCart:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* btnSetting2 = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItems = @[ btnSetting2, btnSetting1 ];

    UIView* view = [[UIView alloc] init];
    view.frame = CGRectMake(15, 25, kScreenWidth * 235 / 375, 35);
    view.backgroundColor = kCorlorFromHexcode(0xDC3820);
    UIButton* btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSearch addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    btnSearch.frame = CGRectMake(0, 0, kScreenWidth * 235 / 375, 35);
    [view addSubview:btnSearch];
    
    
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(btnSearch.frame) + CGRectGetWidth(btnSearch.frame)/2 - 75, 10, 15, 15)];
    imgView.image = [UIImage imageNamed:@"gycommon_nav_search.png"];
    [view addSubview:imgView];

    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) + 15, 10, 150, 18)];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.text = kLocalized(@"GYHE_Easybuy_inputGoodShop");
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:15];

    [view addSubview:lab];

    UIBarButtonItem* btnItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = btnItem;
}
- (void)loadData
{

    NSDictionary* allParas = @{ @"key" : @"" };

    WS(weakSelf);
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:weakSelf URLString:EasyBuyGetHomePageUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
        request.cacheTimeInSeconds = 3600;

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [request start];
        });
    }];
    _collectionView.mj_header = header;
    [_collectionView.mj_header beginRefreshing];
}
//数据导入数据源
- (void)getMainWithDict:(NSDictionary*)responseObject
{
    [_collectionView.mj_header endRefreshing];
    if (responseObject) {
        NSArray* arr = [GYEasybuyMainModel modelArrayWithResponseObject:responseObject error:nil];
        //数据导入数组
        if (arr) {
            self.dataSource = arr.mutableCopy;
            [self.collectionView reloadData];
        }
    }
}

#pragma mark - 懒加载
- (UICollectionView*)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) collectionViewLayout:layout];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;

        layout.itemSize = CGSizeMake(kScreenWidth / 2, 100);
        ;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(16, 0, 0, 0);
        _collectionView.backgroundColor = kDefaultVCBackgroundColor;
        _collectionView.opaque = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYEasybuyHomeCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:GYEasybuyHomeCollectionViewCellReuseId];
    }
    return _collectionView;
}

- (NSMutableArray*)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
