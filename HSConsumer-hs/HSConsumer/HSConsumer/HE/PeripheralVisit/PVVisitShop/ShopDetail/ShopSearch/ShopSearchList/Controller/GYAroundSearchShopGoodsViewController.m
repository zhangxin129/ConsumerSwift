//
//  GYAroundSearchShopGoodsViewController.m
//  HSConsumer
//
//  Created by apple on 15/8/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define GoodCellReuseId @"GoodCellReuseId"
#define GYSearchShopGoodsHistoryUserDefaultsKey @"GYSearchShopGoodsHistoryUserDefaultsKey"
#import "GYAroundSearchShopGoodsViewController.h"
#import "GYStoreTableViewCell.h"
#import "GYShopGoodListModel.h"
#import "SearchGoodModel.h"
#import "GYAroundShopsSearchCategoryController.h"
#import "GYArroundGoodDetailViewController.h"
#import "GYSearchShopGoodsHistoryViewController.h"
#import "GYGIFHUD.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface GYAroundSearchShopGoodsViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, StoreTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet UIView* headerView;
@property (weak, nonatomic) IBOutlet UIButton* tagZH;
@property (weak, nonatomic) IBOutlet UIButton* tagJF;
@property (weak, nonatomic) IBOutlet UIButton* tagXL;
@property (weak, nonatomic) IBOutlet UIButton* tagJG;
@property (weak, nonatomic) IBOutlet UIButton* tagHP;
@property (weak, nonatomic) IBOutlet UIView* sliderView;
@property (weak, nonatomic) IBOutlet UIView* noResultView0;
@property (weak, nonatomic) IBOutlet UIView* noResultView1;
@property (weak, nonatomic) IBOutlet UIView* noResultView2;
@property (weak, nonatomic) IBOutlet UIView* noResultView3;
@property (weak, nonatomic) IBOutlet UIView* noResultView4;
@property (strong, nonatomic) NSArray* noResultViews;

@property (strong, nonatomic) UITableView* tableViewZH;
@property (strong, nonatomic) UITableView* tableViewJF;
@property (strong, nonatomic) UITableView* tableViewXL;
@property (strong, nonatomic) UITableView* tableViewJG;
@property (strong, nonatomic) UITableView* tableViewHP;
@property (strong, nonatomic) NSArray* tableViews;
@property (strong, nonatomic) NSMutableArray* dataSourceZH;
@property (strong, nonatomic) NSMutableArray* dataSourceJF;
@property (strong, nonatomic) NSMutableArray* dataSourceXL;
@property (strong, nonatomic) NSMutableArray* dataSourceJG;
@property (strong, nonatomic) NSMutableArray* dataSourceHP;
@property (strong, nonatomic) NSArray* dataSources;
@property (strong, nonatomic) NSArray* tagBtns;
@property (strong, nonatomic) NSMutableArray* dataSource;
@property (strong, nonatomic) NSMutableArray* searchHistoryDataSource;
@property (strong, nonatomic) UITextField* searchField;
@property (assign, nonatomic) int currentIndex;
@property (strong, nonatomic) UIBarButtonItem* leftBtn;
@property (strong, nonatomic) UIBarButtonItem* rightBtn;
@property (strong, nonatomic) UIBarButtonItem* rightCategoryBtn;
@property (strong, nonatomic) NSMutableArray* searchHistory;
@property (strong, nonatomic) UITableView* searchHistoryTable;
@property (strong, nonatomic) UIButton* clearBtn;
@property (strong, nonatomic) NSMutableArray* tableCurrentPages;
@property (assign, nonatomic) NSInteger currentTotalPages;
//国际化
@property (weak, nonatomic) IBOutlet UILabel* noSearchReasultOneLabel; //无搜索结果
@property (weak, nonatomic) IBOutlet UILabel* noSearchReasultTwoLabel;
@property (strong, nonatomic) IBOutlet UILabel* noSearchReasultThrLabel;
@property (weak, nonatomic) IBOutlet UILabel* noSearchReasultFourLabel;
@property (weak, nonatomic) IBOutlet UILabel* noSearchReasultFiveLabel;
@property (strong, nonatomic) IBOutlet UIView* noSearchResultView;

