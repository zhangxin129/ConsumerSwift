//
//  GYHDChooseAddressViewController.m
//  HSConsumer
//
//  Created by shiang on 16/3/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDChooseAddressViewController.h"
#import "GYHDMessageCenter.h"
#import "GYHDChooseAddressModel.h"
#import "MJExtension.h"
#import "GYAddressData.h"

@interface GYHDChooseAddressViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
/**搜索条*/
@property (nonatomic, weak) UITextField* searchTextField;
/**搜索结果展示View*/
@property (nonatomic, weak) UITableView* searchAddressTableView;
/**搜索数组*/
@property (nonatomic, strong) NSArray* searchAddressArray;
/**零提示*/
@property (nonatomic, weak) UILabel* zeroMessageLabel;
@end

@implementation GYHDChooseAddressViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    //搜索输入框
    self.view.backgroundColor = [UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];

    UIButton* backtrackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backtrackButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [backtrackButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backtrackButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_cancel"] forState:UIControlStateNormal];
    [self.view addSubview:backtrackButton];
    [backtrackButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(40);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(50);
    }];

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
    //    searchTextField.placeholder = @"请输入中文";
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    searchTextField.leftView = leftView;
    searchTextField.returnKeyType = UIReturnKeySearch;
    searchTextField.delegate = self;
    searchTextField.rightViewMode = UITextFieldViewModeAlways;
    searchTextField.rightView = rightSearchButton;
    [self.view addSubview:searchTextField];

    _searchTextField = searchTextField;
    [searchTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(10);
        make.right.equalTo(backtrackButton.mas_left);
        make.centerY.equalTo(backtrackButton);
        make.height.mas_equalTo(27);
    }];
    //2. 展示搜索结果
    UITableView* searchAddressTableView = [[UITableView alloc] init];

    searchAddressTableView.delegate = self;
    searchAddressTableView.dataSource = self;
    searchAddressTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [searchAddressTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"searchCellID"];
    [self.view addSubview:searchAddressTableView];
    _searchAddressTableView = searchAddressTableView;
    [searchAddressTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(searchTextField.mas_bottom).offset(10);
        make.left.bottom.right.mas_equalTo(0);
    }];

    UILabel* zeroMessageLabel = [[UILabel alloc] init];
    zeroMessageLabel.text = [GYUtils localizedStringWithKey:@"GYHD_zero_searchAddress"];
    zeroMessageLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    zeroMessageLabel.textColor = [UIColor grayColor];
    [self.view addSubview:zeroMessageLabel];
    _zeroMessageLabel = zeroMessageLabel;
    zeroMessageLabel.hidden = YES;
    WS(weakSelf);
    [zeroMessageLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.center.equalTo(weakSelf.view);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{

    NSMutableArray* searchAddressArray = [NSMutableArray array];
    for (GYCityAddressModel* cmodel in [[GYHDMessageCenter sharedInstance] selectCityWithString:textField.text]) {

        GYHDChooseAddressModel* model = [[GYHDChooseAddressModel alloc] initWithDict:cmodel.mj_keyValues];
        [searchAddressArray addObject:model];
    }
    self.searchAddressArray = searchAddressArray;
    [self.searchAddressTableView reloadData];
    if (searchAddressArray.count) {
        self.zeroMessageLabel.hidden = YES;
    }
    else {
        self.zeroMessageLabel.hidden = NO;
    }
    return YES;
}

- (void)rightSearchButtonClick:(UIButton*)button
{
    self.searchTextField.text = nil;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchAddressArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHDChooseAddressModel* model = self.searchAddressArray[indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"searchCellID"];
    cell.textLabel.text = model.cityName;
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHDChooseAddressModel* model = self.searchAddressArray[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.block) {
        self.block(model.cityCode);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backClick:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
