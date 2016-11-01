//
//  GYOrderPayConfirmVC.m
//  HSConsumer
//
//  Created by sqm on 16/4/19.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSOrderPayConfirmVC.h"
#import "GYHSQRPayModel.h"
#import "NSString+YYAdd.h"
#import "UIView+Extension.h"
#import "UPPayPlugin.h"
#import "GYQuickPayModel.h"
#import "UIButton+GYTimeOut.h"
#import "GYOtherPayStyleViewController.h"

static NSString *const GYTableViewCellID = @"GYOrderPayConfirmVC";

@interface GYHSOrderPayConfirmVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UPPayPluginDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *valueArr;
@property (nonatomic, weak) UITextField *tradepwdTf;
@property (nonatomic, weak) UILabel *hsbLabel;
@property (nonatomic, strong) NSMutableArray *quickBankListArrM;

@end

@implementation GYHSOrderPayConfirmVC
#pragma mark - 懒加载

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 40;
    }
    return _tableView;
}

- (NSMutableArray *)quickBankListArrM {
    if (!_quickBankListArrM) {
        _quickBankListArrM = @[].mutableCopy;
    }
    return _quickBankListArrM;
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        if (self.paymentStatu == GYOldPaymentWay) {
            _titleArr = @[ kLocalized(@"GYHS_QR_entHSNumber"), kLocalized(@"GYHS_QR_anEnterpriseName"), kLocalized(@"GYHS_QR_posDealTime"), kLocalized(@"GYHS_QR_posDealTransAmount"), kLocalized(@"GYHS_QR_proportionalIntegral"), kLocalized(@"GYHS_QR_posDealPointTransAmount"), kLocalized(@"GYHS_QR_posShouldPayHsbAmount"), kLocalized(@"GYHS_QR_trade_pwd") ];
        } else {
            _titleArr = @[ kLocalized(@"GYHS_QR_entHSNumber"), kLocalized(@"GYHS_QR_anEnterpriseName"), kLocalized(@"GYHS_QR_posDealTime"), kLocalized(@"GYHS_QR_posDealTransAmount"), kLocalized(@"GYHS_QR_posDiscountCoupon"), kLocalized(@"GYHS_QR_posRealMoney"), kLocalized(@"GYHS_QR_proportionalIntegral"), kLocalized(@"GYHS_QR_posDistributePVNumber"), kLocalized(@"GYHS_QR_trade_pwd") ];
        }
    }
    return _titleArr;
}

