//
//  FDSearchShopAndFoodViewController.m
//  HSConsumer
//
//  Created by apple on 15/12/18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "FDSearchShopAndFoodViewController.h"
#import "FDTakeawayMainViewController.h"
#import "PopoverView.h"
#import "FDShopModel.h"
#import "GYsearchHistoryFrameModel.h"
#import "GYseachhistoryModel.h"
#import "GYsearchHistoryCell.h"
#import "FDFoodDetailModel.h"

#import "FDTakeawayMainCell.h"
#import "FDSelectFoodViewController.h"
#import "FDSearchFoodsModel.h"
#import "FDSearchFoodsCell.h"
#import "GYGIFHUD.h"
#define FDTakeawayMainCellId @"FDTakeawayMainCellId"
#define FDSearchFoodsCellId @"FDSearchFoodsCellId"
@interface FDSearchShopAndFoodViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray* datas; //数据源
//导航栏相关
@property (nonatomic, strong) UIView* vTitleView;
@property (nonatomic, strong) UITextField* tfInputSearchText;
@property (nonatomic, assign) NSInteger seachType; //0 餐厅  1 菜品
@property (nonatomic, weak) UITableView* tableViewSearch;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, weak) UIView* vSearch;
@property (strong, nonatomic) NSMutableDictionary* params;
@property (strong, nonatomic) NSMutableDictionary* itemParams;
@property (assign, nonatomic) NSInteger currentPageIndex;
@property (nonatomic, strong) NSMutableArray* historyArry;
@property (nonatomic, weak) UITableView* tableViewHistory; //搜索历史

@end

@implementation FDSearchShopAndFoodViewController
#pragma mark - 系统方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    self.navigationController.navigationBar.barTintColor = kNavigationBarColor;

    [self.tfInputSearchText resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _datas = [NSMutableArray array];
    [self setup];
    [self setNav];
    [self initParams];
    [self initItemsParams];
}

#pragma mark - 自定义方法
- (void)initParams
{
    _currentPageIndex = 1;
    self.seachType = 1;
    _params = [[NSMutableDictionary alloc] init];
    [_params setObject:@(_currentPageIndex).stringValue forKey:@"currentPageIndex"];
    [_params setObject:@"10" forKey:@"pageSize"];
    [_params setObject:@"" forKey:@"keyword"];
    [_params setObject:_landmark forKey:@"landmark"];
    [_params setObject:@"2" forKey:@"type"];
}

- (void)initItemsParams
{

    _currentPageIndex = 1;
    _itemParams = [[NSMutableDictionary alloc] init];
    [_itemParams setObject:@(_currentPageIndex).stringValue forKey:@"currentPageIndex"];
    [_itemParams setObject:@"10" forKey:@"pageSize"];
    [_itemParams setObject:@"" forKey:@"keyword"];
    [_itemParams setObject:_landmark forKey:@"location"];
}

