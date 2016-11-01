//
//  FDShopDetailRecomFoodViewController.m
//  HSConsumer
//
//  Created by apple on 15/12/30.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "FDShopDetailRecomFoodViewController.h"
#import "FDRecomdFoodCell.h"
#import "FDRecomdModel.h"
@interface FDShopDetailRecomFoodViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* recomFoodDetailTableView;
@end

@implementation FDShopDetailRecomFoodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = kLocalized(@"GYHE_Food_Recommendation");

    [self setTableView];
}

- (void)setTableView
{

    _recomFoodDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];

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

    FDRecomdModel* model = nil;
    if (_datas.count > indexPath.row) {
        model = _datas[indexPath.row];
    }

    cell.recomdModel = model;

    cell.selectionStyle = 0;

    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{

    return 100;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{

    FDRecomdFoodCell* model = nil;
    if (_datas.count > indexPath.row) {
        model = _datas[indexPath.row];
    }

    //    发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recomdFood" object:model];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    // 销毁通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"recomdFood" object:nil];
}

@end
