//
//  GYEasybuySearchDetailViewController.m
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEasybuySearchDetailViewController.h"
#import "UIView+CustomBorder.h"
#import "GYNetRequest.h"
#import "JSONModel+ResponseObject.h"
#import "GYEasybuySearchGoodsListCell.h"
#import "GYEasybuyOneDownView.h"
#import "GYEasybuyTwoDownView.h"
#import "MJRefresh.h"
#import "GYEasybuySearchGoodsDetailModel.h"
#import "GYEasybuyMainViewController.h"
#import "GYEasybuyColumnClassModel.h"
#import "GYEasybuyServiceCell.h"
#import "GYEasybuyServiceFooterView.h"
#import "Masonry.h"
#import "GYEasybuyGoodsInfoViewController.h"
#import "GYEasybuySearchShopsListCell.h"
#import "PopoverView.h"
#import "Masonry.h"
#import "GYShopDescribeController.h"
#import "GYHEUtil.h"
#import "GYEasyBuyModel.h"
#import "GYAlertView.h"

#define kGYEasybuySearchGoodsListCell @"GYEasybuySearchGoodsListCell"
#define kGYEasybuySearchShopsListCell @"GYEasybuySearchShopsListCell"

@interface GYEasybuySearchDetailViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, GYNetRequestDelegate, GYEasybuyOneDownViewDelegate>
//智能排序
@property (weak, nonatomic) IBOutlet UILabel* sortLabel1;
@property (weak, nonatomic) IBOutlet UIButton* sortBtn1;
@property (weak, nonatomic) IBOutlet UIButton* sortNameUpDownBtn;
//卖家服务
@property (weak, nonatomic) IBOutlet UILabel* sortLab2;
@property (weak, nonatomic) IBOutlet UIButton* sortBtn2;
@property (weak, nonatomic) IBOutlet UIButton* sortTypeUpDownBtn;

@property (weak, nonatomic) IBOutlet UITableView* tabView;
@property (weak, nonatomic) IBOutlet UIView* topView;
//数据源
@property (nonatomic, strong) NSMutableArray* goodsDataArray;
@property (nonatomic, strong) NSArray* sortNameArray;
@property (nonatomic, strong) NSMutableArray* specialServiceArray;

//弹出tabView
@property (nonatomic, weak) GYEasybuyOneDownView* sortNameTabView;
@property (nonatomic, weak) GYEasybuyOneDownView* sortTypeTabView;
@property (nonatomic, weak) UIView* backView;
//URl参数
@property (nonatomic, copy) NSString* hasCoupon; //抵扣卷
@property (nonatomic, copy) NSString* sortType; //排序方式
@property (nonatomic, copy) NSString* specialService; //服务方式
@property (nonatomic, copy) NSString* count;
@property (nonatomic, copy) NSString* currentPage;

@property (nonatomic, strong) UIView* notFoundView;

@property (nonatomic, strong) UITextField* textField;
@property (nonatomic, strong) UIButton* changeSearchTypeBtn;

@end

@implementation GYEasybuySearchDetailViewController

#pragma mark - 生命周期

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.textField.placeholder = (_searchType == kGoods) ? kLocalized(@"GYHE_Easybuy_pleaseEnterSearchGoods") : kLocalized(@"GYHE_Easybuy_pleaseEnterSearchShops");
    if (kScreenWidth < 325 && [self.textField.placeholder isEqualToString:kLocalized(@"GYHE_Easybuy_pleaseEnterSearchShops")]) {
        [self.textField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    }

    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = kNavigationBarColor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    self.textField.text = _keyWord;
    [_sortNameUpDownBtn setBackgroundImage:[UIImage imageNamed:@"gyhe_headerView_down"] forState:UIControlStateNormal];
    [_sortNameUpDownBtn setBackgroundImage:[UIImage imageNamed:@"gyhe_headerView_up_red"] forState:UIControlStateSelected];
    [_sortTypeUpDownBtn setBackgroundImage:[UIImage imageNamed:@"gyhe_headerView_down"] forState:UIControlStateNormal];
    [_sortTypeUpDownBtn setBackgroundImage:[UIImage imageNamed:@"gyhe_headerView_up_red"] forState:UIControlStateSelected];

    _tabView.tableFooterView = [[UIView alloc] init];
    [_topView addBottomBorder];
    [_topView setBottomBorderInset:YES];

    _sortLabel1.text = kLocalized(@"GYHE_Easybuy_intelligent_sorting");
    _sortLab2.text = kLocalized(@"GYHE_Easybuy_sellerService");
    _hasCoupon = @"0";
    _count = @"8";
    _currentPage = @"1";
    _sortType = @"7";
    _specialService = @"";
    [self setUp];
    [self refresh];
}

