//
//  GYHDPopMoreView.m
//  HSConsumer
//
//  Created by shiang on 16/4/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDPopMoreView.h"
#import "GYHDMessageCenter.h"

@interface GYHDPopMoreView () <UITableViewDataSource, UITableViewDelegate>
/**
 *  下拉选项
 */
@property (nonatomic, weak) UITableView* showTableView;

@property (nonatomic, weak) UIImageView* showImageView;
@end

@implementation GYHDPopMoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];

    UIImageView* showImageView = [[UIImageView alloc] init];
    showImageView.userInteractionEnabled = YES;
    showImageView.image = [UIImage imageNamed:@"gyhd_pop_right_bg"];
    [self addSubview:showImageView];
    _showImageView = showImageView;

    UITableView* showTableView = [[UITableView alloc] init];
    showTableView.dataSource = self;
    showTableView.delegate = self;
    showTableView.scrollEnabled = NO;
    [showTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"popMoreCellID"];
    [showImageView addSubview:showTableView];
    _showTableView = showTableView;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.moreSelectArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"popMoreCellID"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = self.moreSelectArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    WS(weakSelf);
    if (_block) {
        _block(weakSelf.moreSelectArray[indexPath.row]);
        [weakSelf disMiss];
    }
}

- (void)show
{
    UIWindow* window = [UIApplication sharedApplication].windows.lastObject;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
}

- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
    [self disMiss];
}

- (void)disMiss
{
    [self removeFromSuperview];
}

- (void)setMoreSelectArray:(NSArray*)moreSelectArray
{
    _moreSelectArray = moreSelectArray;
    [self.showTableView reloadData];

    [self.showImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(64);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(44*moreSelectArray.count+10);
        make.width.mas_equalTo(150);
    }];
    [self.showTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(-10);
    }];
}

@end
