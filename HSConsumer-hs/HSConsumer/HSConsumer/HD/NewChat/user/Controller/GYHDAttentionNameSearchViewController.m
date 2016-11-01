//
//  GYHDAttentionNameSearchViewController.m
//  HSConsumer
//
//  Created by shiang on 16/3/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDAttentionNameSearchViewController.h"
#import "GYHDMessageCenter.h"
#import "GYHDAttentionCompanySearchListViewController.h"

@interface GYHDAttentionNameSearchViewController () <UITextFieldDelegate>

@property (nonatomic, weak) UITextField* searchTextField;

@end

@implementation GYHDAttentionNameSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    searchTextField.placeholder = [GYUtils localizedStringWithKey:@"GYHD_Company_input_husheng"];
    searchTextField.returnKeyType = UIReturnKeySearch;
    searchTextField.delegate = self;
    //    searchTextField.rightViewMode = UITextFieldViewModeAlways;
    //    searchTextField.rightView = rightSearchButton;
    [self.view addSubview:searchTextField];
    _searchTextField = searchTextField;

    UIButton* searchButton = [[UIButton alloc] init];
    [searchButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_search"] forState:UIControlStateNormal];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"gyhd_text_field_send_icom"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];

    [searchTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(55);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(35);
    }];
    [searchButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(searchTextField.mas_bottom).offset(20);
        make.centerX.equalTo(searchTextField);
        make.size.mas_equalTo(CGSizeMake(220, 33));
    }];
}

- (void)rightSearchButtonClick:(UIButton*)button
{
    self.searchTextField.text = nil;
}

- (void)searchButtonClick
{
    GYHDAttentionCompanySearchListViewController* searchListViewController = [[GYHDAttentionCompanySearchListViewController alloc] init];
    searchListViewController.searchString = self.searchTextField.text;
    [self.navigationController pushViewController:searchListViewController animated:YES];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    NSMutableDictionary *attDict = [NSMutableDictionary dictionary];
//    attDict[NSForegroundColorAttributeName] = [UIColor redColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:attDict];
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setImage:[UIImage imageNamed:@"gyhd_nav_leftView_back"] forState:UIControlStateNormal];
//    backButton.frame = CGRectMake(0, 0, 80, 40);
//    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
//    [backButton addTarget:self action:@selector(ignoreClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//
//}
//- (void)ignoreClick {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//
//    self.navigationController.navigationBar.barTintColor = kNavBackgroundColor;
//
//    NSMutableDictionary *attDict = [NSMutableDictionary dictionary];
//    attDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:attDict];
//}
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [self searchButtonClick];
    return YES;
}
@end
