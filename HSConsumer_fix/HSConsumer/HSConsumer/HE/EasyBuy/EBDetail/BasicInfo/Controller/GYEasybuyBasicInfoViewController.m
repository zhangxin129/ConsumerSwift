//
//  GYEasybuyBasicInfoViewController.m
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEasybuyBasicInfoViewController.h"
#import "GYEasybuyBasicInfoCell.h"

#define kGYEasybuyBasicInfoCell @"GYEasybuyBasicInfoCell"

@interface GYEasybuyBasicInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView* tabView;

@end

@implementation GYEasybuyBasicInfoViewController

#pragma mark - 生命周期


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = kLocalized(@"GYHE_Easybuy_basicParameters");
    
    UIButton* backBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBut setImage:[UIImage imageNamed:@"gycommon_nav_back"] forState:UIControlStateNormal];
    backBut.frame = CGRectMake(0, 0, 40, 40);
    backBut.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [backBut addTarget:self action:@selector(pushBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:backBut];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.basicParameterArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYEasybuyBasicInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYEasybuyBasicInfoCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(self.basicParameterArray.count > indexPath.row)
        cell.dict = self.basicParameterArray[indexPath.row];
    return cell;
}
#pragma mark - 自定义
- (void)pushBack {

    [self.tabView removeFromSuperview];
    self.tabView = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载

- (void)setBasicParameterArray:(NSArray*)basicParameterArray
{
    _basicParameterArray = basicParameterArray;

    UITableView * tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    tabView.backgroundColor = kDefaultVCBackgroundColor;
    tabView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tabView.rowHeight = 44;
    [tabView registerNib:[UINib nibWithNibName:@"GYEasybuyBasicInfoCell" bundle:nil] forCellReuseIdentifier:kGYEasybuyBasicInfoCell];
    tabView.dataSource = self;
    tabView.delegate = self;
    tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tabView];
    _tabView = tabView;
    
    
}



@end
