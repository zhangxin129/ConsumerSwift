//
//  FDSelectFoodViewController.m
//  HSConsumer
//
//  Created by apple on 15/12/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "FDSelectFoodViewController.h"
#define FDChooseFoodTableViewCellReuseId @"FDChooseFoodTableViewCellReuseId"
#define FDCategoryTableViewCellReuseId @"FDCategoryTableViewCellReuseId"
#define FDChoosedFoodTableViewCellReuseId @"FDChoosedFoodTableViewCellReuseId"
#define FDSelectFoodTabelViewCellId @"FDSelectFoodTabelViewCellId"
#define FDCategoryCellBackgroundColor ([UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0f])
#define FDShopCommitRowHeightCacheUserDefaultsKey @"FDShopCommitRowHeightCacheUserDefaultsKey"
#define FDShopCommitCellReuseId @"FDShopCommitCellReuseId"

//#define
#define FoodDetailTopCellId @"foodDetailTopCell"
#define FoodBasicInfoCellId @"FoodBasicInfoCell"
#define FoodSeveiceCellId @"FoodSeveiceCell"
#define FoodShopDetailCellId @"FoodShopDetailCell"
#define FoodBusinessCellId @"FoodBusinessCell"
#define FDRecomdFoodDetailCellId @"FDRecomdFoodDetailCell"

#import "FDCategoryTableViewCell.h"
#import "FDChooseFoodTableViewCell.h"
//餐厅详情的cell
#import "FDChoosedFoodModel.h"
#import "FDFoodCategoryModel.h"
#import "FDFoodDetailModel.h"
#import "FDFoodFormatModel.h"
#import "FDOrderConfirmModel.h"
#import "FDRecomdFoodDetailCell.h"
#import "FDRecomdModel.h"
#import "FDScoreBar.h"
#import "FDSelecteFoodCell.h"
#import "FDShopCommitCell.h"
#import "FDShopDetailModel.h"
#import "FDShopFoodModel.h"
#import "FoodBasicInfoCell.h"
#import "FoodBusinessCell.h"
#import "FoodSeveiceCell.h"
#import "FoodShopDetailCell.h"
#import "GYConfirmOrdersController.h"
#import "GYConfirmationViewController.h"
#import "GYGIFHUD.h"
#import "foodDetailTopCell.h"

#import "FDRecomdModel.h"
#import "FDShopCommentModel.h"
#import "FDShopDetailRecomFoodViewController.h"
#import "GYHDChatViewController.h"
#import "GYHSLoginManager.h"
#import "GYHSLoginViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface FDSelectFoodViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton* mainFoodBtn; //菜单
@property (weak, nonatomic) IBOutlet UIButton* foodDetailBtn; //餐厅详情
@property (weak, nonatomic) IBOutlet UIButton* averageBtn; //评价
@property (weak, nonatomic) IBOutlet UIView* adBgView; //广告视图
@property (weak, nonatomic) IBOutlet UIView* mainBgView;
@property (weak, nonatomic) IBOutlet UILabel* adLabel; //广告
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* adHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* evnBarViewHight;
@property (weak, nonatomic) IBOutlet UIView* evnScoreView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* topShowListViewHight;

@property (weak, nonatomic) IBOutlet UITableView* LeftTableView; //左边列表
@property (weak, nonatomic) IBOutlet UITableView* rightTableView; //右边列表
@property (weak, nonatomic) IBOutlet UIView* bottomBgView; //底部视图
@property (weak, nonatomic) IBOutlet UIImageView* orderImageView; //订单
@property (weak, nonatomic) IBOutlet UILabel* CashLabel; //金额
@property (nonatomic, strong) UILabel* tipLabel; //下单后显示配送费
@property (weak, nonatomic) IBOutlet UIView* moveView; //移动视图
@property (weak, nonatomic) IBOutlet UILabel* intergrationLabel; //积分

@property (weak, nonatomic) IBOutlet UILabel* orederBeforeLabel; //商家预定金额
@property (weak, nonatomic) IBOutlet UILabel* orderLablel; //订单数
@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) CGRect rec;
@property (strong, nonatomic) FDShopFoodModel* shop;
@property (assign, nonatomic) NSInteger currentSelectedIndex; //当前选择的分类
@property (strong, nonatomic) NSMutableArray* categoryDataSource; //菜品分类列表
@property (strong, nonatomic) NSMutableArray* currentFoodDataSource; //当前分类菜品列表
@property (strong, nonatomic) NSMutableDictionary* allFoodDataSources; //所有菜品列表 key:categoryId Value:分类菜品列表
@property (strong, nonatomic) NSMutableArray* choosedFoodDataSource;
@property (strong, nonatomic) FDChoosedFoodModel* currentChoosedFormatFoodModel; //当前弹出框的多规格菜品
@property (assign, nonatomic) NSInteger currentSelectedFormatIndex; //当前弹出框选择的规格
@property (assign, nonatomic) NSInteger choosedFoodCount; //已点菜品的数量
@property (assign, nonatomic) double choosedFoodCoinCount; //已点菜品所消耗的互生币
@property (assign, nonatomic) double choosedFoodPvCount; //已点菜品的积分
@property (strong, nonatomic) IBOutlet UIView* noResultView;
@property (strong, nonatomic) IBOutlet UIView* foodFormatView;
@property (strong, nonatomic) NSMutableArray* formatCategoryBtns;
@property (strong, nonatomic) UIView* coverBlackView;
// 多规格显示相关
@property (weak, nonatomic) IBOutlet UIButton* formatMinusBtn;
@property (weak, nonatomic) IBOutlet UIButton* formatAddBtn;
@property (weak, nonatomic) IBOutlet UILabel* formatNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* formatPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel* formatPVLabel;
@property (weak, nonatomic) IBOutlet UILabel* formatCountLabel;
@property (weak, nonatomic) IBOutlet UIButton* formatConfirmBtn;
@property (weak, nonatomic) IBOutlet UIView* formatBtnContainerView;
@property (weak, nonatomic) IBOutlet UIButton* orderBtn;
//动画label+1
@property (weak, nonatomic) IBOutlet UILabel* animtedLabel;
//点菜清单视图
@property (strong, nonatomic) IBOutlet UIView* selectView;
@property (weak, nonatomic) IBOutlet UITableView* selectFoodTabelView;
@property (nonatomic, strong) NSMutableArray* listFoodArr; //记录彩屏列表数组；

//餐厅详情视图
@property (strong, nonatomic) IBOutlet UIView* foodDetailBgView;
@property (weak, nonatomic) IBOutlet UITableView* foodDetailTabelView;
@property (nonatomic, strong) FDShopDetailModel* shopDetailModel;

//评价相关视图
@property (strong, nonatomic) IBOutlet UIView* averageBgView;

@property (strong, nonatomic) IBOutlet UIView* noResultAvrageView;

@property (strong, nonatomic) IBOutlet UIView* noResultAvrageView1;
@property (strong, nonatomic) IBOutlet UIView* noResultAvrageView2;
@property (strong, nonatomic) IBOutlet UIView* noResultAvrageView3;

@property (weak, nonatomic) IBOutlet UITableView* tasteTableView; //口味视图
@property (weak, nonatomic) IBOutlet UITableView* seviceTableView; //服务视图

@property (weak, nonatomic) IBOutlet UITableView* evnTableView; //环境视图
@property (weak, nonatomic) IBOutlet UITableView* recomTableView; //推荐菜品
@property (nonatomic, strong) NSMutableArray* recomdFoods; //推荐菜品的数组
@property (nonatomic, strong) NSMutableArray* recomdDatas; //人数

//顶部相关
@property (weak, nonatomic) IBOutlet UIView* topBgView;
@property (weak, nonatomic) IBOutlet UIView* changeBgView;
@property (weak, nonatomic) IBOutlet UIScrollView* sliderScrollView;
@property (weak, nonatomic) IBOutlet UIView* tasteBgView;
@property (weak, nonatomic) IBOutlet UIView* serviceBgView;
@property (weak, nonatomic) IBOutlet UIView* evnBgView;
@property (weak, nonatomic) IBOutlet UIView* recomBgView;

@property (weak, nonatomic) IBOutlet UILabel* haopingRateLabel; //好评度
@property (weak, nonatomic) IBOutlet UIImageView* tastImageView0;
@property (weak, nonatomic) IBOutlet UIImageView* tastImageView1;
@property (weak, nonatomic) IBOutlet UIImageView* tastImageView2;
@property (weak, nonatomic) IBOutlet UIImageView* evnImageView0;
@property (weak, nonatomic) IBOutlet UIImageView* evnImageView1;
@property (weak, nonatomic) IBOutlet UIImageView* evnImageView2;
@property (weak, nonatomic) IBOutlet UIImageView* seviceImageView0;
@property (weak, nonatomic) IBOutlet UIImageView* seviceImageView1;
@property (weak, nonatomic) IBOutlet UIImageView* seviceImageView2;
@property (nonatomic, strong) FDShopCommentModel* commentModel;