#pragma mark - UITableViewDataSource，UITableViewDelegate

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodsDataArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (_searchType == kGoods) {
        GYEasybuySearchGoodsListCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYEasybuySearchGoodsListCell forIndexPath:indexPath];
        if(self.goodsDataArray.count > indexPath.row) {
            cell.model = self.goodsDataArray[indexPath.row];
        }
        
        return cell;
    }
    else if (_searchType == kShops) {
        GYEasybuySearchShopsListCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYEasybuySearchShopsListCell forIndexPath:indexPath];
        if (self.goodsDataArray.count > indexPath.row) {
            cell.model = self.goodsDataArray[indexPath.row];
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (_searchType == kGoods) {
        
        GYEasybuyGoodsInfoViewController* vc = [[GYEasybuyGoodsInfoViewController alloc] init];
        if(self.goodsDataArray.count > indexPath.row) {
            GYEasybuySearchGoodsDetailModel* model = self.goodsDataArray[indexPath.row];
            vc.itemId = model.id;
            vc.vShopId = model.vShopId;
        }
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (_searchType == kShops) {
        ShopModel* shopModel = [[ShopModel alloc] init];
        GYShopDescribeController* vc = [[GYShopDescribeController alloc] init];
        if(self.goodsDataArray.count > indexPath.row) {
            GYEasybuySearchShopsDetailModel* model = self.goodsDataArray[indexPath.row];
            CLLocationCoordinate2D shopCoordinate;
            shopCoordinate.latitude = model.lat.doubleValue;
            shopCoordinate.longitude = model.longitude.doubleValue;
            BMKMapPoint mp2 = BMKMapPointForCoordinate(shopCoordinate);
            
            shopModel.strVshopId = model.vShopId;
            shopModel.beTake = model.beTake;
            shopModel.strShopId = model.hotline;
            shopModel.beSell = model.beSell;
            shopModel.beCash = model.beCash;
            //shopModel.beQuan=model
            shopModel.shopDistance = model.dist;
            shopModel.strLongitude = model.longitude;
            shopModel.strShopAddress = model.addr;
            shopModel.beReach = model.beReach;
            shopModel.strResno = model.companyResourceNo;
            shopModel.beTicket = model.beTicket;
            shopModel.strLat = model.lat;
            shopModel.strCity = model.city;
            shopModel.strShopPictureURL = model.pic;
            shopModel.strRate = model.rate;
            shopModel.strShopId = model.shopId;
            shopModel.strStoreName = model.vShopName;
            shopModel.strShopName = model.shopName;
            
            //shopModel.strShopId=model.province ;
            
            vc.currentMp1 = mp2;
            vc.shopModel = shopModel;

        }
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    [GYGIFHUD dismiss];
    if (netRequest.tag == kGYEasyBuySearchListUrl) {

        [self getSearchListWithDict:responseObject];
    }
    else if (netRequest.tag == kGYEasyBuySortNameUrl) {
        NSArray* arr = [GYEasybuySortModel modelArrayWithResponseObject:responseObject error:nil];
        self.sortNameArray = arr;
        self.sortNameTabView.array = self.sortNameArray;
    }
    else if (netRequest.tag == kGYEasyBuySortTypeUrl) {

        NSArray* arr = [GYEasybuySortModel modelArrayWithResponseObject:responseObject error:nil];
        self.specialServiceArray = arr.mutableCopy;
        self.sortTypeTabView.array = self.specialServiceArray;
    }
    else if (netRequest.tag == kGYEasyBuySearchShopsListUrl) {
        [self getSearchListWithDict:responseObject];
    }
}

- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    [GYGIFHUD dismiss];
    [self notFound];
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}

#pragma mark - GYEasybuyOneDownViewDelegate
- (void)easybuyOneDownTabViewDidSelected:(GYEasybuyOneDownView*)easybuyOneDownView Index:(NSInteger)index withArray:(NSArray*)arr
{

    if (easybuyOneDownView == _sortNameTabView) {
        [self removeDownView];
        _sortBtn1.selected = !_sortBtn1.selected;
        _sortNameUpDownBtn.selected = _sortBtn1.selected;

        if(arr.count <= index) {
            return ;
        }
        GYEasybuySortModel* mod = arr[index];
        _sortLabel1.text = mod.title;
        _sortLabel1.textColor = [UIColor redColor];
        _sortType = mod.sortType;
        [self refresh];
    }
    else if (easybuyOneDownView == _sortTypeTabView) {

        if(self.specialServiceArray.count <= index) {
            return ;
        }
        GYEasybuySortModel* mod = self.specialServiceArray[index];
        mod.isSelected = !mod.isSelected;
        _sortTypeTabView.array = self.specialServiceArray;

        // 选中时设置当前
        if (mod.isSelected) {
            _sortLab2.text = mod.title;
            _sortLab2.textColor = kNumRednColor;
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
            _sortLab2.text = sortTitle;
            _sortLab2.textColor = kNumRednColor;
        }
    }
}

#pragma mark - 点击事件
//卖家服务列表里的确认按钮
- (void)serviceTypeSure:(UIButton*)sender
{

    [self removeDownView];
    _sortBtn2.selected = !_sortBtn2.selected;
    _sortTypeUpDownBtn.selected = NO;

    
    [self refreshServiceType];
    
}

//返回上层
- (void)pop:(UIButton*)sender
{
    GYEasybuySearchMainController* vc = self.navigationController.childViewControllers[[self.navigationController.childViewControllers indexOfObject:self] - 1];
    vc.searchType = _searchType;
    [self.navigationController popViewControllerAnimated:NO];
    [self.textField becomeFirstResponder];
}

//返回主层
- (void)backAction:(UIButton*)sender
{
    self.navigationController.navigationBar.barTintColor = kNavigationBarColor;
    UIViewController* vc = self.navigationController.childViewControllers[[self.navigationController.childViewControllers indexOfObject:self] - 2];
    [self.navigationController popToViewController:vc animated:YES];
}

//导航栏里的搜索状态，商品&&商铺
- (void)changesSearchType:(UIButton*)sender
{

    [self.notFoundView removeFromSuperview];
    self.notFoundView = nil;
    self.sortNameArray = nil;
    CGPoint point = CGPointMake(100 , 65);
    NSArray* titles = @[ kLocalized(@"GYHE_Easybuy_goods"), kLocalized(@"GYHE_Easybuy_shops") ];
    NSArray* images = @[ @"gyhe_prow_shop", @"gyhe_prow_goods" ];
    PopoverView* pop = [[PopoverView alloc] initWithPoint:point titles:titles images:images];
    WS(weakSelf);
    pop.selectRowAtIndex = ^(NSInteger index) {

        weakSelf.searchType = (index == 0) ? kGoods : kShops;
        weakSelf.goodsDataArray = nil;
        if(titles.count <= index) {
            return ;
        }
        [weakSelf.changeSearchTypeBtn setTitle:titles[index] forState:UIControlStateNormal];
        weakSelf.currentPage = @"1";
        [weakSelf refresh];

    };
    [pop show];
}

//排序下拉的第一个btn，改变排序方式
- (IBAction)sortNameAction:(UIButton*)sender
{
    sender.selected = !sender.selected;
    _sortNameUpDownBtn.selected = sender.selected;

    [self removeDownView];

    if (sender.selected) {
        _sortBtn2.selected = NO;
        _sortTypeUpDownBtn.selected = NO;

        if (self.sortNameArray.count > 0) {
            self.sortNameTabView.array = self.sortNameArray;
        }
        else {
            NSString *type = _searchType == kGoods ? @"2":@"1";
            GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuySortNameUrl parameters:@{ @"type" : type } requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
            request.tag = kGYEasyBuySortNameUrl;
            [GYGIFHUD show];
            [request start];
        }
    }
}

//排序下拉的第二个btn，改变服务方式
- (IBAction)sortServiceAction:(UIButton*)sender
{
    sender.selected = !sender.selected;
    _sortTypeUpDownBtn.selected = sender.selected;

    [self removeDownView];

    if (sender.selected) {
        _sortBtn1.selected = NO;
        _sortNameUpDownBtn.selected = NO;
        if (self.specialServiceArray.count > 0) {

            self.sortTypeTabView.array = self.specialServiceArray;
        }
        else {
            GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuySortTypeUrl parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
            request.tag = kGYEasyBuySortTypeUrl;
            [GYGIFHUD show];
            [request start];
        }
    }else {
        [self refreshServiceType];
    }
}

- (void)tfEditing:(UITextField*)sender
{
    if (sender.text.length > 100) {
        [GYUtils showToast:kLocalized(@"GYHE_Easybuy_maxLengthIs100")];
        sender.text = [sender.text substringToIndex:100];
    }
}

#pragma mark - 自定义方法
- (void)setNav
{

    UIButton* btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 40, 30);
    btnBack.imageEdgeInsets = UIEdgeInsetsMake(6, 5, 6, 23);
    btnBack.backgroundColor = [UIColor clearColor];
    [btnBack setImage:[UIImage imageNamed:@"gyhe_nav_btn_redback"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];

    UIButton* btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.frame = CGRectMake(0, 0, 40, 30);
    btnSearch.imageEdgeInsets = UIEdgeInsetsMake(6, 5, 6, 23);
    btnSearch.backgroundColor = [UIColor clearColor];
    [btnSearch setTitle:kLocalized(@"GYHE_Easybuy_search") forState:UIControlStateNormal];
    [btnSearch setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSearch];

    self.navigationItem.titleView = [self titleView];
}
- (UIView*)titleView
{
    UIView* vHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    vHead.backgroundColor = [UIColor whiteColor];
    UIView* vTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 4, kScreenWidth - 130, 32)];
    vTitleView.backgroundColor = [UIColor colorWithRed:235.0 / 255.0f green:235.0 / 255.0f blue:235.0 / 255.0f alpha:1.0f];

    UIButton* btnChooseType = [UIButton buttonWithType:UIButtonTypeCustom];
    btnChooseType.frame = CGRectMake(0, 0, 50, 32);
    btnChooseType.backgroundColor = [UIColor clearColor];
    btnChooseType.titleLabel.textColor = [UIColor colorWithRed:160.0 / 255.0F green:160.0 / 255.0F blue:160.0 / 255.0F alpha:1.0f];
    btnChooseType.titleLabel.font = [UIFont systemFontOfSize:14];
    self.changeSearchTypeBtn = btnChooseType;
    [btnChooseType setTitle:kLocalized(@"GYHE_Easybuy_goods") forState:UIControlStateNormal];

    [btnChooseType setImage:[UIImage imageNamed:@"gyhe_prow_trigon.png"] forState:UIControlStateNormal];
    [btnChooseType setImageEdgeInsets:UIEdgeInsetsMake(13, 44, 13, -6)];
    [btnChooseType setTitleEdgeInsets:UIEdgeInsetsMake(0, -btnChooseType.frame.size.width + 32, 0, 5)];
    [btnChooseType setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    [btnChooseType addTarget:self action:@selector(changesSearchType:) forControlEvents:UIControlEventTouchUpInside];

    UITextField* tfInputSearchText = [[UITextField alloc] initWithFrame:CGRectMake(60, 4, CGRectGetWidth(vTitleView.frame) - 60, 25)];
    tfInputSearchText.contentMode = UIViewContentModeScaleToFill;
    tfInputSearchText.returnKeyType = UIReturnKeySearch;
    tfInputSearchText.delegate = self;
    tfInputSearchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfInputSearchText.enablesReturnKeyAutomatically = YES;
    tfInputSearchText.textColor = [UIColor colorWithRed:95.0 / 255.0f green:95.0 / 255.0f blue:95.0 / 255.0f alpha:1.0f];
    tfInputSearchText.backgroundColor = [UIColor colorWithRed:235.0 / 255.0f green:235.0 / 255.0f blue:235.0 / 255.0f alpha:1.0f];
    //    [tfInputSearchText becomeFirstResponder];
    [tfInputSearchText addTarget:self action:@selector(tfEditing:) forControlEvents:UIControlEventEditingChanged];
    [vTitleView addSubview:btnChooseType];
    [vTitleView addSubview:tfInputSearchText];
    tfInputSearchText.placeholder = (_searchType == kGoods) ? kLocalized(@"GYHE_Easybuy_pleaseEnterSearchGoods") : kLocalized(@"GYHE_Easybuy_pleaseEnterSearchShops");
    tfInputSearchText.font = [UIFont systemFontOfSize:14];
    [tfInputSearchText addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchDown];
    [vHead addSubview:vTitleView];
    self.textField = tfInputSearchText;
    return vHead;
}
- (void)search
{
    if (self.textField.text.length == 0) {
        NSString* msg = _searchType == kGoods ? kLocalized(@"GYHE_Easybuy_pleaseEnterSearchGoods") : kLocalized(@"GYHE_Easybuy_pleaseEnterSearchShop");
        [GYUtils showMessage:msg];
        
        return;
    }
    [self refresh];
}
- (void)getSearchListWithDict:(NSDictionary*)responseObject
{

    NSArray* arr = [[NSArray alloc] init];
    if (_searchType == kGoods) {
        arr = [GYEasybuySearchGoodsDetailModel modelArrayWithResponseObject:responseObject error:nil];
    }
    else if (_searchType == kShops) {
        arr = [GYEasybuySearchShopsDetailModel modelArrayWithResponseObject:responseObject error:nil];
    }

    if (arr.count == 0) {

        [self.tabView.mj_header endRefreshing];
        self.tabView.mj_footer.hidden = YES;
        [self notFound];
    }
    else {
        [self.notFoundView removeFromSuperview];
        self.tabView.mj_footer.hidden = NO;

        if ([self.tabView.mj_header isRefreshing]) {
            [self.tabView.mj_header endRefreshing];
            self.goodsDataArray = arr.mutableCopy;
        }
        if ([self.tabView.mj_footer isRefreshing]) {
            [self.tabView.mj_footer endRefreshing];
            [self.goodsDataArray addObjectsFromArray:arr];
        }
        [self.tabView reloadData];
    }
    //如果为最后一页，显示已经加载全部
    if ([responseObject[@"currentPageIndex"] intValue] == [responseObject[@"totalPage"] intValue]) {
        [self.tabView.mj_footer endRefreshingWithNoMoreData];
    }else {
        [self.tabView.mj_footer resetNoMoreData];
    }
}

