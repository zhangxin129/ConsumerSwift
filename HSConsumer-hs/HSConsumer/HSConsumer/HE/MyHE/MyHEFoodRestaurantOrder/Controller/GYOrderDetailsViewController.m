//
//  GYOrderDetailsViewController.m
//  HSConsumer
//
//  Created by appleliss on 15/9/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#import "GYOrderDetailsViewController.h"
#import "GYAddreesCell.h"
#import "GYaddresRestaurantCell.h"
#import "GYOrderandStateCell.h"
#import "GYgreensCell.h"
#import "GYdownpaymentCell.h"
#import "FDChoosedFoodModel.h"
#import "GYNewAddressCell.h"
#import "GYRestaurantOrderViewController.h"
#import "FDSubmitCommitViewController.h"
#import "GYPayMentModel.h"
#import "FDMainViewController.h"
#import "UIButton+GYExtension.h"
#import "GYMealTimeCell.h"
#import "GYNewMoneyCell.h"
#import "GYGIFHUD.h"
#import "GYHSLoginViewController.h"
#import "GYHDChatViewController.h"
#import "GYAlertView.h"
#import "GYHSLoginManager.h"
#import "GYPaymentConfirmViewController.h"

@interface GYOrderDetailsViewController () <GYaddresRestaurantCellDelegate, GYNetRequestDelegate>

@property (nonatomic, strong) NSArray* lbtitle;
@property (nonatomic, strong) NSMutableArray* arrrequest;
@property (nonatomic, strong) NSArray* titleAll;
@property (nonatomic, strong) NSArray* titleAll2;
@property (nonatomic, strong) NSMutableArray* titleAlldata;
@property (nonatomic, strong) NSMutableArray* titleAlldata2;
@property (nonatomic, strong) NSString* companyResourceNo;
@property (nonatomic, strong) NSMutableDictionary* requestDic;
@property (nonatomic, strong) FDFoodModel* foodmodel;
@property (nonatomic, strong) FDChoosedFoodModel* foodfchoosedMOdel;
@property (nonatomic, strong) GYOrderModel* model;

@property (nonatomic, copy)NSString *createTime;

@end

@implementation GYOrderDetailsViewController

#pragma mark - 系统方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    // 国际化 add zhanx
    [self setBtnTitle];
    [self initData];
    [self initView];
    [self createBackLeftItem];
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"gycommon_nav_back"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [backButton addTarget:self action:@selector(popToSomeViewControllerAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:backButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _myTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 40);
    _paybtn.frame = CGRectMake(self.view.bounds.size.width - 70, _myTableView.bounds.size.height + 64, 70, 40);
    _cancikbtn.frame = CGRectMake(self.view.bounds.size.width - 2 * 70, _myTableView.bounds.size.height + 64, 70, 40);
}

#pragma mark - 孙秋明合并代码 通知张鑫检查
#pragma mark - 自定义方法
- (void)popToSomeViewControllerAction {
    if (self.isComeOrder) {
        UIViewController *vc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3];
        [self.navigationController popToViewController:vc animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)backController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setBtnTitle
{
    [self.cancikbtn setTitle:kLocalized(@"GYHE_MyHE_Cancel") forState:UIControlStateNormal];
    [self.paybtn setTitle:kLocalized(@"GYHE_MyHE_Pay") forState:UIControlStateNormal];
    [self.newclick setTitle:kLocalized(@"GYHE_MyHE_Cancel") forState:UIControlStateNormal];
    
    _titleAlldata = [NSMutableArray array];
    _titleAlldata2 = [NSMutableArray array];
    _arrrequest = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", nil];
}

- (void)initData
{
    [self requestData];
    [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYAddreesCell class]) bundle:kDefaultBundle] forCellReuseIdentifier:@"addressCell"];
    [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYaddresRestaurantCell class]) bundle:kDefaultBundle] forCellReuseIdentifier:@"restaurantCell"];
    [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYOrderandStateCell class]) bundle:kDefaultBundle] forCellReuseIdentifier:@"JBCell"];
    [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYgreensCell class]) bundle:kDefaultBundle] forCellReuseIdentifier:@"orderID"];
    [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYdownpaymentCell class]) bundle:kDefaultBundle] forCellReuseIdentifier:@"downpay"];
    [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYMealTimeCell class]) bundle:kDefaultBundle] forCellReuseIdentifier:@"kGYMealTimeCell"];
    [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYNewMoneyCell class]) bundle:kDefaultBundle] forCellReuseIdentifier:@"kGYNewMoneyCell"];
}

