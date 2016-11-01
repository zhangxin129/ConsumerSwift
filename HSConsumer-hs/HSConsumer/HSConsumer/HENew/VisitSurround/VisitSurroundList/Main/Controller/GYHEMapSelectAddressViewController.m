//
//  GYHEMapSelectAddressViewController.m
//  HSConsumer
//
//  Created by zhengcx on 16/10/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEMapSelectAddressViewController.h"
#import "GYHEMapSelectAddressHeaderView.h"
#import "GYHEMapMyAddressCell.h"
#import "GYHEMapSelectSectionHeader.h"
#import "GYHEMapNearCell.h"
#import "GYHEMapMyAddressHeader.h"
#import "GYLocationManager.h"
#import "GYHEUtil.h"
#import "GYHEMapSearchAddressVC.h"
#import "GYHSLoginManager.h"
#import "GYNearAddressModel.h"
#import "GYHELocalAddressCell.h"
#import "UIView+Extension.h"
#import <Masonry/Masonry.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#define kGYHELocalAddressCellIdentifier @"GYHELocalAddressCell"
#define kGYHEMapMyAddressCellIdentifier @"GYHEMapMyAddressCell"
#define kGYHEMapNearCellIdentifier @"GYHEMapNearCell"

@interface GYHEMapSelectAddressViewController ()<UITableViewDataSource, UITableViewDelegate,GYHEMapSelectAddressHeaderViewDelegate, BMKPoiSearchDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *nearDataArry; //数据源
@property (nonatomic, strong)NSMutableArray *adressDataArry; //数据源
@property (nonatomic, strong) GYHEMapSelectAddressHeaderView* headerView;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic,strong) BMKPoiSearch *poiSearch;
@end

@implementation GYHEMapSelectAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNav];
    [self initView];
    self.view.backgroundColor = kBackgroundGrayColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    _poiSearch.delegate = nil;
}

#pragma mark - privateMethod
-(void)setNav
{
    self.title = @"选择地址";
    if(globalData.isLogined){ //登录显示新增地址按钮
        UIButton* addAddressBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 21)];
        [addAddressBtn setTitle:@"新增地址" forState:UIControlStateNormal];
        addAddressBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [addAddressBtn addTarget:self action:@selector(addNewAddress) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* rightMessageBtn = [[UIBarButtonItem alloc] initWithCustomView:addAddressBtn];
        self.navigationItem.rightBarButtonItem = rightMessageBtn;
    }
}

-(void)initView
{
    [self.view addSubview:self.tableView];
}

-(void)addNewAddress
{
    NSLog(@"新增地址");
}

- (void)returnClick
{
    NSLog(@"返回");
}


#pragma mark - BMKPoiSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if(self.nearDataArry.count > 0){
        [self.nearDataArry removeAllObjects];
    }
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        [poiResultList.poiInfoList enumerateObjectsUsingBlock:^(BMKPoiInfo  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GYNearAddressModel * model = [[GYNearAddressModel alloc]init];
            model.title = obj.address;
            [self.nearDataArry addObject:model];
        }];
        [self.tableView reloadData];
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果---%d", error);
    }
}

#pragma mark --GYHEMapSelectAddressHeaderViewDelegate
-(void)searchLocalClickDelegate
{
    GYHEMapSearchAddressVC * searchVC = [[GYHEMapSearchAddressVC alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
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
        dispatch_async(dispatch_get_global_queue(2, 0), ^{
            [[GYHSLoginManager shareInstance] getLocationInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initPoiSearch];
            });
        });
    } cancleBlock:^{
    }];
}

