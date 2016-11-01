//
//  GYEPMyOrderViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kPageSize 10
#define kCellSubCellHeight 115.f

#import "GYEPMyOrderViewController.h"

#import "ViewHeaderForMyOrder.h"
#import "ViewFooterForMyOrder.h"
#import "CellForMyOrderCell.h"
#import "ViewTipBkgView.h"
#import "GYEasybuyMainViewController.h"

#import "GYGIFHUD.h"
@interface GYEPMyOrderViewController () <UITableViewDataSource, UITableViewDelegate> {
    ViewTipBkgView* viewTipBkg;

    int pageSize; //每次/每页获取多少行记录
    int pageNo; //下一页
    ViewTipBkgView* viewTipBkg1;
}
@property (nonatomic, weak) UITableView* tableView;
// add by songjk 记录通知传来的nsnumber
@property (nonatomic, copy) NSString* strNumber;

@end

@implementation GYEPMyOrderViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //        _isQueryRefundRecord = NO;
        _orderState = kOrderStateAll;
        _firstTipsErr = NO;
        _startPageNo = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    pageSize = kPageSize;
    pageNo = _startPageNo;
    //注册通知
    NSString* strNotificationName = [kNotificationNameRefreshOrderList stringByAppendingString:[@(self.orderState) stringValue]];
    DDLogDebug(@"strNotificationName = %@", strNotificationName);
    // modify by songjk
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:strNotificationName object:nil];

    //售后申请后接受通知刷新页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"refreshAfterSaleListNotification" object:nil];

    if (self.navigationController) //用于传下一界面
        self.nav = self.navigationController;

    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    viewTipBkg = [[ViewTipBkgView alloc] init];
    [viewTipBkg setFrame:self.tableView.frame];

    if (self.isSaleAfter == YES) {

        if (self.isQueryRefundRecord == YES) {
            [viewTipBkg.lbTip setText:kLocalized(@"GYHE_MyHE_YouHaveNoReturnRecord")]; //退货
        }
        else {
            [viewTipBkg.lbTip setText:kLocalized(@"GYHE_MyHE_YouHaveNoRelevantOrderRecord")]; //申请售后
        }
    }
    else {

        [viewTipBkg.lbTip setText:@"您还没有相关订单记录！"]; //购物订单
    }

    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    tableView.backgroundColor = kDefaultVCBackgroundColor;
    self.tableView.backgroundColor = kDefaultVCBackgroundColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.tableFooterView = [[UIView alloc] init];

    [self.tableView registerClass:[CellForMyOrderCell class] forCellReuseIdentifier:kCellForMyOrderCellIdentifier];

    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    __weak __typeof(self) wself = self;
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        __strong GYEPMyOrderViewController *sself = wself;
        [sself headerRereshing];
    }];

    //单例 调用刷新图片
    self.tableView.mj_header = header;

    [self getMyOrderlistIsAppendResult:NO andShowHUD:YES];
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        __strong GYEPMyOrderViewController *sself = wself;
        [sself footerRereshing];
    }];

    //设定表格视图 头部 尾部
    self.tableView.mj_footer = footer;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //只有返回首页才隐藏NavigationBarHidden
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) { //返回
        if ([self.navigationController.topViewController isKindOfClass:[GYEasybuyMainViewController class]]) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            ;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // [self headerRereshing];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrResult count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger row = indexPath.row;
    static NSString* cellid = kCellForMyOrderCellIdentifier;
    CellForMyOrderCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath]; //使用此方法加载，必须先注册nib或class
    if (!cell) {
        cell = [[CellForMyOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        DDLogDebug(@"init load detail:%d", (int)row);
    }
    // add by songjk 改变付款状态
    NSMutableDictionary* dictData = [NSMutableDictionary dictionaryWithDictionary:self.arrResult[row]];
    NSString* orderNum = [dictData objectForKey:@"number"];
    if (self.strNumber && [self.strNumber isEqualToString:orderNum]) {
        [dictData setValue:@"1" forKey:@"status"];
    }

    NSInteger subRows = [self.arrResult[row][@"items"] count];
    cell.cellSubCellRowHeight = kCellSubCellHeight;
    //    [cell.tableView setUserInteractionEnabled:NO];
    cell.tableView.frame = CGRectMake(0,
        0,
        kScreenWidth,
        [ViewFooterForMyOrder getHeight] +
            [ViewHeaderForMyOrder getHeight] + subRows * kCellSubCellHeight);
    cell.dicDataSource = dictData;
    if (self.isSaleAfter) {

        cell.isSaleAfter = YES;
    }
    cell.nav = self.nav;
    cell.isQueryRefundRecord = self.isQueryRefundRecord;
    cell.delegate = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell reloadData];//表格嵌套，复用须 reloaddata，否则无法更新数据
    });

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [ViewFooterForMyOrder getHeight] +
        [ViewHeaderForMyOrder getHeight] +
        [self.arrResult[indexPath.row][@"items"] count] * kCellSubCellHeight + kDefaultMarginToBounds;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{

    DDLogDebug(@"%@-----datasource", self.arrResult[indexPath.row]);

    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    if (indexPath.section == 0) return;
    //
    //    NSArray *arrAcc = self.arrResult[indexPath.section];
    //    NSString *nextVCName = arrAcc[indexPath.row][kKeyNextVcName];
    //    NSString *nextVCTitle = arrAcc[indexPath.row][kKeyAccName];
    //        UIViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYEPOrderDetailViewController class]));
    //        vc.navigationItem.title = kLocalized(@"");
    //        if (vc)
    //        {
    //            [self pushVC:vc animated:YES];
    //        }
}

