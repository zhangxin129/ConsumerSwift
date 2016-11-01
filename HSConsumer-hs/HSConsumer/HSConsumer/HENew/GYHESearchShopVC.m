//
//  GYHESearchShopVC.m
//  HSConsumer
//
//  Created by 吴文超 on 16/10/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHESearchShopVC.h"
#import "GYHEVisitListCell.h"
#import "GYHEVisitListModel.h"
//#import "GYHEListSearchViewController.h"
#import "GYPullDownMenu.h"
#import "GYMenuButton.h"
#import "GYHEListSortViewController.h"
#import "GYHENearLocationViewController.h"
#import "GYHECategoryViewController.h"
#import "GYHEMoreMenusCell.h"
#import "GYHEMoreMenusViewController.h"
#import "GYHEAroundLocationChooseController.h"
#import "GYDynamicMenuView.h"
#import "GYHEDynamicMenuViewController.h"
#import "GYHEShopDetailViewController.h"
#import "YYKit.h"
#import "GYFullScreenPopView.h"
#import "GYMapLocationViewController.h"
#import "GYHEMapSelectAddressViewController.h"

#define kGYHEVisitListCellIdentifier @"GYHEVisitListCell"
#define kEachPageSizeStr 2
@interface GYHESearchShopVC ()<UITableViewDataSource, UITableViewDelegate, GYNetRequestDelegate,GYPullDownMenuDataSource>//GYMapLocationViewControllerDelegate//GYAroundLocationChooseControllerDelegate,GYDynamicMenuViewDelegate,//,GYFullScreenPopDelegate

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)GYHEVisitListModel *model;

@property (nonatomic, assign) int currentPageIndexStr; //当前页数
@property (nonatomic, strong) NSArray *titles;         //头部标题
@property (nonatomic, strong)UILabel *locationLabel;   //定位地区
@property (nonatomic, strong)UILabel *cityLabel;       //定位城市
//
@property (nonatomic, strong) NSMutableArray *tempArray;  //临时使用数组

@end

@implementation GYHESearchShopVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
    GYPullDownMenu *menu = [[GYPullDownMenu alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, 40)];
    [self.view addSubview:menu];
    menu.dataSource = self;
    _titles = @[@"附近",@"分类",@"智能排序",@"卖家服务"];
    // 添加子控制器
    [self setupAllChildViewController];
    [self requestData];
    [self creatHeaderRefresh];
    [self creatFootReresh];
    
    
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!globalData.selectedCityCoordinate) {
        NSString*string = globalData.selectedCityAddress;
        NSArray *array = [string componentsSeparatedByString:globalData.selectedCityName];
        if (array.count < 1) {
            return;
        }
        _locationLabel.text = array.lastObject;
    }
    else {
        _locationLabel.text = globalData.locaitonAddress;
    }
}

-(void)setupAllChildViewController
{
    GYHENearLocationViewController *vc1 = [[GYHENearLocationViewController alloc]init];

    [self addChildViewController:vc1];
    GYHECategoryViewController *vc2 = [[GYHECategoryViewController alloc]init];
    [self addChildViewController:vc2];
    GYHEListSortViewController *vc3 = [[GYHEListSortViewController alloc]init];
    [self addChildViewController:vc3];
    GYHEMoreMenusViewController *vc4 = [[GYHEMoreMenusViewController alloc]init];
    [self addChildViewController:vc4];
}


#pragma mark - YZPullDownMenuDataSource
-(NSInteger)numberOfColsInMenu:(GYPullDownMenu *)pullDownMenu
{
    return 4;
}

// 返回下拉菜单每列按钮
- (UIButton *)pullDownMenu:(GYPullDownMenu *)pullDownMenu buttonForColAtIndex:(NSInteger)index
{
    GYMenuButton *button = [GYMenuButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:_titles[index] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:@"gy_he_up_arrow"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"gy_he_down_arrow"] forState:UIControlStateSelected];
    return button;
}

// 返回下拉菜单每列对应的控制器
- (UIViewController *)pullDownMenu:(GYPullDownMenu *)pullDownMenu viewControllerForColAtIndex:(NSInteger)index
{
    return self.childViewControllers[index];
}

// 返回下拉菜单每列对应的高度
- (CGFloat)pullDownMenu:(GYPullDownMenu *)pullDownMenu heightForColAtIndex:(NSInteger)index
{
    // 第1列 高度
    if (index == 0) {
        return kScreenHeight - 64 - 40 - 49;
    }
    // 第2列 高度
    if (index == 1) {
        return kScreenHeight - 64 - 40 - 49;
    }
    // 第3列 高度
    if (index == 2) {
        return 180;
    }
    // 第4列 高度
    return 90;
}

