//
//  GYSurroundVisitShopController.m
//  GYHSConsumer_SurroundVisit
//
//  Created by zhangqy on 16/3/18.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSurroundVisitShopController.h"
#import "GYSurroundVisitShopModel.h"
#import "GYSurroundShopVisitFirstCell.h"
#import "GYSurroundShopVisitSecondCell.h"
#import "GYSurroundShopVisitThirdCell.h"
#import "GYSurroundShopVisitFourthCell.h"
#import "JSONModel+ResponseObject.h"
//#import "GYSurroundShopListController.h"
#import "GYShopDescribeController.h"
#import "GYSurroundVisitShopListCell.h"
#import "GYSurroundVisitShopListModel.h"
//#import "GYSurroundShopDetailController.h"
#import "GYSearchShopsViewController.h"
#import "GYEasyBuyModel.h"
#import "GYAppDelegate.h"
#import "GYHEUtil.h"

#define kGYSurroundShopVisitFirstCellReuseId @"GYSurroundShopVisitFirstCell"
#define kGYSurroundShopVisitSecondCellReuseId @"GYSurroundShopVisitSecondCell"
#define kGYSurroundShopVisitThirdCellReuseId @"GYSurroundShopVisitThirdCell"
#define kGYSurroundShopVisitFourthCellReuseId @"GYSurroundShopVisitFourthCell"
#define kGYSurroundVisitShopListCellReuseId @"GYSurroundVisitShopListCell"
@interface GYSurroundVisitShopController () <UITableViewDelegate, UITableViewDataSource, GYNetRequestDelegate, GYSurroundShopVisitSecondCellDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) GYSurroundVisitShopModel* visitShopModel;
@property (nonatomic, strong) NSArray* historyShops;
//跳转旧代码的商铺而存的模型（以后会删除）
@property (nonatomic, strong) NSMutableArray* shopModelArr;

@end

@implementation GYSurroundVisitShopController

#pragma mark Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupTableView];
    [self requestData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHistoryData) name:kGYHSLoginManagerCityAddressNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showHistoryData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showHistoryData
{
    if (globalData.isLogined) {
        [self requestHistoryShops];
    }
    else {
        [self loadHistoryShops];
    }
}

- (void)requestHistoryShops
{
    if ([GYUtils checkStringInvalid:globalData.selectedCityCoordinate] && (globalData.locationCoordinate.latitude == 0 && globalData.locationCoordinate.longitude == 0)) {
        DDLogDebug(@"The selectedCityCoordinate and locationCoordinate is invalid.");
        return;
    }

    NSDictionary* params = [[NSMutableDictionary alloc] init];
    [params setValue:globalData.loginModel.token forKey:@"key"];

    if ([GYUtils checkStringInvalid:globalData.selectedCityCoordinate]) {
        [params setValue:[NSString stringWithFormat:@"%f,%f", globalData.locationCoordinate.latitude, globalData.locationCoordinate.longitude] forKey:@"landmark"];
    }
    else {
        [params setValue:globalData.selectedCityCoordinate forKey:@"landmark"];
    }

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:GetBeforeShopListUrl parameters:params requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    request.tag = 2;
    [request start];
}

- (void)loadHistoryShops
{
    //未登录
    // 本地浏览记录
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kKeyForVisitHistory];
    NSArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSMutableArray* mutArr = [[NSMutableArray alloc] init];

    for (ShopModel* model in array) {
        GYSurroundVisitShopListModel* mod = [[GYSurroundVisitShopListModel alloc] init];
        mod.beSell = [model.beSell boolValue];
        mod.beQuan = [model.beQuan boolValue];
        mod.categoryNames = model.categoryNames;
        mod.beCash = [model.beCash boolValue];
        mod.id = model.strID;
        mod.vShopId = model.strVshopId;
        mod.url = model.strShopPictureURL;
        //                mod.shopPic = model.;
        mod.beTake = [model.beTake boolValue];
        mod.pointsProportion = model.pointsProportion;
        mod.companyName = model.strCompanyName;
        mod.resno = model.strResno;
        mod.dist = model.shopDistance;
        mod.rate = model.strRate;
        mod.section = model.section;
        mod.addr = model.strShopAddress;
        mod.tel = model.strShopTel;
        mod.beReach = [model.beReach boolValue];
        [mutArr addObject:mod];
    }
    //    if ([array count] > 0) {
    self.historyShops = mutArr.copy;
    //    }

    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark second cell Delegate
