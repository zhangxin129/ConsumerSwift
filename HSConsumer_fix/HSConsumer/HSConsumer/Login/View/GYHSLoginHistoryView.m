//
//  GYHSLoginHistoryView.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSLoginHistoryView.h"
#import "GYHSLoginHistoryTableCell.h"
#import "GYHSLoginHistoryModel.h"
#import "GYHSConstant.h"
#define kGYHSLoginHistoryViewBorder 5
#define kGYHSLoginHistoryViewCellHeight 44
#define kGYHSLoginHistoryViewTableViewY (20 + 44)
#define kGYHSLoginHistoryTableCellIdentify @"kGYHSLoginHistoryTableCellIdentify"

@interface GYHSLoginHistoryView () <UITableViewDelegate, UITableViewDataSource, GYHSLoginHistoryTableCellDelegate>

@property (nonatomic, strong) UIView* superView;
@property (nonatomic, strong) UIView* backView;
@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) NSMutableArray* dataArray;

@end

@implementation GYHSLoginHistoryView

#pragma mark - public methods
- (instancetype)initWithView:(UIView*)view dataArray:(NSArray*)dataArray
{

    CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);

    if (self = [super initWithFrame:frame]) {
        self.superView = view;
        self.backgroundColor = [UIColor clearColor];
        [self.superView addSubview:self];

        self.backView = [[UIView alloc] initWithFrame:frame];
        self.backView.backgroundColor = [UIColor clearColor];
        self.backView.alpha = 0;
        [self addSubview:self.backView];

        [self.dataArray addObjectsFromArray:dataArray];
    }

    return self;
}

- (void)show
{
    [self addSubview:self.tableView];

    if ([self.historyDelegate respondsToSelector:@selector(historyViewState:)]) {
        [self.historyDelegate historyViewState:YES];
    }

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
    [self.backView addGestureRecognizer:tap];

    [self.superView bringSubviewToFront:self];
    [UIView animateWithDuration:0 animations:^{
        self.backView.alpha = 0.3;
        self.tableView.frame = CGRectMake(0, kGYHSLoginHistoryViewTableViewY, kScreenWidth, [self tableViewHeight]);
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44.0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    GYHSLoginHistoryTableCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHSLoginHistoryTableCellIdentify];
    GYHSLoginHistoryModel* model = self.dataArray[indexPath.row];
    [cell setCellValue:model.headPic value:model.userName];
    cell.cellDelegate = self;

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHSLoginHistoryModel* model = self.dataArray[indexPath.row];

    if ([self.historyDelegate respondsToSelector:@selector(selectHSNumber:)]) {
        [self.historyDelegate selectHSNumber:model.userName];
    }

    [self closeView];
}

#pragma mark - GYHSLoginHistoryTableCellDelegate
- (void)deleteButtonAction:(NSString*)hsNumber
{
    if ([self.historyDelegate respondsToSelector:@selector(deleteHSNumber:)]) {
        [self.historyDelegate deleteHSNumber:hsNumber];
    }

    for (GYHSLoginHistoryModel* indexModel in self.dataArray) {
        if ([hsNumber isEqualToString:indexModel.userName]) {
            [self.dataArray removeObject:indexModel];
            break;
        }
    }

    self.tableView.frame = CGRectMake(0, kGYHSLoginHistoryViewTableViewY, kScreenWidth, [self tableViewHeight]);
    [self.tableView reloadData];
}

#pragma mark - private methods
- (void)closeView
{
    if ([self.historyDelegate respondsToSelector:@selector(historyViewState:)]) {
        [self.historyDelegate historyViewState:NO];
    }

    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 0);
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.frame = CGRectZero;
            [self removeFromSuperview];
        }
    }];
}

- (CGFloat)tableViewHeight
{
    CGFloat cellTotalHeight = kGYHSLoginHistoryViewCellHeight * (self.dataArray.count);
    CGFloat tmpHeight = kScreenHeight - kGYHSLoginHistoryViewBorder - kGYHSLoginHistoryViewTableViewY;

    if (cellTotalHeight > tmpHeight) {
        cellTotalHeight = tmpHeight;
    }

    return cellTotalHeight;
}

#pragma mark - getter and setter
- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }

    return _dataArray;
}

- (UITableView*)tableView
{
    if (_tableView == nil) {
        CGRect frame = CGRectMake(0, self.frame.size.height, kScreenWidth, [self tableViewHeight]);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.scrollEnabled = YES;
        [_tableView registerNib:[UINib nibWithNibName:@"GYHSLoginHistoryTableCell" bundle:nil] forCellReuseIdentifier:kGYHSLoginHistoryTableCellIdentify];
    }

    return _tableView;
}

@end
