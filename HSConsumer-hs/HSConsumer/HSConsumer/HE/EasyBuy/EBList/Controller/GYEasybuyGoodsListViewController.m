//
//  GYEasybuyGoodsListViewController.m
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEasybuyGoodsListViewController.h"
#import "GYEPMyHEViewController.h"
#import "GYHSLoginViewController.h"
#import "GYHSLoginManager.h"
#import "GYEasybuyTopicListCollectionViewCell.h"
#import "GYEasybuyTopicListModel.h"
#import "GYEasybuyGoodsInfoViewController.h"
#import "GYNetRequest.h"
#import "JSONModel+ResponseObject.h"
#import "MJRefresh.h"
#import "UIView+CustomBorder.h"
#import "GYEasybuyColumnClassModel.h"
#import "GYEasybuyOneDownView.h"
#import "GYEasybuyTwoDownView.h"
#import "GYEasybuyServiceFooterView.h"
#import "Masonry.h"
#import "GYHEUtil.h"


#define GYEasybuyTopicListCollectionViewCellReuseId @"GYEasybuyTopicListCollectionViewCellReuseId"

@interface GYEasybuyGoodsListViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GYNetRequestDelegate, GYEasybuyTwoDownViewDelegate, GYEasybuyOneDownViewDelegate>

@property (strong, nonatomic) UICollectionView* collectionView;
@property (strong, nonatomic) NSMutableArray* dataSource; //商品的数据源
@property (strong, nonatomic) NSMutableDictionary* params;

//导航栏下的排序视图及Lab
@property (weak, nonatomic) IBOutlet UIView* addBottomView;
@property (weak, nonatomic) IBOutlet UILabel* categoryLabel;
@property (weak, nonatomic) IBOutlet UIButton* categoryBtn;
@property (weak, nonatomic) IBOutlet UIButton* categoryUpDownBtn;

@property (weak, nonatomic) IBOutlet UILabel* sortNameLabel;
@property (weak, nonatomic) IBOutlet UIButton* sortNameBtn;
@property (weak, nonatomic) IBOutlet UIButton* sortNameUpDownBtn;
@property (weak, nonatomic) IBOutlet UILabel* sortTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton* sortTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton* sortTypeUpDownBtn;

//URl参数
@property (nonatomic, copy) NSString* hasCoupon; //抵扣卷
@property (nonatomic, copy) NSString* sortType; //排序方式
@property (nonatomic, copy) NSString* specialService; //服务方式
@property (nonatomic, copy) NSString* count;
@property (nonatomic, copy) NSString* currentPage;

@property (nonatomic, strong) NSArray* sortNameArray; //排序方式列表
@property (nonatomic, strong) NSArray* specialServiceArray; //服务方式列表
@property (nonatomic, strong) NSMutableArray* categoryArray; //商品种类列表

//弹出tabView
@property (nonatomic, weak) GYEasybuyTwoDownView* categoryTabView;
@property (nonatomic, weak) GYEasybuyOneDownView* sortNameTabView;
@property (nonatomic, weak) GYEasybuyOneDownView* sortTypeTabView;
@property (nonatomic, weak) UIView* backView;

//无数据时
@property (nonatomic, strong) UIImageView* notFoundImgView;
@property (nonatomic, strong) UILabel* notFoundlabel;

@end

@implementation GYEasybuyGoodsListViewController

#pragma mark - 生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self.addBottomView addBottomBorder];
    [self.addBottomView setBottomBorderInset:YES];
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.collectionView];

    //设置默认选中第一个
//    _index = 0;
    _categoryLabel.text = _categoryName;
    _sortNameLabel.text = kLocalized(@"GYHE_Easybuy_sort");
    _sortTypeLabel.text = kLocalized(@"GYHE_Easybuy_sellerService");
    _hasCoupon = @"0";
    _count = @"8";
    _currentPage = @"1";
    _sortType = @"1";
    _specialService = @"";

    [self refresh];
}