- (UITableView*)tableViewSearch
{
    if (!_tableViewSearch) {
        UITableView* tableViewSearch = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
        tableViewSearch.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        tableViewSearch.delegate = self;
        tableViewSearch.dataSource = self;

        [tableViewSearch registerNib:[UINib nibWithNibName:@"FDTakeawayMainCell" bundle:nil] forCellReuseIdentifier:FDTakeawayMainCellId];
        [tableViewSearch registerNib:[UINib nibWithNibName:@"FDSearchFoodsCell" bundle:nil] forCellReuseIdentifier:FDSearchFoodsCellId];
        if ([tableViewSearch respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableViewSearch setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([tableViewSearch respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableViewSearch setLayoutMargins:UIEdgeInsetsZero];
        }

        [tableViewSearch addLegendHeaderWithRefreshingBlock:^{
            _currentPageIndex = 1;
            [_params setObject:@(_currentPageIndex).stringValue forKey:@"currentPageIndex"];
            [_itemParams setObject:@(_currentPageIndex).stringValue forKey:@"currentPageIndex"];
            [self clearAndLoadData];

        }];
        [tableViewSearch addLegendFooterWithRefreshingBlock:^{
            _currentPageIndex++;

            [_params setObject:@(_currentPageIndex).stringValue forKey:@"currentPageIndex"];

            [_itemParams setObject:@(_currentPageIndex).stringValue forKey:@"currentPageIndex"];
            [self getDataWithText:self.tfInputSearchText.text];
        }];

        [self.view addSubview:tableViewSearch];
        _tableViewSearch = tableViewSearch;
    }
    return _tableViewSearch;
}

- (void)clearAndLoadData
{
    _currentPageIndex = 1;

    [_datas removeAllObjects];
    [self.tableViewSearch reloadData];

    [self getDataWithText:self.tfInputSearchText.text];
}

- (UIView*)vSearch
{
    if (!_vSearch) {
        UIView* vSearch = [[UIView alloc] initWithFrame:self.view.bounds];
        vSearch.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:vSearch];
        _vSearch = vSearch;
    }
    return _vSearch;
}

- (NSMutableArray*)historyArry
{
    if (!_historyArry) {
        _historyArry = [NSMutableArray array];
    }
    return _historyArry;
}

- (UITableView*)tableViewHistory
{
    if (!_tableViewHistory) {
        UITableView* tableViewHistory = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, kScreenHeight - 64)];
        tableViewHistory.delegate = self;
        tableViewHistory.dataSource = self;
        tableViewHistory.backgroundColor = kCorlorFromRGBA(238, 238, 238, 1);
        [self.view addSubview:tableViewHistory];
        _tableViewHistory = tableViewHistory;
    }
    return _tableViewHistory;
}

- (void)removeHistory
{

    NSString* key;
    if (self.seachType == 1) {
        key = @"shops";
    }
    else
        key = @"foods";
    [self deleteBrowsingHistory:nil andForKey:key andAll:YES];
    [self getData];
    [self.tableViewHistory reloadData];
}

- (void)getData
{

    NSArray* arry = [self loadBrowsingHistoryandType:self.seachType];
    NSMutableArray* marrHistory = [NSMutableArray array];
    for (int i = 0; i < arry.count; i++) {
        GYseachhistoryModel* historyModel = arry[i];
        GYsearchHistoryFrameModel* model = [[GYsearchHistoryFrameModel alloc] init];
        model.model = historyModel;
        [marrHistory addObject:model];
    }
    self.historyArry = marrHistory;
}

- (void)setup
{
    self.seachType = 1;
    self.isFirst = YES;
    UIButton* btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 40, 30);
    btnBack.imageEdgeInsets = UIEdgeInsetsMake(6, 5, 6, 23);
    btnBack.backgroundColor = [UIColor clearColor];
    [btnBack setImage:[UIImage imageNamed:@"gyhe_nav_btn_redback"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];

    UIButton* btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.frame = CGRectMake(0, 2, 19, 20);
    //    btnSearch.backgroundColor = [UIColor whiteColor];

    [btnSearch setImage:[UIImage imageNamed:@"gycommon_search_gray"] forState:UIControlStateNormal];

    [btnSearch addTarget:self action:@selector(myGes) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSearch];

    UIView* footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    footView.backgroundColor = [UIColor whiteColor];
    UITextField* tfDeledate = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 130, 40)];
    tfDeledate.center = footView.center;
    tfDeledate.text = kLocalized(@"GYHE_Food_ClearSearchHistory");
    tfDeledate.textColor = kCellItemTextColor;
    tfDeledate.font = [UIFont systemFontOfSize:15];
    tfDeledate.backgroundColor = [UIColor clearColor];
    tfDeledate.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gycommon_btn_trash"]];
    imgV.frame = CGRectMake(0, 0, 25, 25);
    tfDeledate.leftView = imgV;
    [footView addSubview:tfDeledate];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeHistory)];
    ;
    [tfDeledate addGestureRecognizer:tap];
    [footView addSubview:tfDeledate];

    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = tfDeledate.frame;
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(removeHistory) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    self.tableViewHistory.tableFooterView = footView;
    [self getData];
    [self.tableViewHistory reloadData];
}