@end

@implementation GYAroundSearchShopGoodsViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNav];
    NSArray* history = [[NSUserDefaults standardUserDefaults] objectForKey:GYSearchShopGoodsHistoryUserDefaultsKey];
    if (history) {
        _searchHistory = [NSMutableArray arrayWithArray:history];
    }
    else {
        _searchHistory = [NSMutableArray array];
    }
    _tableCurrentPages = [NSMutableArray arrayWithArray:@[ @"1", @"1", @"1", @"1", @"1" ]];
    
    _currentIndex = 0;
    [self.view addSubview:_headerView]; //白酒
    _scrollView.delegate = self;
    [self setupTableView];
    _params = [[NSMutableDictionary alloc] init];
    if (_categoryName && _categoryName.length > 0) {
        [_params setObject:_categoryName forKey:@"categoryName"];
    }
    if (_brandName && _brandName.length > 0) {
        [_params setObject:_brandName forKey:@"brandName"];
    }
    if (_categoryId && _categoryId.length > 0) {
        [_params setObject:_categoryId forKey:@"categoryId"];
    }
    [_params setObject:self.vshopId forKey:@"vShopId"];
    [_params setObject:@"10" forKey:@"count"];
    
    self.tagBtns = @[ _tagZH, _tagJF, _tagXL, _tagHP, _tagJG ];
    [self.tagZH setTitle:kLocalized(@"GYHE_SurroundVisit_Comprehensive") forState:UIControlStateNormal];
    [self.tagJF setTitle:kLocalized(@"GYHE_SurroundVisit_PV") forState:UIControlStateNormal];
    [self.tagXL setTitle:kLocalized(@"GYHE_SurroundVisit_SalesVolume") forState:UIControlStateNormal];
    [self.tagHP setTitle:kLocalized(@"GYHE_SurroundVisit_GoodComments") forState:UIControlStateNormal];
    [self.tagJG setTitle:kLocalized(@"GYHE_SurroundVisit_Price") forState:UIControlStateNormal];
    self.noSearchReasultOneLabel.text = kLocalized(@"GYHE_SurroundVisit_CommodityDataTemporarily");
    self.noSearchReasultTwoLabel.text = kLocalized(@"GYHE_SurroundVisit_CommodityDataTemporarily");
    self.noSearchReasultThrLabel.text = kLocalized(@"GYHE_SurroundVisit_CommodityDataTemporarily");
    self.noSearchReasultFourLabel.text = kLocalized(@"GYHE_SurroundVisit_CommodityDataTemporarily");
    self.noSearchReasultFiveLabel.text = kLocalized(@"GYHE_SurroundVisit_CommodityDataTemporarily");
    
    if (self.isNeedLoad) {
        [self loadDataAll];
    }
    [self setupTagButtons];
    
    for (int i = 0; i < 5; i++) {
        if(_tableViews.count>i && _dataSources.count >i && _noResultViews.count > i) {
            UITableView* table = _tableViews[i];
            NSMutableArray* array = _dataSources[i];
            if (!array || array.count < 1) {
                table.tableFooterView = _noResultViews[i];
                table.mj_footer.hidden = YES;
            }
            else {
                table.tableFooterView = nil;
                table.mj_footer.hidden = NO;
                [self setupNavCategoryRightBtn];
            }
        }
        
    }
    
    [self.view addSubview:self.noSearchResultView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = kNavigationBarColor;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


#pragma mark - SystemDelegate

#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (scrollView == _scrollView) {
        CGFloat OffsetX = scrollView.contentOffset.x;
        int index = (OffsetX + (kScreenWidth / 2)) / kScreenWidth;
        
        if(_tagBtns.count > index)
            [self tagBtnClickedWithoutScroll:_tagBtns[index] animated:YES];
    }
}

#pragma mark UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    return YES;
}

