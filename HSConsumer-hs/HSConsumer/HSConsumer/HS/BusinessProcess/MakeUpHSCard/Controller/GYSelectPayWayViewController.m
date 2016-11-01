//
//  GYSelectPayWayViewController.m
//  HSConsumer
//
//  Created by 00 on 14-11-4.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSelectPayWayViewController.h"

@interface GYSelectPayWayViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITableView* tableView;
@end

@implementation GYSelectPayWayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UITableView* tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kDefaultVCBackgroundColor;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrData.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* str = @"PAYWAYCELL";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    if (self.arrData.count > indexPath.row) {
        cell.textLabel.text = self.arrData[indexPath.row];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:17.0f];
    cell.textLabel.textColor = [UIColor colorWithRed:90 / 255.0f green:90 / 255.0f blue:90 / 255.0f alpha:1.0f];
    if (indexPath.row == self.selectIndex) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(getBackPayWay:)]) {
        [_delegate getBackPayWay:(int)indexPath.row];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
