//
//  GYHSPaymentListView.m
//  HSCompanyPad
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPaymentListView.h"
#import "GYHSPayListCell.h"
#import "GYHSPaymentCheckModel.h"
#import "GYHSPointHttpTool.h"
#import <GYKit/GYRefreshFooter.h>
#import <GYKit/GYRefreshHeader.h>
#define kLineWidth kDeviceProportion(3)
@interface GYHSPaymentListView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView* backView; //背景图
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) BOOL isDown;
@end
@implementation GYHSPaymentListView

#pragma mark - load
- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kDefaultVCBackgroundColor;
        [self setUI];
    }
    return self;
}

#pragma mark - setUI
- (void)setUI
{
    UIViewController* topVC = [self appRootViewController];
    [topVC.view addSubview:self];
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSPayListCell class]) bundle:nil] forCellReuseIdentifier:payListCell];
    [self addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark -refresh
- (void)addRefreshView:(NSString*)cardNo;
{
    self.page = 1;
    self.pageSize = 10;
    
    @weakify(self);
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.isDown = YES;
        self.page = 1;
        [self requestData:cardNo];
    }];
    
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.isDown = NO;
        self.page++;
        [self requestData:cardNo];
        
    }];
    
    self.tableView.mj_footer = footer;
}

- (void)endRefresh
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - request
- (void)requestData:(NSString*)cardNo;
{

    @weakify(self);
    [GYHSPointHttpTool searchPosEarnestWithperResNo:cardNo
        curPage:[@(self.page) stringValue]
        pageSize:[@(self.pageSize) stringValue]
        startDate:@"all"
        success:^(id responsObject) {
            @strongify(self);
            if (self.isDown) {
                [self.dataArray removeAllObjects];
            }
            if (responsObject[GYNetWorkDataKey][@"result"]) {
                NSArray* array = responsObject[GYNetWorkDataKey][@"result"];
                for (NSDictionary* temp in array) {
                    GYHSPaymentCheckModel* model = [[GYHSPaymentCheckModel alloc] initWithDictionary:temp error:nil];
                    [self.dataArray addObject:model];
                }
            }
            [self.tableView reloadData];
            [self endRefresh];
            
        }
        failure:^{
            [self endRefresh];
            
        }];
}

- (void)willMoveToSuperview:(UIView*)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    
    UIViewController* topVC = [self appRootViewController];
    
    if (!self.backView) {
        self.backView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backView.backgroundColor = [UIColor clearColor];
        self.backView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [self.backView addGestureRecognizer:tap];
    [topVC.view addSubview:self.backView];
    
    [super willMoveToSuperview:newSuperview];
}

- (void)touch
{
    self.isShow = NO;
}

#pragma mark - setter
- (void)setIsShow:(BOOL)isShow
{
    _isShow = isShow;
    if (_isShow) {
        self.backView.hidden = NO;
        self.hidden = NO;
    } else {
        self.backView.hidden = YES;
        self.hidden = YES;
    }
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHSPayListCell* cell = [tableView dequeueReusableCellWithIdentifier:payListCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHSPayListCell* cell = [tableView dequeueReusableCellWithIdentifier:payListCell];
    cell.model = self.dataArray[indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(selectPaymentModel:)]) {
        [_delegate selectPaymentModel:cell.model];
    }
    self.isShow = NO;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIViewController*)appRootViewController
{
    UIViewController* appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController* topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

@end
