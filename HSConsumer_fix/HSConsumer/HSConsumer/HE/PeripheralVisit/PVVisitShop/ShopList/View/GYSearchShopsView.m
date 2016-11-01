//
//  GYSearchShopsView.m
//  HSConsumer
//
//  Created by apple on 15/11/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSearchShopsView.h"
#import "GYSeachShopsHeadView.h"
#import "GYShopADCell.h"
#import "GYShopIntegrationCell.h"
#import "GYAppDelegate.h"
#import "GYSearchShopsMainModel.h"
#import "GYEasyBuyModel.h"
#import "GYShopVisitCell.h"
#import "GYGIFHUD.h"

@interface GYSearchShopsView () <GYNetRequestDelegate>
@end

@implementation GYSearchShopsView {

    NSMutableArray* _mArrProperties; //常用按钮数组
    NSString* _loginKey; //登录key
    NSString* _landMark; //定位坐标
    NSString* _currentCity; //当前城市
    CLLocationCoordinate2D _currentlocationCorrrdinate; //坐标

    NSMutableArray* _topArr; //上推广数组；
    NSMutableArray* _bottomArr; //下推广数组；

    NSMutableArray* _btnArr; //中部按钮数组；
    NSMutableArray* _adArr; //广告数组

    GYSeachShopsHeadView* _headView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _topArr = [NSMutableArray array];
        _bottomArr = [NSMutableArray array];
        _btnArr = [NSMutableArray array];
        _adArr = [NSMutableArray array];
        _vistArr = [NSMutableArray array];

        [self initView];
    }

    return self;
}

- (void)initView
{
    [self setShopTableVIew];
    // 加载本地数据
    [self readLocalShopData];

    // 查询网络数据
    [self loadMainData];
}

#pragma mark - 创建tableview
- (void)setShopTableVIew
{
    _shopTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _shopTableView.delegate = self;
    _shopTableView.dataSource = self;
    _shopTableView.showsHorizontalScrollIndicator = NO;
    _shopTableView.showsVerticalScrollIndicator = NO;
    _shopTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _shopTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_shopTableView registerNib:[UINib nibWithNibName:@"GYShopIntegrationCell" bundle:nil] forCellReuseIdentifier:@"ShopIntergrationCellIdentify"];
    [_shopTableView registerClass:[GYShopADCell class] forCellReuseIdentifier:@"GYShopADCellIdentify"];
    [_shopTableView registerNib:[UINib nibWithNibName:@"GYShopVisitCell" bundle:nil] forCellReuseIdentifier:@"GYShopVisitCellIdentify"];

    _headView = [[GYSeachShopsHeadView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 240)];

    WS(weakSelf)
    _headView.block = ^(NSInteger tag, NSDictionary* model) {
        [weakSelf pushTag:tag model:model];
    };
    _shopTableView.tableHeaderView = _headView;
    self.userInteractionEnabled = YES;
    [self addSubview:_shopTableView];
}

#pragma mark - 获取数据
- (void)loadMainData
{
    NSDictionary* params = [[NSMutableDictionary alloc] init];
    [params setValue:globalData.loginModel.token forKey:@"key"];
    [params setValue:@"" forKey:@"landmark"];

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:GetShopsMainInterfaceUrl parameters:params requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    [request start];
}

- (void)handleMainData:(NSDictionary*)dict
{
    NSInteger returnCode = [[NSString stringWithFormat:@"%@", [dict objectForKey:@"retCode"]] integerValue];
    if (returnCode != 200) {
        DDLogDebug(@"The returnCode:%@ is not 200.", dict);
        return;
    }

    NSDictionary* tempDic = dict[@"data"];
    [self parseShopData:tempDic];
}

- (void)readLocalShopData
{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"ShopData"
                                                         ofType:@"plist"];
    if ([GYUtils checkStringInvalid:filePath]) {
        DDLogDebug(@"The filePath is nil.");
        return;
    }
    NSDictionary* tempDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    [self parseShopData:tempDic];
}

