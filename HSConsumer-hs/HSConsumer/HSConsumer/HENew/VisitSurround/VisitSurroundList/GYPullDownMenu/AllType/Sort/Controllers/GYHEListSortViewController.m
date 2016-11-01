//
//  GYHEListSortViewController.m
//  GYHEPullDown
//
//  Created by kuser on 16/9/23.
//  Copyright © 2016年 hsxt. All rights reserved.
//

#import "GYHEListSortViewController.h"
#import "GYHEListCell.h"

extern NSString * const GYUpdateMenuTitleNote;
static NSString * const ID = @"cell";

@interface GYHEListSortViewController ()

@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, assign) NSInteger selectedCol;

@end

@implementation GYHEListSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    _selectedCol = 0;
    _titleArray = @[@"离我最近",@"好评优先",@"人气最高",@"积分排行"];
    [self.tableView registerClass:[GYHEListCell class] forCellReuseIdentifier:ID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedCol inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYHEListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.textLabel.text = _titleArray[indexPath.row];
    if (indexPath.row == 0) {
        [cell setSelected:YES animated:NO];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedCol = indexPath.row;
    // 选中当前
    GYHEListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 更新菜单标题
    [[NSNotificationCenter defaultCenter] postNotificationName:GYUpdateMenuTitleNote object:self userInfo:@{@"title":cell.textLabel.text}];
}
@end