- (void)initView
{
    [_cancikbtn setTitle:kLocalized(@"GYHE_MyHE_Cancel") forState:UIControlStateNormal];
    [_paybtn setTitle:kLocalized(@"GYHE_MyHE_Pay") forState:UIControlStateNormal];
}

- (void)createBackLeftItem
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(-15, 0, 50, 20)];
    view.backgroundColor = [UIColor clearColor];
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(backController) forControlEvents:UIControlEventTouchUpInside];
    UIImage* image = [UIImage imageNamed:@"gyhe_myhe_nav_back"];
    [backButton setImage:image forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, image.size.width * 0.5, image.size.height * 0.5);
    [backButton setEnlargEdgeWithTop:30 right:30 bottom:30 left:-15];
    [view addSubview:backButton];
    UITapGestureRecognizer* back = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backController)];
    back.numberOfTapsRequired = 1;
    [view addGestureRecognizer:back];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
}

- (void)requestData
{
    [GYGIFHUD show];
    NSMutableDictionary* allParas = [NSMutableDictionary dictionary];
    [allParas setValue:globalData.loginModel.token forKey:@"userKey"];
    [allParas setValue:self.orderId forKey:@"orderId"];
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:GetFoodOrderDetailUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    request.tag = 1500;
    [request start];
}

#pragma mark--GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    if (request.tag == 1500) {
        [GYGIFHUD dismiss];
        [self requestDatas:responseObject];
    }
    if (request.tag == 1501) {
        [GYGIFHUD dismiss];
        [self requestCancelDatas:responseObject];
    }
    if (request.tag == 1502) {
        [GYGIFHUD dismiss];
        [self requestChatData:responseObject];
    }
}

