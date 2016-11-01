//
//  GYAroundLocationChooseController.m
//  HSConsumer
//
//  Created by Apple03 on 15/11/17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAroundLocationChooseController.h"
#import "GYAroundLocationHeadView.h"
#import "GYAroundLocationNameModel.h"
#import "GYCityInfo.h"
#import "ChineseStringModel.h"
#import "GYAroundLocationSearchController.h"
#import "GYAppDelegate.h"
#import "GYMapLocationViewController.h"
#import "GYGIFHUD.h"
#import "GYHSLoginManager.h"
#import "GYLocationManager.h"
#import "GYHEUtil.h"

#define KTitleFont [UIFont systemFontOfSize:14]
#define KDetailFont [UIFont systemFontOfSize:13]

@interface GYAroundLocationChooseController () <GYMapLocationViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, AroundLocationHeadViewDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* marrDatasource;
@property (nonatomic, strong) NSMutableArray* indexMarr;
@property (nonatomic, strong) NSMutableArray* marrHistory;
@property (nonatomic, weak) UILabel* lbCity;

@end

@implementation GYAroundLocationChooseController

#pragma mark - 懒加载
- (NSMutableArray*)marrDatasource
{
    if (!_marrDatasource) {
        _marrDatasource = [NSMutableArray array];
    }
    return _marrDatasource;
}

- (NSMutableArray*)marrHistory
{
    if (!_marrHistory) {
        _marrHistory = [NSMutableArray array];
    }
    return _marrHistory;
}

- (NSMutableArray*)indexMarr
{
    if (!_indexMarr) {
        _indexMarr = [NSMutableArray array];
    }
    return _indexMarr;
}

