//
//  GYHSInvestmentBonuslCheckVC.m
//
//  Created by 吴文超 on 16/8/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSInvestmentBonuslCheckVC.h"
#import "GYHSDetailCheckListView.h" //小标题列举
#import "GYHSDetailCheckTimeView.h" //设置时间查询
#import "GYHSGeneralDetailCheckCell.h" //下面的通用单元格
#import "GYHSAccountUIFactory.h"
#import "GYHSAccountHttpTool.h"
#import "GYHSCompanyPointDetailModel.h"
#import "GYAlertShowDataWithOKButtonView.h"
#import "GYHSInvestDividInfo.h"
#import "GYHSPublicMethod.h"
#import "GYHSInvestBonusDividendModel.h"
#import <GYKit/GYRefreshFooter.h>
#import <GYKit/GYRefreshHeader.h>
#define kCheckViewHeight kDeviceProportion(50)
#define kTimeViewHeight kDeviceProportion(48)
#define kListMenuHeight kDeviceProportion(41)
#define kMenuMargin kDeviceProportion(10)
#define kTimeViewMargin kDeviceProportion(20)
#define kListFourPartHeight kDeviceProportion(35)
#define kLabelLeftRightSpace kDeviceProportion(40)
#define kListSixPartHeight kDeviceProportion(70)
#define kListSixPartLeftWide kDeviceProportion(150)
#define kListSixPartRightWide kDeviceProportion(184.5)
#define kMenuSperation kDeviceProportion(16)
#define kRemoveNoMessage 1233
@interface GYHSInvestmentBonuslCheckVC () <UITableViewDelegate, UITableViewDataSource, GYHSDetailCheckTimeViewChangeDelegate,GYNetworkReloadDelete>
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, weak) GYHSDetailCheckListView *listMenu;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, weak) GYHSCunsumeTextField *endTextfield;
@property (nonatomic, strong) GYHSInvestDividInfo *investDividInfo;

@property (nonatomic, strong) UILabel *accumulativeInvestCountLabel;
@property (nonatomic, strong) UILabel *dividendPeriodLabel;
@property (nonatomic, strong) UILabel *normalDividendLabel;
@property (nonatomic, strong) UILabel *yearDividendRateLabel;
@property (nonatomic, assign) int ipage;
@property (nonatomic, copy)  NSString *recordDate;
@property (nonatomic, strong) UIImageView *backview2;
@end

@implementation GYHSInvestmentBonuslCheckVC

#pragma mark - lazy load
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                  style:UITableViewStyleGrouped];
        _tableView.delegate        = self;
        _tableView.dataSource      = self;
        _tableView.backgroundColor = kWhiteFFFFFF;
    }
    return _tableView;
}

- (NSMutableArray *)listArray
{
    if (!_listArray)
    {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (NSMutableArray *)tempArray
{
    if (!_tempArray)
    {
        _tempArray = [NSMutableArray array];
    }
    return _tempArray;
}

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

// #pragma mark - SystemDelegate
// #pragma mark TableView Delegate
// #pragma mark - CustomDelegate
// #pragma mark - event response

#pragma mark - private methods
/**
 *  分红明细下的视图搭建
 */
- (void)initView
{
    self.title                                = kLocalized(@"GYHS_Account_Investment_Bonus_Detail");
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.view.backgroundColor                            = kWhiteFFFFFF;
    self.navigationController.navigationBar.barTintColor = kBlue0A59C2;

    //此处添加了时间选择器
    GYHSDetailCheckTimeView *timeView = [[GYHSDetailCheckTimeView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kTimeViewHeight)];
    [timeView setThisYearHeadUI];
    UIColor *timeColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kLocalized(@"gyhs_point_fold1")]];
    timeView.backgroundColor = timeColor;
    [self.view
     addSubview:timeView];
    self.endTextfield = timeView.endYearTextfield;
    timeView.delegate = self;
    NSDate *senddate = [NSDate date];

    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];

    [dateformatter setDateFormat:kLocalized(@"YYYY")];

    NSString *locationString = [dateformatter stringFromDate:senddate];

    self.endTextfield.text = locationString;
    //添加一个背景图
    UIImageView *backview1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(timeView.frame), kScreenWidth, kListFourPartHeight * 2 + kMenuSperation)];
    backview1.image = [UIImage imageNamed:kLocalized(@"gycom_safe_queryBakcground")];
    [self.view
     addSubview:backview1];

    //显示4个横排
    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(kTimeViewMargin, kMenuSperation * 0.5, kScreenWidth - 2 * kTimeViewMargin, kListFourPartHeight * 2)];

    [backview1 addSubview:showView];
