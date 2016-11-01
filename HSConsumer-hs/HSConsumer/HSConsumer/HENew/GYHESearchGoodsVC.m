//
//  GYHESearchGoodsVC.m
//  HSConsumer
//
//  Created by 吴文超 on 16/10/24.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHESearchGoodsVC.h"
#import "Masonry.h"
#import "GYHEShopHeaderView.h"
#import "GYHETools.h"
#import "GYHEShopSelectedView.h"
#import "GYHEShopDetailMainCell.h"
#import "GYHEShopGoodListViewController.h"
#import "GYHEShopServerListViewController.h"
#import "GYHEShopFoodListViewController.h"
#import "GYHEShopDetailFirstCell.h"
#import "GYHEShopDetailShowInfotCell1.h"
#import "GYHEShopDetailShowInfotCell2.h"
#import "GYHEShopDetailShowInfotCell3.h"
#import "GYHEShopDetailShowInfotCell4.h"
#import "GYHEShopDetailShowInfotCell5.h"
#import "GYHEShopDetailModel.h"
#import "GYHEShopDetailBusinessImgView.h"

#define kGYHEShopDetailMainCell @"GYHEShopDetailMainCell"
#define kGYHEShopDetailFirstCell @"GYHEShopDetailFirstCell"
#define kGYHEShopDetailShowInfotCell1 @"GYHEShopDetailShowInfotCell1"
#define kGYHEShopDetailShowInfotCell2 @"GYHEShopDetailShowInfotCell2"
#define kGYHEShopDetailShowInfotCell3 @"GYHEShopDetailShowInfotCell3"
#define kGYHEShopDetailShowInfotCell4 @"GYHEShopDetailShowInfotCell4"
#define kGYHEShopDetailShowInfotCell5 @"GYHEShopDetailShowInfotCell5"

#define kHeaderImgH kScreenWidth / 720 * 490
#define kHeaderImgW kScreenWidth
#define kCellH kScreenHeight - 64 - 40 - 49
#define ktabHeaderH 40
#define ktabHeaderW kScreenWidth
#define kFirstCellHeight 50
@interface GYHESearchGoodsVC ()<UITableViewDataSource,UITableViewDelegate,GYHEShopSelectedViewDelegate,UIScrollViewDelegate,GYHEShopDetailMainCellDelegate>


@property (nonatomic ,strong)UITableView *tabView;

@property (nonatomic ,strong)GYHEShopSelectedView *sectionHeader;


//商品，外卖，服务选中
@property (nonatomic , assign)NSInteger selectedIndex;

@property (nonatomic ,strong)GYHEShopDetailModel *model;





@end

@implementation GYHESearchGoodsVC
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xfb7d00);
}



#pragma mark - GYHEShopSelectedViewDelegate
//头部滑动，tabView侧滑
- (void)shopSelectedView:(GYHEShopSelectedView *)shopSelectedView selectIndex:(NSInteger)index {
    //这里要实现上部点击 下面滚动的效果
    _selectedIndex = index;
    GYHEShopDetailMainCell *cell = [_tabView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.selectIndex = index;

}
#pragma mark - GYHEShopDetailMainCellDelegate
//tabview侧滑头部一起滑动
- (void)scrollViewDidScrolled:(GYHEShopDetailMainCell *)cell withIndex:(NSInteger)index{
    _selectedIndex = index;
    _sectionHeader.selectIndex = index;

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        GYHEShopDetailMainCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEShopDetailMainCell forIndexPath:indexPath];
        
        cell.subVCsStr = @[NSStringFromClass([GYHEShopGoodListViewController class]),NSStringFromClass([GYHEShopFoodListViewController class]),NSStringFromClass([GYHEShopServerListViewController class])];
        cell.delegate = self;
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return kCellH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

        return _sectionHeader;

}



- (void)back:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 自定义方法



- (void)setUI {
    _tabView = [[UITableView alloc] init];
    _tabView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 );
    _tabView.delegate = self;
    _tabView.dataSource = self;
    
    _tabView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tabView];
    
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEShopDetailMainCell class]) bundle:nil] forCellReuseIdentifier:kGYHEShopDetailMainCell];
    

    
    
    GYHEShopSelectedView *view = [[GYHEShopSelectedView alloc] initWithFrame:CGRectMake(0, 0, ktabHeaderW, ktabHeaderH)];
    view.delegate = self;
    view.dataArr = @[kLocalized(@"商品零售"),kLocalized(@"外卖送货"),kLocalized(@"信息服务")];
    view.selectIndex = 0;
    _sectionHeader = view;
    _tabView.tableHeaderView = _sectionHeader;
    
    
}

#pragma mark -网上商城信息
- (void)getShopInformation
{
    NSMutableDictionary * paramters = [[NSMutableDictionary alloc]init];
    [paramters setValue:_vShopId forKey:@"vShopId"];
    GYNetRequest * request = [[GYNetRequest alloc]initWithBlock:kGetSalerVirtualShopsUrl parameters:paramters requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            [GYUtils parseNetWork:error resultBlock:nil];
            return;
        }
        _model = [GYHEShopDetailModel modelArrayWithResponseObject:responseObject error:nil].firstObject;
        [self refreshUI];
        
    }];
        [request commonParams:[GYUtils netWorkHECommonParams]];
    [request start];
}

- (void)requestCollectShop:(UIButton *)btn {
    NSMutableDictionary * paramters = [[NSMutableDictionary alloc]init];
    [paramters setValue:globalData.loginModel.custId forKey:@"userId"];
    [paramters setValue:_vShopId forKey:@"virtualShopId"];
    //    [paramters setValue:@"" forKey:@"shopName"];
    [paramters setValue:globalData.loginModel.cardHolder ? @"c" : @"nc" forKey:@"isCard"];
    GYNetRequest * request = [[GYNetRequest alloc]initWithBlock:kCollectShopNewUrl parameters:paramters requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            [GYUtils parseNetWork:error resultBlock:nil];
            [GYUtils showMessage:kLocalized(@"添加商城关注失败或当前商城已关注！")];
            return;
        }
        btn.selected = YES;
        [GYUtils showMessage:responseObject[@"msg"]];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)requestUnCollectionShop:(UIButton *)btn {
    NSMutableDictionary * paramters = [[NSMutableDictionary alloc]init];
    [paramters setValue:globalData.loginModel.custId forKey:@"userId"];
    [paramters setValue:_vShopId forKey:@"virtualShopId"];
    [paramters setValue:globalData.loginModel.cardHolder ? @"c" : @"nc" forKey:@"isCard"];
    GYNetRequest * request = [[GYNetRequest alloc]initWithBlock:kDeleteCollectShopNewUrl parameters:paramters requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            [GYUtils parseNetWork:error resultBlock:nil];
            
            return;
        }
        btn.selected = NO;
        [GYUtils showMessage:responseObject[@"msg"]];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
    
}

- (void)refreshUI {
    [_tabView reloadData];
}


#pragma mark - setter
@end
