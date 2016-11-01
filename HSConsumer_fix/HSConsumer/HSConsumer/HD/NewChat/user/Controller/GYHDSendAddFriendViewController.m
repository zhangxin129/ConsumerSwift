//
//  GYHDSendAddFriendViewController.m
//  HSConsumer
//
//  Created by shiang on 16/4/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSendAddFriendViewController.h"
#import "GYHDMessageCenter.h"

@interface GYHDSendAddFriendViewController () <UITextFieldDelegate>
@property (nonatomic, weak) UITextField* searchTextField;
@end

@implementation GYHDSendAddFriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];
    self.title = [GYUtils localizedStringWithKey:@"GYHD_Friend_add_Friend"];
    UILabel* tipsLabel = [[UILabel alloc] init];
    tipsLabel.text = [GYUtils localizedStringWithKey:@"GYHD_Send_Application_tips"];
    tipsLabel.font = [UIFont systemFontOfSize:KFontSizePX(24)];
    tipsLabel.textColor = [UIColor grayColor];
    [self.view addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];

    UIButton* rightSearchButton = [[UIButton alloc] init];
    [rightSearchButton setBackgroundImage:[UIImage imageNamed:@"gyhd_search_bar_right_icon"] forState:UIControlStateNormal];

    [rightSearchButton addTarget:self action:@selector(rightSearchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    rightSearchButton.frame = CGRectMake(0, 0, 30, 30);
    UITextField* searchTextField = [[UITextField alloc] init];
    searchTextField.backgroundColor = [UIColor whiteColor];
    searchTextField.placeholder = [GYUtils localizedStringWithKey:@"GYHD_searchHusheng"];
    NSDictionary* myInfodict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
    searchTextField.text = [NSString stringWithFormat:@"我是%@", myInfodict[@"Friend_Name"]];
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    searchTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    searchTextField.delegate = self;

    searchTextField.rightViewMode = UITextFieldViewModeAlways;
    searchTextField.rightView = rightSearchButton;
    [self.view addSubview:searchTextField];
    _searchTextField = searchTextField;
    [searchTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(tipsLabel.mas_bottom);
        make.height.mas_equalTo(40);

    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_Send"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [rightButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];

    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_cancel"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    //    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //    NSMutableDictionary *attDict = [NSMutableDictionary dictionary];
    //    attDict[NSForegroundColorAttributeName] = [UIColor redColor];
    //    [self.navigationController.navigationBar setTitleTextAttributes:attDict];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//
//    self.navigationController.navigationBar.barTintColor = kNavBackgroundColor;
//
//    NSMutableDictionary *attDict = [NSMutableDictionary dictionary];
//    attDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:attDict];
//
//}

- (void)rightButtonClick
{

    if (self.block) {
        self.block(self.searchTextField.text);
        [self.navigationController popViewControllerAnimated:YES];
        //        [self dismissViewControllerAnimated:YES completion:nil];
    }
    //    NSLog(@"发送%@", self.searchTextField.text);
}

- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];

    //    NSLog(@"取消");
}

- (void)rightSearchButtonClick:(UIButton*)button
{
    self.searchTextField.text = nil;
}

- (void)dealloc
{
    [NSThread sleepForTimeInterval:1.0];
//    NSLog(@"消费");
}
@end
