//
//  GYHSPointCheckVC.m
//
//  Created by apple on 16/7/29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPointCheckVC.h"
#import "GYHSCodeReaderViewController.h"
#import "GYHSConsumeListCell.h"
#import "GYHSCunsumeTextField.h"
#import "GYHSPointCheckModel.h"
#import "GYHSPointCheckView.h"
#import "GYHSPointHttpTool.h"
#import "GYHSPointListView.h"
#import "GYHSPointTimeView.h"
#import "GYHSPublicMethod.h"
#import <GYKit/GYRefreshFooter.h>
#import <GYKit/GYRefreshHeader.h>
#import <BlocksKit/BlocksKit+UIKit.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <YYKit/YYTextKeyboardManager.h>
#define kCheckViewHeight kDeviceProportion(50)
#define kTimeViewHeight kDeviceProportion(48)
#define kListMenuHeight kDeviceProportion(41)
#define kMenuMargin kDeviceProportion(10)
#define kTimeViewMargin kDeviceProportion(20)
#define kRemoveNoMessage 1233
static const NSString* identiferCell = @"GYHSConsumeListCell";
@interface GYHSPointCheckVC () <GYHSCheckDelegate, GYHSPointTimeDelegate, UITableViewDelegate, UITableViewDataSource, GYHSCodeReaderDelegate>
@property (nonatomic, strong) NSArray* array;
@property (nonatomic, weak) GYHSPointListView* listMenu;
@property (nonatomic, weak) GYHSPointTimeView* timeView;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, copy) NSString* perResNO; //互生号
@property (nonatomic, copy) NSString* startDate; //开始日期
@property (nonatomic, copy) NSString* endDate; //结束日期
@property (nonatomic, copy) NSString* queryType; //查询类型
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) BOOL isDown;
@end

@implementation GYHSPointCheckVC

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

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(kLocalized(@"GYHS_Point_Point_Notes"));
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = kBlue0A59C2;

    GYHSPointCheckView* checkView = [[GYHSPointCheckView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kCheckViewHeight)];
    checkView.delegate = self;
    UIColor* checkColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gyhs_point_fold1"]];
    checkView.backgroundColor = checkColor;
    [self.view addSubview:checkView];
    
    GYHSPointTimeView* timeView = [[GYHSPointTimeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(checkView.frame), kScreenWidth, kTimeViewHeight)];
    UIColor* timeColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gyhs_point_fold2"]];
    timeView.backgroundColor = timeColor;
    timeView.delegate = self;
    [self.view addSubview:timeView];
    self.timeView = timeView;
    
    GYHSPointListView* listMenu = [[GYHSPointListView alloc] initWithFrame:CGRectMake(kMenuMargin, CGRectGetMaxY(timeView.frame), kScreenWidth - 2 * kMenuMargin, kListMenuHeight)];
    UIColor* menuColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gyhs_point_fold3"]];
    listMenu.backgroundColor = menuColor;
    [self.view addSubview:listMenu];
    self.listMenu = listMenu;
    self.checkType = kPointCheckPoint;
    
    [self.view addSubview:self.tableView];
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.left.equalTo(self.view).offset(kMenuMargin * 2);
        make.right.equalTo(self.view).offset(-kMenuMargin * 2);
        make.top.equalTo(self.view).offset(CGRectGetMaxY(self.listMenu.frame));
        make.bottom.equalTo(self.view).offset(-kMenuMargin * 2);
    }];
}

#pragma mark - GYHSCheckDelegate
- (void)click:(NSInteger)index
{

    self.checkType = index;
}

#pragma mark - GYHSPointTimeDelegate
- (void)checkWithPerNo:(NSString*)perResNO startDate:(NSString*)startDate endDate:(NSString*)endDate
{
    self.perResNO = perResNO;
    self.startDate = startDate;
    self.endDate = endDate;
    if (!self.tableView.mj_header) {
        [self addRefreshView];
    }
    else {
        self.page = 1;
        self.pageSize = 10;
        [self requestWithperResNO:self.perResNO startDate:self.startDate endDate:self.endDate queryType:self.queryType];
    }
}

- (void)getScanWithNumber
{
    //扫一扫
    GYHSCodeReaderViewController* codeReaderVC = [[GYHSCodeReaderViewController alloc] init];
    codeReaderVC.modalPresentationStyle = UIModalPresentationFormSheet;
    codeReaderVC.delegate = self;
    [self.navigationController pushViewController:codeReaderVC animated:YES];
}

#pragma mark - GYHSCodeReaderDelegate
- (void)reader:(GYHSCodeReaderViewController*)reader didScanResult:(NSString*)result
{
    if (result.length >= 14 && [result hasPrefix:@"ID&"] && [GYUtils isHSCardNo:[result substringWithRange:NSMakeRange(3, 11)]]) {
        NSString* cardNumber = [result substringWithRange:NSMakeRange(3, 11)];
        self.timeView.cardField.text = cardNumber;
        [reader.navigationController popViewControllerAnimated:YES];
    }
    else {
        [reader startScanning];
    }
}

