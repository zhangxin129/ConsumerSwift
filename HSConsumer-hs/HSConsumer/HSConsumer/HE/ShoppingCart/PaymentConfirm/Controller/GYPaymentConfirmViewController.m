//
//  GYPaymentConfirmViewController.m
//  HSConsumer
//
//  Created by admin on 16/7/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYPaymentConfirmViewController.h"
#import "GYAlertView.h"
#import "GYEPMyAllOrdersViewController.h"
#import "GYEPOrderDetailViewController.h"
#import "GYOrderDetailsViewController.h"
#import "GYOtherPayStyleViewController.h"
#import "GYPaymentInfoTableViewCell.h"
#import "GYPaymentListTableViewCell.h"
#import "GYPaymentPWDTableViewCell.h"
#import "GYRestaurantOrderViewController.h"
#import "NSString+YYAdd.h"
#import "UIButton+GYTimeOut.h"

#define infoTableViewCell @"GYPaymentInfoTableViewCell"
#define listTableViewCell @"GYPaymentListTableViewCell"
#define PWDTableViewCell @"GYPaymentPWDTableViewCell"

typedef NS_ENUM (NSInteger, RetCode) {
    RetCodeA = 200, ////支付成功
    RetCodeB = 590, ///互生币支付余额不足
    RetCodeC = 783, ///该用户交易密码未设置!
    RetCodeD = 201, ///支付失败
    RetCodeE = 792, ///支付密码不正确
    RetCodeF = 160360, ///支付密码不正确
    RetCodeG = 160415, //交易密码未设置
};

@interface GYPaymentConfirmViewController () <UITableViewDataSource, UITableViewDelegate, GYNetRequestDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, copy) NSString *retainMoney; //互生币余额
@property (nonatomic, copy) NSString *passWordStr;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *ValueArray;
/**互生币支付的密钥*/
@property (nonatomic, copy) NSString *tnCode;
@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation GYPaymentConfirmViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self accountInfoRequest];
    if (self.paymentMode == GYPaymentModeWithGoods) {
        [self getToken];
    }
    if (self.paymentMode == GYPaymentModeWithFood) {
        [self getmyToken];
    }
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYPaymentInfoTableViewCell class]) bundle:nil] forCellReuseIdentifier:infoTableViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYPaymentListTableViewCell class]) bundle:nil] forCellReuseIdentifier:listTableViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYPaymentPWDTableViewCell class]) bundle:nil] forCellReuseIdentifier:PWDTableViewCell];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"gycommon_nav_back"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [backButton addTarget:self action:@selector(pushToOrderDetail) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)pushToOrderDetail {
    if (self.paymentMode == GYPaymentModeWithGoods) {
        if (self.isFromOrderList) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        GYEPOrderDetailViewController *vc = [[GYEPOrderDetailViewController alloc] init];
        vc.orderID = self.orderNO;
        vc.isComeOrder = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.titleArray.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GYPaymentInfoTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:infoTableViewCell forIndexPath:indexPath];
        if (self.paymentMode == GYPaymentModeWithReApplyCard) {
            infoCell.orderTagLabel.text = [NSString stringWithFormat:@"%@:", kLocalized(@"GYHE_SC_PaymentAmount")];
        } else {
            infoCell.orderTagLabel.text = [NSString stringWithFormat:@"%@:", kLocalized(@"GYHE_SC_OrderAmount")];
        }
        infoCell.orderNumLabel.text = [NSString stringWithFormat:@"%@:%@", kLocalized(@"GYHE_SC_OrderNumber"), kSaftToNSString(self.orderNO)];
        infoCell.orderMoneyLabel.text = [GYUtils formatCurrencyStyle:kSaftToNSString(self.orderMoney).doubleValue];
        return infoCell;
    } else if (indexPath.section == 1) {
        GYPaymentListTableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:listTableViewCell forIndexPath:indexPath];
        listCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.titleArray.count > indexPath.row) {
            listCell.titleLabel.text = self.titleArray[indexPath.row];
        }
        if (self.ValueArray.count > indexPath.row) {
            listCell.moneyLabel.text = self.ValueArray[indexPath.row];
        }
        if (indexPath.row == 0) {
            listCell.tagLabel.hidden = NO;
            listCell.coinImageView.hidden = NO;
        } else {
            listCell.tagLabel.hidden = YES;
            listCell.coinImageView.hidden = YES;
        }
        if (self.titleArray.count == indexPath.row + 1) {
            listCell.moneyLabel.textColor = [UIColor redColor];
        } else {
            listCell.moneyLabel.textColor = [UIColor blackColor];
        }
        return listCell;
    } else {
        GYPaymentPWDTableViewCell *pwdCell = [tableView dequeueReusableCellWithIdentifier:PWDTableViewCell forIndexPath:indexPath];
        return pwdCell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 90.0f;
    } else {
        return 44.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 40.0f;
    }
    return 20.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];

        UIButton *otherPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        otherPayBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 150, 30)];
        [otherPayBtn setTitle:kLocalized(@"GYHE_SC_ChooseOtherPayWay") forState:UIControlStateNormal];
        otherPayBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [otherPayBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [otherPayBtn addTarget:self action:@selector(otherPaybtnClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:otherPayBtn];
        return view;
    }
    return nil;
}