- (void)surroundShopVisitSecondCell:(GYSurroundShopVisitSecondCell*)cell didSelectItemAtIndexPath:(NSIndexPath*)indexPath categoryName:(NSString*)categoryName categoryId:(NSString*)categoryId
{
    UIViewController* vc = nil;
    if (indexPath.item == 2) {
        vc = [[NSClassFromString(@"FDMainViewController") alloc] init];
    }
    else if (indexPath.item == 3) {
        vc = [[NSClassFromString(@"FDTakeawayMainViewController") alloc] init];
    }
    else {
        //新代码（还未迁移）
        //        GYSurroundShopListController *listVC = [[GYSurroundShopListController alloc] init];
        //        listVC.categoryName = categoryName;
        //        listVC.id = categoryId;
        //        vc = listVC;
        GYSearchShopsViewController* listVC = [[GYSearchShopsViewController alloc] init];
        if ([categoryId isEqualToString:@"1002"]) {
            
            listVC.modelID = @"";
        }
        else {
            listVC.modelID = categoryId;
        }
        listVC.modelTitle = categoryName;
        listVC.hidesBottomBarWhenPushed = YES;
        vc = listVC;
    }
    UIViewController* mainVC = self.parentViewController;
    if (mainVC && mainVC.navigationController && vc) {
        vc.hidesBottomBarWhenPushed = YES;
        [mainVC.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark netRequestDelegate
- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    if (netRequest.tag == 1) {
        [self handleWithResponseData:responseObject];
    }
    else if (netRequest.tag == 2) {
        //经常光顾
        self.historyShops = [GYSurroundVisitShopListModel modelArrayWithResponseObject:responseObject error:nil];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];

        //为了跳转商铺而存的shopModel模型（以后会删除）
        NSArray* visitArr = responseObject[@"data"];

        if ([GYUtils checkArrayInvalid:visitArr]) {
            DDLogDebug(@"The visitArr:%@ is invalid.", visitArr);
            return;
        }
        for (NSDictionary* dic in visitArr) {
            if ([GYUtils checkDictionaryInvalid:dic]) {
                continue;
            }

            ShopModel* model = [ShopModel modelWithDictionary:dic];
            [self.shopModelArr addObject:model];
        }
    }
    else if (netRequest.tag == 3) {

        NSDictionary* serverDic = responseObject;
        if ([GYUtils checkDictionaryInvalid:serverDic]) {
            DDLogDebug(@"The ServerDic:%@ is invalid.", serverDic);
            return;
        }

        globalData.goodsNum = kSaftToNSInteger(serverDic[@"data"]);
    }
}

- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}

