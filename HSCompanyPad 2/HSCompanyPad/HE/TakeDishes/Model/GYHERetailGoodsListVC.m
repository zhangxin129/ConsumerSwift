//
//  GYHERetailGoodsListVC.m
//
//  Created by apple on 16/8/8.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHERetailGoodsListVC.h"
#import "GYHEGoodsQueryCell.h"
#import "UILabel+Category.h"

@interface GYHERetailGoodsListVC ()<UITableViewDataSource ,UITableViewDelegate ,goodsQueryDelegate>

@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) UILabel *noDataLable;

@end

@implementation GYHERetailGoodsListVC

#pragma mark - lazy load

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDLogInfo(@"Show Controller: %@", [self class]);
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
}

// #pragma mark - SystemDelegate
// #pragma mark TableView Delegate
// #pragma mark - CustomDelegate
// #pragma mark - event response

#pragma mark - private methods
- (void)initView
{
    _listTableView = [[UITableView alloc] init];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [self.view addSubview:_listTableView];
    [_listTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEGoodsQueryCell class]) bundle:nil] forCellReuseIdentifier:@"goodsQueryCell"];
    [_listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.equalTo(@(kDeviceProportion(kScreenWidth)));
        make.height.equalTo(@(kDeviceProportion(kScreenHeight - 44 - 100 - 62)));
    }];
    
    _noDataLable = [[UILabel alloc] init];
    [_noDataLable initWithText:kLocalized(@"没有数据用于显示") TextColor:kGrayCCCCCC Font:kFont40 TextAlignment:1];
    [self.view addSubview:_noDataLable];
    [_noDataLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset((kScreenHeight - 30 - 44 - 100 - 62) / 2);
        make.left.equalTo(self.view.mas_left).offset((kScreenHeight - 160) / 2);
        make.width.equalTo(@(kDeviceProportion(160)));
        make.height.equalTo(@(kDeviceProportion(30)));
    }];
    _noDataLable.hidden = YES;
}

#pragma mark - event

#pragma mark - request

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GYHEGoodsQueryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsQueryCell" forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark - goodsQueryDelegate
- (void)stateAction{
    
}

- (void)changeAction{

}

- (void)deleteAction{
    [GYAlertView alertWithTitle:kLocalized(@"确认删除") Message:kLocalized(@"你确认删除...吗？") topColor:TopColorRed comfirmBlock:^{
        [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"删除成功!") topColor:1 comfirmBlock:^{
            
        }];
    }];
}

@end