#pragma mark - custom methods
- (void)otherPaybtnClick {
    GYOtherPayStyleViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYOtherPayStyleViewController class]));
    vc.title = kLocalized(@"GYHE_SC_ChooseOtherPaymentWay");
    vc.transNo = self.orderNO;
    vc.inputValue = [self.realMoney doubleValue];

    vc.currentPayStyle = payStyleWithQuickPayment;
    if (self.paymentMode == GYPaymentModeWithGoods) {
        vc.currentFunctionType = GYFunctionTypeWithGoods;
    } else if (self.paymentMode == GYPaymentModeWithFood) {
        vc.currentFunctionType = GYFunctionTypeWithFood;
    } else {
        vc.currentFunctionType = GYFunctionTypeWithReApplyCard;
    }

    vc.tradeTitle = self.navigationItem.title;

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setListCellTitleArrayAndValueArray {
    if (self.paymentMode == GYPaymentModeWithGoods) {
        self.titleArray = @[ kLocalized(@"HE_SC_OrderACPayment"), kLocalized(@"GYHE_SC_OrderAmount"), kLocalized(@"GYHE_SC_Coupon"), kLocalized(@"HE_SC_OrderRealMoney") ];
        NSString *discountNum = nil;
        if (self.discount.doubleValue == 0) {
            discountNum = [NSString stringWithFormat:@"%.2lf", self.discount.doubleValue];
        } else {
            discountNum = [NSString stringWithFormat:@"-%.2lf", self.discount.doubleValue];
        }
        self.ValueArray = @[ [GYUtils formatCurrencyStyle:kSaftToNSString(self.retainMoney).doubleValue], [GYUtils formatCurrencyStyle:kSaftToNSString(self.orderMoney).doubleValue], discountNum, [GYUtils formatCurrencyStyle:kSaftToNSString(self.realMoney).doubleValue] ];
    } else if (self.paymentMode == GYPaymentModeWithFood) {
        self.titleArray = @[ kLocalized(@"HE_SC_OrderACPayment"), kLocalized(@"GYHE_SC_OrderAmount"), kLocalized(@"GYHE_SC_PaymentAmount") ];
        self.ValueArray = @[ [GYUtils formatCurrencyStyle:kSaftToNSString(self.retainMoney).doubleValue], [GYUtils formatCurrencyStyle:kSaftToNSString(self.orderMoney).doubleValue], [GYUtils formatCurrencyStyle:kSaftToNSString(self.realMoney).doubleValue] ];
    } else {
        self.titleArray = @[ kLocalized(@"HE_SC_OrderACPayment"), kLocalized(@"GYHE_SC_PaymentAmount") ];
        self.ValueArray = @[ [GYUtils formatCurrencyStyle:kSaftToNSString(self.retainMoney).doubleValue], [GYUtils formatCurrencyStyle:kSaftToNSString(self.realMoney).doubleValue] ];
    }
    [self.tableView reloadData];
}