#pragma mark - collectionView代理

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    GYEasybuyTopicListCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:GYEasybuyTopicListCollectionViewCellReuseId forIndexPath:indexPath];
    if (self.dataSource.count > indexPath.item) {
        cell.model = self.dataSource[indexPath.item];
    }
    return cell;
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{

    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    GYEasybuyTopicListModel* model = [[GYEasybuyTopicListModel alloc] init];
    if(self.dataSource.count > indexPath.item) {
        model = self.dataSource[indexPath.item];
    }

    GYEasybuyGoodsInfoViewController* vc = [[GYEasybuyGoodsInfoViewController alloc] init];
    vc.itemId = model.id;
    vc.vShopId = model.vShopId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    [GYGIFHUD dismiss];

    if (netRequest.tag == kGYEasyBuyTopicListUrl) {

        [self getTopicListWithDict:responseObject];
    }
    else if (netRequest.tag == kGYEasyBuyColumnClassifyUrl) {
        NSError* error = nil;
        NSMutableArray* arr = [GYEasybuyColumnClassModel modelArrayWithResponseObject:responseObject error:&error].mutableCopy;
//        for (int i = 0; i < arr.count; i++) {
//            GYEasybuyColumnClassModel* mod = arr[i];
//            mod.isSelected = i == 0 ? YES : NO;
//        }
        GYEasybuyColumnClassModel* mod = arr[_index];
        mod.isSelected = YES;
        self.categoryArray = arr;
        [self createCategoryView];
    }
    else if (netRequest.tag == kGYEasyBuySortNameUrl) {
        NSError* error = nil;
        NSArray* arr = [GYEasybuySortModel modelArrayWithResponseObject:responseObject error:&error];
        self.sortNameArray = arr;
        [self createSortNameView];
    }
    else if (netRequest.tag == kGYEasyBuySortTypeUrl) {
        NSError* error = nil;
        NSArray* arr = [GYEasybuySortModel modelArrayWithResponseObject:responseObject error:&error];
        self.specialServiceArray = arr;
        [self createSortTypeView];
    }
}

- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    [GYGIFHUD dismiss];

    [self.collectionView.mj_header endRefreshing];
    self.collectionView.mj_footer.hidden = YES;
//    [self.view addSubview:self.notFoundImgView];
    [self.view insertSubview:self.notFoundImgView aboveSubview:self.collectionView];
    WS(weakSelf);
    [self.notFoundImgView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.width.height.mas_equalTo(60);
        make.centerX.equalTo(weakSelf.view);
        make.top.mas_equalTo(200);
    }];
//    [self.view addSubview:self.notFoundlabel];
    [self.view insertSubview:self.notFoundlabel aboveSubview:self.collectionView];
    [self.notFoundlabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.mas_equalTo(280);
    }];
    [self.dataSource removeAllObjects];
    [self.collectionView reloadData];

    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    if(netRequest.tag == kGYEasyBuyTopicListUrl) {
        if([[netRequest.responseObject[@"retCode"] stringValue] isEqualToString: @"201"]) {
            return ;
        }
    }

    [GYUtils parseNetWork:error resultBlock:nil];
}

#pragma mark - GYEasybuyOneDownViewDelegate
- (void)easybuyOneDownTabViewDidSelected:(GYEasybuyOneDownView*)easybuyOneDownView Index:(NSInteger)index withArray:(NSArray*)arr
{

    if (easybuyOneDownView == _sortNameTabView) {
        _sortNameBtn.selected = NO;
        _sortNameUpDownBtn.selected = NO;
        [self removeDownView];

        GYEasybuySortModel* mod = [[GYEasybuySortModel alloc] init];
        if(arr.count > index) {
            mod = arr[index];
        }
        _sortNameLabel.text = mod.title;
        _sortNameLabel.textColor = kNumRednColor;
        _sortType = mod.sortType;
        
        [self.collectionView.mj_header beginRefreshing];

    }
    else if (easybuyOneDownView == _sortTypeTabView) {
        if(self.specialServiceArray.count <= index ) {
            return ;
        }
        GYEasybuySortModel* mod = self.specialServiceArray[index];
        mod.isSelected = !mod.isSelected;
        _sortTypeTabView.array = self.specialServiceArray;

        // 选中时设置当前
        if (mod.isSelected) {
            _sortTypeLabel.text = mod.title;
            _sortTypeLabel.textColor = kNumRednColor;
        }
        else {
            // 取消时选中最后选择项
            NSString* sortTitle = @"";
            for (NSInteger index = [self.specialServiceArray count] - 1; index >= 0; index--) {
                GYEasybuySortModel* indexMod = self.specialServiceArray[index];
                if (indexMod.isSelected) {
                    sortTitle = indexMod.title;
                    break;
                }
            }

            // 都不选择时使用初始值
            if ([GYUtils checkStringInvalid:sortTitle]) {
                sortTitle = kLocalized(@"GYHE_Easybuy_sellerService");
            }
            _sortTypeLabel.text = sortTitle;
            _sortTypeLabel.textColor = kNumRednColor;
        }
    }
}

