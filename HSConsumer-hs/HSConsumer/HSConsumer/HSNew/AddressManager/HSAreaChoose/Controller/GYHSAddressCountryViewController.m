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

#import "GYHSAddressCountryViewController.h"
#import "GYHSProvinceViewController.h"
#import "FMDatabase.h"
#import "GYPinYinConvertTool.h"
#import "GYLocationManager.h"
#import "GYAddressCountryModel.h"
#import "GYAddressData.h"
#import "GYSaveLocationTool.h"
#import "GYHSTools.h"

@interface GYHSAddressCountryViewController ()
@property (nonatomic, strong) UITableView* tvCountry;
@end

@implementation GYHSAddressCountryViewController {

    FMDatabase* dataBase;
    NSString* locatinString;
}
//懒加载
- (UITableView*)tvCountry
{
    if (_tvCountry == nil) {
        _tvCountry = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:(UITableViewStyleGrouped)];
        _tvCountry.dataSource = self;
        _tvCountry.delegate = self;
    }
    return _tvCountry;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.marrSourceData count] <= 0) {
        [self loadData];
    }
}

- (void)loadData
{

    [[GYAddressData shareInstance] netRequestForCountrys:^{
        [self.marrSourceData removeAllObjects];
        self.marrSourceData = [[GYAddressData shareInstance] selectLocalCountry];
        [self.tvCountry reloadData];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.marrSourceData = [[GYAddressData shareInstance] selectLocalCountry];
    [self.view addSubview:self.tvCountry];

    self.tvCountry.tableFooterView = [[UIView alloc] init];
    switch (self.addressType) {
    case noLocationfunction: {

    } break;
    case locationFunction: {
        [[GYLocationManager sharedInstance] reverseAdress:^(NSString* cityName, NSString* address) {
            locatinString = cityName;
        }];
    } break;

    default:
        break;
    }
}

#pragma mark DataSourceDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{

    switch (self.addressType) {
    case noLocationfunction: {
        return 2;

    } break;
    case locationFunction: {
        return 3;

    } break;
    default:
        break;
    }
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView* headerView;
    switch (self.addressType) {
    case noLocationfunction: {

    } break;

    case locationFunction: {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        headerView.backgroundColor = kDefaultVCBackgroundColor;

        UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 15, 30)];
        NSString* titleString;
        switch (section) {
        case 0:
            titleString = kLocalized(@"GYHS_Address_Universally_PositioningNow");
            break;
        case 1:
            titleString = kLocalized(@"GYHS_Address_Universally_AllAreas");
            break;
        default:
            break;
        }
        lbTitle.text = titleString;
        [headerView addSubview:lbTitle];

        //            return headerView;

    } break;
    default:
        break;
    }

    return headerView;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{

    switch (self.addressType) {
    case noLocationfunction: {
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

    } break;

    case locationFunction: {
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

    } break;
    default:
        break;
    }

    return 0;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows;

    switch (self.addressType) {
    case noLocationfunction: {
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

    } break;
    case locationFunction: {

        switch (section) {
        case 0:
            rows = 1;
            break;
        case 1:
            rows = 1;
            break;
        case 2:
            rows = self.marrSourceData.count;
            break;
        default:
            break;
        }
    } break;
    default:
        break;
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

    switch (self.addressType) {
    case noLocationfunction: {
        switch (indexPath.section) {
        case 0: {
            cell.textLabel.text = self.strSelectedArea;
            UILabel* lbSelect = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
            lbSelect.font = kAreaChooseFont;
            lbSelect.text = kLocalized(@"GYHS_Address_Universally_PositioningSelect");
            cell.accessoryView = lbSelect;

        } break;
        case 1: {
            GYAddressCountryModel* MOD = nil;
            if (self.marrSourceData.count > indexPath.row) {
                MOD = self.marrSourceData[indexPath.row];
            }
            cell.textLabel.text = MOD.countryName;
            cell.accessoryView = nil;

        } break;
        default:
            break;
        }

    } break;
    case locationFunction: {
        switch (indexPath.section) {
        case 0:
            cell.textLabel.text = locatinString;
            break;
        case 1: {
            cell.textLabel.text = self.strSelectedArea;
            UILabel* lbSelect = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
            lbSelect.font = kAreaChooseFont;
            lbSelect.text = kLocalized(@"GYHS_Address_Universally_PositioningSelect");
            cell.accessoryView = lbSelect;

        }

        break;
        case 2: {
            GYChooseAreaModel* MOD = nil;
            if (self.marrSourceData.count > indexPath.row) {
                MOD = self.marrSourceData[indexPath.row];
            }
            cell.textLabel.text = MOD.areaName;
            cell.accessoryView = nil;
        } break;
        default:
            break;
        }
    }
    default:
        break;
    }

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (self.addressType) {
    case noLocationfunction: {

        switch (indexPath.section) {
        case 1: {
            GYAddressCountryModel* MOD = nil;
            if (self.marrSourceData.count > indexPath.row) {
                MOD = self.marrSourceData[indexPath.row];
            }
            GYHSProvinceViewController* vcProvince = [[GYHSProvinceViewController alloc] init];
            vcProvince.mstrCountry = [MOD.countryName mutableCopy];

            vcProvince.areaId = MOD.countryNo;

            [self.navigationController pushViewController:vcProvince animated:YES];

        } break;

        default:
            break;
        }

    } break;
    case locationFunction: {
        switch (indexPath.section) {

        case 0: {

            [self saveRequest:locatinString];

        } break;
        case 2: {
            GYChooseAreaModel* MOD = nil;
            if (self.marrSourceData .count > indexPath.row) {
                MOD = self.marrSourceData[indexPath.row];
            }
            GYHSProvinceViewController* vcProvince = [[GYHSProvinceViewController alloc] init];
            vcProvince.mstrCountry = [MOD.areaName mutableCopy];

            vcProvince.areaId = MOD.areaId;
            [self.navigationController pushViewController:vcProvince animated:YES];

        } break;

        default:
            break;
        }
    }
    default:
        break;
    }
}

//发起网络请求保存地址
- (void)saveRequest:(NSString*)address
{
    [GYSaveLocationTool saveRequest:address result:^(BOOL result) {

        if (result) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getAddress" object:address userInfo:nil];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:kLocalized(@"GYHS_Address_Universally_UpdataSuccess") delegate:self cancelButtonTitle:kLocalized(@"GYHS_Address_Confirm") otherButtonTitles:nil, nil];
            [av show];
        } else {

            UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:kLocalized(@"GYHS_Address_Universally_UpdataError")  delegate:self cancelButtonTitle:kLocalized(@"GYHS_Address_Confirm") otherButtonTitles:nil, nil];
            [av show];
        }
    }];
}

@end
