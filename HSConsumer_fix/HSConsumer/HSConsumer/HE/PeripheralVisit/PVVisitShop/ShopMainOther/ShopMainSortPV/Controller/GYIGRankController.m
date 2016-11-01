//
//  GYIGRankController.m
//  HSConsumer
//
//  Created by apple on 15/11/13.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#import "GYIGRankController.h"
#import "GYIGWelfareController.h"
#import "GYGIFHUD.h"
#import "GYEasyBuyModel.h"
#import "GYIGRankCell.h"
#import "GYAppDelegate.h"
#import "GYShopDescribeController.h"
#import "GYHSLoginViewController.h"
#import "GYHSLoginManager.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

#define pageCount 10

@interface GYIGRankController () <UITableViewDataSource, UITableViewDelegate, GYNetRequestDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, copy) NSString* cityString; //城市
@property (nonatomic, copy) NSString* categoryIdString; //传入ID
@property (nonatomic, assign) NSInteger currentPage; // 当前页数
@property (nonatomic, assign) NSInteger totalCount; //总个数
@property (nonatomic, assign) NSInteger totalPage; //总共多少页
@property (nonatomic) CLLocationCoordinate2D currentLocation;
@property (nonatomic) GlobalData* data;

@end

@implementation GYIGRankController

#pragma mark 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setRightNavButton];
    [self setTopView];
    [self getCitySelectName];
    [self creatHeaderOrFootRefresh];
    [self getNetData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}




#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    [GYGIFHUD dismiss];
    if (_currentPage == 1) {
        [_dataArray removeAllObjects];
    }
    NSDictionary* ResponseDic = responseObject;
    NSString* retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];
    if ([retCode isEqualToString:@"200"]) {
        _currentPage++;
        _totalCount = [ResponseDic[@"rows"] integerValue];
        _tableView.backgroundView.hidden = YES;
        _totalPage = [ResponseDic[@"totalPage"] integerValue];
        for (NSDictionary* tempDic in ResponseDic[@"data"]) {
            ShopModel* model = [[ShopModel alloc] init];
            model.strShopId = kSaftToNSString(tempDic[@"id"]); // 之前是id
            model.strVshopId = kSaftToNSString(tempDic[@"vShopId"]);
            model.strShopAddress = tempDic[@"addr"];
            model.strLongitude = tempDic[@"longitude"];
            model.strLat = tempDic[@"lat"];
            model.strShopName = tempDic[@"name"];
            model.strShopTel = tempDic[@"tel"];
            model.strShopPictureURL = tempDic[@"url"];
            model.strRate = kSaftToNSString(tempDic[@"rate"]);
            model.strCompanyName = [NSString stringWithFormat:@"%@", tempDic[@"companyName"]];
            model.strResno = kSaftToNSString(tempDic[@"resno"]);
            model.beCash = kSaftToNSString([tempDic[@"beCash"] stringValue]);
            model.beReach = kSaftToNSString([tempDic[@"beReach"] stringValue]);
            model.beSell = kSaftToNSString([tempDic[@"beSell"] stringValue]);
            model.beTake = kSaftToNSString([tempDic[@"beTake"] stringValue]);
            model.beQuan = kSaftToNSString([tempDic[@"beQuan"] stringValue]);
            model.pointsProportion = kSaftToNSString(tempDic[@"pointsProportion"]);
            if (![tempDic[@"section"] isKindOfClass:[NSNull class]]) {
                model.section = tempDic[@"section"];
            }
            model.categoryNames = tempDic[@"categoryNames"];
            // modify by songjk 地址距离改成取字段：dist
            model.shopDistance = kSaftToNSString(tempDic[@"dist"]);
            [_dataArray addObject:model];
        }
    }
    if (_currentPage <= _totalPage) {
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }
    else {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_footer endRefreshingWithNoMoreData]; //必须要放在reload后面
    }
    if ([ResponseDic[@"data"] isKindOfClass:([NSArray class])] && ![ResponseDic[@"data"] count] > 0) {
        _tableView.mj_footer.hidden = YES;
        UIView* background = [[UIView alloc] initWithFrame:_tableView.frame];
        UILabel* lbTips = [[UILabel alloc] init];
        lbTips.center = CGPointMake(kScreenWidth / 2, kScreenHeight/2 - 100 + 60);
        lbTips.textColor = kCellItemTitleColor;
        lbTips.textAlignment = NSTextAlignmentCenter;
        lbTips.font = [UIFont systemFontOfSize:14.0];
        lbTips.backgroundColor = [UIColor clearColor];
        lbTips.bounds = CGRectMake(0, 0, 270, 40);
        lbTips.text = kLocalized(@"GYHE_SurroundVisit_SorryNoShopsData");
        UIImageView* imgvNoResult = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_no_result.png"]];
        imgvNoResult.center = CGPointMake(kScreenWidth / 2, kScreenHeight/2 - 100);
        imgvNoResult.bounds = CGRectMake(0, 0, 52, 59);
        [background addSubview:imgvNoResult];
        [background addSubview:lbTips];
        _tableView.backgroundView = background;
        
        if (_dataArray.count > 0) {
            background.hidden = YES;
        }else{
            background.hidden = NO;
        }
    }
    [_tableView reloadData];
}

- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error
{

    [GYGIFHUD dismiss];
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellID = @"cell";
    GYIGRankCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(_dataArray.count > indexPath.row) {
        ShopModel* model = _dataArray[indexPath.row];
        [cell refreshUIWith:model];
    }
    
    cell.selectionStyle = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return kWindow.bounds.size.width * 90 / kScreenWidth;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    _currentLocation = _data.locationCoordinate;
    BMKMapPoint mp1 = BMKMapPointForCoordinate(_currentLocation);
    if(_dataArray.count > indexPath.row) {
        ShopModel* model = _dataArray[indexPath.row];
        GYShopDescribeController* vc = [[GYShopDescribeController alloc] init];
        vc.currentMp1 = mp1;
        vc.shopModel = model;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - 点击事件
//跳转积分福利说明
- (void)btnAction
{
    GYIGWelfareController* vc = [[GYIGWelfareController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//点击进入购物车
- (void)shopingCarAction:(UIBarButtonItem*)sender{
    kCheckLogined
    UIViewController *vc = [[NSClassFromString(@"GYHESCShoppingCartViewController") alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 自定义方法
//请求网络数据
- (void)getNetData
{
    _categoryIdString = self.modelID;
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:_cityString forKey:@"city"];
    [dict setValue:@"" forKey:@"area"];
    [dict setValue:@"" forKey:@"section"];
    [dict setValue:[NSString stringWithFormat:@"%zi", pageCount] forKey:@"count"];
    [dict setValue:[NSString stringWithFormat:@"%zi", _currentPage] forKey:@"currentPage"];
    [dict setValue:@"" forKey:@"categoryId"];
    [dict setValue:@"4" forKey:@"sortType"];
    [dict setValue:@"" forKey:@"distance"];
    [dict setObject:@"" forKey:@"supportService"];
    if (globalData.selectedCityCoordinate) {
        [dict setValue:globalData.selectedCityCoordinate forKey:@"location"];
    }
    else {
        [dict setValue:[NSString stringWithFormat:@"%f,%f", globalData.locationCoordinate.latitude, globalData.locationCoordinate.longitude] forKey:@"location"];
    }
    [GYGIFHUD showFullScreen];
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:GetTopicListUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    [request start];
}

- (void)headerRereshing
{
    _currentPage = 1;
    [self getNetData];
}

- (void)footerRereshing
{
    [self getNetData];
}

- (void)setRightNavButton
{
    //积分排行
    self.title = kLocalized(@"GYHE_SurroundVisit_RangeByPoint");
    _dataArray = [NSMutableArray array];
    UIView* carView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(shopingCarAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = carView.frame;
    UIImageView* images = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gycommon_nav_cart"]];
    images.frame = carView.frame;
    [carView addSubview:images];
    [carView addSubview:btn];
    UIBarButtonItem* rightBar = [[UIBarButtonItem alloc] initWithCustomView:carView];
    self.navigationItem.rightBarButtonItem = rightBar;
    self.view.backgroundColor = [UIColor colorWithRed:239 / 255.0 green:239 / 255.0 blue:239 / 255.0 alpha:1];
    _currentPage = 1;
}

//设置顶部topview
- (void)setTopView
{
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 170)];
    bgView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:250 / 255.0 blue:220 / 255.0 alpha:1];
    [self.view addSubview:bgView];
    UILabel* labelOne = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 110, 20)];
    labelOne.font = [UIFont systemFontOfSize:14];
    labelOne.textColor = kPriceRedColor;
    labelOne.text = kLocalized(@"GYHE_SurroundVisit_IntegralPromotionActivities");
    [bgView addSubview:labelOne];
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(labelOne.frame.origin.x, CGRectGetMaxY(labelOne.frame) + 5, bgView.frame.size.width - 20, 1)];
    lineView.backgroundColor = kNavigationBarColor;
    [bgView addSubview:lineView];
    
    //了解积分福利按钮
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(bgView.frame.size.width - 130, labelOne.frame.origin.y, 130, 20);
    [btn setTitle:kLocalized(@"GYHE_SurroundVisit_UnderstandAlternateIntegralWelfare") forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitleColor:[UIColor colorWithRed:0 green:140 / 255.0 blue:215 / 255.0 alpha:1] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    //音响图标
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(bgView.frame.size.width - 135, labelOne.frame.origin.y + 3, 15, 15)];
    imgView.image = [UIImage imageNamed:@"gyhe_shoping_horn"];
    [bgView addSubview:imgView];
    
    //互生卡图片
    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(labelOne.frame.origin.x, CGRectGetMaxY(lineView.frame) + 10, bgView.frame.size.width / 2 - 30, 104)];
    img.image = [UIImage imageNamed:@"gyhe_card"];
    [bgView addSubview:img];
    UILabel* labelTwo = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(img.frame) + 15, img.frame.origin.y, bgView.frame.size.width - img.frame.size.width - 10, 20)];
    labelTwo.text = kLocalized(@"GYHE_SurroundVisit_AnIntegralLifeIncome");
    labelTwo.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    labelTwo.textColor = kNavigationBarColor;
    [bgView addSubview:labelTwo];
    //积分作用
    NSArray* titleArr = @[ kLocalized(@"GYHE_SurroundVisit_IntegralCardConsumption"), kLocalized(@"GYHE_SurroundVisit_IntegralCash"), kLocalized(@"GYHE_SurroundVisit_AnnualIncomeConsumersIntegralInvestment_cell"), kLocalized(@"GYHE_SurroundVisit_IntegralInvestmentFreeMedicalSubsidyProgram"), kLocalized(@"GYHE_SurroundVisit_AlternateAccidentProtectionSupport") ];
    for (NSInteger i = 0; i < 5; i++) {
        UIImageView* tipView = [[UIImageView alloc] initWithFrame:CGRectMake(labelTwo.frame.origin.x, i * 15 + CGRectGetMaxY(labelTwo.frame) + 5, 10, 10)];
        tipView.image = [UIImage imageNamed:@"gyhe_sortpv_wrap_mark"];
        [bgView addSubview:tipView];
        UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tipView.frame) + 5, tipView.frame.origin.y - 5, labelTwo.frame.size.width - 10, 20)];
        if(titleArr.count > i)
            lab.text = titleArr[i];
        lab.font = [UIFont systemFontOfSize:11];
        lab.textColor = [UIColor colorWithRed:90 / 255.0 green:90 / 255.0 blue:90 / 255.0 alpha:1];
        [bgView addSubview:lab];
    }
    UILabel* labelThr = [[UILabel alloc] initWithFrame:CGRectMake(labelOne.frame.origin.x, CGRectGetMaxY(bgView.frame) + 10, self.view.frame.size.width - 20, 20)];
    labelThr.text = kLocalized(@"GYHE_SurroundVisit_IntegralRankingShopIntegralRatio");
    labelThr.textColor = kPriceRedColor;
    labelThr.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:labelThr];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(labelThr.frame) + 2, self.view.frame.size.width, self.view.frame.size.height - bgView.frame.size.height - labelThr.frame.size.height - 64 - 10) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"GYIGRankCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}

- (void)getCitySelectName
{
    _data = globalData;
    if (globalData.selectedCityCoordinate) {
        _cityString = globalData.selectedCityName;
    }
    else {
        _cityString = globalData.locationCity;
    }
}

- (void)creatHeaderOrFootRefresh
{
    
    __weak __typeof(self) wself = self;
    //    添加头部刷新
    GYRefreshHeader* headerFresh = [GYRefreshHeader headerWithRefreshingBlock:^{
        __strong GYIGRankController *sself = wself;
        [sself headerRereshing];
    }];
    //单例 调用刷新图片
    _tableView.mj_header = headerFresh;
    //    添加尾部刷新
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        __strong GYIGRankController *sself = wself;
        [sself footerRereshing];
    }];
    _tableView.mj_footer = footer;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //设定表格视图 头部 尾部
    self.tableView.mj_footer = footer;
}



@end