#pragma mark - GYEasybuyTwoDownViewDelegate
- (void)firstTabViewDidSelect:(GYEasybuyTwoDownView*)easybuyTwoDownView Index:(NSInteger)index withArray:(NSArray*)arr
{
    if(arr.count <= index) {
        return ;
    }
    GYEasybuyColumnClassModel* mod = arr[index];
    _categoryLabel.text = mod.name;
    _categoryLabel.textColor = kNumRednColor;
    _categoryId = mod.id;
    self.title = _categoryLabel.text;

    for(int i = 0;i < [mod categories].count;i++) {
        GYEasybuyColumnClassSonModel * sonModel = mod.categories[i];
        if(i == 0) {
            sonModel.isSelected = YES;
        }
        if(sonModel.isSelected && i != 0) {
            GYEasybuyColumnClassSonModel * firstModel = mod.categories[i];
            firstModel.isSelected = NO;
        }
    }
    self.categoryTabView.secondArray = mod.categories;

    if (index != _index) {

        if(self.categoryArray.count <= index) {
            return ;
        }
        GYEasybuyColumnClassModel* mod = self.categoryArray[index];
        mod.isSelected = YES;
        GYEasybuyColumnClassModel* model = self.categoryArray[_index];
        model.isSelected = NO;
        [self.categoryTabView.firstTabView.tabView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:index inSection:0], [NSIndexPath indexPathForRow:_index inSection:0] ] withRowAnimation:UITableViewRowAnimationFade];
        _index = (int)index;
    }
}

- (void)secondTabViewDidSelect:(GYEasybuyTwoDownView*)easybuyTwoDownView Index:(NSInteger)index withArray:(NSArray*)arr
{
    _categoryBtn.selected = NO;
    _categoryUpDownBtn.selected = NO;
    [self removeDownView];

    if(arr.count <= index) {
        return ;
    }
    GYEasybuyColumnClassSonModel* mod = arr[index];
    if([mod isKindOfClass:[GYEasybuyColumnClassSonModel class]]) {
        for(GYEasybuyColumnClassSonModel *model in arr) {
            model.isSelected = NO;
        }
        mod.isSelected = YES;
    }else {//GYEasybuyColumnClassModel
        GYEasybuyColumnClassModel *model = (GYEasybuyColumnClassModel *)mod;
        for(GYEasybuyColumnClassSonModel *mode in [model categories]) {
            mode.isSelected = NO;
        }
        GYEasybuyColumnClassSonModel *selModel = [model categories].firstObject;
        selModel.isSelected = YES;
    }
    
    
    _categoryLabel.text = mod.name;
    _categoryLabel.textColor = kNumRednColor;
    _categoryId = mod.id;
    self.title = _categoryLabel.text;
    
//    if([self.collectionView.mj_header isRefreshing]) {
//        [self.collectionView.mj_header endRefreshing];
//    }
//    if([self.collectionView.mj_footer isRefreshing]) {
//        [self.collectionView.mj_footer endRefreshing];
//    }
    [self.collectionView.mj_header beginRefreshing];

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
        UIViewController* vc = [[NSClassFromString(@"GYHESCShoppingCartViewController") alloc] init];
    [vc hidesBottomBarWhenPushed];
    [self.navigationController pushViewController:vc animated:YES];
}