@property (weak, nonatomic) IBOutlet UIView* tasteScoreBarView;
@property (weak, nonatomic) IBOutlet UIView* evnScorBarView;
@property (weak, nonatomic) IBOutlet UIView* serviceScoreBarView;
@property (weak, nonatomic) IBOutlet UILabel* tastScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel* evnScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel* seviceScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel* tastLabel;
@property (weak, nonatomic) IBOutlet UILabel* tastNumLabel;
@property (weak, nonatomic) IBOutlet UILabel* seviceLabel;
@property (weak, nonatomic) IBOutlet UILabel* seviceNumLabel;
@property (weak, nonatomic) IBOutlet UILabel* evnLabel;
@property (weak, nonatomic) IBOutlet UILabel* evnNumLabel;
@property (weak, nonatomic) IBOutlet UILabel* recomLabel;
@property (weak, nonatomic) IBOutlet UILabel* recomNumLabel;
@property (nonatomic, assign) NSInteger ScoreIndex;

//评价数据源
@property (strong, nonatomic) NSMutableArray* tasteDataSource;
@property (strong, nonatomic) NSMutableArray* serviceDataSource;
@property (strong, nonatomic) NSMutableArray* evnDataSource;
@property (strong, nonatomic) NSMutableArray* recomDataSource;

@property (strong, nonatomic) NSMutableArray* tableArray;
@property (strong, nonatomic) NSMutableArray* dataSourceArray;

@property (copy, nonatomic) NSString* count;
@property (strong, nonatomic) NSMutableArray* currentPages;
@property (copy, nonatomic) NSString* key;

@property (strong, nonatomic) NSMutableDictionary* rowHeightCache;
@property (strong, nonatomic) NSMutableDictionary* params;

//控制商铺简介下拉
@property (nonatomic, assign) BOOL isShowIntroduction; //刷新显示
@property (nonatomic, assign) BOOL isPull;
@property (nonatomic, assign) NSInteger rowsIntroduction; //显示行
@property (nonatomic, strong) UIImageView* arrowView; //箭头

@property (nonatomic, copy) NSString* recomId; //推荐菜的id用来显示推荐菜的位置

//国际化 add zhangx
@property (weak, nonatomic) IBOutlet UILabel* noDishesLabel; //无菜品信息
@property (weak, nonatomic) IBOutlet UILabel* specificationsLabel; //规格
@property (weak, nonatomic) IBOutlet UILabel* haveMenuLabel; //已点菜单
@property (weak, nonatomic) IBOutlet UILabel* degreePraiseLabel; //好评度
@property (weak, nonatomic) IBOutlet UILabel* tasteScoreLabel; //口味评分

@property (weak, nonatomic) IBOutlet UILabel* EnvSoreLabel; //环境评分

@property (weak, nonatomic) IBOutlet UILabel* sevScoreLabel; //服务评分
@property (weak, nonatomic) IBOutlet UILabel* noEvaluationLabel; //无相关评价
@property (weak, nonatomic) IBOutlet UILabel* noEvaluatLabel; //无相关评价

@property (weak, nonatomic) IBOutlet UILabel* noEvaluationLb; //无相关评价

@property (strong, nonatomic) IBOutlet UILabel* noEvaluatLb; //无相关评价

@end

@implementation FDSelectFoodViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [_tableArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        UITableView* tableView = (UITableView*)obj;
        [tableView reloadData];
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachCenter:) name:@"recomdFood" object:nil];
}

- (void)reachCenter:(NSNotification*)noti
{

    [self.mainFoodBtn setTitleColor:kNavigationBarColor forState:0];
    [self.foodDetailBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.averageBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    [UIView animateWithDuration:0.3
                     animations:^{

                         self.moveView.frame = CGRectMake(self.mainFoodBtn.frame.origin.x, self.rect.origin.y, self.rect.size.width, self.rect.size.height);
                     }];

    self.foodDetailBgView.hidden = YES;
    self.averageBgView.hidden = YES;

    FDRecomdModel* model = (FDRecomdModel*)noti.object;

    _recomId = model.recomId;

    if (_recomId != nil) {

        for (FDFoodDetailModel* model in _currentFoodDataSource) {

            if ([_recomId isEqualToString:model.foodId]) {

                FDFoodDetailModel* tempModel = model;
                _currentFoodDataSource = [_currentFoodDataSource mutableCopy];
                [_currentFoodDataSource removeObject:model];

                [_currentFoodDataSource insertObject:tempModel atIndex:0];

                [self.rightTableView reloadData];

                return;
            }
        }
    }
}

- (void)viewDidLayoutSubviews
{

    [super viewDidLayoutSubviews];

    [self.mainBgView addBottomBorder];
    [self.adBgView addBottomBorder];
    [self.topBgView addTopBorder];
    [self.changeBgView addTopBorder];
    [self.foodDetailTabelView addTopBorder];

    [self.tasteBgView addAllBorder];
    [self.serviceBgView addAllBorder];
    [self.evnBgView addAllBorder];
    [self.recomBgView addAllBorder];

    self.tasteBgView.layer.borderWidth = kDefaultViewBorderWidth;
    self.tasteBgView.layer.borderColor = kDefaultViewBorderColor.CGColor;
    [self.tasteBgView clipsToBounds];

    self.serviceBgView.layer.borderWidth = kDefaultViewBorderWidth;
    self.serviceBgView.layer.borderColor = kDefaultViewBorderColor.CGColor;
    [self.serviceBgView clipsToBounds];

    self.evnBgView.layer.borderWidth = kDefaultViewBorderWidth;
    self.evnBgView.layer.borderColor = kDefaultViewBorderColor.CGColor;
    [self.evnBgView clipsToBounds];

    self.recomBgView.layer.borderWidth = kDefaultViewBorderWidth;
    self.recomBgView.layer.borderColor = kDefaultViewBorderColor.CGColor;
    [self.recomBgView clipsToBounds];

    self.rect = self.moveView.frame;
}

- (void)updateViewConstraints
{

    [super updateViewConstraints];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //国际化

    self.CashLabel.text = @"0.00";
    self.intergrationLabel.text = @"0.00";

    [self.mainFoodBtn setTitle:kLocalized(@"GYHE_Food_Menu") forState:UIControlStateNormal];

    [self.foodDetailBtn setTitle:kLocalized(@"GYHE_Food_RestaurantDetails") forState:UIControlStateNormal];

    [self.averageBtn setTitle:kLocalized(@"GYHE_Food_Appraise") forState:UIControlStateNormal];

    self.noDishesLabel.text = kLocalized(@"GYHE_Food_NoSearchDishes");
    self.haveMenuLabel.text = kLocalized(@"GYHE_Food_HaveMenu");
    self.specificationsLabel.text = kLocalized(@"GYHE_Food_Specifications");
    self.degreePraiseLabel.text = kLocalized(@"GYHE_Food_DegreePraise");
    self.tasteScoreLabel.text = kLocalized(@"GYHE_Food_TasetScore");
    self.EnvSoreLabel.text = kLocalized(@"GYHE_Food_EnvironmentalScore");
    self.sevScoreLabel.text = kLocalized(@"GYHE_Food_ServiceScore");
    self.noEvaluationLabel.text = kLocalized(@"GYHE_Food_NoRelevantEvaluation");
    self.noEvaluationLb.text = kLocalized(@"GYHE_Food_NoRelevantEvaluation");
    self.noEvaluatLabel.text = kLocalized(@"GYHE_Food_NoRelevantEvaluation");
    self.noEvaluatLb.text = kLocalized(@"GYHE_Food_NoRelevantEvaluation");
    self.tastLabel.text = kLocalized(@"GYHE_Food_Taste");
    self.seviceLabel.text = kLocalized(@"GYHE_Food_Service");
    self.evnLabel.text = kLocalized(@"GYHE_Food_EnvironmentalScience");
    self.recomLabel.text = kLocalized(@"GYHE_Food_RecommendedDishes");

    _formatCategoryBtns = [[NSMutableArray alloc] init];
    //    [self.mainBgView addBottomBorder];
    //    [self.adBgView addBottomBorder];
    //    评价相关
    //    [self.topBgView addTopBorder];
    //    [self.changeBgView addTopBorder];
    //    [self.tasteBgView addAllBorder];
    //    [self.serviceBgView addAllBorder];
    //    [self.evnBgView addAllBorder];
    //    [self.recomBgView addAllBorder];
    [self.sliderScrollView setContentOffset:CGPointMake(0, 0)];
    [self setTagViewColorIndex:0];
    _currentPages = [@[ @1, @1, @1, @1 ] mutableCopy];
    _params = [[NSMutableDictionary alloc] init];
    _count = @"10";
    _key = globalData.loginModel.token;
    [_params setObject:_count forKey:@"count"];
    [_params setObject:kSaftToNSString(_key) forKey:@"key"];
    if (_shopModel.shopId != nil) {

        [_params setObject:kSaftToNSString(_shopModel.shopId) forKey:@"shopId"];
    } else {

        [_params setObject:kSaftToNSString(_shopId) forKey:@"shopId"];
    }

    _rowHeightCache = [[NSMutableDictionary alloc] init];
    NSDictionary* dict = [[NSUserDefaults standardUserDefaults] objectForKey:FDShopCommitRowHeightCacheUserDefaultsKey];
    if (dict) {
        _rowHeightCache = [NSMutableDictionary dictionaryWithDictionary:dict];
    }
    [self setupAvrageTableView];
    if (_shopModel.shopName) {

        self.title = _shopModel.shopName;
    } else {

        self.title = @""; //_shopName;
    }

    self.orderLablel.layer.cornerRadius = 10;
    //self.orderLablel.font=[UIFont systemFontOfSize:10];
    self.orderLablel.clipsToBounds = YES;
    self.orderLablel.hidden = YES;
    //    self.rect=self.moveView.frame;
    self.isClick = NO;
    self.isShowIntroduction = YES;
    self.isPull = NO;
    [self setTabelView];
    [self setupFormatView];
    if (_isTakeaway) {

        [self.orderBtn setTitle:kLocalized(@"GYHE_Food_GoSettlement") forState:UIControlStateNormal];
    } else {

        [self.orderBtn setTitle:kLocalized(@"GYHE_Food_OrderReservation") forState:UIControlStateNormal];
    }

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myGes)];

    self.orderImageView.userInteractionEnabled = YES;

    [self.orderImageView addGestureRecognizer:tap];

    self.rightTableView.tableFooterView = [[UIView alloc] init];
    self.selectFoodTabelView.tableFooterView = [[UIView alloc] init];
    self.LeftTableView.tableFooterView = [[UIView alloc] init];
    //    [self.foodDetailTabelView addTopBorder];

    self.foodDetailTabelView.tableFooterView = [[UIView alloc] init];
    self.tasteTableView.tableFooterView = [[UIView alloc] init];
    _currentFoodDataSource = [[NSMutableArray alloc] init];
    _categoryDataSource = [[NSMutableArray alloc] init];
    _allFoodDataSources = [[NSMutableDictionary alloc] init];
    _choosedFoodDataSource = [[NSMutableArray alloc] init];
    _listFoodArr = [[NSMutableArray alloc] init];

    _tastNumLabel.text = @"(0)";
    _seviceNumLabel.text = @"(0)";
    _evnNumLabel.text = @"(0)";
    _recomNumLabel.text = @"(0)";
    [self loadData];
}