#pragma mark - 设置导航栏
- (void)setNav
{

    UIView* vHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    vHead.backgroundColor = [UIColor whiteColor];
    _vTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 4, 190, 32)];
    _vTitleView.backgroundColor = [UIColor colorWithRed:235.0 / 255.0f green:235.0 / 255.0f blue:235.0 / 255.0f alpha:1.0f];
    UIButton* btnChooseType = [UIButton buttonWithType:UIButtonTypeCustom];
    btnChooseType.frame = CGRectMake(0, 0, 50, 32);
    btnChooseType.backgroundColor = [UIColor clearColor];
    btnChooseType.titleLabel.textColor = [UIColor colorWithRed:160.0 / 255.0F green:160.0 / 255.0F blue:160.0 / 255.0F alpha:1.0f];
    btnChooseType.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnChooseType setTitle:kLocalized(@"GYHE_Food_Restaurant") forState:UIControlStateNormal];

    [btnChooseType setImage:[UIImage imageNamed:@"gyhe_prow_trigon.png"] forState:UIControlStateNormal];
    [btnChooseType setImageEdgeInsets:UIEdgeInsetsMake(13, 44, 13, -6)];
    [btnChooseType setTitleEdgeInsets:UIEdgeInsetsMake(0, -btnChooseType.frame.size.width + 32, 0, 5)];
    [btnChooseType setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    [btnChooseType addTarget:self action:@selector(changeSearchType:) forControlEvents:UIControlEventTouchUpInside];

    _tfInputSearchText = [[UITextField alloc] initWithFrame:CGRectMake(60, 4, 125, 25)];
    _tfInputSearchText.contentMode = UIViewContentModeScaleToFill;
    _tfInputSearchText.returnKeyType = UIReturnKeySearch;
    _tfInputSearchText.delegate = self;
    _tfInputSearchText.placeholder = kLocalized(@"GYHE_Food_InputRestaurantName");
    _tfInputSearchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    //设置清空模式
    _tfInputSearchText.rightViewMode = UITextFieldViewModeAlways;

    _tfInputSearchText.textColor = [UIColor colorWithRed:95.0 / 255.0f green:95.0 / 255.0f blue:95.0 / 255.0f alpha:1.0f];
    _tfInputSearchText.backgroundColor = [UIColor colorWithRed:235.0 / 255.0f green:235.0 / 255.0f blue:235.0 / 255.0f alpha:1.0f];
    [_tfInputSearchText addTarget:self action:@selector(tfEditing:) forControlEvents:UIControlEventEditingChanged];
    [_vTitleView addSubview:btnChooseType];

    [_vTitleView addSubview:_tfInputSearchText];

    [vHead addSubview:_vTitleView];

    self.navigationItem.titleView = vHead;
}

#pragma mark 搜索
- (void)myGes
{

    [_datas removeAllObjects];
    [self.tableViewSearch reloadData];
    if (self.seachType == 1) {

        if ([GYUtils isBlankString:self.tfInputSearchText.text]) {
            
            [GYUtils showMessage:kLocalized(@"GYHE_Food_PleaseInputSearchRestaurant") confirm:^{
                
            }];
            
            return;
        }

        [self getDataWithText:self.tfInputSearchText.text];
    }
    else {
        if ([GYUtils isBlankString:self.tfInputSearchText.text]) {
            
            [GYUtils showMessage:kLocalized(@"GYHE_Food_PleaseInputSearchMenu") confirm:^{
                
            }];
            return;
        }

        [self getDataWithText:self.tfInputSearchText.text];
    }

    [self.tfInputSearchText resignFirstResponder];
}