#pragma mark - pushVC
- (void)pushVC:(id)vc animated:(BOOL)ani
{
    if (self.nav) {

        [self.nav pushViewController:vc animated:ani];
    }
}

// add by songjk 刷新通知  用于银联付款
- (void)refreshData:(NSNotification*)sender
{
    self.strNumber = [sender object];
    DDLogDebug(@"strNumber = %@", self.strNumber);
    pageNo = _startPageNo;
    [self.tableView.mj_footer resetNoMoreData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getMyOrderlistIsAppendResult:NO andShowHUD:NO];
    });
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    //    pageSize = kPageSize;
    pageNo = _startPageNo;
    [self.tableView.mj_footer resetNoMoreData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getMyOrderlistIsAppendResult:NO andShowHUD:NO];
    });
}

- (void)getMyOrderlistIsAppendResult:(BOOL)append andShowHUD:(BOOL)isShow
{
    GlobalData* data = globalData;
    NSString* sUrl = EasyBuyGetMyOrderUrl;
    NSMutableDictionary* allParas = [@{ @"key" : data.loginModel.token,
        @"count" : [@(pageSize) stringValue],
        @"currentPage" : [@(pageNo) stringValue] } mutableCopy];
    if (self.isQueryRefundRecord) {
        sUrl = EasyBuyGetRefundRecordUrl;
    }
    else {
        if (self.orderState != kOrderStateAll) {
            if (self.orderState == kOrderStateWaittingConfirmReceiving) {
                [allParas setObject:[NSString stringWithFormat:@"%ld,%ld", self.orderState, kOrderStateSellerWaittingPayConfirm] forKey:@"status"];
            }
            else if (self.orderState == kOrderStateWaittingDelivery) {
                [allParas setObject:[NSString stringWithFormat:@"%ld,%ld", kOrderStateHasPay, self.orderState] forKey:@"status"];
            }
            else {
                [allParas setObject:[@(self.orderState) stringValue] forKey:@"status"];
            }
        }
        else {
            [allParas setObject:@"" forKey:@"status"];
        }
    }
    if (isShow)
        [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc]initWithBlock:sUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        
        if (!append) {
            if (self.arrResult && self.arrResult.count > 0) {
                [self.arrResult removeAllObjects];
                self.arrResult = nil;
            }
            self.arrResult = [NSMutableArray array];
        }
        BOOL hasNext = NO;
        if (!error) {
            NSDictionary *dic = responseObject;
            if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode) {  //返回成功数据
                NSInteger totalPage = kSaftToNSInteger(dic[@"totalPage"]);
                //                    self.arrResult =  dic[@"data"];
                if (dic[@"data"] && [dic[@"data"] isKindOfClass:[NSArray class]]) {
                    [self.arrResult addObjectsFromArray:dic[@"data"]];
                    // add by songjk 待付款刷新付款之后数据
                    if (self.orderState == kOrderStateWaittingPay) {
                        for (NSDictionary *dict in self.arrResult) {
                            NSString *strNumber = [dict objectForKey:@"number"];
                            if (self.strNumber && [strNumber isEqualToString:self.strNumber]) {
                                [self.arrResult removeObject:dict];
                                break;
                            }
                        }
                    }
                } else {
                    [self.arrResult addObjectsFromArray:@[]];
                }
                pageNo++;
                if (pageNo <= totalPage) {
                    hasNext = YES;
                }
            }
            
        } else {
            [GYUtils showToast:kLocalized(@"GYHE_MyHE_NetworkError") ];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.firstTipsErr = YES;
            
            if ([self.arrResult isKindOfClass:[NSNull class]]) {//{"currentPageIndex":null,"data":null,"msg":null,"retCode":200,"rows":null,"totalPage":null}
                self.arrResult = nil;
            }
            self.tableView.mj_footer.hidden = (self.arrResult && self.arrResult.count > 0 ? NO : YES);
            if (self.tableView.mj_footer.hidden) {
                self.tableView.tableFooterView = viewTipBkg;
            } else {
                self.tableView.tableFooterView = nil;
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (!hasNext) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];//必须要放在reload后面
            }
            [GYGIFHUD dismiss];
        });
    }];
    [request start];
}

- (void)footerRereshing {
    [self getMyOrderlistIsAppendResult:YES andShowHUD:NO];
}

- (void)dealloc {
    DDLogDebug(@"dealloc:%@", [self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
