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

#import "GYAddressCountryViewController.h"
#import  <FMDB/FMDatabase.h>
#import "GYAddressCountryModel.h"
#import "GYAreaHttpTool.h"
#import <GYKit/GYPinYinConvertTool.h>
#import "GYProvinceViewController.h"
#import <MJExtension/MJExtension.h>

static NSString* const GYTableViewCellID = @"GYAddressCountryViewController";

@interface GYAddressCountryViewController ()
@property (nonatomic, strong) NSMutableArray* marrSourceData;

@end

@implementation GYAddressCountryViewController {

    NSString* locatinString;
}

#pragma mark - 懒加载
- (NSMutableArray*)marrSourceData
{
    if (_marrSourceData == nil) {
        _marrSourceData = [[NSMutableArray alloc] init];
    }
    return _marrSourceData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(kDefaultMarginToBounds, 0, 0, 0);
    self.tableView.backgroundColor = kDefaultVCBackgroundColor;
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = view;
    
    [self getAddressCountry];
    
    @weakify(self);
    self.addressBlock = ^(GYCityAddressModel* model) {
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(sendAddress:)]) {
            [self.delegate sendAddress:model];
        }
    };
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.title.length == 0) {
        self.title = kLocalized(@"HS_ChooseArea");
    }
}

- (void)getAddressCountry
{
    @weakify(self);
    
    [GYAreaHttpTool getQueryCountry:^(id responsObject) {
        @strongify(self);
        for (GYAddressCountryModel* model in responsObject) {
            DDLogCError(@"%@%@", globalData.loginModel.countryCode, model.countryCode);
            if ([model.countryNo isEqualToString:globalData.loginModel.countryCode]) {
            
                [self.marrSourceData addObject:model];
            }
        }
        [self.tableView reloadData];
        
    }
        failure:^{
            DDLogCError(@"同步国家地区到本地失败");
            
        }];
}

#pragma mark DataSourceDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if (self.hasSelectedArea) {
        return 2;
    } else {
    
        return 1;
    }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (self.hasSelectedArea) {
        switch (section) {
        case 0:
            rows = 1;
            break;
        case 1:
            rows = self.marrSourceData.count;
        }
    } else {
    
        rows = self.marrSourceData.count;
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44.0f;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return kDefaultMarginToBounds;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    label.backgroundColor = kDefaultVCBackgroundColor;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = kGray333333;
    label.textAlignment = NSTextAlignmentLeft;
    
    if (self.hasSelectedArea) {
        switch (section) {
        case 0:
            label.text = @"  已选地区";
            break;
        case 1:
            label.text = @"  全部地区";
            break;
        }
    } else {
        label.text = @"  全部地区";
    }
    return label;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:GYTableViewCellID];
    if (cell == nil) {
    
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GYTableViewCellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.accessoryView = nil;
    cell.userInteractionEnabled = YES;
    if (self.hasSelectedArea) {
    
        switch (indexPath.section) {
        case 0: {
            cell.textLabel.text = self.strSelectedArea;
            UILabel* lbSelect = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
            lbSelect.font = [UIFont systemFontOfSize:15.0];
            lbSelect.text = @"已选地区";
            lbSelect.backgroundColor = [UIColor clearColor];
            cell.accessoryView = lbSelect;
            cell.userInteractionEnabled = NO;
            
        } break;
        case 1: {
            GYAddressCountryModel* model = self.marrSourceData[indexPath.row];
            cell.textLabel.text = model.countryName;
            
        } break;
        }
    } else {
        GYAddressCountryModel* model = self.marrSourceData[indexPath.row];
        cell.textLabel.text = model.countryName;
    }
    cell.textLabel.font = kCellTitleFont;
    cell.textLabel.textColor = kGray333333;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor whiteColor];
    cell.accessoryView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GYAddressCountryModel* model = self.marrSourceData[indexPath.row];
    GYProvinceViewController* nextVC = [[GYProvinceViewController alloc] init];
    nextVC.model = model;
    [self.navigationController pushViewController:nextVC animated:YES];
    
}




@end