//返回
- (void)backAction:(UIButton*)btn
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sortCategory:(UIButton*)sender
{
    
    sender.selected = !sender.selected;
    _categoryUpDownBtn.selected = sender.selected;

    [self removeDownView];
    if(!sender.selected) {
        [self.collectionView.mj_header beginRefreshing];
    }

    if (sender.selected) {
        _sortNameBtn.selected = !sender.selected;
        _sortTypeBtn.selected = !sender.selected;
        _sortNameUpDownBtn.selected = !sender.selected;
        _sortTypeUpDownBtn.selected = !sender.selected;

        if (self.categoryArray.count > 0) {
            [self createCategoryView];
        }
        else {
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
            [dict setValue:globalData.loginModel.token forKeyPath:@"key"];
            GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuyColumnClassifyUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
            request.tag = kGYEasyBuyColumnClassifyUrl;
            [GYGIFHUD show];
            [request start];
        }
    }
}

- (IBAction)sortName:(UIButton*)sender
{
    
    sender.selected = !sender.selected;
    _sortNameUpDownBtn.selected = sender.selected;

    [self removeDownView];


    if (sender.selected) {
        _categoryBtn.selected = !sender.selected;
        _sortTypeBtn.selected = !sender.selected;
        _categoryUpDownBtn.selected = !sender.selected;
        _sortTypeUpDownBtn.selected = !sender.selected;

        if (self.sortNameArray.count > 0) {
            [self createSortNameView];
        }
        else {
            GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuySortNameUrl parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
            request.tag = kGYEasyBuySortNameUrl;
            [GYGIFHUD show];
            [request start];
        }
    }
}

- (IBAction)sortType:(UIButton*)sender
{
    
    sender.selected = !sender.selected;
    _sortTypeUpDownBtn.selected = sender.selected;

    [self removeDownView];
    if(!sender.selected) {
        [self refreshWithServiceType];
    }

    if (sender.selected) {
        _categoryBtn.selected = !sender.selected;
        _sortNameBtn.selected = !sender.selected;
        _categoryUpDownBtn.selected = !sender.selected;
        _sortNameUpDownBtn.selected = !sender.selected;

        if (self.specialServiceArray.count > 0) {
            self.sortTypeTabView.array = self.specialServiceArray;
        }
        else {

            GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuySortTypeUrl parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
            request.tag = kGYEasyBuySortTypeUrl;
            [GYGIFHUD show];
            [request start];
        }
    }
}

//卖家服务列表里的确认按钮
- (void)serviceTypeSure:(UIButton*)sender
{

    [self removeDownView];
    _sortTypeBtn.selected = NO;
    _sortTypeUpDownBtn.selected = NO;

    [self refreshWithServiceType];
    

}

#pragma mark - 自定义方法

- (void)setNav
{

    self.navigationItem.title = _categoryName;

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
}
- (void)createSortNameView
{
    self.sortNameTabView.array = self.sortNameArray;
}

- (void)createCategoryView
{
    
    self.categoryTabView.currentSelectIndex = _index;
    self.categoryTabView.firstArray = self.categoryArray;
    if(self.categoryArray.count <= _index) {
        return ;
    }
    
    GYEasybuyColumnClassModel* mod = self.categoryArray[_index];
    
    
    for(int i = 0;i < [mod categories].count;i++) {
        GYEasybuyColumnClassSonModel * sonModel = mod.categories[i];
        if(i == 0) {
            sonModel.isSelected = YES;
        }
        if(sonModel.isSelected && i != 0) {
            GYEasybuyColumnClassSonModel * firstModel = mod.categories[0];
            firstModel.isSelected = NO;
        }
    }

    self.categoryTabView.secondArray = [mod categories];
}

- (void)createSortTypeView
{
    self.sortTypeTabView.array = self.specialServiceArray;
}