//设置评论tableView
- (void)setupAvrageTableView
{

    _tasteDataSource = [[NSMutableArray alloc] init];
    _serviceDataSource = [[NSMutableArray alloc] init];
    _evnDataSource = [[NSMutableArray alloc] init];
    _recomDataSource = [[NSMutableArray alloc] init];
    _recomdFoods = [NSMutableArray array];
    _recomdDatas = [NSMutableArray array];
    _dataSourceArray = [@[ _tasteDataSource, _serviceDataSource, _evnDataSource, _recomDataSource ] mutableCopy];
    _tableArray = [NSMutableArray arrayWithObjects:_tasteTableView, _seviceTableView, _evnTableView, _recomTableView, nil];
    for (int i = 0; i < _tableArray.count; i++) {
        UITableView* tableView = _tableArray[i];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FDShopCommitCell class]) bundle:nil] forCellReuseIdentifier:FDShopCommitCellReuseId];
        [tableView addLegendHeaderWithRefreshingBlock:^{
            [self loadDataClearWithTableIndex:i];
        }];
        [tableView addLegendFooterWithRefreshingBlock:^{
            NSNumber* currentPage = _currentPages[i];
            currentPage = @(currentPage.integerValue + 1);
            [_currentPages replaceObjectAtIndex:i withObject:currentPage];
            [self loadDataWithTableIndex:i];
        }];
    }
}

- (void)setTabelView
{

    self.LeftTableView.delegate = self;
    self.LeftTableView.dataSource = self;
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    self.selectFoodTabelView.delegate = self;
    self.selectFoodTabelView.dataSource = self;
    self.foodDetailTabelView.delegate = self;
    self.foodDetailTabelView.dataSource = self;
    self.tasteTableView.delegate = self;
    self.tasteTableView.dataSource = self;
    self.seviceTableView.delegate = self;
    self.seviceTableView.dataSource = self;
    self.evnTableView.delegate = self;
    self.evnTableView.dataSource = self;
    self.recomTableView.delegate = self;
    self.recomTableView.dataSource = self;

    [self.LeftTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FDCategoryTableViewCell class]) bundle:nil] forCellReuseIdentifier:FDCategoryTableViewCellReuseId];
    [self.rightTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FDChooseFoodTableViewCell class]) bundle:nil] forCellReuseIdentifier:FDChooseFoodTableViewCellReuseId];
    [self.rightTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FDChooseFoodTableViewCell class]) bundle:nil] forCellReuseIdentifier:FDChoosedFoodTableViewCellReuseId];
    
    [self.selectFoodTabelView registerNib:[UINib nibWithNibName:NSStringFromClass([FDSelecteFoodCell class]) bundle:nil] forCellReuseIdentifier:FDSelectFoodTabelViewCellId];

    [self.foodDetailTabelView registerNib:[UINib nibWithNibName:NSStringFromClass([foodDetailTopCell class]) bundle:nil] forCellReuseIdentifier:FoodDetailTopCellId];

    [self.foodDetailTabelView registerNib:[UINib nibWithNibName:NSStringFromClass([FoodBasicInfoCell class]) bundle:nil] forCellReuseIdentifier:FoodBasicInfoCellId];

    [self.foodDetailTabelView registerClass:[FoodSeveiceCell class] forCellReuseIdentifier:FoodSeveiceCellId];

    [self.foodDetailTabelView registerClass:[FoodShopDetailCell class] forCellReuseIdentifier:FoodShopDetailCellId];
    [self.foodDetailTabelView registerClass:[FoodBusinessCell class] forCellReuseIdentifier:FoodBusinessCellId];
}

#pragma mark - 请求数据
- (void)loadData
{
    NSDictionary* paramsCategory;

    if (_shopModel.vShopId != nil && _shopModel.shopId != nil) {

        paramsCategory = @{ @"vShopId" : _shopModel.vShopId,
            @"shopId" : _shopModel.shopId };
    } else {

        paramsCategory = @{ @"vShopId" : kSaftToNSString(_vShopId),
            @"shopId" : kSaftToNSString(_shopId) };
    }

    NSMutableDictionary* paramsUsers = [paramsCategory mutableCopy];
    if (globalData.isLogined) {
        [paramsUsers setObject:globalData.loginModel.custId forKey:@"userId"];
    } else {
        [paramsUsers setObject:@"" forKey:@"userId"];
    }
    NSString* dm = globalData.foodConsmerDomain;
    NSString* urlString = [dm stringByAppendingString:@"/ph/food/getShopById"];
    NSString* urlString2 = [dm stringByAppendingString:@"/ph/food/queryItemfoods"];
    [GYGIFHUD show];
    [FDShopFoodModel modelArrayNetURL:urlString
                           parameters:paramsUsers
                               option:GYM_GetJson
                           completion:^(NSArray* modelArray, id responseObject, NSError* error) {
                               [GYGIFHUD dismiss];
                               _shop = modelArray.firstObject;
                               self.title = _shop.shopName;
                               _shop.timeresultTakeaway = [_shop.timeresultTakeaway sortedArrayUsingSelector:@selector(compare:)]; //给外卖时间排序
                               globalData.tfsDomain = _shop.tfsDomain;
                               NSArray* categoryList = _shop.categoryList;
                               FDFoodCategoryModel* allFoodModel = [[FDFoodCategoryModel alloc] init];
                               [FDFoodDetailModel modelArrayNetURL:urlString2
                                                        parameters:paramsCategory
                                                            option:GYM_GetJson
                                                        completion:^(NSArray* modelArray, id responseObject, NSError* error) {

                                                            if (modelArray && modelArray.count > 0) {
                                                                allFoodModel.itemInfoFoodList = [modelArray copy];
                                                                allFoodModel.itemCustomCategoryId = @"allFoodCategoryId";
                                                                allFoodModel.itemCustomCategoryName = kLocalized(@"GYHE_Food_All");
                                                                [_categoryDataSource addObject:allFoodModel];
                                                                [_categoryDataSource addObjectsFromArray:categoryList];
                                                                [self.LeftTableView reloadData];
                                                                for (int i = 0; i < _categoryDataSource.count; i++) {
                                                                    FDFoodCategoryModel* model = _categoryDataSource[i];
                                                                    [_allFoodDataSources setObject:model.itemInfoFoodList forKey:model.itemCustomCategoryId];
                                                                    if (i == 0) {
                                                                        [_currentFoodDataSource addObjectsFromArray:model.itemInfoFoodList];
                                                                        if (_currentFoodDataSource.count < 1) {
                                                                            self.rightTableView.tableFooterView = _noResultView;
                                                                        } else {
                                                                            self.rightTableView.tableFooterView = [[UIView alloc] init];
                                                                        }
                                                                        [self.rightTableView reloadData];
                                                                    }
                                                                }
                                                            }
                                                            if (_categoryDataSource.count < 1) {

                                                                self.rightTableView.tableFooterView = _noResultView;
                                                            }
                                                        }];

                               [self isSomeSelect];

                           }];
}

#pragma mark - 判断某些显示相关

