//
//  GYHSCompanyGeneralDetailCheckVC.m
//
//  Created by 吴文超 on 16/8/2.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSCompanyGeneralDetailCheckVC.h"
#import "GYHSDetailCheckListView.h" //小标题列举
#import "GYHSDetailCheckTimeView.h" //设置时间查询
#import "GYHSGeneralDetailCheckCell.h" //下面的通用单元格
#import "GYAlertShowDataWithOKButtonView.h"
//负责网络请求
#import "GYHSAccountHttpTool.h"
//数据层
#import "GYHSCompanyPointDetailModel.h"
#import "GYHSPublicMethod.h"
#import <GYKit/GYRefreshFooter.h>
#import <GYKit/GYRefreshHeader.h>

#define kCheckViewHeight kDeviceProportion(50)
#define kTimeViewHeight kDeviceProportion(48)
#define kListMenuHeight kDeviceProportion(41)
#define kMenuMargin kDeviceProportion(10)
#define kTimeViewMargin kDeviceProportion(20)
//自定义一个偏移量
#define kDeviationSpace kDeviceProportion(15)
#define kRemoveNoMessage 1233
@interface GYHSCompanyGeneralDetailCheckVC () <UITableViewDelegate, UITableViewDataSource, GYHSDetailCheckTimeViewChangeDelegate,GYNetworkReloadDelete>
//@property (nonatomic,strong) NSArray * dataArr;
@property (nonatomic, weak) GYHSDetailCheckListView *listMenu;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, assign) int ipage;
@property (nonatomic, weak)  GYHSCunsumeTextField *begainField;
@property (nonatomic, weak)  GYHSCunsumeTextField *endTextfield;
@property (nonatomic, copy) NSString *recordstartDate;
@property (nonatomic, copy) NSString *recordendDate;
@end

@implementation GYHSCompanyGeneralDetailCheckVC

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
    self.ipage = 1;
    [self getTodayCheckListContent];
    [self setupRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

    [self getCustomCheckListContent];
}

/**
 *  尾部刷新
 */
- (void)footerRereshing
{
    self.ipage += 1;
    [self getCustomCheckListContent];
}
/**
 *  没有网络状态下上盖视图上的重新加载点击
 */
- (void)gyNetworkDidTapReloadBtn
{
    [self getCustomCheckListContent];
}


#pragma mark-----测试五 通用表格单元测试
/**
 *  取得默认的今天数据
 */
- (void)getTodayCheckListContent
{
    //@weakify(self);
    if (self.detailType == kPointDetailCheckType)
    {
        [self pointDetailCheck:kLocalized(@"today")];
    }
    else if (self.detailType == kCashDetailCheckType)
    {
        [self cashDetailCheck:kLocalized(@"today")];
    }
    else if (self.detailType == kInvestmentDetailCheckType)
    {
        [self investmentDetailCheck:kLocalized(@"today")];
    }
    else if (self.detailType == kHsbDetailCheckType)
    {
        [self hsbDetailCheck:kLocalized(@"today")];
    }
}

/**
 *  取得最近一周的数据
 */
- (void)getWeekCheckListContent
{
    if (self.detailType == kPointDetailCheckType)
    {
        [self pointDetailCheck:kLocalized(@"week")];
    }
    else if (self.detailType == kCashDetailCheckType)
    {
        [self cashDetailCheck:kLocalized(@"week")];
    }
    else if (self.detailType == kInvestmentDetailCheckType)
    {
        [self investmentDetailCheck:kLocalized(@"week")];
    }
    else if (self.detailType == kHsbDetailCheckType)
    {
        [self hsbDetailCheck:kLocalized(@"week")];
    }
}

#pragma mark-----特别的自定义的
/**
 *  按照时间戳取得新的网络数据
 */