#pragma mark-----中间的四个小块
    //分四个小块
    //小块1
    UIView *showView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (showView.frame.size.width) * 0.5, (showView.frame.size.height) * 0.5)];
    showView1.backgroundColor = kDefaultVCBackgroundColor;
    [showView addSubview:showView1];
    showView1.layer.borderWidth = 1;
    showView1.layer.borderColor = kGrayE3E3EA.CGColor;

    //添加label到第一个视图上
    UILabel *label01 = [[UILabel alloc] init];
    [showView1 addSubview:label01];
    label01.text            = kLocalized(@"GYHS_Account_Cumulative_Volume_Of_Investment");
    label01.font            = kFont28;
    label01.textColor       = kGray999999;
    label01.backgroundColor = [UIColor clearColor];
    CGSize label01Size = [self giveLabelWith:label01.font
                                    nsstring:label01.text];

    [label01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showView1).offset(kLabelLeftRightSpace);
        make.width.equalTo(@(kDeviceProportion(label01Size.width) + 1));
        make.height.equalTo(@(kDeviceProportion(label01Size.height) + 1));
        make.centerY.equalTo(showView1.mas_centerY);
    }];
    label01.textAlignment = NSTextAlignmentLeft;

    UILabel *label02 = [[UILabel alloc] init];
    [showView1 addSubview:label02];
    label02.text            = @"";//100000.00
    label02.font            = kFont28;
    label02.textColor       = kBlue0A59C2;
    label02.backgroundColor = [UIColor clearColor];
    CGSize label02Size = [self giveLabelWith:label02.font
                                    nsstring:label02.text];
    self.accumulativeInvestCountLabel = label02;
    [label02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(showView1).offset(-kLabelLeftRightSpace);
        make.width.equalTo(@(kDeviceProportion(100)));
        make.height.equalTo(@(kDeviceProportion(label02Size.height) + 1));
        make.centerY.equalTo(showView1.mas_centerY);
    }];
    label02.textAlignment = NSTextAlignmentRight;

    //小块2
    UIView *showView2 = [[UIView alloc] initWithFrame:CGRectMake((showView.frame.size.width) * 0.5, 0, (showView.frame.size.width) * 0.5, (showView.frame.size.height) * 0.5)];
    showView2.backgroundColor = kDefaultVCBackgroundColor;
    [showView addSubview:showView2];
    showView2.layer.borderWidth = 1;
    showView2.layer.borderColor = kGrayE3E3EA.CGColor;
    //添加label到第一个视图上
    UILabel *label03 = [[UILabel alloc] init];
    [showView2 addSubview:label03];
    label03.text            = kLocalized(@"GYHS_Account_Investment_Bonus_Cycle");
    label03.font            = kFont28;
    label03.textColor       = kGray999999;
    label03.backgroundColor = [UIColor clearColor];
    CGSize label03Size = [self giveLabelWith:label03.font
                                    nsstring:label03.text];

    [label03 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showView2).offset(kLabelLeftRightSpace);
        make.width.equalTo(@(kDeviceProportion(label03Size.width) + 1));
        make.height.equalTo(@(kDeviceProportion(label03Size.height) + 1));
        make.centerY.equalTo(showView2.mas_centerY);
    }];
    label03.textAlignment = NSTextAlignmentLeft;

    UILabel *label04 = [[UILabel alloc] init];
    [showView2 addSubview:label04];
    label04.text            = @"";//2014-1-1/2015-1-1
    label04.font            = kFont28;
    label04.textColor       = kGray333333; //需要调整
    label04.backgroundColor = [UIColor clearColor];
    CGSize label04Size = [self giveLabelWith:label04.font
                                    nsstring:label04.text];

    [label04 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(showView2).offset(-kLabelLeftRightSpace);
        make.width.equalTo(@(kDeviceProportion(100) * 2));
        make.height.equalTo(@(kDeviceProportion(label04Size.height) + 1));
        make.centerY.equalTo(showView2.mas_centerY);
    }];
    label04.textAlignment    = NSTextAlignmentRight;
    self.dividendPeriodLabel = label04;

    //小块3
    UIView *showView3 = [[UIView alloc] initWithFrame:CGRectMake(0, (showView.frame.size.height) * 0.5, (showView.frame.size.width) * 0.5 - 1, (showView.frame.size.height) * 0.5)];
    showView3.backgroundColor = kDefaultVCBackgroundColor;
    [showView addSubview:showView3];
    showView3.layer.borderWidth = 1;
    showView3.layer.borderColor = kGrayE3E3EA.CGColor;
    //添加label到第一个视图上
    UILabel *label05 = [[UILabel alloc] init];
    [showView3 addSubview:label05];
    label05.text            = kLocalized(@"GYHS_Account_The_Total_Number_Of_HSB_Bonus");
    label05.font            = kFont28;
    label05.textColor       = kGray999999;
    label05.backgroundColor = [UIColor clearColor];
    CGSize label05Size = [self giveLabelWith:label05.font
                                    nsstring:label05.text];

    [label05 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showView3).offset(kLabelLeftRightSpace);
        make.width.equalTo(@(kDeviceProportion(label05Size.width) + 1));
        make.height.equalTo(@(kDeviceProportion(label05Size.height) + 1));
        make.centerY.equalTo(showView3.mas_centerY);
    }];
    label05.textAlignment = NSTextAlignmentLeft;

    UILabel *label06 = [[UILabel alloc] init];
    [showView3 addSubview:label06];
    label06.text            = @"";//100000.00
    label06.font            = kFont28;
    label06.textColor       = kRedFF6235;
    label06.backgroundColor = [UIColor clearColor];
    CGSize label06Size = [self giveLabelWith:label06.font
                                    nsstring:label06.text];

    [label06 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(showView3).offset(-kLabelLeftRightSpace);
        make.width.equalTo(@(kDeviceProportion(100)));
        make.height.equalTo(@(kDeviceProportion(label06Size.height) + 1));
        make.centerY.equalTo(showView3.mas_centerY);
    }];
    label06.textAlignment    = NSTextAlignmentRight;
    self.normalDividendLabel = label06;

    //小块4
    UIView *showView4 = [[UIView alloc] initWithFrame:CGRectMake((showView.frame.size.width) * 0.5, (showView.frame.size.height) * 0.5, (showView.frame.size.width) * 0.5, (showView.frame.size.height) * 0.5)];
    showView4.backgroundColor = kDefaultVCBackgroundColor;
    [showView addSubview:showView4];
    showView4.layer.borderWidth = 1;
    showView4.layer.borderColor = kGrayE3E3EA.CGColor;
    //添加label到第一个视图上
    UILabel *label07 = [[UILabel alloc] init];
    [showView4 addSubview:label07];
    label07.text            = kLocalized(@"GYHS_Account_Return_On_Dividends_For_The_Year");
    label07.font            = kFont28;
    label07.textColor       = kGray999999;
    label07.backgroundColor = [UIColor clearColor];
    CGSize label07Size = [self giveLabelWith:label07.font
                                    nsstring:label07.text];

    [label07 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showView4).offset(kLabelLeftRightSpace);
        make.width.equalTo(@(kDeviceProportion(label07Size.width) + 1));
        make.height.equalTo(@(kDeviceProportion(label07Size.height) + 1));
        make.centerY.equalTo(showView4.mas_centerY);
    }];
    label07.textAlignment = NSTextAlignmentLeft;

    UILabel *label08 = [[UILabel alloc] init];
    [showView4 addSubview:label08];
    label08.text            = @"";//100%
    label08.font            = kFont28;
    label08.textColor       = kRedFF6235;
    label08.backgroundColor = [UIColor clearColor];
    CGSize label08Size = [self giveLabelWith:label08.font
                                    nsstring:label08.text];

    [label08 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(showView4).offset(-kLabelLeftRightSpace);
        make.width.equalTo(@(kDeviceProportion(100)));//label08Size.width
        make.height.equalTo(@(kDeviceProportion(label08Size.height) + 1));
        make.centerY.equalTo(showView4.mas_centerY);
    }];
    label08.textAlignment      = NSTextAlignmentRight;
    self.yearDividendRateLabel = label08;

