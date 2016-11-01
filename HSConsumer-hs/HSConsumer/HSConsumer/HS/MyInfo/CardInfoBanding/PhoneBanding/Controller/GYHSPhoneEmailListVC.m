//
//  GYHSPhoneEmailListVC.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSPhoneEmailListVC.h"
#import "GYHSPhoneEmailListTableCell.h"
#import "GYNetRequest.h"
#import "GYHSLoginModel.h"
#import "GYHSLoginManager.h"
#import "GYHSPhoneBandingVC.h"
#import "GYHSEmailBandingVC.h"
#import "GYHSConstant.h"
#import "SWTableViewCell.h"

#define kGYHSPhoneEmailListVC_CellIdentify @"kGYHSPhoneEmailListVC_CellIdentify"

@interface GYHSPhoneEmailListVC () <UITableViewDelegate, UITableViewDataSource, GYNetRequestDelegate,SWTableViewCellDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;

@end

@implementation GYHSPhoneEmailListVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self loadDataArray];
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    GYHSPhoneEmailListTableCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHSPhoneEmailListVC_CellIdentify];
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    NSDictionary* dic = self.dataArray[indexPath.section][indexPath.row];
    NSString* imageName = [dic valueForKey:@"Image"];
    NSString* value = [dic valueForKey:@"Value"];
    NSString* bindState = [dic valueForKey:@"BindState"];
    NSString* btnName = [dic valueForKey:@"BtnName"];

    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:70.0f];
    cell.delegate = self;
    [cell setPhoneCellValue:imageName
                  bandState:bindState
                phoneNumber:value
                   btnTitle:btnName
                  indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 80.0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0f;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
}

#pragma mark- SWTableViewCellDelegate
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {

    NSLog(@"%lu",index);
    
    GYHSPhoneBandingVC* vc = [[GYHSPhoneBandingVC alloc] init];
    vc.pageType = GYHSPhoneBandingVCPageModify;
    GYHSLoginModel* model = [self loginModel];
    vc.oldPhoneNumber = model.mobile;
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSArray *)rightButtons {
    NSMutableArray *buttonMary = [[NSMutableArray alloc] init];
    [buttonMary sw_addUtilityButtonWithColor:kNavigationBarColor title:kLocalized(@"GYHS_Banding_Modify_Phone")];
    return buttonMary;
    
}

#pragma mark - private methods

- (void)initView
{
    NSString* titleName = kLocalized(@"GYHS_Banding_Cell_Phone_Number_Binding");
    self.title = titleName;
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    [self.view addSubview:self.tableView];
}

- (GYHSLoginModel*)loginModel
{
    return [[GYHSLoginManager shareInstance] loginModuleObject];
}

#pragma mark - getter and setter
- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSPhoneEmailListTableCell class]) bundle:nil] forCellReuseIdentifier:kGYHSPhoneEmailListVC_CellIdentify];
    }

    return _tableView;
}

-(void)loadDataArray {

    self.dataArray = [[NSMutableArray alloc] init];
    
    GYHSLoginModel* model = [self loginModel];
    NSString* imageName = @"hs_cell_phone_banding";
    NSString* bindState = kLocalized(@"GYHS_Banding_Authenticated");
    NSString* btnName = kLocalized(@"GYHS_Banding_ModifyThePhone");
    NSString* value = model.mobile;
    
    
    [_dataArray addObject:@[ @{
                                 @"Image" : imageName,
                                 @"Value" : value,
                                 @"BindState" : bindState,
                                 @"BtnName" : btnName
                                 } ]];

}


@end