- (void)getCustomCheckListContent
{
//先找到两个时间戳
    if (self.detailType == kPointDetailCheckType)
    {
        [self pointCustomDetailCheckStartDate:self.begainField.text
                                      endDate:self.endTextfield.text];
    }
    else if (self.detailType == kCashDetailCheckType)
    {
        [self cashCustomDetailCheckStartDate:self.begainField.text
                                     endDate:self.endTextfield.text];
    }
    else if (self.detailType == kInvestmentDetailCheckType)
    {
        [self investmentCustomDetailCheckStartDate:self.begainField.text
                                           endDate:self.endTextfield.text];
    }
    else if (self.detailType == kHsbDetailCheckType)
    {
        [self hsbCustomDetailCheckStartDate:self.begainField.text
                                    endDate:self.endTextfield.text];
    }
}

#pragma mark - private methods
/**
 *  初始化视图
 */
- (void)initView
{
    if (_detailType == kInvestmentDetailCheckType)
    {
        self.title = kLocalized(@"GYHS_Account_Integral_Investment_Detail");
    }
    else
    {
        self.title = kLocalized(@"GYHS_Account_Detail_Query");
    }

    self.automaticallyAdjustsScrollViewInsets = NO;

    self.view.backgroundColor                            = kWhiteFFFFFF;
    self.navigationController.navigationBar.barTintColor = kBlue0A59C2;

    //此处添加了时间选择器
    GYHSDetailCheckTimeView *timeView = [[GYHSDetailCheckTimeView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kTimeViewHeight)];
    [timeView setCommonUI];
    timeView.delegate = self;
    UIColor *timeColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kLocalized(@"gyhs_point_fold1")]];
    timeView.backgroundColor = timeColor;
    [self.view
     addSubview:timeView];
    self.begainField     = timeView.begainField;
    self.endTextfield    = timeView.endTextfield;
    self.recordstartDate = self.begainField.text;
    self.recordendDate   = self.endTextfield.text;

    UIView *viewtest   = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(timeView.frame), kScreenWidth, kDeviceProportion(12))];
    UIColor *testColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kLocalized(@"gyhs_point_fold4")]];
    viewtest.backgroundColor = testColor;
    [self.view
     addSubview:viewtest];


    //子标题菜单
    GYHSDetailCheckListView *listMenu = [[GYHSDetailCheckListView alloc] initWithFrame:CGRectMake(kMenuMargin, CGRectGetMaxY(viewtest.frame), kScreenWidth - 2 * kMenuMargin, kListMenuHeight)];

    UIColor *menuColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kLocalized(@"gyhs_point_fold3")]];
    listMenu.backgroundColor = menuColor;
    [self.view
     addSubview:listMenu];
    if (_checkType == kListViewCheckFiveItems)
    {
        [listMenu setFiveCommonTitle];
    }
    else
    {
        [listMenu setFourCommonTitle];
    }

    self.listMenu = listMenu;

    //添加表视图
    [self.view
     addSubview:self.tableView];
    @weakify(self);
    [self.tableView
     mas_makeConstraints:^(MASConstraintMaker *make) {
         @strongify(self);
        make.left.equalTo(self.view).equalTo(@(kMenuMargin * 2));
        make.right.equalTo(self.view).equalTo(@(-kMenuMargin * 2));
        make.top.equalTo(self.view).equalTo(@(CGRectGetMaxY(self.listMenu.frame) ));
        make.bottom.equalTo(self.view).equalTo(@(-kMenuMargin * 2));
    }];
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
        UIView *viewC = [GYHSPublicMethod addNoDataTipViewWithSuperView:self.view];
        
        @weakify(self);
        [viewC
         mas_makeConstraints:^(MASConstraintMaker *make) {
             @strongify(self);
             make.left.equalTo(self.view).equalTo(@(kMenuMargin * 2));
             make.right.equalTo(self.view).equalTo(@(-kMenuMargin * 2));
             make.top.equalTo(self.view).equalTo(@(CGRectGetMaxY(self.listMenu.frame) ));
             make.bottom.equalTo(self.view).equalTo(@(-kMenuMargin * 2));
         }];
        viewC.tag = kRemoveNoMessage;
    }

    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //这里要判断下 如果是五个子标题的 按五个标题的单元格来 四个的按四个来
    GYHSGeneralDetailCheckCell *cell = [GYHSGeneralDetailCheckCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.checkType == kListViewCheckFiveItems)
    {
        GYHSCompanyPointDetailModel *data = self.listArray[indexPath.row];
        return [cell createNeedCustomWithFiveLabels:data.transDate
                                             string:[self givebusinessType:data.businessType]
                                             string:[GYUtils formatCurrencyStyle:[data.amount doubleValue]]
                                             string:[GYUtils formatCurrencyStyle:[data.accBalanceNew doubleValue]]
                                             string:[self giveTransType:data.transType]];
    }
    else
    {
        GYHSCompanyPointDetailModel *data = self.listArray[indexPath.row];

        return [cell createNeedCustomWithFourLabels:data.transDate
                                             string:[GYUtils formatCurrencyStyle:[data.amount doubleValue]]
                                             string:[GYUtils formatCurrencyStyle:[data.accBalanceNew doubleValue]]
                                             string:[self giveTransType:data.transType]];
    }
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
 *  积分账户的网络请求
 *
 *  @param dateFlag 时间格式
 */