#pragma mark - 查询类别
- (void)setCheckType:(kPointCheck)checkType
{
    if (_checkType != checkType) {
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        _checkType = checkType;
        switch (_checkType) {
        case kPointCheckPoint:
            self.array = @[ kLocalized(@"GYHS_Point_Trade_Time"), kLocalized(@"GYHS_Point_Consumer_Card"), kLocalized(@"GYHS_Point_Real_Cash"), kLocalized(@"GYHS_Point_Point_Rate"), kLocalized(@"GYHS_Point_Point_Cash"), kLocalized(@"GYHS_Point_Remark") ];
            self.listMenu.array = self.array;
            self.queryType = @"1";
            break;
        case kPointCheckCancel:
            self.array = @[ kLocalized(@"GYHS_Point_Trade_Time"), kLocalized(@"GYHS_Point_Consumer_Card"), kLocalized(@"GYHS_Point_Real_Cash"), kLocalized(@"GYHS_Point_Point_Cash"), kLocalized(@"GYHS_Point_Cancel_Cash"), kLocalized(@"GYHS_Point_Point_Cash_Return") ];
            self.listMenu.array = self.array;
            self.queryType = @"3";
            break;
        case kPointCheckReturn:
            self.array = @[ kLocalized(@"GYHS_Point_Trade_Time"), kLocalized(@"GYHS_Point_Consumer_Card"), kLocalized(@"GYHS_Point_Real_Cash"), kLocalized(@"GYHS_Point_Point_Cash"), kLocalized(@"GYHS_Point_Return_Cash"), kLocalized(@"GYHS_Point_Point_Cash_Return") ];
            self.listMenu.array = self.array;
            self.queryType = @"2";
            break;
            
        default:
            break;
        }
        self.startDate = self.timeView.begainField.text;
        self.endDate = self.timeView.endTextfield.text;
        self.perResNO = self.timeView.cardField.text;
        if (self.perResNO.length != 11 || !self.startDate) {
            return;
        }
        if (!self.tableView.mj_header) {
            [self addRefreshView];
        }
        else {
            self.page = 1;
            self.pageSize = 10;
            [self requestWithperResNO:self.perResNO startDate:self.startDate endDate:self.endDate queryType:self.queryType];
        }
    }
}

#pragma mark -refresh
- (void)addRefreshView
{
    self.page = 1;
    self.pageSize = 10;
    
    @weakify(self);
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.isDown = YES;
        self.page = 1;
        [self requestWithperResNO:self.perResNO startDate:self.startDate endDate:self.endDate queryType:self.queryType];
        
    }];
    
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.isDown = NO;
        self.page++;
        [self requestWithperResNO:self.perResNO startDate:self.startDate endDate:self.endDate queryType:self.queryType];
    }];
    
    self.tableView.mj_footer = footer;
}

- (void)endRefresh
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - request
- (void)requestWithperResNO:(NSString*)perResNO startDate:(NSString*)startDate endDate:(NSString*)endDate queryType:(NSString*)queryType
{
    [GYHSPointHttpTool pointQueryWithEntResNo:globalData.loginModel.entResNo
        perResNo:perResNO
        startDate:startDate
        endDate:endDate
        queryType:queryType
        curPage:[@(self.page) stringValue]
        pageSize:[@(self.pageSize) stringValue]
        success:^(id responsObject) {
            if (self.isDown) {
                [self.dataArray removeAllObjects];
            }
            if (responsObject[GYNetWorkDataKey]) {
                NSArray* array = responsObject[GYNetWorkDataKey];
                for (NSDictionary* temp in array) {
                    GYHSPointCheckModel* model = [[GYHSPointCheckModel alloc] initWithDictionary:temp error:nil];
                    model.checkType = self.checkType;
                    [self.dataArray addObject:model];
                }
            }
            [self.tableView reloadData];
            [self endRefresh];
            NSInteger totalPage = [responsObject[@"totalPage"] integerValue];
            if (self.page >= totalPage) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        failure:^{
            [self endRefresh];
        }];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    UIView* view = [self.view viewWithTag:kRemoveNoMessage];
    if (view) {
        [view removeFromSuperview];
    }
    if (self.dataArray.count == 0) {
        UIView *viewC = [GYHSPublicMethod addNoDataTipViewWithSuperView:self.view];
        viewC.frame = CGRectMake(kDeviceProportion(20), kDeviceProportion(183), kDeviceProportion(984), kDeviceProportion(468));
        @weakify(self);
        [viewC mas_makeConstraints:^(MASConstraintMaker* make) {
            @strongify(self);
            make.left.equalTo(self.view).offset(kMenuMargin * 2);
            make.right.equalTo(self.view).offset(-kMenuMargin * 2);
            make.top.equalTo(self.view).offset(CGRectGetMaxY(self.listMenu.frame));
            make.bottom.equalTo(self.view).offset(-kMenuMargin * 2);
        }];
        
        viewC.tag = kRemoveNoMessage;
    }
    self.tableView.mj_footer.hidden = self.dataArray.count < 1;
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHSConsumeListCell* cell = [tableView dequeueReusableCellWithIdentifier:consumeListCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - viewDidLayoutSubviews
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.customBorderType = UIViewCustomBorderTypeRight | UIViewCustomBorderTypeLeft;
}

#pragma mark - lazy load
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSConsumeListCell class]) bundle:nil] forCellReuseIdentifier:consumeListCell];
    }
    return _tableView;
}

- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
