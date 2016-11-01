
//
//  Created by cook on 15/6/19.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYTitleViewController.h"
@implementation GYTitleViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.scrollEnabled = YES;
        self.tableView.bounces = NO;
    }
    return self;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* ID = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    cell.textLabel.font = kFont32;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    return 40;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    if ([self.delegate respondsToSelector:@selector(titleViewController:didSelectedIndex:)]) {
        [_delegate titleViewController:self didSelectedIndex:(int)indexPath.row];
    }
    
}


@end
