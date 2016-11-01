//
//  GYHSExchangeHSBNextViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSExchangeHSBNextViewController.h"
#import "GYPasswordKeyboardView.h"
#import "GYHSLabelTwoTableViewCell.h"
#import "NSString+YYAdd.h"

#import "GYHSExchangeNextCurrencyCell.h"
#import "GYHSOtherPayStyleCell.h"
#import "GYHSTools.h"
#import "GYHSPopView.h"
#import "Masonry.h"
#import "IQKeyboardManager.h"
#import "GYRestaurantOrderViewController.H"
#import "libPayecoPayPlugin.h"
#import "GYEPMyAllOrdersViewController.H"


@interface GYHSExchangeHSBNextViewController ()<UITableViewDataSource,UITableViewDelegate,GYPasswordKeyboardViewDelegate,PayEcoPpiDelegate>
@property (nonatomic,strong)UITableView *exchangeHSBNextTableView;
// 易联支付类
@property (nonatomic, strong) PayEcoPpi* payEcoPpi;
@end

@implementation GYHSExchangeHSBNextViewController
#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self get_cash_act_info];
    [self initUI];
}
-(void)initUI
{
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    [self.view addSubview:self.exchangeHSBNextTableView];
    
    [self.exchangeHSBNextTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSExchangeNextCurrencyCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSExchangeNextCurrencyCell"];
    [self.exchangeHSBNextTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSLabelTwoTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSLabelTwoTableViewCell"];
    [self.exchangeHSBNextTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSOtherPayStyleCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSOtherPayStyleCell"];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

#pragma mark - 查询货币账户余额
- (void)get_cash_act_info //货币账户余额
{
    NSDictionary* allFixParas = @{
                                  @"accCategory" : kTypeCashBalanceDetail,
                                  @"systemType" : kSystemTypeConsumer
                                  };
    NSMutableDictionary* allParas = [NSMutableDictionary dictionaryWithDictionary:allFixParas];
    [allParas setValue:globalData.loginModel.custId forKey:@"custId"];
    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kAccountBalanceDetailUrlString parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary *dic = responseObject;
        globalData.user.cashAccBal = [dic[@"data"][@"accountBalance"] doubleValue];
        [self.exchangeHSBNextTableView reloadData];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}
#pragma mark -- 兑换互生币 - 货币支付
- (void)get_cash_trans_hsd:(NSString*)pwString
{
    NSDictionary* allFixParas = @{
                                  @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard,
                                  @"pwd" : [pwString md5String]
                                  };
    NSMutableDictionary* allParas = [NSMutableDictionary dictionaryWithDictionary:allFixParas];
    [allParas setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"custId"];
    [allParas setValue:kSaftToNSString(self.transNo) forKey:@"transNo"];
    [GYGIFHUD show];
    //[button controlTimeOut];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kHSExchangeHsbByHbUrlString parameters:allParas requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            NSInteger errorRetCode = [error code];
            if (errorRetCode == -9000) {
               [ GYUtils showMessage:kLocalized(@"GYHE_SC_ServiceUnavailability") confirm:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                return;
            }
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"currencyChange" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hsCoinChange" object:nil userInfo:nil];
        globalData.user.isNeedRefresh = YES;
        [GYUtils showMessage:kLocalized(@"GYHS_MyAccounts_order_is_pay_success") confirm:^{
            [self.navigationController popViewControllerAnimated:YES];
        } withColor:kBtnBlue];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

#pragma mark -- UITableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        GYHSLabelTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLabelTwoTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bottomlb.hidden = YES;
        cell.toplb.hidden = YES;
        cell.titleLabel.text = kLocalized(@"GYHS_MyAccounts_pay_amount");
        cell.detLabel.text =[GYUtils formatCurrencyStyle:self.inputValue];
        cell.detLabel.textAlignment = NSTextAlignmentRight;
        cell.titleLabel.font = kExchangeHSBTwoCellFont;
        cell.detLabel.font = kExchangeHSBTwoCellFont;
        cell.detLabel.textColor = kSelectedRed;
        cell.titleLabel.textColor = kCellTitleBlack;
        return cell;

    }else if (indexPath.row == 1){
        GYHSExchangeNextCurrencyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSExchangeNextCurrencyCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.currencyBalanceLb.text = [NSString stringWithFormat:@"余额：%@",[GYUtils formatCurrencyStyle:globalData.user.cashAccBal]];
        return cell;
    }else {
        GYHSOtherPayStyleCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSOtherPayStyleCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.inputValue > globalData.user.cashAccBal) {
            cell.otherPayStyleLb.text = kLocalized(@"货币账户余额不足，请选择：");
            cell.otherPayStyleLb.textColor = kSelectedRed;
        }else{
            cell.otherPayStyleLb.text = kLocalized(@"GYHS_MyAccounts_chooseOtherPaymentWay");
        }
        [cell.accreditationCardPayBtn setTitle:@"认证卡支付" forState:UIControlStateNormal];
        [cell.accreditationCardPayBtn addTarget:self action:@selector(otherPayWayBtn) forControlEvents:UIControlEventTouchUpInside];
        return  cell;
    }
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 2) {
        return 44;
    }
    return 50;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 336;
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    view.backgroundColor = kDefaultVCBackgroundColor;
    return view;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    GYPasswordKeyboardView *pk = [[GYPasswordKeyboardView alloc] init];
    pk.frame = CGRectMake(0, 0, kScreenWidth, 5 * (kScreenHeight/12));
    pk.style = GYPasswordKeyboardStyleTrading;
    pk.delegate = self;
    [pk pop:footView];
    if (self.inputValue > globalData.user.cashAccBal) {
        return nil;
    }
    return footView;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.view endEditing:YES];
}

#pragma mark -- GYPasswordKeyboardViewDelegate
-(void)returnPasswordKeyboard:(GYPasswordKeyboardView *)passwordKeyboard style:(GYPasswordKeyboardStyle)style type:(GYPasswordKeyboardReturnType)type password:(NSString *)password  {
    if (self.inputValue > globalData.user.cashAccBal) {
        [GYUtils showToast:@"账户余额不足!"];
        return;
    }
    if (password.length != 8) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyAccounts_please_enter_trade_pwd")];
        return;
    }
    [self get_cash_trans_hsd:password];
}
- (void)cancelClick //  取消/返回时触发
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 选择其他支付方式
-(void)otherPayWayBtn
{
    [self queryEcoPpiOrder];
}
- (void)queryEcoPpiOrder
{
    self.currentFunctionType = GYFunctionTypeWithBuyHSB;
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
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kUrlPayOperateOrderInfo parameters:paramDic requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            NSInteger  errorRetCode = [error code];
            if (errorRetCode == -9000) {
                if (self.currentFunctionType == GYFunctionTypeWithFood) {
                    [GYUtils showMessage:kLocalized(@"GYHE_SC_ServiceUnavailability")
                                confirm:^{
                                    GYRestaurantOrderViewController *orderVc = [[GYRestaurantOrderViewController alloc] init];
                                    orderVc.strTyp = @"1";
                                    [self.navigationController pushViewController:orderVc animated:YES];
                                }];
                } else if (self.currentFunctionType == GYFunctionTypeWithGoods) {
                    [GYUtils showMessage:kLocalized(@"GYHE_SC_ServiceUnavailability")
                                confirm:^{
                                    GYEPMyAllOrdersViewController *epMyOrderVc = [[GYEPMyAllOrdersViewController alloc] init];
                                    epMyOrderVc.title = kLocalized(@"GYHE_SC_ShoppingList");
                                    [self.navigationController pushViewController:epMyOrderVc animated:YES];
                                }];
                } else {
                    [GYUtils showMessage:kLocalized(@"GYHE_SC_ServiceUnavailability")
                                confirm:^{
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hsCoinChange" object:nil userInfo:nil];
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

#pragma mark -- 懒加载 

-(UITableView*)exchangeHSBNextTableView
{
    if (!_exchangeHSBNextTableView) {
        _exchangeHSBNextTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        _exchangeHSBNextTableView.delegate = self;
        _exchangeHSBNextTableView.dataSource = self;
        _exchangeHSBNextTableView.delaysContentTouches = NO;
    }
    return _exchangeHSBNextTableView;
}
@end