- (NSArray *)valueArr {

    if (!_valueArr) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyyMMddHHmmss"]; //设定时间格式,这里可以设置成自己需要的格式
        NSDate *date = [dateFormat dateFromString:self.model.date];
        if (self.paymentStatu == GYOldPaymentWay) {
            _valueArr = @[ self.model.entResNo, self.model.entName, [GYUtils dateToString:date], [GYUtils formatCurrencyStyle:self.model.tradeAmount.doubleValue], [NSString stringWithFormat:@"%.4f", self.model.pointRate.doubleValue], [NSString stringWithFormat:@"%.2f", self.model.acceptScore.doubleValue], [GYUtils formatCurrencyStyle:self.model.hsbAmount.doubleValue] ];
        } else {
            _valueArr = @[ self.model.entResNo, self.model.entName, [GYUtils dateToString:date], [GYUtils formatCurrencyStyle:self.model.tradeAmount.doubleValue], [NSString stringWithFormat:@"-%.2lf", [self.model.couponNum integerValue] * [self.model.couponValue doubleValue]], [GYUtils formatCurrencyStyle:self.model.transAmount.doubleValue], [NSString stringWithFormat:@"%.4f", self.model.pointRate.doubleValue], [GYUtils formatCurrencyStyle:floor(self.model.acceptScore.doubleValue * 0.5 * 100) / 100] ];
        }
    }
    return _valueArr;
}

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    DDLogDebug(@"控制器%@加载了", [self class]);

    [self.view addSubview:self.tableView];

    self.title = kLocalized(@"GYHS_QR_posDealDetail");
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
    footerView.backgroundColor = kDefaultVCBackgroundColor;

    UILabel *tipLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth * 0.8, 20)];
    tipLable.textColor = kCellItemTextColor;
    tipLable.font = [UIFont systemFontOfSize:14];
    tipLable.text = kLocalized(@"GYHS_QR_posWarning");
    tipLable.width = [tipLable.text widthForFont:[UIFont systemFontOfSize:14]];
    [footerView addSubview:tipLable];

    UILabel *hsbLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tipLable.frame), 0, kScreenWidth - 20 - CGRectGetMaxX(tipLable.frame), 20)];
    hsbLabel.textColor = kValueRedCorlor;
    hsbLabel.font = [UIFont systemFontOfSize:15];
    [footerView addSubview:hsbLabel];
    self.hsbLabel = hsbLabel;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 40, kScreenWidth - 2 * 20, 40);
    [btn setTitle:kLocalized(@"GYHS_QR_immediatePayment") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:kDefaultButtonColor];

    [footerView addSubview:btn];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *otherPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    otherPayBtn.frame = CGRectMake(15, CGRectGetMaxY(btn.frame) + 5, 150, 30);
    [otherPayBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [otherPayBtn setTitle:@"选择其它支付方式" forState:UIControlStateNormal];
    [otherPayBtn addTarget:self action:@selector(otherPayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:otherPayBtn];
    self.tableView.tableFooterView = footerView;

    [self get_user_info];
    [self getBankList];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.paymentStatu == GYOldPaymentWay) {
        return section == 0 ? 7 : 1;
    } else {
        return section == 0 ? 8 : 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GYTableViewCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:GYTableViewCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.textLabel.textColor = kCellItemTitleColor;
    cell.detailTextLabel.textColor = kCellItemTextColor;
    if (indexPath.section == 0) {
        for (UIView *subView in cell.subviews) {
            if (subView == self.tradepwdTf) {
                [subView removeFromSuperview];
            }
        }
        cell.textLabel.text = self.titleArr[indexPath.row];
        cell.detailTextLabel.text = self.valueArr[indexPath.row];
        if (self.paymentStatu == GYOldPaymentWay) {
            if (indexPath.row == self.titleArr.count - 2) {
                cell.detailTextLabel.textColor = kValueRedCorlor;
            }
        } else {
            if (indexPath.row == self.titleArr.count - 4) {
                cell.detailTextLabel.textColor = kValueRedCorlor;
            }
        }
    } else {
        [self.tradepwdTf removeFromSuperview]; //防止重用
        //cell.textLabel.text = self.titleArr[indexPath.row + 7];
        cell.textLabel.text = [self.titleArr lastObject];
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, kScreenWidth - 100 - 20, 40)];
        textField.placeholder = kLocalized(@"GYHS_QR_input_trading_pwd");
        textField.secureTextEntry = YES;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.textColor = kCellItemTextColor;
        textField.font = [UIFont systemFontOfSize:14];
        [cell addSubview:textField];
        textField.delegate = self;
        self.tradepwdTf = textField;
    }

    return cell;
}

#pragma mark - textfield代理

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *toBeStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeStr.length > 8) {
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
}

