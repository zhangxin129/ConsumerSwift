//
//  GYEasyBuyViewController.m
//  HSConsumer
//
//  Created by apple on 14-11-26.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEasyBuyViewController.h"
#import "GYEasyBuyModel.h"
#import "GYEeayBuyTableViewCell.h"
#import "GYEasybuyMainViewController.h"
#import "DropDownWithChildListView.h"
#import "GYEasybuyGoodsInfoViewController.h"
#import "GYGoodCategoryModel.h"
#import "EasyPurchaseData.h"
#import "GYSortTypeModel.h"
#import "GYEPMyHEViewController.h"
#import "GYGIFHUD.h"
#import "GYAppDelegate.h"
#import "GYHSLoginViewController.h"
#import "GYHSLoginManager.h"
#define pageCount 8
@interface GYEasyBuyViewController ()
@property (nonatomic, strong) NSString* hasCoupon;
// 记录传递过来的序号
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) DropDownWithChildListView* dropDownView;
@end

@implementation GYEasyBuyViewController {
    __weak IBOutlet UITableView* tvEasyBuy;
    NSMutableArray* marrEasyBuySource;
    NSMutableArray* chooseArray;
    NSMutableArray* marrCategoryLevelTwo;
    NSInteger sectionNumber;
    NSInteger indexNumber; // 记录上一级分类位置
    UITableView* tempTv;
    NSMutableArray* testArr;
    NSMutableArray* marrCategoryLevelOne;
    NSMutableArray* marrLevelTwoTitle;

    NSInteger levelTwo;
    NSMutableArray* marrSortType;
    NSMutableArray* marrSortTtile;

    NSMutableArray* marrSortName;
    NSMutableArray* marrSortNameTitle;

    NSString* strSortType;
    NSString* strSpecialService;
    NSString* strCategory;

    NSMutableArray* marrSpecailService;

    NSInteger currentPage;
    NSInteger totalCount;

    BOOL isUpFresh;

    NSInteger totalPage;

    UIButton* _backTopBtn; //返回顶部按钮
    NSMutableArray* mTitleArray;
}

#pragma-- 系统方法