- (void)isSomeSelect
{

    if (_isTakeaway) {

        self.orederBeforeLabel.text = [NSString stringWithFormat:@"%@%.f", kLocalized(@"GYHE_Food_StartSendFee"), [_shop.qiSongPrice doubleValue]];
        self.orederBeforeLabel.textAlignment = NSTextAlignmentCenter;
    } else {

        if (![_shop.moneyEarnest doubleValue] > 0) {

            self.orederBeforeLabel.text = kLocalized(@"GYHE_Food_BusinessFreeDeposit");
        } else {

            self.orederBeforeLabel.text = kLocalized(@"GYHE_Food_BusinessReceiveDeposit");
            //            CGFloat Earnest=[_shop.moneyEarnest doubleValue]*100;
            //            self.orederBeforeLabel.text=[NSString stringWithFormat:@"预付商家金额(%.f%%)",Earnest      ];
        }
    }

    if ((_shop.fullPrice != nil && ![_shop.fullPrice isEqualToString:@""]) && (_shop.offPrice != nil && ![_shop.offPrice isEqualToString:@""])) {

        _tipLabel.text = [NSString stringWithFormat:kLocalized(@"GYHE_Food_ArriveAndSubtract"), kLocalized(@"GYHE_Food_SendPrice"), [_shop.sendPrice doubleValue], _shop.fullPrice, _shop.offPrice];
    } else {

        _tipLabel.text = [NSString stringWithFormat:@"%@%.f", kLocalized(@"GYHE_Food_SendPrice"), [_shop.sendPrice doubleValue]];
    }

    if (_isTakeaway) {

        if ((_shop.fullPrice != nil && ![_shop.fullPrice isEqualToString:@""]) && (_shop.offPrice != nil && ![_shop.offPrice isEqualToString:@""])) {

            _adLabel.text = [NSString stringWithFormat:kLocalized(@"GYHE_Food_ArriveAndSubtractAndMoney"), _shop.fullPrice, _shop.offPrice, kLocalized(@"GYHE_Food_SendPrice")];
        } else {

            _adHight.constant = 0;
            _adBgView.hidden = 0;
        }
    } else {

        if (_shop.dikou != nil && ![_shop.dikou isEqualToString:@""]) {

            _adLabel.text = _shop.dikou;
        } else {

            _adHight.constant = 0;
            _adBgView.hidden = 0;
        }
    }
}

#pragma mark -tableView代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{

    if (tableView == self.foodDetailTabelView) {

        return 4;
        //        return 5;
    } else if (tableView == self.recomTableView) {

        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    if (tableView == self.LeftTableView) {

        return _categoryDataSource.count;
    } else if (tableView == self.rightTableView) {

        return _currentFoodDataSource.count;
    } else if (tableView == self.selectFoodTabelView) {

        return _choosedFoodDataSource.count;
    } else if (tableView == self.foodDetailTabelView) {

        if (section == 3) {

            return _rowsIntroduction;
        }
        return 1;
    } else if (tableView == _tasteTableView) {
        return _tasteDataSource.count;
    } else if (tableView == _seviceTableView) {
        return _serviceDataSource.count;
    } else if (tableView == _evnTableView) {
        return _evnDataSource.count;
    } else if (tableView == _recomTableView) {
        if (section == 0) {
            return 1;
        } else {
            return _recomDataSource.count;
        }
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    UITableViewCell* cell = [[UITableViewCell alloc] init];
    if (tableView == self.LeftTableView) {
        FDCategoryTableViewCell* categoryCell = [tableView dequeueReusableCellWithIdentifier:FDCategoryTableViewCellReuseId];
        if (cell == nil) {
            categoryCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FDCategoryTableViewCell class]) owner:self options:nil] lastObject];
        }
        if (indexPath.row == _currentSelectedIndex) {
            categoryCell.sliderView.hidden = NO;
            categoryCell.backgroundColor = [UIColor whiteColor];
        } else {
            categoryCell.sliderView.hidden = YES;
            categoryCell.backgroundColor = FDCategoryCellBackgroundColor;
        }
        if (_categoryDataSource.count > indexPath.row) {
            FDFoodCategoryModel* model = _categoryDataSource[indexPath.row];
            categoryCell.categoryLabel.text = model.itemCustomCategoryName;
        }
        categoryCell.selectionStyle = UITableViewCellSelectionStyleNone;

        return categoryCell;
    } else if (tableView == self.rightTableView) {

        FDChooseFoodTableViewCell* foodCell = [tableView dequeueReusableCellWithIdentifier:FDChooseFoodTableViewCellReuseId];
        if (cell == nil) {
            foodCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FDChooseFoodTableViewCell class]) owner:self options:nil] lastObject];
        }
        foodCell.isChoosedFoodCell = NO;
        _listFoodArr = _currentFoodDataSource;
        FDFoodDetailModel* model = nil;
        if (_currentFoodDataSource.count > indexPath.row) {
            model = _currentFoodDataSource[indexPath.row];
        }
        FDChoosedFoodModel* cModel = [[FDChoosedFoodModel alloc] init];
        cModel.food = model;
        cModel.count = 0;
        cModel.salesCount = 0;
        NSDictionary* itemSale = _shop.itemSale;
        NSNumber* salesCount = itemSale[model.foodId];
        if (salesCount) {
            cModel.salesCount = salesCount.integerValue;
        }

        cModel.format = [model.foodFormat firstObject];
        foodCell.model = cModel;

        foodCell.selectionStyle = UITableViewCellSelectionStyleNone;
        foodCell.delegat = self;
        return foodCell;
    } else if (tableView == self.selectFoodTabelView) { //已点菜品
        FDSelecteFoodCell* foodCell = [tableView dequeueReusableCellWithIdentifier:FDSelectFoodTabelViewCellId];
        if (foodCell == nil) {
            foodCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FDSelecteFoodCell class]) owner:self options:nil] lastObject];
        }
        foodCell.isChoosedFoodCell = YES;
        if (_currentFoodDataSource.count > indexPath.row) {
            FDChoosedFoodModel* choosedModel = _choosedFoodDataSource[indexPath.row];
            foodCell.model = choosedModel;
        }
        foodCell.selectionStyle = UITableViewCellSelectionStyleNone;
        foodCell.delegate = self;

        return foodCell;
    } else if (tableView == self.foodDetailTabelView) {

        if (indexPath.section == 0) {

            foodDetailTopCell* cell = [tableView dequeueReusableCellWithIdentifier:FoodDetailTopCellId];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([foodDetailTopCell class]) owner:self options:nil] lastObject];
            }

            //                cell.model=_shopModel;
            cell.shopDetailModel = _shopDetailModel;
            if (_isTakeaway) {

                cell.tipView.hidden = YES;
            } else {

                cell.brandLabel.hidden = YES;
            }
            [self setShowHsNoWithCell:cell];
            cell.block = ^() {

                [self contanctShopAction];

            };

            cell.selectionStyle = 0;
            return cell;
        } else if (indexPath.section == 1) {

            FoodBasicInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:FoodBasicInfoCellId];

            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FoodBasicInfoCell class]) owner:self options:nil] lastObject];
            }

            cell.model = _shopDetailModel;
            cell.shopModel = _shop;
            cell.delegate = self;
            cell.selectionStyle = 0;
            return cell;
        } else if (indexPath.section == 2) {

            FoodSeveiceCell* cell = [tableView dequeueReusableCellWithIdentifier:FoodSeveiceCellId];

            cell.model = _shopDetailModel;

            cell.selectionStyle = 0;

            return cell;
        } else if (indexPath.section == 3) {

            FoodShopDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:FoodShopDetailCellId];

            cell.shopDetailModel = _shopDetailModel;

            cell.selectionStyle = 0;

            return cell;
        }

        FoodBusinessCell* cell = [tableView dequeueReusableCellWithIdentifier:FoodBusinessCellId];

        return cell;
    } else {
        FDShopCommitCell* cell = [tableView dequeueReusableCellWithIdentifier:FDShopCommitCellReuseId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FDShopCommitCell class]) owner:self options:nil] lastObject];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (tableView == _tasteTableView) {
            if (_tasteDataSource.count > indexPath.row) {
                cell.model = _tasteDataSource[indexPath.row];
            }
        } else if (tableView == _seviceTableView) {
            if (_serviceDataSource.count > indexPath.row) {
                cell.isSeviceTableView = YES;
                cell.model = _serviceDataSource[indexPath.row];
            }
        } else if (tableView == _evnTableView) {
            if (_evnDataSource.count > indexPath.row) {
                cell.model = _evnDataSource[indexPath.row];
            }
        } else if (tableView == _recomTableView) {
            if (indexPath.section == 0) {

                FDRecomdFoodDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:FDRecomdFoodDetailCellId];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FDRecomdFoodDetailCell class]) owner:self options:nil] lastObject];
                }
                cell.selectionStyle = 0;
                cell.recomdFoods = _recomdFoods;
                return cell;
            } else {

                if (_recomDataSource.count > indexPath.row) {
                    cell.model = _recomDataSource[indexPath.row];
                }
            }
        }
        cell.dele = self;
        return cell;
    }

    cell.backgroundColor = [UIColor colorWithRed:234 / 255.0 green:234 / 255.0 blue:234 / 255.0 alpha:1];

    cell.selectionStyle = 0;
    return cell;
}

