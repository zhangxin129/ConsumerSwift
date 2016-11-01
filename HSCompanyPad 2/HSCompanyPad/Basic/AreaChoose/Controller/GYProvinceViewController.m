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

#import "GYProvinceViewController.h"
#import "GYCityAddressViewController.h"
#import "GYAreaHttpTool.h"
#import <MJExtension/MJExtension.h>
#import "GYAddressCountryModel.h"
#import "GYAddressCountryViewController.h"

@interface GYProvinceViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray* marrSourceData;
@property (nonatomic, strong) UITableView* tableView;
@end

@implementation GYProvinceViewController

#pragma mark - 懒加载
- (NSMutableArray*)marrSourceData
{
    if (_marrSourceData == nil) {
        _marrSourceData = [[NSMutableArray alloc] init];
    }
    
    return _marrSourceData;
}

- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    self.title = kLocalized(@"HS_ChooseArea");
    [self getAddressProvince];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
}

- (void)getAddressProvince
{

    @weakify(self);
    [GYAreaHttpTool getQueryProvinceWithCountryNo:self.model.countryNo success:^(id responsObject) {
            @strongify(self);
            self.marrSourceData = responsObject;
            [self.tableView reloadData];
            
    } failure:^{
            DDLogCError(@"同步省份地区到本地失败");
            
    }];
}

#pragma mark DataSourceDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.marrSourceData.count;
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
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = kGray333333;
    cell.textLabel.font = kCellTitleFont;
    GYProvinceModel* model = self.marrSourceData[indexPath.row];
    cell.textLabel.text = model.provinceName;
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GYProvinceModel* model = self.marrSourceData[indexPath.row];
    if (self.type == GYProvinceViewControllerClickBack && [self.delegate respondsToSelector:@selector(provinceViewController:didSelectedWithModel:)]) {
        [self.delegate provinceViewController:self didSelectedWithModel:model];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    GYCityAddressViewController* nextVC = [[GYCityAddressViewController alloc] init];
    nextVC.model = model;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 16.0f;
}




@end