#pragma mark --UItableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYHEVisitListCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEVisitListCellIdentifier];
    
    if (!cell) {
        cell = [[GYHEVisitListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHEVisitListCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GYHEVisitListModel* model = self.dataArry[indexPath.row];
    [cell setModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择了=====%ld",(long)indexPath.row);
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    GYHEShopDetailViewController* vc = [[GYHEShopDetailViewController alloc] init];
//    if(self.dataArry.count > indexPath.row) {
//        GYHEVisitListModel *mode = self.dataArry[indexPath.row];
//        vc.vShopId = mode.vshopId;
//    }
    //传商铺id
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --privateMark
-(void)creatHeaderRefresh
{
    __weak __typeof(self) wself = self;
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        __strong GYHESearchShopVC *sself = wself;
        [sself headerRereshing];
    }];
    //单例 调用刷新图片
    self.tableView.mj_header = header;
}

-(void)creatFootReresh
{
    __weak __typeof(self) wself = self;
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        __strong GYHESearchShopVC *sself = wself;
        [sself footerRereshing];
    }];
    self.tableView.mj_footer = footer;
}

//开始进入刷新状态
-(void)headerRereshing
{
//    _isUpFresh = YES;
    [self.tempArray removeAllObjects];
    [self.dataArry removeAllObjects];
    
    _currentPageIndexStr = 1;
    //开始网络请求
    [self requestData];
}

-(void)footerRereshing
{
        _currentPageIndexStr += 1;
        //开始网络请求
        [self requestData];
   
}

-(void)requestData
{
    
    //拿到本地商铺数据
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];//@"互生"
    [dict setObject:self.searchWord
             forKey:@"vshopName"];
    [dict setObject:@(_currentPageIndexStr)
             forKey:@"currentPageIndex"];
    [dict setObject:@"10"
             forKey:@"pageSize"];
    if (globalData.selectedCityCoordinate)
    {
        [dict setObject:globalData.selectedCityCoordinate
                 forKey:@"landmark"];
    }
    else
    {
        [dict setObject:[NSString stringWithFormat:@"%f,%f", globalData.locationCoordinate.latitude, globalData.locationCoordinate.longitude]
                 forKey:@"landmark"];
    }
    WS(weakSelf);
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kshopControllerFindVShopsUrl
                                                     parameters:dict
                                                  requestMethod:GYNetRequestMethodGET
                                              requestSerializer:GYNetRequestSerializerJSON
                                                   respondBlock:^(NSDictionary *responseObject, NSError *error) {
                                                       if (error) {
                                                           DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
                                                           [GYUtils parseNetWork:error resultBlock:nil];
                                                           return;
                                                       }
                                                       
                                                       [weakSelf.tempArray removeAllObjects];
                                                       
                                                       for (NSInteger j = 0;j < [responseObject[@"data"] count]; j++) {
                                                           NSDictionary *dic = responseObject[@"data"][j];
                                                           GYHEVisitListModel *model = [[GYHEVisitListModel alloc] initWithDictionary:dic error:nil];
                                                           [weakSelf.tempArray addObject:model];
                                                       }
                                                       [weakSelf.dataArry addObjectsFromArray:weakSelf.tempArray];
                                                       
                                                       //停止下拉刷新控件动画
                                                       [weakSelf.tableView.mj_header endRefreshing];
                                                       //停止上拉刷新控件动画
                                                       [weakSelf.tableView.mj_footer endRefreshing];
                                                       
                                                       [weakSelf.tableView reloadData];
                                                       
                                                       if (weakSelf.tempArray.count == 0)                                                          //中间采用临时数组的好处是将页数回调整一下
                                                       {
                                                           self.currentPageIndexStr -= 1;                                                        //没有加到数组的时候 页数减一
                                                           [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                                       }
                                                       else if (self.tempArray.count < 10)
                                                       {
                                                           [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                                       }

                                                   }];
    [request commonParams:[GYUtils netWorkHECommonParams]];
    [request start];
    
}

-(void)initView
{
    [self.view addSubview:self.tableView];
    //初始化当前页数为1
    _currentPageIndexStr = 1;

}

#pragma mark --lazy mark
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - 40 - 60) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 140;
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        [_tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEVisitListCell class]) bundle:nil] forCellReuseIdentifier:kGYHEVisitListCellIdentifier];
    }
    return _tableView;
}

-(NSMutableArray *)dataArry
{
    if (!_dataArry) {
        _dataArry = [NSMutableArray array];
    }
    return _dataArry;
}

- (NSMutableArray *)tempArray
{
    if (!_tempArray)
    {
        _tempArray = [NSMutableArray array];
    }
    return _tempArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end