#pragma mark TableView Delegate
#pragma mark UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _searchHistoryTable) {
        return _searchHistory.count;
    }
    for (int i = 0; i < 5; i++) {
        if(_dataSources.count > i && _tableViews.count > i) {
            NSMutableArray* array = _dataSources[i];
            if (tableView == _tableViews[i]) {
                
                return (array.count + 1) / 2;
            }
        }
        
    }
    return 0;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView == _searchHistoryTable) {
        _clearBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _clearBtn.frame = CGRectMake(0, 0, 100, 30);
        [_clearBtn setTitle:kLocalized(@"GYHE_SurroundVisit_ClearSearchHistory") forState:UIControlStateNormal];
        
        [_clearBtn addTarget:self action:@selector(clearBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_clearBtn setBackgroundColor:_searchField.backgroundColor];
        [_clearBtn setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
        return _clearBtn;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == _searchHistoryTable) {
        return 30;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (tableView == _searchHistoryTable) {
        int row = (int)indexPath.row;
        int count = (int)_searchHistory.count;
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchHistoryCell"];
        cell.textLabel.text = _searchHistory[count - row - 1];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.backgroundColor = _searchField.backgroundColor;
        return cell;
    }
    GYStoreTableViewCell* cell = [GYStoreTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (int i = 0; i < 5; i++) {
        if(_dataSources.count > i && _tableViews.count > i) {
            NSMutableArray* array = _dataSources[i];
            if (tableView == _tableViews[i]) {
                NSUInteger count = array.count;
                NSInteger row = indexPath.row;
                
                long left = row * 2;
                long right = row * 2 + 1;
                if (left < count  && array.count > left) {
                    cell.leftModel = array[left];
                    cell.leftView.tag = 70000 + left;
                }
                if (right < count && array.count > right) {
                    cell.rightModel = array[right];
                    cell.rightView.tag = 70000 + right;
                }
                cell.backgroundColor = kDefaultVCBackgroundColor;
            }
        }
        
    }
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (tableView == _searchHistoryTable) {
        return 30;
    }
    return 250;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _searchHistoryTable) {
        if(_searchHistory.count > indexPath.row) {
            NSString* searchText = _searchHistory[indexPath.row];
            _searchField.text = searchText;
            [_params setObject:searchText forKey:@"keyword"];
            [_params setObject:@"" forKey:@"categoryName"];
            [self loadDataAll];
            [self hiddenHistoryTable];
            [_searchField endEditing:YES];
        }
        
    }
}


#pragma mark - CustomDelegate

#pragma mark StoreTableViewCellDelegate
- (void)StoreTableView:(GYStoreTableViewCell*)cell chooseOne:(NSInteger)type model:(GYShopGoodListModel*)model
{
    [self loadHotGoodInfoWithItemid:model.itemId vShopid:self.vshopId shopID:model.shopId];
}

#pragma mark - event response
- (void)pushToSearchView:(UIButton*)btn
{
    GYSearchShopGoodsHistoryViewController* searchVC = [[GYSearchShopGoodsHistoryViewController alloc] init];
    searchVC.delegate = self;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)clearBtnClicked:(UIButton*)btn
{
    [_searchHistory removeAllObjects];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GYSearchShopGoodsHistoryUserDefaultsKey];
    [self hiddenHistoryTable];
}

- (void)tagBtnClicked:(UIButton*)btn animated:(BOOL)animate
{
    for (int i = 0; i < 5; i++) {
        if(self.tagBtns.count > i) {
            UIButton* button = self.tagBtns[i];
            button.selected = NO;
            if (btn == button) {
                _currentIndex = i;
            }
        }
        
    }
    btn.selected = YES;
    CGRect frame = _scrollView.frame;
    frame.origin.x = kScreenWidth * _currentIndex;
    [_scrollView scrollRectToVisible:frame animated:YES];
}

- (void)backBtnClicked:(UIBarButtonItem*)btn
{
    [_searchField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBtnClicked:(UIBarButtonItem*)btn
{
    NSString* keyword = _searchField.text;
    if (keyword && keyword.length > 0) {
        int k = 0;
        for (; k < _searchHistory.count; k++) {
            NSString* str = _searchHistory[k];
            if ([str isEqualToString:keyword]) {
                break;
            }
        }
        if (k >= _searchHistory.count) {
            [_searchHistory addObject:keyword];
            [[NSUserDefaults standardUserDefaults] setObject:_searchHistory forKey:GYSearchShopGoodsHistoryUserDefaultsKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [_searchHistoryTable reloadData];
        }
        
        [_params setObject:keyword forKey:@"keyword"];
    }
    else {
        [_params setObject:@"" forKey:@"keyword"];
    }
    
    [_params setObject:@"" forKey:@"categoryName"];
    [self hiddenHistoryTable];
    [self loadDataAll];
    for (int i = 0; i < 5; i++) {
        if(_tableViews.count > i)
            [((UITableView*)_tableViews[i])reloadData];
    }
    [_searchField endEditing:YES];
}

- (void)categoryBtnClicked:(UIBarButtonItem*)btn
{
    NSString* searchText = _searchField.text;
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!searchText || searchText.length < 1) {
        [_params setObject:@"" forKey:@"keyword"];
    }
    GYAroundShopsSearchCategoryController* vcCategory = [[GYAroundShopsSearchCategoryController alloc] init];
    vcCategory.strShopID = self.vshopId;
    
    vcCategory.CompletionBlock = ^(NSString* str, NSString* catId) {
        _categoryName = str;
        _categoryId = catId;
        [_params setObject:_categoryName forKey:@"categoryName"];
        [_params setObject:_categoryId forKey:@"categoryId"];
        if (_categoryName && _categoryName.length > 0) {
            [_params setObject:_categoryName forKey:@"categoryName"];
        }
        [self loadDataAll];
    };
    [self.navigationController pushViewController:vcCategory animated:YES];
}

#pragma mark - private methods
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupTagButtons
{
    for (int i = 0; i < self.tagBtns.count; i++) {
        UIButton* btn = self.tagBtns[i];
        if (i == 0) {
            btn.selected = YES;
        }
        [btn setTitleColor:kNavigationBarColor forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(tagBtnClicked:animated:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTintColor:[UIColor clearColor]];
    }
}

- (void)setupNavLeftBtn
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"gyhd_nav_leftView_back"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 40, 20);
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    _leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = _leftBtn;
    [btn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupNavCategoryRightBtn
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"gyhe_type_shop_rightbarbutton_red"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 60, 20);
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    _rightCategoryBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = _rightCategoryBtn;
    [btn addTarget:self action:@selector(categoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupNav
{
    [self setupNavLeftBtn];
    [self setupNavCategoryRightBtn];
    
    _searchField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 30, 38)];
    _searchField.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1.0f];
    UILabel* placeholderlb = [[UILabel alloc] initWithFrame:CGRectMake(_searchField.frame.size.width / 6, 4, 120, 30)];
    placeholderlb.text = kLocalized(@"GYHE_SurroundVisit_SearchStoreGoods");
    placeholderlb.textColor = kCellItemTextColor;
    placeholderlb.font = [UIFont systemFontOfSize:16.0];
    [_searchField addSubview:placeholderlb];
    UIImageView* leftSearchIV = [[UIImageView alloc] initWithFrame:CGRectMake(placeholderlb.frame.origin.x - 22, 13, 20, 12)];
    leftSearchIV.image = [UIImage imageNamed:@"gycommon_search_gray"];
    leftSearchIV.contentMode = UIViewContentModeScaleAspectFit;
    [_searchField addSubview:leftSearchIV];
    _searchField.leftViewMode = UITextFieldViewModeAlways;
    _searchField.textColor = [UIColor grayColor];
    _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchField.keyboardType = UIKeyboardTypeDefault;
    _searchField.returnKeyType = UIReturnKeySearch;
    
    self.navigationItem.titleView = _searchField;
    
    UIButton* tempBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    CGRect tempFrame = _searchField.frame;
    tempFrame.origin.x = 0;
    tempFrame.origin.y = 0;
    tempBtn.frame = tempFrame;
    
    [tempBtn addTarget:self action:@selector(pushToSearchView:) forControlEvents:UIControlEventTouchUpInside];
    [_searchField addSubview:tempBtn];
    
}

- (void)setupTableView
{
    _dataSource = [[NSMutableArray alloc] init];
    _searchHistoryDataSource = [[NSMutableArray alloc] init];
    _dataSourceZH = [[NSMutableArray alloc] init];
    _dataSourceJF = [[NSMutableArray alloc] init];
    _dataSourceXL = [[NSMutableArray alloc] init];
    _dataSourceJG = [[NSMutableArray alloc] init];
    _dataSourceHP = [[NSMutableArray alloc] init];
    
    _dataSources = @[ _dataSourceZH, _dataSourceJF, _dataSourceXL, _dataSourceHP, _dataSourceJG ];
    
    _tableViewZH = [[UITableView alloc] initWithFrame:CGRectMake(0, 35, kScreenWidth, kScreenHeight - 100)];
    _tableViewJF = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 35, kScreenWidth, kScreenHeight - 100)];
    _tableViewXL = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth * 2, 35, kScreenWidth, kScreenHeight - 100)];
    _tableViewHP = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth * 3, 35, kScreenWidth, kScreenHeight - 100)];
    _tableViewJG = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth * 4, 35, kScreenWidth, kScreenHeight - 100)];
    _tableViews = @[ _tableViewZH, _tableViewJF, _tableViewXL, _tableViewHP, _tableViewJG ];
    _noResultViews = @[ _noResultView0, _noResultView1, _noResultView2, _noResultView3, _noResultView4 ];
    for (int i = 0; i < 5; i++) {
        if(_tableViews.count > i) {
            UITableView* table = _tableViews[i];
            [_scrollView addSubview:table];
            table.dataSource = self;
            table.delegate = self;
            if ([table respondsToSelector:@selector(setSeparatorInset:)]) {
                [table setSeparatorInset:UIEdgeInsetsZero];
            }
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            [table registerNib:[UINib nibWithNibName:NSStringFromClass([GYStoreTableViewCell class]) bundle:nil] forCellReuseIdentifier:GoodCellReuseId];
            
            WS(weakSelf);
            GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
                //        请求数据
                [weakSelf loadDataWithIndex:_currentIndex preClear:YES params:_params];
            }];
            
            GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
                
                [weakSelf loadNextPageTableIndex:i];
                
            }];
            
            //    设定表格视图 头部 尾部
            table.mj_header = header;
            table.mj_footer = footer;
            
            [table.mj_footer resetNoMoreData];
        }
        
    }
    
    _scrollView.contentSize = CGSizeMake(kScreenWidth * 5, kScreenHeight - 65);
    _scrollView.pagingEnabled = YES;
    CGRect frame = CGRectMake(60, 0, 100, 0);
    _searchHistoryTable = [[UITableView alloc] initWithFrame:frame];
    
    _searchHistoryTable.delegate = self;
    _searchHistoryTable.dataSource = self;
    _searchHistoryTable.scrollEnabled = YES;
    _searchHistoryTable.bounces = NO;
    
}

