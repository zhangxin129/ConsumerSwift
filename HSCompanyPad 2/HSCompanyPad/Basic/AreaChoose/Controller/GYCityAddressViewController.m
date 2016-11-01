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
#import "GYAreaHttpTool.h"
#import <MJExtension/MJExtension.h>
#import "GYAddressCountryModel.h"
#import "GYProvinceViewController.h"
#import "GYAddressCountryViewController.h"
#import  <FMDB/FMDatabase.h>
static NSString* const GYTableViewCellID = @"GYCityAddressViewController";

@interface GYCityAddressViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray* marrSourceData;
@property (nonatomic, strong) UITableView* tableView;
@end

@implementation GYCityAddressViewController {
    
    FMDatabase* dataBase;
}

#pragma mark - 懒加载
- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
    }
    return _tableView;
}

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
    
    self.title = kLocalized(@"HS_ChooseArea");
    [self getAddressCity];
    
    //帮列表添加一个尾视图，去除线条。
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = view;
    [self.view addSubview:self.tableView];
}

- (void)getAddressCity
{
    @weakify(self);
    
    [GYAreaHttpTool getQueryCityWithCountryNo:self.model.countryNo provinceNo:self.model.provinceNo success:^(id responsObject) {
        @strongify(self);
        
        self.marrSourceData  = (NSMutableArray *)responsObject;
        [self.tableView reloadData];
        
    } failure:^{
            DDLogCError(@"同步城市地区到本地失败");
    }];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.marrSourceData.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44.0f;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return kDefaultMarginToBounds;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:GYTableViewCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GYTableViewCellID];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = kGray333333;
    cell.textLabel.font = kCellTitleFont;
    GYCityAddressModel* model = self.marrSourceData[indexPath.row];
    cell.textLabel.text = model.cityName;
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GYCityAddressModel* model = self.marrSourceData[indexPath.row];
    
    if (self.type == GYCityAddressViewControllerClickBack && [self.delegate respondsToSelector:@selector(cityAddressViewController:didSelectedWithModel:)]) {
        [self.delegate cityAddressViewController:self didSelectedWithModel:model];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    UIViewController* popVC = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 4];
    
    GYAddressCountryViewController* backVC = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3];
    if (backVC.addressBlock) {
        backVC.addressBlock(model);
    }
    
    [self.navigationController popToViewController:popVC animated:YES];
    
    
}



@end