#pragma mark tableView dataSource delegate
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            GYSurroundShopVisitFirstCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYSurroundShopVisitFirstCellReuseId forIndexPath:indexPath];
            GYSurroundVisitShopItemModel* model = _visitShopModel.firstCategories.firstObject;
            cell.imageURLString = model.picAddr;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.row == 1) {
            GYSurroundShopVisitSecondCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYSurroundShopVisitSecondCellReuseId forIndexPath:indexPath];
            cell.delegate = self;
            
            cell.secondCategories = _visitShopModel.secondCategories;
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.row == 2) {
            GYSurroundShopVisitThirdCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYSurroundShopVisitThirdCellReuseId];

            GYSurroundVisitShopItemModel* leftModel = _visitShopModel.thirdCategories.firstObject;
            GYSurroundVisitShopItemModel* rightModel = _visitShopModel.thirdCategories.lastObject;
            cell.leftImageURLString = leftModel.picAddr;
            cell.rightImageURLString = rightModel.picAddr;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.row == 3) {
            GYSurroundShopVisitFourthCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYSurroundShopVisitFourthCellReuseId forIndexPath:indexPath];
            GYSurroundVisitShopItemModel* firstModel = _visitShopModel.fourthCategories.firstObject;
            GYSurroundVisitShopItemModel* secondModel = _visitShopModel.fourthCategories.lastObject;
            cell.firstImageURLStrings = firstModel.picAddr;
            cell.secondImageURLStrings = secondModel.picAddr;
            return cell;
        }
    }
    else if (indexPath.section == 1) {
        GYSurroundVisitShopListCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYSurroundVisitShopListCellReuseId];
        if(self.historyShops.count >indexPath.row) {
            cell.model = self.historyShops[indexPath.row];
        }
        
        return cell;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    else if (section == 1) {
        return self.historyShops.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CGFloat width = [[UIScreen mainScreen] bounds].size.width;
            CGFloat height = width * 16 / 75;
            return height;
        }
        if (indexPath.row == 1) {
            return 170;
        }
        if (indexPath.row == 2) {
            return kScreenWidth / 750.0 * 260.0;
        }
        if (indexPath.row == 3) {
            CGFloat width = [[UIScreen mainScreen] bounds].size.width;
            CGFloat height = width * 16 / 75 + 15;
            return height;
        }
    }
    else if (indexPath.section == 1) {
        return 100;
    }

    return 0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    else if (section == 1) {
        return 30;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 15)];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = kgrayTextColor;
        lab.text = kLocalized(@"GYHE_SurroundVisit_Patronize");
        [view addSubview:lab];
        return view;
    }
    return nil;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        //取网络保存
        if (globalData.isLogined) {
            if (self.shopModelArr.count > indexPath.row) {
                ShopModel* model = self.shopModelArr[indexPath.row];
                GYShopDescribeController* vc = [[GYShopDescribeController alloc] init];
                vc.shopModel = model;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else {
            //取本地缓存
            NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kKeyForVisitHistory];
            NSArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:data];

            if (indexPath.row < [array count]) {
                ShopModel* model = array[indexPath.row];
                GYShopDescribeController* vc = [[GYShopDescribeController alloc] init];
                vc.shopModel = model;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

#pragma mark 自定义方法
- (void)requestData
{
    //读本地存储
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ShopData" ofType:@"plist"]];
    _visitShopModel = [[GYSurroundVisitShopModel alloc] initWithDictionary:dict error:nil];
    
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:GetShopsMainInterfaceUrl parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    request.cacheTimeInSeconds = 3600;
    request.tag = 1;
    [request start];
    
    

    [self getGoodsNum];
}
// 商品个数
- (void)getGoodsNum
{
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuyGetCartMaxSizeUrl parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    request.tag = 3;
    [request start];
}

- (void)handleWithResponseData:(NSDictionary*)data
{
    _visitShopModel = [[GYSurroundVisitShopModel modelArrayWithResponseObject:data error:nil] firstObject];
    [_tableView reloadData];
}

- (void)setupTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[GYSurroundShopVisitFirstCell class] forCellReuseIdentifier:kGYSurroundShopVisitFirstCellReuseId];
    [_tableView registerClass:[GYSurroundShopVisitSecondCell class] forCellReuseIdentifier:kGYSurroundShopVisitSecondCellReuseId];
    [_tableView registerNib:[UINib nibWithNibName:kGYSurroundShopVisitThirdCellReuseId bundle:nil] forCellReuseIdentifier:kGYSurroundShopVisitThirdCellReuseId];
    [_tableView registerClass:[GYSurroundShopVisitFourthCell class] forCellReuseIdentifier:kGYSurroundShopVisitFourthCellReuseId];
    [_tableView registerNib:[UINib nibWithNibName:kGYSurroundVisitShopListCellReuseId bundle:nil] forCellReuseIdentifier:kGYSurroundVisitShopListCellReuseId];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark 懒加载
- (NSMutableArray*)shopModelArr
{
    if (!_shopModelArr) {
        _shopModelArr = [[NSMutableArray alloc] init];
    }
    return _shopModelArr;
}
- (NSArray *)historyShops {
    if(!_historyShops) {
        _historyShops = [[NSArray alloc] init];
    }
    return _historyShops;
}

@end
