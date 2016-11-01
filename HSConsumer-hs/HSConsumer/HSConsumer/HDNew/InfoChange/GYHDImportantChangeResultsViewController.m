//
//  GYHDImportantChangeResultsViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/18.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDImportantChangeResultsViewController.h"
#import "GYHSVConfirmTableCell.h"
#import "GYHSLabelTwoTableViewCell.h"
#import "GYHDWaitingAuditCell.h"
#import "GYHDImportantChangeLicenceViewController.h"
#import "GYHDImportantChangePassportViewController.h"
#import "GYHDImportantChangeIdentifyViewController.h"
#import "MaSonry.h"
#import "GYHSTools.h"
// 复核通过
#define kGYHSApproveState @"2"

@interface GYHDImportantChangeResultsViewController () <UITableViewDelegate, UITableViewDataSource, GYHSVConfirmTableCellDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;

@end

@implementation GYHDImportantChangeResultsViewController

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
        GYHDWaitingAuditCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDWaitingAuditCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.auditImageView.image = [UIImage imageNamed:name];
        cell.auditLb.text = dic[@"Value"];
        return cell;
    }else if (indexPath.section == 1){
        GYHSLabelTwoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLabelTwoTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString* value = [dic valueForKey:@"Value"];
        cell.titleLabel.text = name;
        cell.detLabel.text = value;
        cell.titleLabel.font = kButtonCellFont;
        cell.titleLabel.font = kButtonCellFont;
        cell.detLabel.textAlignment = NSTextAlignmentLeft;
        if (indexPath.row != 0) {
            cell.toplb.hidden = YES;
        }
        return cell;
    }
    GYHSVConfirmTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSVConfirmTableCell_Identify"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellName:name];
    cell.cellDelegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CGRect rect = [self.changeItem boundingRectWithSize:CGSizeMake(kScreenWidth - 170, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:16] } context:nil];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        return rect.size.height+28;
    }else if (indexPath.section == 0){
        return 170.0;
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
    if ([_changeResultsDelegate respondsToSelector:@selector(againImportantChange)]) {
        [self.changeResultsDelegate againImportantChange];
    }
    if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify]) {
        GYHDImportantChangeIdentifyViewController *vcImportChange = [[GYHDImportantChangeIdentifyViewController alloc] init];
        vcImportChange.title = kLocalized(@"GYHS_MyInfo_ImportantInformationChanges");
        [self.navigationController pushViewController:vcImportChange animated:YES];
    }else if ([globalData.loginModel.creType isEqualToString:kCertypePassport]){
        GYHDImportantChangePassportViewController *vcImportChange = [[GYHDImportantChangePassportViewController alloc] init];
        vcImportChange.title = kLocalized(@"GYHS_MyInfo_ImportantInformationChanges");
        [self.navigationController pushViewController:vcImportChange animated:YES];
    }
    else if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]){
        GYHDImportantChangeLicenceViewController *vcImportChange = [[GYHDImportantChangeLicenceViewController alloc] init];
        vcImportChange.title = kLocalized(@"GYHS_MyInfo_ImportantInformationChanges");
        [self.navigationController pushViewController:vcImportChange animated:YES];
    }
}
#pragma mark - private methods
- (void)initView
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHDWaitingAuditCell class]) bundle:nil] forCellReuseIdentifier:@"GYHDWaitingAuditCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSLabelTwoTableViewCell class]) bundle:nil]
     forCellReuseIdentifier:@"GYHSLabelTwoTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSVConfirmTableCell class]) bundle:nil]
     forCellReuseIdentifier:@"GYHSVConfirmTableCell_Identify"];
}
-(NSString*)imageName
{
    NSString* imageName = @"gyhd_review_rejected";
    
    if ([kGYHSApproveState isEqualToString:self.approvestatus]) {
        imageName = @"gdhd_complete";
    }
    return imageName;
}
- (NSString*)approveState
{
    NSString* msg = kLocalized(@"GYHS_MyInfo_Apply_To_Dismiss");
    
    if ([kGYHSApproveState isEqualToString:self.approvestatus]) {
        msg = kLocalized(@"GYHD_InfoChange_Important_Information_Change_Approved");
    }
    return msg;
}
- (NSString*)approveInfo
{
    return [GYUtils checkStringInvalid:self.changeItem] ? @"" : self.changeItem;
}
- (NSString*)approveTime
{
    return kSaftToNSString(self.approveDate);
}
- (NSString*)approveConfirmInfo
{
    NSString* msg = kLocalized(@"GYHD_InfoChange_Again_Application_Change");
    if ([kGYHSApproveState isEqualToString:self.approvestatus]) {
        msg = kLocalized(@"GYHD_InfoChange_Apply_For_Change_Again");
    }
    return msg;
}
#pragma mark - getter and setter
- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
    }
    return _tableView;
}
- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:@[@{ @"Name" : [self imageName],
                                 @"Value" : [self approveState]
                                   }]];
        NSString * name =kLocalized(@"GYHD_InfoChange_Dismiss_Reason");
        if ([kGYHSApproveState isEqualToString:self.approvestatus]) {
            name = kLocalized(@"GYHD_InfoChange_Change_Content");
        }
        [_dataArray addObject:@[
                                 @{ @"Name" : name,
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
