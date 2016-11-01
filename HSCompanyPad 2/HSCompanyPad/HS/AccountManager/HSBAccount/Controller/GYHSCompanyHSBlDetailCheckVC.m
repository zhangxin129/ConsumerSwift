//
//  GYHSCompanyHSBlDetailCheckVC.m
//
//  Created by 吴文超 on 16/8/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSCompanyHSBlDetailCheckVC.h"
#import "GYHSDetailCheckListView.h"  //小标题列举
#import "GYHSDetailCheckTimeView.h"  //设置时间查询
#import "GYHSGeneralDetailCheckCell.h" //下面的通用单元格
#import "GYHSHSBTopPartView.h"  //最上面的两个部分的选择
#import "GYHSAccountHttpTool.h"
#import "GYHSCompanyPointDetailModel.h"
#import "GYAlertShowDataWithOKButtonView.h"
#import "GYHSPublicMethod.h"
#import <GYKit/GYRefreshFooter.h>
#import <GYKit/GYRefreshHeader.h>
#define kCheckViewHeight  kDeviceProportion(50)
#define kTimeViewHeight kDeviceProportion(36)
#define kListMenuHeight  kDeviceProportion(41)
#define kMenuMargin  kDeviceProportion(10)
#define kTimeViewMargin  kDeviceProportion(20)
#define kSperationHeight kDeviceProportion(12)
#define kRemoveNoMessage 1233

typedef NS_ENUM (NSUInteger, kAcountKindCheck)
{
    kCirculationCoinCheckType   = 1, //流通币明细
    kCharityReliefFundCheckType = 2  //慈善救助基金明细
};
@interface GYHSCompanyHSBlDetailCheckVC ()<UITableViewDelegate, UITableViewDataSource, GYHSHSBTopPartViewDelegate, GYHSDetailCheckTimeViewChangeDelegate,GYNetworkReloadDelete>
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, weak) GYHSDetailCheckListView *listMenu;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) kAcountKindCheck checkType;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, assign) int ipage;
@property (nonatomic, copy) NSString *recordstartDate;
@property (nonatomic, copy) NSString *recordendDate;
@property (nonatomic, weak)  GYHSCunsumeTextField *begainField;
@property (nonatomic, weak)  GYHSCunsumeTextField *endTextfield;
@property (nonatomic, assign) NSInteger keepIndex;
@end

@implementation GYHSCompanyHSBlDetailCheckVC

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
 *  按照默认进入方式进行首先布置
 */
- (void)initView
{
    self.title                                = kLocalized(@"GYHS_Account_Detail_Query");
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.view.backgroundColor                            = kWhiteFFFFFF;
    self.navigationController.navigationBar.barTintColor = kBlue0A59C2;

    self.checkType = kCirculationCoinCheckType;
    self.keepIndex = 1;
    GYHSHSBTopPartView *checkView = [[GYHSHSBTopPartView alloc]initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kCheckViewHeight)];
    checkView.delegate = self;
    UIColor *checkColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kLocalized(@"gyhs_point_fold1")]];
    checkView.backgroundColor = checkColor;
    [self.view
     addSubview:checkView];


    UIView *viewtest   = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(checkView.frame), kScreenWidth, kTimeViewHeight + kSperationHeight)];
    UIColor *testColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kLocalized(@"gyhs_point_fold2")]];
    viewtest.backgroundColor = testColor;
    [self.view
     addSubview:viewtest];
    //此处添加了时间选择器
    GYHSDetailCheckTimeView *timeView = [[GYHSDetailCheckTimeView alloc]initWithFrame:CGRectMake(0, -kSperationHeight * 0.5, kScreenWidth, kTimeViewHeight)];
    [timeView setCommonUI];
    timeView.delegate = self;

    [viewtest addSubview:timeView];
    self.begainField     = timeView.begainField;
    self.endTextfield    = timeView.endTextfield;
    self.recordstartDate = self.begainField.text;
    self.recordendDate   = self.endTextfield.text;

    //子标题菜单
    GYHSDetailCheckListView *listMenu = [[GYHSDetailCheckListView alloc]initWithFrame:CGRectMake(kMenuMargin, CGRectGetMaxY(viewtest.frame), kScreenWidth - 2 * kMenuMargin, kListMenuHeight)];
    UIColor *menuColor                = [UIColor colorWithPatternImage:[UIImage imageNamed:kLocalized(@"gyhs_point_fold3")]];
    listMenu.backgroundColor = menuColor;
    [self.view
     addSubview:listMenu];
    self.listMenu = listMenu;
    [self.listMenu setFiveCommonTitle];


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
    self.ipage = 1;
    [self hsbDetailCheck:kLocalized(@"today")];
    [self setupRefresh];
}

