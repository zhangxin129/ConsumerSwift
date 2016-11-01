//
//  GYHDRealNameAuthWaitingAuditViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDRealNameAuthWaitingAuditViewController.h"
#import "GYHDWaitingAuditCell.h"
#import "Masonry.h"
#import "GYHSTools.h"
#import "GYHSButtonCell.h"

@interface GYHDRealNameAuthWaitingAuditViewController ()<UITableViewDataSource,UITableViewDelegate,GYHSButtonCellDelegate>
@property (nonatomic,strong)UITableView *waitingTableView;
@property (nonatomic,strong)NSMutableArray *titleArray;
@property (nonatomic,strong)NSMutableArray *valueArray;

@end

@implementation GYHDRealNameAuthWaitingAuditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.waitingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHDWaitingAuditCell class]) bundle:nil] forCellReuseIdentifier:@"GYHDWaitingAuditCell"];
    [self.waitingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSButtonCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSButtonCell"];
}
#pragma mark -- GYHSButtonCell
-(void)nextBtn
{
    if ([_againAuthDelegate respondsToSelector:@selector(againAuth)]) {
        [self.againAuthDelegate againAuth];
    }
}
#pragma mark -- UItableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.reviewStatus isEqualToString:kRealNameAuthStatusApproveRefuse]) {
        return 2;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.backgroundColor = kDefaultVCBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0) {
        GYHDWaitingAuditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDWaitingAuditCell" forIndexPath:indexPath];
        if ([self.reviewStatus isEqualToString:kRealNameAuthStatusApproveRefuse]) {
            cell.auditImageView.image = [UIImage imageNamed:@"gyhd_review_rejected"];
            cell.auditLb.text = kLocalized(@"GYHD_RealnameRegister_Review_Rejected");
            cell.warmPromptLb.text = [NSString stringWithFormat:@"%@\n%@",kLocalized(@"GYHD_RealnameRegister_Dismiss_Reason"),self.refuseReason];
        }else {
            cell.auditImageView.image = [UIImage imageNamed:@"gyhd_waiting_audit_icon"];
            cell.auditLb.text = kLocalized(@"GYHD_RealnameRegister_To_Audit");
            cell.warmPromptLb.text = kLocalized(@"GYHD_RealnameRegister_Warm_prompt_Authentication_Submitted_Entered_Platform_Audit");
        }
        
        return cell;
    }else {
        if ([self.reviewStatus isEqualToString:kRealNameAuthStatusApproveRefuse]) {
            GYHSButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSButtonCell" forIndexPath:indexPath];
            [cell.btnTitle setTitle:kLocalized(@"GYHD_RealnameRegister_To_Apply_Certification") forState:UIControlStateNormal];
            cell.btnTitle.backgroundColor = kButtonCellBtnCorlor;
            cell.btnDelegate  = self;
            return cell;
        }
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 200;
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    view.backgroundColor = kDefaultVCBackgroundColor;
    return view;
}
//组头高度
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20.0f;
    }
    else {
        return 1.0f;
    }
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}
#pragma mark -- 懒加载
-(UITableView*)waitingTableView
{
    if (!_waitingTableView) {
        _waitingTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _waitingTableView.delegate = self;
        _waitingTableView.dataSource = self;
        [self.view addSubview:_waitingTableView];
        [_waitingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
    }
    return _waitingTableView;
}

-(NSMutableArray*)valueArray
{
    if (!_valueArray) {
        _valueArray = [[NSMutableArray alloc] init];
        
    }
    return _valueArray;
}
@end
