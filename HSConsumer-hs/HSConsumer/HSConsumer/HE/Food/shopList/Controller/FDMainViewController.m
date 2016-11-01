//
//  FDMainViewController.m
//  HSConsumer
//
//  Created by zhangqy on 15/9/21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//
#define scoreRed ([UIColor colorWithRed:254 / 255.0 green:71 / 255.0 blue:66 / 255.0 alpha:1])
#define locationGray ([UIColor colorWithRed:234 / 255.0 green:234 / 255.0 blue:234 / 255.0 alpha:1.0])
#define FDMainShopTableViewCellReuseId @"FDMainShopTableViewCellReuseId"
#define FDMainShopCellId @"FDMainShopCellId"
#define FDMainDropScoreTableViewCellReuseId @"FDMainDropScoreTableViewCellReuseId"
#define FDMainDropCategoryTableViewCellReuseId @"FDMainDropCategoryTableViewCellReuseId"
#define FDDropAreaTableViewCellReuseId @"FDDropAreaTableViewCellReuseId"
#define FDMainDropServiceTableViewCellReuseId @"FDMainDropServiceTableViewCellReuseId"
#define DropViewHeight 310
#define DropViewHeightScore 310
#define dropOriginY 125

#import "FDMainViewController.h"
#import "FDAreaModel.h"
#import "FDLocationModel.h"
#import "FDMainDropCategoryTableViewCell.h"
#import "FDMainDropScoreTableViewCell.h"
#import "FDMainModel.h"
#import "FDMainShopTableViewCell.h"
#import "FDSearchShopViewController.h"

#import "FDCityModel.h"
#import "FDDropAreaTableViewCell.h"
#import "FDMainDropServiceTableViewCell.h"
#import "FDMainShopCell.h"
#import "FDSelectFoodViewController.h" //add by zhangx 点菜视图
#import "GYGIFHUD.h"

@interface FDMainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView* noResultView;
@property (weak, nonatomic) IBOutlet UILabel* tagCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel* tagAreaLabel;
@property (weak, nonatomic) IBOutlet UIView* tagCategoryView;
@property (weak, nonatomic) IBOutlet UIView* tagScoreView;
@property (weak, nonatomic) IBOutlet UIView* tagAreaView;
@property (weak, nonatomic) IBOutlet UITableView* shopTableView;
@property (weak, nonatomic) IBOutlet UIImageView* scoreImageView0;
@property (weak, nonatomic) IBOutlet UIImageView* scoreImageView1;
@property (weak, nonatomic) IBOutlet UIImageView* scoreImageView2;
@property (weak, nonatomic) IBOutlet UILabel* scoreLabel;
@property (weak, nonatomic) IBOutlet UIView* tagServiceView;
@property (strong, nonatomic) IBOutlet UIView* blackCoverView;
@property (weak, nonatomic) IBOutlet UITableView* tagTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* tagTableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView* tagHalfTableViewLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* tagHalfTableViewLeftHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView* tagHalfTableViewRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* tagHalfTableViewRightHeightConstraint;

@property (strong, nonatomic) NSMutableArray* shopDataSource;
@property (strong, nonatomic) NSMutableArray* categoryDataSource;
@property (strong, nonatomic) NSMutableArray* scoreDataSource;
@property (strong, nonatomic) NSMutableArray* areaDataSource;
@property (strong, nonatomic) NSMutableArray* locationDataSource;
@property (strong, nonatomic) NSMutableArray* serviceDataSource;
@property (strong, nonatomic) NSMutableArray* currentTagDataSource;

@property (strong, nonatomic) NSArray* citys;
@property (strong, nonatomic) NSArray* areas;
@property (strong, nonatomic) NSArray* locations;

@property (copy, nonatomic) NSString* selectedCategory;
@property (copy, nonatomic) NSString* selectedScore;
@property (copy, nonatomic) NSString* selectedArea;
@property (copy, nonatomic) NSString* selectedLocation;
@property (copy, nonatomic) NSString* selectedService;

@property (assign, nonatomic) NSInteger currentPageIndex;
@property (copy, nonatomic) NSString* currentCity;
@property (copy, nonatomic) NSString* landmark;
@property (copy, nonatomic) NSString* locationAddress;
@property (assign, nonatomic) CLLocationCoordinate2D currentlocationCorrrdinate;

