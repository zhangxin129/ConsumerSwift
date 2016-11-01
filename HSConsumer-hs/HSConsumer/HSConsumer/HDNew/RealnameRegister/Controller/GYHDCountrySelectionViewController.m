//
//  GYHDCountrySelectionViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/18.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDCountrySelectionViewController.h"
#import "Masonry.h"
#import "GYAddressData.h"
#import "YYKit.h"
#import "GYHSLabelTwoTableViewCell.h"
#import "GYHSTools.h"
#import "GYHDCountryHeaderView.h"

@interface GYHDCountrySelectionViewController ()
@property (nonatomic,strong) UITableView *countryUITableView;

@property (nonatomic,strong)GYHDCountryHeaderView *headerView;
@end

@implementation GYHDCountrySelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.countryUITableView];
    self.title = kLocalized(@"GYHS_RealName_Select_Nationality");
    self.marrSourceData = [[GYAddressData shareInstance] selectAllCountrys];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.marrSourceData];
    for ( GYAddressCountryModel * model  in array) {
        if ([model.countryNo isEqualToString:@"156"]) {
            NSInteger index = [self.marrSourceData indexOfObject:model];
            [self.marrSourceData exchangeObjectAtIndex:0 withObjectAtIndex:index];
            
        }
    }
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
    GYAddressCountryModel* model  = nil;
    if (self.marrSourceData.count > indexPath.row) {
            model  = self.marrSourceData[indexPath.row];
    }
    cell.textLabel.text = model.countryName;
    cell.textLabel.textColor =kcurrencyBalanceCorlor;
    cell.accessoryView = nil;
    return cell;
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
   UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
   view.backgroundColor = kDefaultVCBackgroundColor;
    self.headerView.countryLb.text = self.countryName;
    if (section == 0) {
        return self.headerView;
    }
    return view;
}
//组头高度
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section  == 0) {
        return 165.0f;
    }
    return .1f;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GYAddressCountryModel* model = nil;
    if (self.marrSourceData.count > indexPath.row) {
        model = self.marrSourceData[indexPath.row];
    }
    
    if (_Delegate && [_Delegate respondsToSelector:@selector(selectNationalityModel:)]) {
        [_Delegate selectNationalityModel:model];
        self.countryName = model.countryName;
        [self.countryUITableView reloadData];
    }
}
#pragma mark -- Lazy loading
-(UITableView*)countryUITableView
{
    if (!_countryUITableView) {
        _countryUITableView = [[UITableView alloc] init];
        _countryUITableView.dataSource = self;
        _countryUITableView.delegate = self;
        
        [self.view addSubview:_countryUITableView];
     
        [_countryUITableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
    }
    return _countryUITableView;
}
-(GYHDCountryHeaderView*)headerView
{
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHDCountryHeaderView class]) owner:self options:nil].lastObject;
        _headerView.frame = CGRectMake(0, 0, self.countryUITableView.frame.size.width, 165);
        
    }
    return _headerView;
}
@end
