//
//  GYHEDynamicMenuViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/10/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEDynamicMenuViewController.h"
#import "GYHEVisitListCell.h"
#import "GYHEVisitListModel.h"
#import "GYHECollectionGoodCell.h"
#import "GYHECollectListModel.h"

#define kGYHETakeawayListCellIdentifier @"GYHEVisitListCell"
#define kGYHECollectionGoodCellIdentifier @"GYHECollectionGoodCell"
#define kEachPageSizeStr 2
@interface GYHEDynamicMenuViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *listTableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isUpFresh;//是否刷新

@property (nonatomic, assign) int totalPage;//总共页数

@property (nonatomic, assign) int currentPageIndexStr;//当前页数
@end

@implementation GYHEDynamicMenuViewController
#pragma mark -- The life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self initUI];
    [self requestData];
    [self creatHeaderRefresh];
    [self creatFootReresh];
}
-(void)initUI
{
    [self.view addSubview:self.listTableView];
    //初始化当前页数为1
    _currentPageIndexStr = 1;
    _totalPage = 3;
}
-(void)setNav
{
    //左侧返回图标
    UIImageView* leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    leftImage.contentMode = UIViewContentModeScaleAspectFit;
    leftImage.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapSetting = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backClickBtn)];
    [leftImage addGestureRecognizer:tapSetting];
    UIBarButtonItem* leftBackBtn = [[UIBarButtonItem alloc] initWithCustomView:leftImage];
    self.navigationItem.leftBarButtonItem = leftBackBtn;
   
//    UIImageView* searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
//    searchImage.contentMode = UIViewContentModeScaleAspectFit;
//    searchImage.userInteractionEnabled = YES;
//    UITapGestureRecognizer* tapRightMessage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchClickBtn)];
//    [searchImage addGestureRecognizer:tapRightMessage];
//    UIBarButtonItem* rightMessageBtn = [[UIBarButtonItem alloc] initWithCustomView:searchImage];
//    self.navigationItem.rightBarButtonItem = rightMessageBtn;

    switch (self.entranceType) {
        case GYEntranceVisitSurroundType:
        {
           leftImage.image = [UIImage imageNamed:@"gycommon_nav_back"];
           //searchImage.image = [UIImage imageNamed:@"gyhe_search_white"];
           self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
        }
        break;
        case GYEntranceEasyBuyType:
        {
           leftImage.image = [UIImage imageNamed:@"gyhe_orange_right"];
           //searchImage.image = [UIImage imageNamed:@"gyhe_search_orange"];
           self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor orangeColor]}];
        }
        break;
        default:
            break;
    }
    switch (self.dynamicMenuType) {
        case GYVisitRecordType:
        {
             self.title = @"光顾纪录";
        }
        break;
        case GYFocuStoreType:
        {
            self.title = @"关注店铺";
        }
        break;
        case GYCollectionGoodsType:
        {
            self.title = @"收藏商品";
        }
        break;
        case GYBrowseRecordsType:
        {
            self.title = @"浏览记录";
        }
        break;
        default:
            break;
    }
    
}
#pragma mark -- 返回
-(void)backClickBtn
{
    NSLog(@"返回按钮点击");
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 搜索
-(void)searchClickBtn
{
   
}
#pragma mark --privateMark
-(void)creatHeaderRefresh
{
    WS(weakSelf);
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        __strong GYHEDynamicMenuViewController *sself = weakSelf;
        [sself headerRereshing];
    }];
    //单例 调用刷新图片
    self.listTableView.mj_header = header;
    
}
-(void)creatFootReresh
{
    WS(weakSelf);
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        __strong GYHEDynamicMenuViewController *sself = weakSelf;
        [sself footerRereshing];
    }];
    self.listTableView.mj_footer = footer;
}
//开始进入刷新状态
-(void)headerRereshing
{
    _isUpFresh = YES;
    _currentPageIndexStr = 1;
    //开始网络请求
    [self requestData];
}

-(void)footerRereshing
{
    _isUpFresh = NO;
    if (_currentPageIndexStr < _totalPage) {
        _currentPageIndexStr += 1;
        //开始网络请求
        [self requestData];
    }
}