- (void)getDataWithText:(NSString*)text
{

    self.tableViewHistory.hidden = YES;
    [self.tfInputSearchText resignFirstResponder];
    NSString* keyword = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    [_params setObject:keyword forKey:@"keyword"];
    [_itemParams setObject:keyword forKey:@"keyword"];
    [GYGIFHUD show];
    if (self.seachType == 1) {

        [FDShopModel modelArrayNetURL:FoodSearchShopsUrl parameters:_params option:GYM_GetJson completion:^(NSArray* modelArray, id responseObject, NSError* error) {
            [GYGIFHUD dismiss];

            if (_currentPageIndex == 1) {

                [_datas removeAllObjects];

            }


            if (modelArray.count > 0) {

                [_datas addObjectsFromArray:modelArray];

                [self.tableViewSearch reloadData];

                self.tableViewSearch.backgroundView.hidden = YES;
                [self.tableViewSearch.mj_header endRefreshing];
                [self.tableViewSearch.mj_footer endRefreshing];

            } else {

                self.tableViewSearch.mj_footer.hidden = YES;
                UIView *background = [[UIView alloc] initWithFrame:self.tableViewSearch.frame];
                UILabel *lbTips = [[UILabel alloc] init];
                lbTips.center = CGPointMake(kScreenWidth/2, 160);
                lbTips.textColor = kCellItemTitleColor;
                lbTips.font = [UIFont systemFontOfSize:15.0];
                lbTips.backgroundColor = [UIColor clearColor];
                lbTips.bounds = CGRectMake(0, 0, 210, 40);
                lbTips.textAlignment = NSTextAlignmentCenter;
                //lbTips.text = kLocalized(@"HENoRelevantDataFound");
                lbTips.text = [NSString stringWithFormat:kLocalized(@"GYHE_Food_NoSearchRelatedInfoWithTakeAway"),self.tfInputSearchText.text,kLocalized(@"GYHE_Food_Restaurant")];
                UIImageView *imgvNoResult = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_no_result.png"]];
                imgvNoResult.center = CGPointMake(kScreenWidth/2, 100);
                imgvNoResult.bounds = CGRectMake(0, 0, 52, 59);
                [background addSubview:imgvNoResult];

                [background addSubview:lbTips];
                self.tableViewSearch.backgroundView = background;
                self.tableViewSearch.backgroundView.hidden = NO;

                [self.tableViewSearch.mj_header endRefreshing];
                [self.tableViewSearch.mj_footer endRefreshing];

            }
            if (_currentPageIndex >= [[responseObject objectForKey:@"totalPage"] integerValue]) {

                [self.tableViewSearch.mj_footer endRefreshingWithNoMoreData];

            } else {
                [self.tableViewSearch.mj_footer resetNoMoreData];
            }

            [self saveBrowsingHistory:self.tfInputSearchText.text andType:self.seachType];

        }];
    }
    else {

        [FDSearchFoodsModel modelArrayNetURL:FoodSearchItemsUrl parameters:_itemParams option:GYM_GetJson completion:^(NSArray* modelArray, id responseObject, NSError* error) {


            [GYGIFHUD dismiss];
            DDLogDebug(@"%@", modelArray);

            if (_currentPageIndex == 1) {

                [_datas removeAllObjects];

            }
            if (modelArray.count > 0) {

                [_datas addObjectsFromArray:modelArray];

                [self.tableViewSearch reloadData];

                self.tableViewSearch.backgroundView.hidden = YES;

                [self.tableViewSearch.mj_header endRefreshing];
                [self.tableViewSearch.mj_footer endRefreshing];

            } else {

                self.tableViewSearch.mj_footer.hidden = YES;
                UIView *background = [[UIView alloc] initWithFrame:self.tableViewSearch.frame];
                UILabel *lbTips = [[UILabel alloc] init];
                lbTips.center = CGPointMake(kScreenWidth/2, 160);
                lbTips.textColor = kCellItemTitleColor;
                lbTips.font = [UIFont systemFontOfSize:15.0];
                lbTips.backgroundColor = [UIColor clearColor];
                lbTips.bounds = CGRectMake(0, 0, 210, 40);
                lbTips.textAlignment = NSTextAlignmentCenter;
                lbTips.text = [NSString stringWithFormat:kLocalized(@"GYHE_Food_NoSearchRelatedInfoWithTakeAway"),self.tfInputSearchText.text,kLocalized(@"GYHE_Food_Dishes")];
                UIImageView *imgvNoResult = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_no_result.png"]];
                imgvNoResult.center = CGPointMake(kScreenWidth/2, 100);
                imgvNoResult.bounds = CGRectMake(0, 0, 52, 59);
                [background addSubview:imgvNoResult];

                [background addSubview:lbTips];
                self.tableViewSearch.backgroundView = background;
                self.tableViewSearch.backgroundView.hidden = NO;

                [self.tableViewSearch.mj_header endRefreshing];
                [self.tableViewSearch.mj_footer endRefreshing];

            }
            if (_currentPageIndex >= [[responseObject objectForKey:@"totalPage"] integerValue]) {

                [self.tableViewSearch.mj_footer endRefreshingWithNoMoreData];

            } else {
                [self.tableViewSearch.mj_footer resetNoMoreData];
            }

            [self saveBrowsingHistory:self.tfInputSearchText.text andType:self.seachType];

        }];
    }
}