- (void)setTableHeaderViewWithRetainMoney:(NSString *)retainMoney {
    if (kSaftToDouble(retainMoney) < kSaftToDouble(self.realMoney)) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        headerView.backgroundColor = [UIColor clearColor];

        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        backView.backgroundColor = kCorlorFromRGBA(250, 255, 213, 1);
        [headerView addSubview:backView];

        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
        tipLabel.center = CGPointMake(backView.center.x + 20, backView.center.y);
        tipLabel.text = kLocalized(@"GYHE_SC_AccountNotEnoughToChooseOtherWay");
        tipLabel.textColor = [UIColor redColor];
        tipLabel.font = [UIFont systemFontOfSize:14.0f];
        [backView addSubview:tipLabel];

        CGFloat imageX = (tipLabel.frame.origin.x - 20) > 0 ? tipLabel.frame.origin.x - 20 : 0;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, 13, 15, 15)];
        imgView.image = [UIImage imageNamed:@"msg_fail"];
        [backView addSubview:imgView];
        self.tableView.tableHeaderView = headerView;
    } else {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        headerView.backgroundColor = [UIColor clearColor];
        self.tableView.tableHeaderView = headerView;
    }
}

- (void)accountInfoRequest {
    NSDictionary *parameterDic = @{ @"accCategory" : kTypeHSDBalanceDetail,
                                    @"systemType" : kSystemTypeConsumer,
                                    @"custId" : kSaftToNSString(globalData.loginModel.custId) };
    GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self baseURL:nil URLString:kAccountBalanceDetailUrlString parameters:parameterDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    request.tag = 100;
    [request start];
}

- (void)confirmBtnClick:(UIButton *)sender {
    [sender controlTimeOut];
    NSIndexPath *index = [NSIndexPath indexPathForItem:0 inSection:2];
    GYPaymentPWDTableViewCell *pwdCell = [self.tableView cellForRowAtIndexPath:index];
    self.passWordStr = pwdCell.passWordTextField.text;
    if (!self.passWordStr || self.passWordStr.length != 8) {
        [GYUtils showToast:kLocalized(@"GYHE_SC_PleaseInputEightPassword")]; //input_pay_password
        return;
    }
    if (self.paymentMode == GYPaymentModeWithGoods) {
        [self goodsLoadDataFromNetwork:^{
            pwdCell.passWordTextField.text = @"";
        }];
    } else if (self.paymentMode == GYPaymentModeWithReApplyCard) {
        [self reApplyCardLoadDataFromNetwork];
    } else if (self.paymentMode == GYPaymentModeWithFood) {
        [self foodLoadDataFromNetwork:^{
            pwdCell.passWordTextField.text = @"";
        }];
    }
}