- (void)click:(UIButton *)btn {
    kCheckLogined;
    [self.view endEditing:YES];

    if (self.tradepwdTf && self.tradepwdTf.text.length != 8) {
        [GYUtils showToast:@"请输入正确的交易密码"];
        return;
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象

    [dateFormat setDateFormat:@"yyyyMMddHHmmss"]; //设定时间格式,这里可以设置成自己需要的格式

    NSDate *date = [dateFormat dateFromString:self.model.date];
    WS(weakSelf)
    //互生币支付transType 21000
    [GYGIFHUD show];
    [btn controlTimeOut];

    [Network GET:[HSReconsitutionUrl stringByAppendingString:@"/cardReader/sourceTransNo"] parameters:@{ @"entResNo" : self.model.entResNo } completion:^(id responseObject, NSError *error) {
        if (!error && [responseObject[@"retCode"] isEqualToNumber:@200]) {
            NSString *str = [self getNewSourceNo:responseObject[@"data"]];//拼接pos机器终端类型

            NSDictionary *tempParamDic = @{@"transType":@"21000",
                                           @"entResNo":self.model.entResNo,
                                           @"entCustId":self.model.entCustId,
                                           @"channelType":@"4",
                                           @"sourceTransNo":str,
                                           @"sourcePosDate":[GYUtils dateToString:date],
                                           @"sourceCurrencyCode":self.model.currencyCode,
                                           @"userType":kUserTypeCard,
                                           @"pointRate":self.model.pointRate,
                                           @"tradePwd":self.tradepwdTf.text.md5String,
                                           @"perResNo":globalData.loginModel.resNo,
                                           @"equipmentNo":self.model.posDeviceNo,
                                           @"sourceBatchNo":self.model.batchNo,
                                           @"perCustId":globalData.loginModel.custId,
                                           @"entName":self.model.entName,
                                           @"equipmentType":@"2",
                                           @"termRunCode":self.model.voucherNo,
                                           @"pointSum":self.model.acceptScore};
            NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithDictionary:tempParamDic];
            if (self.paymentStatu == GYOldPaymentWay) {
                [paramDic setValue:self.model.hsbAmount forKey:@"transAmount"];
                [paramDic setValue:self.model.tradeAmount forKey:@"sourceTransAmount"];
            } else {
                [paramDic setValue:self.model.transAmount forKey:@"transAmount"];
                [paramDic setValue:[@(self.model.transAmount.doubleValue  / globalData.custGlobalDataModel.currencyToHsbRate.doubleValue)stringValue] forKey:@"sourceTransAmount"];
                [paramDic setValue:self.model.hsbAmount forKey:@"orderAmount"];
                [paramDic setValue:self.model.couponNum forKey:@"deductionVoucher"];
            }

            [Network Post:[HSReconsitutionUrl stringByAppendingString:@"/customer/posPoint"]  parameters:paramDic completion:^(id responseObject, NSError *error) {
                [GYGIFHUD dismiss];

                if (!error && [responseObject[@"retCode"] isEqualToNumber:@200]) {
                    [GYUtils showToast:@"恭喜，您的交易支付成功！"];
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                } else if (!error && [responseObject[@"retCode"] isEqualToNumber:@220]) {
                    [GYUtils showToast:kLocalized(@"GYHS_QR_thisDealIsPaid")];
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    [GYUtils showToast:kErrorMsg];
                }
            }];
        } else {
            [GYGIFHUD dismiss];
        }

    }];
}

- (void)otherPayBtnClick:(UIButton *)btn {
    [self.view endEditing:YES];
    kCheckLogined;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象

    [dateFormat setDateFormat:@"yyyyMMddHHmmss"]; //设定时间格式,这里可以设置成自己需要的格式

    NSDate *date = [dateFormat dateFromString:self.model.date];
    WS(weakSelf)
    [GYGIFHUD show];
    [btn controlTimeOut];
    [Network GET:[HSReconsitutionUrl stringByAppendingString:@"/cardReader/sourceTransNo"] parameters:@{ @"entResNo" : self.model.entResNo } completion:^(id responseObject, NSError *error) {
        if (!error && [responseObject[@"retCode"] isEqualToNumber:@200]) {

            NSString *str = [self getNewSourceNo:responseObject[@"data"]];//拼接pos机器终端类型
            NSDictionary *tempParamDic = @{@"transType":@"22000",
                                           @"entResNo":self.model.entResNo,
                                           @"entCustId":self.model.entCustId,
                                           @"channelType":@"4", @"sourceTransNo":str,
                                           @"sourcePosDate":[GYUtils dateToString:date],
                                           @"sourceCurrencyCode":self.model.currencyCode,
                                           @"userType":kUserTypeCard,
                                           @"pointRate":self.model.pointRate,
                                           @"perResNo":globalData.loginModel.resNo,
                                           @"equipmentNo":self.model.posDeviceNo,
                                           @"sourceBatchNo":self.model.batchNo,
                                           @"perCustId":globalData.loginModel.custId,
                                           @"entName":self.model.entName,
                                           @"equipmentType":@"2",
                                           @"termRunCode":self.model.voucherNo,
                                           @"pointSum":self.model.acceptScore,
                                           @"payChannel":@"102"};

            NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithDictionary:tempParamDic];
            if (self.paymentStatu == GYOldPaymentWay) {
                [paramDic setValue:self.model.hsbAmount forKey:@"transAmount"];
                [paramDic setValue:self.model.tradeAmount forKey:@"sourceTransAmount"];
            } else {
                [paramDic setValue:self.model.transAmount forKey:@"transAmount"];
                [paramDic setValue:[@(self.model.transAmount.doubleValue  / globalData.custGlobalDataModel.currencyToHsbRate.doubleValue)stringValue] forKey:@"sourceTransAmount"];
                [paramDic setValue:self.model.hsbAmount forKey:@"orderAmount"];
                [paramDic setValue:self.model.couponNum forKey:@"deductionVoucher"];
            }

            [Network Post:[HSReconsitutionUrl stringByAppendingString:@"/customer/pointBanking"]  parameters:paramDic completion:^(id responseObject, NSError *error) {
                [GYGIFHUD dismiss];
                if (!error && [responseObject[@"retCode"] isEqualToNumber:@200]) {
                    GYOtherPayStyleViewController *vc = [[GYOtherPayStyleViewController alloc] init];
                    vc.title = kLocalized(@"GYHS_QR_chooseOtherPaymentWay");
                    vc.transNo = responseObject[@"data"][@"transNo"];
                    vc.inputValue = [self.model.transAmount doubleValue];
                    vc.model = self.model;
                    vc.date = date;
                    vc.currentPayStyle = payStyleWithQuickPayment;
                    vc.currentFunctionType = GYFunctionTypeWithQRPay;
                    vc.tradeTitle = self.navigationItem.title;

                    [self.navigationController pushViewController:vc animated:YES];
                } else if (!error && [responseObject[@"retCode"] isEqualToNumber:@220]) {
                    [GYUtils showToast:kLocalized(@"GYHS_QR_thisDealIsPaid")];
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];

                } else {
                    [GYUtils showToast:kErrorMsg];
                }
            }];
        } else {
            [GYGIFHUD dismiss];
        }
    }];
}


