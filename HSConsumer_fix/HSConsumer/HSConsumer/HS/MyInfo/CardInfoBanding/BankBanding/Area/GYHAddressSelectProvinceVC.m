//
//  GYProvinceViewController.m
//  HSConsumer
//
//  Created by apple on 15-1-29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHAddressSelectProvinceVC.h"
#import "GYHSProvinceModel.h"
#import "GYNetRequest.h"
#import "GYCityAddressSelectCityVC.h"
#import "GYHSConstant.h"
@interface GYHAddressSelectProvinceVC () <UITableViewDelegate, UITableViewDataSource, GYNetRequestDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;

@end

@implementation GYHAddressSelectProvinceVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = kLocalized(@"GYHS_Banding_Choose_Province");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];

    NSArray* localAry = [self loadLocalPrivinceData];
    if ([localAry count] <= 0) {
        [self queryProvinceData];
    }
    else {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:localAry];
        [self.tableView reloadData];
    }
}

#pragma mark DataSourceDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;

    if (section == 0) {
        rows = 1;
    }
    else if (section == 1) {
        rows = [self.dataArray count];
    }

    return rows;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat sectionHeight = 30;

    if (section == 2) {
        sectionHeight = 0;
    }

    return sectionHeight;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifer = @"PrivineceCellIdentify";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }

    if (indexPath.section == 0) {
        cell.textLabel.text = self.mstrCountry;
        UILabel* lbSelect = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        lbSelect.font = [UIFont systemFontOfSize:15.0];
        lbSelect.text = kLocalized(@"GYHS_Banding_Universally_PositioningSelect");
        cell.accessoryView = lbSelect;
    }
    else if (indexPath.section == 1) {

        if (indexPath.row < [self.dataArray count]) {
            GYHSProvinceModel* model = self.dataArray[indexPath.row];
            cell.textLabel.text = model.provinceName;
            cell.accessoryView = nil;
        }
    }

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    GYCityAddressSelectCityVC* vc = [[GYCityAddressSelectCityVC alloc] init];

    if (([self.dataArray count] <= 0) || (indexPath.row > [self.dataArray count])) {
        DDLogDebug(@"The indexPath row:%ld is more than dataAry count:%ld", indexPath.row, [self.dataArray count]);
        return;
    }
    GYHSProvinceModel* model = self.dataArray[indexPath.row];

    //jianglincen增加method
    if (self.isFromAddressVC) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectProvinceModel:)]) {

            [self.delegate didSelectProvinceModel:model];
        }
        [self.navigationController popViewControllerAnimated:YES];

        return;
    }

    vc.provinceNO = model.provinceNo;
    vc.areaId = self.areaId;
    vc.countryProvinceInfo = [[NSString stringWithFormat:@"%@ %@", self.mstrCountry, model.provinceName] mutableCopy];
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
        [GYUtils showMessage:@"返回数据解析错误。" confirm:nil];
        return;
    }

    NSMutableArray* resultAry = [NSMutableArray array];
    for (NSDictionary* indexDic in serverAry) {
        if ([GYUtils checkDictionaryInvalid:indexDic]) {
            continue;
        }

        GYHSProvinceModel* model = [[GYHSProvinceModel alloc] initWithDictionary:indexDic error:nil];
        [resultAry addObject:model];
    }

    if ([resultAry count] > 0) {
        [self savePrivinceData:resultAry];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:resultAry];
        [self.tableView reloadData];
    }
}

- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}

#pragma mark - private medthos
- (void)queryProvinceData
{
    NSDictionary* paramsDic = @{ @"countryNo" : self.areaId };

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlQueryProvince parameters:paramsDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    [request start];
}

- (NSArray*)loadLocalPrivinceData
{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:[self privinceDataKey]];
    NSArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    if ([GYUtils checkArrayInvalid:array]) {
        array = [NSArray array];
    }

    return array;
}

- (void)savePrivinceData:(NSArray*)array
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
        [userDefault setObject:data forKey:[self privinceDataKey]];
        [userDefault synchronize];
    });
}

- (NSString*)privinceDataKey
{
    return [NSString stringWithFormat:@"GYHSAddressPrivienceData%@", self.areaId];
}

#pragma mark - getter and setter
- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];

        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44.f;
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
