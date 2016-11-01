//
//  GYHDImportantChangeApprovingViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/18.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDImportantChangeApprovingViewController.h"
#import "GYHDWaitingAuditCell.h"
#import "Masonry.h"

#define kGYHDWaitingAuditCell @"GYHDWaitingAuditCell"
@interface GYHDImportantChangeApprovingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *approveUITableView;
@end

@implementation GYHDImportantChangeApprovingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.approveUITableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHDWaitingAuditCell class]) bundle:nil] forCellReuseIdentifier:kGYHDWaitingAuditCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- UItableView代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.backgroundColor = kDefaultVCBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    GYHDWaitingAuditCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHDWaitingAuditCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.auditImageView.image = [UIImage imageNamed:@"gyhd_processing"];
    cell.auditLb.text = @"审核中";
    cell.warmPromptLb.text = @"温馨提示：\n目前您处于重要信息变更申请处理中，在此期间，本业务暂时无法受理";
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 200;
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
    view.backgroundColor = kDefaultVCBackgroundColor;
    return view;
}
//组头高度
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
        return 15.0f;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}

#pragma mark -- Lazy loading
-(UITableView*)approveUITableView
{
    if (!_approveUITableView) {
            _approveUITableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
            _approveUITableView.delegate = self;
            _approveUITableView.dataSource = self;
            [self.view addSubview:_approveUITableView];
            [_approveUITableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.top.mas_equalTo(0);
            }];
    }
    return _approveUITableView;
}

@end