- (void)get_user_info {
    if (!globalData.isLogined) {
        return;
    }
    WS(weakSelf)
    NSDictionary* paramsDic = @{ @"accCategory" : kTypeHSDBalanceDetail,
                                 @"systemType" : kSystemTypeConsumer,
                                 @"custId" : globalData.loginModel.custId };

    [Network GET:kAccountBalanceDetailUrlString parameters:paramsDic
      completion:^(id responseObject, NSError *error) {
        if ([responseObject[@"retCode"] isEqualToNumber:@200] && [responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            NSString *ltb = kSaftToNSString(responseObject[@"data"][@"ltbBalance"]);
            NSString *xfb = kSaftToNSString(responseObject[@"data"][@"xfbBalance"]);
            weakSelf.hsbLabel.text = [NSString stringWithFormat:@"%.2f", ltb.doubleValue + xfb.doubleValue];
        }
    }];
}

#pragma mark - UPPayPluginDelegate
- (void)UPPayPluginResult:(NSString *)result {
    //    支付状态返回值:success、fail、cancel
    if ([result isEqualToString:@"success"]) {
        [GYUtils showToast:@"恭喜，您的交易支付成功！"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [GYUtils showToast:@"抱歉，您的交易支付失败！"];
    }
}

- (void)getBankList {

    NSDictionary *dict = @{
        @"custId" : globalData.loginModel.custId,
        @"bindingChannel" : @"P",
        @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard
    };

    [GYGIFHUD show];
    [Network GET:kUrlListQkBanksByBindingChannel parameters:dict completion:^(NSDictionary *responseObject, NSError *error) { //kUrlListQkBanks
        [GYGIFHUD dismiss];
        if (error) {

        } else {
            if ([responseObject[@"retCode"] isEqualToNumber:@200]) {
                for (NSDictionary *tempDic in responseObject[@"data"]) {
                    GYQuickPayModel *model = [[GYQuickPayModel alloc] initWithDictionary:tempDic error:nil];
                    [self.quickBankListArrM addObject:model];
                }

            }
        }
    }];
}

- (NSString *)getNewSourceNo:(NSString *)sourceNo {
    if ([sourceNo hasPrefix:@"9"]) {
        return [sourceNo stringByAppendingString:@"3"];
    } else {
        return [@"3" stringByAppendingString:sourceNo];

    }

}

@end