@property (strong, nonatomic) NSArray* tagViewArray;
@property (assign, nonatomic) BOOL tagViewShow;
@property (weak, nonatomic) IBOutlet UIView* tagContainerView;
@property (strong, nonatomic) IBOutlet UIButton* backBtn;
@property (strong, nonatomic) IBOutlet UIView* navTitleView;
@property (strong, nonatomic) NSMutableArray* supportService;
@property (nonatomic, strong) NSMutableArray* contentServiceArr;
@property (strong, nonatomic) IBOutlet UIButton* serviceConfirmBtn;
@property (strong, nonatomic) IBOutlet UIView* serviceConfirmView;
//国际化 add zhangx
@property (weak, nonatomic) IBOutlet UILabel* selectLabel; //筛选

@property (weak, nonatomic) IBOutlet UILabel* noSearchShopLabel; //Sorry，无法搜到餐厅信息
@property (weak, nonatomic) IBOutlet UILabel* titleViewLabel; //互生号/餐厅

@end

@implementation FDMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.titleViewLabel.text = kLocalized(@"GYHE_Food_HSNumberRestaurant");
    [self.serviceConfirmBtn setTitle:kLocalized(@"GYHE_Food_Confirm") forState:UIControlStateNormal];
    [self.backBtn setTitle:kLocalized(@"GYHE_Food_Restaurant") forState:UIControlStateNormal];
    self.selectLabel.text = kLocalized(@"GYHE_Food_Filter");
    self.noSearchShopLabel.text = kLocalized(@"GYHE_Food_NoSearchRestaurantInfomation");
    self.tagCategoryLabel.text = kLocalized(@"GYHE_Food_RestaurantClassification");
    self.scoreLabel.text = kLocalized(@"GYHE_Food_Excellent");
    self.tagAreaLabel.text = kLocalized(@"GYHE_Food_Distance");

    //    _citys = [globalData cityModels];
    //    _areas = [globalData areaModels];
    _citys = [self getCityArray];
    _areas = [self getAreaArray];
    _locations = [globalData locationModels];

    [self initData];
    [self setupDropView];
    [self setupTableView];
    [self loadServiceData];
    [self clearAndLoadData];

    if (!globalData.isOnNet) {
        [self showNoNetworkView];
    } else {
    }

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    _backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _navTitleView.layer.cornerRadius = 5;
    UITapGestureRecognizer* tapNav = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchBtnClicked:)];
    [_navTitleView addGestureRecognizer:tapNav];
    self.navigationItem.titleView = _navTitleView;
}