- (void)clickBackView {
    if(_categoryBtn.selected || _sortTypeBtn.selected) {
        [self refreshWithServiceType];
    }
    

    _sortNameBtn.selected = NO;
    _sortTypeBtn.selected = NO;
    _categoryBtn.selected = NO;
    _sortNameUpDownBtn.selected = NO;
    _sortTypeUpDownBtn.selected = NO;
    _categoryUpDownBtn.selected = NO;
    [self removeDownView];
    
    
}
- (void)removeDownView
{
    
    [_backView removeFromSuperview];
    _backView = nil;
    [_categoryTabView removeFromSuperview];
    [_sortNameTabView removeFromSuperview];
    [_sortTypeTabView removeFromSuperview];
}

- (void)refresh
{

    WS(weakSelf);
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = @"1";
        [weakSelf loadData];
    }];

    self.collectionView.mj_header = header;
    [self.collectionView.mj_header beginRefreshing];

    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage = [NSString stringWithFormat:@"%d", [weakSelf.currentPage intValue]+1];
        [weakSelf loadData];
    }];

    //    [footer addTopBorder];
    self.collectionView.mj_footer = footer;
}

- (void)refreshWithServiceType {
    NSMutableArray* serviceArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.specialServiceArray.count; i++) {
        GYEasybuySortModel* mod = self.specialServiceArray[i];
        if ([mod.sortType isEqualToString:@"6"]) {
            _hasCoupon = mod.isSelected ? @"1" : @"0";
        }
        else {
            if (mod.isSelected) {
                [serviceArray addObject:mod.title];
            }
        }
    }
    NSString* str = [serviceArray componentsJoinedByString:@","];
    _specialService = str;
    if (str.length == 0 && [_hasCoupon isEqualToString:@"0"]) {
        _sortTypeLabel.text = kLocalized(@"GYHE_Easybuy_sellerService");
        _sortTypeLabel.textColor = kTitleBlackColor;
    }
    [self.collectionView.mj_header beginRefreshing];
}

- (void)loadData
{

    [self.params setValue:_hasCoupon forKey:@"hasCoupon"];
    [self.params setValue:_count forKey:@"count"];
    [self.params setValue:_currentPage forKey:@"currentPage"];
    [self.params setValue:_categoryId forKey:@"categoryId"];
    [self.params setValue:_sortType forKey:@"sortType"];
    [self.params setValue:_specialService forKey:@"specialService"];

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:GetEasyBuyTopicListUrl parameters:self.params requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = kGYEasyBuyTopicListUrl;
    [request start];
}

- (void)getTopicListWithDict:(NSDictionary*)responseObject
{

    NSError* error = nil;
    NSArray* arr = [GYEasybuyTopicListModel modelArrayWithResponseObject:responseObject error:&error];
    //没有数据隐藏上拉刷新视图，显示没有更多数据
    if (arr.count == 0) {
        self.collectionView.mj_footer.hidden = YES;
        WS(weakSelf);

        [self.view insertSubview:self.notFoundImgView aboveSubview:self.collectionView];
        [self.notFoundImgView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.width.height.mas_equalTo(60);
            make.centerX.equalTo(weakSelf.view);
            make.top.mas_equalTo(200);
        }];

        [self.view insertSubview:self.notFoundlabel aboveSubview:self.collectionView];
        [self.notFoundlabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerX.equalTo(weakSelf.view);
            make.top.mas_equalTo(280);
        }];

        [self.dataSource removeAllObjects];
        [self.collectionView reloadData];
    }
    else {
        self.collectionView.mj_footer.hidden = NO;
        [self.notFoundlabel removeFromSuperview];
        [self.notFoundImgView removeFromSuperview];
    }

    if ([self.collectionView.mj_header isRefreshing]) {
        [_collectionView.mj_header endRefreshing];
        self.dataSource = arr.mutableCopy;
    }
    if ([self.collectionView.mj_footer isRefreshing]) {

        [_collectionView.mj_footer endRefreshing];

        [self.dataSource addObjectsFromArray:arr];
    }
    [self.collectionView reloadData];

    //如果为最后一页，显示已经加载全部
    if ([responseObject[@"totalPage"] intValue] == [responseObject[@"currentPageIndex"] intValue]) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }else {
        [self.collectionView.mj_footer resetNoMoreData];
    }
}

