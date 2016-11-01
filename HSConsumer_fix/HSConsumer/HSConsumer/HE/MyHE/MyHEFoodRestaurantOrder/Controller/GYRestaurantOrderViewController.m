//
//  GYRestaurantOrderViewController.m
//  HSConsumer
//
//  Created by appleliss on 15/9/23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#define orderCell @"orderCell"
#define orderOutCell @"orderOutCell"
#define IntervalX 15

#import "FDFoodModel.h"
#import "GYRestaurantOrderViewController.h"
#import "GYOrderDetailsViewController.h"
#import "FDSubmitCommitViewController.h"
#import "GYEPMyHEViewController.h"
#import "GYNoneOrderViewController.h"
#import "GYGIFHUD.h"
#import "FDSelectFoodViewController.h"
#import "GYHSLoginViewController.h"
#import "GYHDChatViewController.h"
#import "GYAlertMesView.h"
#import "GYHDMessageListViewController.h"
#import "GYAlertView.h"
#import "GYHSLoginManager.h"
#import "GYPaymentConfirmViewController.h"

@interface GYRestaurantOrderViewController () <UITableViewDataSource, UITableViewDelegate, GYNetRequestDelegate>

@property (nonatomic, strong) NSMutableArray* arr;
@property (nonatomic, strong) NSMutableArray* orderArr;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, assign) int countPage;
@property (nonatomic, weak) UIView* noView;
@property (nonatomic, strong)GYOrderModel *selectModel;

@end

@implementation GYRestaurantOrderViewController

#pragma mark - 系统方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createLeftBack];
    [self initData];
    [self createMyTableView];
    [self headerRereshing];
}

- (void)createLeftBack
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    view.backgroundColor = [UIColor clearColor];
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(backViewController) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"gycommon_nav_back"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 20, 20);
    [view addSubview:backButton];
    UITapGestureRecognizer* back = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewController)];
    back.numberOfTapsRequired = 1;
    [view addGestureRecognizer:back];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
}