- (void)requestDatas:(NSDictionary*)responseObject
{
    NSDictionary* dic = responseObject;
    if (dic == nil || [dic[@"retCode"] integerValue] != 200 || dic[@"data"] == nil) {
        
        [GYUtils showMessage:kLocalized(@"GYHE_MyHE_SystemBusyPleaseTryLater") confirm:^{
            
        }];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if ([dic[@"retCode"] integerValue] == 200 && dic[@"data"]) {
        _requestDic = [NSMutableDictionary dictionary];
        _requestDic = dic[@"data"];
        _companyResourceNo = dic[@"data"][@"companyResourceNo"];
        _model = [GYOrderModel mj_objectWithKeyValues:dic[@"data"]];
        _model.type = kSaftToNSString(dic[@"data"][@"type"]);
        _model.preAmount = kSaftToNSString(dic[@"data"][@"preAmount"]);
        self.pyModel = [[GYPayMentModel alloc] init];
        self.pyModel.amount = _model.totalAmount;
        self.pyModel.preAmount = [NSString stringWithFormat:@"%0.2f", [kSaftToNSString(dic[@"data"][@"preAmount"]) floatValue]];
        self.pyModel.userId = dic[@"data"][@"userId"];
        self.pyModel.orderId = dic[@"data"][@"orderId"];
        self.pyModel.currency = globalData.custGlobalDataModel.currencyCode;
        self.pyModel.custId = globalData.loginModel.custId;
        self.pyModel.userKey = globalData.loginModel.token;
        self.pyModel.amountActually = dic[@"data"][@"amountActually"];
        if (![_moderType isEqualToString:@"2"]) {
            self.paybtn.hidden = YES;
            self.title = kLocalized(@"GYHE_MyHE_RestaurantOrders");
            _lbtitle = @[ kLocalized(@"GYHE_MyHE_OrdrNumber"), kLocalized(@"GYHE_MyHE_MakeOrderTime"), [_model.type isEqualToString:@"3"] == YES ? kLocalized(@"GYHE_MyHE_TakeTime") : kLocalized(@"GYHE_MyHE_AppointMakeTime"), kLocalized(@"GYHE_MyHE_PremarkMoney") ];
        }
        else {
            self.title = kLocalized(@"GYHE_MyHE_DeliveryOrders");
            _lbtitle = @[ kLocalized(@"GYHE_MyHE_OrdrNumber"), kLocalized(@"GYHE_MyHE_MakeOrderTime"), kLocalized(@"GYHE_MyHE_SendArriveTime") ];
        }
        NSString* typ = kSaftToNSString(dic[@"data"][@"discountType"]) != nil ? kSaftToNSString(dic[@"data"][@"discountType"]) : @"0";
        switch ([typ integerValue]) {
        case 0: {
            if (![_model.type isEqualToString:@"1"]) { //外卖与自提
                _titleAll = @[ [_model.type isEqualToString:@"2"] == YES ? kLocalized(@"GYHE_MyHE_Total") : kLocalized(@"GYHE_MyHE_OrderAmount") ];
                [_titleAlldata addObject:[NSString stringWithFormat:@"%0.2f", [_model.totalAmount floatValue] + [_model.sendPrice floatValue]]];
            }
            else { //店内
                [_titleAlldata addObject:kSaftToNSString(_model.totalAmount)]; //
                if ([_model.orderSate isEqualToString:@"7"] || [_model.orderSate isEqualToString:@"4"] || [_model.orderSate isEqualToString:@"5"]) {
                    _titleAll = @[ kLocalized(@"GYHE_MyHE_OrderAmount"), kLocalized(@"GYHE_MyHE_OtherPayMoney") ];
                    [_titleAlldata addObject:kSaftToNSString(_model.amountOther)];
                }
                else {
                    _titleAll = @[ kLocalized(@"GYHE_MyHE_OrderAmount") ];
                }
            }
        } break;
        case 1: {
            if ([_model.orderSate isEqualToString:@"7"] || [_model.orderSate isEqualToString:@"4"] || [_model.orderSate isEqualToString:@"5"]) {
                _titleAll = @[ kLocalized(@"GYHE_MyHE_OrderAmount"), kLocalized(@"GYHE_MyHE_OtherPayMoney"), kLocalized(@"GYHE_MyHE_Rebate") ];
                [_titleAlldata addObject:[NSString stringWithFormat:@"%0.2f", [kSaftToNSString(_model.totalAmount) floatValue]]];
                [_titleAlldata addObject:[NSString stringWithFormat:@"%0.2f", [kSaftToNSString(_model.amountOther) floatValue]]]; ////特殊服务
                NSString* str = kSaftToNSString(dic[@"data"][@"couponInfo"][@"faceValue"]);
                NSString* num = kSaftToNSString(dic[@"data"][@"couponInfo"][@"num"]);
                NSString* text = kLocalized(@"GYHE_MyHE_RMBValue");
                NSString* p = kLocalized(@"GYHE_MyHE_Zhang");
                if (num == nil) {
                    [_titleAlldata addObject:@""];
                }
                else {
                    [_titleAlldata addObject:[NSString stringWithFormat:@"%@%@%@%@", str, text, num, p]];
                }
            }
            else {
                [_titleAlldata addObject:kSaftToNSString(_model.totalAmount)];
                _titleAll = @[ kLocalized(@"GYHE_MyHE_OrderAmount") ];
            }
        } break;
        case 2: {
            if ([_model.orderSate isEqualToString:@"7"] || [_model.orderSate isEqualToString:@"4"] || [_model.orderSate isEqualToString:@"5"]) {
                _titleAll = @[ kLocalized(@"GYHE_MyHE_OrderAmount"),
                    kLocalized(@"GYHE_MyHE_DiscountPrice"),
                    kLocalized(@"GYHE_MyHE_DiscountRate"),
                    kLocalized(@"GYHE_MyHE_OtherPayMoney") ];
                [_titleAlldata addObject:[NSString stringWithFormat:@"%0.2f", [kSaftToNSString(_model.totalAmount) floatValue]]];
                [_titleAlldata addObject:[NSString stringWithFormat:@"%0.2f", [kSaftToNSString(_model.amountCoupon) floatValue]]];
                [_titleAlldata addObject:[NSString stringWithFormat:@"%0.2f%%", [kSaftToNSString(_model.discountRate) floatValue] * 100]];
                [_titleAlldata addObject:[NSString stringWithFormat:@"%0.2f", [kSaftToNSString(_model.amountOther) floatValue]]];
            }
            else {
                [_titleAlldata addObject:kSaftToNSString(_model.totalAmount)];
                _titleAll = @[ kLocalized(@"GYHE_MyHE_OrderAmount") ];
            }
        } break;
        default:
            break;
        }
        // bill----------------------------
        NSString* amountActually = dic[@"data"][@"amountActually"];
        if (![GYUtils checkStringInvalid:amountActually] && [amountActually integerValue] == 0 && [dic[@"data"][@"orderStatus"] integerValue] == 7) {
            [self.paybtn removeFromSuperview];
        }
        // ----------------------------
        if ([_model.type isEqualToString:@"1"] && [_model.orderSate isEqualToString:@"0"]) {
            [_titleAlldata2 addObject:[NSString stringWithFormat:@"%0.2f", [kSaftToNSString(_model.preAmount) floatValue]]];
            _titleAll2 = @[ kLocalized(@"GYHE_MyHE_PremarkMoney") ];
            _titleAll = @[ kLocalized(@"GYHE_MyHE_OrderAmount"), kLocalized(@"GYHE_MyHE_PremarkMoney") ];
            [_titleAlldata addObject:[NSString stringWithFormat:@"%0.2f", [kSaftToNSString(_model.totalAmount) floatValue]]];
            [_titleAlldata addObject:[NSString stringWithFormat:@"%0.2f", [kSaftToNSString(_model.preAmount) floatValue]]];
            [_arrrequest removeAllObjects];
            [_arrrequest addObject:kSaftToNSString(dic[@"data"][@"orderId"])];
        }
        else {
            _titleAll2 = @[ kLocalized(@"GYHE_MyHE_PremarkMoney"), kLocalized(@"GYHE_MyHE_ShouldPayMoney") ];
            [_titleAlldata2 addObject:[NSString stringWithFormat:@"%0.2f", [kSaftToNSString(_model.preAmount) floatValue]]];
            [_titleAlldata2 addObject:[NSString stringWithFormat:@"%0.2f", [kSaftToNSString(_model.amountActually) floatValue]]];
            [_arrrequest removeAllObjects];
            [_arrrequest addObject:kSaftToNSString(dic[@"data"][@"orderId"])];
        }
        NSString* string = dic[@"data"][@"createTime"];
        string = [string substringWithRange:NSMakeRange(0, 16)];
        [_arrrequest addObject:kSaftToNSString(string)];
        _createTime = kSaftToNSString(string);
        [_arrrequest addObject:kSaftToNSString(dic[@"data"][@"planTime"])];
        
        [_myTableView reloadData];
    }
    else {
        
        [GYUtils showMessage:kLocalized(@"GYHE_MyHE_SystemBusyPleaseTryLater") confirm:^{
            
        }];
        
        [self backController];
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
            NSString *type = [self.model.type isEqualToString:@"2"] ?  kLocalized(@"GYHE_MyHE_DeliveryOrders") :kLocalized(@"GYHE_MyHE_RestaurantEatOrders");
            //订单类型
            NSString *orderState;
            switch ([_model.orderSate intValue]) {
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
                    if ([_model.type isEqualToString:@"1"]) {
                        orderState = kLocalized(@"GYHE_MyHE_AlreadyConfirm");
                    }else {
                        orderState = kLocalized(@"GYHE_MyHE_AlreadyConfirm");
                    }
                } break;
                case 4: {
                    // 修改交易完成订单金额显示
                    orderState = kLocalized(@"GYHE_MyHE_OrderFinish");
                    
                    if ([_model.remarkStatus integerValue] == -1 || [_model.remarkStatus integerValue] == 0) {
                        
                    }
                    else {
                        orderState = kLocalized(@"GYHE_MyHE_AlreadyEvaluate");
                    }
                } break;
                case 6:
                    orderState = kLocalized(@"GYHE_MyHE_Eating");
                    break;
                case 7:
                    orderState = kLocalized(@"GYHE_MyHE_WaitPay");
                    break;
                case 8: {
                    if ([_model.type isEqualToString:@"1"]) {
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
            
            NSString *price = [NSString stringWithFormat:@"%.2f",[self.model.totalAmount doubleValue]];
            NSString *pv = [NSString stringWithFormat:@"%.2f",[self.model.totalPv doubleValue]];
            
            [comDict setValue:@{
                                @"order_type":kSaftToNSString(type),
                                @"order_no":kSaftToNSString(self.model.orderNumber),
                                @"order_time":kSaftToNSString(_createTime),
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

- (void)requestCancelDatas:(NSDictionary*)responseObject
{
    NSDictionary* dic = responseObject;
    if (dic == nil || dic[@"retCode"] == nil) {
        
        [GYUtils showMessage:kLocalized(@"GYHE_MyHE_CancelFail") confirm:^{
        }];
        return;
    }
    NSString* strMessage;
    if ([dic[@"retCode"] intValue] == 200) {
        GYRestaurantOrderViewController* orderVc = [[GYRestaurantOrderViewController alloc] init];
        orderVc.strTyp = [NSString stringWithFormat:@"%@", _model.type];
        [self pushVC:orderVc animated:YES];
        strMessage = kLocalized(@"GYHE_MyHE_CancelOrderSuccess");
    }
    else {
        strMessage = kLocalized(@"GYHE_MyHE_CancelFail");
    }
    
    [GYUtils showMessage:strMessage confirm:^{
        
    }];
}

//取消按钮
- (void)cancelRequestDataUpdateState
{
    [GYGIFHUD show];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setValue:globalData.loginModel.token forKey:@"key"];
    [dic setValue:self.pyModel.userId forKey:@"userId"];
    [dic setValue:self.pyModel.orderId forKey:@"orderId"];
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:FoodCancelOrderUrl parameters:dic requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerHTTP];
    request.tag = 1501;
    [request start];
}

#pragma mark - failDelegate
-(void)netRequest:(GYNetRequest *)request didFailureWithError:(NSError *)error {
    
    [GYGIFHUD dismiss];
    [GYUtils parseNetWork:error resultBlock:nil];
}

#pragma mark--UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{

    if (![_model.type isEqualToString:@"1"]) {
        return 5;
    }
    else {
        return 6;
    }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return 1;
    }
    else if (section == 2) {
        return 3;
    }
    else if (section == 3) {
        if ([_model.type isEqualToString:@"2"] == YES) {
            return _model.foodArr.count + 1;
        }
        else {
            return _model.foodArr.count;
        }
    }
    else if (section == 4) {
        if ([_model.orderSate isEqualToString:@"0"] || [_model.orderSate isEqualToString:@"1"] || [_model.orderSate isEqualToString:@"6"] || [_model.orderSate isEqualToString:@"99"]) {
            return 1;
        }
        else {
            return _titleAll.count;
        }
    }
    else {
        if ([_model.orderSate isEqualToString:@"4"] || [_model.orderSate isEqualToString:@"7"]) {
            return _titleAll2.count;
        }
        else {
            return 1;
        }
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        GYNewAddressCell* cell = [GYNewAddressCell cellWithTableView:tableView];
        cell.rightBtn.hidden = YES;
        AddrModel* addmodel = [[AddrModel alloc] init];
        addmodel.consignee = _model.receiverAddr;
        addmodel.mobile = self.mobile ? self.mobile : _model.tel;
        cell.addmodel = addmodel;
        if ([_model.type isEqualToString:@"2"]) {
            cell.userName.hidden = NO;
        }
        cell.imagess.hidden = YES;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else if (indexPath.section == 1) {
        static NSString* restaurantCell = @"restaurantCell";
        GYaddresRestaurantCell* cell = [tableView dequeueReusableCellWithIdentifier:restaurantCell];
        if (cell == nil) {
            cell = [[GYaddresRestaurantCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:restaurantCell];
        }
        
        CGRect fr = cell.lbaddressrestaurant.frame;
        fr.size.height = [GYUtils heightForString:_model.restaurantAddres fontSize:13 andWidth:kScreenWidth - 30] ;// + 5;
        fr.size.width = kScreenWidth - 30;
        cell.lbaddressrestaurant.frame = fr;
        cell.tel = _model.shopTel;
        cell.gyGYaddresRestaurantCellDelegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lbaddressrestaurant.text = _model.restaurantAddres;
        cell.lbaddressrestaurant.numberOfLines = 0;
        cell.lbrestaurantName.text = _model.restaurantName;
        if (_model.companyResourceNo) {
            NSString* one = [_model.companyResourceNo substringWithRange:NSMakeRange(0, 2)];
            NSString* two = [_model.companyResourceNo substringWithRange:NSMakeRange(2, 3)];
            NSString* three = [_model.companyResourceNo substringWithRange:NSMakeRange(5, 2)];
            NSString* four = [_model.companyResourceNo substringWithRange:NSMakeRange(7, 4)];
            cell.shopHSNUmber.text = [NSString stringWithFormat:@"%@ %@ %@ %@", one, two, three, four];
        }
        return cell;
    }
    else if (indexPath.section == 2) {
        static NSString* JBcell = @"JBCell";
        GYOrderandStateCell* cell = [tableView dequeueReusableCellWithIdentifier:JBcell];
        if (cell == nil) {
            cell = [[GYOrderandStateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JBcell];
        }
        if (indexPath.row > 0) {
            cell.lbOrderState.hidden = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_arrrequest.count > indexPath.row) {
            cell.lbOrder.text = _arrrequest[indexPath.row];
        }

        switch ([_model.orderSate intValue]) {
        case -3: {
            cell.lbOrderState.text = kLocalized(@"GYHE_MyHE_WaitConfirm");
            _cancikbtn.hidden = YES;
            _newclick.hidden = NO;
            _paybtn.hidden = YES;
        } break;
        case 0: {
            
            NSString *strNumber = [NSString stringWithFormat:@"%@",_model.orderSate];
            if (![strNumber isEqualToString:@"0"]) {
                cell.lbOrderState.text = kLocalized(@"GYHE_MyHE_WaitPay");
                _cancikbtn.hidden = YES;
                _paybtn.hidden = YES;
            }else{
                cell.lbOrderState.text = kLocalized(@"GYHE_MyHE_WaitPay");
                _cancikbtn.hidden = NO;
                _paybtn.hidden = NO;
            }
        } break;
        case 1: {
            cell.lbOrderState.text = kLocalized(@"GYHE_MyHE_WaitConfirm");
            _cancikbtn.hidden = YES;
            _newclick.hidden = NO;
            _paybtn.hidden = YES;
        } break;
        case 2: {
            if ([_model.type isEqualToString:@"1"]) {
                cell.lbOrderState.text = kLocalized(@"GYHE_MyHE_AlreadyConfirm");
                _paybtn.hidden = YES;
                _cancikbtn.hidden = YES;
                self.distanceBottomConstraint.constant = 0;
            }
            else if ([_model.type isEqualToString:@"3"]) {
                cell.lbOrderState.text = kLocalized(@"GYHE_MyHE_AlreadyConfirm");
                _cancikbtn.hidden = YES;
                _newclick.hidden = NO;
                _paybtn.hidden = YES;
            }
            else {
                cell.lbOrderState.text = kLocalized(@"GYHE_MyHE_AlreadyConfirm");
                _cancikbtn.hidden = YES;
                _newclick.hidden = NO;
                _paybtn.hidden = YES;
            }
        } break;
        case 4: {
            if ([_model.remarkStatus isEqualToString:@"-1"] || [_model.remarkStatus isEqualToString:@"0"]) {
                cell.lbOrderState.text = kLocalized(@"GYHE_MyHE_OrderFinish");
                [_paybtn setTitle:kLocalized(@"GYHE_MyHE_Evaluate") forState:UIControlStateNormal];
                _paybtn.tag = 4;
                _paybtn.hidden = NO;
                _cancikbtn.hidden = YES;
            }
            else {
                cell.lbOrderState.text = kLocalized(@"GYHE_MyHE_AlreadyEvaluate");
                _paybtn.hidden = YES;
                _cancikbtn.hidden = YES;
                self.distanceBottomConstraint.constant = 0;
            }
        } break;
        case 6: {
            cell.lbOrderState.text = kLocalized(@"GYHE_MyHE_Eating");
            _paybtn.hidden = YES;
            _cancikbtn.hidden = YES;
            self.distanceBottomConstraint.constant = 0;
        } break;
        case 7: {
            cell.lbOrderState.text = kLocalized(@"GYHE_MyHE_WaitPay");
            if ([_model.amountActually isEqualToString:@"0.00"]) {
                _paybtn.hidden = YES;
            }
            else {
                _paybtn.hidden = NO;
            }
            _cancikbtn.hidden = YES;

        } break;
        case 8: {
            cell.lbOrderState.text = kLocalized(@"GYHE_MyHE_WaitConfirm");
            _cancikbtn.hidden = YES;
            _newclick.hidden = NO;
            _paybtn.hidden = YES;
        } break;
        case 9: {
            cell.lbOrderState.text = kLocalized(@"GYHE_MyHE_AlreadyConfirm");
            _cancikbtn.hidden = YES;
            _paybtn.hidden = YES;
            self.distanceBottomConstraint.constant = 0;
        } break;
        case 10: {
            cell.lbOrderState.text = kLocalized(@"GYHE_MyHE_WaitShopCancel");
            _paybtn.hidden = YES;
            _cancikbtn.hidden = YES;
            self.distanceBottomConstraint.constant = 0;
        } break;
        case 11: {
            cell.lbOrderState.text = kLocalized(@"GYHE_MyHE_DeliverMeals");
            _cancikbtn.hidden = YES;
            _paybtn.hidden = YES;
            self.distanceBottomConstraint.constant = 0;
        } break;
        case 99:
            cell.lbOrderState.text = kLocalized(@"GYHE_MyHE_AlreadyCanceled");
            _cancikbtn.hidden = YES;
            _paybtn.hidden = YES;
            self.distanceBottomConstraint.constant = 0;
            break;
        default:
            break;
        }
        //_cancikbtn.frame = _paybtn.frame;
        if (_lbtitle.count > indexPath.row) {
            cell.lbTitle.text = _lbtitle[indexPath.row];
        }
        return cell;
    }
    else if (indexPath.section == 3) {
        static NSString* orderID = @"orderID";
        GYgreensCell* cell = [tableView dequeueReusableCellWithIdentifier:orderID];
        if (cell == nil) {
            cell = [[GYgreensCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderID];
        }
        NSUInteger rowCount = [self.myTableView numberOfRowsInSection:3];
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        if ([_model.type isEqualToString:@"2"] && rowCount - 1 <= indexPath.row) {
            if (![GYUtils isBlankString:_model.deliDiscount]) {
                cell.lbGreensName.text = [NSString stringWithFormat:@"%@(%@)", kLocalized(@"GYHE_MyHE_SendingPrice"), _model.deliDiscount];
            }
            else {
                cell.lbGreensName.text = [NSString stringWithFormat:@"%@", kLocalized(@"GYHE_MyHE_SendingPrice")];
            }
            CGRect lbgframe = cell.lbGreensName.frame;
            lbgframe.size.width = 200;
            cell.lbGreensName.frame = lbgframe;
            CGRect lbImge = cell.HSBImage.frame;
            lbImge.origin.x = cell.PvpointImage.frame.origin.x;
            cell.HSBImage.frame = lbImge;
            cell.lbGreensPirce.frame = cell.lbGreensPVPrice.frame;
            cell.lbGreensPirce.text = [NSString stringWithFormat:@"%0.2f", [_model.sendPrice floatValue]];
            cell.lbGreensPVPrice.hidden = YES;
            cell.PvpointImage.hidden = YES;
            cell.X.hidden = YES;
            cell.greensNum.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else {
            if (_model.foodArr.count > indexPath.row) {
                dic = _model.foodArr[indexPath.row];
            }
        }
        NSMutableDictionary* formatdic = dic[@"foodFormat"];
        NSString* string = [GYUtils isBlankString:dic[@"foodName"]] == YES ? @"" : dic[@"foodName"];
        if (![GYUtils isBlankString:formatdic[@"pVName"]]) {
            string = [NSString stringWithFormat:@"%@(%@)", string, formatdic[@"pVName"]];
        }
        if (![dic[@"itemsStatus"] integerValue] == 0) {
            cell.lbGreensName.textColor = kNavigationBarColor;
            if (string.length > 3) {
                NSString* str = [string substringToIndex:2];
                string = [str stringByAppendingString:[NSString stringWithFormat:@"...%@", kLocalized(@"GYHE_MyHE_AlreadyDelete")]];
            }
            else {
                string = [string stringByAppendingString:kLocalized(@"GYHE_MyHE_AlreadyDelete")];
            }
        }
        cell.lbGreensName.text = string;
        cell.lbGreensPirce.text = [NSString stringWithFormat:@"%0.2f", [formatdic[@"price"] floatValue]];
        cell.lbGreensPVPrice.text = [NSString stringWithFormat:@"%0.2f", [formatdic[@"auction"] floatValue]];
        cell.greensNum.text = [dic[@"foodNum"] stringValue];
        cell.X.hidden = NO;
        cell.lbGreensName.hidden = NO;
        cell.greensNum.hidden = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        static NSString* mellcell = @"kGYMealTimeCell";
        static NSString* moncell = @"kGYNewMoneyCell";
        /////////////一堆 各种 鸟毛 判断
        if ((indexPath.section == 4 && indexPath.row < 2) || indexPath.section == 5 || [_titleAll[indexPath.row] isEqualToString:kLocalized(@"GYHE_MyHE_OtherPayMoney")]) {
            GYNewMoneyCell* cell = [tableView dequeueReusableCellWithIdentifier:moncell];
            GYgreensCell* greenscell = [tableView dequeueReusableCellWithIdentifier:@"orderID"]; ///外卖用这个
            if ([_model.type isEqualToString:@"2"]) {
                if (indexPath.section == 5) {
                    if (_titleAll2.count > indexPath.row) {
                        cell.title.text = _titleAll2[indexPath.row];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else {
                    if (_titleAll.count > indexPath.row) {
                        greenscell.lbGreensName.text = _titleAll[indexPath.row];
                    }
                    if (_titleAlldata.count > indexPath.row) {
                        greenscell.lbGreensPirce.text = [NSString stringWithFormat:@"%0.2f", [_titleAlldata[indexPath.row] floatValue]];
                    }
                    greenscell.lbGreensPVPrice.text = [NSString stringWithFormat:@"%0.2f", [_model.totalPv floatValue]];
                    greenscell.X.hidden = YES;
                    greenscell.selectionStyle = UITableViewCellSelectionStyleNone;
                    greenscell.greensNum.hidden = YES;
                    return greenscell;
                }
            }
            else {
                if (indexPath.section == 5) {
                    if (_titleAll2.count > indexPath.row) {
                        cell.title.text = _titleAll2[indexPath.row];
                    }
                    if (_titleAlldata2.count > indexPath.row) {
                        cell.titleData.text = [NSString stringWithFormat:@"%0.2f", [_titleAlldata2[indexPath.row] floatValue]];
                    }
                }
                else {
                    if (_titleAll.count > indexPath.row) {
                        cell.title.text = _titleAll[indexPath.row];
                    }
                    if (_titleAlldata.count > indexPath.row) {
                        cell.titleData.text = [NSString stringWithFormat:@"%0.2f", [_titleAlldata[indexPath.row] floatValue]];
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        else {
            GYMealTimeCell* cell = [tableView dequeueReusableCellWithIdentifier:mellcell];
            if (cell == nil) {
                cell = [[GYMealTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mellcell];
            }
            if (_titleAll.count > indexPath.row) {
                cell.title.text = _titleAll[indexPath.row];
            }
            if (_titleAlldata.count > indexPath.row) {
                cell.labValue.text = _titleAlldata[indexPath.row];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if ([_model.type isEqualToString:@"2"]) {
            return 20;
        }
        else {
            return 0.1;
        }
    }
    else
        return 20;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {

        if ([_model.type isEqualToString:@"2"]) {
            return 46 + [GYUtils heightForString:_model.receiverAddr fontSize:13 andWidth:kScreenWidth - 30];
        }
        else
            return 46;
    }
    else if (indexPath.section == 1) {
        CGFloat heg = [GYUtils heightForString:_model.restaurantAddres fontSize:13 andWidth:kScreenWidth - 30];
        if (heg >= 25) {
            return 90 + heg - 25;
        }
        else {
            return 90;
        }
    }
    else
        return 44;
}

- (void)GYRecstaurantTableViewCellcalorder
{
    [GYAlertView showMessage:kLocalized(@"GYHE_MyHE_ReallyCancelOrder") cancleButtonTitle:kLocalized(@"GYHE_MyHE_Cancel") confirmButtonTitle:kLocalized(@"GYHE_MyHE_Confirms") cancleBlock:^{

    } confirmBlock:^{
        [self cancelRequestDataUpdateState];
    }];
}

#pragma mark 按钮
- (IBAction)calOrderbtn:(UIButton*)sender
{
    switch (sender.tag) {
    case 0: ///取消
    {
        [self GYRecstaurantTableViewCellcalorder];
    } break;
    case 3: ///取消
    {
        [self GYRecstaurantTableViewCellcalorder];
    } break;
    case 1: ////去付款
    {
        if ([_moderType isEqualToString:@"1"]) {

            
            GYPaymentConfirmViewController *vc = [[GYPaymentConfirmViewController alloc] init];
            vc.paymentMode = GYPaymentModeWithFood;
            vc.orderNO = self.pyModel.orderId;
            vc.userId = self.pyModel.userId;
//            vc.orderType = @"1";
            vc.orderMoney = self.pyModel.amount;
            if ([self.pyModel.amountActually isKindOfClass:[NSNull class]] || [self.pyModel.amountActually floatValue] <= 0) {
                vc.realMoney = [NSString stringWithFormat:@"%0.2f", [self.pyModel.preAmount floatValue]];
            }
            else {
                vc.realMoney = [NSString stringWithFormat:@"%0.2f", [self.pyModel.amountActually floatValue]];
            }
            vc.navigationItem.title = kLocalized(@"GYHE_MyHE_PayCinfirm");
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            GYRestaurantOrderViewController* orderVc = [[GYRestaurantOrderViewController alloc] init];
            orderVc.strTyp = [NSString stringWithFormat:@"%@", _model.type];
            [self pushVC:orderVc animated:YES];
        }
    } break;
    case 4: {
        FDSubmitCommitViewController* vc = [[FDSubmitCommitViewController alloc] initWithNibName:NSStringFromClass([FDSubmitCommitViewController class]) bundle:nil];
        vc.userKey = globalData.loginModel.token;
        vc.userId = globalData.loginModel.custId;
        vc.orderId = _model.orderNumber;
        vc.shopId = _model.shopId;
        vc.vShopId = _model.vShopId;
        vc.shopName = _model.restaurantName;
        vc.isTakeaway = [_model.type isEqualToString:@"2"] || [_model.type isEqualToString:@"3"];
        vc.foodOrderType = kSaftToNSString(_model.type);
        [self pushVC:vc animated:YES];

    } break;
    default:
        break;
    }
}

- (void)pushVC:(id)vc animated:(BOOL)ani
{
    [self.navigationController pushViewController:vc animated:ani];
}

////算高度
- (CGSize)labHeigh:(NSString*)string andFout:(int)fout andLabeWith:(CGFloat)labWith
{
    UIFont* fop = [UIFont systemFontOfSize:fout];
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary* attributes = @{
        NSFontAttributeName : fop,
        NSParagraphStyleAttributeName : paragraphStyle
    };
    CGSize size = [string boundingRectWithSize:CGSizeMake(labWith, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return size;
}

- (void)GYaddresRestaurantCell
{
    kCheckLogined
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSString stringWithFormat:@"%@", _companyResourceNo] forKey:@"resourceNo"];
    [dict setValue:globalData.loginModel.token forKey:@"key"];
    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:GetVShopShortlyInfoUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    request.tag = 1502;
    [request start];
}

@end