- (void)viewDidLoad
{
    [super viewDidLoad];

    mTitleArray = [NSMutableArray array];
    testArr = [NSMutableArray array];
    marrEasyBuySource = [NSMutableArray array];
    marrCategoryLevelOne = [NSMutableArray array];
    marrCategoryLevelTwo = [NSMutableArray array];
    marrLevelTwoTitle = [NSMutableArray array];

    marrSortType = [NSMutableArray array];
    marrSortTtile = [NSMutableArray array];

    marrSortName = [NSMutableArray array];
    marrSortNameTitle = [NSMutableArray array];

    marrSpecailService = [NSMutableArray array];

    // 2为销量最高 1为人气排序
    strSortType = @"1";
    strSpecialService = @"";
    strCategory = self.strGoodsCategoryId;
    currentPage = 1;

    [tvEasyBuy registerNib:[UINib nibWithNibName:NSStringFromClass([GYEeayBuyTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];

    tvEasyBuy.showsVerticalScrollIndicator = NO;

    if ([tvEasyBuy respondsToSelector:@selector(setSeparatorInset:)]) {

        [tvEasyBuy setSeparatorInset:UIEdgeInsetsZero];
    }

    tvEasyBuy.tableFooterView = [[UIView alloc] init];
    tvEasyBuy.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
    //
    //
    //        [self headerRereshing];
    //
    //    }];
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        
        
        [self headerRereshing];

    }];

    tvEasyBuy.mj_header = header;

    UIButton* myHSButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect Hsframe = CGRectMake(0, 0, 22, 25);
    myHSButton.frame = Hsframe;
    [myHSButton setBackgroundImage:kLoadPng(@"gycommon_nav_myHE") forState:UIControlStateNormal];
    [myHSButton setTitle:@"" forState:UIControlStateNormal];
    [myHSButton addTarget:self action:@selector(pushToMyHS:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* btnSetting1 = [[UIBarButtonItem alloc] initWithCustomView:myHSButton];

    UIImage* image = kLoadPng(@"gycommon_nav_cart");
    CGRect backframe = CGRectMake(0, 0, 25, 25);
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = backframe;
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(pushCartVc:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* btnSetting2 = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItems = @[ btnSetting2, btnSetting1 ];

    if (globalData.isOnNet) {
        [self loadTopicFromNetwork];
    }
    else {

        [self showNoNetworkView];
    }

    //      返回顶部按钮
    _backTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    GYAppDelegate* app = (GYAppDelegate*)[UIApplication sharedApplication].delegate;

    _backTopBtn.frame = CGRectMake(app.window.bounds.size.width - 35 / 2 - 40, app.window.bounds.size.height - 60 -5, 45, 45);

    [_backTopBtn setBackgroundImage:[UIImage imageNamed:@"gyhe_backtotop"] forState:0];

    [_backTopBtn addTarget:self action:@selector(backTop) forControlEvents:UIControlEventTouchUpInside];

    _backTopBtn.hidden = YES;

    [app.window addSubview:_backTopBtn];
}

- (void)backTop
{

    _backTopBtn.hidden = YES;

    tvEasyBuy.contentOffset = CGPointMake(0, 0);
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{

    CGFloat offHeight = scrollView.contentOffset.y;

    if (scrollView == tvEasyBuy) {

        if (offHeight > kScreenHeight / 2) {
            _backTopBtn.hidden = NO;
        }
        else {

            _backTopBtn.hidden = YES;
        }
    }
}

- (void)reloadNetworkData
{
    [super reloadNetworkData];
    if (globalData.isOnNet) {
        [self loadTopicFromNetwork];
        [self dismissNoNetworkView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    //只有返回首页才隐藏NavigationBarHidden
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) { //返回
        if ([self.navigationController.topViewController isKindOfClass:[GYEasybuyMainViewController class]]) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            ;
        }
    }

    [_backTopBtn removeFromSuperview];
}

- (void)pushToMyHS:(UIButton*)sender
{
    kCheckLogined

        GYEPMyHEViewController* vcCart = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyHEViewController class]));
    vcCart.navigationItem.title = kLocalized(@"GYHS_Base_shopping_cart");
    [self pushVC:vcCart animated:YES];
}

//加载列表数据
- (void)loadDataFromNetworkWithCategoryId:(NSString*)categoryid WithSortType:(NSString*)sorttype WithspecialService:(NSString*)specialService
{

    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    self.hasCoupon = @"0";
    // 消费抵扣全 传在hasCoupon

    // modify by songjk 传入的id由数字改为名称
    NSString* strSpecialServiceType = specialService;
    if (specialService && specialService.length > 0) {

        if ([specialService rangeOfString:@"6"].location != NSNotFound) {
            self.hasCoupon = @"1";

            NSArray* arrService = [specialService componentsSeparatedByString:@","];
            NSMutableArray* marrService = [NSMutableArray arrayWithArray:arrService];
            [marrService removeObject:@"6"];
            if (marrService.count > 0) {
                NSMutableArray* marrName = [NSMutableArray array];
                NSString* strName = @"";
                for (int i = 0; i < marrService.count; i++) {
                    strName = [GYUtils getServiceNameWithServiceCode:marrService[i]];
                    if (strName && strName.length > 0) {
                        [marrName addObject:strName];
                    }
                }
                strSpecialServiceType = [marrName componentsJoinedByString:@","];
            }
            else {
                strSpecialServiceType = @"";
            }
        }
        else { // 不包含6
            NSArray* arrService = [specialService componentsSeparatedByString:@","];
            if (arrService.count > 0) {
                // modify 传入的id由数字改为名称
                NSMutableArray* marrName = [NSMutableArray array];
                NSString* strName = @"";
                for (int i = 0; i < arrService.count; i++) {
                    strName = [GYUtils getServiceNameWithServiceCode:arrService[i]];
                    if (strName && strName.length > 0) {
                        [marrName addObject:strName];
                    }
                }
                strSpecialServiceType = [marrName componentsJoinedByString:@","];
            }
        }
    }

    //    strSpecialServiceType = [strSpecialServiceType stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [dict setValue:categoryid forKey:@"categoryId"];
    [dict setValue:sorttype forKey:@"sortType"];
    [dict setValue:strSpecialServiceType forKey:@"specialService"];
    [dict setValue:self.hasCoupon forKey:@"hasCoupon"];
    [dict setValue:[NSString stringWithFormat:@"%d", pageCount] forKey:@"count"];
    [dict setValue:[NSString stringWithFormat:@"%ld", (long)currentPage] forKey:@"currentPage"];
    //    [dict setValue:globalData.loginModel.token forKey:@"key"];

    [Network GET:GetEasyBuyTopicListUrl parameters:dict completion:^(id responseObject, NSError* error) {
        if (!error) {
            NSDictionary *responseDict = responseObject;
            if (!error) {
                NSString *str = [NSString stringWithFormat:@"%@", [responseDict objectForKey:@"retCode"]];
                if ([str isEqualToString:@"200"]) {
                    tvEasyBuy.backgroundView.hidden = YES;
                    totalCount = [[responseDict objectForKey:@"rows"] integerValue];
                    totalPage = [responseDict [@"totalPage"] intValue];

                    NSMutableArray *dataSource = [NSMutableArray array];
                    NSArray *arrData = [responseDict objectForKey:@"data"];
                    for (int i = 0; i < arrData.count; i++) {
                        NSDictionary *dic = arrData[i];
                        GYEasyBuyModel *model = [[GYEasyBuyModel alloc] init];
                        model.strGoodPictureURL = kSaftToNSString([dic objectForKey:@"url"]);
                        model.strGoodName = kSaftToNSString([dic objectForKey:@"title"]);
                        model.strGoodPrice = kSaftToNSString([dic objectForKey:@"price"]);
                        model.strGoodPoints = kSaftToNSString([dic objectForKey:@"pv"]);
                        model.strGoodId = kSaftToNSString([dic objectForKey:@"id"]);
                        model.strCurrentPageIndex = kSaftToNSString([dic objectForKey:@"currentPageIndex"]);
                        model.strTotalPage = kSaftToNSString([dic objectForKey:@"totalPage"]);
                        model.strTotalRows = kSaftToNSString([dic objectForKey:@"rows"]);
                        model.city = kSaftToNSString(dic[@"city"]);
                        model.companyName = dic[@"companyName"];
                        model.beCash = [dic[@"beCash"] boolValue];
                        model.beReach = [dic[@"beReach"] boolValue];
                        model.beSell = [dic[@"beSell"] boolValue];
                        model.beTake = [dic[@"beTake"] boolValue];
                        model.beTicket = [dic[@"beTicket"] boolValue];
                        model.monthlySales = kSaftToNSString(dic[@"monthlySales"]);
                        model.saleCount = kSaftToNSString(dic[@"salesCount"]);
                        ShopModel *shopMod = [[ShopModel alloc] init];
                        shopMod.strShopId = kSaftToNSString([dic objectForKey:@"vShopId"]);
                        model.shopInfo = shopMod;

                        if (isUpFresh) {
                            [dataSource addObject:model];
                        } else {
                            [marrEasyBuySource addObject:model];

                        }
                    }
                    if (isUpFresh) {
                        marrEasyBuySource = dataSource;
                    }

                    [tvEasyBuy reloadData];
                    GYRefreshFooter *footer = [GYRefreshFooter footerWithRefreshingBlock:^{

                        [self footerRereshing];

                    }];

                    

                    tvEasyBuy.mj_footer = footer;

//                  [tvEasyBuy addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];

                    currentPage += 1;

                    if (currentPage <= totalPage) {
                        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                        [tvEasyBuy.mj_header endRefreshing];
                        [tvEasyBuy.mj_footer endRefreshing];

                    } else {
                        [tvEasyBuy.mj_header endRefreshing];
                        [tvEasyBuy.mj_footer endRefreshing];
                        [tvEasyBuy.mj_footer endRefreshingWithNoMoreData];//必须要放在reload后面
                    }
                    if ([responseDict[@"data"] isKindOfClass:([NSArray class])] && ![responseDict[@"data"]  count] > 0) {

                        tvEasyBuy.mj_footer.hidden = YES;

                        UIView *background = [[UIView alloc] initWithFrame:tvEasyBuy.frame];
                        UILabel *lbTips = [[UILabel alloc] init];
                        lbTips.center = CGPointMake(kScreenWidth/2, kScreenHeight/2 - 100 + 60);
                        lbTips.textColor = kCellItemTitleColor;
                        lbTips.textAlignment = NSTextAlignmentCenter;
                        lbTips.font = [UIFont systemFontOfSize:15.0];
                        lbTips.backgroundColor = [UIColor clearColor];
                        lbTips.bounds = CGRectMake(0, 0, 235, 40);
                        lbTips.text = kLocalized(@"GYHS_Base_noSearchRelevantProductData");
                        UIImageView *imgvNoResult = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_no_result.png"]];
                        imgvNoResult.center = CGPointMake(kScreenWidth/2, kScreenHeight/2 - 100);
                        imgvNoResult.bounds = CGRectMake(0, 0, 52, 59);
                        [background addSubview:imgvNoResult];
                        [background addSubview:lbTips];
                        tvEasyBuy.backgroundView = background;
                        tvEasyBuy.backgroundView.hidden = NO;

                    } else {
                        tvEasyBuy.backgroundView.hidden = YES;
                    }
                } else {
                    if ([tvEasyBuy.mj_header isRefreshing]) {
                        [tvEasyBuy.mj_header endRefreshing];
                    }

                    if ([tvEasyBuy.mj_footer isRefreshing]) {
                        [tvEasyBuy.mj_footer endRefreshing];
                    }

                    [tvEasyBuy.mj_footer endRefreshingWithNoMoreData];
                    [marrEasyBuySource removeAllObjects];
                    [tvEasyBuy reloadData];

                    if (marrEasyBuySource.count == 0) {
                        tvEasyBuy.mj_footer.hidden = YES;
                        UIView *background = [[UIView alloc] initWithFrame:tvEasyBuy.frame];
                        UILabel *lbTips = [[UILabel alloc] init];
                        lbTips.center = CGPointMake(kScreenWidth/2, kScreenHeight/2 - 100 + 60);
                        lbTips.textColor = kCellItemTitleColor;
                        lbTips.textAlignment = NSTextAlignmentCenter;
                        lbTips.font = [UIFont systemFontOfSize:15.0];
                        lbTips.backgroundColor = [UIColor clearColor];
                        lbTips.bounds = CGRectMake(0, 0, 235, 40);
                        lbTips.text = kLocalized(@"GYHS_Base_noSearchRelevantProductData");
                        UIImageView *imgvNoResult = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_no_result.png"]];
                        imgvNoResult.center = CGPointMake(kScreenWidth/2, kScreenHeight/2 - 100);
                        imgvNoResult.bounds = CGRectMake(0, 0, 52, 59);
                        [background addSubview:imgvNoResult];
                        [background addSubview:lbTips];
                        tvEasyBuy.backgroundView = background;
                        tvEasyBuy.backgroundView.hidden = NO;
                    }

                }
            }
        }

    }];
}

- (void)loadTopicFromNetwork
{

    [GYGIFHUD show];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:globalData.loginModel.token forKeyPath:@"key"];
    [Network GET:EasyBuyColumnClassifyUrl parameters:dict completion:^(id responseObject, NSError* error) {

        if (!error) {
            NSDictionary *ResponseDic = responseObject;


            if (!error) {
                NSString *str = [NSString stringWithFormat:@"%@", [ResponseDic objectForKey:@"retCode"]];

                if ([str isEqualToString:@"200"]) {

                    NSArray *arrtest = [ResponseDic objectForKey:@"data"];
                    for (NSInteger i = 0; i < arrtest.count; i++) {
                        NSDictionary *Dic1 = arrtest[i];
                        GYGoodCategoryModel *model1 = [[GYGoodCategoryModel alloc] init];
                        model1.strCategoryTitle = [Dic1 objectForKey:@"name"];
                        model1.strCategoryId = [Dic1 objectForKey:@"id"];
                        NSArray *arryCategories = [Dic1 objectForKey:@"categories"];
                        // 记录传入的类型
                        NSString *strID = [[NSUserDefaults standardUserDefaults] objectForKey:@"easyBuyID"];
                        if ([strID isEqualToString:model1.strCategoryId]) {
                            self.index = i;
                        }
                        for (int j = 0; j < arryCategories.count; j++) {
                            NSDictionary *Dic2 = arryCategories[j];
                            GYGoodCategoryModel *model2 = [[GYGoodCategoryModel alloc] init];
                            model2.strCategoryTitle = [Dic2 objectForKey:@"name"];
                            model2.strCategoryId = [Dic2 objectForKey:@"id"];
                            [model1.marrSubCategory addObject:model2];
                        }
                        [testArr addObject:model1];
                        [marrCategoryLevelOne addObject:model1.strCategoryTitle];
                    }

                }

            }

        }

        [self getSortTypeData];
    }];
}

- (void)getSortNameData
{
    [Network GET:EasyBuySortNameUrl parameters:nil completion:^(id responseObject, NSError* error) {
        [GYGIFHUD dismiss];
        if (!error) {
            NSDictionary *ResponseDic = responseObject;

            if (!error) {

                NSString *retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];

                if ([retCode isEqualToString:@"200"]) {


                    for (NSDictionary *dict in ResponseDic[@"data"]) {
                        GYSortTypeModel *sortTypeMod = [[GYSortTypeModel alloc] init];
                        sortTypeMod.strSortType = [NSString stringWithFormat:@"%@", dict[@"sortType"]];
                        sortTypeMod.strTitle = [NSString stringWithFormat:@"%@", dict[@"title"]];

                        [marrSortNameTitle addObject:sortTypeMod.strTitle];

                        [marrSortName addObject:sortTypeMod];

                    }

                    [self addTopSelectView];

                }

            }

        }
        [tvEasyBuy.mj_header beginRefreshing];
    }];
}