///查询历史数据
- (NSArray*)loadBrowsingHistoryandType:(NSInteger)type
{
    NSString* key;
    if (type == 1)
        key = @"shops";
    else
        key = @"foods";
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary* dicBrowsing = [userDefault objectForKey:key];

    if (!dicBrowsing) {
        //        viewTipBkg.hidden = NO;
        //        [self.tableView setHidden:YES];
        //        return;
    }
    NSMutableArray* arrgg = [[NSMutableArray alloc] init];
    for (NSString* key in [dicBrowsing allKeys]) {
        NSDictionary* dic = dicBrowsing[key];
        GYseachhistoryModel* model = [[GYseachhistoryModel alloc] init];
        model.name = [dic objectForKey:@"name"];
        model.time = [dic objectForKey:@"time"];
        model.type = [dic objectForKey:@"type"];
        [arrgg addObject:model];
    }
    NSArray* sortedArray = [arrgg sortedArrayUsingComparator:^NSComparisonResult(GYseachhistoryModel* p1, GYseachhistoryModel* p2) { //倒序
        return [p2.time compare:p1.time];
    }];
    // 标题行
    NSMutableArray* marrSort = [NSMutableArray arrayWithArray:sortedArray];

    GYseachhistoryModel* model = [[GYseachhistoryModel alloc] init];
    model.name = kLocalized(@"GYHE_Food_RecentSearch");
    [marrSort insertObject:model atIndex:0];
    return marrSort;
}

#pragma mark 保存搜索记录
- (void)saveBrowsingHistory:(NSString*)name andType:(NSInteger)type
{
    if (!([name isEqualToString:@""] || [name isKindOfClass:[NSNull class]])) {

        NSString* key;
        if (type == 1) {
            key = @"shops";
        }
        else
            key = @"foods";
        NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];

        NSMutableDictionary* dicBrowsing = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:key]];
        /////先查询当前的值是否已存在
        NSDictionary* dicname = [userDefault objectForKey:key];
        for (NSString* keyname in [dicname allKeys]) {
            if ([keyname isEqualToString:name]) {
                DDLogDebug(@"%@", key);
                [self deleteBrowsingHistory:keyname andForKey:key andAll:NO];
            }
        }

        GYseachhistoryModel* model = [[GYseachhistoryModel alloc] init];
        model.type = [NSString stringWithFormat:@"%ld", type];
        model.time = @([[NSDate date] timeIntervalSince1970]);
        model.name = name;
        NSDictionary* dictype = @{ @"name" : model.name,
            @"type" : model.type,
            @"time" : model.time };
        [dicBrowsing setObject:dictype forKey:model.name];
        [userDefault setObject:dicBrowsing forKey:key];
        [userDefault synchronize];

        NSArray* arry = [self loadBrowsingHistoryandType:self.seachType];
        NSMutableArray* marrHistory = [NSMutableArray array];
        for (int i = 0; i < arry.count; i++) {
            GYseachhistoryModel* historyModel = arry[i];
            GYsearchHistoryFrameModel* model = [[GYsearchHistoryFrameModel alloc] init];
            model.model = historyModel;
            [marrHistory addObject:model];
        }
    }
}