- (void)setShowHsNoWithCell:(foodDetailTopCell*)cell
{
    if (_shop.hsNo != nil) {

        NSString* str = _shop.hsNo;

        NSString* strOne = [str substringToIndex:2];
        NSString* strTwo = [str substringWithRange:NSMakeRange(2, 3)];
        NSString* strThree = [str substringWithRange:NSMakeRange(5, 2)];
        NSString* strFour = [str substringWithRange:NSMakeRange(7, 4)];

        cell.HSNumberLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@", kLocalized(@"GYHE_Food_CardState"), strOne, strTwo, strThree, strFour];
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{

    FDShopCommitModel* model;

    if (tableView == self.LeftTableView) {

        return 50;
    } else if (tableView == self.rightTableView) {

        return 85;
    } else if (tableView == self.selectFoodTabelView) {

        return 70;
    } else if (tableView == self.foodDetailTabelView) {

        if (indexPath.section == 0) {

            return 160;
        } else if (indexPath.section == 1) {

            return 175;
        } else if (indexPath.section == 2) {

            NSMutableArray* arr = [NSMutableArray array];

            NSString* str = @"0";

            if (_shopDetailModel.tickets) {

                str = @"1";

                [arr addObject:str];
            }
            if (_shopDetailModel.takeOut) {

                str = @"2";

                [arr addObject:str];
            }
            if (_shopDetailModel.appointment) {

                str = @"3";

                [arr addObject:str];
            }

            if (_shopDetailModel.parking) {

                str = @"4";

                [arr addObject:str];
            }

            if (_shopDetailModel.pickUp) {

                str = @"5";

                [arr addObject:str];
            }

            return arr.count * 30;
        } else if (indexPath.section == 3) {

            NSString* str = _shopDetailModel.introduce;

            CGFloat heigh = [GYUtils heightForString:str fontSize:12 andWidth:kScreenWidth - 40];

            return heigh + 10;
        }

        return 30;
    } else if (tableView == _tasteTableView) {
        if (_tasteDataSource.count > indexPath.row) {
            model = _tasteDataSource[indexPath.row];
        }
    } else if (tableView == _seviceTableView) {
        if (_serviceDataSource.count > indexPath.row) {
            model = _serviceDataSource[indexPath.row];
            model.recomFood = @"";
            model.recomReason = @"";
        }
    } else if (tableView == _evnTableView) {
        if (_evnDataSource.count > indexPath.row) {
            model = _evnDataSource[indexPath.row];
        }
    } else if (tableView == _recomTableView) {
        if (indexPath.section == 0) {

            if (_recomdFoods.count > 0) {

                NSString* str = [_recomdFoods componentsJoinedByString:@"   "];

                CGFloat hight = [GYUtils heightForString:str fontSize:12 andWidth:kScreenWidth - 20];
                return 34 + hight + 10;
            } else {
                return 0;
            }
        } else {

            if (_recomDataSource.count > indexPath.row) {
                model = _recomDataSource[indexPath.row];
            }
        }
    }
    return [tableView fd_heightForCellWithIdentifier:FDShopCommitCellReuseId
                                    cacheByIndexPath:indexPath
                                       configuration:^(FDShopCommitCell* cell) {
                                           cell.model = model;
                                       }];
    return 40;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.LeftTableView) {
        _currentSelectedIndex = indexPath.row;

        if (_currentSelectedIndex == 0 && _recomId != nil) {

            FDFoodCategoryModel* model = _categoryDataSource[_currentSelectedIndex];
            NSString* categoryId = model.itemCustomCategoryId;
            _currentFoodDataSource = [_allFoodDataSources objectForKey:categoryId];

            for (FDFoodDetailModel* model in _currentFoodDataSource) {

                if ([_recomId isEqualToString:model.foodId]) {

                    FDFoodDetailModel* tempModel = model;
                    _currentFoodDataSource = [_currentFoodDataSource mutableCopy];
                    [_currentFoodDataSource removeObject:model];

                    [_currentFoodDataSource insertObject:tempModel atIndex:0];

                    [tableView reloadData];
                    [self.rightTableView reloadData];

                    return;
                }
            }
        }

        [tableView reloadData];
        FDFoodCategoryModel* model = _categoryDataSource[_currentSelectedIndex];
        NSString* categoryId = model.itemCustomCategoryId;
        _currentFoodDataSource = [_allFoodDataSources objectForKey:categoryId];

        if (_currentFoodDataSource.count < 1) {
            self.rightTableView.tableFooterView = _noResultView;
        } else {
            self.rightTableView.tableFooterView = [[UIView alloc] init];
        }
        [self.rightTableView reloadData];
    } else if (tableView == self.rightTableView) {
    } else if (tableView == self.recomTableView) {

        if (indexPath.section == 0) {

            FDShopDetailRecomFoodViewController* vc = [[FDShopDetailRecomFoodViewController alloc] init];

            vc.datas = _recomdDatas;

            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{

    if (tableView == self.foodDetailTabelView) {

        if (section == 3) {

            return [self seeShopIntroduction];
        }
    }

    return nil;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{

    if (tableView == self.foodDetailTabelView || tableView == self.tasteTableView) {

        if (section == 0) {

            return 0;
        } else if (section == 3) {
            if (tableView == self.foodDetailTabelView) {

                return 50;
            }
            return 20;
        }
        return 20;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{

    if (tableView == self.recomTableView) {

        if (section == 0) {

            if (_recomdFoods.count > 0) {

                return 20;
            }

            return 0;
        }
    }

    return 0;
}

- (UIView*)seeShopIntroduction
{
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    UIView* bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    bg.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
    [v addSubview:bg];
    UIButton* btnChechShop = [UIButton buttonWithType:UIButtonTypeCustom];
    btnChechShop.frame = CGRectMake(kDefaultMarginToBounds, 20, kScreenWidth - kDefaultMarginToBounds, 30);
    btnChechShop.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnChechShop.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnChechShop setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    [btnChechShop setTitle:kLocalized(@"GYHE_Food_ShopIntroduction") forState:UIControlStateNormal];
    [btnChechShop addTarget:self action:@selector(seeIntroduction) forControlEvents:UIControlEventTouchUpInside];
    _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnChechShop.frame) - 30, 25, 10, 15)];
    if (_isPull) {

        _arrowView.image = [UIImage imageNamed:@"gyhe_food_return_down"];
    } else {

        _arrowView.image = [UIImage imageNamed:@"gyhe_food_return_right"];
    }

    [v addSubview:_arrowView];
    [v addSubview:btnChechShop];
    [v addBottomBorder];
    return v;
}

- (void)seeIntroduction
{
    if (_shopDetailModel.introduce.length == 0) {
        [GYUtils showMessage:kLocalized(@"GYHE_Food_NoShopIntroduce")];
        return;
    }
    DDLogDebug(@"查看简介");
    _isPull = !_isPull;

    [UIView animateWithDuration:0.3
        animations:^{

        }
        completion:^(BOOL finished) {
            if (_isShowIntroduction) {
                _rowsIntroduction = 1;
                NSIndexSet* indexSet = [[NSIndexSet alloc] initWithIndex:3];
                [self.foodDetailTabelView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                _isShowIntroduction = !_isShowIntroduction;
            } else {
                _rowsIntroduction = 0;

                NSIndexSet* indexSet = [[NSIndexSet alloc] initWithIndex:3];
                [self.foodDetailTabelView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                _isShowIntroduction = !_isShowIntroduction;
            }
        }];
}

- (void)setupFormatView
{
    //多规格菜单
    _coverBlackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _coverBlackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:_coverBlackView];
    _coverBlackView.hidden = YES;
    _foodFormatView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 150);
    [self.view addSubview:_foodFormatView];

    //    已点菜单视图
    _selectView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 250);

    [self.view addSubview:_selectView];

    //餐厅详情视图
    self.foodDetailBgView.frame = CGRectMake(0, 40, kScreenWidth, kScreenHeight - 40 - 64);

    [self.view addSubview:self.foodDetailBgView];

    //评价详情视图

    self.averageBgView.frame = CGRectMake(0, 40, kScreenWidth, kScreenHeight - 40 - 64);
    [self.view addSubview:self.averageBgView];

    self.foodDetailBgView.hidden = YES;

    self.averageBgView.hidden = YES;

    if (_isTakeaway) {

        _evnBarViewHight.constant = 0;

        _evnScoreView.hidden = YES;

        _topShowListViewHight.constant = 70;
    }

    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.orderImageView.frame) + 15, CGRectGetMaxY(self.CashLabel.frame) - 1, 150, 15)];

    _tipLabel.font = [UIFont systemFontOfSize:8];

    _tipLabel.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];

    [self.bottomBgView addSubview:_tipLabel];

    _tipLabel.hidden = YES;
}

- (void)cellValueChangedChoosedModel:(FDChoosedFoodModel*)model Cell:(UITableViewCell*)cell View:(UIView*)view
{
    if (_isTakeaway) {

        _tipLabel.hidden = NO;
    }

    FDFoodDetailModel* food = model.food;

    if (model.count == 0) {
        int row = 0;
        for (int i = 0; i < _choosedFoodDataSource.count; i++) {
            if (_choosedFoodDataSource[i] == model) {
                row = i;
            }
        }
        [_choosedFoodDataSource removeObject:model];

        [self.selectFoodTabelView reloadData];
    } else {
        for (int i = 0; i < _choosedFoodDataSource.count; i++) {
            FDChoosedFoodModel* eModel = _choosedFoodDataSource[i];
            if ([eModel.food.foodId isEqualToString:food.foodId]) {
                if (eModel != model) {
                    eModel.count++;
                    model.count = eModel.count;
                }

                [self updateAllChoosedFoodCount];
                return;
            }
        }
        [_choosedFoodDataSource addObject:model];
    }

    [self updateAllChoosedFoodCount];
}