- (void)foodLoadDataFromNetwork:(void (^)(void))complete {

    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setValue:globalData.loginModel.token forKey:@"userKey"];
    [json setValue:[self.passWordStr md5String] forKey:@"pwd"];
    [json setValue:self.orderMoney forKey:@"amount"];
    [json setValue:self.orderNO forKey:@"orderId"];
    [json setValue:@"3" forKey:@"payType"];
    [json setValue:self.userId forKey:@"userId"];
    [json setValue:self.realMoney forKey:@"preAmount"];
    [json setValue:@"000" forKey:@"currency"];
    [json setValue:globalData.loginModel.custId forKey:@"custId"];
    [json setValue:self.tnCode forKey:@"token"];

    [GYGIFHUD show];
    [self.confirmBtn controlTimeOut];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:FoodPayOrderUrl
                                                     parameters:json
                                                  requestMethod:GYNetRequestMethodPOST
                                              requestSerializer:GYNetRequestSerializerJSON
                                                   respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            NSInteger errorRetCode = [error code];
            switch (errorRetCode) {
            case -9000: {
                [GYAlertView showMessage:kLocalized(@"GYHE_SC_ServiceUnavailability")
                            confirmBlock:^{
                        GYRestaurantOrderViewController *orderVc = [[GYRestaurantOrderViewController alloc] init];
                        orderVc.strTyp = @"1";
                        [self.navigationController pushViewController:orderVc animated:YES];
                    }];
            } break;
            case RetCodeB: {
                [GYAlertView showMessage:kLocalized(@"GYHE_SC_HSBCreditrunningLow")
                            confirmBlock:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
            } break;
            case RetCodeC: {
                [GYAlertView showMessage:kLocalized(@"GYHE_SC_UserPasswordNotSet")
                            confirmBlock:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
            } break;
            case RetCodeD: {
                [GYAlertView showMessage:kLocalized(@"GYHE_SC_HSBPayFailed")
                            confirmBlock:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];

            } break;
            case RetCodeE:
            case RetCodeF: {
                [GYAlertView showMessage:kLocalized(@"GYHE_SC_TransactionPasswordVerificationFailed")];
            } break;
            case RetCodeG: {
                [GYAlertView showMessage:kLocalized(@"GYHE_SC_TransactionPasswordNotSet")];
            } break;
            default: {
                if (kErrorMsg) {
                    [GYAlertView showMessage:kErrorMsg
                                confirmBlock:^{
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                } else {
                    [GYAlertView showMessage:kLocalized(@"GYHE_SC_PaymentFailure")
                                confirmBlock:^{
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                }
            } break;
            }
            return;
        }
        //                                                       if (self.orderType.length > 0) {
        [GYAlertView showMessage:kLocalized(@"GYHE_SC_HSBpaySuccess")
                    confirmBlock:^{
            GYRestaurantOrderViewController *orderVc = [[GYRestaurantOrderViewController alloc] init];
            orderVc.strTyp = @"1";
            [self.navigationController pushViewController:orderVc animated:YES];
        }];

        //                                                       } else {
        //                                                           complete();
        //                                                           [GYAlertView showMessage:kLocalized(@"GYHE_SC_PaymentSuccess")
        //                                                                       confirmBlock:^{
        //                                                                           GYEPMyAllOrdersViewController* epMyOrderVc = [[GYEPMyAllOrdersViewController alloc] init];
        //                                                                           epMyOrderVc.title = kLocalized(@"GYHE_SC_ShoppingList");
        //                                                                           [self.navigationController pushViewController:epMyOrderVc animated:YES];
        //                                                                       }];
        //                                                       }
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    request.noShowErrorMsg = YES;
    [request start];
}

- (void)reApplyCardLoadDataFromNetwork {
    NSMutableDictionary *allParas = [NSMutableDictionary dictionary];

    [allParas setValue:kSaftToNSString(self.orderNO) forKey:@"orderNo"];
    [allParas setValue:kSaftToNSString(@"200") forKey:@"payChannel"];
    [allParas setValue:[self.passWordStr md5String] forKey:@"tradePwd"];
    [allParas setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"custId"];
    [allParas setValue:kUserTypeCard forKey:@"userType"];

    [GYGIFHUD show];
    [self.confirmBtn controlTimeOut];

    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kHSCardMendCardPayUrlString
                                                     parameters:allParas
                                                  requestMethod:GYNetRequestMethodPOST
                                              requestSerializer:GYNetRequestSerializerJSON
                                                   respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            NSInteger errorRetCode = [error code];
            if (errorRetCode == -9000) {
                [GYAlertView showMessage:kLocalized(@"GYHE_SC_ServiceUnavailability")
                            confirmBlock:^{
                                [self.navigationController popViewControllerAnimated:YES];
                            }];
            } else {
                DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
                [GYUtils parseNetWork:error resultBlock:nil];
            }
            return;
        }
        [GYAlertView showMessage:kLocalized(@"GYHE_SC_YourOrderPaySuccess")
                    confirmBlock:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }];
    request.noShowErrorMsg = YES;
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)goodsLoadDataFromNetwork:(void (^)(void))complete {

    [self.view endEditing:YES];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:kSaftToNSString(globalData.loginModel.token) forKey:@"key"];
    [dict setValue:kSaftToNSString(self.orderNO) forKey:@"orderId"];
    NSString *pwd = [self.passWordStr md5String];
    [dict setValue:pwd forKey:@"payPwd"];
    [dict setValue:kSaftToNSString(self.realMoney) forKey:@"amount"];
    //  互生币改为000
    [dict setValue:@"000" forKey:@"coinCode"];
    [dict setValue:@"ios" forKey:@"osType"];
    [dict setValue:kSaftToNSString(self.tnCode) forKey:@"token"];

    [self.confirmBtn controlTimeOut];
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:[NSString stringWithFormat:@"%@/easybuy/payHsbOnline", globalData.retailDomain]
                                                     parameters:dict
                                                  requestMethod:GYNetRequestMethodGET
                                              requestSerializer:GYNetRequestSerializerJSON
                                                   respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            NSInteger errorRetCode = [error code];
            if (errorRetCode == -9000) {
                [GYAlertView showMessage:kLocalized(@"GYHE_SC_ServiceUnavailability")
                            confirmBlock:^{
                                GYEPMyAllOrdersViewController *epMyOrderVc = [[GYEPMyAllOrdersViewController alloc] init];
                                epMyOrderVc.title = kLocalized(@"GYHE_SC_ShoppingList");
                                [self.navigationController pushViewController:epMyOrderVc animated:YES];
                            }];
            } else if (errorRetCode == 590) {
                [GYAlertView showMessage:kLocalized(@"GYHE_SC_HSBCreditrunningLow")];
            } else if (errorRetCode == 783) {
                [GYAlertView showMessage:kLocalized(@"GYHE_SC_UserPasswordNotSet")];
            } else if (errorRetCode == 792 || errorRetCode == 160360) {                                                // bill
                [GYAlertView showMessage:kLocalized(@"GYHE_SC_TransactionPasswordVerificationFailed")];
            } else {
                [GYUtils parseNetWork:error resultBlock:nil];
            }
            return;
        }
        complete();
        [GYAlertView showMessage:kLocalized(@"GYHE_SC_HSBpaySuccess")
                    confirmBlock:^{
            GYEPMyAllOrdersViewController *epMyOrderVc = [[GYEPMyAllOrdersViewController alloc] init];
            epMyOrderVc.title = kLocalized(@"GYHE_SC_ShoppingList");
            [self.navigationController pushViewController:epMyOrderVc animated:YES];
        }];
    }];
    request.noShowErrorMsg = YES;
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)getToken {

    NSDictionary *dict = @{
        @"custId" : globalData.loginModel.custId
    };

    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kUrlGetToken
                                                     parameters:dict
                                                  requestMethod:GYNetRequestMethodGET
                                              requestSerializer:GYNetRequestSerializerJSON
                                                   respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return;
        }
        NSString *tnCode = responseObject[@"data"];
        self.tnCode = tnCode;
    }];
    request.noShowErrorMsg = YES;
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)getmyToken {
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GetTokenUrl
                                                     parameters:nil
                                                  requestMethod:GYNetRequestMethodGET
                                              requestSerializer:GYNetRequestSerializerJSON
                                                   respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return;
        }
        NSString *tnCode = responseObject[@"data"];
        self.tnCode = tnCode;
    }];
    request.noShowErrorMsg = YES;
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest *)request didFailureWithError:(NSError *)error {
    if (request.tag == 100) {
        self.retainMoney = @"-";
        [self setListCellTitleArrayAndValueArray];
        [self.tableView reloadData];
    }
}