#pragma mark - 懒加载
- (UICollectionView*)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - 64 - 40) collectionViewLayout:layout];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;

        layout.itemSize = CGSizeMake(kScreenWidth / 2, (kScreenWidth / 2 - 18) / 340.0 * 390 + 123);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.backgroundColor = kDefaultVCBackgroundColor;
        _collectionView.opaque = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYEasybuyTopicListCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:GYEasybuyTopicListCollectionViewCellReuseId];
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

- (NSMutableDictionary*)params
{
    if (!_params) {
        _params = [[NSMutableDictionary alloc] init];
    }
    return _params;
}

- (NSMutableArray*)categoryArray
{
    if (!_categoryArray) {
        _categoryArray = [[NSMutableArray alloc] init];
    }
    return _categoryArray;
}

- (NSArray*)sortNameArray
{
    if (!_sortNameArray) {
        _sortNameArray = [[NSArray alloc] init];
    }
    return _sortNameArray;
}

- (NSArray*)specialServiceArray
{
    if (!_specialServiceArray) {
        _specialServiceArray = [[NSArray alloc] init];
    }
    return _specialServiceArray;
}

- (GYEasybuyTwoDownView*)categoryTabView
{
    if (!_categoryTabView) {
        CGRect rect = self.backView.frame;
        rect.size.height = rect.size.height - 100;
        GYEasybuyTwoDownView* view = [[GYEasybuyTwoDownView alloc] initWithFrame:rect withFirstCellName:@"GYEasybuyCategoryCell" withFirstViewWidth:kScreenWidth / 3.0];
        view.secondCellName = @"GYEasybuyCategoreTableViewCell";
        view.delegate = self;
        view.oneTabViewCellKey = @"model";
        view.twoTabViewCellKey = @"model";
        [self.view addSubview:view];
        _categoryTabView = view;
    }
    return _categoryTabView;
}

- (GYEasybuyOneDownView*)sortNameTabView
{
    if (!_sortNameTabView) {
        CGRect rect = self.backView.frame;
        rect.size.height = self.sortNameArray.count * 44;
        GYEasybuyOneDownView* view = [[GYEasybuyOneDownView alloc] initWithFrame:rect withCellName:@"UITableViewCell" withFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        view.delegate = self;
        view.tabViewCellKey = @"title";
        [self.view addSubview:view];
        _sortNameTabView = view;
    }
    return _sortNameTabView;
}

- (GYEasybuyOneDownView*)sortTypeTabView
{
    if (!_sortTypeTabView) {
        CGRect rect = self.backView.frame;
        rect.size.height = self.specialServiceArray.count * 44 + 60;
        GYEasybuyServiceFooterView* footerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYEasybuyServiceFooterView class]) owner:self options:0][0];
        GYEasybuyOneDownView* view = [[GYEasybuyOneDownView alloc] initWithFrame:rect withCellName:@"GYEasybuyServiceCell" withFooterView:footerView];
        [footerView.sureBtn addTarget:self action:@selector(serviceTypeSure:) forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:view];
        view.delegate = self;
        view.tabViewCellKey = @"model";
        _sortTypeTabView = view;
    }
    return _sortTypeTabView;
}

- (UIView*)backView
{
    if (!_backView) {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - 104)];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackView)];
        [view addGestureRecognizer:tap];
        
        [self.view addSubview:view];
        _backView = view;
    }
    return _backView;
}

- (UIImageView*)notFoundImgView
{
    if (!_notFoundImgView) {
        _notFoundImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gycommon_search_norecord"]];
    }
    return _notFoundImgView;
}

- (UILabel *)notFoundlabel {
    if (!_notFoundlabel) {
        _notFoundlabel = [[UILabel alloc] init];
        _notFoundlabel.text = kLocalized(@"GYHE_Easybuy_NoSearchRelevantProductData");
        _notFoundlabel.textColor = [UIColor lightGrayColor];


    }
    return _notFoundlabel;
}

@end