-(void)initPoiSearch
{
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 20;
    option.radius = 200;
    option.location = globalData.locationCoordinate;
    option.keyword = @"酒店";
    BOOL flag = [self.poiSearch poiSearchNearBy:option];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (globalData.isLogined) { //登录:2 未登录:1
        return 3;
    }else{
        return 2;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (globalData.isLogined){  //登录
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return 3;
                break;
            case 2:
                if (self.nearDataArry.count > 0) {
                    return self.nearDataArry.count;
                }else{
                    return 0;
                }
                break;
            default:
                break;
        }
    }else{  //未登录
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                if (self.nearDataArry.count > 0) {
                    return self.nearDataArry.count;
                }else{
                    return 0;
                }
                break;
            default:
                break;
        }
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (globalData.isLogined){  //登录
        if (indexPath.section == 0) {
            GYHELocalAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:kGYHELocalAddressCellIdentifier];
            return addressCell;
        }else if(indexPath.section == 1) { //我的地址
            GYHEMapMyAddressCell *myAddressCell = [tableView dequeueReusableCellWithIdentifier:kGYHEMapMyAddressCellIdentifier];
            return myAddressCell;
        }else { //附近地址
            GYHEMapNearCell *addressCell = [tableView dequeueReusableCellWithIdentifier:kGYHEMapNearCellIdentifier];
            if(self.nearDataArry.count > 0){
                GYNearAddressModel* model = self.nearDataArry[indexPath.row];
                addressCell.nearAddressLabel.text = model.title;
            }else{
                addressCell.nearAddressLabel.text = globalData.locaitonAddress;
            }
            return addressCell;
        }
    }else{  //未登录
        if (indexPath.section == 0) {
            
            GYHELocalAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:kGYHELocalAddressCellIdentifier];
            return addressCell;
        }else{//附近地址
            GYHEMapNearCell *addressCell = [tableView dequeueReusableCellWithIdentifier:kGYHEMapNearCellIdentifier];
            if(self.nearDataArry.count > 0){
                if (_nearDataArry.count > indexPath.row) {
                    GYNearAddressModel* model = self.nearDataArry[indexPath.row];
                    [addressCell setModel:model];
                }
                return addressCell;
                
            }else{
                addressCell.nearAddressLabel.text = globalData.locaitonAddress;
            }
            return addressCell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self GPSAction];
    }else{
        NSLog(@"点击了地址");
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (globalData.isLogined){ //登录
        switch (indexPath.section){
            case 0:
                return 44;
                break;
            case 1:
                return 60;
                break;
            case 2:
                return 40;
                break;
            default:
                return 0.1;
                break;
        }
    }else{//未登录
        switch (indexPath.section){
            case 0:
                return 44;
                break;
            case 1:
                return 40;
                break;
            default:
                return 0.1;
                break;
        }
    }
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    if (globalData.isLogined){//登录
        if(section == 1){ //我的地址
            GYHEMapSelectSectionHeader* headerView;
            headerView = [[[NSBundle mainBundle] loadNibNamed:@"GYHEMapMyAddressHeader" owner:self options:nil] firstObject];
            return headerView;
        }else if(section == 2){  //附近
            GYHEMapSelectSectionHeader* headerView;
            headerView = [[[NSBundle mainBundle] loadNibNamed:@"GYHEMapSelectSectionHeader" owner:self options:nil] firstObject];
            return headerView;
        }else{
            return nil;
        }
    }else{ //未登录
        if (section == 1) {  //附近
            GYHEMapSelectSectionHeader* headerView;
            headerView = [[[NSBundle mainBundle] loadNibNamed:@"GYHEMapSelectSectionHeader" owner:self options:nil] firstObject];
            return headerView;
        }else{
            return nil;
        }
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return 15;
    }
    return 35;
}

#pragma mark --lazy mark
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth,kScreenHeight - 24) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEMapMyAddressCell class]) bundle:nil] forCellReuseIdentifier:kGYHEMapMyAddressCellIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEMapNearCell class]) bundle:nil] forCellReuseIdentifier:kGYHEMapNearCellIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHELocalAddressCell class]) bundle:nil] forCellReuseIdentifier:kGYHELocalAddressCellIdentifier];
        self.tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

-(NSMutableArray *)nearDataArry
{
    if (!_nearDataArry) {
        _nearDataArry = [NSMutableArray array];
    }
    return _nearDataArry;
}

-(NSMutableArray *)adressDataArry
{
    if (!_adressDataArry) {
        _adressDataArry = [NSMutableArray array];
    }
    return _adressDataArry;
}

- (GYHEMapSelectAddressHeaderView*)headerView
{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"GYHEMapSelectAddressHeaderView" owner:self options:nil] firstObject];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (BMKPoiSearch *)poiSearch
{
    if (_poiSearch == nil) {
        _poiSearch = [[BMKPoiSearch alloc] init];
        _poiSearch.delegate = self;
    }
    return _poiSearch;
}

@end