- (void)tagBtnClickedWithoutScroll:(UIButton*)btn animated:(BOOL)animate
{
    for (int i = 0; i < 5; i++) {
        if(self.tagBtns.count > i) {
            UIButton* button = self.tagBtns[i];
            button.selected = NO;
            if (btn == button) {
                _currentIndex = i;
            }
        }
        
    }
    btn.selected = YES;
    [UIView animateWithDuration:0.1f animations:^{
        CGPoint center = self.sliderView.center;
        center.x = btn.center.x;
        self.sliderView.center = center;
    }];
}

- (void)hiddenHistoryTable
{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = _searchHistoryTable.frame;
        frame.size.height = 0;
        _searchHistoryTable.frame = frame;
    }];
}

- (void)showHistoryTable
{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = _searchHistoryTable.frame;
        
        frame.size.height = _searchHistory.count*30+30;
        if (_searchHistory.count == 0) {
            frame.size.height = 0;
        }
        if (_searchHistory.count >= 5) {
            frame.size.height = 5*30+30;
        }
        frame.size.width = _searchField.frame.size.width;
        _searchHistoryTable.frame = frame;
    }];
}

- (void)loadDataAll
{
    
    for (int i = 0; i < 5; i++) {
        [self loadDataWithIndex:i preClear:YES params:_params];
        if(_tableCurrentPages.count > i)
            _tableCurrentPages[i] = @"0";
    }
}