#pragma mark-----子标题7个小块的处理
    //添加一个背景图
    UIImageView *backview2 = [[UIImageView alloc] initWithFrame:CGRectMake(kMenuMargin, CGRectGetMaxY(backview1.frame), kScreenWidth - 2 * kMenuMargin, kListSixPartHeight + kMenuSperation * 0.5)];
    backview2.image = [UIImage imageNamed:kLocalized(@"gyhs_point_fold3")];
    [self.view
     addSubview:backview2];
    self.backview2 = backview2;
    //子标题菜单

    UIView *listMenu = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 2 * kMenuMargin, kListSixPartHeight)];

    [backview2 addSubview:listMenu];

    //分成7个小块
    UIView *titleView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kListSixPartLeftWide, kListSixPartHeight)];
    titleView1.backgroundColor = kDefaultVCBackgroundColor;
    [listMenu addSubview:titleView1];
    titleView1.layer.borderWidth = 1;
    titleView1.layer.borderColor = kGrayE3E3EA.CGColor;

    UILabel *title01 = [[UILabel alloc] init];
    [titleView1 addSubview:title01];
    title01.text            = kLocalized(@"GYHS_Account_Date_Of_Investment");
    title01.font            = kFont24;
    title01.textColor       = kGray333333;
    title01.backgroundColor = [UIColor clearColor];
    CGSize title01Size = [self giveLabelWith:title01.font
                                    nsstring:title01.text];

    [title01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kDeviceProportion(title01Size.width) + 1));
        make.height.equalTo(@(kDeviceProportion(title01Size.height) + 1));
        make.centerY.equalTo(titleView1.mas_centerY);
        make.centerX.equalTo(titleView1.mas_centerX);
    }];
    title01.textAlignment = NSTextAlignmentCenter;

    UIView *titleView2 = [[UIView alloc] initWithFrame:CGRectMake(kListSixPartLeftWide, 0, kListSixPartLeftWide, kListSixPartHeight)];
    titleView2.backgroundColor = kDefaultVCBackgroundColor;
    [listMenu addSubview:titleView2];
    titleView2.layer.borderWidth = 1;
    titleView2.layer.borderColor = kGrayE3E3EA.CGColor;
    //
    UILabel *title02 = [[UILabel alloc] init];
    [titleView2 addSubview:title02];
    title02.text            = kLocalized(@"GYHS_Account_Points_Of_Investment");
    title02.font            = kFont24;
    title02.textColor       = kGray333333;
    title02.backgroundColor = [UIColor clearColor];
    CGSize title02Size = [self giveLabelWith:title02.font
                                    nsstring:title02.text];

    [title02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kDeviceProportion(title02Size.width) + 1));
        make.height.equalTo(@(kDeviceProportion(title02Size.height) + 1));
        make.centerY.equalTo(titleView2.mas_centerY);
        make.centerX.equalTo(titleView2.mas_centerX);
    }];
    title02.textAlignment = NSTextAlignmentCenter;

    UIView *titleView3 = [[UIView alloc] initWithFrame:CGRectMake(kListSixPartLeftWide * 2, 0, kListSixPartLeftWide, kListSixPartHeight)];
    titleView3.backgroundColor = kDefaultVCBackgroundColor;
    [listMenu addSubview:titleView3];
    titleView3.layer.borderWidth = 1;
    titleView3.layer.borderColor = kGrayE3E3EA.CGColor;
    //需要特别对待下
    UILabel *title03 = [[UILabel alloc] init];
    [titleView3 addSubview:title03];
    title03.text            = kLocalized(@"GYHS_Account_Time_To_Participate_In_Dividends");
    title03.font            = kFont24;
    title03.textColor       = kGray333333;
    title03.backgroundColor = [UIColor clearColor];

    [title03 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kDeviceProportion(60)));
        make.height.equalTo(@(kListSixPartHeight));
        make.centerY.equalTo(titleView3.mas_centerY);
        make.centerX.equalTo(titleView3.mas_centerX);
    }];
    title03.numberOfLines = 0;
    title03.textAlignment = NSTextAlignmentCenter;

    UIView *titleView4 = [[UIView alloc] initWithFrame:CGRectMake(kListSixPartLeftWide * 3, 0, listMenu.frame.size.width - kListSixPartLeftWide * 3, kListSixPartHeight * 0.5)];
    titleView4.backgroundColor = kDefaultVCBackgroundColor;
    [listMenu addSubview:titleView4];
    titleView4.layer.borderWidth = 1;
    titleView4.layer.borderColor = kGrayE3E3EA.CGColor;
    //
    UILabel *title04 = [[UILabel alloc] init];
    [titleView4 addSubview:title04];
    title04.text            = kLocalized(@"GYHS_Account_The_Number_Of_HSB_This_Time");
    title04.font            = kFont24;
    title04.textColor       = kGray333333;
    title04.backgroundColor = [UIColor clearColor];
    CGSize title04Size = [self giveLabelWith:title04.font
                                    nsstring:title04.text];

    [title04 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kDeviceProportion(title04Size.width) + 1));
        make.height.equalTo(@(kDeviceProportion(title04Size.height) + 1));
        make.centerY.equalTo(titleView4.mas_centerY);
        make.centerX.equalTo(titleView4.mas_centerX);
    }];
    title04.textAlignment = NSTextAlignmentCenter;

    UIView *titleView5 = [[UIView alloc] initWithFrame:CGRectMake(kListSixPartLeftWide * 3, kListSixPartHeight * 0.5, kListSixPartRightWide, kListSixPartHeight * 0.5)];
    titleView5.backgroundColor = kDefaultVCBackgroundColor;
    [listMenu addSubview:titleView5];
    titleView5.layer.borderWidth = 1;
    titleView5.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel *title05 = [[UILabel alloc] init];
    [titleView5 addSubview:title05];
    title05.text            = kLocalized(@"GYHS_Account_Ltb");
    title05.font            = kFont24;
    title05.textColor       = kGray333333;
    title05.backgroundColor = [UIColor clearColor];
    CGSize title05Size = [self giveLabelWith:title05.font
                                    nsstring:title05.text];

    [title05 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kDeviceProportion(title05Size.width) + 1));
        make.height.equalTo(@(kDeviceProportion(title05Size.height) + 1));
        make.centerY.equalTo(titleView5.mas_centerY);
        make.centerX.equalTo(titleView5.mas_centerX);
    }];
    title05.textAlignment = NSTextAlignmentCenter;

    UIView *titleView6 = [[UIView alloc] initWithFrame:CGRectMake(kListSixPartLeftWide * 3 + kListSixPartRightWide, kListSixPartHeight * 0.5, kListSixPartRightWide, kListSixPartHeight * 0.5)];
    titleView6.backgroundColor = kDefaultVCBackgroundColor;
    [listMenu addSubview:titleView6];
    titleView6.layer.borderWidth = 1;
    titleView6.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel *title06 = [[UILabel alloc] init];
    [titleView6 addSubview:title06];
    title06.text            = kLocalized(@"GYHS_Account_Charity_Relief_Fund");
    title06.font            = kFont24;
    title06.textColor       = kGray333333;
    title06.backgroundColor = [UIColor clearColor];
    CGSize title06Size = [self giveLabelWith:title06.font
                                    nsstring:title06.text];

    [title06 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kDeviceProportion(title06Size.width) + 1));
        make.height.equalTo(@(kDeviceProportion(title06Size.height) + 1));
        make.centerY.equalTo(titleView6.mas_centerY);
        make.centerX.equalTo(titleView6.mas_centerX);
    }];
    title06.textAlignment = NSTextAlignmentCenter;

    UIView *titleView7 = [[UIView alloc] initWithFrame:CGRectMake(kListSixPartLeftWide * 3 + kListSixPartRightWide * 2, kListSixPartHeight * 0.5, kListSixPartRightWide, kListSixPartHeight * 0.5)];
    titleView7.backgroundColor = kDefaultVCBackgroundColor;
    [listMenu addSubview:titleView7];
    titleView7.layer.borderWidth = 1;
    titleView7.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel *title07 = [[UILabel alloc] init];
    [titleView7 addSubview:title07];
    title07.text            = kLocalized(@"GYHS_Account_Totals");
    title07.font            = kFont24;
    title07.textColor       = kGray333333;
    title07.backgroundColor = [UIColor clearColor];
    CGSize title07Size = [self giveLabelWith:title07.font
                                    nsstring:title07.text];

    [title07 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kDeviceProportion(title07Size.width) + 1));
        make.height.equalTo(@(kDeviceProportion(title07Size.height) + 1));
        make.centerY.equalTo(titleView7.mas_centerY);
        make.centerX.equalTo(titleView7.mas_centerX);
    }];
    title07.textAlignment = NSTextAlignmentCenter;

    [self.view
     addSubview:self.tableView];
    @weakify(self);
    [self.tableView
     mas_makeConstraints:^(MASConstraintMaker *make) {
         @strongify(self);
        make.left.equalTo(self.view).equalTo(@(kMenuMargin * 2));
        make.right.equalTo(self.view).equalTo(@(-kMenuMargin * 2));
        make.top.equalTo(self.view).equalTo(@(CGRectGetMaxY(backview2.frame)));
        make.bottom.equalTo(self.view).equalTo(@(-kMenuMargin * 2));
    }];
