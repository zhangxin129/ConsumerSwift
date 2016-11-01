//
//  GYHDAttentionCitySearchViewController.m
//  HSConsumer
//
//  Created by shiang on 16/3/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDAttentionCitySearchViewController.h"
#import "GYHDMessageCenter.h"
//#import "GYFMDBCityManager.h"
#import "GYAddressData.h"
#import "GYHDCityGroupModel.h"
#import "GYPinYinConvertTool.h"
#import "GYHDAttentionCompanySearchListViewController.h"
#import "MJExtension.h"

@interface GYHDAttentionCitySearchViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITextField* searchTextField;
/**地址表*/
@property (nonatomic, weak) UITableView* addressTableView;
/**地址数组*/
@property (nonatomic, strong) NSArray* addressArray;
@end

@implementation GYHDAttentionCitySearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView* headView = [[UIView alloc] init];
    headView.frame = CGRectMake(0, 0, kScreenWidth, 400);
    headView.backgroundColor = [UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];
    // 搜索框

    UITableView* addressTableView = [[UITableView alloc] init];
    [addressTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"addressCellID"];
    addressTableView.tableHeaderView = headView;
    addressTableView.delegate = self;
    addressTableView.dataSource = self;
    [self.view addSubview:addressTableView];
    _addressTableView = addressTableView;
    //搜索
    UIView* leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0, 0, 30, 30);
    UIImageView* leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhd_search_bar_left_icon"]];
    [leftView addSubview:leftImageView];
    [leftImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.center.equalTo(leftView);
    }];
    UIButton* rightSearchButton = [[UIButton alloc] init];
    [rightSearchButton setBackgroundImage:[UIImage imageNamed:@"gyhd_search_bar_right_icon"] forState:UIControlStateNormal];
    [rightSearchButton addTarget:self action:@selector(rightSearchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    rightSearchButton.frame = CGRectMake(0, 0, 30, 30);
    UITextField* searchTextField = [[UITextField alloc] init];
    ;
    searchTextField.background = [UIImage imageNamed:@"gyhd_search_bar_bg"];
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    searchTextField.leftView = leftView;
    //    searchTextField.returnKeyType = UIReturnKeySearch;
    searchTextField.placeholder = [GYUtils localizedStringWithKey:@"GYHD_Friend_input_city"];
    //    searchTextField.delegate = self;
    searchTextField.rightViewMode = UITextFieldViewModeAlways;
    searchTextField.rightView = rightSearchButton;
    [headView addSubview:searchTextField];
    [searchTextField addTarget:self action:@selector(searchAddress) forControlEvents:UIControlEventEditingChanged];
    _searchTextField = searchTextField;
    // 定位城市
    UILabel* GPSCityLabel = [[UILabel alloc] init];
    GPSCityLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    GPSCityLabel.textColor = [UIColor colorWithRed:100 / 255.0f green:100 / 255.0f blue:100 / 255.0f alpha:1];
    GPSCityLabel.text = [GYUtils localizedStringWithKey:@"GYHD_Friend_GPS_city"];
    [headView addSubview:GPSCityLabel];

    UIView* GPSlineView = [[UIView alloc] init];
    GPSlineView.backgroundColor = [UIColor colorWithRed:206 / 255.0f green:206 / 255.0f blue:206 / 255.0f alpha:1];
    [headView addSubview:GPSlineView];

    UIButton* GPSCityButton = [self buttonWithTitle:globalData.selectedCityName];
    [headView addSubview:GPSCityButton];
    // 热门城市
    UILabel* hotCitylabel = [[UILabel alloc] init];
    hotCitylabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    hotCitylabel.textColor = [UIColor colorWithRed:100 / 255.0f green:100 / 255.0f blue:100 / 255.0f alpha:1];
    hotCitylabel.text = [GYUtils localizedStringWithKey:@"GYHD_Company_hot_city"];
    [headView addSubview:hotCitylabel];

    UIView* hotCitylineView = [[UIView alloc] init];
    hotCitylineView.backgroundColor = [UIColor colorWithRed:206 / 255.0f green:206 / 255.0f blue:206 / 255.0f alpha:1];
    [headView addSubview:hotCitylineView];

    // 热门城市
    UILabel* allCitylabel = [[UILabel alloc] init];
    allCitylabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    allCitylabel.textColor = [UIColor colorWithRed:100 / 255.0f green:100 / 255.0f blue:100 / 255.0f alpha:1];
    allCitylabel.text = [GYUtils localizedStringWithKey:@"GYHD_Company_all_city"];
    [headView addSubview:allCitylabel];

    UIView* allCitylineView = [[UIView alloc] init];
    allCitylineView.backgroundColor = [UIColor colorWithRed:206 / 255.0f green:206 / 255.0f blue:206 / 255.0f alpha:1];
    [headView addSubview:allCitylineView];

    NSArray* hotCites = [ [GYUtils localizedStringWithKey:@"GYHD_Popular_cities"] componentsSeparatedByString:@"|"];
    UIButton* beijingButton = [self buttonWithTitle:hotCites[0]];
    [headView addSubview:beijingButton];
    UIButton* shanghaiButton = [self buttonWithTitle:hotCites[1]];
    [headView addSubview:shanghaiButton];
    UIButton* guangzhouButton = [self buttonWithTitle:hotCites[2]];
    [headView addSubview:guangzhouButton];
    UIButton* xianButton = [self buttonWithTitle:hotCites[3]];
    [headView addSubview:xianButton];
    UIButton* xiamenButton = [self buttonWithTitle:hotCites[4]];
    [headView addSubview:xiamenButton];
    UIButton* shenzhenButton = [self buttonWithTitle:hotCites[5]];
    [headView addSubview:shenzhenButton];
    UIButton* tianjinButton = [self buttonWithTitle:hotCites[6]];
    [headView addSubview:tianjinButton];
    UIButton* wuhanButton = [self buttonWithTitle:hotCites[7]];
    [headView addSubview:wuhanButton];
    UIButton* changshaButton = [self buttonWithTitle:hotCites[8]];
    [headView addSubview:changshaButton];
    // 全部城市
    [addressTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];

    [searchTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(46);
        make.height.mas_equalTo(35);
    }];
    [GPSCityLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(searchTextField.mas_bottom).offset(30);
        make.left.equalTo(searchTextField);
    }];
    [GPSlineView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(GPSCityLabel);
        make.left.lessThanOrEqualTo(GPSCityLabel.mas_right).offset(1);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(0.5);
    }];
    [GPSCityButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(GPSCityLabel.mas_bottom).offset(2);
        make.left.equalTo(GPSCityLabel);
        make.size.mas_equalTo(CGSizeMake(100, 35));
    }];

    [hotCitylabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(GPSCityButton.mas_bottom).offset(10);
        make.left.equalTo(GPSCityButton);
    }];
    [hotCitylineView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(hotCitylabel);
        make.left.lessThanOrEqualTo(hotCitylabel.mas_right).offset(1);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(0.5);
    }];
    CGFloat buttonW = (kScreenWidth / 3) - 30;
    [beijingButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(hotCitylabel.mas_bottom).offset(1);
        make.left.equalTo(hotCitylabel);
        make.size.mas_equalTo(CGSizeMake(buttonW, 35));
    }];

    [shanghaiButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.width.height.equalTo(beijingButton);
        make.left.equalTo(beijingButton.mas_right).offset(15);
    }];
    [guangzhouButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.width.height.equalTo(beijingButton);
        make.left.equalTo(shanghaiButton.mas_right).offset(15);
    }];

    [xianButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(beijingButton.mas_bottom).offset(15);
        make.left.equalTo(beijingButton);
        make.size.mas_equalTo(CGSizeMake(buttonW, 35));
    }];

    [xiamenButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.width.height.equalTo(xianButton);
        make.left.equalTo(xianButton.mas_right).offset(15);
    }];
    [shenzhenButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.width.height.equalTo(xianButton);
        make.left.equalTo(xiamenButton.mas_right).offset(15);
    }];

    [tianjinButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(xianButton.mas_bottom).offset(15);
        make.left.equalTo(xianButton);
        make.size.mas_equalTo(CGSizeMake(buttonW, 35));
    }];

    [wuhanButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.width.height.equalTo(tianjinButton);
        make.left.equalTo(tianjinButton.mas_right).offset(15);
    }];
    [changshaButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.width.height.equalTo(tianjinButton);
        make.left.equalTo(wuhanButton.mas_right).offset(15);
    }];

    [allCitylabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.lessThanOrEqualTo(tianjinButton.mas_bottom).offset(1);
        make.left.equalTo(searchTextField);
    }];
    [allCitylineView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(allCitylabel);
        make.left.lessThanOrEqualTo(allCitylabel.mas_right).offset(1);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(0.5);
    }];
    [self loadAddressWithCityName:@""];
}