// 排序
- (void)getSortTypeData
{
    [Network GET:EasyBuySortTypeUrl parameters:nil completion:^(id responseObject, NSError* error) {
        if (!error) {
            NSDictionary *ResponseDic = responseObject;

            if (!error) {

                NSString *retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];

                if ([retCode isEqualToString:@"200"]) {

                    for (NSDictionary *dict in ResponseDic[@"data"]) {
                        GYSortTypeModel *sortTypeMod = [[GYSortTypeModel alloc] init];
                        sortTypeMod.strSortType = [NSString stringWithFormat:@"%@", dict[@"sortType"]];
                        sortTypeMod.strTitle = [NSString stringWithFormat:@"%@", dict[@"title"]];

                        [marrSortTtile addObject:sortTypeMod.strTitle];

                        [marrSortType addObject:sortTypeMod];



                    }
                    // 排序
                    if (marrSortType.count > 0) {
                        [marrSortType sortedArrayUsingComparator:^NSComparisonResult (id obj1, id obj2) {
                            return [((GYSortTypeModel *)obj1).strSortType integerValue] > [((GYSortTypeModel *)obj1).strSortType integerValue];
                        }];
                        [marrSortTtile removeAllObjects];
                        for (int i = 0; i < marrSortType.count; i++) {
                            GYSortTypeModel *model = marrSortType[i];
                            [marrSortTtile addObject:model.strTitle];
                        }
                    }
                }

            }

        }
        [self getSortNameData];
    }];
}