- (void)netRequest:(GYNetRequest *)request didSuccessWithData:(NSDictionary *)responseObject {

    NSString *xfbBalance = kSaftToNSString(responseObject[@"data"][@"xfbBalance"]);
    NSString *ltbBalance = kSaftToNSString(responseObject[@"data"][@"ltbBalance"]);
    if (self.paymentMode == GYPaymentModeWithReApplyCard) {
        self.retainMoney = [NSString stringWithFormat:@"%.2f", [ltbBalance doubleValue]];
    } else {
        self.retainMoney = [NSString stringWithFormat:@"%.2f", ([xfbBalance doubleValue] + [ltbBalance doubleValue])];
    }
    [self setListCellTitleArrayAndValueArray];
    [self setTableHeaderViewWithRetainMoney:self.retainMoney];
    [self.tableView reloadData];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kCorlorFromRGBA(237, 238, 239, 1);
        _tableView.delegate = self;
        _tableView.dataSource = self;

        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        headerView.backgroundColor = [UIColor clearColor];
        self.tableView.tableHeaderView = headerView;

        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.confirmBtn.frame = CGRectMake(20, 0, kScreenWidth - 40, 40);
        [self.confirmBtn setTitle:kLocalized(@"HE_SC_CartConfirm") forState:UIControlStateNormal];
        [self.confirmBtn setBackgroundColor:kCorlorFromRGBA(231, 142, 35, 1)];
        [self.confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:self.confirmBtn];
        _tableView.tableFooterView = footerView;
    }
    return _tableView;
}

/*
   #pragma mark - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   }
 */

@end