#pragma mark - 系统方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getHistory];
    [self setup];
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    self.isLocation = YES;
    [self setup];
    [self readLocalData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLocation) name:kGYHSLoginManagerCityAddressNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
   修改主界面返回时tabBar不显示问题 add by zhangx
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)setup
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitle];

    CGFloat vsearchH = 45;
    UIView* vSearch = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, vsearchH)];
    vSearch.backgroundColor = kBackGroundColor;
    [self.view addSubview:vSearch];
    //gycommon_nav_search
    UITextField* tfSearch = [[UITextField alloc] init];
    tfSearch.textAlignment = NSTextAlignmentCenter;
    tfSearch.placeholder = kLocalized(@"GYHE_SurroundVisit_EnterCityName_OrPinYinQuery");
    tfSearch.frame = CGRectMake(0, 0, 170, 20);
    tfSearch.font = [UIFont systemFontOfSize:13];
    tfSearch.enabled = NO;
    tfSearch.userInteractionEnabled = NO;
    tfSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfSearch.leftViewMode = UITextFieldViewModeAlways;
    tfSearch.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIImageView* imgSearch = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhe_search_gray"]];
    imgSearch.frame = CGRectMake(0, 0, 15, 15);
    tfSearch.leftView = imgSearch;

    UIButton* btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.backgroundColor = [UIColor whiteColor];
    btnSearch.frame = CGRectMake(10, 8, kScreenWidth - 20, vsearchH - 16);
    tfSearch.center = btnSearch.center;
    [btnSearch addTarget:self action:@selector(toSearch) forControlEvents:UIControlEventTouchUpInside];

    [vSearch addSubview:btnSearch];
    [vSearch addSubview:tfSearch];

    CGFloat vGPSlocationH = 30;
    UIView* vGPSlocation = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(vSearch.frame), kScreenWidth, vGPSlocationH)];
    vGPSlocation.backgroundColor = [UIColor whiteColor];
    UILabel* lbCity = [[UILabel alloc] init];
    lbCity.font = KTitleFont;
    lbCity.textColor = kCellItemTitleColor;
    //    lbCity.text = globalData.locationCity;
    if (globalData.selectedCityCoordinate) {
        lbCity.text = globalData.selectedCityAddress;
    }
    else {
        lbCity.text = globalData.locaitonAddress;
    }
    //CGSize citySize = [GYUtils sizeForString:lbCity.text font:KTitleFont width:200];
    //lbCity.frame = CGRectMake(16, 5, citySize.width, vGPSlocationH - 10);
    if (lbCity.text.length > 0) {
        lbCity.frame = CGRectMake(16, 5, kScreenWidth - 65, vGPSlocationH - 10);
    }
    else {
        lbCity.frame = CGRectMake(16, 5, 0, vGPSlocationH - 10);
    }
    //    [GlobalData shareInstance]

    lbCity.userInteractionEnabled = YES;

    UITapGestureRecognizer* tpClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tpClick)];

    [lbCity addGestureRecognizer:tpClick];

    [vGPSlocation addSubview:lbCity];
    self.lbCity = lbCity;

    UIButton* lbGPSshow = [UIButton buttonWithType:UIButtonTypeCustom];
    lbGPSshow.frame = CGRectMake(CGRectGetMaxX(lbCity.frame) + 5, 12, 200, 15);
    [lbGPSshow setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
    lbGPSshow.titleLabel.font = [UIFont systemFontOfSize:10];
    lbGPSshow.backgroundColor = [UIColor clearColor];
    lbGPSshow.center = CGPointMake(lbGPSshow.center.x, lbCity.center.y);

    UILabel* lbGPSTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 10)];

    lbGPSTime.font = [UIFont systemFontOfSize:10];
    lbGPSTime.textColor = kCellItemTextColor;
    lbGPSTime.backgroundColor = [UIColor clearColor];

    //    UIImageView*GPSbtn=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    if (!globalData.locationCity) {
        [lbGPSshow setTitle:kLocalized(@"GYHE_SurroundVisit_GPSFailedPlease_ManuallySelectAddress") forState:UIControlStateNormal];
    }
    else {
        //lbGPSshow.frame = CGRectMake(CGRectGetMaxX(lbCity.frame) + 5, 12, 50, 10);
        lbGPSshow.frame = CGRectMake(kScreenWidth - 60, 12, 50, 10);
        [lbGPSshow setTitle:kLocalized(@"GYHE_SurroundVisit_GPSLocation") forState:UIControlStateNormal];

        [lbGPSshow addTarget:self action:@selector(GPSAction) forControlEvents:UIControlEventTouchUpInside];
    }

    [vGPSlocation addSubview:lbGPSshow];
    [self.view addSubview:vGPSlocation];

    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(vGPSlocation.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(vGPSlocation.frame) - 64)];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;

    // head
    NSMutableArray* marrDitail = [NSMutableArray array];
    GYAroundLocationNameModel* modelHistory = [[GYAroundLocationNameModel alloc] init];
    modelHistory.title = kLocalized(@"GYHE_SurroundVisit_SearchHistory");
    [self getHistory];
    NSArray* arrHistory = self.marrHistory;
    for (int i = 0; i < arrHistory.count; i++) {
        GYAroundLocationNameDetailModel* detailModel = [[GYAroundLocationNameDetailModel alloc] init];
        detailModel.name = arrHistory[i];
        [marrDitail addObject:detailModel];
    }
    NSArray* marrDitails = [[marrDitail reverseObjectEnumerator] allObjects];
    modelHistory.arrData = [NSArray arrayWithArray:marrDitails];

    [marrDitail removeAllObjects];
    GYAroundLocationNameModel* modelHot = [[GYAroundLocationNameModel alloc] init];
    modelHot.title = kLocalized(@"GYHE_SurroundVisit_HotCity");
    NSArray* arrHot = @[ kLocalized(@"GYHE_SurroundVisit_BeijingCity"), kLocalized(@"GYHE_SurroundVisit_ShenZhenCity"), kLocalized(@"GYHE_SurroundVisit_GuangZhouCity"), kLocalized(@"GYHE_SurroundVisit_ChengDuCity"), kLocalized(@"GYHE_SurroundVisit_WuHanCity"), kLocalized(@"GYHE_SurroundVisit_ShangHaiCity") ];
    for (int i = 0; i < arrHot.count; i++) {
        GYAroundLocationNameDetailModel* detailModel = [[GYAroundLocationNameDetailModel alloc] init];
        detailModel.name = arrHot[i];
        [marrDitail addObject:detailModel];
    }
    modelHot.arrData = [NSArray arrayWithArray:marrDitail];

    GYAroundLocationNameModel* modelALL = [[GYAroundLocationNameModel alloc] init];
    modelALL.title = kLocalized(@"GYHE_SurroundVisit_AllCity");
    NSArray* arrData = @[ modelHistory, modelHot, modelALL ];

    GYAroundLocationHeadView* headVeiw = [[GYAroundLocationHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    headVeiw.arrData = arrData;
    [headVeiw reloadData];

    CGFloat height = headVeiw.height;

    headVeiw = [[GYAroundLocationHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    headVeiw.delegate = self;
    headVeiw.arrData = arrData;
    [headVeiw reloadData];
    self.tableView.tableHeaderView = headVeiw;
}

#pragma mark -重新定位

- (void)GPSAction
{
    if (![[GYLocationManager sharedInstance] checkLocationStatus]) {
        [GYHEUtil showLocationServiceInfo:nil];
        return;
    }

    [GYUtils showMessge:kLocalized(@"GYHE_SurroundVisit_ISLocation") confirm:^{
        [GYGIFHUD show];
        [[GYHSLoginManager shareInstance] getLocationInfo];
    } cancleBlock:^{
    }];
}

- (void)setLocation
{
    [GYGIFHUD dismiss];

    self.lbCity.text = globalData.locaitonAddress;
    if (globalData.selectedCityCoordinate) {
        self.lbCity.text = globalData.selectedCityAddress;
    }

    [self setTitle];
}

- (void)setTitle
{

    if (globalData.selectedCityCoordinate) {

        if (globalData.selectedCityName) {
            if ([globalData.selectedCityName hasSuffix:kLocalized(@"GYHE_SurroundVisit_City")]) {
                self.title = [globalData.selectedCityName substringToIndex:globalData.selectedCityName.length - 1];
            }
            else {
                self.title = globalData.selectedCityName;
            }
        }
    }
    else {
        if (globalData.locationCity) {
            if ([globalData.locationCity hasSuffix:kLocalized(@"GYHE_SurroundVisit_City")]) {
                self.title = [globalData.locationCity substringToIndex:globalData.locationCity.length - 1];
            }
            else {
                self.title = globalData.locationCity;
            }
        }
    }
}

- (void)myGes
{

    globalData.selectedCityName = kSaftToNSString(globalData.locationCity);

    self.isLocation = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)tpClick
{

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)toSearch
{
    DDLogDebug(@"search");
    GYAroundLocationSearchController* searchVc = [[GYAroundLocationSearchController alloc] init];
    searchVc.title = self.title;
    [self.navigationController pushViewController:searchVc animated:YES];
}

- (void)readLocalData
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"cityLists" ofType:@"txt"];

    NSData* jsonData = [NSData dataWithContentsOfFile:path];
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    for (NSDictionary* tempDic in dict[@"data"]) {
        GYCityInfo* cityModel = [[GYCityInfo alloc] init];
        cityModel.strAreaName = tempDic[@"areaName"];
        cityModel.strAreaCode = tempDic[@"areaCode"];
        cityModel.strAreaType = tempDic[@"areaType"];
        cityModel.strAreaParentCode = tempDic[@"parentCode"];
        cityModel.strAreaSortOrder = tempDic[@"sortOrder"];
        cityModel.strEnName = tempDic[@"enName"];
        cityModel.strEnName = [cityModel.strEnName lowercaseString];
        [self.marrDatasource addObject:cityModel];
    }

    //获取索引
    NSMutableArray* result = [[NSMutableArray alloc] initWithArray:[self getIndexArr:self.marrDatasource]];
    [self.marrDatasource removeAllObjects];
    self.marrDatasource = result;
}

//返回索引数组
- (NSArray*)getIndexArr:(NSArray*)marr
{
    // modify songjk 改变左边索引取值为 strEnName的首字母
    NSMutableArray* nameMarr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < marr.count; i++) {
        GYCityInfo* cityModel = marr[i];
        [nameMarr addObject:cityModel];
        //        [nameMarr addObject:cityModel.strAreaName];
    }
    NSMutableArray* stringsToSort = [[NSMutableArray alloc] initWithArray:nameMarr];

    //获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray* chineseStringsArray = [NSMutableArray array];
    for (int i = 0; i < [stringsToSort count]; i++) {
        GYCityInfo* cityModel = stringsToSort[i];
        ChineseStringModel* chineseString = [[ChineseStringModel alloc] init];
        //        chineseString.string=[NSString stringWithString:[stringsToSort objectAtIndex:i]];
        chineseString.string = cityModel.strAreaName;
        chineseString.pinYin = [cityModel.strEnName substringToIndex:1];
        if (chineseString.string == nil) {
            chineseString.string = @"";
            chineseString.pinYin = @"";
        }
        [chineseStringsArray addObject:chineseString];
    }

    //按照拼音首字母对这些Strings进行排序
    NSArray* sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];

    NSString* firstLetter;
    NSMutableArray* data = [[NSMutableArray alloc] init];
    NSMutableArray* section;
    for (NSInteger i = 0; i < chineseStringsArray.count; i++) {
        NSString* string = [[chineseStringsArray[i] pinYin] substringToIndex:1];
        if ([firstLetter isEqualToString:string]) {
            if (section == nil) {
                section = [[NSMutableArray alloc] init];
            }
            else {
            }
            [section addObject:[chineseStringsArray[i] string]];
        }
        else {
            if (section != nil && section.count != 0) {
                [data addObject:section];
            }
            else {
            }
            section = [[NSMutableArray alloc] init];
            firstLetter = string;
            [section addObject:[chineseStringsArray[i] string]];
            [self.indexMarr addObject:[string uppercaseString]];
        }
        if (i == chineseStringsArray.count - 1) {
            [data addObject:section];
        }
        else {
        }
    }
    for (NSInteger i = 0; i < data.count; i++) {
        for (NSInteger j = 0; j < [data[i] count]; j++) {
            for (NSInteger m = 0; m < marr.count; m++) {
                GYCityInfo* cityModel = marr[m];
                if ([data[i][j] isEqualToString:cityModel.strAreaName]) {
                    data[i][j] = cityModel;
                    break;
                }
            }
        }
    }

    return data;
}