- (void)showFoodFormatChoosedVC:(FDChoosedFoodModel*)model
{
    [_formatCategoryBtns removeAllObjects];
    for (UIView* view in self.formatBtnContainerView.subviews) {
        [view removeFromSuperview];
    }
    _currentChoosedFormatFoodModel = model;
    FDFoodDetailModel* _currentChoosedFormatFood = model.food;
    _formatNameLabel.text = _currentChoosedFormatFood.name;
    NSArray* formats = _currentChoosedFormatFood.foodFormat;
    FDFoodFormatModel* formatModel = formats[0];
    self.specificationsLabel.text = formatModel.pName;
    CGFloat btnWidth = (_formatBtnContainerView.bounds.size.width - 20 * (formats.count - 1)) / formats.count;
    CGFloat btnHeight = _formatBtnContainerView.bounds.size.height;
    for (int i = 0; i < formats.count; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((btnWidth + 20) * i, 0, btnWidth, btnHeight);
        btn.layer.cornerRadius = 4;
        btn.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        [btn setTitleColor:kNavigationBarColor forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [btn addTarget:self action:@selector(formatCategoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn.selected = YES;
            btn.layer.borderColor = kNavigationBarColor.CGColor;
            _currentSelectedFormatIndex = i;
        }
        FDFoodFormatModel* model = formats[i];
        [btn setTitle:model.pVName forState:UIControlStateNormal];
        [self.formatBtnContainerView addSubview:btn];
        [_formatCategoryBtns addObject:btn];

        //self.specificationsLabel.text = model.pName;
    }

    [UIView animateWithDuration:0.25
                     animations:^{
                         _foodFormatView.frame = CGRectMake(0, kScreenHeight - 150 - 64, kScreenWidth, 150);
                     }];
    _coverBlackView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _coverBlackView.hidden = NO;
    [self formatCategoryBtnClicked:_formatCategoryBtns[0]];
}

- (IBAction)formatConfirmBtnClicked:(id)sender
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         _foodFormatView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 150);
                     }];
    _coverBlackView.hidden = YES;
}

- (IBAction)selectFoodConfirmBtnAciton:(id)sender
{

    DDLogDebug(@"关闭已点菜单");

    [UIView animateWithDuration:0.25
                     animations:^{
                         _selectView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 250);
                     }];
    _coverBlackView.hidden = YES;

    _currentFoodDataSource = _listFoodArr;

    [self.rightTableView reloadData];
}

- (IBAction)formatMinusBtnClicked:(id)sender
{
    if (_currentChoosedFormatFoodModel.count > 0) {
        _currentChoosedFormatFoodModel.count--;
    }
    if (_currentChoosedFormatFoodModel.count <= 0) {
        _currentChoosedFormatFoodModel.count = 0;
    }
    [self updateAllChoosedFoodCount];
}

- (IBAction)formatAddBtnClicked:(id)sender
{

    if (_isTakeaway) {

        _tipLabel.hidden = NO;
    }

    self.rec = self.animtedLabel.frame;
    self.animtedLabel.hidden = NO;
    [UIView animateWithDuration:0.5
        animations:^{

            self.animtedLabel.frame = CGRectMake(self.rec.origin.x, self.rec.origin.y - 3, self.rec.size.width, self.rec.size.height);

        }
        completion:^(BOOL finished) {

            self.animtedLabel.hidden = YES;
            self.animtedLabel.frame = self.rec;

        }];

    FDFoodDetailModel* food = _currentChoosedFormatFoodModel.food;
    FDFoodFormatModel* format = [food.foodFormat objectAtIndex:_currentSelectedFormatIndex];
    for (int i = 0; i < _choosedFoodDataSource.count; i++) {

        FDChoosedFoodModel* eModel = _choosedFoodDataSource[i];
        if ([eModel.food.foodId isEqualToString:food.foodId] && [eModel.format.pVName isEqualToString:format.pVName]) {
            eModel.count++;
            _currentChoosedFormatFoodModel.count = eModel.count;
            [self updateAllChoosedFoodCount];
            return;
        }
    }
    FDChoosedFoodModel* newChoosedFood = [[FDChoosedFoodModel alloc] init];
    newChoosedFood.food = food;
    newChoosedFood.count = 1;
    newChoosedFood.format = format;
    [_choosedFoodDataSource addObject:newChoosedFood];
    _currentChoosedFormatFoodModel = newChoosedFood;
    [self updateAllChoosedFoodCount];
}

#pragma mark - 主菜单列表
- (IBAction)mainFoodAction:(UIButton*)sender
{

    [self.mainFoodBtn setTitleColor:kNavigationBarColor forState:0];
    [self.foodDetailBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.averageBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    [UIView animateWithDuration:0.3
                     animations:^{

                         self.moveView.frame = CGRectMake(self.mainFoodBtn.frame.origin.x, self.rect.origin.y, self.rect.size.width, self.rect.size.height);

                     }];

    self.foodDetailBgView.hidden = YES;

    self.averageBgView.hidden = YES;
}

#pragma mark - 进入已点菜单

- (void)myGes
{

    if (_choosedFoodCount <= 0) {
        return;
    }
    DDLogDebug(@"已点菜单");

    if (_choosedFoodCount > 0) {

        [UIView animateWithDuration:0.25
                         animations:^{

                             _selectView.frame = CGRectMake(0, kScreenHeight - 250 - 64 - 43, kScreenWidth, 250);
                         }];

        _coverBlackView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth - 43);
        _coverBlackView.hidden = NO;

        //        _currentFoodDataSource = _choosedFoodDataSource;
        if (_choosedFoodDataSource.count < 1) {
            self.selectFoodTabelView.tableFooterView = _noResultView;
        } else {
            self.selectFoodTabelView.tableFooterView = [[UIView alloc] init];
        }
        [self.selectFoodTabelView reloadData];
    }
}

#pragma mark - 进入餐厅详情
- (IBAction)foodDetailAction:(UIButton*)sender
{

    [self.foodDetailTabelView reloadData];

    [self.foodDetailBtn setTitleColor:kNavigationBarColor forState:0];
    [self.mainFoodBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.averageBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.moveView.frame = CGRectMake(self.foodDetailBtn.frame.origin.x, self.rect.origin.y, self.rect.size.width, self.rect.size.height);
                     }];

    self.averageBgView.hidden = YES;
    self.foodDetailBgView.hidden = NO;

    [self loadDataDetail];
}

- (void)loadDataDetail
{

    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];

    if (_shopModel.vShopId != nil && _shopModel.shopId != nil) {

        [dict setObject:_shopModel.shopId forKey:@"shopId"];

        [dict setObject:_shopModel.vShopId forKey:@"vShopId"];
    } else {

        [dict setObject:kSaftToNSString(_shopId) forKey:@"shopId"];

        [dict setObject:kSaftToNSString(_vShopId) forKey:@"vShopId"];
    }
    [GYGIFHUD show];
    [FDShopDetailModel modelArrayNetURL:FoodDetailUrl
                             parameters:dict
                                 option:GYM_GetJson
                             completion:^(NSArray* modelArray, id responseObject, NSError* error) {

                                 [GYGIFHUD dismiss];

                                 _shopDetailModel = modelArray.firstObject;

                                 [self.foodDetailTabelView reloadData];

                             }];
}

- (void)setShopTopAvarage
{

    _haopingRateLabel.text = [NSString stringWithFormat:@"%.0f", _commentModel.totalScore];

    if (_commentModel.score >= 0) {

        _tastScoreLabel.text = [NSString stringWithFormat:@"%.0f%%", _commentModel.score];
    }

    if (_commentModel.serviceScore >= 0) {

        _seviceScoreLabel.text = [NSString stringWithFormat:@"%d%%", (int)(_commentModel.serviceScore + 0.5)];
    }
    if (_commentModel.surroundingsScore >= 0) {

        _evnScoreLabel.text = [NSString stringWithFormat:@"%.0f%%", _commentModel.surroundingsScore];
    }

    for (NSInteger i = 0; i < 3; i++) {

        NSInteger shopPoint;

        if (i == 0) {

            shopPoint = _commentModel.score;
            _ScoreIndex = 1;
        } else if (i == 1) {

            shopPoint = _commentModel.serviceScore;
            _ScoreIndex = 2;
        } else {

            shopPoint = _commentModel.surroundingsScore;
            _ScoreIndex = 3;
        }

        [self setPointWith:shopPoint];
    }
}

- (void)setPointWith:(NSInteger)shopPoint
{

    NSInteger score = 0;
    if (shopPoint == 0) {
        score = 0;
    } else if (shopPoint > 0 && shopPoint <= 60) {
        score = 1;
    } else if (shopPoint > 60 && shopPoint <= 70) {
        score = 2;
    } else if (shopPoint > 70 && shopPoint <= 80) {
        score = 3;
    } else if (shopPoint > 80 && shopPoint <= 90) {
        score = 4;
    } else if (shopPoint > 90 && shopPoint <= 100) {
        score = 5;
    }
    [self setTagScoreViewWithScore:score scoreIndex:_ScoreIndex];
}

- (void)setTagScoreViewWithScore:(NSInteger)score scoreIndex:(NSInteger)scoreIndex
{
    UIImage* image0 = [UIImage imageNamed:@"gyhe_food_flower1"];
    UIImage* image1 = [UIImage imageNamed:@"gyhe_food_flower2"];
    UIImage* image2 = [UIImage imageNamed:@"gyhe_food_flower3"];

    UIImageView* imgView0;
    UIImageView* imgView1;
    UIImageView* imgView2;
    if (scoreIndex == 1) {

        imgView0 = _tastImageView0;
        imgView1 = _tastImageView1;
        imgView2 = _tastImageView2;
    } else if (scoreIndex == 2) {

        imgView0 = _seviceImageView0;
        imgView1 = _seviceImageView1;
        imgView2 = _seviceImageView2;
    } else {

        imgView0 = _evnImageView0;
        imgView1 = _evnImageView1;
        imgView2 = _evnImageView2;
    }

    switch (score) {
    case 5:
        imgView0.image = image0;
        imgView1.image = image0;
        imgView2.image = image0;
        break;
    case 4:
        imgView0.image = image0;
        imgView1.image = image0;
        imgView2.image = image1;
        break;
    case 3:
        imgView0.image = image0;
        imgView1.image = image0;
        imgView2.image = image2;
        break;
    case 2:
        imgView0.image = image0;
        imgView1.image = image1;
        imgView2.image = image2;
        break;
    case 1:
        imgView0.image = image0;
        imgView1.image = image2;
        imgView2.image = image2;
        break;

    default:
        imgView0.image = image2;
        imgView1.image = image2;
        imgView2.image = image2;
        break;
    }
}

