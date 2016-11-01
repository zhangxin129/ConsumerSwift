//
//  FDRecomFoodViewController.m
//  HSConsumer
//
//  Created by apple on 15/12/24.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "FDRecomFoodViewController.h"
#import "FDRecomdFoodCell.h"
@interface FDRecomFoodViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView* recomFoodDetailTableView;
@property (nonatomic, strong) NSMutableArray* datas;
@end

@implementation FDRecomFoodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = kLocalized(@"GYHE_Food_RecommendedDishes");

    _datas = [NSMutableArray array];

    [self setTableView];

    [self loadData];
}

- (void)loadData
{

    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:_userKey forKey:@"userKey"];
    [params setObject:_orderId forKey:@"orderId"];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:GetFoodOrderDetailUrl
                                                     parameters:params
                                                  requestMethod:GYNetRequestMethodGET
                                              requestSerializer:GYNetRequestSerializerJSON
                                                   respondBlock:^(NSDictionary* responseObject, NSError* error) {
                                                       if (error) {
                                                           [GYUtils parseNetWork:error resultBlock:nil];
                                                           return;
                                                       }
                                                       NSDictionary* data = responseObject[@"data"];
                                                       NSArray* array = data[@"foodList"];
                                                       for (int i = 0; i < array.count; i++) {
                                                           NSDictionary* item = array[i];
                                                           FDSubmitCommitOrderDetailFoodModel* model = [[FDSubmitCommitOrderDetailFoodModel alloc] initWithDictionary:item error:nil];
                                                           [_datas addObject:model];
                                                       }
                                                       [_recomFoodDetailTableView reloadData];

                                                   }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)setTableView
{

    _recomFoodDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];

    _recomFoodDetailTableView.dataSource = self;
    _recomFoodDetailTableView.delegate = self;

    _recomFoodDetailTableView.tableFooterView = [[UIView alloc] init];

    [_recomFoodDetailTableView registerNib:[UINib nibWithNibName:@"FDRecomdFoodCell" bundle:nil] forCellReuseIdentifier:@"FDRecomdFoodCellId"];

    [self.view addSubview:_recomFoodDetailTableView];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return _datas.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    FDRecomdFoodCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FDRecomdFoodCellId"];
    FDSubmitCommitOrderDetailFoodModel* model = nil;
    if (indexPath.row < [_datas count]) {
        model = _datas[indexPath.row];
    }

    cell.model = model;

    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{

    return 100;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    FDSubmitCommitOrderDetailFoodModel* model = nil;
    if (_datas.count > indexPath.row) {
        model = _datas[indexPath.row];
    }

    if (self.myBlock) {

        _myBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
