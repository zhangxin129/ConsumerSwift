//
//  GYAddressCountryViewController.m
//  HSConsumer
//
//  Created by apple on 15-1-29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSAddressSelectCountryVC.h"
#import "GYHSAddressCountryModel.h"
#import "GYNetRequest.h"
#import "GYHSLoginManager.h"
#import "GYHSLocalInfoModel.h"
#import "GYHAddressSelectProvinceVC.h"
#import "GYHSConstant.h"
@interface GYHSAddressSelectCountryVC () <UITableViewDataSource, UITableViewDelegate, GYNetRequestDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;

@end

@implementation GYHSAddressSelectCountryVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kLocalized(@"GYHS_Banding_Navigation_SelectBanCardArea");
    self.view.backgroundColor = kDefaultVCBackgroundColor;

    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];

    NSArray* localAry = [self loadLocalCountryData];
    if ([localAry count] <= 0) {
        [self queryCountryData];
    }
    else {
        NSArray* userAry = [self queryUserCountry:localAry];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:userAry];
        [self.tableView reloadData];
    }
}

#pragma mark DataSourceDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 2;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{

    CGFloat sectionHeight = 20;
    if (section == 2) {
        sectionHeight = 0;
    }

    return sectionHeight;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;

    if (section == 0) {
        rows = 1;
    }
    else if (section == 1) {
        rows = self.dataArray.count;
    }

    return rows;
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    if (indexPath.section == 0) {
        cell.textLabel.text = self.strSelectedArea;
        UILabel* lbSelect = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        lbSelect.font = [UIFont systemFontOfSize:15.0];
        lbSelect.text = kLocalized(@"GYHS_Banding_Universally_PositioningSelect");
        cell.accessoryView = lbSelect;
    }
    else if (indexPath.section == 1) {
        GYHSAddressCountryModel* mod = nil;
        if (self.dataArray.count > indexPath.row) {
            mod = self.dataArray[indexPath.row];
        }
        cell.textLabel.text = mod.countryName;
        cell.accessoryView = nil;
    }

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    GYHSAddressCountryModel* model = nil;
    if (self.dataArray.count > indexPath.row) {
        model = self.dataArray[indexPath.row];
    }
    GYHAddressSelectProvinceVC* vc = [[GYHAddressSelectProvinceVC alloc] init];
    vc.mstrCountry = [model.countryName mutableCopy];
    vc.areaId = model.countryNo;
    vc.selectIndexPath = self.selectIndexPath;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    DDLogDebug(@"responseObject:%@", responseObject);

    if ([GYUtils checkDictionaryInvalid:responseObject]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_Return_Data_Parsing_Error") confirm:nil];
        return;
    }

    NSInteger returnCode = [[responseObject objectForKey:@"retCode"] integerValue];
    if (returnCode != 200) {
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_QueryDataFailure") confirm:nil];
        return;
    }

    NSArray* serverAry = responseObject[@"data"];
    if ([GYUtils checkArrayInvalid:serverAry]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_Return_Data_Parsing_Error") confirm:nil];
        return;
    }

    NSMutableArray* resultAry = [NSMutableArray array];
    for (NSDictionary* indexDic in serverAry) {
        if ([GYUtils checkDictionaryInvalid:indexDic]) {
            continue;
        }

        GYHSAddressCountryModel* model = [[GYHSAddressCountryModel alloc] initWithDictionary:indexDic error:nil];
        [resultAry addObject:model];
    }

    if ([resultAry count] > 0) {
        NSArray* userAry = [self queryUserCountry:resultAry];
        [self saveCountryData:resultAry];

        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:userAry];
        [self.tableView reloadData];
    }
}

- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}

#pragma mark - private methods
- (void)queryCountryData
{

    NSString* url = kUrlQueryCountry;
    NSDictionary* paramsDic = @{};

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:url parameters:paramsDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    [request start];
}

- (NSMutableArray*)queryUserCountry:(NSArray*)array
{
    GYHSLocalInfoModel* userModel = [[GYHSLoginManager shareInstance] localInfoModel];

    NSMutableArray* resultArray = [NSMutableArray array];
    if ([GYUtils checkStringInvalid:userModel.countryNo]) {
        DDLogDebug(@"The userModel is nil.");
        return resultArray;
    }

    for (GYHSAddressCountryModel* indexModel in array) {
        if ([indexModel.countryNo isEqualToString:userModel.countryNo]) {
            [resultArray addObject:indexModel];
        }
    }

    return resultArray;
}

- (NSArray*)loadLocalCountryData
{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"GYHSAddressCountryData"];
    NSArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    if ([GYUtils checkArrayInvalid:array]) {
        array = [NSArray array];
    }

    return array;
}

- (void)saveCountryData:(NSArray*)array
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
        [userDefault setObject:data forKey:@"GYHSAddressCountryData"];
        [userDefault synchronize];
    });
}

#pragma mark - getter and setter
- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:(UITableViewStyleGrouped)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }

    return _tableView;
}

- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

@end