#pragma mark - 进入评价
- (IBAction)averageAction:(UIButton*)sender
{

    [self.averageBtn setTitleColor:kNavigationBarColor forState:0];
    [self.foodDetailBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.mainFoodBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3
                     animations:^{

                         self.moveView.frame = CGRectMake(self.averageBtn.frame.origin.x, self.rect.origin.y, self.rect.size.width, self.rect.size.height);
                     }];

    self.averageBgView.hidden = NO;
    self.foodDetailBgView.hidden = YES;

    [self loadDataAll];

    [self getShopCommitInfo];
}

- (void)getShopCommitInfo
{

    NSMutableDictionary* dict = [NSMutableDictionary dictionary];

    if (_shop.vShopId != nil && _shop.shopId != nil) {

        [dict setObject:_shop.vShopId forKey:@"vshopId"];

        [dict setObject:_shop.shopId forKey:@"shopId"];
    }

    [FDShopCommentModel modelArrayNetURL:GetFoodShopCommitFoodScoreUrl
                              parameters:dict
                                  option:GYM_GetJson
                              completion:^(NSArray* modelArray, id responseObject, NSError* error) {

                                  _commentModel = modelArray.firstObject;

                                  [self setShopTopAvarage];
                              }];
}

- (void)loadDataAll
{
    //    add zhangxin  解决重复点击评价 评价列表内容重复问题
    [_tasteDataSource removeAllObjects];
    [_serviceDataSource removeAllObjects];
    [_evnDataSource removeAllObjects];
    [_recomDataSource removeAllObjects];

    _currentPages = [@[ @1, @1, @1, @1 ] mutableCopy];
    for (int i = 0; i < _dataSourceArray.count; i++) {
        [self loadDataWithTableIndex:i];
    }
}

- (void)loadDataWithTableIndex:(NSInteger)index;
{

    NSArray* searchTypeArray = @[ @"1", @"5", @"2", @"3" ];
    NSArray* noResultViews = @[ _noResultAvrageView, _noResultAvrageView1, _noResultAvrageView2, _noResultAvrageView3 ];
    UIView* noResultView = noResultViews[index];
    UITableView* tableView = _tableArray[index];
    NSMutableArray* dataSource = _dataSourceArray[index];
    [_params setObject:searchTypeArray[index] forKey:@"searchType"];
    [_params setObject:[_currentPages[index] stringValue] forKey:@"currentPage"];
    [GYGIFHUD show];
    [FDShopCommitModel modelArrayNetURL:GetFoodShopCommentUrl
                             parameters:_params
                                 option:GYM_GetJson
                             completion:^(NSArray* modelArray, id responseObject, NSError* error) {

                                 [GYGIFHUD dismiss];
                                 if ([_currentPages[index] integerValue] == 1) {

                                     //            [_recomdDatas removeAllObjects];
                                 }
                                 [tableView.mj_header endRefreshing];
                                 [tableView.mj_footer endRefreshing];
                                 [dataSource addObjectsFromArray:modelArray];

                                 if ([_currentPages[index] integerValue] >= [[responseObject objectForKey:@"totalPage"] integerValue]) {
                                     [tableView.mj_footer endRefreshingWithNoMoreData];
                                 } else {
                                     [tableView.mj_footer resetNoMoreData];
                                 }

                                 if (modelArray.count > 0) {
                                     FDShopCommitModel* model = modelArray[0];
                                     //            if (model.tasteNum.integerValue>0) {
                                     //
                                     _tastNumLabel.text = [NSString stringWithFormat:@"(%ld)", kSaftToNSInteger(model.tasteNum)];
                                     //            }
                                     //            if (model.serviceNum.integerValue>0) {
                                     //
                                     _seviceNumLabel.text = [NSString stringWithFormat:@"(%ld)", kSaftToNSInteger(model.serviceNum)];
                                     //            }
                                     //            if (model.evnNum.integerValue>0) {
                                     //
                                     _evnNumLabel.text = [NSString stringWithFormat:@"(%ld)", (long)kSaftToNSInteger(model.evnNum)];
                                     //            }
                                     //            if (model.recomNum.integerValue>0) {

                                     _recomNumLabel.text = [NSString stringWithFormat:@"(%ld)", kSaftToNSInteger(model.recomNum)];
                                     //            }
                                 }

                                 if (index == 3) {

                                     //        获取推荐菜及推荐人数 数组

                                     for (FDShopCommitModel* tempModel in modelArray) {

                                         if (![_recomdFoods containsObject:tempModel.recomFood] && tempModel.recomFood != nil && ![tempModel.recomFood isEqualToString:@""]) {

                                             FDRecomdModel* model = [[FDRecomdModel alloc] init];

                                             model.recomFood = tempModel.recomFood;
                                             model.cont = [tempModel.cont integerValue];
                                             model.pics = tempModel.pics;
                                             model.recomId = tempModel.recomId;
                                             [_recomdDatas addObject:model];
                                             [_recomdFoods addObject:tempModel.recomFood];
                                         }
                                     }
                                 }

                                 if (dataSource.count <= 0) {
                                     tableView.tableFooterView = noResultView;
                                 } else {
                                     tableView.tableFooterView = [[UIView alloc] init];
                                 }
                                 [tableView reloadData];
                             }];
}

- (void)loadDataClearWithTableIndex:(NSInteger)index;
{
    NSNumber* currentPage = _currentPages[index];
    currentPage = @(1);
    [_currentPages replaceObjectAtIndex:index withObject:currentPage];
    NSMutableArray* dataSource = _dataSourceArray[index];
    [dataSource removeAllObjects];

    [self loadDataWithTableIndex:index];
}

#pragma mark - 评价切换

- (IBAction)tagBtnClick:(UIButton*)sender
{

    NSInteger index = sender.tag - 10000;
    CGRect frame = _sliderScrollView.frame;
    frame.origin.x = index * kScreenWidth;
    [_sliderScrollView scrollRectToVisible:frame animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (scrollView == _sliderScrollView) {

        CGFloat offsetX = scrollView.contentOffset.x;
        int index = (offsetX + (kScreenWidth / 2)) / kScreenWidth;

        [self setTagViewColorIndex:index];
    }
}

- (void)setTagViewColorIndex:(int)index
{
    NSArray* tagLabels = @[ _tastLabel, _tastNumLabel, _seviceLabel, _seviceNumLabel, _evnLabel, _evnNumLabel, _recomLabel, _recomNumLabel ];
    for (int i = 0; i < tagLabels.count; i++) {
        UILabel* label = tagLabels[i];
        [label setTextColor:[UIColor darkGrayColor]];
        if (i == index * 2 || i == (index * 2 + 1)) {
            [label setTextColor:kNavigationBarColor];
        }
    }
}

- (void)formatCategoryBtnClicked:(UIButton*)button
{
    for (int i = 0; i < _formatCategoryBtns.count; i++) {
        UIButton* btn = _formatCategoryBtns[i];
        btn.selected = NO;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        if (btn == button) {
            _currentSelectedFormatIndex = i;
        }
    }
    FDFoodFormatModel* format = [_currentChoosedFormatFoodModel.food.foodFormat objectAtIndex:_currentSelectedFormatIndex];
    _formatPriceLabel.text = [NSString stringWithFormat:@"%.2f", format.price.doubleValue];
    _formatPVLabel.text = [NSString stringWithFormat:@"%.2f", format.auction.doubleValue];
    button.selected = YES;
    button.layer.borderColor = kNavigationBarColor.CGColor;
}

- (void)updateAllChoosedFoodCount
{
    _choosedFoodCount = 0;
    _choosedFoodCoinCount = 0;
    _choosedFoodPvCount = 0;
    for (int i = 0; i < _choosedFoodDataSource.count; i++) {
        FDChoosedFoodModel* model = _choosedFoodDataSource[i];
        FDFoodFormatModel* format = model.format;
        _choosedFoodCount += model.count;
        _choosedFoodCoinCount += [format.price doubleValue] * model.count;
        _choosedFoodPvCount += [format.auction doubleValue] * model.count;
    }
    if (_choosedFoodCount > 0) {
        self.orderLablel.hidden = NO;
        self.orderBtn.hidden = NO;
    } else {
        self.orderLablel.hidden = YES;
        self.orderBtn.hidden = YES;
    }
    self.orderLablel.text = @(_choosedFoodCount).stringValue;
    //    _choosedFoodCoinCount = _choosedFoodCoinCount+0.01;
    //    self.CashLabel.text = [NSString stringWithFormat:@"%0.1f0",_choosedFoodCoinCount];

    //self.CashLabel.text = [NSString stringWithFormat:@"%.2f", _choosedFoodCoinCount];
    NSString* priceStr = [self roundUp:_choosedFoodCoinCount afterPoint:1];
    self.CashLabel.text = [NSString stringWithFormat:@"%.2f", priceStr.floatValue];

    self.intergrationLabel.text = [NSString stringWithFormat:@"%0.2f", _choosedFoodPvCount];
}

/**
 *  给数字做四舍五入
 *
 *  @param number   需要处理的数字
 *  @param position 保留小数点第几位
 *
 *  @return 返回四舍五入后的字符串
 */
- (NSString*)roundUp:(double)number afterPoint:(int)position
{

    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];

    //NSDecimalNumber *ouncesDecimal = [NSDecimalNumber decimalNumberWithString:number];
    NSDecimalNumber* ouncesDecimal = [[NSDecimalNumber alloc] initWithDouble:number];
    NSDecimalNumber* roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];

    return [NSString stringWithFormat:@"%@", roundedOunces];
}

