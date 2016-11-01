//
//  GYHSBankAccountAddVC.m
//
//  Created by apple on 16/8/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSBankAccountDetialVC.h"
#import "GYHSBankAccountCell.h"
#import "GYHSBankListModel.h"
#define kTopHeight 70
#define kMargin 212
#define kBottomHeight kDeviceProportion(70)
#define kTableViewHeight kDeviceProportion(52.5 * 6)
#define kTableViewWidth kDeviceProportion(600)

@interface GYHSBankAccountDetialVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@end

@implementation GYHSBankAccountDetialVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDLogInfo(@"Show Controller: %@", [self class]);
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHS_Myhs_Bank_Account");
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view).offset(kMargin);
        make.top.equalTo(self.view).offset(kTopHeight + kNavigationHeight);
        make.size.mas_equalTo(CGSizeMake(kTableViewWidth, kTableViewHeight));
    }];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHSBankAccountCell* cell = [tableView dequeueReusableCellWithIdentifier:bankAccountCell];
    cell.bankLeftLabel.text = [[self.dataArray[indexPath.row] allKeys] lastObject];
    cell.bankRightLabel.text = [self.dataArray[indexPath.row] objectForKey:cell.bankLeftLabel.text];
    if (indexPath.row == 0) {
        cell.bankRightLabel.textColor = kRedE50012;
    }
    else {
        cell.bankRightLabel.textColor = kGray333333;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.customBorderType = UIViewCustomBorderTypeTop;
}

#pragma mark - lazy load
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 44;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSBankAccountCell class]) bundle:nil] forCellReuseIdentifier:bankAccountCell];
    }
    return _tableView;
}

- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
    
        _dataArray = [NSMutableArray arrayWithArray:@[
            @{ kLocalized(@"GYHS_Myhs_Account_Name_Colon") : self.model.realName },
            @{ kLocalized(@"GYHS_Myhs_Settle_Kind_Colon") : globalData.config.currencyName ? globalData.config.currencyName : @"" },
            @{ kLocalized(@"GYHS_Myhs_Open_Bank_Colon") : self.model.bankName },
            @{ kLocalized(@"GYHS_Myhs_Open_Area_Colon") : self.model.openArea },
            @{ kLocalized(@"GYHS_Myhs_Bank_Number_Colon") : self.model.bankAccNo },
            @{ kLocalized(@"GYHS_Myhs_Is_Default_Bank_Colon") : self.model.isDefault.doubleValue ? kLocalized(@"GYHS_Myhs_Yes") : kLocalized(@"GYHS_Myhs_No") }
        ]];
    }
    return _dataArray;
}

@end
