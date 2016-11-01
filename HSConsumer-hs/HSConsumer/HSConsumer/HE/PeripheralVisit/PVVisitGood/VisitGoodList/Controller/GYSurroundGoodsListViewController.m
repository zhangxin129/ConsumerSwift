//
//  GYSurroundGoodsListViewController.m
//  GYHSConsumer_SurroundVisit
//
//  Created by apple on 16/3/22.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSurroundGoodsListViewController.h"
#import "GYSurroundGoodsListDetailCell.h"
#import "JSONModel+ResponseObject.h"
#import "MJRefresh.h"
#import "MJRefreshAutoStateFooter.h"
#import "GYSurroundGoodsMenuModel.h"
#import "GYSurroundGoodsListModel.h"
#import "GYDropListView.h"
#import "FDAreaModel.h"
#import "FDCityModel.h"
#import "FDLocationModel.h"
#import "GYEasybuySearchMainController.h"
#import "GYCityInfo.h"
#import "Masonry.h"
#import "GYHEUtil.h"

#define kGYSurroundGoodsListDetailCell @"GYSurroundGoodsListDetailCell"


@interface GYSurroundGoodsListViewController () <UITableViewDelegate, UITableViewDataSource, GYNetRequestDelegate, GYDropListViewDelegate>

//字段
@property (nonatomic, copy) NSString* currentPage; //当前页面
@property (nonatomic, copy) NSString* count;
@property (nonatomic, copy) NSString* sortType; //当前的排序方式
@property (nonatomic, copy) NSString* specialService; //服务
@property (nonatomic, copy) NSString* hasCoupon; //抵扣
@property (nonatomic, copy) NSString* province; //省
@property (nonatomic, copy) NSString* city; //市
@property (nonatomic, copy) NSString* area; //区
@property (nonatomic, copy) NSString* section; //街道
@property (nonatomic, copy) NSString* distance; //附近距离
@property (nonatomic, copy) NSString* location; //定位

@property (nonatomic, strong) NSMutableArray* areaDataSource;
@property (nonatomic, strong) NSMutableArray* locationDataSource;

//数据源
@property (nonatomic, strong) NSMutableArray* goodsArray;
@property (nonatomic, strong) NSMutableDictionary* classifyDict;
@property (nonatomic, strong) NSArray* classifyArray;
@property (nonatomic, strong) NSArray* sortTypeArray;
@property (nonatomic, strong) NSMutableArray* serviceArray;

@property (nonatomic, strong) UITableView* tabView;
@property (nonatomic, strong) GYDropListView* dropListView;

@property (nonatomic, strong) UIView* notFoundView;

@end

@implementation GYSurroundGoodsListViewController

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{

    [super viewDidLoad];

    self.currentPage = @"1";
    self.count = @"8";
    self.sortType = @"1";
    self.specialService = @"";
    self.hasCoupon = @"0";
    self.province = kLocalized(@"GYHE_SurroundVisit_GuangDong");
    self.city = kLocalized(@"GYHE_SurroundVisit_ShenZhenCity");
    self.area = @"";
    self.section = @"";
    self.distance = @"";
    self.location = @"22.549372,114.077610";

    [self setNav];
    [self refrshUI];

    [self requestClassify];
    [self requestSortType];
    [self requestService];
    [self setupDropListView];
    [self loadAreaData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MJRefresh
//设置上下拉刷新
- (void)refrshUI
{
    WS(weakSelf);
    self.tabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = @"1";
        [weakSelf loadListDataFromNetwork];
    }];

    self.tabView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage = [NSString stringWithFormat:@"%d", [weakSelf.currentPage intValue]+1];
        [weakSelf loadListDataFromNetwork];
    }];

    [self.tabView.mj_header beginRefreshing];
}

//结束刷新
- (void)refreshEnd
{
    if ([self.tabView.mj_header isRefreshing]) {
        [self.tabView.mj_header endRefreshing];
    }
    if ([self.tabView.mj_footer isRefreshing]) {
        [self.tabView.mj_footer endRefreshing];
    }
}