/*
   修改界面返回时tabBar不显示问题 add by zhangx
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
        [self dismissNoNetworkView];
    }
}

- (void)initData
{
    _currentPageIndex = 1;
    _shopDataSource = [[NSMutableArray alloc] init];
    _categoryDataSource = [[NSMutableArray alloc] init];
    _scoreDataSource = [[NSMutableArray alloc] initWithArray:@[ @"90-100", @"80-90", @"70-80", @"60-70", @"0-60" ]];
    _areaDataSource = [[NSMutableArray alloc] init];
    _locationDataSource = [[NSMutableArray alloc] init];
    _serviceDataSource = [[NSMutableArray alloc] init];
    _supportService = [[NSMutableArray alloc] init];
    _contentServiceArr = [[NSMutableArray alloc] init];

    _params = [[NSMutableDictionary alloc] init];
    [_params setObject:@"10" forKey:@"pageSize"];
    [_params setObject:@(_currentPageIndex).stringValue forKey:@"currentPageIndex"];
    [_params setObject:@"" forKey:@"key"];
    [_params setObject:@"1" forKey:@"type"];
    [_params setObject:@"2" forKey:@"everFlag"];
    [_params setObject:@"" forKey:@"area"];
    [_params setObject:@"" forKey:@"areaName"];

    if (globalData.selectedCityCoordinate) {
        [_params setObject:globalData.selectedCityName forKey:@"city"];
        [_params setObject:globalData.selectedCityCoordinate forKey:@"landmark"];
        NSString* code = [self cityCodeFromCityName:globalData.selectedCityName];
        [self updateAreaDataSourceWithCityCode:code];
    } else {
        if (globalData.locationCity == nil) {

            [_params setObject:@"" forKey:@"city"];
        } else {

            [_params setObject:globalData.locationCity forKey:@"city"];
        }
        [_params setObject:[NSString stringWithFormat:@"%f,%f", globalData.locationCoordinate.latitude, globalData.locationCoordinate.longitude] forKey:@"landmark"];
        NSString* code = [self cityCodeFromCityName:globalData.locationCity];
        [self updateAreaDataSourceWithCityCode:code];
    }
}

- (void)updateAreaDataSourceWithCityName:(NSString*)cityName
{
    NSString* code = [self cityCodeFromCityName:cityName];
    [self updateAreaDataSourceWithCityCode:code];
}

- (void)setupTableView
{
    _shopTableView.tableFooterView = [[UIView alloc] init];
    [_shopTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FDMainShopTableViewCell class]) bundle:nil] forCellReuseIdentifier:FDMainShopTableViewCellReuseId];
    [_shopTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FDMainShopCell class]) bundle:nil] forCellReuseIdentifier:FDMainShopCellId];
    [_shopTableView addLegendHeaderWithRefreshingBlock:^{
        _currentPageIndex = 1;
        [_params setObject:@(_currentPageIndex).stringValue forKey:@"currentPageIndex"];

        [_shopDataSource removeAllObjects];
        [self clearAndLoadData];

    }];
    [_shopTableView addLegendFooterWithRefreshingBlock:^{
        _currentPageIndex++;
        [_params setObject:@(_currentPageIndex).stringValue forKey:@"currentPageIndex"];
        [self loadData];
    }];
}

- (NSString*)cityCodeFromCityName:(NSString*)city
{
    if (_citys) {
        for (int i = 0; i < _citys.count; i++) {
            FDCityModel* cityModel = _citys[i];
            if ([city isEqualToString:cityModel.areaName]) {
                return cityModel.areaCode;
            }
        }
    }
    return nil;
}

- (void)updateAreaDataSourceWithCityCode:(NSString*)cityCode
{
    [_areaDataSource removeAllObjects];
    //附近
    FDAreaModel* model = [[FDAreaModel alloc] init];
    model.areaName = kLocalized(@"GYHE_Food_Nearby");
    [_areaDataSource addObject:model];
    for (FDAreaModel* model in _areas) {
        if ([model.parentCode isEqualToString:cityCode]) {
            if ([model.areaName isEqualToString:kLocalized(@"GYHE_Food_AllCity")]) {
                continue;
            }
            [_areaDataSource addObject:model];
        }
    }
    [_tagHalfTableViewLeft reloadData];
}

- (void)setupDropView
{
    _tagViewArray = @[ _tagCategoryView, _tagScoreView, _tagAreaView, _tagServiceView ];
    [_tagTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FDMainDropCategoryTableViewCell class]) bundle:nil] forCellReuseIdentifier:FDMainDropCategoryTableViewCellReuseId];
    [_tagTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FDMainDropScoreTableViewCell class]) bundle:nil] forCellReuseIdentifier:FDMainDropScoreTableViewCellReuseId];
    [_tagTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FDMainDropServiceTableViewCell class]) bundle:nil] forCellReuseIdentifier:FDMainDropServiceTableViewCellReuseId];
    [_tagHalfTableViewLeft registerNib:[UINib nibWithNibName:NSStringFromClass([FDDropAreaTableViewCell class]) bundle:nil] forCellReuseIdentifier:FDDropAreaTableViewCellReuseId];
    [_tagHalfTableViewRight registerNib:[UINib nibWithNibName:NSStringFromClass([FDDropAreaTableViewCell class]) bundle:nil] forCellReuseIdentifier:FDDropAreaTableViewCellReuseId];

    _tagTableView.tableFooterView = [[UIView alloc] init];
    _tagHalfTableViewLeft.tableFooterView = [[UIView alloc] init];
    _tagHalfTableViewRight.tableFooterView = [[UIView alloc] init];
    _tagHalfTableViewLeft.separatorStyle = 0;
    _tagHalfTableViewRight.separatorStyle = 0;
    for (int i = 0; i < _tagViewArray.count; i++) {
        UIView* view = _tagViewArray[i];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagViewTapped:)];
        [view addGestureRecognizer:tap];
    }
}

- (void)tagViewTapped:(UITapGestureRecognizer*)tap
{
    if (self.tagViewShow) {
        [self hiddenAllTagView];
        return;
    }

    UIView* view = tap.view;
    if (view == _tagCategoryView) {
        if (_categoryDataSource.count <= 0) {
            return;
        }
        _currentTagDataSource = _categoryDataSource;
        [self showTagView:_tagTableView];
    } else if (view == _tagScoreView) {
        _currentTagDataSource = _scoreDataSource;
        [self showTagView:_tagTableView];
    } else if (view == _tagAreaView) {
        [self showTagView:_tagHalfTableViewLeft];
    } else if (view == _tagServiceView) {
        if (_serviceDataSource.count <= 0) {
            return;
        }
        _currentTagDataSource = _serviceDataSource;
        [self showTagView:_tagTableView];
    }
    self.tagViewShow = YES;
}

- (void)hiddenAllTagView
{
    [UIView animateWithDuration:0.25
        animations:^{
            _tagTableViewHeightConstraint.constant = 0;
            _tagHalfTableViewLeftHeightConstraint.constant = 0;
            _tagHalfTableViewRightHeightConstraint.constant = 0;
            [self.view layoutIfNeeded];
            _blackCoverView.alpha = 0;
        }
        completion:^(BOOL finished) {
            _blackCoverView.hidden = YES;
            _blackCoverView.alpha = 0.4;
            self.tagViewShow = NO;
        }];
}

- (void)showTagView:(UITableView*)tableView
{
    _blackCoverView.hidden = NO;
    [UIView animateWithDuration:0.1
        animations:^{
            _blackCoverView.alpha = 0.4;
        }
        completion:^(BOOL finished) {
            if (tableView == _tagTableView) {
                _tagHalfTableViewLeftHeightConstraint.constant = 0;
                _tagHalfTableViewRightHeightConstraint.constant = 0;

                [UIView animateWithDuration:0.25
                                 animations:^{
                                     _tagTableViewHeightConstraint.constant = kScreenHeight - 20 - 44 - 45;
                                     [self.view layoutIfNeeded];
                                 }
                                 completion:^(BOOL finished){

                                 }];
                [_tagTableView reloadData];
            } else if (tableView == _tagHalfTableViewLeft) {
                _tagTableViewHeightConstraint.constant = 0;

                [UIView animateWithDuration:0.25
                                 animations:^{
                                     _tagHalfTableViewLeftHeightConstraint.constant = kScreenHeight - 128;
                                     _tagHalfTableViewRightHeightConstraint.constant = kScreenHeight - 128;
                                     [self.view layoutIfNeeded];
                                 }
                                 completion:^(BOOL finished){

                                 }];
                [_tagHalfTableViewLeft reloadData];
            } else if (tableView == _tagHalfTableViewRight) {
                _tagTableViewHeightConstraint.constant = 0;
                [UIView animateWithDuration:0.25
                                 animations:^{
                                     _tagHalfTableViewRightHeightConstraint.constant = kScreenHeight - 128;
                                     [self.view layoutIfNeeded];
                                 }
                                 completion:^(BOOL finished){

                                 }];

                [_tagHalfTableViewRight reloadData];
            }
        }];
}

- (void)loadData
{
    NSString* urlString = [foodConsmerDomainBase stringByAppendingString:@"/ph/food/mainPage"];
    [GYGIFHUD show];

    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:urlString
                                                     parameters:_params
                                                  requestMethod:GYNetRequestMethodGET
                                              requestSerializer:GYNetRequestSerializerJSON
                                                   respondBlock:^(NSDictionary* responseObject, NSError* error) {
                                                       [GYGIFHUD dismiss];
                                                       if (error) {
                                                           [_shopTableView.mj_header endRefreshing];
                                                           [_shopTableView.mj_footer endRefreshing];
                                                           [_shopTableView reloadData];
                                                           if (_shopDataSource.count > 0) {
                                                               _shopTableView.tableFooterView = [[UIView alloc] init];
                                                               _shopTableView.mj_footer.hidden = NO;
                                                           } else if (_shopDataSource.count == 0) {
                                                               _shopTableView.tableFooterView = _noResultView;
                                                               _noResultView.hidden = !globalData.isOnNet ? YES : NO;
                                                               _shopTableView.mj_footer.hidden = YES;
                                                           } else {
                                                               _shopTableView.mj_footer.hidden = NO;
                                                           }
                                                           return;
                                                       }
                                                       [_shopTableView.mj_header endRefreshing];
                                                       [_shopTableView.mj_footer endRefreshing];
                                                       NSArray* modelArray = [FDMainModel modelArrayWithResponseObject:responseObject error:nil];
                                                       if (modelArray.count > 0) {
                                                           FDMainModel* model = modelArray.firstObject;
                                                           if (_categoryDataSource.count <= 0 && model.specialList.count > 0) {
                                                               [_categoryDataSource addObjectsFromArray:model.specialList];
                                                           }

                                                           [_shopDataSource addObjectsFromArray:model.shopList];
                                                       }
                                                       [_shopTableView reloadData];
                                                       if (_shopDataSource.count > 0) {
                                                           _shopTableView.tableFooterView = [[UIView alloc] init];
                                                           _shopTableView.mj_footer.hidden = NO;
                                                       } else if (_shopDataSource.count == 0) {
                                                           _shopTableView.tableFooterView = _noResultView;
                                                           _noResultView.hidden = !globalData.isOnNet ? YES : NO;
                                                           _shopTableView.mj_footer.hidden = YES;
                                                       } else {
                                                           _shopTableView.mj_footer.hidden = NO;
                                                       }

                                                       if (_currentPageIndex >= [[responseObject objectForKey:@"totalPage"] integerValue]) {
                                                           [_shopTableView.mj_footer endRefreshingWithNoMoreData];
                                                       } else {
                                                           [_shopTableView.mj_footer resetNoMoreData];
                                                       }
                                                   }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)loadServiceData
{
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:QueryDiningServicesUrl
                                                     parameters:nil
                                                  requestMethod:GYNetRequestMethodGET
                                              requestSerializer:GYNetRequestSerializerJSON
                                                   respondBlock:^(NSDictionary* responseObject, NSError* error) {
                                                       if (error) {
                                                           [GYUtils parseNetWork:error resultBlock:nil];
                                                           return;
                                                       }
                                                       NSArray* data = responseObject[@"data"];
                                                       if ([data isKindOfClass:[NSArray class]]) {
                                                           _serviceDataSource = [data mutableCopy];
                                                       }
                                                   }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)clearAndLoadData
{
    _currentPageIndex = 1;
    [_shopDataSource removeAllObjects];
    [self loadData];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _shopTableView) {
        return _shopDataSource.count;
    } else if (tableView == _tagTableView) {
        return _currentTagDataSource.count;
    } else if (tableView == _tagHalfTableViewLeft) {
        return _areaDataSource.count;
    } else if (tableView == _tagHalfTableViewRight) {
        return _locationDataSource.count;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    if (tableView == _shopTableView) {

        FDMainShopCell* shopCell = [tableView dequeueReusableCellWithIdentifier:FDMainShopCellId forIndexPath:indexPath];

        if (_shopDataSource.count > 0 && indexPath.row < [_shopDataSource count]) {
            shopCell.model = _shopDataSource[indexPath.row];
        }
        shopCell.selectionStyle = UITableViewCellSelectionStyleNone;

        return shopCell;
    } else if (tableView == _tagTableView && _currentTagDataSource == _categoryDataSource) {
        FDMainDropCategoryTableViewCell* categoryCell = [tableView dequeueReusableCellWithIdentifier:FDMainDropCategoryTableViewCellReuseId forIndexPath:indexPath];
        if (indexPath.row < [_categoryDataSource count]) {
            categoryCell.nameLabel.text = [_categoryDataSource[indexPath.row] objectForKey:@"specialName"];
        }

        categoryCell.nameLabel.font = [UIFont systemFontOfSize:15];
        categoryCell.choosed = NO;
        if ([categoryCell.nameLabel.text isEqualToString:_selectedCategory]) {
            categoryCell.choosed = YES;
        }
        return categoryCell;
    } else if (tableView == _tagTableView && _currentTagDataSource == _scoreDataSource) {
        FDMainDropScoreTableViewCell* scoreCell = [tableView dequeueReusableCellWithIdentifier:FDMainDropScoreTableViewCellReuseId forIndexPath:indexPath];
        scoreCell.score = indexPath.row;
        scoreCell.choosed = NO;
        if (_selectedScore && indexPath.row < _scoreDataSource.count && [_scoreDataSource[indexPath.row] isEqualToString:_selectedScore]) {
            scoreCell.choosed = YES;
        }
        return scoreCell;
    } else if (tableView == _tagTableView && _currentTagDataSource == _serviceDataSource) {
        FDMainDropServiceTableViewCell* serviceCell = [tableView dequeueReusableCellWithIdentifier:FDMainDropServiceTableViewCellReuseId forIndexPath:indexPath];
        NSString* key = nil;
        if (indexPath.row < _currentTagDataSource.count) {
            serviceCell.nameLabel.text = [_serviceDataSource[indexPath.row] objectForKey:@"value"];
            key = [_serviceDataSource[indexPath.row] objectForKey:@"key"];
        }
        if ([_supportService containsObject:key]) {
            serviceCell.choosed = YES;
        } else {
            serviceCell.choosed = NO;
        }
        serviceCell.tipImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"gyhe_food_service_%ld", indexPath.row + 1]];
        serviceCell.nameLabel.font = [UIFont systemFontOfSize:15];
        return serviceCell;
    } else if (tableView == _tagHalfTableViewLeft) {
        FDDropAreaTableViewCell* areaCell = [tableView dequeueReusableCellWithIdentifier:FDDropAreaTableViewCellReuseId forIndexPath:indexPath];
        FDAreaModel* model = nil;
        if (_areaDataSource.count > indexPath.row) {
            model = _areaDataSource[indexPath.row];
        }
        areaCell.areaLabel.text = model.areaName;
        areaCell.backgroundColor = [UIColor whiteColor];
        areaCell.areaLabel.textColor = [UIColor blackColor];

        if (_selectedArea == model.areaName) {
            areaCell.areaLabel.textColor = scoreRed;
            areaCell.backgroundColor = locationGray;
        }
        areaCell.selected = NO;
        return areaCell;
    } else if (tableView == _tagHalfTableViewRight) {
        FDDropAreaTableViewCell* locationCell = [tableView dequeueReusableCellWithIdentifier:FDDropAreaTableViewCellReuseId forIndexPath:indexPath];
        if (_locationDataSource.count > 0) {

            FDLocationModel* model = nil;
            if (indexPath.row < [_locationDataSource count]) {
                model = _locationDataSource[indexPath.row];
                locationCell.areaLabel.text = model.locationName;
            }
            locationCell.areaLabel.textColor = [UIColor darkGrayColor];
            locationCell.backgroundColor = locationGray;
            locationCell.arrowImgView.hidden = YES;
            if (_selectedLocation == model.locationName) {
                locationCell.areaLabel.textColor = scoreRed;
            }
            locationCell.selected = NO;
        }
        return locationCell;
    }
    return cell;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView == _tagTableView && _currentTagDataSource == _serviceDataSource) {
        return _serviceConfirmView;
    }
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == _tagTableView && _currentTagDataSource == _serviceDataSource) {
        return 50;
    }
    return 0.1;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (tableView == _shopTableView) {
        if (indexPath.row < [_shopDataSource count]) {
            FDSelectFoodViewController* chooseVC = [[FDSelectFoodViewController alloc] init];
            chooseVC.shopModel = _shopDataSource[indexPath.row];
            chooseVC.isTakeaway = NO;
            chooseVC.landMark = _landmark;
            [self.navigationController pushViewController:chooseVC animated:YES];
        }
    } else if (tableView == _tagTableView) {
        if (_currentTagDataSource == _categoryDataSource) {
            if (indexPath.row < [_categoryDataSource count]) {
                _tagCategoryLabel.text = [_categoryDataSource[indexPath.row] objectForKey:@"specialName"];
                [_params setObject:[_categoryDataSource[indexPath.row] objectForKey:@"specialId"] forKey:@"specialId"];
            }
            _selectedCategory = _tagCategoryLabel.text;
            _tagCategoryLabel.textColor = scoreRed;
            [tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            [_shopDataSource removeAllObjects];
            [self clearAndLoadData];
            [self hiddenAllTagView];
        }
        if (_currentTagDataSource == _scoreDataSource && _scoreDataSource.count > indexPath.row) {
            _selectedScore = _scoreDataSource[indexPath.row];
            [tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self setTagScoreViewWithScore:indexPath.row];
            [_params setObject:_selectedScore forKey:@"pointNum"];
            [_shopDataSource removeAllObjects];
            [self clearAndLoadData];
            [self hiddenAllTagView];
        }
        if (_currentTagDataSource == _serviceDataSource && _serviceDataSource.count > indexPath.row) {
            NSDictionary* dict = _serviceDataSource[indexPath.row];
            NSString* key = dict[@"key"];
            NSString* value = dict[@"value"];
            if ([_supportService containsObject:key]) {
                [_supportService removeObject:key];
                [_contentServiceArr removeObject:value];
            } else {
                [_supportService addObject:key];
                [_contentServiceArr addObject:value];
            }
            [tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } else if (tableView == _tagHalfTableViewLeft && _areaDataSource.count > indexPath.row) {
        FDAreaModel* areaModel = _areaDataSource[indexPath.row];
        if (indexPath.row == 0) {

            _selectedArea = areaModel.areaName;
            [tableView reloadData];
            [_locationDataSource removeAllObjects];
            NSArray* locationNames = @[ kLocalized(@"GYHE_Food_AllCity"), kLocalized(@"GYHE_Food_WithinFiveHundredMeters"), kLocalized(@"GYHE_Food_WithinOnekm"), kLocalized(@"GYHE_Food_WithinThreekm"), kLocalized(@"GYHE_Food_WithinFivekm"), kLocalized(@"GYHE_Food_WithinTenkm") ];
            for (int i = 0; i < locationNames.count; i++) {
                FDLocationModel* model = [[FDLocationModel alloc] init];
                model.locationName = locationNames[i];
                [_locationDataSource addObject:model];
            }
            [_tagHalfTableViewRight reloadData];
            [self showTagView:_tagHalfTableViewRight];
        } else {

            _selectedArea = areaModel.areaName;
            [tableView reloadData];
            [_locationDataSource removeAllObjects];
            NSString* urlString = [globalData.retailDomain stringByAppendingString:@"/shops/getLocation"];
            [FDLocationModel modelArrayNetURL:urlString
                parameters:@{ @"areaCode" : areaModel.areaCode }
                option:GYM_GetJson
                completion:^(NSArray* modelArray, id responseObject, NSError* error) {

                    [_locationDataSource addObjectsFromArray:modelArray];
                    [_tagHalfTableViewRight reloadData];
                }];

            [self showTagView:_tagHalfTableViewRight];
        }
    } else if (tableView == _tagHalfTableViewRight) {

        FDLocationModel* fLocationModel = nil;
        if (indexPath.row < [_locationDataSource count]) {
            fLocationModel = _locationDataSource[indexPath.row];
        }
        _selectedLocation = fLocationModel.locationName;
        [tableView reloadData];
        _tagAreaLabel.textColor = scoreRed;

        _tagAreaLabel.text = _selectedLocation;
        if (indexPath.row == 0 && ![_selectedArea isEqualToString:kLocalized(@"GYHE_Food_Nearby")]) {
            _tagAreaLabel.text = _selectedArea;
            [_params setObject:@"" forKey:@"areaName"];
            [_params setObject:_selectedArea forKey:@"area"];
            [_params setObject:@"" forKey:@"distance"];
            [_shopDataSource removeAllObjects];
            [self clearAndLoadData];
            [self hiddenAllTagView];
        } else if ([_selectedArea isEqualToString:kLocalized(@"GYHE_Food_Nearby")]) {
            NSArray* nearArray = @[ @"", @"0.5", @"1", @"3", @"5", @"10" ];
            [_params setObject:@"" forKey:@"areaName"];
            [_params setObject:@"" forKey:@"area"];
            [_params setObject:nearArray[indexPath.row] forKey:@"distance"];
            [_shopDataSource removeAllObjects];
            [self clearAndLoadData];
            [self hiddenAllTagView];
        } else {
            _tagAreaLabel.text = _selectedLocation;
            [_params setObject:_selectedLocation forKey:@"areaName"];
            [_params setObject:@"" forKey:@"distance"];
            [_shopDataSource removeAllObjects];
            [self clearAndLoadData];
            [self hiddenAllTagView];
        }

        // [_params setObject:[model.locationName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]  forKey:@"areaName"];
    }
}

- (IBAction)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBtnClicked:(id)sender
{
    FDSearchShopViewController* vc = [[FDSearchShopViewController alloc] init];
    vc.landmark = _params[@"landmark"];
    [vc.backBtn setTitle:kLocalized(@"GYHE_Food_Restaurant") forState:UIControlStateNormal];

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setTagScoreViewWithScore:(NSInteger)score
{
    NSArray* scoreStr = @[ kLocalized(@"GYHE_Food_Excellent"), kLocalized(@"GYHE_Food_Fine"), kLocalized(@"GYHE_Food_Recommend"), kLocalized(@"GYHE_Food_Proposal"), kLocalized(@"GYHE_Food_Common") ];
    _scoreLabel.text = scoreStr[score];
    _scoreLabel.textColor = scoreRed;
    UIImage* image0 = [UIImage imageNamed:@"gyhe_food_flower1"];
    UIImage* image1 = [UIImage imageNamed:@"gyhe_food_flower2"];
    UIImage* image2 = [UIImage imageNamed:@"gyhe_food_flower3"];

    switch (score) {
    case 0:
        _scoreImageView0.image = image0;
        _scoreImageView1.image = image0;
        _scoreImageView2.image = image0;
        break;
    case 1:
        _scoreImageView0.image = image0;
        _scoreImageView1.image = image0;
        _scoreImageView2.image = image1;
        break;
    case 2:
        _scoreImageView0.image = image0;
        _scoreImageView1.image = image0;
        _scoreImageView2.image = image2;
        break;
    case 3:
        _scoreImageView0.image = image0;
        _scoreImageView1.image = image1;
        _scoreImageView2.image = image2;
        break;
    case 4:
        _scoreImageView0.image = image0;
        _scoreImageView1.image = image2;
        _scoreImageView2.image = image2;
        break;

    default:
        _scoreImageView0.image = image2;
        _scoreImageView1.image = image2;
        _scoreImageView2.image = image2;
        break;
    }
}

- (IBAction)serviceConfirmBtnClicked:(id)sender
{
    NSString* supportService = @"";
    for (int i = 0; i < _supportService.count; i++) {
        supportService = [supportService stringByAppendingString:_supportService[i]];
        if (i < _supportService.count - 1) {
            supportService = [supportService stringByAppendingString:@","];
        }
    }
    [_params setObject:supportService forKey:@"supportService"];
    [_shopDataSource removeAllObjects];
    [self clearAndLoadData];
    [self hiddenAllTagView];

    if (_contentServiceArr.count > 0) {
        NSString* filtrationStr = [_contentServiceArr componentsJoinedByString:@","];
        self.selectLabel.text = filtrationStr;
        self.selectLabel.textColor = scoreRed;
    } else {
        self.selectLabel.text = kLocalized(@"GYHE_Food_Filter");
        self.selectLabel.textColor = kCorlorFromRGBA(129, 129, 129, 1);
    }
}
#pragma mark 获取市的代理方法
- (NSArray*)getCityArray
{

    //将文字转化为areaCode
    //    NSString *cityAreaCode;
    NSString* path = [[NSBundle mainBundle] pathForResource:@"cityLists" ofType:@"txt"];
    NSData* jsonData = [NSData dataWithContentsOfFile:path];
    NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray* cityArr = [[NSMutableArray alloc] init];
    for (NSDictionary* tempDic in dict1[@"data"]) {
        FDCityModel* cityModel = [[FDCityModel alloc] init];
        //        [cityModel setValuesForKeysWithDictionary:tempDic];
        cityModel.areaName = tempDic[@"areaName"];
        cityModel.areaCode = tempDic[@"areaCode"];
        cityModel.enName = tempDic[@"enName"];
        cityModel.parentCode = kSaftToNSString(tempDic[@"parentCode"]);
        cityModel.sortOrder = kSaftToNSString(tempDic[@"sortOrder"]);
        [cityArr addObject:cityModel];
    }

    return cityArr;
}
- (NSArray*)getAreaArray
{

    //将文字转化为areaCode
    //    NSString *cityAreaCode;
    NSString* path = [[NSBundle mainBundle] pathForResource:@"districtlist" ofType:@"txt"];
    NSData* jsonData = [NSData dataWithContentsOfFile:path];
    NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray* areaArr = [[NSMutableArray alloc] init];
    for (NSDictionary* tempDic in dict1[@"data"]) {
        FDAreaModel* model = [[FDAreaModel alloc] init];
        //        [cityModel setValuesForKeysWithDictionary:tempDic];
        model.areaName = tempDic[@"areaName"];
        model.areaCode = tempDic[@"areaCode"];
        model.enName = tempDic[@"enName"];
        model.parentCode = kSaftToNSString(tempDic[@"parentCode"]);
        model.sortOrder = kSaftToNSString(tempDic[@"sortOrder"]);
        [areaArr addObject:model];
    }
    
    return areaArr;
}


@end