- (void)loadDataWithIndex:(NSInteger)index preClear:(BOOL)preClear params:(NSMutableDictionary*)params
{
    NSInteger tempIndex = index;
    if (tempIndex == 3) {
        tempIndex = 4;
    }
    else if (tempIndex == 4) {
        tempIndex = 3;
    }
    
    [params setObject:@(tempIndex).stringValue forKey:@"sortType"];
    [self loadDataFromNetWorkWithParams:params Complection:^(NSArray* goodsList, NSError* error) {
        
        if(_dataSources.count <= index) {
            return ;
        }
        if (preClear) {
            [_dataSources[index] removeAllObjects];
            if(_tableCurrentPages.count > index)
                _tableCurrentPages[index] = @"1";
        }
        [_dataSources[index] addObjectsFromArray:goodsList];
        [self isRemoveNoSearchResultView];
        if(_tableViews.count > index) {
            UITableView *table = _tableViews[index];
            NSMutableArray *array = _dataSources[index];
            if (!array || array.count < 1) {
                if(_noResultViews.count > index)
                    table.tableFooterView = _noResultViews[index];
                table.mj_footer.hidden = YES;
            } else {
                table.tableFooterView = nil;
                table.mj_footer.hidden = NO;
                [self setupNavCategoryRightBtn];
            }
            [table reloadData];
            [table.mj_header endRefreshing];
            
            if(_tableCurrentPages.count > index) {
                if ([_tableCurrentPages[index] integerValue] >= _currentTotalPages) {
                    [table.mj_footer endRefreshingWithNoMoreData];
                    
                } else {
                    [table.mj_footer resetNoMoreData];
                }

            }
            
        }
    }];
}