- (void)pointDetailCheck:(NSString *)dateFlag
{
    [GYNetwork sharedInstance].delegate = self;
    @weakify(self);

    [GYHSAccountHttpTool getAccountDetailListWithBusinessType:@"0"
                                                      accType:@"10110"
                                                     dateFlag:dateFlag
                                                  currentPage:[NSString stringWithFormat:@"%d", self.ipage]
                                                     pageSize:@"10"
                                                      success:^(id responsObject) {
        @strongify(self);
        [self.listArray removeAllObjects];
        NSArray *array = responsObject[GYNetWorkDataKey];
        for (NSDictionary *dic in array)
        {
            GYHSCompanyPointDetailModel *data = [[GYHSCompanyPointDetailModel alloc] initWithDictionary:dic
                                                                                                  error:nil];
            [self.listArray
             addObject:data];
        }
        [self.tableView reloadData];
        if (self.listArray.count < 10)
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
                                                      failure:^{
    }];
}

/**
 *  积分账户的网络请求
 *
 *  @param startDate 开始日期
 *  @param endDate   结束日期
 */
- (void)pointCustomDetailCheckStartDate:(NSString *)startDate endDate:(NSString *)endDate
{
    [GYNetwork sharedInstance].delegate = self;
    if ((![self.recordstartDate
           isEqualToString:startDate]) || (![self.recordendDate
                                             isEqualToString:endDate]))
    {
        [self.listArray removeAllObjects];
        self.ipage = 1;
    }
    self.recordstartDate = startDate;
    self.recordendDate   = endDate;
    @weakify(self);

    [GYHSAccountHttpTool getCustomAccountDetailListWithBusinessType:@"0"
                                                            accType:@"10110"
                                                           dateFlag:@""
                                                          startDate:startDate
                                                            endDate:endDate
                                                        currentPage:[NSString stringWithFormat:@"%d", self.ipage]
                                                           pageSize:@"10"
                                                            success:^(id responsObject) {
        @strongify(self);
        [self.tempArray removeAllObjects];
        NSArray *array = responsObject[GYNetWorkDataKey];
        for (NSDictionary *dic in array)
        {
            GYHSCompanyPointDetailModel *data = [[GYHSCompanyPointDetailModel alloc] initWithDictionary:dic
                                                                                                  error:nil];

            [self.tempArray
             addObject:data];
        }

        [self.listArray
         addObjectsFromArray:self.tempArray];
        //停止下拉刷新控件动画
        [self.tableView.mj_header endRefreshing];
        //停止上拉刷新控件动画
        [self.tableView.mj_footer endRefreshing];

        [self.tableView reloadData];
        if (self.tempArray.count == 0)                                                          //中间采用临时数组的好处是将页数回调整一下
        {
            self.ipage -= 1;                                                        //没有加到数组的是 页数减一
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

/**
 *  货币账户的网络请求
 *
 *  @param startDate 日期
 */
- (void)cashDetailCheck:(NSString *)dateFlag
{
    [GYNetwork sharedInstance].delegate = self;
    @weakify(self);

    [GYHSAccountHttpTool getAccountDetailListWithBusinessType:@"0"
                                                      accType:@"30110"
                                                     dateFlag:dateFlag
                                                  currentPage:[NSString stringWithFormat:@"%d", self.ipage]
                                                     pageSize:@"10"
                                                      success:^(id responsObject) {
        @strongify(self);
        [self.listArray removeAllObjects];
        NSArray *array = responsObject[GYNetWorkDataKey];
        for (NSDictionary *dic in array)
        {
            GYHSCompanyPointDetailModel *data = [[GYHSCompanyPointDetailModel alloc] initWithDictionary:dic
                                                                                                  error:nil];
            [self.listArray
             addObject:data];
        }
        [self.tableView reloadData];
        if (self.listArray.count < 10)
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
                                                      failure:^{
    }];
}

/**
 *  货币账户的网络请求
 *
 *  @param startDate 开始日期
 *  @param endDate   结束日期
 */
- (void)cashCustomDetailCheckStartDate:(NSString *)startDate endDate:(NSString *)endDate
{
    [GYNetwork sharedInstance].delegate = self;
    if ((![self.recordstartDate
           isEqualToString:startDate]) || (![self.recordendDate
                                             isEqualToString:endDate]))
    {
        [self.listArray removeAllObjects];
        self.ipage = 1;
    }
    self.recordstartDate = startDate;
    self.recordendDate   = endDate;
    @weakify(self);

    [GYHSAccountHttpTool getCustomAccountDetailListWithBusinessType:@"0"
                                                            accType:@"30110"
                                                           dateFlag:@""
                                                          startDate:startDate
                                                            endDate:endDate
                                                        currentPage:[NSString stringWithFormat:@"%d", self.ipage]
                                                           pageSize:@"10"
                                                            success:^(id responsObject) {
        @strongify(self);
        [self.tempArray removeAllObjects];
        NSArray *array = responsObject[GYNetWorkDataKey];
        for (NSDictionary *dic in array)
        {
            GYHSCompanyPointDetailModel *data = [[GYHSCompanyPointDetailModel alloc] initWithDictionary:dic
                                                                                                  error:nil];

            [self.tempArray
             addObject:data];
        }

        [self.listArray
         addObjectsFromArray:self.tempArray];
        //停止下拉刷新控件动画
        [self.tableView.mj_header endRefreshing];
        //停止上拉刷新控件动画
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        if (self.tempArray.count == 0)                                                          //中间采用临时数组的好处是将页数回调整一下
        {
            self.ipage -= 1;                                                        //没有加到数组的是 页数减一
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

/**
 *  投资账户的网络请求
 *
 *  @param dateFlag 日期
 */
- (void)investmentDetailCheck:(NSString *)dateFlag
{
    [GYNetwork sharedInstance].delegate = self;
    @weakify(self);

    [GYHSAccountHttpTool getAccountDetailListWithBusinessType:@"0"
                                                      accType:@"10410"
                                                     dateFlag:dateFlag
                                                  currentPage:[NSString stringWithFormat:@"%d", self.ipage]
                                                     pageSize:@"10"
                                                      success:^(id responsObject) {
        @strongify(self);
        [self.listArray removeAllObjects];
        NSArray *array = responsObject[GYNetWorkDataKey];
        for (NSDictionary *dic in array)
        {
            GYHSCompanyPointDetailModel *data = [[GYHSCompanyPointDetailModel alloc] initWithDictionary:dic
                                                                                                  error:nil];
            [self.listArray
             addObject:data];
        }
        [self.tableView reloadData];
        if (self.listArray.count < 10)
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
                                                      failure:^{
    }];
}

/**
 *  投资账户的网络请求
 *
 *  @param startDate 开始日期
 *  @param endDate   结束日期
 */
- (void)investmentCustomDetailCheckStartDate:(NSString *)startDate endDate:(NSString *)endDate
{
    [GYNetwork sharedInstance].delegate = self;
    if ((![self.recordstartDate
           isEqualToString:startDate]) || (![self.recordendDate
                                             isEqualToString:endDate]))
    {
        [self.listArray removeAllObjects];
        self.ipage = 1;
    }
    self.recordstartDate = startDate;
    self.recordendDate   = endDate;
    @weakify(self);

    [GYHSAccountHttpTool getCustomAccountDetailListWithBusinessType:@"0"
                                                            accType:@"10410"
                                                           dateFlag:@""
                                                          startDate:startDate
                                                            endDate:endDate
                                                        currentPage:[NSString stringWithFormat:@"%d", self.ipage]
                                                           pageSize:@"10"
                                                            success:^(id responsObject) {
        @strongify(self);
        [self.tempArray removeAllObjects];
        NSArray *array = responsObject[GYNetWorkDataKey];
        for (NSDictionary *dic in array)
        {
            GYHSCompanyPointDetailModel *data = [[GYHSCompanyPointDetailModel alloc] initWithDictionary:dic
                                                                                                  error:nil];

            [self.tempArray
             addObject:data];
        }

        [self.listArray
         addObjectsFromArray:self.tempArray];
        //停止下拉刷新控件动画
        [self.tableView.mj_header endRefreshing];
        //停止上拉刷新控件动画
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        if (self.tempArray.count == 0)                                                          //中间采用临时数组的好处是将页数回调整一下
        {
            self.ipage -= 1;                                                        //没有加到数组的是 页数减一
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

/**
 *  互生币账户的网络请求(以流通币为主)
 *
 *  @param dateFlag 日期
 */
- (void)hsbDetailCheck:(NSString *)dateFlag
{
    [GYNetwork sharedInstance].delegate = self;
    @weakify(self);
    [GYHSAccountHttpTool getAccountDetailListWithBusinessType:@"0"
                                                      accType:@"20110"
                                                     dateFlag:dateFlag
                                                  currentPage:[NSString stringWithFormat:@"%d", self.ipage]
                                                     pageSize:@"10"
                                                      success:^(id responsObject) {
        @strongify(self);
        [self.listArray removeAllObjects];
        NSArray *array = responsObject[GYNetWorkDataKey];
        for (NSDictionary *dic in array)
        {
            GYHSCompanyPointDetailModel *data = [[GYHSCompanyPointDetailModel alloc] initWithDictionary:dic
                                                                                                  error:nil];
            [self.listArray
             addObject:data];
        }
        [self.tableView reloadData];
        if (self.listArray.count < 10)
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
                                                      failure:^{
    }];
}

/**
 *  互生币账户的网络请求(以流通币为主)
 *
 *  @param startDate 开始日期
 *  @param endDate   结束日期
 */
- (void)hsbCustomDetailCheckStartDate:(NSString *)startDate endDate:(NSString *)endDate
{
    [GYNetwork sharedInstance].delegate = self;
    if ((![self.recordstartDate
           isEqualToString:startDate]) || (![self.recordendDate
                                             isEqualToString:endDate]))
    {
        [self.listArray removeAllObjects];
        self.ipage = 1;
    }
    self.recordstartDate = startDate;
    self.recordendDate   = endDate;
    @weakify(self);

    [GYHSAccountHttpTool getCustomAccountDetailListWithBusinessType:@"0"
                                                            accType:@"20110"
                                                           dateFlag:@""
                                                          startDate:startDate
                                                            endDate:endDate
                                                        currentPage:[NSString stringWithFormat:@"%d", self.ipage]
                                                           pageSize:@"10"
                                                            success:^(id responsObject) {
        @strongify(self);
        [self.tempArray removeAllObjects];
        NSArray *array = responsObject[GYNetWorkDataKey];
        for (NSDictionary *dic in array)
        {
            GYHSCompanyPointDetailModel *data = [[GYHSCompanyPointDetailModel alloc] initWithDictionary:dic
                                                                                                  error:nil];

            [self.tempArray
             addObject:data];
        }

        [self.listArray
         addObjectsFromArray:self.tempArray];
        //停止下拉刷新控件动画
        [self.tableView.mj_header endRefreshing];
        //停止上拉刷新控件动画
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        if (self.tempArray.count == 0)                                                          //中间采用临时数组的好处是将页数回调整一下
        {
            self.ipage -= 1;                                                        //没有加到数组的是 页数减一
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else if (self.tempArray.count < 10)
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
                                                            failure:^{
        //
    }];
}

#pragma mark - request

- (void)clickToday:(GYHSDetailCheckTimeView *)timeView
{
//    [self getTodayCheckListContent];
}

- (void)clickWeek:(GYHSDetailCheckTimeView *)timeView
{
//[self getWeekCheckListContent];
}

#pragma mark-----日期格式判断
/**
 *  点击查询按钮
 *
 *  @param timeView 时间控件视图
 */
- (void)clickCheckBtn:(GYHSDetailCheckTimeView *)timeView
{
    self.ipage = 1;
    [self.listArray removeAllObjects];
    //判断一下 是否为空
    if (self.begainField.text.length == 0)
    {
        [self.begainField tipWithContent:kLocalized(@"GYHS_Account_Date_Format_Cannot_Be_Empty") animated:YES];
        return;
    }
    if (self.endTextfield.text.length == 0)
    {
        [self.endTextfield tipWithContent:kLocalized(@"GYHS_Account_Date_Format_Cannot_Be_Empty") animated:YES];
        return;
    }

    //再判断一下时间是否大于12个月 如果大于将弹出错误提示

    NSDate *befordate              = [NSDate dateWithTimeIntervalSinceNow:-24 * 365 * 60 * 60];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];

    [dateformatter setDateFormat:kLocalized(@"YYYY-MM-dd")];

    NSString *locationStringBefore = [dateformatter stringFromDate:befordate];  //得到一年前的日期格式

    NSDate *senddate          = [NSDate date];
    NSString *locationString  = [dateformatter stringFromDate:senddate]; //目前的日期格式
    NSArray *arrayToday       = [locationString componentsSeparatedByString:@"-"];
    NSString *arrayTodayYear  = arrayToday[0];
    NSString *arrayTodayMonth = arrayToday[1];
    NSString *arrayTodayDay   = arrayToday[2];

    NSArray *arrayBefore  = [locationStringBefore componentsSeparatedByString:@"-"]; //将字符串分隔三个元素
    NSArray *arrayBeginTf = [self.begainField.text
                             componentsSeparatedByString:@"-"];
    NSArray *arrayEndTf = [self.endTextfield.text
                           componentsSeparatedByString:@"-"];


    NSString *arrayBeginTfYear = arrayBeginTf[0];
    NSString *arrayBeforeYear  = arrayBefore[0];
    NSString *arrayEndTfYear   = arrayEndTf[0];

    NSString *arrayBeginTfMonth = arrayBeginTf[1];
    NSString *arrayBeforeMonth  = arrayBefore[1];
    NSString *arrayEndTfMonth   = arrayEndTf[1];

    NSString *arrayBeginTfDay = arrayBeginTf[2];
    NSString *arrayBeforeDay  = arrayBefore[2];
    NSString *arrayEndTfDay   = arrayEndTf[2];

    if ([arrayBeginTfYear integerValue] > [arrayTodayYear integerValue] || [arrayEndTfYear integerValue] > [arrayTodayYear integerValue])
    {

        [GYUtils showToast:kLocalized(@"GYHS_Account_Query_Time_Can_Not_Exceed_The_Current_Time")];
        return;
    }
    else
    {
        if (([arrayBeginTfYear integerValue] == [arrayTodayYear integerValue] && [arrayBeginTfMonth integerValue] > [arrayTodayMonth integerValue]) || ([arrayEndTfYear integerValue] == [arrayTodayYear integerValue] && [arrayEndTfMonth integerValue] > [arrayTodayMonth integerValue]))
        {

            [GYUtils showToast:kLocalized(@"GYHS_Account_Query_Time_Can_Not_Exceed_The_Current_Time")];
            return;
        }
        else
        {
            if (([arrayBeginTfYear integerValue] == [arrayTodayYear integerValue] && [arrayBeginTfMonth integerValue] == [arrayTodayMonth integerValue] && [arrayBeginTfDay integerValue] > [arrayTodayDay integerValue]) || ([arrayEndTfYear integerValue] == [arrayTodayYear integerValue] && [arrayEndTfMonth integerValue] == [arrayTodayMonth integerValue] && [arrayEndTfDay integerValue] > [arrayTodayDay integerValue]))
            {

                [GYUtils showToast:kLocalized(@"GYHS_Account_Query_Time_Can_Not_Exceed_The_Current_Time")];
                return;
            }
        }
    }


    if ([arrayBeginTfYear integerValue] < [arrayBeforeYear integerValue] || [arrayEndTfYear integerValue] < [arrayBeforeYear integerValue])
    {

        [GYUtils showToast:kLocalized(@"GYHS_Account_Can_Not_Check_For_More_Than_12_Months")];
        return;
    }
    else
    {
        if (([arrayBeginTfYear integerValue] == [arrayBeforeYear integerValue]) && ([arrayBeginTfMonth integerValue] < [arrayBeforeMonth integerValue]))
        {

            [GYUtils showToast:kLocalized(@"GYHS_Account_Can_Not_Check_For_More_Than_12_Months")];
            return;
        }
        else
        {
            if (([arrayBeginTfYear integerValue] == [arrayBeforeYear integerValue]) && ([arrayBeginTfMonth integerValue] == [arrayBeforeMonth integerValue]) && ([arrayBeginTfDay integerValue] < [arrayBeforeDay integerValue]))
            {

                [GYUtils showToast:kLocalized(@"GYHS_Account_Can_Not_Check_For_More_Than_12_Months")];
                return;
            }
        }
    }


    if ([arrayBeginTfYear integerValue] > [arrayEndTfYear integerValue])
    {

        [GYUtils showToast:kLocalized(@"GYHS_Account_Start_Date_Cannot_Be_Greater_Than_End_Date")];
        return;
    }
    else
    {
        if (([arrayBeginTfYear integerValue] == [arrayEndTfYear integerValue]) && ([arrayBeginTfMonth integerValue] > [arrayEndTfMonth integerValue]))
        {

            [GYUtils showToast:kLocalized(@"GYHS_Account_Start_Date_Cannot_Be_Greater_Than_End_Date")];
            return;
        }
        else
        {
            if (([arrayBeginTfYear integerValue] == [arrayEndTfYear integerValue]) && ([arrayBeginTfMonth integerValue] == [arrayEndTfMonth integerValue]) && ([arrayBeginTfDay integerValue] > [arrayEndTfDay integerValue]))
            {

                [GYUtils showToast:kLocalized(@"GYHS_Account_Start_Date_Cannot_Be_Greater_Than_End_Date")];
                return;
            }
        }
    }

    [self getCustomCheckListContent];
}

/**
 *  根据数字码返回对应的汉字
 *
 *  @param businessType 事件类型数字码
 *
 *  @return 返回汉字
 */
- (NSString *)givebusinessType:(NSNumber *)businessType
{
    if ([businessType isEqualToNumber:@0])
    {
        return kLocalized(@"GYHS_Account_Total");
    }
    else if ([businessType isEqualToNumber:@1])
    {
        return kLocalized(@"GYHS_Account_Income");
    }
    else if ([businessType isEqualToNumber:@2])
    {
        return kLocalized(@"GYHS_Account_Expenditure");
    }
    else
    {
        return kLocalized(@"");
    }
}
/**
 *  拿到字典
 *
 *  @param transType 交易类型码
 *
 *  @return 字符串
 */
-(NSString*)giveTransType:(NSString*)transType{
    NSDictionary* dic = [NSDictionary dictionary];
    if (self.detailType == kPointDetailCheckType) {
         dic = [[GYHSAccountHttpTool alloc] dicHsConfig][@"conf_0"][@"transType_list"];
    }
    else if (self.detailType == kCashDetailCheckType) {
         dic = [[GYHSAccountHttpTool alloc] dicHsConfig][@"conf_1"][@"transType_list"];
    }
    else if (self.detailType == kHsbDetailCheckType) {
         dic = [[GYHSAccountHttpTool alloc] dicHsConfig][@"conf_2"][@"transType_list"];
    }
    else if (self.detailType == kInvestmentDetailCheckType) {
         dic = [[GYHSAccountHttpTool alloc] dicHsConfig][@"conf_4"][@"transType_list"];
    }
    
    
    return [dic valueForKey:transType];
    
    
}

@end
