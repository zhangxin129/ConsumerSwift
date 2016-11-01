//
//  GYHSOtherPayStyleViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSOtherPayStyleViewController.h"

#import "GYAlertView.h"
#import "GYCashBuyHSBOtherPaidStyleViewController.h"
#import "GYEPMyAllOrdersViewController.h"
#import "GYHEOrderQuickPayVC.h"
#import "GYOtherPayStyleViewCell.h"
#import "GYOtherPayStyleViewSpecialCell.h"
#import "GYRestaurantOrderViewController.h"
#import "UIButton+GYTimeOut.h"
#import "UPPayPlugin.h"
#import "libPayecoPayPlugin.h"
#import "GYHSPopView.h"

@interface GYHSOtherPayStyleViewController () <UITableViewDataSource, UITableViewDelegate, PayEcoPpiDelegate, GYNetRequestDelegate,GYHSPopViewDelegate> {
    GlobalData* data;
    NSInteger _selecteIndex; //选中哪行
}
@property (nonatomic, strong) UITableView* payStyleUITableView;
@property (nonatomic, strong) NSMutableArray* dataSourceArray;
@property (nonatomic, strong) UIButton* confirmBtn;
@property (nonatomic, copy) NSString* currentPayType; //当前支付方式
// 易联支付类
@property (nonatomic, strong) PayEcoPpi* payEcoPpi;
@end

@implementation GYHSOtherPayStyleViewController
#pragma mark -- life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
      data = globalData;
    [self.view addSubview:self.payStyleUITableView];
    NSLog(@"=======kPayEcoPpiPluginMode:%@", kPayEcoPpiPluginMode);
    [self.dataSourceArray addObject:@"EP"]; //默认为认证卡支付
    self.currentPayType = [self.dataSourceArray firstObject];
    [self loadPaymentTypeDataFromNet];
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn.frame = CGRectMake(16, 16, kScreenWidth - 32-20, 44);
    [self.confirmBtn setTitle:kLocalized(@"GYHS_MyAccounts_ok") forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundImage:[UIImage imageNamed:@"hs_btn_confirm_bg"] forState:UIControlStateNormal];
    [self.confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView* confirmView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    [confirmView addSubview:self.confirmBtn];
    self.payStyleUITableView.tableFooterView = confirmView;
    [self.payStyleUITableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYOtherPayStyleViewSpecialCell class]) bundle:nil] forCellReuseIdentifier:@"otherPayStyleViewSpecialCell"];
    [self.payStyleUITableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYOtherPayStyleViewCell class]) bundle:nil] forCellReuseIdentifier:@"otherPayStyleViewCell"];
    _selecteIndex = self.currentPayStyle;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置初始值
    //inputValue = 0.0;
    if (data.user.isNeedRefresh) {
        [self get_cash_act_info];
        data.user.isNeedRefresh = NO;
    }
}
#pragma mark  -- UITableView代理
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYOtherPayStyleViewCell* otherPayStyleViewCell = [tableView dequeueReusableCellWithIdentifier:@"otherPayStyleViewCell"];
    if (_selecteIndex == indexPath.row) {
        otherPayStyleViewCell.selectImageView.image = [UIImage imageNamed:@"gycommon_circular_selected_red"]; //btn_round_click
    } else {
        otherPayStyleViewCell.selectImageView.image = [UIImage imageNamed:@"gycommon_circular_unselected_ring"];
    }
    NSString* payTypeStr = nil;
    if (self.dataSourceArray.count > indexPath.row) {
        payTypeStr = self.dataSourceArray[indexPath.row];
    }
    if ([payTypeStr isEqualToString:@"EP"]) {
        otherPayStyleViewCell.titleLabel.text = kLocalized(@"GYHS_MyAccounts_authentication_card_pay");
    } else if ([payTypeStr isEqualToString:@"QU"]) {
        otherPayStyleViewCell.titleLabel.text = kLocalized(@"GYHS_MyAccounts_quick_card_pay");
    }
    otherPayStyleViewCell.accounTransMoney.text = [GYUtils formatCurrencyStyle:[otherPayStyleViewCell.accountTransRateLabel.text doubleValue] * self.inputValue];
    return otherPayStyleViewCell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (_selecteIndex != indexPath.row) {
        _selecteIndex = indexPath.row;
        if (self.dataSourceArray.count > indexPath.row) {
            self.currentPayType = self.dataSourceArray[indexPath.row];
        }
        [self.payStyleUITableView reloadData];
    }
}
#pragma mark -- 点击确定按钮
- (void)confirmBtnClick:(UIButton*)button
{
    if ([self.currentPayType isEqualToString:@"EP"]) {
        [self queryEcoPpiOrder:button];
    } else if ([self.currentPayType isEqualToString:@"QU"]) {
        GYHEOrderQuickPayVC* vc = [[GYHEOrderQuickPayVC alloc] init];
        vc.orderNO = kSaftToNSString(self.transNo);
        vc.amount = [NSString stringWithFormat:@"%lf", self.inputValue];
        if (self.currentFunctionType == GYFunctionTypeWithBuyHSB) {
            vc.orderType = GYHSCashBuyHSBQuickPay;
        } else if (self.currentFunctionType == GYFunctionTypeWithReApplyCard) {
            vc.orderType = GyHEReApplyCardQuickPay;
        } else if (self.currentFunctionType == GYFunctionTypeWithGoods) {
            vc.orderType = GYHEOrderQuickPayVCOrderTypeGoods;
        } else if (self.currentFunctionType == GYFunctionTypeWithFood) {
            vc.orderType = GYHEOrderQuickPayVCOrderTypeFood;
        } else if (self.currentFunctionType == GYFunctionTypeWithQRPay) {
            vc.orderType = GyHSQRPayCardQuickPay;
            vc.model = self.model;
        }
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [GYUtils showToast:@"您选择的支付方式不正确"];
    }
}