//主线程中更新UI
- (void)refreshTableview
{
    [tvEasyBuy reloadData];
}

//添加多选横条
- (void)addTopSelectView
{
    DDLogDebug(@"%zi-----------levelone-------%zi----------sortname-------%zi-----sorttitle", marrCategoryLevelOne.count, marrSortNameTitle.count, marrSortTtile.count);
    if (marrCategoryLevelOne.count > 0 && marrSortNameTitle.count > 0 && marrSortTtile.count > 0) {
        chooseArray = [NSMutableArray arrayWithArray:@[
            marrCategoryLevelOne,
            marrSortNameTitle,
            marrSortTtile
        ]];
        DropDownWithChildListView* dropDownView = [[DropDownWithChildListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40) dataSource:self delegate:self WithUseType:easyBuyListType WithOther:nil];

        dropDownView.mSuperView = self.view;
        dropDownView.deleteTableview = self;
        dropDownView.dropDownDataSource = self;
        dropDownView.has = YES;
        // songjk
        dropDownView.index = self.index;
        [dropDownView.BtnConfirm addTarget:self action:@selector(btnSpecailServiceRequet) forControlEvents:UIControlEventTouchUpInside];
        [dropDownView setBtnText:kLocalized(@"GYHS_Base_sort") section:1];
        [dropDownView setBtnText:kLocalized(@"GYHS_Base_sellerService") section:2];
        _delegate = dropDownView;
        self.dropDownView = dropDownView;
        [self.view addSubview:dropDownView];
    }
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    currentPage = 1;
    isUpFresh = YES;
    [self loadDataFromNetworkWithCategoryId:strCategory WithSortType:strSortType WithspecialService:strSpecialService];
}