- (void)notFound
{
    [self.goodsDataArray removeAllObjects];
    [self.tabView reloadData];
    [self.tabView.mj_header endRefreshing];
    self.tabView.mj_footer.hidden = YES;
    WS(weakSelf);
    [self.view addSubview:self.notFoundView];
    [self.notFoundView mas_makeConstraints:^(MASConstraintMaker* make) {

        make.centerX.equalTo(weakSelf.view);
        make.top.mas_equalTo(120);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
}
- (void)clickBackView {
    
    if(_sortBtn2.selected) {
        [self refreshServiceType];
    }
    
    _sortBtn1.selected = NO;
    _sortBtn2.selected = NO;
    _sortNameUpDownBtn.selected = NO;
    _sortTypeUpDownBtn.selected = NO;
    [self removeDownView];
    
}

- (void)removeDownView
{

    [_backView removeFromSuperview];
    _backView = nil;
    [_sortNameTabView removeFromSuperview];
    [_sortTypeTabView removeFromSuperview];
}

- (void)setUp
{

    [self.changeSearchTypeBtn setTitle:(_searchType == kGoods) ? kLocalized(@"GYHE_Easybuy_goods") : kLocalized(@"GYHE_Easybuy_shops") forState:UIControlStateNormal];
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYEasybuySearchGoodsListCell class]) bundle:nil] forCellReuseIdentifier:kGYEasybuySearchGoodsListCell];
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYEasybuySearchShopsListCell class]) bundle:nil] forCellReuseIdentifier:kGYEasybuySearchShopsListCell];
}