- (void)parseShopData:(NSDictionary*)tempDic
{
    if ([GYUtils checkDictionaryInvalid:tempDic]) {
        DDLogDebug(@"The tempDic:%@ is invald.", tempDic);
        return;
    }

    NSArray* topArr = tempDic[@"firstCategories"];
    [_topArr removeAllObjects];
    [_topArr addObjectsFromArray:topArr];

    NSArray* btnArr = tempDic[@"secondCategories"];
    [_btnArr removeAllObjects];
    [_btnArr addObjectsFromArray:btnArr];

    NSArray* bottomArr = tempDic[@"fourthCategories"];
    [_bottomArr removeAllObjects];
    [_bottomArr addObjectsFromArray:bottomArr];

    NSArray* adArr = tempDic[@"thirdCategories"];
    [_adArr removeAllObjects];
    [_adArr addObjectsFromArray:adArr];

    _headView.topArr = _topArr;
    _headView.btnArr = _btnArr;
    [_shopTableView reloadData];
}

- (void)loadHistoryData
{
    if (globalData.loginModel.token.length > 0) {
        _landMark = [NSString stringWithFormat:@"%f,%f", globalData.locationCoordinate.latitude, globalData.locationCoordinate.longitude];
        if (globalData.selectedCityCoordinate) {
            _landMark = globalData.selectedCityCoordinate;
        }

        NSDictionary* params = [[NSMutableDictionary alloc] init];
        [params setValue:globalData.loginModel.token forKey:@"key"];
        [params setValue:_landMark forKey:@"landmark"];

        GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:GetBeforeShopListUrl parameters:params requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
        [request start];
    }
    else {
        //未登录
        [_vistArr removeAllObjects];
        // 本地浏览记录
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kKeyForVisitHistory];
        NSArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:data];

        if ([array count] > 0) {
            [_vistArr addObjectsFromArray:array];
            [self reloadHistoryData];
        }
    }
}

- (void)handleHistoryData:(NSDictionary*)dict
{
    NSInteger returnCode = [[NSString stringWithFormat:@"%@", [dict objectForKey:@"retCode"]] integerValue];
    if (returnCode != 200) {
        DDLogDebug(@"The returnCode:%@ is not 200.", dict);
        return;
    }

    [_vistArr removeAllObjects];
    NSArray* visitArr = dict[@"data"];

    if ([GYUtils checkArrayInvalid:visitArr]) {
        DDLogDebug(@"The visitArr:%@ is invalid.", visitArr);
        return;
    }

    for (NSDictionary* dic in visitArr) {
        if ([GYUtils checkDictionaryInvalid:dic]) {
            continue;
        }

        ShopModel* model = [ShopModel modelWithDictionary:dic];
        [_vistArr addObject:model];
    }

    if ([_vistArr count] > 0) {
        [self reloadHistoryData];
    }
}

- (void)reloadHistoryData
{
    NSIndexSet* indexSet = [[NSIndexSet alloc] initWithIndex:2];
    [_shopTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    [GYGIFHUD dismiss];
    if ([netRequest.URLString isEqualToString:GetShopsMainInterfaceUrl]) {
        [self handleMainData:responseObject];
    }
    else {
        [self handleHistoryData:responseObject];
    }
}

#pragma mark - tableview的代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    // 积分抵扣券
    if (indexPath.section == 0) {
        GYShopIntegrationCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShopIntergrationCellIdentify"];
        cell.picArr = _adArr;
        cell.block = ^(NSInteger tag, NSString* idStr) {
            [self pushTag:tag idStr:idStr];
        };

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    // 广告滚动页面
    else if (indexPath.section == 1) {
        GYShopADCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYShopADCellIdentify"];
        cell.imgArr = _bottomArr;
        cell.block = ^(NSInteger tag, NSString* idStr) {
            [self pushTag:tag idStr:idStr];
        };

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

    GYShopVisitCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYShopVisitCellIdentify"];
    cell.visitArr = _vistArr;
    cell.contentView.hidden = NO;

    if (_vistArr.count == 0) {
        cell.contentView.hidden = YES;
    }

    cell.block = ^(ShopModel* model) {
        [self pushVC:model];
    };

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CGFloat cellHight;
    if (indexPath.section == 0) {
        cellHight = 90;
    }
    else if (indexPath.section == 1) {
        cellHight = 70;
    }
    else if (indexPath.section == 2) {
        cellHight = _vistArr.count * 100 + 50;
    }

    return cellHight;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

#pragma mark - 传输tag值到主界面跳转视图
- (void)pushTag:(NSInteger)tag idStr:(NSString*)idStr
{
    if (_block) {
        _block(tag, idStr);
    }
}

- (void)pushVC:(ShopModel *)model {
    _modelBlcok(model);
}

- (void)pushTag:(NSInteger)tag model:(NSDictionary *)model {

    if (_myBlock) {
        _myBlock(tag, model);
    }
}

@end