-(void)requestData
{
    NSLog(@"请求网络数据");
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"1" forKey:@"currentPageIndex"];
    [dict setValue:@"10" forKey:@"pageSize"];
    NSString *strUrl;
    NSInteger dataType;
    switch (self.dynamicMenuType) {
        case GYVisitRecordType:      //光顾纪录
        {
            if (self.entranceType == GYEntranceEasyBuyType) { //轻松购  商品
               strUrl = kgetFavoriteItemListUrl;
                dataType = 1;
            }else{                                            //周边逛  商铺
               strUrl = kfindBrowseVshopListUrl;
                 dataType = 2;
            }
        }
        break;
        case GYFocuStoreType:        //关注商铺
        {
            strUrl = kgetFavoriteShopListUrl;
             dataType = 2;
        }
            break;
        case GYCollectionGoodsType:  //收藏商品
        {
            strUrl = kgetFavoriteItemListUrl;
            dataType = 1;
        }
            break;
        case GYBrowseRecordsType:    //浏览记录
        {
            if (self.entranceType == GYEntranceEasyBuyType) { //轻松购  商品
                strUrl = kfindBrowseItemListUrl;
                dataType = 1;
            }else{                                            //周边逛  商铺
                
                strUrl = kfindBrowseVshopListUrl;
                 dataType = 2;
            }
        }
        break;
        default:
            break;
    }

    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:strUrl parameters:dict requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return;
        }
        if (_isUpFresh) {
            [self.dataArry removeAllObjects];
        }
        if (dataType == 1) {//商品模型
            if (_currentPageIndexStr > 1) {//请求数据源
                for (NSInteger i = 0; i < kEachPageSizeStr; i++) {
                    for (NSDictionary *dic in responseObject[@"data"]) {
                        GYHECollectListModel *model = [[GYHECollectListModel alloc] initWithDictionary:dic error:nil];
                        
                        [self.dataArry addObject:model];
                    }
                }
            }else{//数据源重新刷新
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GYHECollectListModel *model = [[GYHECollectListModel alloc] initWithDictionary:dic error:nil];
                   
                    [self.dataArry addObject:model];
                }
            }
        }else{  // 商铺模型
            if (_currentPageIndexStr > 1) {//请求数据源
                
                    for (NSDictionary *dic in responseObject[@"data"]) {
                        GYHEVisitListModel *model = [[GYHEVisitListModel alloc] initWithDictionary:dic error:nil];
                        [self.dataArry addObject:model];
                    }
                
            }else{//数据源重新刷新
                
                
                    for (NSDictionary *dic in responseObject[@"data"]) {
                        GYHEVisitListModel *model = [[GYHEVisitListModel alloc] initWithDictionary:dic error:nil];
                        [self.dataArry addObject:model];
                    }
                
            }
        }
        [self.listTableView reloadData];
        if (_currentPageIndexStr < _totalPage) {
            [self.listTableView.mj_header endRefreshing];
            [self.listTableView.mj_footer endRefreshing];
        }
        else {
            [self.listTableView.mj_header endRefreshing];
            [self.listTableView.mj_footer endRefreshing];
            [self.listTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    [request commonParams:[GYUtils netWorkHECommonParams]];
    [request start];
}

#pragma mark --UItableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.entranceType) {
        case GYEntranceVisitSurroundType:
        {
            if (self.dynamicMenuType == GYCollectionGoodsType) {
                GYHECollectionGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHECollectionGoodCellIdentifier];
                if (!cell) {
                    cell = [[GYHECollectionGoodCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHECollectionGoodCellIdentifier];
                }
                [cell setModel:self.dataArray[indexPath.row]];
                return cell;
            }
            GYHEVisitListCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHETakeawayListCellIdentifier];
            if (!cell) {
                cell = [[GYHEVisitListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHETakeawayListCellIdentifier];
            }
            [cell setModel:self.dataArray[indexPath.row]];
            return cell;
        }
        break;
        case GYEntranceEasyBuyType:
        {
            if (self.dynamicMenuType == GYFocuStoreType) {
                GYHEVisitListCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHETakeawayListCellIdentifier];
                if (!cell) {
                    cell = [[GYHEVisitListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHETakeawayListCellIdentifier];
                }
                [cell setModel:self.dataArray[indexPath.row]];
                return cell;
            }
            GYHECollectionGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHECollectionGoodCellIdentifier];
            if (!cell) {
                cell = [[GYHECollectionGoodCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHECollectionGoodCellIdentifier];
            }
            [cell setModel:self.dataArray[indexPath.row]];
            return cell;
        }
            break;
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择了=====%ld",(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
       return @"删除";
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark --lazy mark
-(UITableView *)listTableView
{
    if (!_listTableView) {
        _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.rowHeight = 140;
        _listTableView.backgroundColor = kDefaultVCBackgroundColor;
        [_listTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEVisitListCell class]) bundle:nil] forCellReuseIdentifier:kGYHETakeawayListCellIdentifier];
        [_listTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHECollectionGoodCell class]) bundle:nil] forCellReuseIdentifier:kGYHECollectionGoodCellIdentifier];
       
    }
    return _listTableView;
}
-(NSMutableArray *)dataArry
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