- (void)refresh
{
    WS(weakSelf);
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = @"1";
        if (weakSelf.searchType == kGoods) {
            [weakSelf requestData];
        } else if (weakSelf.searchType == kShops) {
            [weakSelf requestShopList];
        }
    }];

    self.tabView.mj_header = header;
    [self.tabView.mj_header beginRefreshing];
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage = [NSString stringWithFormat:@"%d", [weakSelf.currentPage intValue]+1];
        if (weakSelf.searchType == kGoods) {
            [weakSelf requestData];
        } else if (weakSelf.searchType == kShops) {
            [weakSelf requestShopList];
        }
    }];
    [footer addTopBorder];
    self.tabView.mj_footer = footer;
}
- (void)refreshServiceType {
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
        _sortLab2.text = kLocalized(@"GYHE_Easybuy_sellerService");
        _sortLab2.textColor = kTitleBlackColor;
    }
    
    [self.tabView.mj_header beginRefreshing];
}
- (void)requestShopList
{

    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    GlobalData* data = [GlobalData shareInstance];
    [params setValue:_hasCoupon forKey:@"hasCoupon"];
    [params setValue:_count forKey:@"count"];
    [params setValue:_currentPage forKey:@"currentPage"];
    [params setValue:_sortType forKey:@"sortType"];
    [params setValue:_specialService forKey:@"specialService"];
    [params setValue:_keyWord forKey:@"keyword"];
    if (globalData.selectedCityCoordinate) {
        
       [params setValue:data.selectedCityCoordinate forKey:@"location"];
    }
    else {
        
        [params setValue:[NSString stringWithFormat:@"%f,%f", globalData.locationCoordinate.latitude, globalData.locationCoordinate.longitude] forKey:@"location"];
    }

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuySearchShopUrl parameters:params requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = kGYEasyBuySearchShopsListUrl;
    
    [request start];
}