- (void)footerRereshing
{
    isUpFresh = NO;
    if (currentPage <= totalPage) {
        [self loadDataFromNetworkWithCategoryId:strCategory WithSortType:strSortType WithspecialService:strSpecialService];
    }
}

//点击确认按钮出发方法，发起请求
- (void)btnSpecailServiceRequet
{

    NSString* strSpecailServiceTotal = [marrSpecailService componentsJoinedByString:@","];
    currentPage = 1;
    //    if (marrEasyBuySource.count > 0) {
    //        [marrEasyBuySource removeAllObjects];
    //
    //    }
    //[marrService removeObject:@"6"];
    if (mTitleArray.count > 0) {
        NSString* textString = [mTitleArray lastObject];
        if (mTitleArray.count > 1) {
            textString = [textString stringByAppendingString:@"..."];
        }
        [self.dropDownView setBtnText:textString section:2];
        [self.dropDownView setBtnTextColor:kNavigationBarColor section:2];
    }
    else {
        [self.dropDownView setBtnText:kLocalized(@"GYHS_Base_sellerService") section:2];
        [self.dropDownView setBtnTextColor:[UIColor blackColor] section:2];
    }

    strSpecialService = strSpecailServiceTotal;
    [self loadDataFromNetworkWithCategoryId:strCategory WithSortType:strSortType WithspecialService:strSpecailServiceTotal];

    if (_delegate && [_delegate respondsToSelector:@selector(hidenBackgroundView)]) {

        [_delegate hidenBackgroundView];
    }
}

