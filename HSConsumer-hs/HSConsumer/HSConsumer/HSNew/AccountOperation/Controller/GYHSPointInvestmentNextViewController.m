//
//  GYHSPointInvestmentNextViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSPointInvestmentNextViewController.h"
#import "GYPasswordKeyboardView.h"
#import "GYHSPointInvestmentViewController.h"
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
#import "IQKeyboardManager.h"
#import "GYHSTools.h"

@interface GYHSPointInvestmentNextViewController () <GYNetRequestDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, GYPasswordKeyboardViewDelegate> {
    GlobalData* data; //全局单例
}
@property (nonatomic, strong) UITableView* HSDNextpointTableView;
@property (nonatomic, copy) NSArray* titileArray;
@property (nonatomic, copy) NSArray* detArray;
@property (nonatomic, weak) GYPasswordKeyboardView* pk;
@end

@implementation GYHSPointInvestmentNextViewController
#pragma mark-- life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    data = globalData;
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    [self.view addSubview:self.HSDNextpointTableView];
    [self.HSDNextpointTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSButtonCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSButtonCell"];
    [self.HSDNextpointTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSLableTextFileTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSLableTextFileTableViewCell"];
    [self.HSDNextpointTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSLabelTwoTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSLabelTwoTableViewCell"];
    self.HSDNextpointTableView.backgroundColor = kDefaultVCBackgroundColor;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self.view endEditing:YES];
}
#pragma mark-- 网络请求
- (void)integral_transfer_hsb:(NSString*)password //转现数只可为整数，不可带数点
{
    NSString* url;
    NSDictionary* allFixParas = nil;
    GYHSLoginModel* model = [GYHSLoginManager shareInstance].loginModuleObject;
    if (self.accountOperationType == GYHSPointHSBType) {
        url = kPointToHSDUrlString;
        allFixParas = @{
            @"custType" : globalData.loginModel.cardHolder ? kCustTypeCard : kCustTypeNoCard,
            @"amount" : kSaftToNSString(self.integral),
            @"channel" : kChannelMOBILE,
            @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard,
            @"transPwd" : kSaftToNSString([password md5String]),
        };
    }
    else if (self.accountOperationType == GYHSPointInvestmentType) {
        url = kPointInvestUrlString;
        allFixParas = @{
            @"investAmount" : kSaftToNSString(self.integral),
            @"custType" : globalData.loginModel.cardHolder ? kCustTypeCard : kCustTypeNoCard,
            @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard,
            @"transPwd" : kSaftToNSString([password md5String]),
            @"channel" : @"4"
        };
    }
    else if (self.accountOperationType == GYHSHSBCurrencyType) {
        url = kHSDToCashToCashAccountUrlString;
        allFixParas = @{
            @"fromHsbAmt" : self.integral,
            @"toCashAmt" : self.delArray[2],
            @"channel" : kChannelMOBILE,
            @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard,
            @"transPwd" : [password md5String]
        };
    }
    NSMutableDictionary* allParas = [NSMutableDictionary dictionaryWithDictionary:allFixParas];
    if (self.accountOperationType == GYHSHSBCurrencyType) { //互生币转货币
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
    [GYGIFHUD show];
    [request start];
}
#pragma mark GYnetRequestDelegate

- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    [GYGIFHUD dismiss];
    DDLogDebug(@"responseObject:%@", responseObject);
    NSString* msg;
    if (self.accountOperationType == GYHSPointHSBType) { //积分转互生币
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pvCountChange" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hsCoinChange" object:nil userInfo:nil];
        
        msg = kLocalized(@"GYHS_MyAccounts_points_to_hsd_succeed");
    }
    else if (self.accountOperationType == GYHSPointInvestmentType) { //积分投资
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pvCountChange" object:nil userInfo:nil];
        msg = kLocalized(@"GYHS_MyAccounts_points_to_invest_succeed");
    }
    else if (self.accountOperationType == GYHSHSBCurrencyType) //互生币转货币
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"currencyChange" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hsCoinChange" object:nil userInfo:nil];
        msg = kLocalized(@"GYHS_MyAccounts_hsCoin_to_cask_succeed");
    }
    [GYUtils showMessage:msg confirm:^{
        if (self.successfulDealDelegate && [_successfulDealDelegate respondsToSelector:@selector(successfulDeal)]) {
            [self.successfulDealDelegate successfulDeal];
        }
        [self popToTargetViewController];
    } withColor:kBtnBlue];
}

- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    [GYGIFHUD dismiss];
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    NSString* msg;
    if (netRequest.retCode == 43268 || netRequest.retCode == 12476) {
        msg = [NSString stringWithFormat:@"该业务暂时不能受理！原因：%@", netRequest.msg];
        [GYUtils showMessage:msg];
        return;
    }
    [GYUtils parseNetWork:error resultBlock:nil];
}
#pragma  mark -- 交易成功后返回具体界面
- (void)popToTargetViewController
{
    if (self.accountOperationType == GYHSHSBCurrencyType) { //返回到互生币账户主界面
        for (UIViewController* vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:NSClassFromString(@"GYHSMainViewController")]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
    else { //返回到积分账户主界面
        for (UIViewController* vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:NSClassFromString(@"GYHSMainViewController")]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titileArray.count;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    GYHSLabelTwoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLabelTwoTableViewCell" forIndexPath:indexPath];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.titileArray.count > indexPath.row) {
        cell.titleLabel.text = self.titileArray[indexPath.row];
    }
    if (self.accountOperationType == GYHSHSBCurrencyType && indexPath.row == 1) {
        NSString* string = @"1%";
        NSString* str = [NSString stringWithFormat:@"%@(%@)", self.titileArray[indexPath.row], string];
        NSMutableAttributedString* attrstr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrstr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([self.titileArray[indexPath.row] length] + 1, [string length])];
        cell.titleLabel.attributedText = attrstr;
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
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
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

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    GYPasswordKeyboardView* pk = [[GYPasswordKeyboardView alloc] init];
    pk.frame =CGRectMake(0, 0, kScreenWidth, 5 * (kScreenHeight/12) );
    pk.style = GYPasswordKeyboardStyleTrading;
    pk.delegate = self;
    [pk pop:footerView];
    return footerView;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.view endEditing:YES];
}
#pragma mark-- GYPasswordKeyboardViewDelegate
- (void)returnPasswordKeyboard:(GYPasswordKeyboardView*)passwordKeyboard style:(GYPasswordKeyboardStyle)style type:(GYPasswordKeyboardReturnType)type password:(NSString*)password
{
    if (password.length != 8) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyAccounts_please_enter_trade_pwd")];
        return;
    }
    [self integral_transfer_hsb:password];
}
- (void)cancelClick //  取消/返回时触发
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 懒加载
- (NSArray*)titileArray
{
    if (!_titileArray) {
        if (self.accountOperationType == GYHSPointHSBType) {
            _titileArray = [[NSArray alloc] initWithObjects:kLocalized(@"积分转互生币数"),

                                            kLocalized(@"互生币账户到账数"), nil];
        }
        else if (self.accountOperationType == GYHSPointInvestmentType) {
            _titileArray = [[NSArray alloc] initWithObjects:kLocalized(@"投资积分数"),
                                            kLocalized(@"投资账户到账数"), nil];
        }
        else if (self.accountOperationType == GYHSHSBCurrencyType) {
            _titileArray = [[NSArray alloc] initWithObjects:
                                            kLocalized(@"互生币转货币数"),
                                            kLocalized(@"GYHS_MyAccounts_hsdtocash_to_cash_fee"),
                                            kLocalized(@"货币账户到账数"), nil];
        }
    }
    return _titileArray;
}
- (NSArray*)detArray
{
    if (!_detArray) {
        if (self.accountOperationType == GYHSPointHSBType) {
            _detArray = [[NSArray alloc] initWithObjects:
            [GYUtils formatCurrencyStyle:[self.integral doubleValue]],
            [GYUtils formatCurrencyStyle:[self.integral doubleValue]], nil];
        }
        else if (self.accountOperationType == GYHSPointInvestmentType) {
            _detArray = [[NSArray alloc] initWithObjects:
                         [GYUtils formatCurrencyStyle:[self.integral doubleValue]],
                         [GYUtils formatCurrencyStyle:[self.integral doubleValue]], nil];
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
        _HSDNextpointTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
        _HSDNextpointTableView.dataSource = self;
        _HSDNextpointTableView.delegate = self;
        _HSDNextpointTableView.delaysContentTouches = NO;
    }
    return _HSDNextpointTableView;
}

@end