- (void)requestData
{

    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setValue:_hasCoupon forKey:@"hasCoupon"];
    [params setValue:_count forKey:@"count"];
    [params setValue:_currentPage forKey:@"currentPage"];
    [params setValue:_sortType forKey:@"sortType"];
    [params setValue:_specialService forKey:@"specialService"];
    [params setValue:_keyWord forKey:@"keyword"];

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuySearchUrl parameters:params requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = kGYEasyBuySearchListUrl;
   
    [request start];
    //
}

#pragma mark - 懒加载
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
        rect.size.height = self.specialServiceArray.count * 44 + 55;
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

- (NSMutableArray*)goodsDataArray
{
    if (!_goodsDataArray) {
        _goodsDataArray = [[NSMutableArray alloc] init];
    }
    return _goodsDataArray;
}

- (NSArray*)sortNameArray
{
    if (!_sortNameArray) {
        _sortNameArray = [[NSArray alloc] init];
    }
    return _sortNameArray;
}

- (NSMutableArray*)specialServiceArray
{
    if (!_specialServiceArray) {
        _specialServiceArray = [[NSMutableArray alloc] init];
    }
    return _specialServiceArray;
}

- (UIView*)notFoundView
{
    if (!_notFoundView) {
        _notFoundView = [[UIView alloc] init];

        UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gycommon_search_norecord"]];
        UILabel* lab = [[UILabel alloc] init];
        if (_searchType == kGoods) {
            lab.text = kLocalized(@"GYHE_Easybuy_NoSearchRelevantProductData");
        }
        else {
            lab.text = kLocalized(@"GYHE_Easybuy_NoSearchRelevantShops");
        }

        lab.textColor = [UIColor lightGrayColor];
        WS(weakSelf);
        [_notFoundView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.height.mas_equalTo(60);
            make.width.mas_equalTo(50);
            make.centerX.equalTo(weakSelf.notFoundView);
            make.top.mas_equalTo(0);
        }];
        [_notFoundView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.notFoundView);
            make.top.mas_equalTo(80);
        }];

    }
    return _notFoundView;
}

@end