#pragma mark 多选时用于 清除 多选项中得数据
- (void)btnTouch:(NSInteger)section
{
    if (section == 2) {
    }
    else {

        [marrSpecailService removeAllObjects];
    }
}

#pragma mark-- dropDownListDelegate  选择section下面的row 的回调方法
- (void)chooseAtSection:(NSInteger)section index:(NSInteger)index WithHasChild:(BOOL)has
{
    sectionNumber = section;
    indexNumber = index;
    //当点击到不是  多选项的btn 清除特殊服务数组

    CGFloat width = self.view.frame.size.width / [chooseArray count];

    if (marrLevelTwoTitle.count > 0) {
        [marrLevelTwoTitle removeAllObjects];
    }

    GYGoodCategoryModel* CategoryLevelOne = testArr[index];
    marrCategoryLevelTwo = [NSMutableArray arrayWithArray:CategoryLevelOne.marrSubCategory];

    for (GYGoodCategoryModel* model in marrCategoryLevelTwo) {

        [marrLevelTwoTitle addObject:model.strCategoryTitle];
    }

    if (marrCategoryLevelTwo.count > 0 && has) {
        if (tempTv == nil) {

            tempTv = [[UITableView alloc] init];
            tempTv.tag = 100;
            tempTv.delegate = self;
            tempTv.dataSource = self;
        }
        //隐藏分割线
        if ([tvEasyBuy respondsToSelector:@selector(setSeparatorInset:)]) {

            [tvEasyBuy setSeparatorInset:UIEdgeInsetsZero];
        }

        //        if ([tvEasyBuy respondsToSelector:@selector(setLayoutMargins:)]) {
        //
        //            [tvEasyBuy setLayoutMargins:UIEdgeInsetsZero];
        //
        //        }

        CGFloat maxHeight = kScreenHeight - 64 - 40;
        //        height= (kScreenHeight-64-40)*0.8;
        CGFloat height = 40 * marrCategoryLevelTwo.count;
        height = height < maxHeight ? height : maxHeight;
        tempTv.frame = CGRectMake(width, 40, self.view.frame.size.width - width, height);
        //        tempTv.separatorStyle=UITableViewCellSeparatorStyleNone;

        [self.view addSubview:tempTv];
    }
    [tempTv reloadData];
}