- (void)notFound
{
    [self.goodsArray removeAllObjects];
    [self.tabView reloadData];

    self.tabView.mj_footer.hidden = YES;
    [self performSelector:@selector(refreshEnd) withObject:nil afterDelay:1.0];

    [self.view addSubview:self.notFoundView];
    WS(weakSelf);
    [self.notFoundView mas_makeConstraints:^(MASConstraintMaker* make) {

        make.centerX.equalTo(weakSelf.view);
        make.top.mas_equalTo(200);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
}

#pragma mark - 网络请求
- (void)loadListDataFromNetwork
{

    globalData.selectedCityCoordinate;
    globalData.selectedCityAddress;
    //当前城市
    NSString* strCity;
    if (globalData.locationCity) {
        strCity = globalData.locationCity;
    }
    else {
        strCity = globalData.selectedCityName;
    }
    //过滤掉城市的“市”字
    if ([strCity hasSuffix:kLocalized(@"GYHE_SurroundVisit_City")]) {
        strCity = [strCity substringToIndex:strCity.length - 1];
    }
    if ([strCity hasSuffix:kLocalized(@"GYHE_SurroundVisit_CityAndArea")]) {
        NSRange range = [strCity rangeOfString:kLocalized(@"GYHE_SurroundVisit_City")];
        if (range.location != NSNotFound) {
            strCity = [strCity substringToIndex:range.location];
        }
    }
    _city = strCity;
    //当前省
    //    NSString *strProvince;
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"stateLists" ofType:@"txt"];
    //
    //    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    //    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    //
    //    for (NSDictionary *tempDic in dict[@"data"]) {
    //        GYCityInfo *cityModel = [[GYCityInfo alloc] init];
    //        cityModel.strAreaName = tempDic[@"areaName"];
    //        cityModel.strAreaCode = tempDic[@"areaCode"];
    //        cityModel.strAreaType = tempDic[@"areaType"];
    //        cityModel.strAreaParentCode = tempDic[@"parentCode"];
    //        cityModel.strAreaSortOrder = tempDic[@"sortOrder"];
    //        if ([cityModel.strAreaCode isEqualToString:provinceCode]) {
    //            strProvince = cityModel.strAreaName;
    //        }
    //    }
    //    _province = strProvince;

    //当前经度纬度
    NSString* location;
    if (globalData.locationCoordinate.latitude) {
        location = [NSString stringWithFormat:@"%f,%f", globalData.locationCoordinate.latitude, globalData.locationCoordinate.longitude];
    }
    else {
        location = globalData.selectedCityCoordinate;
    }
    _location = location;

    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:_hasCoupon forKey:@"hasCoupon"];
    [dict setValue:_section forKey:@"section"];
    if (_categoryId) {
        [dict setValue:_categoryId forKey:@"categoryId"];
    }
    [dict setValue:_area forKey:@"area"];

    [dict setValue:_city forKey:@"city"];
    [dict setValue:_distance forKey:@"distance"];
    [dict setValue:_specialService forKey:@"specialService"];
    [dict setValue:_location forKey:@"location"];
    [dict setValue:_sortType forKey:@"sortType"];
    [dict setValue:_count forKey:@"count"];
    [dict setValue:[NSString stringWithFormat:@"%@", self.currentPage] forKey:@"currentPage"];
    [dict setValue:_province forKey:@"province"];

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:GetGoodsTopicListUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = kGoodsTopicListTag;
    [request start];
}

#pragma mark - GYNetRequestDelegate网络请求的代理
- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    if (netRequest.tag == kGoodsTopicListTag) {
        [self setGoodsTopicListData:responseObject];
    }
    else if (netRequest.tag == kCategoryTag) {

        NSArray* rawClassifyArray = responseObject[@"data"];
        _classifyDict = [[NSMutableDictionary alloc] init];
        NSMutableArray* arr = [[NSMutableArray alloc] init];
        WS(weakSelf);
        [rawClassifyArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
            [weakSelf.classifyDict setValue:obj[@"id"] forKey:obj[@"categoryName"]];
            [arr addObject:obj[@"categoryName"]];
        }];
        [_dropListView setDataSource:arr atTitleIndex:2 groupIndex:0];
    }
    else if (netRequest.tag == kCategorySonTag) {

        NSArray* rawClassifyArray = responseObject[@"data"];
        _classifyArray = [GYSurroundGoodsListModel modelArrayWithResponseObject:responseObject error:nil];
        NSMutableArray* arr = [[NSMutableArray alloc] init];
        [rawClassifyArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
            [arr addObject:obj[@"categoryName"]];
        }];
        [_dropListView setDataSource:arr atTitleIndex:2 groupIndex:1];
        [_dropListView showTableViewAtTitleIndex:2 groupIndex:1];
    }
    else if (netRequest.tag == kSortTypeTag) {

        _sortTypeArray = responseObject[@"data"];
        NSMutableArray* array = [[NSMutableArray alloc] init];
        [_sortTypeArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
            [array addObject:obj[@"title"]];
        }];
        [_dropListView setDataSource:array atTitleIndex:1 groupIndex:0];
    }
    else if (netRequest.tag == kServiceTypeTag) {
        NSArray* rawServiceArray = responseObject[@"data"];

        _serviceArray = [[NSMutableArray alloc] init];
        WS(weakSelf);
        [rawServiceArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
            [weakSelf.serviceArray addObject:obj[@"title"]];
        }];
        [_dropListView setDataSource:_serviceArray atTitleIndex:3 groupIndex:0];
    }
    else if (netRequest.tag == kLocationTypeTag) {
        NSArray* modelArray = [FDLocationModel modelArrayWithResponseObject:responseObject error:nil];
        _locationDataSource = [[NSMutableArray alloc] init];
        WS(weakSelf);
        [modelArray enumerateObjectsUsingBlock:^(FDLocationModel* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
            [weakSelf.locationDataSource addObject:obj.locationName];
        }];
        [_dropListView setDataSource:_locationDataSource atTitleIndex:0 groupIndex:1];
        [_dropListView showTableViewAtTitleIndex:0 groupIndex:1];
    }
}

- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    [self notFound];

    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}

#pragma mark GYDropListViewDelegate
- (NSInteger)dropListView:(GYDropListView*)dropListView numberOfGroupsInTitleIndex:(NSInteger)titleIndex
{
    switch (titleIndex) {
    case 0:
        return 2;
        break;
    case 1:
        return 1;
        break;
    case 2:
        return 2;
        break;
    case 3:
        return 1;
        break;
    default:
        return 0;
        break;
    }
}

- (GYDropListViewCellType)dropListView:(GYDropListView*)dropListView cellTypeForRowAtTitleIndex:(NSInteger)titleIndex groupIndex:(NSInteger)groupIndex
{
    if (titleIndex == 0 && groupIndex == 0) {
        return GYDropListViewCellTypeSlider;
    }
    if (titleIndex == 1 && groupIndex == 0) {
        return GYDropListViewCellTypeCheckmark;
    }
    if (titleIndex == 2) {
        return GYDropListViewCellTypeSlider;
    }
    if (titleIndex == 3) {
        return GYDropListViewCellTypeMutableCheckmark;
    }
    return GYDropListViewCellTypeDefault;
}

- (void)loadAreaData
{
    NSString* cityName = globalData.locationCity;
    _city = cityName;
    WS(weakSelf);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSString *cityCode = nil;

        [globalData.cityModels enumerateObjectsUsingBlock:^(FDCityModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if ([obj.areaName isEqualToString:cityName]) {
                cityCode = obj.areaCode;
                *stop = YES;

            }
        }];
        weakSelf.areaDataSource = [NSMutableArray arrayWithArray:[weakSelf areaArrayWithCityCode:cityCode]];
        NSMutableArray *areaNames = [[NSMutableArray alloc] init];
        [weakSelf.areaDataSource enumerateObjectsUsingBlock:^(FDAreaModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            [areaNames addObject:obj.areaName];
        }];
        [weakSelf.dropListView setDataSource:areaNames atTitleIndex:0 groupIndex:0];
    });
}

- (NSArray*)areaArrayWithCityCode:(NSString*)cityCode
{
    NSMutableArray* areaArray = [[NSMutableArray alloc] init];
    FDAreaModel* model = [[FDAreaModel alloc] init];
    model.areaName = kLocalized(@"GYHE_SurroundVisit_Near");
    [areaArray addObject:model];
    for (FDAreaModel* model in globalData.areaModels) {
        if ([model.parentCode isEqualToString:cityCode]) {
            if ([model.areaName isEqualToString:kLocalized(@"GYHE_SurroundVisit_AllCitys")]) {
                continue;
            }
            [areaArray addObject:model];
        }
    }
    return areaArray;
}

