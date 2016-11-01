//
//  GYProvinceChooseViewController.m
//  HSConsumer
//
//  Created by apple on 15-4-8.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYProvinceChooseViewController.h"
#import "GYProvinceChooseModel.h"

@interface GYProvinceChooseViewController ()
@property (nonatomic, weak) UITableView* tableView;
@end

@implementation GYProvinceChooseViewController

+(GYProvinceChooseViewController *)shareInstance {
    static GYProvinceChooseViewController *province ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        province = [[GYProvinceChooseViewController alloc ] init];
    });
    return province;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = kLocalized(@"GYHE_SurroundVisit_SelectProvince");
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

    [self loadData];
}

-(void)loadData {
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"stateLists"];
    if (!data) {
        [self saveData];
    }
    else {
        self.marrDatasource = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        GYProvinceChooseModel* model = self.marrDatasource[0];
        if (model.areaName == nil) {
            [self.marrDatasource removeAllObjects];
            [self saveData];
        }
    }
}

- (void)saveData
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"stateLists" ofType:@"txt"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    for (NSDictionary* objDic in dict[@"data"]) {
        GYProvinceChooseModel* model = [[GYProvinceChooseModel alloc] initWithDictionary:objDic error:nil];
        [self.marrDatasource addObject:model];
    }
    NSData* provinceData = [NSKeyedArchiver archivedDataWithRootObject:self.marrDatasource];
    [[NSUserDefaults standardUserDefaults] setObject:provinceData forKey:@"stateLists"];
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
    GYProvinceChooseModel* pModel = nil;
    if (self.marrDatasource .count > indexPath.row) {
        pModel = self.marrDatasource[indexPath.row];
    }
    cell.textLabel.text = pModel.areaName;
    cell.textLabel.textColor = kCellItemTitleColor;
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYProvinceChooseModel* cityModel = nil;
    if (self.marrDatasource.count > indexPath.row) {
        cityModel = self.marrDatasource[indexPath.row];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(selectOneProvince:)]) {
        [_delegate selectOneProvince:cityModel];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma private method
-(NSString *)queryProvinceCodePassProvinceName:(NSString *)provinceName {
    [self loadData];
    for (GYProvinceChooseModel *model in self.marrDatasource) {
        if([provinceName isEqualToString:model.areaName]) {
            return model.areaCode;
        }
    }
    return nil;
}

-(NSMutableArray *)marrDatasource {

    if(_marrDatasource == nil) {
        _marrDatasource = [NSMutableArray array];
    }
    return _marrDatasource;
}

@end