- (void)loadNextPageTableIndex:(NSInteger)index
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:_params];
    if(_tableCurrentPages.count > index) {
        NSInteger tableCurrentPage = [_tableCurrentPages[index] integerValue];
        
        tableCurrentPage++;
        _tableCurrentPages[index] = [@(tableCurrentPage) stringValue];
        [params setObject:_tableCurrentPages[index] forKey:@"currentPage"];
        [self loadDataWithIndex:index preClear:NO params:params];
    }
    
}

- (void)loadHotGoodInfoWithItemid:(NSString*)itemid vShopid:(NSString*)vShopid shopID:(NSString*)shopID
{
    __block SearchGoodModel* MOD;
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if (globalData.loginModel.token == nil) {
        [dict setValue:@"" forKey:@"key"];
    }
    else {
        [dict setValue:globalData.loginModel.token forKey:@"key"];
    }
    [dict setValue:[NSString stringWithFormat:@"%@", shopID] forKey:@"shopId"];
    [dict setValue:[NSString stringWithFormat:@"%@", itemid] forKey:@"itemId"];
    [dict setValue:[NSString stringWithFormat:@"%@", vShopid] forKey:@"vShopId"];
    
    [GYGIFHUD show];
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GetGoodsInfoUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        [GYGIFHUD dismiss];
        if (!error) {
            NSDictionary *ResponseDic = responseObject;
            if (!error) {
                
                NSString *retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];
                
                if ([retCode isEqualToString:@"200"]) {
                    NSDictionary *tempDic = ResponseDic[@"data"];
                    MOD = [[SearchGoodModel alloc] init];
                    MOD.name = kSaftToNSString(tempDic[@"itemName"]);
                    MOD.addr = kSaftToNSString(tempDic[@"addr"]);
                    MOD.beCash = kSaftToNSString(tempDic[@"beCash"]);
                    MOD.beReach = kSaftToNSString(tempDic[@"beReach"]);
                    MOD.beSell = kSaftToNSString(tempDic[@"beSell"]);
                    MOD.beTake = kSaftToNSString(tempDic[@"beTake"]);
                    MOD.beTicket = kSaftToNSString(tempDic[@"beTicket"]);
                    MOD.goodsId = kSaftToNSString(tempDic[@"id"]);
                    NSNumber *lat = tempDic[@"lat"];
                    MOD.shoplat = [NSString stringWithFormat:@"%f", [lat floatValue]];
                    NSNumber *longitude = tempDic[@"longitude"];
                    MOD.shoplongitude = [NSString stringWithFormat:@"%f", [longitude floatValue]];
                    MOD.shopsName = kSaftToNSString(tempDic[@"name"]);;
                    NSNumber *price = tempDic[@"price"];
                    MOD.price = [NSString stringWithFormat:@"%0.02f", [price floatValue]];
                    NSNumber *pv = tempDic[@"pv"];
                    MOD.goodsPv = [NSString stringWithFormat:@"%.02f", [pv floatValue]];
                    MOD.shopId = kSaftToNSString(tempDic[@"shopId"]);
                    
                    MOD.moonthlySales = kSaftToNSString(tempDic[@"monthlySales"]);
                    MOD.saleCount = kSaftToNSString(tempDic[@"salesCount"]);
                    if ([kSaftToNSString(tempDic[@"tel"]) length] > 0) {
                        MOD.shopTel = kSaftToNSString(tempDic[@"tel"]);
                    } else {
                        MOD.shopTel = @" ";
                    }
                    
                    
                    MOD.vShopId = kSaftToNSString(tempDic[@"vShopId"]);
                    MOD.shopSection = kSaftToNSString(tempDic[@"area"]);
                    
                    CLLocationCoordinate2D shopCoordinate;
                    shopCoordinate.latitude = MOD.shoplat.floatValue;
                    shopCoordinate.longitude = MOD.shoplongitude.floatValue;
                    BMKMapPoint mp2 = BMKMapPointForCoordinate(shopCoordinate);
                    BMKMapPoint mp1 = BMKMapPointForCoordinate(globalData.locationCoordinate);
                    CLLocationDistance dis = BMKMetersBetweenMapPoints(mp1, mp2);
                    DDLogDebug(@"%f-----dis,mp1.x = %f,mp1.y = %f", dis, mp1.x, mp1.y);
                    MOD.shopDistance = [NSString stringWithFormat:@"%.01f", dis/1000];
                }
            } else {
                [GYUtils parseNetWork:error resultBlock:nil];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            
            
        } else {
            [GYUtils parseNetWork:error resultBlock:nil];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        [GYUtils hideHudViewWithSuperView:self.navigationController.view];
        GYArroundGoodDetailViewController *vcGoodDetail = [[GYArroundGoodDetailViewController alloc] initWithNibName:NSStringFromClass([GYArroundGoodDetailViewController class]) bundle:nil];
        vcGoodDetail.model = MOD;
        [self.navigationController pushViewController:vcGoodDetail animated:YES];
    }];
    [request start];
}