- (NSString*)getNewSourceNo:(NSString*)sourceNo
{
    if ([sourceNo hasPrefix:@"9"]) {
        return [sourceNo stringByAppendingString:@"3"];
    } else {
        return [@"3" stringByAppendingString:sourceNo];
    }
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}

- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    [self.dataSourceArray removeAllObjects];
    [self.dataSourceArray addObjectsFromArray:responseObject[@"data"]];
    for (NSString* string in self.dataSourceArray) {
        if ([string isEqualToString:@"AC"]) {
            [self.dataSourceArray removeObject:@"AC"];
            break;
        }
    }
    if (self.dataSourceArray.count > 0) {
        self.currentPayType = [self.dataSourceArray firstObject];
    }
    [self.payStyleUITableView reloadData];
}

#pragma mark - 网络数据交换
- (void)loadPaymentTypeDataFromNet
{
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kGetPaymentTypeUrlString parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.noShowErrorMsg = YES;
    [request start];
}
#pragma mark -- 现金货币余额
- (void)get_cash_act_info
{
    NSDictionary* allFixParas = @{
                                  @"accCategory" : kTypeCashBalanceDetail,
                                  @"systemType" : kSystemTypeConsumer
                                  };
    NSMutableDictionary* allParas = [NSMutableDictionary dictionaryWithDictionary:allFixParas];
    [allParas setValue:data.loginModel.custId forKey:@"custId"];
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kAccountBalanceDetailUrlString parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary* dic = responseObject;
        data.user.cashAccBal = [dic[@"data"][@"accountBalance"] doubleValue];
        [self.payStyleUITableView reloadData];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)queryEcoPpiOrder:(UIButton*)button
{
    NSMutableDictionary* mDict = [[NSMutableDictionary alloc] init];
    if (self.currentFunctionType == GYFunctionTypeWithQRPay) {
        [mDict setValue:[GYUtils dateToString:self.date] forKey:@"sourcePosDate"];
        [mDict setValue:self.model.entResNo forKey:@"entResNo"];
        [mDict setValue:self.model.voucherNo forKey:@"termRunCode"];
        [mDict setValue:self.model.batchNo forKey:@"sourceBatchNo"];
        [mDict setValue:self.model.posDeviceNo forKey:@"equipmentNo"];
        [mDict setValue:self.model.entCustId forKey:@"entCustId"];
    }
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:mDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary* paramDic = @{
                               @"operateCode" : [self operateCodeParams],
                               @"orderNo" : kSaftToNSString(self.transNo),
                               @"transAmount" : [NSString stringWithFormat:@"%.2f", self.inputValue],
                               @"key" : kSaftToNSString(globalData.loginModel.token),
                               @"jsonObject" : jsonString
                               };
    [GYGIFHUD show];
    [button controlTimeOut];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kUrlPayOperateOrderInfo parameters:paramDic requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            NSInteger  errorRetCode = [error code];
            if (errorRetCode == -9000) {
                if (self.currentFunctionType == GYFunctionTypeWithFood) {
                    [GYAlertView showMessage:kLocalized(@"GYHE_SC_ServiceUnavailability")
                                confirmBlock:^{
                                    GYRestaurantOrderViewController *orderVc = [[GYRestaurantOrderViewController alloc] init];
                                    orderVc.strTyp = @"1";
                                    [self.navigationController pushViewController:orderVc animated:YES];
                                }];
                } else if (self.currentFunctionType == GYFunctionTypeWithGoods) {
                    [GYAlertView showMessage:kLocalized(@"GYHE_SC_ServiceUnavailability")
                                confirmBlock:^{
                                    GYEPMyAllOrdersViewController *epMyOrderVc = [[GYEPMyAllOrdersViewController alloc] init];
                                    epMyOrderVc.title = kLocalized(@"GYHE_SC_ShoppingList");
                                    [self.navigationController pushViewController:epMyOrderVc animated:YES];
                                }];
                } else {
                    [GYAlertView showMessage:kLocalized(@"GYHE_SC_ServiceUnavailability")
                                confirmBlock:^{
                                    [self.navigationController popViewControllerAnimated:YES];
                                }];
                }
                return;
            }
            if ( errorRetCode == 6011)
            {
                [GYUtils showToast:kErrorMsg];
                return ;
            }
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary* serverDic = responseObject[@"data"];
        
        if ([GYUtils checkDictionaryInvalid:serverDic]) {
            DDLogDebug(@"The serverDic:%@ is invalid.", serverDic);
            [GYUtils showToast:kLocalized(@"GYHS_MyAccounts_get_transaction_data_error")];
            return;
        }
        //初始化易联支付类对象
        self.payEcoPpi = [[PayEcoPpi alloc] init];
        NSString* reqJson = [GYUtils dictionaryToString:serverDic];
        // delegate: 用于接收支付结果回调
        // env:环境参数 00: 测试环境  01: 生产环境
        // orientation: 支付界面显示的方向 00：横屏  01: 竖屏
        [self.payEcoPpi startPay:reqJson delegate:self env:kPayEcoPpiPluginMode orientation:@"01"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hsCoinChange" object:nil userInfo:nil];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (NSString*)operateCodeParams
{
    if (self.currentFunctionType == GYFunctionTypeWithBuyHSB) {
        return kGYHSXT_AO_0001;
    } else if (self.currentFunctionType == GYFunctionTypeWithReApplyCard) {
        return kGYHSXT_BS_0001;
    } else if (self.currentFunctionType == GYFunctionTypeWithGoods) {
        return kGY_HSEC_TMS_001;
    } else if (self.currentFunctionType == GYFunctionTypeWithFood) {
        return kGY_HSEC_TMS_002;
    } else {
        return kGYHSXT_PS_0001;
    }
}

#pragma mark - PayEcoPpiDelegate
// 易联支付完成后执行回调，返回数据，通知商户
- (void)payResponse:(NSString*)respJsonStr
{
    DDLogDebug(@"\nPayEco PpiDelegate payResponse:%@", respJsonStr);
    NSData* respData = [respJsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* respDic = [NSJSONSerialization JSONObjectWithData:respData
                                                            options:kNilOptions
                                                              error:nil];
    NSString* respCode = [respDic objectForKey:@"respCode"];
    NSString* respDesc = [respDic objectForKey:@"respDesc"];
    if ([respCode isEqualToString:@"0000"]) {
        if (self.currentFunctionType == GYFunctionTypeWithFood) {
            [GYUtils showToast:kLocalized(@"GYHS_MyAccounts_pay_success_going_to_orderList")];
        } else {
            [GYUtils showToast:kLocalized(@"GYHS_MyAccounts_order_pay_success")];
        }
        [self popViewByType];
    } else {
        if (!respDesc || [respDesc isKindOfClass:[NSNull class]]) {
            respDesc = @"订单支付失败!";
        }
        if ([respCode isEqualToString:@"W101"]) {
            respDesc = @"订单未支付!";
        }
        [GYUtils showToast:respDesc];
    }
}

- (void)popViewByType
{
    if (self.currentFunctionType == GYFunctionTypeWithBuyHSB) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if (self.currentFunctionType == GYFunctionTypeWithReApplyCard) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if (self.currentFunctionType == GYFunctionTypeWithGoods) {
        GYEPMyAllOrdersViewController* epMyOrderVc = [[GYEPMyAllOrdersViewController alloc] init];
        epMyOrderVc.title = kLocalized(@"GYHS_MyAccounts_ep_myorder_all_order");
        [self.navigationController pushViewController:epMyOrderVc animated:YES];
    } else if (self.currentFunctionType == GYFunctionTypeWithFood) {
        GYRestaurantOrderViewController* orderVc = [[GYRestaurantOrderViewController alloc] init];
        orderVc.strTyp = @"1";
        [self.navigationController pushViewController:orderVc animated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - lazy load
- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] init];
    }
    return _dataSourceArray;
}

-(UITableView*)payStyleUITableView
{
    if (!_payStyleUITableView) {
        _payStyleUITableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, kScreenHeight) style:UITableViewStylePlain];
        _payStyleUITableView.delegate = self;
        _payStyleUITableView.dataSource = self;
        _payStyleUITableView.rowHeight = 70.0f;
    }
    return _payStyleUITableView;
}
@end