#pragma mark - event

#pragma mark 添加刷新控件
/**
 *  刷新控件
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

- (void)headerRereshing
{
    self.ipage = 1;
    [self.listArray removeAllObjects];
    [self.tempArray removeAllObjects];

    [self getNewData];
}

- (void)footerRereshing
{
    self.ipage += 1;
    [self getNewData];
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
        viewC.frame = self.tableView.frame;
        
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
    GYHSCompanyPointDetailModel *data = self.listArray[indexPath.row];
    
    
    return [cell createNeedCustomWithFiveLabels:data.transDate
                                         string:[self givebusinessType:data.businessType]
                                         string:[GYUtils formatCurrencyStyle:[data.amount doubleValue]]
                                         string:[GYUtils formatCurrencyStyle:[data.accBalanceNew doubleValue]]
                                         string:[self giveTransType:data.transType]];
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

#pragma mark - request
/**
 *  上面流通币和慈善两个按钮的轮换点击
 *
 *  @param index 按钮的tag值
 */
- (void)click:(NSInteger)index
{
    if (index == 1)
    {
        _checkType = kCirculationCoinCheckType; //流通币情况
    }
    else
    {
        _checkType = kCharityReliefFundCheckType;  //慈善救助基金
    }

    if (index == self.keepIndex)
    {
        return;
    }
    else
    {
        self.keepIndex = index;
        [self.listArray removeAllObjects];
        [self getNewData];
    }
}

/**
 *  流通币下的网络请求
 *
 *  @param dateFlag 日期标识
 */
- (void)hsbDetailCheck:(NSString *)dateFlag
{
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
 *  根据参数(数字码)来确定返回什么汉字
 *
 *  @param businessType 商务类型对应的数字码
 *
 *  @return 返回需要的汉字
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
        return @"";
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
  NSDictionary* dic = [[GYHSAccountHttpTool alloc] dicHsConfig][@"conf_2"][@"transType_list"];

    return [dic valueForKey:transType];
    

}





/**
 *  点击查询按钮
 *
 *  @param timeView 时间控件的视图
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

    
    NSArray *arrayBefore  = [locationStringBefore componentsSeparatedByString:@"-"];    //将字符串分隔三个元素
    NSArray *arrayBeginTf = [self.begainField.text
                             componentsSeparatedByString:@"-"];
    NSArray *arrayEndTf = [self.endTextfield.text
                           componentsSeparatedByString:@"-"];
    NSDate *senddate         = [NSDate date];
    NSString *locationString = [dateformatter stringFromDate:senddate];  //目前的日期格式
    NSArray *arrayToday      = [locationString componentsSeparatedByString:@"-"];

    NSString *arrayTodayYear  = arrayToday[0];
    NSString *arrayTodayMonth = arrayToday[1];
    NSString *arrayTodayDay   = arrayToday[2];

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


    [self getNewData];
}

/**
 *  获得新数据
 */
- (void)getNewData
{
    [GYNetwork sharedInstance].delegate = self;
    if (_checkType == kCirculationCoinCheckType)
    {
        [self ltbCustomDetailCheckStartDate:self.begainField.text
                                    endDate:self.endTextfield.text];
    }
    else
    {
        [self csCustomDetailCheckStartDate:self.begainField.text
                                   endDate:self.endTextfield.text];
    }
}
/**
 *  没有网络的加盖视图上的点击重新加载
 */
- (void)gyNetworkDidTapReloadBtn
{
    [self getNewData];
}
- (void)clickToday:(GYHSDetailCheckTimeView *)timeView
{
    
}

- (void)clickWeek:(GYHSDetailCheckTimeView *)timeView
{
    
}

/**
 *  流通币下的网络请求
 *
 *  @param startDate 开始日期
 *  @param endDate   结束日期
 */
- (void)ltbCustomDetailCheckStartDate:(NSString *)startDate endDate:(NSString *)endDate
{
    //如果时间相同 状态相同 返回 //否则数据刷新更新
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

        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
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

/**
 *  慈善标题下的网络请求
 *
 *  @param startDate 开始日期
 *  @param endDate   结束日期
 */
- (void)csCustomDetailCheckStartDate:(NSString *)startDate endDate:(NSString *)endDate
{
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
                                                            accType:@"20130"
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

        [self.tableView.mj_header endRefreshing];
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

@end
