//
//  GYPointToCashViewNextController.m
//  HSConsumer
//
//  Created by apple on 14-10-27.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.

//积分转互生币与积分投资页面

#import "GYPointToHSDNextViewController.h"
#import "GYPointToHSDViewController.h"
#import "GYGIFHUD.h"
#import "UIButton+GYExtension.h"
#import "GYAlertView.h"
#import "GYHSLoginManager.h"
#import "GYHSLabelTwoTableViewCell.h"
#import "GYHSLableTextFileTableViewCell.h"
#import "GYHSButtonCell.h"
#import "NSString+YYAdd.h"
#import "GYNetRequest.h"
#import "GYHSLoginModel.h"

@interface GYPointToHSDNextViewController () <GYHSLableTextFileTableViewCellDeleget, GYHSButtonCellDelegate, GYNetRequestDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate> {
    GlobalData* data; //全局单例
}
@property (nonatomic, strong) UITableView* HSDNextpointTableView;
@property (nonatomic, copy) NSArray* titileArray;
@property (nonatomic, copy) NSArray* detArray;
@property (nonatomic, copy) NSString* pwString;
@end

@implementation GYPointToHSDNextViewController

- (void)integral_transfer_hsb //转现数只可为整数，不可带数点
{
    NSString* url;
    NSDictionary* allFixParas = nil;
    GYHSLoginModel* model = [GYHSLoginManager shareInstance].loginModuleObject;
    if ([self.type isEqualToString:@"0"]) {
        url = kPointToHSDUrlString;
        allFixParas = @{
            @"custType" : globalData.loginModel.cardHolder ? kCustTypeCard : kCustTypeNoCard,
            @"amount" : kSaftToNSString(self.integral),
            @"channel" : kChannelMOBILE,
            @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard,
            @"transPwd" : kSaftToNSString([self.pwString md5String]),
        };
    }
    else if ([self.type isEqualToString:@"1"]) {
        url = kPointInvestUrlString;
        allFixParas = @{
            @"investAmount" : kSaftToNSString(self.integral),
            @"custType" : globalData.loginModel.cardHolder ? kCustTypeCard : kCustTypeNoCard,
            @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard,
            @"transPwd" : kSaftToNSString([self.pwString md5String]),
            @"channel" : @"4"
        };
    }
    else if ([self.type isEqualToString:@"2"]) {
        url = kHSDToCashToCashAccountUrlString;
        allFixParas = @{
            @"fromHsbAmt" : self.integral,
            @"toCashAmt" : self.delArray[3],
            @"channel" : kChannelMOBILE,
            @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard,
            @"transPwd" : [self.pwString md5String]

        };
    }

    NSMutableDictionary* allParas = [NSMutableDictionary dictionaryWithDictionary:allFixParas];
    if ([self.type isEqualToString:@"2"]) { //互生币转货币
        if (globalData.loginModel.cardHolder) {
            NSString* custName = @"gyist";
            if (data.loginModel.custName.length) {
                custName = data.loginModel.custName;
            }
            [allParas setValue:kSaftToNSString(custName) forKey:@"custName"];
            [allParas setValue:kSaftToNSString(data.loginModel.resNo) forKey:@"hsResNo"];
            [allParas setValue:kCustTypeCard forKey:@"custType"];
        }
        else {
            [allParas setValue:kSaftToNSString(data.loginModel.userName) forKey:@"hsResNo"];
            [allParas setValue:kCustTypeNoCard forKey:@"custType"];
            [allParas setValue:kSaftToNSString(data.loginModel.userName) forKey:@"custName"];
        }
    }
    else { //积分投资 积分转互生币
        [allParas setValue:kSaftToNSString(model.resNo) forKey:@"hsResNo"];
        NSString* custName = @"gyist";
        if (model.custName.length) {
            custName = model.custName;
        }
        [allParas setValue:kSaftToNSString(custName) forKey:@"custName"];
    }

    [allParas setValue:kSaftToNSString(model.custId) forKey:@"custId"];

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:url parameters:allParas requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
}

#pragma mark GYnetRequestDelegate

- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    [GYGIFHUD dismiss];
    DDLogDebug(@"responseObject:%@", responseObject);
    NSString* msg;
    if ([self.type isEqualToString:@"0"]) { //积分转互生币
           msg = kLocalized(@"GYHS_MyAccounts_points_to_hsd_succeed");
    }
    else if ([self.type isEqualToString:@"1"]) { //积分投资
            msg = kLocalized(@"GYHS_MyAccounts_points_to_invest_succeed");
    }
    else if ([self.type isEqualToString:@"2"]) //互生币转货币
    {
             msg = kLocalized(@"GYHS_MyAccounts_hsCoin_to_cask_succeed");
    }
    [GYAlertView showMessage:msg confirmBlock:^{ [self popToTargetViewController];
    }];
}

- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    [GYGIFHUD dismiss];
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    NSString *msg;
    if (netRequest.retCode == 43268 || netRequest.retCode == 12476) {
        msg = [NSString stringWithFormat:@"该业务暂时不能受理！原因：%@",netRequest.msg];
        [GYUtils showMessage:msg];
        return;
    }
    [GYUtils parseNetWork:error resultBlock:nil];
}
- (void)popToTargetViewController
{
    if ([self.type isEqualToString:@"2"]) { //返回到互生币账户主界面
        for (UIViewController* vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:NSClassFromString(@"GYHSDToCashAccoutViewController")]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
    else { //返回到积分账户主界面
        for (UIViewController* vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:NSClassFromString(@"GYPointAccoutViewController")]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    data = globalData;
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    [self.HSDNextpointTableView registerNib:[UINib nibWithNibName:@"GYHSButtonCell" bundle:nil] forCellReuseIdentifier:@"GYHSButtonCell"];
    [self.HSDNextpointTableView registerNib:[UINib nibWithNibName:@"GYHSLableTextFileTableViewCell" bundle:nil] forCellReuseIdentifier:@"GYHSLableTextFileTableViewCell"];
    [self.HSDNextpointTableView registerNib:[UINib nibWithNibName:@"GYHSLabelTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"GYHSLabelTwoTableViewCell"];
    self.HSDNextpointTableView.backgroundColor = kDefaultVCBackgroundColor;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self.view endEditing:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.titileArray.count;
    }
    else {
        return 1;
    }
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0) {
        GYHSLabelTwoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLabelTwoTableViewCell" forIndexPath:indexPath];
        if (self.titileArray.count > indexPath.row) {
            cell.titleLabel.text = self.titileArray[indexPath.row];
        }
        if ([self.type isEqualToString:@"2"] && indexPath.row == 2) {
            NSString* string = @"1%";
            NSString* str = [NSString stringWithFormat:@"%@(%@)", self.titileArray[indexPath.row], string];
            NSMutableAttributedString* attrstr = [[NSMutableAttributedString alloc] initWithString:str];
            [attrstr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([self.titileArray[indexPath.row] length] + 1, [string length])];
            cell.titleLabel.attributedText = attrstr;
            if (indexPath.row == 0 || indexPath.row == 6) {
                //加粗
                [cell.detLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
            }
        }
        if (self.detArray.count - 1 != indexPath.row) { //隐藏多余的分割线
            cell.bottomlb.hidden = YES;
        }
        cell.titleLabelWith.constant = 170;
        if (self.detArray.count > indexPath.row) {
            cell.detLabel.text = self.detArray[indexPath.row];
        }
        [cell.detLabel setTextColor:kValueRedCorlor];
        cell.detLabel.textAlignment = NSTextAlignmentRight;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 1) {
        GYHSLableTextFileTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLableTextFileTableViewCell" forIndexPath:indexPath];
        cell.textField.placeholder = kLocalized(@"GYHS_MyAccounts_input_trading_pwd");
        cell.titleLabel.text = kLocalized(@"GYHS_MyAccounts_trade_pwd");
        [cell.textField setKeyboardType:UIKeyboardTypeNumberPad];
        cell.textField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textField setSecureTextEntry:YES];
        return cell;
    }
    else {
        GYHSButtonCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSButtonCell" forIndexPath:indexPath];
        [cell.btnTitle setTitle:kLocalized(@"GYHS_MyAccounts_confirm_to_submit") forState:UIControlStateNormal];
        [cell.btnTitle setBackgroundImage:[UIImage imageNamed:@"gyhs_btn_orange"] forState:UIControlStateNormal];
        [cell.btnTitle.titleLabel setFont:kButtonTitleDefaultFont];
        cell.backgroundColor = kDefaultVCBackgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.btnDelegate = self;
        return cell;
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self.view endEditing:YES];
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 2) {
        return 70;
    }
    return 50;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    view.backgroundColor = kDefaultVCBackgroundColor;
    return view;
}

#pragma mark 代理
///确认提交
- (void)nextBtn
{
    [self.view endEditing:YES];
    if (self.pwString.length != 8) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyAccounts_please_enter_trade_pwd")];
        return;
    }
    [self.view endEditing:YES];
    NSString *msg;
    if ([self.type isEqualToString:@"0"]) {
        msg = kLocalized(@"GYHS_MyAccounts_points_to_hsd_confirm");
    }
    else if ([self.type isEqualToString:@"1"]) {
         msg = kLocalized(@"GYHS_MyAccounts_points_to_invest_confirm");
    }
    else {
         msg = kLocalized(@"GYHS_MyAccounts_confirmToApplyForAlternateCurrencyTurnMoney") ;
    }

    [GYAlertView showMessage:msg cancleBlock:nil confirmBlock:^{
       [GYGIFHUD show];
        [self integral_transfer_hsb];
    }];
}