- (void)deleteTableviewInSectionOne
{
    if (tempTv) {
        [tempTv removeFromSuperview];
    }
}

#pragma mark-- dropdownList DataSource
- (NSInteger)numberOfSections
{
    return [chooseArray count];
}

//返回的多选列表总共有多少项。
- (NSInteger)multipleChoiceCount
{
    NSInteger arrCount = [chooseArray count];
    return [chooseArray[arrCount - 1] count];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSArray* arry = chooseArray[section];
    return [arry count];
}

- (NSString*)titleInSection:(NSInteger)section index:(NSInteger)index
{

    return chooseArray[section][index];
}

- (NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}

#pragma mark DataSourceDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    if (tableView.tag == 100) {
        return marrCategoryLevelTwo.count;
    }
    NSInteger rows = 0;
    if (marrEasyBuySource.count % 2 == 0) {
        rows = marrEasyBuySource.count / 2;
    }
    else {
        rows = marrEasyBuySource.count / 2 + 1;
    }

    return rows;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (tableView.tag == 100) {
        return 40;
    }
    return 265;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifer = @"cell";
    static NSString* cellIdentiferForTemp = @"TempCell";
    if (tableView.tag == 100) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentiferForTemp];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentiferForTemp];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = marrLevelTwoTitle[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.textColor = kCellItemTitleColor;
        return cell;
    }
    else {

        GYEeayBuyTableViewCell* easyBuyCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        //        [easyBuyCell.contentView removeFromSuperview];
        if (easyBuyCell != nil) {
            //        easyBuyCell=[[GYEeayBuyTableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
            NSArray* arr = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYEeayBuyTableViewCell class]) owner:self options:nil];
            easyBuyCell = [arr objectAtIndex:0];
        }
        else {
            while ([easyBuyCell.contentView.subviews lastObject] != nil) {
                [(UIView*)[easyBuyCell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        easyBuyCell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (marrEasyBuySource.count > 0) {
            GYEasyBuyModel* modelleft = marrEasyBuySource[indexPath.row * 2];
            GYEasyBuyModel* modelright = nil;
            if ((indexPath.row * 2 + 1) >= marrEasyBuySource.count) {
            }
            else {
                modelright = marrEasyBuySource[indexPath.row * 2 + 1];
            }

            [easyBuyCell refreshUIWithModel:modelleft WithSecondModel:modelright];
        }

        easyBuyCell.btnLeftCover.tag = 100 + indexPath.row * 2;
        [easyBuyCell.btnLeftCover addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        easyBuyCell.btnRightCover.tag = 5000 + indexPath.row * 2 + 1;
        [easyBuyCell.btnRightCover addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];

        return easyBuyCell;
    }
}

#pragma mark tableviewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{

    if (self.index != indexNumber) {
        self.index = indexNumber;
        self.dropDownView.index = self.index;
    }
    if (tableView == tempTv) {
        GYGoodCategoryModel* mod = marrCategoryLevelTwo[indexPath.row];
        // add by songjk // 全部的时候显示上一个分类标题
        NSString* name = mod.strCategoryTitle;
        if (indexPath.row == 0) {
            GYGoodCategoryModel* CategoryLevelOne = testArr[indexNumber];
            name = CategoryLevelOne.strCategoryTitle;
        }

        if (_delegate && [_delegate respondsToSelector:@selector(chooseRowWith:WithSection:WithTableView:)]) {

            //            if (marrEasyBuySource.count > 0) {
            //
            //                [marrEasyBuySource removeAllObjects];
            //            }

            [_delegate chooseRowWith:name WithSection:sectionNumber WithTableView:tempTv];
            currentPage = 1;
            self.title = name;
            strCategory = mod.strCategoryId;
            [marrEasyBuySource removeAllObjects];
            //            [self headerRereshing];
            [tvEasyBuy.mj_header beginRefreshing];
            //            [self loadDataFromNetworkWithCategoryId:mod.strCategoryId WithSortType:strSortType WithspecialService:strSpecialService];
        }

        [tempTv removeFromSuperview];
    }
}

//用于隐藏分割线
- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{

    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {

        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {

        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark 代理类传过来选中的section和 indexpath DropDownWithChildChooseDataSource回调
- (void)didSelectedOneShow:(NSString*)title WithIndexPath:(NSIndexPath*)indexPath WithCurrentSection:(NSInteger)sectionNumber2
{

    switch (sectionNumber2) {
    case 1: {
        //        if (marrEasyBuySource.count > 0) {
        //
        //            [marrEasyBuySource removeAllObjects];
        //        }

        GYSortTypeModel* sortTypeMod1 = marrSortName[indexPath.row];
        strSortType = sortTypeMod1.strSortType;
        currentPage = 1;

        [self loadDataFromNetworkWithCategoryId:strCategory WithSortType:strSortType WithspecialService:strSpecialService];

    } break;
    case 2: {

        [mTitleArray addObject:title];
        GYSortTypeModel* sortTypeMod2 = marrSortType[indexPath.row];

        if ([sortTypeMod2.strTitle isEqualToString:kLocalized(@"GYHS_Base_all")]) {
            sortTypeMod2.strSortType = @"";
        }

        //            if([marrSpecailService containsObject:sortTypeMod2.strSortType]) {
        //                [marrSpecailService removeObject:sortTypeMod2.strSortType];
        //            }else {
        //                [marrSpecailService addObject:sortTypeMod2.strSortType];
        //            }

        [marrSpecailService addObject:sortTypeMod2.strSortType];
        //nsset去重

        NSSet* set = [NSSet setWithArray:marrSpecailService];

        marrSpecailService = [[set allObjects] mutableCopy];
        //                  [self loadDataFromNetworkWithCategoryId:strCategory WithSortType:strSortType WithspecialService:strSpecialService];
        //            reloadDatasoureArray:(NSMutableArray *)datasource
        //            [self.dropDownView reloadDatasoureArray:marrSpecailService];
        //            [self.dropDownView.mTableView reloadData];
    } break;
    default:
        break;
    }
}

#pragma mark 用于消除 多选项中选中的项目
- (void)mutableSelectRemoveObj:(NSIndexPath*)indexPath WithCurrentSectin:(NSInteger)sectionNumber
{
    GYSortTypeModel* sortTypeMod2 = marrSortType[indexPath.row];
    [marrSpecailService removeObject:sortTypeMod2.strSortType];

    [mTitleArray removeObject:sortTypeMod2.strTitle];
}

- (void)btnClicked:(UIButton*)sender
{
    GYEasyBuyModel* mod = nil;

    if (sender.tag < 5000) {
        mod = marrEasyBuySource[sender.tag - 100];
    }
    else {
        mod = marrEasyBuySource[sender.tag - 5000];
    }

    GYEasybuyGoodsInfoViewController* vcGoodDetail = kLoadVcFromClassStringName(NSStringFromClass([GYEasybuyGoodsInfoViewController class]));

    vcGoodDetail.itemId = mod.strGoodId;
    vcGoodDetail.vShopId = mod.shopInfo.strShopId;
    [self.navigationController pushViewController:vcGoodDetail animated:YES];
}

//进入购物车
- (void)pushCartVc:(id)sender {
    kCheckLogined
    DDLogDebug(@"into cart.");//gycommon_nav_cart
    UIViewController *vc = [[NSClassFromString(@"GYHESCShoppingCartViewController") alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - GYViewControllerDelegate

- (void)pushVC:(id)vc animated:(BOOL)ani {

    [self.navigationController pushViewController:vc animated:ani];
}

@end
