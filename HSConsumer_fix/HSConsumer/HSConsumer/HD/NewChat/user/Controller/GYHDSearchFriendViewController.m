//
//  GYHDSearchFriendViewController.m
//  HSConsumer
//
//  Created by shiang on 16/3/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSearchFriendViewController.h"
#import "GYHDSearchFriendModel.h"
#import "GYHDPopView.h"
#import "GYHDSearchAgeView.h"
#import "GYHDMessageCenter.h"
#import "GYHDChooseAddressViewController.h"
#import "GYHDAddFriendViewController.h"
#import "GYHDAddressView.h"
//#import "GYFMDBCityManager.h"
#import "GYAddressData.h"

@interface GYHDSearchFriendViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
/**搜索好友视图*/
@property (nonatomic, weak) UITableView* searchFriendTableView;
/**搜索好友数组*/
@property (nonatomic, strong) NSMutableArray* searchFriendArray;
/***/
@property (nonatomic, weak) UITextField* searchTextField;
/**选择城市*/
@property (nonatomic, copy) NSString* searchAddress;

@property (nonatomic, strong) GYCityAddressModel* cityModel;
@end

@implementation GYHDSearchFriendViewController

- (NSMutableArray*)searchFriendArray
{
    if (!_searchFriendArray) {
        _searchFriendArray = [[NSMutableArray alloc] init];
        GYHDSearchFriendModel* sexModel = [[GYHDSearchFriendModel alloc] init];
        sexModel.searchTips = [GYUtils localizedStringWithKey:@"GYHD_sex"];
        sexModel.tipkeyString = @"sex";
        sexModel.searchResults = [GYUtils localizedStringWithKey:@"GYHD_any"];

        GYHDSearchFriendModel* ageModel = [[GYHDSearchFriendModel alloc] init];
        ageModel.searchTips = [GYUtils localizedStringWithKey:@"GYHD_age"];
        ageModel.tipkeyString = @"age";
        ageModel.searchResults = [GYUtils localizedStringWithKey:@"GYHD_any"];

        GYHDSearchFriendModel* addressModel = [[GYHDSearchFriendModel alloc] init];
        addressModel.searchTips = [GYUtils localizedStringWithKey:@"GYHD_address"];
        addressModel.tipkeyString = @"address";
        addressModel.searchResults = [GYUtils localizedStringWithKey:@"GYHD_any"];
        [_searchFriendArray addObjectsFromArray:@[ sexModel, ageModel, addressModel ]];
    }
    return _searchFriendArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];

        UIButton *backtrackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backtrackButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [backtrackButton setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1] forState:UIControlStateNormal];
        backtrackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        backtrackButton.frame = CGRectMake(0, 0, 80, 44);
        [backtrackButton setImage:kLoadPng(@"gyhd_nav_leftView_back") forState:UIControlStateNormal];
        [backtrackButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_add"] forState:UIControlStateNormal];
        backtrackButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backtrackButton];
    self.title = [GYUtils localizedStringWithKey:@"GYHD_user_addfriend"];

    //搜索输入框
    UIView* leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0, 0, 60, 40);
    UIImageView* leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhd_search_bar_left_icon"]];
    [leftView addSubview:leftImageView];
    [leftImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.center.equalTo(leftView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    UIButton* rightSearchButton = [[UIButton alloc] init];
    [rightSearchButton setBackgroundImage:[UIImage imageNamed:@"gyhd_search_bar_right_icon"] forState:UIControlStateNormal];
    [rightSearchButton addTarget:self action:@selector(rightSearchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    rightSearchButton.frame = CGRectMake(0, 0, 30, 30);
    UITextField* searchTextField = [[UITextField alloc] init];
    searchTextField.background = [UIImage imageNamed:@"gyhd_search_bar_bg"];
    searchTextField.placeholder = [GYUtils localizedStringWithKey:@"GYHD_searchHusheng"];
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    searchTextField.leftView = leftView;
    searchTextField.delegate = self;
    searchTextField.rightViewMode = UITextFieldViewModeAlways;
    //    searchTextField.rightView = rightSearchButton;
    [self.view addSubview:searchTextField];
    _searchTextField = searchTextField;
    [searchTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(-10);
        make.right.mas_equalTo(10);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(40);

    }];

    //搜索表
    UITableView* selectAddTableView = [[UITableView alloc] init];
    selectAddTableView.backgroundColor = [UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];
    selectAddTableView.scrollEnabled = NO;
    [selectAddTableView setSeparatorColor:[UIColor colorWithRed:235 / 255.0f green:235 / 255.0f blue:235 / 255.0f alpha:1]];
    [self.view addSubview:selectAddTableView];
    _searchFriendTableView = selectAddTableView;
    [selectAddTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(searchTextField.mas_bottom).offset(20);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    selectAddTableView.dataSource = self;
    selectAddTableView.delegate = self;
}


- (void)backClick:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
    //    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightSearchButtonClick:(UIButton*)button
{
    self.searchTextField.text = nil;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchFriendArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHDSearchFriendModel* searchModel = self.searchFriendArray[indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"formCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"formCell"];
    }
    cell.textLabel.text = searchModel.searchTips;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = searchModel.searchResults;
    return cell;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{

    UIView* returnView = [[UIView alloc] init];
    UIButton* searchButton = [[UIButton alloc] init];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"gyhd_text_field_send_icom"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    searchButton.frame = CGRectMake(10, 10, kScreenWidth - 20, 40);
    [searchButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_search"] forState:UIControlStateNormal];
    [returnView addSubview:searchButton];
    return returnView;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHDSearchFriendModel* mode = self.searchFriendArray[indexPath.row];
    WS(weakSelf);
    switch (indexPath.row) {
    case 0: {

        NSArray* array = [ [GYUtils localizedStringWithKey:@"GYHD_choose_sex"] componentsSeparatedByString:@"|"];

        GYHDSearchAgeView* ageView = [[GYHDSearchAgeView alloc] init];
        ageView.chooseAgeArray = array;
        ageView.chooseTips = mode.searchTips;
        [ageView mas_makeConstraints:^(MASConstraintMaker* make) {
                make.size.mas_equalTo(CGSizeMake(270, 229));
        }];

        GYHDPopView* popView = [[GYHDPopView alloc] initWithChlidView:ageView];

        [popView showToView:self.navigationController.view];
        ageView.block = ^(NSString* chooseString) {
            mode.searchResults = chooseString;
            [weakSelf.searchFriendTableView reloadData];
            [popView disMiss];
        };
        break;
    }
    case 1: {
        NSArray* array = [ [GYUtils localizedStringWithKey:@"GYHD_choose_age"] componentsSeparatedByString:@"|"];
        GYHDSearchAgeView* ageView = [[GYHDSearchAgeView alloc] init];
        ageView.chooseAgeArray = array;
        ageView.chooseTips = mode.searchTips;
        [ageView mas_makeConstraints:^(MASConstraintMaker* make) {
                make.size.mas_equalTo(CGSizeMake(270, 276));
        }];

        GYHDPopView* popView = [[GYHDPopView alloc] initWithChlidView:ageView];

        [popView showToView:self.navigationController.view];
        ageView.block = ^(NSString* chooseString) {
            mode.searchResults = chooseString;
            [weakSelf.searchFriendTableView reloadData];
            [popView disMiss];
        };
        break;
    }
    case 2: {

        GYHDChooseAddressViewController* chooAddressViewController = [[GYHDChooseAddressViewController alloc] init];

        chooAddressViewController.block = ^(NSString* chooseString) {
//            self.cityModel = [[GYFMDBCityManager shareInstance] selectCity:chooseString];
            self.cityModel = [[GYAddressData shareInstance] queryCityNo:chooseString];
            mode.searchResults = self.cityModel.cityFullName;
            [weakSelf.searchFriendTableView reloadData];
        };
        [self presentViewController:chooAddressViewController animated:YES completion:nil];
        //            GYHDAddressView *addressView = [[GYHDAddressView alloc] init];
        //            [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        //                make.size.mas_equalTo(CGSizeMake(270, 276));
        //            }];
        //
        //            GYHDPopView *popView = [[GYHDPopView alloc] initWithChlidView:addressView];
        //            popView.showType = GYHDPopViewShowCenter;
        //            [popView show];
        //            WS(weakSelf);
        //
        //            addressView.block = ^(NSString *cityNo) {
        //
        //                self.cityModel = [[GYFMDBCityManager shareInstance] selectCity:cityNo];
        //                mode.searchResults = self.cityModel.cityFullName;
        //                [weakSelf.searchFriendTableView reloadData];
        //                [popView disMiss];
        //
        //            };
        break;
    }
    default:
        break;
    }
}

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath

{
    
    if([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, -10,0,0)];
        
    }
    
    if([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [tableView setLayoutMargins:UIEdgeInsetsMake(0, -10,0,0)];
        
    }
    
    if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsMake(0, -10,0,0)];
        
    }
    
}


- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}

- (void)searchButtonClick
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"husheng"] = self.searchTextField.text;
    for (GYHDSearchFriendModel* model in self.searchFriendArray) {
        dict[model.tipkeyString] = model.searchResults;
    }
    GYHDAddFriendViewController* addFirendViewController = [[GYHDAddFriendViewController alloc] init];
    dict[@"province"] = self.cityModel.provinceNo;
    dict[@"city"] = self.cityModel.cityNo;
    addFirendViewController.searchDict = dict;
    [self.navigationController pushViewController:addFirendViewController animated:YES];
}

@end
//            GYHDChooseAddressViewController *chooAddressViewController = [[GYHDChooseAddressViewController alloc] init];
//
//
//            chooAddressViewController.block = ^(NSString *chooseString) {
//                mode.searchResults = chooseString;
//                [weakSelf.searchFriendTableView reloadData];
//            };
//            [self presentViewController:chooAddressViewController animated:YES completion:nil];