- (void)textField:(NSString*)string indextPath:(NSIndexPath*)indexPath
{
    self.pwString = string;
}
- (void)textFieldDidEndEditing:(UITextField*)textField
{
    self.pwString = textField.text;
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    if (range.location >= 8) {
        return NO;
    }
    else {
        return YES;
    }
}

#pragma mark 懒加载
- (NSArray*)titileArray
{
    if (!_titileArray) {
        if ([self.type isEqualToString:@"0"]) {
            _titileArray = [[NSArray alloc] initWithObjects:kLocalized(@"GYHS_MyAccounts_number_of_turn_to_cash"),
                                            kLocalized(@"GYHS_MyAccounts_tra_to_account"),
                                            kLocalized(@"GYHS_MyAccounts_settlement_currency"),
                                            kLocalized(@"GYHS_MyAccounts_converted_to_hsd_now"), nil];
        }
        else if ([self.type isEqualToString:@"1"]) {
            _titileArray = [[NSArray alloc] initWithObjects:kLocalized(@"GYHS_MyAccounts_investment_points"),
                                            kLocalized(@"GYHS_MyAccounts_tra_to_account"), nil];
        }
        else if ([self.type isEqualToString:@"2"]) {
            _titileArray = [[NSArray alloc] initWithObjects:
                                                kLocalized(@"GYHS_MyAccounts_input_hsdtocash_to_cash_amount"),
                                            kLocalized(@"GYHS_MyAccounts_tra_to_account"),
                                            kLocalized(@"GYHS_MyAccounts_hsdtocash_to_cash_fee"),
                                            kLocalized(@"GYHS_MyAccounts_hsd_to_cash_actual_amount"),
                                            kLocalized(@"GYHS_MyAccounts_local_settlement_currency"),
                                            kLocalized(@"GYHS_MyAccounts_hsCointoCash_rate"),
                                            kLocalized(@"GYHS_MyAccounts_converted_to_cash_now"), nil];
        }
    }
    return _titileArray;
}
- (NSArray*)detArray
{
    if (!_detArray) {
        if ([self.type isEqualToString:@"0"]) {
            _detArray = [[NSArray alloc] initWithObjects:
                                             [GYUtils formatCurrencyStyle:[self.integral doubleValue]],
                                         kLocalized(@"GYHS_MyAccounts_accounts"),
                                         kLocalized(@"GYHS_MyAccounts_money"),
                                         [GYUtils formatCurrencyStyle:[self.integral doubleValue]], nil];
        }
        else if ([self.type isEqualToString:@"1"]) {
            _detArray = [[NSArray alloc] initWithObjects:
                                             [GYUtils formatCurrencyStyle:[self.integral doubleValue]],
                                         kLocalized(@"GYHS_MyAccounts_investment_account"), nil];
        }
        else {
            _detArray = self.delArray;
        }
    }
    return _detArray;
}
- (UITableView*)HSDNextpointTableView
{
    if (!_HSDNextpointTableView) {
        _HSDNextpointTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
        _HSDNextpointTableView.dataSource = self;
        _HSDNextpointTableView.delegate = self;
    
        [self.view addSubview:_HSDNextpointTableView];
    }
    return _HSDNextpointTableView;
}

@end
