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

#import "GYHSProvinceViewController.h"
#import "GYHSCityAddressViewController.h"
#import "FMDB.h"
#import "GYProvinceModel.h"
#import "GYCityAddressModel.h"
#import "GYAddressData.h"
#import "GYHSTools.h"

@interface GYHSProvinceViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) UITableView* tableView;

@end

@implementation GYHSProvinceViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.marrSourceData.count == 0) {
        [self loadData];
    }
}

- (void)loadData //返回网络请求数据
{

    GYAddressData* address = [GYAddressData shareInstance];

    [address receiveProvinceInfoBlock:^(NSArray* array) {
        self.marrSourceData = [NSMutableArray arrayWithArray:array];
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = kLocalized(@"GYHS_Address_Navigation_SelectProvince");

    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.backgroundColor = kDefaultVCBackgroundColor;
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 44.f;
}

#pragma mark DataSourceDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if (self.type == provinceTypePop) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == provinceTypePop) {
        return self.marrSourceData.count;
    }
    NSInteger rows;
    switch (section) {
    case 0:
        rows = 1;
        break;
    case 1: {
        rows = self.marrSourceData.count;
    }
    default:
        break;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.type == provinceTypePop) {
        return 15;
    }

    CGFloat sectionHeight;
    sectionHeight = 30;
    switch (section) {
    case 2:
        sectionHeight = 0;
        break;

    default:
        break;
    }

    return sectionHeight;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    static NSString* cellIdentifer = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }

    if (self.type == provinceTypePop) {
        GYProvinceModel* MOD = nil;
        if (self.marrSourceData.count > indexPath.row) {
            MOD = self.marrSourceData[indexPath.row];
        }

        cell.textLabel.text = MOD.provinceName;
        cell.accessoryView = nil;
        return cell;
    }

    switch (indexPath.section) {
    case 0: {
        cell.textLabel.text = self.mstrCountry;
        UILabel* lbSelect = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        lbSelect.font = kAreaChooseFont;
        lbSelect.text = kLocalized(@"GYHS_Address_Universally_PositioningSelect");
        cell.accessoryView = lbSelect;

    } break;
    case 1: {
        GYProvinceModel* MOD = nil;
        if (self.marrSourceData.count > indexPath.row) {
            MOD = self.marrSourceData[indexPath.row];
        }
        cell.textLabel.text = MOD.provinceName;
        cell.accessoryView = nil;

    } break;
    default:
        break;
    }

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.type == provinceTypePop) {
        GYHSCityAddressViewController* vcCity = [[GYHSCityAddressViewController alloc] init];
        GYProvinceModel* MOD = nil;
        if (self.marrSourceData.count > indexPath.row) {
            MOD = self.marrSourceData[indexPath.row];
        }

        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:MOD.provinceName forKey:@"province"];
        [defaults synchronize];

        vcCity.areaIdString = MOD.provinceNo;
        vcCity.areaIdcounyry = self.areaId;
        vcCity.mstrCountryAndProvince = [[NSString stringWithFormat:@"%@ %@", self.mstrCountry, MOD.provinceName] mutableCopy];

        if (self.delegate && [self.delegate respondsToSelector:@selector(returnPopPvovince:)]) {
            [self.delegate returnPopPvovince:MOD];
        }

        [self.navigationController popViewControllerAnimated:YES];
    }

    switch (indexPath.section) {
    case 1: {
        if (_fromWhere == 1) {
            GYChooseAreaModel* MOD = nil;
            if (self.marrSourceData.count > indexPath.row) {
                MOD = self.marrSourceData[indexPath.row];
            }
            if (_delegate && [_delegate respondsToSelector:@selector(didSelectProvince:)]) {
                [_delegate didSelectProvince:MOD];
            }
        }
        else {

            GYHSCityAddressViewController* vcCity = [[GYHSCityAddressViewController alloc] init];
            GYProvinceModel* MOD = nil;
            if (self.marrSourceData.count > indexPath.row) {
                MOD = self.marrSourceData[indexPath.row];
            }

            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:MOD.provinceName forKey:@"province"];
            [defaults synchronize];

            vcCity.areaIdString = MOD.provinceNo;
            vcCity.areaIdcounyry = self.areaId;
            vcCity.mstrCountryAndProvince = [[NSString stringWithFormat:@"%@ %@", self.mstrCountry, MOD.provinceName] mutableCopy];
            [self.navigationController pushViewController:vcCity animated:YES];
        }

    }
    break;

    default:
        break;
    }
}

@end