- (void)dropListView:(GYDropListView*)dropListView didSelectRowAtTitleIndex:(NSInteger)titleIndex groupIndex:(NSInteger)groupIndex indexPath:(NSIndexPath*)indexPath rowText:(NSString*)rowText
{
    if (titleIndex == 0) {
        if (groupIndex == 0) {
            if(_areaDataSource.count <= indexPath.row) {
                return ;
            }
            FDAreaModel* areaModel = [[FDAreaModel alloc] init];
            if(_areaDataSource.count > indexPath.row)
                areaModel = _areaDataSource[indexPath.row];
            _area = rowText;
            if (indexPath.row == 0) {
                _locationDataSource = [[NSMutableArray alloc] init];
                NSArray* locationNames = @[ kLocalized(@"GYHE_SurroundVisit_AllCitys"), kLocalized(@"GYHE_SurroundVisit_500Meters"), kLocalized(@"GYHE_SurroundVisit_Within1km"), kLocalized(@"GYHE_SurroundVisit_Within3km"), kLocalized(@"GYHE_SurroundVisit_Within5km"), kLocalized(@"GYHE_SurroundVisit_Within10km") ];
                _locationDataSource = [locationNames mutableCopy];
                [_dropListView setDataSource:_locationDataSource atTitleIndex:0 groupIndex:1];
                [_dropListView showTableViewAtTitleIndex:0 groupIndex:1];
            }
            else {
                _locationDataSource = [[NSMutableArray alloc] init];
                GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:GetLocationUrl parameters:@{ @"areaCode" : areaModel.areaCode } requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
                request.tag = kLocationTypeTag;
                [request start];
            }
        }
        if (groupIndex == 1) {
            NSString* title = @"GYHE_SurroundVisit_All";
            if ([rowText isEqualToString:kLocalized(@"")]) {
                title = _area;
            }
            else {
                title = rowText;
            }
            [_dropListView setTitle:title color:[UIColor redColor] atTitleIndex:0];
            [_dropListView hiddenAllTableView];
            if (![_area isEqualToString:kLocalized(@"GYHE_SurroundVisit_Near")]) {
                _section = rowText;
            }
            if ([_area isEqualToString:kLocalized(@"GYHE_SurroundVisit_Near")]) {
                NSString* distance = @"";
                switch (indexPath.row) {
                case 0:

                    break;
                case 1:
                    distance = @"0.5";
                    break;
                case 2:
                    distance = @"1";
                    break;
                case 3:
                    distance = @"3";
                    break;
                case 4:
                    distance = @"5";
                    break;
                case 5:
                    distance = @"10";
                    break;
                default:
                    break;
                }
                _distance = distance;

                _currentPage = @"1";

                [_goodsArray removeAllObjects];
                [_tabView.mj_footer resetNoMoreData];
                [self refrshUI];
            }
            else {
                if ([_location isEqualToString:kLocalized(@"GYHE_SurroundVisit_All")]) {
                    _location = @"";
                }
                _currentPage = @"1";

                [_goodsArray removeAllObjects];
                [_tabView.mj_footer resetNoMoreData];
                [self refrshUI];
            }
        }
    }

    if (titleIndex == 1) {
        [_dropListView setTitle:rowText color:[UIColor redColor] atTitleIndex:titleIndex];
        __block NSString* sortType = nil;
        [_sortTypeArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
            if ([obj[@"title"] isEqualToString:rowText]) {
                sortType = obj[@"sortType"];
                *stop = YES;
            }
        }];
        _currentPage = @"1";
        _sortType = sortType;
        [self.goodsArray removeAllObjects];
        [self refrshUI];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [dropListView hiddenAllTableView];
        });
    }
    if (titleIndex == 2) {
        if (groupIndex == 0) {
            [_dropListView setTitle:rowText color:[UIColor redColor] atTitleIndex:titleIndex];

            NSString* classifyId = [_classifyDict valueForKey:rowText];

            NSDictionary* dict = @{ @"categoryId" : classifyId };
            GYNetRequest* getGoodsgetListRequest = [[GYNetRequest alloc] initWithDelegate:self URLString:GetChildCategoryByParentIdUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
            getGoodsgetListRequest.tag = kCategorySonTag;
            [getGoodsgetListRequest start];
        }
        if (groupIndex == 1) {
            if(_classifyArray.count <= indexPath.row) {
                return ;
            }
            GYSurroundGoodsListModel* mod = _classifyArray[indexPath.row];
            _categoryId = mod.id;
            [self refrshUI];
        }
    }
    if (titleIndex == 3) {
        [_dropListView setTitle:rowText color:[UIColor redColor] atTitleIndex:3];
    }
}

- (void)dropListView:(GYDropListView*)dropListView didClickConfirmButtonAtTitleIndex:(NSInteger)titleIndex groupIndex:(NSInteger)groupIndex choosedIndexPaths:(NSArray*)choosedIndexPaths
{
    if (titleIndex == 3) {
        [dropListView hiddenAllTableView];
        _hasCoupon = @"";
        __block NSString* services = @"";
        WS(weakSelf);
        [choosedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
            if (obj.row == 4) {
                weakSelf.hasCoupon = @"1";

            } else {
                if(weakSelf.serviceArray.count > obj.row) {
                    services = [services stringByAppendingString:weakSelf.serviceArray[obj.row]];
                    services = [services stringByAppendingString:@","];
                }
                
            }

        }];
        if ([services hasSuffix:@","]) {

            services = [services substringToIndex:services.length - 1];
        }

        _currentPage = @"1";
        _specialService = services;
        [self.goodsArray removeAllObjects];
        [self refrshUI];
    }
}