//////删除
- (void)deleteBrowsingHistory:(NSString*)model andForKey:(NSString*)key andAll:(BOOL)cler;
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* dicBrowsing = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:key]];
    if (cler) {
        [dicBrowsing removeAllObjects];
    }
    else {
        [dicBrowsing removeObjectForKey:model];
    }

    [userDefault setObject:dicBrowsing forKey:key];
    [userDefault synchronize];

    NSArray* arry = [self loadBrowsingHistoryandType:self.seachType];
    NSMutableArray* marrHistory = [NSMutableArray array];
    for (int i = 0; i < arry.count; i++) {
        GYseachhistoryModel* historyModel = arry[i];
        GYsearchHistoryFrameModel* model = [[GYsearchHistoryFrameModel alloc] init];
        model.model = historyModel;
        [marrHistory addObject:model];
    }
}

//弹出指定搜索
- (void)changeSearchType:(UIButton*)sender
{ //指定弹出点
    CGPoint point = CGPointMake(85, 65);
    NSArray* titles = @[ kLocalized(@"GYHE_Food_Restaurant"), kLocalized(@"GYHE_Food_Dishes") ];
    PopoverView* pop = [[PopoverView alloc] initWithPoint:point titles:titles images:nil];
    __block FDSearchShopAndFoodViewController* vcSelf = self;
    pop.selectRowAtIndex = ^(NSInteger index) {
        DDLogDebug(@"select index:%ld", (long)index);
        NSInteger type = 0;
        if (index == 0) {
            type = 1;
        } else {
            type = 0;
        }
        if (type != _seachType) {
            _seachType = type;

        }
        switch (index) {
        case 0: {
            self.seachType = 1;  // 商品
            _tfInputSearchText.placeholder = kLocalized(@"GYHE_Food_InputRestaurantName");
            [_datas removeAllObjects];
            [self.tableViewSearch reloadData];
            if (self.tfInputSearchText.text.length == 0) {
                NSArray *arry = [vcSelf loadBrowsingHistoryandType:vcSelf.seachType];
                NSMutableArray *marrHistory = [NSMutableArray array];
                for (int i = 0; i < arry.count; i++) {
                    GYseachhistoryModel *historyModel = arry[i];
                    GYsearchHistoryFrameModel *model = [[GYsearchHistoryFrameModel alloc] init];
                    model.model = historyModel;
                    [marrHistory addObject:model];
                }
                vcSelf.historyArry = marrHistory;
                if (vcSelf.historyArry.count > 0) {
                    vcSelf.tableViewHistory.hidden = NO;
                    [vcSelf.view bringSubviewToFront:vcSelf.tableViewHistory];
                }
                [vcSelf.tableViewHistory reloadData];
            }
        }
        break;
        case 1: {
            self.seachType = 0;
            _tfInputSearchText.placeholder = kLocalized(@"GYHE_Food_InputDishesName");
            [_datas removeAllObjects];
            [self.tableViewSearch reloadData];
            if (self.tfInputSearchText.text.length == 0) {

                NSArray *arry = [vcSelf loadBrowsingHistoryandType:vcSelf.seachType];
                NSMutableArray *marrHistory = [NSMutableArray array];
                for (int i = 0; i < arry.count; i++) {
                    GYseachhistoryModel *historyModel = arry[i];
                    GYsearchHistoryFrameModel *model = [[GYsearchHistoryFrameModel alloc] init];
                    model.model = historyModel;
                    [marrHistory addObject:model];
                }
                vcSelf.historyArry = marrHistory;
                if (vcSelf.historyArry.count > 0) {
                    vcSelf.tableViewHistory.hidden = NO;
                    [vcSelf.view bringSubviewToFront:vcSelf.tableViewHistory];
                }
                [vcSelf.tableViewHistory reloadData];
            }
        }
        break;
        default:
            break;
        }

//        [vcSelf.datas removeAllObjects];
//        [vcSelf.tableViewSearch reloadData];
//        vcSelf.tfInputSearchText.text=@"";

        NSArray *titles = @[kLocalized(@"GYHE_Food_Restaurant"), kLocalized(@"GYHE_Food_Dishes")];
        NSString *string = titles[index];

        [sender setTitle:string forState:UIControlStateNormal];
    };
    [pop show];
}

