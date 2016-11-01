//
//  GYHSChangeLoginENController.m
//  HSConsumer
//
//  Created by liangzm on 15-3-25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSChangeLoginENController.h"

#import "GYEasybuyMainViewController.h"

@interface GYHSChangeLoginENController () {

    NSMutableArray* arr;
    GYHSLoginEn* ln;
    EMLoginEn lineTurns;
}
@end

@implementation GYHSChangeLoginENController

- (void)viewDidLoad
{
    [super viewDidLoad];
    DDLogDebug(@"Load Controller: %@", [self class]);

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = kLocalized(@"GYHS_Login_SettingEnviroument");

    ln = [GYHSLoginEn sharedInstance];

    //设置顺序
    lineTurns = [GYHSLoginEn getInitLoginLine];

    arr = [@[
        @[ @"开发环境", @(kLoginEn_dev) ],
        @[ @"测试环境", @(kloginEn_test) ],
        @[ @"演示环境", @(kLoginEn_demo) ],
        @[ @"预生产环境", @(kLoginEn_is_preRelease) ],
        @[ @"生产环境", @(kLoginEn_is_release) ],
    ] mutableCopy];

    [arr addObject:@[ @"声明：本设置面板只限内部使用.", @(-2) ]];

    //设置默认的电商
    globalData.retailDomain = [ln getDefaultRetailDomain];

    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    label.text = [NSString stringWithFormat:@"版本号:%@", kAppVersion];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = kNavigationBarColor;
    self.tableView.tableFooterView = label;
}

- (void)dealloc
{
    DDLogDebug(@"dealloc Controller: %@", [self class]);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    //只有返回首页才隐藏NavigationBarHidden
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) { //用于电商
        if ([self.navigationController.topViewController isKindOfClass:[GYEasybuyMainViewController class]]) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger row = indexPath.row;

    static NSString* cid = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cid];
    }
    NSString* text = arr[row][0];
    EMLoginEn l = [arr[row][1] integerValue];

    cell.textLabel.text = text;
    if ((NSInteger)l >= 0) {
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
        [cell.textLabel setTextColor:kCellItemTitleColor];
        if (ln.loginLine == l) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    else {
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.textLabel setTextColor:kNavigationBarColor];
    }

    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{   //清除缓存
    NSData* visitdata = [NSKeyedArchiver archivedDataWithRootObject:[[NSMutableArray alloc] init]];
    [[NSUserDefaults standardUserDefaults] setObject:visitdata forKey:kKeyForVisitHistory];
    [[NSUserDefaults standardUserDefaults] setObject:[[NSDictionary alloc] init] forKey:kKeyForBrowsingHistory];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    EMLoginEn l = [arr[row][1] integerValue];
    if ((NSInteger)l < -1) {
        return;
    }

    ln.loginLine = l;
    //设置默认电商域名
    globalData.retailDomain = [[GYHSLoginEn sharedInstance] getDefaultRetailDomain];
    globalData.foodConsmerDomain = [[GYHSLoginEn sharedInstance] getFoodConsmerDomain];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
