//
//  GYCityAddressSelectCityVC.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/30.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYCityAddressSelectCityVC.h"
#import "GYHSCityAddressModel.h"
#import "GYHSAddBankCardInfoVC.h"
#import "GYHSAddressSelectCityDataController.h"
#import "GYHSConstant.h"
@interface GYCityAddressSelectCityVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, strong) GYHSAddressSelectCityDataController* selectCityDC;

@end

@implementation GYCityAddressSelectCityVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kLocalized(@"GYHS_Banding_Choose_City");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc ]init];

    WS(weakSelf)
        [self.selectCityDC queyrCitys:self.areaId privinceNo:self.provinceNO resultBlock:^(NSArray* citysArray) {
        if ([citysArray count] > 0) {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.dataArray addObjectsFromArray:citysArray];
            [weakSelf.tableView reloadData];
        }
        }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    CGFloat sectionHeight = 20;

    if (section == 2) {
        sectionHeight = 0;
    }

    return sectionHeight;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44.0f;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    static NSString* cellIdentifer = @"GYHSCitysCellIdentify";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }

    if (indexPath.section == 0) {
        cell.textLabel.text = self.countryProvinceInfo;
        UILabel* lbSelect = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        lbSelect.font = [UIFont systemFontOfSize:15.0];
        lbSelect.text = kLocalized(@"GYHS_Banding_Universally_PositioningSelect");
        cell.accessoryView = lbSelect;
    }
    else if (indexPath.section == 1) {
        GYHSCityAddressModel* model = nil;
        if (self.dataArray.count > indexPath.row) {
            model = self.dataArray[indexPath.row];
        }
        cell.textLabel.text = model.cityName;
        cell.accessoryView = nil;
    }

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{

    if (indexPath.row >= [self.dataArray count]) {
        return;
    }

    GYHSCityAddressModel* model = nil;
    if (self.dataArray.count > indexPath.row) {
        model = self.dataArray[indexPath.row];
    }

    //jianglincen增加method
    if (self.isFromAddressVC) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCityModel:)]) {

            [self.delegate didSelectCityModel:model];
        }
        [self.navigationController popViewControllerAnimated:YES];

        return;
    }

    NSString* strArea = [NSString stringWithFormat:@"%@ %@", self.countryProvinceInfo, model.cityName];

    NSMutableDictionary* cityDic = [NSMutableDictionary dictionary];
    [cityDic setObject:strArea forKey:@"cityInfo"];

    if (![GYUtils checkObjectInvalid:self.selectIndexPath]) {
        [cityDic setObject:self.selectIndexPath forKey:@"selectIndexPath"];
    }

    if (![GYUtils checkStringInvalid:self.areaId]) {
        [cityDic setObject:self.areaId forKey:@"countryNo"];
    }

    if (![GYUtils checkStringInvalid:self.provinceNO]) {
        [cityDic setObject:self.provinceNO forKey:@"provinceNo"];
    }

    if (![GYUtils checkStringInvalid:model.cityNo]) {
        [cityDic setObject:model.cityNo forKey:@"cityNo"];
    }

    NSMutableArray* allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];

    for (UIViewController* aViewController in allViewControllers) {
        if ([aViewController isKindOfClass:[GYHSAddBankCardInfoVC class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kGYHSAddBankCardInfoSelectCitysNotification object:cityDic userInfo:nil];
            [self.navigationController popToViewController:aViewController animated:YES];
        }
    }
}

#pragma mark - getter and setter
- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
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

- (GYHSAddressSelectCityDataController*)selectCityDC
{
    if (_selectCityDC == nil) {
        _selectCityDC = [[GYHSAddressSelectCityDataController alloc] init];
    }

    return _selectCityDC;
}

@end
