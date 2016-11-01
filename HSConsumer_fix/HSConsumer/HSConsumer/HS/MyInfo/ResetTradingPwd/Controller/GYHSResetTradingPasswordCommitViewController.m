//
//  GYHSResetTradingPasswordCommitViewController.m
//
//  Created by lizp on 16/8/16.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSResetTradingPasswordCommitViewController.h"
#import "GYHSResetTradingTableViewCell.h"
#import "GYHSResetTradingFooterView.h"

@interface GYHSResetTradingPasswordCommitViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titltData;
@property (nonatomic,strong) NSArray *placeholderData;

@end

@implementation GYHSResetTradingPasswordCommitViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Show Controller: %@", [self class]);

}

- (void)dealloc {
    NSLog(@"Dealloc Controller: %@", [self class]);
}

#pragma mark - SystemDelegate
#pragma mark TableView Delegate   
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titltData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GYHSResetTradingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHSResetTradingTableViewCellIdentifier];
    
    [cell refreshDataWithTitle:self.titltData[indexPath.row] placeHolder:self.placeholderData[indexPath.row] indexPaht:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50.0f;
}

#pragma mark - CustomDelegate  
#pragma mark - event response  

#pragma mark - private methods 
- (void)initView
{
    self.title = kLocalized(@"GYHS_Pwd_Reset_Trading_Password");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    NSLog(@"Load Controller: %@", [self class]);
    
    [self.view addSubview:self.tableView];
    GYHSResetTradingFooterView *footerView = [[GYHSResetTradingFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];

    self.tableView.tableFooterView = footerView;
    
}

#pragma mark - getters and setters  
-(UITableView *)tableView {

    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth, kScreenHeight -15-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"GYHSResetTradingTableViewCell" bundle:nil] forCellReuseIdentifier:kGYHSResetTradingTableViewCellIdentifier];
    }
    return _tableView;
}

-(NSArray *)titltData {

    if(!_titltData) {
        _titltData = @[kLocalized(@"GYHS_Pwd_New_Trade_Password"),kLocalized(@"GYHS_Pwd_Determine_Password")];
    }
    return _titltData;
}

-(NSArray *)placeholderData {

    if(!_placeholderData) {
        _placeholderData = @[kLocalized(@"GYHS_Pwd_Eight_New_Password_Input"),kLocalized(@"GYHS_Pwd_Eight_New_Password_Entered_Again")];
    }
    return _placeholderData;
}

@end