- (void)loadDataFromNetWorkWithParams:(NSDictionary*)params Complection:(CompletionBlock)block
{
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:SearchShopItemUrl parameters:params requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        NSError *jsonError;
        NSMutableArray *goodsList = [[NSMutableArray alloc] init];
        [GYGIFHUD dismiss];
        if(error) {
            [GYUtils parseNetWork:error resultBlock:nil];
        }else {
            if (responseObject) {
                
                NSDictionary *rootDict = responseObject;
                if (jsonError == nil) {
                    NSArray *datas = rootDict[@"data"];
                    
                    if ([rootDict[@"data"] isKindOfClass:[NSNull class]]) {
                        block(nil, nil);
                        return;
                        
                    }
                    _currentTotalPages = [rootDict[@"totalPage"] integerValue];
                    if ([datas isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *item in datas) {
                            GYShopGoodListModel *model = [[GYShopGoodListModel alloc] initWithDictionary:item error:nil];
                            [goodsList addObject:model];
                        }
                        block(goodsList, nil);
                    }
                }
            }
        }
        
    }];
    [request start];
}

- (void)isRemoveNoSearchResultView
{
    BOOL isRemove = NO;
    if (self.dataSources && self.dataSources.count > 0) {
        for (NSArray* array in self.dataSources) {
            if (array && array.count > 0) {
                isRemove = YES;
            }
        }
        if (isRemove) {
            [self.noSearchResultView removeFromSuperview];
        }
        else {
            [self.view addSubview:self.noSearchResultView];
        }
    }else{
        [self.view addSubview:self.noSearchResultView];
    }
}

#pragma mark - getters and setters

@end
