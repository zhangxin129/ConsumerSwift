//
//  GYEasybuyEvaluationListViewController.m
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/4/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEasybuyEvaluationListViewController.h"
#import "GYEasybuyEvaluationCell.h"
#import "JSONModel+ResponseObject.h"
#import "GYNetRequest.h"
#import "GYEasybuyEvaluationCell.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "UIView+CustomBorder.h"
#import "GYHEUtil.h"

#define kGYEasybuyEvaluationCell @"GYEasybuyEvaluationCell"

@interface GYEasybuyEvaluationListViewController () <UITableViewDataSource, UITableViewDelegate, GYNetRequestDelegate>

@property (nonatomic, strong) UIView* notFoundView;
@property (weak, nonatomic) IBOutlet UITableView* tabView;
@property (nonatomic, strong) NSMutableArray* dataArray;

@property (copy, nonatomic) NSString* count;
@property (copy, nonatomic) NSString* currentPage;

@end

@implementation GYEasybuyEvaluationListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tabView.tableFooterView = [[UIView alloc] init];
    _count = @"8";
    _currentPage = @"1";

    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYEasybuyEvaluationCell class]) bundle:nil] forCellReuseIdentifier:kGYEasybuyEvaluationCell];
    [self refresh];
    [self requestData];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    GYEasybuyEvaluationCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYEasybuyEvaluationCell];
    if (cell == nil) {
        cell = [[GYEasybuyEvaluationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYEasybuyEvaluationCell];
        //设置你的cell
    }
    if(self.dataArray.count > indexPath.row) {
        cell.model = self.dataArray[indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(self.dataArray.count > indexPath.row) {
        GYEasybuyEvaluationModel* model = self.dataArray[indexPath.row];
        
        CGRect rect = [model.content boundingRectWithSize:CGSizeMake(kScreenWidth - 23, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:15] } context:nil];
        return 80 + rect.size.height;
    }
    return 0;
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{

    NSArray* arr = [GYEasybuyEvaluationModel modelArrayWithResponseObject:responseObject error:nil];

    if (arr.count == 0) {
        [self.tabView.mj_header endRefreshing];
        self.tabView.mj_footer.hidden = YES;
        [self notFound];
    }
    else {
        self.tabView.mj_footer.hidden = NO;

        if ([self.tabView.mj_header isRefreshing]) {
            [self.tabView.mj_header endRefreshing];
            self.dataArray = arr.mutableCopy;
        }
        if ([self.tabView.mj_footer isRefreshing]) {
            [self.tabView.mj_footer endRefreshing];
            [self.dataArray addObjectsFromArray:arr];
        }
        [_tabView reloadData];
    }

    //如果为最后一页，显示已经加载全部
    if ([responseObject[@"totalPage"] intValue] == [responseObject[@"currentPageIndex"] intValue]) {
        [self.tabView.mj_footer endRefreshingWithNoMoreData];
    }
    else {
        [self.tabView.mj_footer resetNoMoreData];
    }
}

- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}

#pragma mark - 自定义方法
- (void)refresh
{
    WS(weakSelf);
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = @"1";
        [weakSelf requestData];
    }];
    self.tabView.mj_header = header;
    [self.tabView.mj_header beginRefreshing];

    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage = [NSString stringWithFormat:@"%d", [weakSelf.currentPage intValue]+1];
        [weakSelf requestData];
    }];
    [footer addTopBorder];
    self.tabView.mj_footer = footer;
}

- (void)requestData
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:_itemId forKey:@"itemID"];
    [dict setValue:_count forKey:@"count"];
    [dict setValue:_currentPage forKey:@"currentPage"];
    [dict setValue:_status forKey:@"status"];

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:GetEvaluationInfoUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    [request start];
}

- (void)notFound
{
    [self.view addSubview:self.notFoundView];
    WS(weakSelf);
    [self.notFoundView mas_makeConstraints:^(MASConstraintMaker* make) {

        make.centerX.equalTo(weakSelf.view);
        make.top.mas_equalTo(120);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
}

- (NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (UIView*)notFoundView
{
    if (!_notFoundView) {
        _notFoundView = [[UIView alloc] init];

        UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gycommon_search_norecord"]];
        UILabel* lab = [[UILabel alloc] init];
        lab.text = kLocalized(@"GYHE_Easybuy_no_evaluation");
        lab.textColor = [UIColor lightGrayColor];

        [_notFoundView addSubview:imgView];
        WS(weakSelf);
        [imgView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.height.mas_equalTo(60);
            make.width.mas_equalTo(50);
            make.centerX.equalTo(weakSelf.notFoundView);
            make.top.mas_equalTo(0);
        }];
        [_notFoundView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerX.equalTo(weakSelf.notFoundView);
            make.top.mas_equalTo(80);
        }];
    }
    return _notFoundView;
}

@end
