//
//  GYHSRealInfoView.m
//
//  Created by apple on 16/8/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSRealInfoView.h"
#import "GYHSRealInfoCell.h"
#import "GYRealNameAuthModel.h"
#define kTopHeight kDeviceProportion(50)
#define kLeftWidth kDeviceProportion(100)

@interface GYHSRealInfoView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, strong) GYRealNameAuthModel* realModel;
@end
@implementation GYHSRealInfoView
- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithArray:@[
            @{ kLocalized(@"GYHS_Myhs_Company_Name_Colon") :  kSaftToNSString(self.realModel.entName)
            },
            @{ kLocalized(@"GYHS_Myhs_Company_Address_Colon") :  kSaftToNSString(self.realModel.entRegAddr) },
             @{ kLocalized(@"GYHS_Myhs_Legal_Person_Colon") :  kSaftToNSString(self.realModel.creName) },
            @{ kLocalized(@"GYHS_Myhs_Business_License_Nymber_Colon") :  kSaftToNSString(self.realModel.busiLicenseNo) }
        ]];
    }
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame model:(GYRealNameAuthModel*)model;
{
    if (self = [super initWithFrame:frame]) {
        self.realModel = model;
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
    tableView.scrollEnabled = NO; //数据较少关闭滑动
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSRealInfoCell class]) bundle:nil] forCellReuseIdentifier:realNameInfoCell];
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

    GYHSRealInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:realNameInfoCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.leftLabel.text = [[self.dataArray[indexPath.row] allKeys] lastObject];
    cell.rightLabel.text = [self.dataArray[indexPath.row] objectForKey:cell.leftLabel.text];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (void)layoutSubviews
{
     [super layoutSubviews];
    self.customBorderType = UIViewCustomBorderTypeAll;
}


@end
