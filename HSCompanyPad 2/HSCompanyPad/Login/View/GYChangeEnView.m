//
//  GYChangeEnView.m
//  company
//
//  Created by cook on 15/12/27.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYChangeEnView.h"

static NSString* const GYTableViewCellID = @"GYChangeEnView";

@interface GYChangeEnView () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray* arr;
    GYLoginEn* ln;
    EMLoginEn lineTurns;
}
@end

@implementation GYChangeEnView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        ln = [GYLoginEn sharedInstance];
        //设置顺序
        lineTurns = [GYLoginEn getInitLoginLine];
        
        arr = [@[
            @[ @"开发环境", @(kLoginEn_dev) ],
            @[ @"测试环境A", @(kLoginEn_testA) ],
            @[@"测试环境B",@(kLoginEn_testB)],
            @[ @"测试环境(真实支付)", @(kLoginEn_test_realPay) ],
            @[ @"演示环境", @(kLoginEn_demo) ],
            @[ @"预生产环境", @(kLoginEn_preRelease) ],
            @[ @"生产环境", @(kLoginEn_release) ],
        ] mutableCopy];
        
        [arr addObject:@[ @"声明：本设置面板只限内部使用.", @(-2) ]];
        //设置默认的电商
        
        UITableView* tableView = [[UITableView alloc] initWithFrame:self.bounds];
        [self addSubview:tableView];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableFooterView = [[UIView alloc] init];
    }
    
    return self;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger row = indexPath.row;
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:GYTableViewCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:GYTableViewCellID];
    }
    NSString* text = arr[row][0];
    EMLoginEn l = [arr[row][1] integerValue];
    
    cell.textLabel.text = text;
    if ((NSInteger)l >= 0) {
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
        [cell.textLabel setTextColor:kGray868695];
        if (ln.loginLine == l) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else
            [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    else {
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.textLabel setTextColor:[UIColor orangeColor]];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    EMLoginEn l = [arr[row][1] integerValue];
    if ((NSInteger)l < -1) {
        return;
    }
    
    ln.loginLine = l;
    
//        [kDefaultNotificationCenter postNotificationName:GYChangeLoginEnNotification object:nil];
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[ @(0.01), @(1.2), @(0.9), @(1) ];
    animation.keyTimes = @[ @(0), @(0.4), @(0.6), @(1) ];
    animation.timingFunctions = @[ [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut] ];
    animation.duration = 0.5;
    [self.layer addAnimation:animation forKey:@"bouce"];
    [self removeFromSuperview];
    
}



@end
