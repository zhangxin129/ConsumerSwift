//
//  GYHSImportantChangeApproveStateVC.m
//  HSConsumer
//
//  Created by wangfd on 16/5/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSImportantChangeApproveStateVC.h"
#import "GYHSRegisterTableCell.h"
#import "GYHSVConfirmTableCell.h"
#import "WealCheckDetailCell.h"

#import "GYHSImportantChangeLicenceViewController.h"
#import "GYHSImportantChangePassportViewController.h"
#import "GYHSImportantChangeIdentifyViewController.h"

// 复核通过
#define kGYHSApproveState @"2"

@interface GYHSImportantChangeApproveStateVC () <UITableViewDelegate, UITableViewDataSource, GYHSVConfirmTableCellDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;

@end

@implementation GYHSImportantChangeApproveStateVC

#pragma mark - life system
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
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
    NSDictionary* dic = self.dataArray[indexPath.section][indexPath.row];
    NSString* name = [dic valueForKey:@"Name"];
    if (indexPath.section == 0) {
        WealCheckDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WealCheckDetailCell_Identify"];
        NSString* value = [dic valueForKey:@"Value"];
        cell.lbTitle.text = name;
        cell.lbContent.text = value;
        cell.lbContent.textAlignment = NSTextAlignmentLeft;
        [cell lbTitlefont:[UIFont systemFontOfSize:15.0f] lbContentfont:[UIFont systemFontOfSize:15.0f]];
        return cell;
    }
    GYHSVConfirmTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSVConfirmTableCell_Identify"];
    [cell setCellName:name];
    cell.cellDelegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CGRect rect = [self.approveRemark boundingRectWithSize:CGSizeMake(kScreenWidth - 98, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:15] } context:nil];

    if (indexPath.section == 0 && indexPath.row == 1) {
        return rect.size.height;
    }
    else {
        return 50.0;
    }
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
}
#pragma mark - GYHSVConfirmTableCellDelegate
- (void)confirmButtonAction:(UIButton*)button
{
    if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify]) {
        GYHSImportantChangeIdentifyViewController *vcImportChange = [[GYHSImportantChangeIdentifyViewController alloc] init];
        vcImportChange.title = kLocalized(@"GYHS_MyInfo_ImportantInformationChanges");
        [self.navigationController pushViewController:vcImportChange animated:YES];
    }else if ([globalData.loginModel.creType isEqualToString:kCertypePassport]){
        GYHSImportantChangePassportViewController *vcImportChange = [[GYHSImportantChangePassportViewController alloc] init];
        vcImportChange.title = kLocalized(@"GYHS_MyInfo_ImportantInformationChanges");
       [self.navigationController pushViewController:vcImportChange animated:YES];
    }
    else if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]){
        GYHSImportantChangeLicenceViewController *vcImportChange = [[GYHSImportantChangeLicenceViewController alloc] init];
        vcImportChange.title = kLocalized(@"GYHS_MyInfo_ImportantInformationChanges");
       [self.navigationController pushViewController:vcImportChange animated:YES];
    }
}
#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHS_MyInfo_Important_Informatiron_Change");
    self.view.backgroundColor = kDefaultVCBackgroundColor;

    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}
- (NSString*)approveState
{
    NSString* msg = kLocalized(@"GYHS_MyInfo_Apply_To_Dismiss");

    if ([kGYHSApproveState isEqualToString:self.approvestatus]) {
        msg = kLocalized(@"GYHS_MyInfo_Apply_For_Through");
    }
    return msg;
}
- (NSString*)approveInfo
{
    return [GYUtils checkStringInvalid:self.approveRemark] ? @"" : self.approveRemark;
}
- (NSString*)approveTime
{
    return kSaftToNSString(self.approveDate);
}
- (NSString*)approveConfirmInfo
{
    NSString* msg = kLocalized(@"GYHS_MyInfo_To_Apply_For");
    if ([kGYHSApproveState isEqualToString:self.approvestatus]) {
        msg = kLocalized(@"GYHS_MyInfo_To_Apply_For_Again");
    }
    return msg;
}
#pragma mark - getter and setter
- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"WealCheckDetailCell" bundle:nil]
            forCellReuseIdentifier:@"WealCheckDetailCell_Identify"];
        [_tableView registerNib:[UINib nibWithNibName:@"GYHSVConfirmTableCell" bundle:nil]
            forCellReuseIdentifier:@"GYHSVConfirmTableCell_Identify"];
    }
    return _tableView;
}
- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];

        [_dataArray addObject:@[ @{ @"Name" : kLocalized(@"GYHS_MyInfo_The_Examination_And_Approval_Status"),
            @"Value" : [self approveState]
        },
            @{ @"Name" : kLocalized(@"GYHS_MyInfo_The_Examination_And_Approval_Opinions"),
                @"Value" : [self approveInfo]
            },
            @{ @"Name" : kLocalized(@"GYHS_MyInfo_Approval_Date"),
                @"Value" : [self approveTime]
            } ]];

        [_dataArray addObject:@[ @{ @"Name" : [self approveConfirmInfo] } ]];
    }
    return _dataArray;
}
@end