#pragma mark - 自定义方法
- (void)setNav
{
    UIImageView* rightBtnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    rightBtnImageView.contentMode = UIViewContentModeScaleAspectFit;
    rightBtnImageView.image = [UIImage imageNamed:@"gycommon_nav_search"];
    rightBtnImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(search)];
    [rightBtnImageView addGestureRecognizer:tap];
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtnImageView];

    self.navigationItem.rightBarButtonItem = rightBtn;
    self.title = _categoryName;
}
//搜索
- (void)search
{
    GYEasybuySearchMainController* vc = [[GYEasybuySearchMainController alloc] init];
    vc.searchType = 2;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupDropListView
{
    NSArray* titles = @[ kLocalized(@"GYHE_SurroundVisit_Near"), kLocalized(@"GYHE_SurroundVisit_Sort"), _categoryName, kLocalized(@"GYHE_SurroundVisit_SellerService") ];

    _dropListView = [[GYDropListView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) titles:titles delegate:self];
    _dropListView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_dropListView];
}

- (void)requestClassify
{

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:GetGoodsMainInterfaceUrl parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = kCategoryTag;
    [request start];
}

- (void)requestSortType
{
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:ShopSortTypeUrl parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    request.tag = kSortTypeTag;
    [request start];
}

- (void)requestService
{
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:SortTypeUrl parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    request.tag = kServiceTypeTag;
    [request start];
}

- (void)setGoodsTopicListData:(NSDictionary*)responseObject
{

    NSError* error = nil;
    NSMutableArray* array = [GYSurroundGoodsModel modelArrayWithResponseObject:responseObject error:&error].mutableCopy;
    if (array.count > 0) {
        [self.notFoundView removeFromSuperview];

        //下拉刷新，将数据源重置
        if ([self.tabView.mj_header isRefreshing]) {
            self.goodsArray = array;
        }
        //上拉加载，添加新的数据源
        if ([self.tabView.mj_footer isRefreshing]) {
            [self.goodsArray addObjectsFromArray:array];
        }
        [self performSelector:@selector(refreshEnd) withObject:nil afterDelay:1.0];
        [self.tabView reloadData];
    }
    else {
        [self notFound];
    }

    //如果为最后一页，显示已经加载全部
    if ([responseObject[@"totalPage"] intValue] == [responseObject[@"currentPageIndex"] intValue]) {
        [self.tabView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodsArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYSurroundGoodsListDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYSurroundGoodsListDetailCell];
    if(self.goodsArray.count > indexPath.row) {
        [cell refreshUI:self.goodsArray[indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(self.goodsArray.count <= indexPath.row) {
        return ;
    }
    GYSurroundGoodsModel* mod = self.goodsArray[indexPath.row];

    //存到最近浏览的商品
    //存到最近浏览的商品
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSDictionary* dic = [ud objectForKey:kKeyForBrowsingHistory];
    
    NSMutableDictionary* mutDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    
    NSDictionary* dict = @{ @"goodsId" : mod.id,
                            @"shopId" : mod.vShopId,
                            @"goodsPictureUrl" : mod.url,
                            @"goodsName" : mod.itemName,
                            @"goodsPrice" : mod.price  ,
                            @"numBroweTime" : @([[NSDate date] timeIntervalSince1970])};
    [mutDic setValue:dict forKey:mod.id];
    [ud setObject:mutDic forKey:kKeyForBrowsingHistory];
    [ud synchronize];
    

  
}

#pragma mark - 懒加载

- (UITableView*)tabView
{
    if (!_tabView) {
        CGFloat height = kScreenHeight - 40;
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, height) style:UITableViewStylePlain];
        _tabView.backgroundColor = [UIColor whiteColor];
        _tabView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tabView.rowHeight = 100;
        _tabView.dataSource = self;
        _tabView.delegate = self;
        _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tabView];

        [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYSurroundGoodsListDetailCell class]) bundle:nil] forCellReuseIdentifier:kGYSurroundGoodsListDetailCell];
    }
    return _tabView;
}

- (NSMutableArray*)goodsArray
{
    if (!_goodsArray) {
        _goodsArray = [[NSMutableArray alloc] init];
    }
    return _goodsArray;
}

- (UIView*)notFoundView
{
    if (!_notFoundView) {
        _notFoundView = [[UIView alloc] init];

        UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gycommon_search_norecord"]];
        UILabel* lab = [[UILabel alloc] init];
        lab.text = kLocalized(@"GYHE_SurroundVisit_NoSearchRelevantProductData");
        lab.textColor = [UIColor lightGrayColor];

        [_notFoundView addSubview:imgView];
        WS(weakSelf);
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