#pragma mark - tableview代理方法
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    if (tableView == self.tableViewHistory) {

        return self.historyArry.count;
    }
    else {
        return self.datas.count;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    if (tableView == self.tableViewHistory) {
        GYsearchHistoryCell* cell = [GYsearchHistoryCell cellWithTableView:tableView];
        GYsearchHistoryFrameModel* model = nil;
        if (self.historyArry.count > indexPath.row) {
            model = self.historyArry[indexPath.row];
        }
        cell.model = model;
        return cell;
    }
    else {

        if (self.seachType == 1) {

            FDTakeawayMainCell* cell = [tableView dequeueReusableCellWithIdentifier:FDTakeawayMainCellId];

            FDShopModel* model = nil;
            if (_datas.count > indexPath.row) {
                model = _datas[indexPath.row];
            }

            cell.model = model;

            cell.selectionStyle = 0;
            return cell;
        }
        else {

            FDSearchFoodsCell* cell = [tableView dequeueReusableCellWithIdentifier:FDSearchFoodsCellId];

            FDSearchFoodsModel* model = nil;
            if (_datas.count > indexPath.row) {
                model = _datas[indexPath.row];
            }

            cell.selectionStyle = 0;
            cell.model = model;

            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{

    if (tableView == self.tableViewHistory) {
        GYsearchHistoryFrameModel* model = nil;
        if (self.historyArry.count > indexPath.row) {
            model = self.historyArry[indexPath.row];
        }
        return 30; //暂时先固定高度
    }
    else {
        float height;
        if (self.seachType == 1) {
            height = 100.0f;
        }
        else {
            height = 90.0f;
        }

        return height;
    }
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    view.backgroundColor = kCorlorFromRGBA(238, 238, 238, 1);
    return view;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self.view endEditing:YES];
    if (tableView == self.tableViewHistory) {
        if (indexPath.row != 0) {
            GYsearchHistoryFrameModel* model = nil;
            if (self.historyArry.count > indexPath.row) {
                model = self.historyArry[indexPath.row];
            }
            self.tfInputSearchText.text = model.model.name;
            [_datas removeAllObjects];
            [self.tableViewSearch reloadData];
            [self getDataWithText:model.model.name];
        }
    }
    else {

        if (self.seachType == 1) {

            FDSelectFoodViewController* chooseVC = [[FDSelectFoodViewController alloc] init];
            if (_datas.count > indexPath.row) {
                chooseVC.shopModel = _datas[indexPath.row];
            }
            chooseVC.isTakeaway = YES;
            chooseVC.landMark = _landmark;
            [self.navigationController pushViewController:chooseVC animated:YES];
        }
        else {

            FDSelectFoodViewController* chooseVC = [[FDSelectFoodViewController alloc] init];
            FDSearchFoodsModel* model = nil;
            if (_datas .count > indexPath.row) {
                model = _datas[indexPath.row];
            }
            NSString* shopId = model.shopId;
            NSString* vShopId = model.vShopId;
            NSString* shopName = model.shopName;
            chooseVC.dist = model.dist;
            chooseVC.shopId = shopId;
            chooseVC.vShopId = vShopId;
            chooseVC.shopName = shopName;
            chooseVC.isTakeaway = YES;
            chooseVC.isSearch = YES;
            chooseVC.isSendRange = model.isInSendRange;
            chooseVC.landMark = _landmark;
            chooseVC.foodId = model.itemId;
            [self.navigationController pushViewController:chooseVC animated:YES];
        }
    }
}

- (UIImage*)buttonImageFromColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 44);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark uitextfieldDelegate
- (void)tfEditing:(UITextField*)sender
{
    if (sender.text.length > 100) {
        [GYUtils showToast:kLocalized(@"GYHE_Food_MaximumLengthLimit")];

        sender.text = [sender.text substringToIndex:100];
    }
    if (!sender || sender.text.length == 0) {
        [self.view sendSubviewToBack:self.vSearch];
        self.tableViewHistory.hidden = NO;
        [self.view bringSubviewToFront:self.tableViewHistory];
        [self getData];
        [self.tableViewHistory reloadData];
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self getDataWithText:self.tfInputSearchText.text];

    return YES;
}

@end