#pragma mark - 进入订单
- (IBAction)orderAction:(id)sender
{

    kCheckLogined

        if (!self.shopModel.pickUp && !self.shopModel.appointment && !self.isTakeaway)
    {
        [self.view makeToast:kLocalized(@"GYHE_Food_RestaurantNoSupportOnlineOrdering")];
        return;
    }
    if (!(_choosedFoodCount > 0 && (!self.isTakeaway || (self.isTakeaway && [_shop.sendPriceMin doubleValue] <= @(_choosedFoodCoinCount).doubleValue)))) {
        [self.view makeToast:kLocalized(@"GYHE_Food_NoReachStartPrice")];
        return;
    }
    if (self.isSearch) {

        if ((self.isTakeaway && [self.dist doubleValue] >= [_shop.sendRange doubleValue]) || _shop.sendRange == nil || _shop.sendRange.length == 0) {

            //            [self.view makeToast:@"您的位置已超出配送范围，换一家店试试吧!"];

            [GYUtils showMessage:kLocalized(@"GYHE_Food_SettlementTip") confirm:^{
                [self confirmBtnClick];
            }];
            return;
        }
    } else {

        if (self.isTakeaway && !self.shopModel.isInSendRange) {

            //            [self.view makeToast:@"您的位置已超出配送范围，换一家店试试吧!"];

            [GYUtils showMessage:kLocalized(@"GYHE_Food_SettlementTip") confirm:^{
                [self confirmBtnClick];
            }];
            return;
        }
    }
    //    add zhangxin 正常能够下单问题修改
    FDOrderConfirmModel* order = [[FDOrderConfirmModel alloc] init];
    if (_isTakeaway) {
        order.type = @"2";
    } else {
        order.type = @"1";
    }
    order.fullOffDesc = _shop.fullOffDesc;
    order.shopId = _shop.shopId;
    order.vShopId = _shop.vShopId;
    order.totalAmount = @(_choosedFoodCoinCount).stringValue;
    order.totalPv = @(_choosedFoodPvCount).stringValue;
    order.foodArr = _choosedFoodDataSource;
    order.restaurantAddres = _shop.shopAddr;
    order.restaurantName = _shop.shopName;
    order.openingHours = _shop.openingHours;
    order.moneyEarnest = _shop.moneyEarnest;
    order.fullPrice = _shop.fullPrice;
    order.offPrice = _shop.offPrice;
    //满减通过店铺简介中拿值
    if (_choosedFoodCoinCount >= [_shop.fullPrice doubleValue]) {

        order.sendPrice = [NSString stringWithFormat:@"%.2f", ([_shop.sendPrice doubleValue] - [_shop.offPrice doubleValue])];
    } else {
        order.sendPrice = _shop.sendPrice;
    }
    order.timeresultShop2 = _shop.timeresultShop2;
    order.timeresultSince2 = _shop.timeresultSince2;
    order.timeresultTakeaway = _shop.timeresultTakeaway;
    order.supportAppointment = self.shopModel.appointment;
    order.timeresultShopNoShop = _shop.timeresultShopNoOpen;
    order.timeresultSinceNoShop = _shop.timeresultSinceNoOpen;
    order.supportTake = self.shopModel.pickUp;
    if (_isTakeaway == YES) { //送外卖

        if (_shop.orderHours.length > 11) { //返回时间长度大于11

            NSString* orderHours = _shop.orderHours;
            NSInteger BeginHour = kSaftToNSInteger([orderHours substringToIndex:2]); //开始小时
            NSInteger BeginMin = kSaftToNSInteger([orderHours substringWithRange:NSMakeRange(3, 2)]); //开始分钟
            NSInteger EndHour = kSaftToNSInteger([orderHours substringWithRange:NSMakeRange(6, 2)]); //结束小时
            NSInteger EndMin = kSaftToNSInteger([orderHours substringWithRange:NSMakeRange(9, 2)]); //结束分钟
            NSDate* now = [NSDate date];
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
            NSDateComponents* dateComponent = [calendar components:unitFlags fromDate:now];
            NSInteger nowHour = [dateComponent hour];
            NSInteger nowMinute = [dateComponent minute];
            if ((nowHour > EndHour) || (nowHour < BeginHour) || (nowHour == BeginHour && nowMinute < BeginMin) || (nowHour == EndHour && nowMinute > EndMin) || (nowHour == BeginHour && nowHour == EndHour && nowMinute > EndMin)) {
                [self.view makeToast:kLocalized(@"GYHE_Food_NoreceiveTimeInscheduled")];
                return;
            } else {
                GYConfirmOrdersController* orderVC = [[GYConfirmOrdersController alloc] init];
                orderVC.orderConfirModel = order;
                [self.navigationController pushViewController:orderVC animated:YES];
            }
        }
    } else {
        GYConfirmationViewController* orderVC = [[GYConfirmationViewController alloc] initWithNibName:NSStringFromClass([GYConfirmationViewController class]) bundle:[NSBundle mainBundle]];
        orderVC.orderConfirModel = order;
        [self.navigationController pushViewController:orderVC animated:YES];
    }
}

- (void)confirmBtnClick {
    FDOrderConfirmModel* order = [[FDOrderConfirmModel alloc] init];
    if (_isTakeaway) {
        order.type = @"2";
    } else {
        order.type = @"1";
    }
    order.shopId = _shop.shopId;
    order.vShopId = _shop.vShopId;
    order.totalAmount = @(_choosedFoodCoinCount).stringValue;
    order.totalPv = @(_choosedFoodPvCount).stringValue;
    order.foodArr = _choosedFoodDataSource;
    order.restaurantAddres = _shop.shopAddr;
    order.restaurantName = _shop.shopName;
    order.openingHours = _shop.openingHours;
    order.moneyEarnest = _shop.moneyEarnest;
    order.fullPrice = _shop.fullPrice;
    order.offPrice = _shop.offPrice;
    //满减通过店铺简介中拿值
    if (_choosedFoodCoinCount >= [_shop.fullPrice doubleValue]) {
        
        order.sendPrice = [NSString stringWithFormat:@"%.2f", ([_shop.sendPrice doubleValue] - [_shop.offPrice doubleValue])];
    } else {
        order.sendPrice = _shop.sendPrice;
    }
    order.timeresultShop2 = _shop.timeresultShop2;
    order.timeresultSince2 = _shop.timeresultSince2;
    order.timeresultTakeaway = _shop.timeresultTakeaway;
    order.supportAppointment = self.shopModel.appointment;
    order.timeresultShopNoShop = _shop.timeresultShopNoOpen;
    order.timeresultSinceNoShop = _shop.timeresultSinceNoOpen;
    order.supportTake = self.shopModel.pickUp;
    if (_isTakeaway == YES) {
        GYConfirmOrdersController* orderVC = [[GYConfirmOrdersController alloc] init];
        orderVC.orderConfirModel = order;
        [self.navigationController pushViewController:orderVC animated:YES];
    } else {
        GYConfirmationViewController* orderVC = [[GYConfirmationViewController alloc] initWithNibName:NSStringFromClass([GYConfirmationViewController class]) bundle:[NSBundle mainBundle]];
        orderVC.orderConfirModel = order;
        [self.navigationController pushViewController:orderVC animated:YES];
    }
}

- (void)contanctShopAction
{

    kCheckLogined
        NSMutableDictionary* dict
        = [[NSMutableDictionary alloc] init];
    if (!_shop.hsNo || !globalData.loginModel.token) {
        [GYUtils showMessage:kLocalized(@"GYHE_Food_CompanyResNo") confirm:nil];
        return;
    }
    [dict setValue:[NSString stringWithFormat:@"%@", _shop.hsNo] forKey:@"resourceNo"];
    [dict setValue:globalData.loginModel.token forKey:@"key"];

    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:GetVShopShortlyInfoUrl
                                                     parameters:dict
                                                  requestMethod:GYNetRequestMethodGET
                                              requestSerializer:GYNetRequestSerializerJSON
                                                   respondBlock:^(NSDictionary* responseObject, NSError* error) {
                                                       [GYGIFHUD dismiss];
                                                       if (error) {
                                                           WS(weakSelf)
                                                               [GYUtils parseNetWork:error
                                                                         resultBlock:nil];
                                                           [weakSelf.navigationController popViewControllerAnimated:YES];
                                                           return;
                                                       }
                                                       if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               GYHDChatViewController* chatViewController = [[GYHDChatViewController alloc] init];

                                                               chatViewController.companyInformationDict = responseObject;
                                                               [self.navigationController pushViewController:chatViewController animated:YES];
                                                           });
                                                       }
                                                   }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

@end
