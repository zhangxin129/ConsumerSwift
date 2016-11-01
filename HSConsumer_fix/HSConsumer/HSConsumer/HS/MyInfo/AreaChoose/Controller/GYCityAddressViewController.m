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

#import "GYCityAddressViewController.h"
#import "UIAlertView+Blocks.h"
#import "GYCityAddressModel.h"
#import "FMDB.h"
#import "GYHSBasicInfomationController.h"
#import "GYAddressData.h"

@interface GYCityAddressViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) UITableView* tableView;

@end

@implementation GYCityAddressViewController {

    FMDatabase* dataBase;
}
- (NSMutableArray*)marrSourceData
{
    if (_marrSourceData == nil) {
        _marrSourceData = [[NSMutableArray alloc] init];
    }
    return _marrSourceData;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.marrSourceData.count == 0) {
        [self loadData];
    }
}

- (void)loadData //返回网络请求数据
{
    if (!self.areaIdcounyry || !self.areaIdString) {
        [self.tableView removeFromSuperview];
        return;
    }

    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kCityKey];
    if (data) {
        NSArray* cityArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        for (GYCityAddressModel* model in cityArr) {
            if ([model.provinceNo isEqualToString:self.areaIdString]) {
                [self.marrSourceData addObject:model];
            }
        }
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    self.title = kLocalized(@"GYHS_Address_Navigation_SelectCity");
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.backgroundColor = kDefaultVCBackgroundColor;
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark DataSourceDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if (self.type == cityTypePop) {
        return 1;
    }

    return 2;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == cityTypePop) {
        return self.marrSourceData.count;
    }
    NSInteger rows;
    switch (section) {
    case 0:
        rows = 1;
        break;
    case 1: {
        return self.marrSourceData.count;
    }
    default:
        break;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.type == cityTypePop) {
        return 15;
    }

    CGFloat sectionHeight;
    sectionHeight = 20;
    switch (section) {
    case 2:
        sectionHeight = 0;
        break;

    default:
        break;
    }

    return sectionHeight;
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

    if (self.type == cityTypePop) {
        GYCityAddressModel* MOD = nil;
        if (self.marrSourceData.count > indexPath.row) {
            MOD = self.marrSourceData[indexPath.row];
        }

        cell.textLabel.text = MOD.cityName;

        cell.accessoryView = nil;
        return cell;
    }

    switch (indexPath.section) {
    case 0: {
        cell.textLabel.text = self.mstrCountryAndProvince;
        UILabel* lbSelect = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        lbSelect.font = [UIFont systemFontOfSize:15.0];
        lbSelect.text = kLocalized(@"GYHS_Address_Universally_PositioningSelect");
        cell.accessoryView = lbSelect;

    } break;
    case 1: {
        GYCityAddressModel* MOD = nil;
        if (self.marrSourceData .count > indexPath.row) {
            MOD = self.marrSourceData[indexPath.row];
        }

        cell.textLabel.text = MOD.cityName;

        cell.accessoryView = nil;

    } break;
    default:
        break;
    }

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{

    GYCityAddressModel* MOD = nil;
    if (self.marrSourceData.count > indexPath.row) {
        MOD = self.marrSourceData[indexPath.row];
    }

    if (self.type == cityTypePop && self.delegate && [self.delegate respondsToSelector:@selector(returnPopCity:)]) {
        [self.delegate returnPopCity:MOD];
        [self.navigationController popViewControllerAnimated:YES];
    }

    NSUserDefaults* cityDefault = [NSUserDefaults standardUserDefaults];
    [cityDefault setObject:MOD.cityNo forKey:@"cityNO"];

    [cityDefault setObject:MOD.cityName forKey:@"cityName"];
    //add by wangbb
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:MOD];
    [cityDefault setObject:data forKey:@"GYCityAddressModel"];
    [cityDefault synchronize];


    NSMutableArray* allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController* aViewController in allViewControllers) {

        if ([aViewController isKindOfClass:[GYHSBasicInfomationController class]]) {

            [[NSNotificationCenter defaultCenter] postNotificationName:@"GYUpdateBasicInfomationNotification" object:MOD userInfo:nil];
            [self.navigationController popToViewController:aViewController animated:YES];
        }
    }
}

- (void)saveRequest:(NSString*)address
{
}



@end