- (void)searchAddress
{
    static NSString* string = @"-1";
    if (![string isEqualToString:self.searchTextField.text]) {
        [self loadAddressWithCityName:self.searchTextField.text];
        [self.addressTableView reloadData];
    }
    string = self.searchTextField.text;
}

- (void)loadAddressWithCityName:(NSString*)cityName
{
    //    GYFMDBCityManager *city = [GYFMDBCityManager shareInstance];
    ////    NSMutableArray *array = [city selectFromDB];
    //    NSMutableArray *array = [city selectAddressWithString:cityName];
    NSMutableArray* array = nil;
    if ([cityName isEqualToString:@""]) {
        array = [[GYAddressData shareInstance] selectAllCitys];
        ;
    }
    else {
        array = [[GYAddressData shareInstance] selectAddressWithString:cityName];
    }

    NSArray* ABCArray = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#", nil];
    NSMutableArray* cityGroupArray = [NSMutableArray array];
    for (NSString* key in ABCArray) {
        GYHDCityGroupModel* cityGroupModel = [[GYHDCityGroupModel alloc] init];

        for (GYCityAddressModel* model in array) {

            //1. 转字母
            //            NSString *tempStr = dict[@"cityName"];
            NSString* tempStr = model.cityName;
            if (!tempStr || tempStr.length == 0) {
                tempStr = @"未设置名称";
            }
            if (tempStr) {
                tempStr = [[tempStr substringToIndex:1] uppercaseString];
            }
            if ([GYUtils isIncludeChineseInString:tempStr]) {
                tempStr = [GYPinYinConvertTool chineseConvertToPinYinHead:tempStr];
            }
            //2. 获取首字母
            NSString* firstLetter;
            if (tempStr.length >= 1) {
                firstLetter = [[tempStr substringToIndex:1] uppercaseString];
            }
            if (![ABCArray containsObject:firstLetter]) {
                tempStr = [@"#" stringByAppendingString:tempStr];
                firstLetter = [[tempStr substringToIndex:1] uppercaseString];
            }

            //3. 加入数组
            if ([firstLetter isEqualToString:key]) {

                cityGroupModel.cityTitle = key;
                GYHDCityModel* cityModel = [[GYHDCityModel alloc] initWithDictionary:model.mj_keyValues];
                [cityGroupModel.cityGroupArray addObject:cityModel];
            }
        }
        if (cityGroupModel.cityTitle && cityGroupModel.cityGroupArray.count > 0) {
            [cityGroupArray addObject:cityGroupModel];
        }
    }
    self.addressArray = cityGroupArray;
}

