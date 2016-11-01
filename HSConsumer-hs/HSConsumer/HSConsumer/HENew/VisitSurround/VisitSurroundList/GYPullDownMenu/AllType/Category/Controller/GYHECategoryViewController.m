//
//  GYHECategoryViewController.m
//  GYHEPullDown
//
//  Created by kuser on 16/9/23.
//  Copyright © 2016年 hsxt. All rights reserved.
//

#import "GYHECategoryViewController.h"

extern NSString * const GYUpdateMenuTitleNote;
static NSString * const categoryID = @"categoryID";
static NSString * const categoryDetailID = @"categoryDetailID";

@interface GYHECategoryViewController ()

// 分类tableView
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
// 分类详情tableView
@property (weak, nonatomic) IBOutlet UITableView *categoryDetailTableView;

@property (strong, nonatomic) NSString *selectedCategory;

@end


@implementation GYHECategoryViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.categoryTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.categoryTableView didSelectRowAtIndexPath:indexPath];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.categoryTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:categoryID];
    [self.categoryDetailTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:categoryDetailID];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.categoryTableView) {
        // 左边的类别表格 👈
        return 6;
        
    } else {
        // 右边的类别详情表格 👉
        return 9;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.categoryTableView) {
        // 左边的类别表格 👈
        UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:categoryID];
        cell.textLabel.text = [NSString stringWithFormat:@"购物%ld",(long)indexPath.row];
        return cell;
    }
    // 右边的类别详情表格 👉
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryDetailID];
    cell.textLabel.text = [NSString stringWithFormat:@"影院%ld",(long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.categoryTableView) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        // 左边的类别表格
        _selectedCategory = cell.textLabel.text;
        // 刷新右边数据
        [self.categoryDetailTableView reloadData];
        return;
    }
    // 右边的类别详情表格
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 更新菜单标题
    [[NSNotificationCenter defaultCenter] postNotificationName:GYUpdateMenuTitleNote object:self userInfo:@{@"title":cell.textLabel.text}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