#pragma mark-----检查分红明细数据问题
    self.ipage      = 1;
    self.recordDate = self.endTextfield.text;

    [self setupRefresh];
    [self httpRequest];

}

#pragma mark 添加刷新控件
/**
 *  添加刷新控件
 */
- (void)setupRefresh
{
    @weakify(self);
    GYRefreshHeader *header = [GYRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self headerRereshing];
    }];

    self.tableView.mj_header = header;

    GYRefreshFooter *footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self footerRereshing];
    }];

    self.tableView.mj_footer = footer;
}

/**
 *  头部刷新
 */
- (void)headerRereshing
{
    self.ipage = 1;
    [self.tempArray removeAllObjects];
    [self.listArray removeAllObjects];

    [self httpRequest];
}

/**
 *  尾部刷新
 */
- (void)footerRereshing
{
    self.ipage += 1;
    [self httpRequest];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UIView *view = [self.view
                    viewWithTag:kRemoveNoMessage];
    if (view)
    {
        [view removeFromSuperview];
    }
    if (self.listArray.count == 0)
    {
        UIView *view = [self.view
                        viewWithTag:kRemoveNoMessage];
        if (view)
        {
            [view removeFromSuperview];
        }

        UIView *viewC = [GYHSPublicMethod addNoDataTipViewWithSuperView:self.view];
        viewC.frame = self.tableView.frame;
        @weakify(self);
        [viewC
         mas_makeConstraints:^(MASConstraintMaker *make) {
             @strongify(self);
             make.left.equalTo(self.view).equalTo(@(kMenuMargin * 2));
             make.right.equalTo(self.view).equalTo(@(-kMenuMargin * 2));
             make.top.equalTo(self.view).equalTo(@(CGRectGetMaxY(_backview2.frame)));
             make.bottom.equalTo(self.view).equalTo(@(-kMenuMargin * 2));
         }];

        viewC.tag = kRemoveNoMessage;
    }

    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYHSGeneralDetailCheckCell *cell = [GYHSGeneralDetailCheckCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GYHSInvestBonusDividendModel *data = self.listArray[indexPath.row];

    return [cell createNeedCustomWithSixLabels:data.investDate
                                        string:[GYUtils formatCurrencyStyle:data.investAmount.doubleValue]
                                        string:data.dividendDays
                                        string:[GYUtils formatCurrencyStyle:data.normalDividend.doubleValue]
                                        string:[GYUtils formatCurrencyStyle:data.directionalDividend.doubleValue]
                                        string:[GYUtils formatCurrencyStyle:data.totalDividend.doubleValue]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDeviceProportion(60);
}

#pragma mark - event
/**
 *  网络请求得到新数据
 */
- (void)httpRequest
{
    [GYNetwork sharedInstance].delegate = self;
    [self investmentCustomDetailCheckStartDate:self.endTextfield.text]; //分红明细列表
}
- (void)gyNetworkDidTapReloadBtn
{
    [self httpRequest];
}
/**
 *  查询投资分红明细(包含标题详情)
 *
 *  @param startDate 开始日期
 */
- (void)investmentCustomDetailCheckStartDate:(NSString *)startDate
{
    //如果上下两次时间相同 表格数组不移除元素//如果不同要移除元素
    if (![self.recordDate
          isEqualToString:startDate])
    {
        [self.listArray removeAllObjects];
        self.ipage = 1;
    }
    self.recordDate = startDate;
    @weakify(self);
    //查询投资分红明细(包含标题详情)
    [GYHSAccountHttpTool queryPointDividendListWithDateFalg:startDate
                                                   pageSize:@"10"
                                                    curPage:[NSString stringWithFormat:@"%d", self.ipage]
                                                    success:^(id responsObject) {
        //如果服务器返回请求不是最新的 直接返回


        @strongify(self);
        NSDictionary *dic = responsObject[@"dividInfo"];

        self.investDividInfo = [[GYHSInvestDividInfo alloc] initWithDictionary:dic
                                                                         error:nil];

        //更新数据
        self.accumulativeInvestCountLabel.text = [GYUtils formatCurrencyStyle:self.investDividInfo.accumulativeInvestCount.doubleValue];
        self.dividendPeriodLabel.text = self.investDividInfo.dividendPeriod;
        self.normalDividendLabel.text = [GYUtils formatCurrencyStyle:self.investDividInfo.normalDividend.doubleValue];
        self.yearDividendRateLabel.text = [NSString stringWithFormat:@"%.2f%%", self.investDividInfo.yearDividendRate.doubleValue * 100];
        [self.tempArray removeAllObjects];
        NSArray *array = responsObject[@"dividList"][@"result"];
        for (NSDictionary *dic in array)
        {
            GYHSInvestBonusDividendModel *data = [[GYHSInvestBonusDividendModel alloc] initWithDictionary:dic
                                                                                                    error:nil];

            [self.tempArray
             addObject:data];
        }

        [self.listArray
         addObjectsFromArray:self.tempArray];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.tempArray.count == 0)  //中间采用临时数组的好处是将页数回调整一下
        {
            self.ipage -= 1;//没有加到数组的是 页数减一
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else if (self.tempArray.count < 10)
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
                                                    failure:^{
    }];
}



#pragma mark - request

/**
 *  点击查询按钮
 *
 *  @param timeView 上面的时间控件视图
 */
- (void)clickCheckBtn:(GYHSDetailCheckTimeView *)timeView
{
    self.ipage = 1;
    [self.listArray removeAllObjects];
    //判断一下 是否为空
    if (self.endTextfield.text.length == 0)
    {
        [self.endTextfield tipWithContent:kLocalized(@"GYHS_Account_Date_Format_Cannot_Be_Empty") animated:YES];
        return;
    }
    //再判断一下时间是否大于五年 如果大于将弹出错误提示
    NSDate *senddate               = [NSDate date];
    NSDate *befordate              = [NSDate dateWithTimeIntervalSinceNow:-24 * 365 * 5 * 60 * 60];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];

    [dateformatter setDateFormat:kLocalized(@"YYYY")];

    NSString *locationStringBefore = [dateformatter stringFromDate:befordate]; //得到五年前的日期格式

    NSString *locationString = [dateformatter stringFromDate:senddate];      //目前的日期格式



    if ([self.endTextfield.text integerValue] < [locationStringBefore integerValue])
    {
        [self.endTextfield tipWithContent:kLocalized(@"GYHS_Account_Can_Not_Check_For_More_Than_5_Years") animated:YES];
        return;
    }


    if ([self.endTextfield.text integerValue] > [locationString integerValue])
    {

        [self.endTextfield tipWithContent:kLocalized(@"GYHS_Account_Query_Time_Can_Not_Exceed_The_Current_Time") animated:YES];
        return;
    }
    //请求数据
    [self investmentCustomDetailCheckStartDate:self.endTextfield.text];

}

/**
 *  代理方法 点击今年
 *
 *  @param timeView 时间控件视图
 */
- (void)clickToday:(GYHSDetailCheckTimeView *)timeView
{
}

/**
 *  给一个label根据字体样式大小设计尺寸
 *
 *  @param fnt    字体大小
 *  @param string 字符串
 *
 *  @return 返回一个尺寸
 */
- (CGSize)giveLabelWith:(UIFont *)fnt nsstring:(NSString *)string
{
    UILabel *label = [[UILabel alloc] init];

    label.text = string;


    return [label.text
            sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil]];
}

@end
