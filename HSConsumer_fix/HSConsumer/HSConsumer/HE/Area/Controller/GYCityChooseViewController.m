//
//  GYCityChooseViewController.m
//  HSConsumer
//
//  Created by apple on 15-4-8.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYCityChooseViewController.h"
#import "GYCityChooseModel.h"
#import "GYProvinceChooseViewController.h"

@interface GYCityChooseViewController ()
@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, copy) NSString* parentCode;

@end

@implementation GYCityChooseViewController

+(GYCityChooseViewController *)shareInstance {
    static GYCityChooseViewController *cityVC ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cityVC = [[GYCityChooseViewController alloc] init];
    });
    return cityVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kLocalized(@"GYHE_SurroundVisit_SelectCity");

    self.parentCode = [[GYProvinceChooseViewController shareInstance] queryProvinceCodePassProvinceName:self.parentName];
    
    [self loadData];

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
    [self.tableView reloadData];
}

-(void)loadData {
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityLists"];
    if (!data) {
        [self saveData];
    }
    else {
        NSArray* arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        GYCityChooseModel* model = arr[0];
        if (model.areaName == nil) {
            [self saveData];
        }
        else {
            
            if(self.parentCode == nil && self.isUnderProvinceSelected == NO) {
                for (GYCityChooseModel *model in arr) {
                    //self.marrDatasource 在当前的国家的所有城市
                    [self.marrDatasource addObject:model];
                }
            }else {
                for (GYCityChooseModel* model in arr) {
                    if ([self.parentCode isEqualToString:model.parentCode]) {
                        //self.marrDatasource 在某个省份下的所有城市
                        [self.marrDatasource addObject:model];
                    }
                }
            }
            
        }
    }
}

- (void)saveData
{

    NSString* path = [[NSBundle mainBundle] pathForResource:@"cityLists" ofType:@"txt"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray* cityMarr = [NSMutableArray array];
    for (NSDictionary* objDic in dict[@"data"]) {
        GYCityChooseModel* model = [[GYCityChooseModel alloc] initWithDictionary:objDic error:nil];
        [cityMarr addObject:model];
        
        if(self.parentCode == nil) {
            [self.marrDatasource addObject:model];
        }else {
            if ([self.parentCode isEqualToString:objDic[@"parentCode"]]) {
                [self.marrDatasource addObject:model];
            }
        }
        
        
    }
    NSData* provinceData = [NSKeyedArchiver archivedDataWithRootObject:cityMarr];
    [[NSUserDefaults standardUserDefaults] setObject:provinceData forKey:@"cityLists"];
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

    GYCityChooseModel* cityModel = nil;
    if (self.marrDatasource.count > indexPath.row) {
        cityModel = self.marrDatasource[indexPath.row];
    }
    cell.textLabel.text = cityModel.areaName;

    cell.textLabel.textColor = kCellItemTitleColor;

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYCityChooseModel* cityModel = nil;
    if (self.marrDatasource.count > indexPath.row) {
        cityModel = self.marrDatasource[indexPath.row];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(selectOneCity:)]) {
        [_delegate selectOneCity:cityModel];
        [self.navigationController popViewControllerAnimated:YES];
    }

}

#pragma mark - private method 
-(NSString *)queryCityCodePassCityName:(NSString *)cityName {
    [self loadData];
    for (GYCityChooseModel *model in self.marrDatasource) {
        if([cityName isEqualToString:model.areaName]) {
            return model.areaCode;
        }
    }
    return nil;
}

-(NSMutableArray *)marrDatasource {

    if(_marrDatasource == nil) {
        _marrDatasource = [[NSMutableArray alloc] init];
    }
    return _marrDatasource;
}

@end