- (UIButton*)buttonWithTitle:(NSString*)title
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitleColor:[UIColor colorWithRed:115 / 255.0f green:115 / 255.0f blue:115 / 255.0f alpha:115 / 255.0f] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

- (void)rightSearchButtonClick:(UIButton*)button
{
    self.searchTextField.text = nil;
}

- (void)buttonClick:(UIButton*)button
{
    [self searchWithCity:button.currentTitle];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.addressArray.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    GYHDCityGroupModel* cityGroupModel = self.addressArray[section];
    return cityGroupModel.cityGroupArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHDCityGroupModel* cityGroupModel = self.addressArray[indexPath.section];
    GYHDCityModel* cityModel = cityGroupModel.cityGroupArray[indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"addressCellID"];

    cell.textLabel.text = cityModel.cityName;
    return cell;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    GYHDCityGroupModel* cityGroupModel = self.addressArray[section];
    return cityGroupModel.cityTitle;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHDCityGroupModel* cityGroupModel = self.addressArray[indexPath.section];
    GYHDCityModel* cityModel = cityGroupModel.cityGroupArray[indexPath.row];
    [self searchWithCity:cityModel.cityName];
}

- (void)searchWithCity:(NSString*)city
{
    GYHDAttentionCompanySearchListViewController* searchListViewController = [[GYHDAttentionCompanySearchListViewController alloc] init];
    searchListViewController.searchCity = city;
    [self.navigationController pushViewController:searchListViewController animated:YES];
}
@end
