//
//  GYAreaChooseViewController.m
//  HSConsumer
//
//  Created by apple on 15-4-8.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAreaChooseViewController.h"
#import "GYAreaChooseModel.h"
#import "GYCityChooseViewController.h"

@interface GYAreaChooseViewController ()
@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, copy) NSString *parentCode;
@end

@implementation GYAreaChooseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = kLocalized(@"GYHE_SurroundVisit_ChooseArea");
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    self.tableView.backgroundColor = kDefaultVCBackgroundColor;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView* headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, kScreenWidth, 15);
    self.tableView.tableHeaderView = headerView;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.parentCode = [[GYCityChooseViewController shareInstance] queryCityCodePassCityName:self.parentName];

    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"districtlist"];
    if (!data) {
        [self saveData];
    }
    else {
        NSArray* arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        GYAreaChooseModel* model = arr[0];
        if (model.areaName == nil) {
            [self saveData];
        }
        else {
            for (GYAreaChooseModel* model in arr) {
                if ([self.parentCode isEqualToString:model.parentCode]) {
                    [self.marrDatasource addObject:model];
                }
            }
        }
    }

    
}

- (void)saveData
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"districtlist" ofType:@"txt"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray* districtMarr = [NSMutableArray array];
    for (NSDictionary* objDic in dict[@"data"]) {
        GYAreaChooseModel* model = [[GYAreaChooseModel alloc] initWithDictionary:objDic error:nil];
        [districtMarr addObject:model];
        if ([self.parentCode isEqualToString:objDic[@"parentCode"]]) {
            [self.marrDatasource addObject:model];
        }
    }
    NSData* provinceData = [NSKeyedArchiver archivedDataWithRootObject:districtMarr];
    [[NSUserDefaults standardUserDefaults] setObject:provinceData forKey:@"districtlist"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark DataSourceDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.marrDatasource.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifer = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }

    GYAreaChooseModel* cityModel = nil;
    if (self.marrDatasource.count > indexPath.row) {
        cityModel = self.marrDatasource[indexPath.row];
    }
    cell.textLabel.text = cityModel.areaName;
    cell.textLabel.textColor = kCellItemTitleColor;

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYAreaChooseModel* cityModel = nil;
    if (self.marrDatasource.count > indexPath.row) {
        cityModel = self.marrDatasource[indexPath.row];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(selectOneArea:)]) {
        [_delegate selectOneArea:cityModel];
        [self.navigationController popViewControllerAnimated:YES];
    }

}

-(NSMutableArray *)marrDatasource {

    if(_marrDatasource == nil) {
        _marrDatasource = [NSMutableArray array];
    }
    return _marrDatasource;
}

@end
