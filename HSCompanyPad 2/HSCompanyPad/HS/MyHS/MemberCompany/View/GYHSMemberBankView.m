//
//  GYHSMemBerBankView.m
//
//  Created by apple on 16/8/10.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMemberBankView.h"
#import "GYHSBankAccountMainVC.h"
#import "GYHSBankListModel.h"
#import "GYHSMemberBankCell.h"
#import "GYHSPublicMethod.h"
#define kTopHeight kDeviceProportion(45)
#define kLeftWidth kDeviceProportion(80)
@interface GYHSMemberBankView () <UITableViewDataSource, UITableViewDelegate, GYHSBankCilckDelegate, GYHSSelectBankAccountDelegate>
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, weak) UITableView* tableView;
@end
@implementation GYHSMemberBankView

- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithArray:@[ @{ kLocalized(@"GYHS_Myhs_Bank_Account") : @"" }, @{ kLocalized(@"GYHS_Myhs_Account_Name") : @"" }, @{ kLocalized(@"GYHS_Myhs_Open_Bank") : @"" }, @{ kLocalized(@"GYHS_Myhs_Open_Area") : @"" }, @{ kLocalized(@"GYHS_Myhs_Bank_Number") : @"" }, @{ kLocalized(@"GYHS_Myhs_Settle_Kind") : @"" } ]];
    }
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

#pragma mark - setUI
- (void)setUI
{
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(kLeftWidth, kTopHeight, self.size.width - 3 * kLeftWidth, self.size.height - kTopHeight) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.estimatedRowHeight = 44;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSMemberBankCell class]) bundle:nil] forCellReuseIdentifier:memberBankCell];
    [self addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    GYHSMemberBankCell* cell = [tableView dequeueReusableCellWithIdentifier:memberBankCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.leftLabel.text = [[self.dataArray[indexPath.row] allKeys] lastObject];
    cell.rightLabel.text = [self.dataArray[indexPath.row] objectForKey:cell.leftLabel.text];
    cell.delegate = self;
    if (indexPath.row == 0) {
        cell.isShowBtn = YES;
        cell.rightLabel.layer.borderWidth = 1.0;
        cell.rightLabel.layer.borderColor = kRedE40011.CGColor;
    } else {
        cell.isShowBtn = NO;
        cell.rightLabel.layer.borderWidth = 0;
    }
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - GYHSBankCilckDelegate
- (void)selectBankClick:(UIButton*)button cell:(GYHSMemberBankCell*)cell
{
    GYHSBankAccountMainVC* bankVC = [[GYHSBankAccountMainVC alloc] init];
    bankVC.delegate = self;
    [[GYHSPublicMethod viewControllerWithView:self].navigationController pushViewController:bankVC animated:YES];
}

#pragma mark - GYHSSelectBankAccountDelegate
- (void)selectBankAccountWithModel:(GYHSBankListModel*)model
{
    NSString *isVetfy, *bankAllName;
    if ([model.isValidAccount isEqualToString:@"1"]) {
        isVetfy = kLocalized(@"GYHS_Myhs_Verified");
    } else {
        isVetfy = kLocalized(@"GYHS_Myhs_No_Verified");
    }
    bankAllName = [NSString stringWithFormat:@"%@%@ %@", isVetfy, model.bankName, model.bankAccNo];
    self.model = model;
    NSArray* detailArr = @[ bankAllName, model.realName, model.bankName, model.openArea, model.bankAccNo, globalData.config.currencyName ];
    for (int i = 0; i < self.dataArray.count; i++) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithDictionary:self.dataArray[i]];
        [dic setValue:detailArr[i] forKey:[[self.dataArray[i] allKeys] lastObject]];
        [self.dataArray replaceObjectAtIndex:i withObject:dic];
    }
    [self.tableView reloadData];
}

- (void)reloadDeleteBank
{
    NSArray* detailArr = @[@"",@"",@"",@"",@"",@""];
    for (int i = 0; i < self.dataArray.count; i++) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithDictionary:self.dataArray[i]];
        [dic setValue:detailArr[i] forKey:[[self.dataArray[i] allKeys] lastObject]];
        [self.dataArray replaceObjectAtIndex:i withObject:dic];
    }
    [self.tableView reloadData];
}
- (void)layoutSubviews
{
     [super layoutSubviews];
    self.customBorderType = UIViewCustomBorderTypeAll;
}

@end