#pragma mark DataSourceDelegate
//添加
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.marrDatasource.count;
}

//索引
- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    return self.indexMarr;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.marrDatasource[section] count];
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    headerView.backgroundColor = kBackGroundColor;
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 200, 20)];
    lbTitle.textColor = kCellItemTitleColor;
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.text = self.indexMarr[section];
    [headerView addSubview:lbTitle];
    return headerView;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44.0f;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifer = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    GYCityInfo* cityModel = self.marrDatasource[indexPath.section][indexPath.row];
    cell.textLabel.text = cityModel.strAreaName;
    cell.textLabel.font = KTitleFont;
    cell.textLabel.textColor = kCellItemTitleColor;
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYCityInfo* cityModel = self.marrDatasource[indexPath.section][indexPath.row];
    [self saveHistoryWithCity:cityModel.strAreaName];
    globalData.selectedCityName = cityModel.strAreaName;
    // 这里要跳到最新的地图页面
    if (self.isLocation == NO) {
        if (_delegate && [_delegate respondsToSelector:@selector(getCity:WithType:)]) {
            [_delegate getCity:cityModel.strAreaName WithType:1];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        ////跳新页面

        GYMapLocationViewController* newview = [[GYMapLocationViewController alloc] init];
        newview.delegate = self;
        newview.city = cityModel.strAreaName;
        [self presentViewController:newview animated:YES completion:nil];
    }
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark AroundLocationHeadViewDelegate
- (void)AroundLocationHeadView:(GYAroundLocationHeadView*)view didChooseCity:(NSString*)city
{

    //    [self saveHistoryWithCity:city];
    globalData.selectedCityName = city;
    GYMapLocationViewController* newview = [[GYMapLocationViewController alloc] init];
    newview.delegate = self;
    newview.city = city;
    [self presentViewController:newview animated:YES completion:nil];

    DDLogDebug(@"city = %@", city);
    ////
    //    if ([self.delegate respondsToSelector:@selector(getCity:WithType:)]) {
    //        [self.delegate getCity:city WithType:0];
    //    }
    //    [self.navigationController popViewControllerAnimated:YES];
}

//////从新地图跳过来的
- (void)getCity:(NSString*)CityTitle getIsLocation:(NSString*)location
{

    if ([self.delegate respondsToSelector:@selector(getCity:WithType:)]) {
        [self.delegate getCity:CityTitle WithType:0];
    }
    if (_block) {

        _block();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

// 保存历史
- (void)saveHistoryWithCity:(NSString*)city
{
    if (kSaftToNSString(city).length == 0) {
        return;
    }

    GlobalData* data = globalData;
    data.selectedCityName = city;
    for (NSString* strCity in self.marrHistory) {
        if ([strCity isEqualToString:city]) {
            return;
        }
    }
    if (self.marrHistory.count < kHistoryCount) {
        [self.marrHistory addObject:city];
        [[NSUserDefaults standardUserDefaults] setObject:self.marrHistory forKey:kHistoryKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        [self.marrHistory removeObjectAtIndex:0];
        [self.marrHistory addObject:city];
        [[NSUserDefaults standardUserDefaults] setObject:self.marrHistory forKey:kHistoryKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)getHistory {
    self.marrHistory = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kHistoryKey]];
}

@end