- (void)createMyTableView
{
    _mytable = ({
        UITableView *tab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
        tab.backgroundColor = kDefaultVCBackgroundColor;
        tab.delegate = self;
        tab.dataSource = self;
        [tab registerNib:[UINib nibWithNibName:@"GYRecstaurantTableViewCell" bundle:kDefaultBundle] forCellReuseIdentifier:orderCell];
        [tab registerNib:[UINib nibWithNibName:@"GYRecestaurantOutCell" bundle:kDefaultBundle] forCellReuseIdentifier:orderOutCell];
        tab.separatorStyle = UITableViewCellSelectionStyleNone;
        tab;
    });
    [self.mytable addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerrereshing)];
    //    [self getMyOrderlistIsAppendResult:NO andShowHUD:YES];
    [self.mytable addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    _mytable.delegate = self;
    _mytable.dataSource = self;
    _mytable.hidden = YES;
    [self.view addSubview:_mytable];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - 自定义方法
- (void)backViewController
{
    for (UIViewController* controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[FDSelectFoodViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
        if ([controller isKindOfClass:[FDSelectFoodViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
        if ([controller isKindOfClass:[GYEPMyHEViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
        if ([controller isKindOfClass:[GYHDMessageListViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
}

- (void)initData
{
    _arr = [NSMutableArray array];
    if (![_strTyp isEqualToString:@"2"]) { ////yes 餐厅
        self.title = kLocalized(@"GYHE_MyHE_RestaurantOrders");
    }
    else {
        self.title = kLocalized(@"GYHE_MyHE_DeliveryOrders");
    }
    _pageSize = 8;
    _pageNo = 1;
    _orderArr = [NSMutableArray array];
}

#pragma mark 刷新++
- (void)headerRereshing
{
    _pageNo = 1;
    [self.mytable.mj_footer resetNoMoreData];
    [self requestData];
}

- (void)footerrereshing
{
    if (_countPage > _pageNo) {
        _pageNo += 1;
        [self requestData];
    }
    else {
        [_mytable.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark 网络请求
- (void)requestData
{
    [GYGIFHUD show];
    NSMutableDictionary* allParas = [NSMutableDictionary dictionary];
    [allParas setValue:globalData.loginModel.token forKey:@"userKey"];
    [allParas setValue:[@(_pageSize) stringValue] forKey:@"count"];
    [allParas setValue:[@(_pageNo) stringValue] forKey:@"currentPage"];
    [allParas setValue:[_strTyp isEqualToString:@"2"] ? _strTyp : @"1,3" forKey:@"type"];
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:GetFoodOrderListUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = 1400;
    [request start];
}

#pragma mark--GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    if (request.tag == 1400) {
        [GYGIFHUD dismiss];
        [self requestDatas:responseObject];
    }
    if (request.tag == 1401) {
        [GYGIFHUD dismiss];
        [self requestCancelDatas:responseObject];
    }
    if (request.tag == 1402) {
        [GYGIFHUD dismiss];
        [self requestChatData:responseObject];
    }
}

- (void)requestDatas:(NSDictionary*)responseObject
{
    NSDictionary* models = responseObject;
    if (models == nil || models[@"retCode"] == nil || models[@"data"] == nil) {
        
        [GYUtils showMessage:kLocalized(@"GYHE_MyHE_SystemBusyPleaseTryLater") confirm:^{
            
             [self backViewController];
        }];
        return;
    }
    if ([models[@"retCode"] integerValue] == 200) {
        NSArray* dicArr = models[@"data"];
        if (dicArr.count <= 0) {
            GYNoneOrderViewController* none = [[GYNoneOrderViewController alloc] init];
            none.strtitle = _strTyp;
            none.view.frame = self.view.frame;
            [self.view addSubview:none.view];
        }
        if (_orderArr.count > 0 && _pageNo == 1) {
            [_orderArr removeAllObjects];
        }
        for (int i = 0; i < dicArr.count; i++) {
            _noView.hidden = YES;
            _mytable.hidden = NO;
            GYOrderModel* model = [GYOrderModel mj_objectWithKeyValues:dicArr[i]];
            [_orderArr addObject:model];
        }
        if (dicArr.count < 8) {
            [_mytable.mj_footer endRefreshingWithNoMoreData];
            [_mytable.mj_footer endRefreshing];
        }
        _countPage = [models[@"totalPage"] intValue];
        [_mytable reloadData];
        [self.mytable.mj_header endRefreshing];
        [_mytable.mj_footer endRefreshing];
    }
    else {
        
        [GYUtils showMessage:kLocalized(@"GYHE_MyHE_SystemBusyPleaseTryLater") confirm:^{
            
        }];
    }
}

- (void)requestCancelDatas:(NSDictionary*)responseObject
{
    NSDictionary* dic = responseObject;
    if (dic == nil) {
        [GYUtils showMessage:kLocalized(@"GYHE_MyHE_SystemBusyPleaseTryLater") confirm:^{
            
        }];
        return;
    }
    if ([dic[@"retCode"] intValue] == 200) {
        //判断返回状态是否为
        NSString* strMessage;
        strMessage = kLocalized(@"GYHE_MyHE_CancelOrdersSuccess");
        
        [GYUtils showMessage:strMessage confirm:^{
            
        }];
        
     
        [self headerRereshing];
    }
    else {
        
        [GYUtils showMessage:kLocalized(@"GYHE_MyHE_CancelFail")  confirm:^{
            
        }];
        
    }
}

- (void)requestChatData:(NSDictionary*)responseObject
{
    NSDictionary* ResponseDic = responseObject;
    NSString* retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];
    if ([retCode isEqualToString:@"200"] && [ResponseDic[@"data"] isKindOfClass:[NSDictionary class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            GYHDChatViewController *chatViewController = [[GYHDChatViewController alloc] init];
            
            NSMutableDictionary *comDict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
            //1 店内，2外卖,3 自提
            NSString *type = [self.selectModel.type isEqualToString:@"2"] ?  kLocalized(@"GYHE_MyHE_DeliveryOrders") :kLocalized(@"GYHE_MyHE_RestaurantEatOrders");
            //订单类型
            NSString *orderState;
            switch ([self.selectModel.orderSate intValue]) {
                case -2:
                    orderState = kLocalized(@"GYHE_MyHE_WaitConfirm");
                    break;
                case -3:
                    orderState = kLocalized(@"GYHE_MyHE_WaitConfirm");
                    break;
                case 0:
                    orderState = kLocalized(@"GYHE_MyHE_WaitPay");
                    break;
                case 1:
                    orderState = kLocalized(@"GYHE_MyHE_WaitConfirm");
                    break;
                case 2: {
                    if ([self.selectModel.type isEqualToString:@"1"]) {
                        orderState = kLocalized(@"GYHE_MyHE_AlreadyConfirm");
                    }else {
                        orderState = kLocalized(@"GYHE_MyHE_AlreadyConfirm");
                    }
                } break;
                case 4: {
                    // 修改交易完成订单金额显示
                    orderState = kLocalized(@"GYHE_MyHE_OrderFinish");
                    
                    if ([self.selectModel.remarkStatus integerValue] == -1 || [self.selectModel.remarkStatus integerValue] == 0) {
                        
                    }
                    else {
                        orderState =  kLocalized(@"GYHE_MyHE_AlreadyEvaluate");
                    }
                } break;
                case 6:
                    orderState = kLocalized(@"GYHE_MyHE_Eating");
                    break;
                case 7:
                    orderState = kLocalized(@"GYHE_MyHE_WaitPay");
                    break;
                case 8: {
                    if ([self.selectModel.type isEqualToString:@"1"]) {
                        orderState = kLocalized(@"GYHE_MyHE_WaitConfirm");
                        
                    } else { /////自提
                        orderState = kLocalized(@"GYHE_MyHE_WaitConfirm");
                    }
                } break;
                case 9:
                    orderState = kLocalized(@"GYHE_MyHE_AlreadyConfirm");
                    break;
                case 10:
                    orderState = kLocalized(@"GYHE_MyHE_WaitShopCancel");
                    break;
                case 99:
                    orderState = kLocalized(@"GYHE_MyHE_AlreadyCanceled");
                    break;
                default:
                    break;
            }
            NSString *orderTime;
            if([GYUtils checkObjectInvalid:self.selectModel.createTime]) {
                orderTime = @"";
            }else {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
                NSTimeInterval time = [self.selectModel.createTime doubleValue]/1000;
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
                
                orderTime = [formatter stringFromDate:date];
            }
            
            
            NSString *price = [NSString stringWithFormat:@"%.2f",[self.selectModel.totalAmount doubleValue]];
            NSString *pv = [NSString stringWithFormat:@"%.2f",[self.selectModel.totalPv doubleValue]];

            
            [comDict setValue:@{
                                @"order_type":kSaftToNSString(type),
                                @"order_no":kSaftToNSString(self.selectModel.orderNumber),
                                @"order_time":kSaftToNSString(orderTime),
                                @"order_state":kSaftToNSString(orderState),
                                @"order_price":kSaftToNSString(price),
                                @"order_pv":kSaftToNSString(pv)
                                } forKey:@"orders"];
            [comDict setValue:@"" forKey:@"goods"];
            chatViewController.companyInformationDict = comDict;
            [self.navigationController pushViewController:chatViewController animated:YES];
        });
    }
    else {
        WS(weakSelf)
            [GYUtils showMessage:kLocalized(@"GYHE_MyHE_ContactFail") confirm:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
    }
}

///取消按钮
- (void)cancelRequestDataUpdateState:(GYOrderModel*)model
{
    [GYGIFHUD show];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setValue:globalData.loginModel.token forKey:@"key"];
    [dic setValue:model.userIds forKey:@"userId"];
    [dic setValue:model.orderNumber forKey:@"orderId"];
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:FoodCancelOrderUrl parameters:dic requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerHTTP];
    request.tag = 1401;
    [request start];
}

//评价与支付
- (void)payRequestDataUpdateState:(GYOrderModel*)model
{
#pragma mark 评价
    if ([model.orderSate isEqualToString:@"4"]) {
        FDSubmitCommitViewController* vc = [[FDSubmitCommitViewController alloc] initWithNibName:@"FDSubmitCommitViewController" bundle:nil];
        vc.userKey = globalData.loginModel.token;
        vc.userId = globalData.loginModel.custId;
        vc.orderId = model.orderNumber;
        vc.shopId = model.shopId;
        vc.vShopId = model.vShopId;
        vc.shopName = model.restaurantName;
        vc.isTakeaway = [model.type isEqualToString:@"2"] || [model.type isEqualToString:@"3"];
        vc.foodOrderType = kSaftToNSString(model.type);
        [self pushVC:vc animated:YES];
    }
#pragma mark 支付页面
    else {
        
        GYPaymentConfirmViewController *vc = [[GYPaymentConfirmViewController alloc] init];
        vc.paymentMode = GYPaymentModeWithFood;
        vc.orderNO = kSaftToNSString(model.orderNumber);
        vc.userId = kSaftToNSString(model.userIds);
//        vc.orderType = @"1";
        vc.orderMoney = kSaftToNSString(model.totalAmount);
        if ([model.amountActually floatValue] > 0) {
            vc.realMoney = kSaftToNSString(model.amountActually);
        }
        else {
            vc.realMoney = kSaftToNSString(model.preAmount);
        }
        vc.navigationItem.title = kLocalized(@"GYHE_MyHE_PayCinfirm");
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - failDelegate
-(void)netRequest:(GYNetRequest *)request didFailureWithError:(NSError *)error {
    
    [GYGIFHUD dismiss];
    [GYUtils parseNetWork:error resultBlock:nil];
}

#pragma mark tablview delegate
- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYOrderModel* model = nil;
    if (_orderArr.count > indexPath.row) {
        model = _orderArr[indexPath.row];
    }
    if ([cell isKindOfClass:[GYRecstaurantTableViewCell class]]) {
        GYRecstaurantTableViewCell* cellmodel = (GYRecstaurantTableViewCell*)cell;
        cellmodel.model = model;
    }
    else {
        GYRecestaurantOutCell* outCell = (GYRecestaurantOutCell*)cell;
        outCell.model = model;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _orderArr.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    // GYOrderModel *model=_orderArr[indexPath.row];
    if ([_strTyp isEqualToString:@"1"] || [_strTyp isEqualToString:@"3"]) { ////餐厅
        GYRecstaurantTableViewCell* cell = [GYRecstaurantTableViewCell cellWithTableView:tableView];
        cell.gydelegate = self;
        //cell.model=model;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else {
        GYRecestaurantOutCell* outCell = [GYRecestaurantOutCell cellWithTableView:tableView andDelegate:self];
        // outCell.model=_orderArr[indexPath.row];
        outCell.gyRecestaurantOutCellDelegate = self;
        outCell.gyRecstaurantTableViewCellDelegate = self;
        [outCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return outCell;
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYOrderDetailsViewController* vc = [[GYOrderDetailsViewController alloc] initWithNibName:@"GYOrderDetailsViewController" bundle:nil];
    GYOrderModel* mode = nil;
    if (_orderArr.count > indexPath.row) {
        mode = _orderArr[indexPath.row];
    }
    vc.orderId = mode.orderNumber;
    vc.moderType = _strTyp;
    [self pushVC:vc animated:YES];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([_strTyp isEqualToString:@"1"]) {
        GYOrderModel* mode = nil;
        if (_orderArr.count > indexPath.row) {
            mode = _orderArr[indexPath.row];
        }
        if ([mode.type isEqualToString:@"3"]) {
            return 160;
        }
        else {
            return 188;
        }
    }
    else {
        return 184;
    }
}

#pragma mark cell delegate  方法
- (void)GYRecstaurantTableViewCellshowAlart
{
    DDLogDebug(@"************");
}

- (void)GYRecstaurantTableViewCellcalorder:(GYOrderModel*)model
{
    //bug27356
    [GYAlertView showMessage:kLocalized(@"GYHE_MyHE_ReallyCancelOrder") cancleButtonTitle:kLocalized(@"GYHE_MyHE_Cancel") confirmButtonTitle:kLocalized(@"GYHE_MyHE_Confirms") cancleBlock:^{

    } confirmBlock:^{
        [self cancelRequestDataUpdateState:model];
    }];
}

- (void)GYRecstaurantTableViewCellconfirm:(GYOrderModel*)model
{
    if ([model.orderSate isEqualToString:@"4"]) {
        GYAlertMesView* alert = [[GYAlertMesView alloc] initWithTitle:@"" contentText:kLocalized(@"GYHE_MyHE_ReallyConfirmEvaluationOrder") leftButtonTitle:kLocalized(@"GYHE_MyHE_Cancel") rightButtonTitle:kLocalized(@"GYHE_MyHE_Confirm")];
        [alert show];
        alert.leftBlock = ^() {
            kLocalized(@"GYHE_MyHE_Cancel");
        };
        alert.rightBlock = ^() {
            [self payRequestDataUpdateState:model];
        };
        alert.dismissBlock = ^() {
        };
    }
    else {
        [self payRequestDataUpdateState:model];
    }
}

////外卖  确认收货
- (void)GYRecestaurantOutCellConfirm:(GYOrderModel*)model
{
    [self allDelegaterReques:FoodConfirmReceiptUrl andmodel:model andType:_strTyp];
}

#pragma mark 所有的代理 网络请求 传 代理接口 和model
- (void)allDelegaterReques:(NSString*)urlstring andmodel:(GYOrderModel*)model andType:(NSString*)strTyp
{
}

- (void)GYRecstaurantTableViewCellDelegateIMChact:(GYOrderModel*)model
{
    _selectModel = model;
    FDShopModel* shopModel = [[FDShopModel alloc] init];
    shopModel.shopId = model.shopId;
    shopModel.shopName = model.restaurantName;
    shopModel.vShopId = model.vShopId;
    shopModel.shopAddr = model.restaurantAddres;
    kCheckLogined
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSString stringWithFormat:@"%@", model.companyResourceNo] forKey:@"resourceNo"];
    [dict setValue:globalData.loginModel.token forKey:@"key"];
    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:GetVShopShortlyInfoUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    request.tag = 1402;
    [request start];
}

/// 跳转页面
- (void)pushVC:(id)vc animated:(BOOL)ani
{
    [self.navigationController pushViewController:vc animated:ani];
}

@end
