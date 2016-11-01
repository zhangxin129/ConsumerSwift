//
//  GYConfirmTransferInfoViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-30.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#import "GYHSConfirmTransferInfoVC.h"
#import "GYGIFHUD.h"
#import "GYAccounTradeAlertView.h"
#import "GYHSCardBandModel.h"
#import "NSString+YYAdd.h"
#import "GYAlertView.h"
#import "GYHSLoginManager.h"
#import "GYHSButtonCell.h"
#import "GYHSLableTextFileTableViewCell.h"
#import "GYHSLabelTwoTableViewCell.h"

#define kCellTextFont [UIFont systemFontOfSize:15]

@interface GYHSConfirmTransferInfoVC () <UITextFieldDelegate, GYNetRequestDelegate, UITableViewDataSource, UITableViewDelegate, GYHSButtonCellDelegate> {
    GlobalData* data; //全局单例
}
@property (nonatomic, strong) UITableView* confirmTransferTableView;
@property (nonatomic, copy) NSArray* titileArray;
@property (nonatomic, assign) double fee; //汇率
@property (nonatomic, copy) NSString* tradepwdstr;
@property (nonatomic, copy) NSString* userName;
@property (nonatomic, copy) NSString* feestr;
@end

@implementation GYHSConfirmTransferInfoVC

#pragma mark - 网络数据交换
- (void)get_transfer_cash_to_bank_fee //获取现金账户转账银行扣除手续费
{

    NSDictionary* allFixParas = @{
        @"transAmount" : [@(self.inputValue) stringValue],
        @"sysFlag" : @"N"
    };
    NSMutableDictionary* allParas = [NSMutableDictionary dictionaryWithDictionary:allFixParas];
    [allParas setValue:kSaftToNSString(self.bandCardModel.bankCode) forKey:@"inAccBankNode"];
    [allParas setValue:kSaftToNSString(self.bandCardModel.cityCode) forKey:@"inAccCityCode"];
    GYNetRequest* requset = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlGetBankTransFee parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    [requset setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    requset.tag = 1;
    [GYGIFHUD show];
    [requset start];
}
- (void)transfer_cash_to_bank // 现金账户转账到银行卡
{
    NSDictionary* allFixParas = @{
        @"channel" : kChannelMOBILE,
        @"custType" : globalData.loginModel.cardHolder ? kCustTypeCard : kCustTypeNoCard, //非持卡人传51
        @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard,
        @"transPwd" : [self.tradepwdstr md5String],

    };
    NSMutableDictionary* allParas = [NSMutableDictionary dictionaryWithDictionary:allFixParas];
    [allParas setValue:kSaftToNSString(data.loginModel.resNo) forKey:@"hsResNo"];
    [allParas setValue:kSaftToNSString(data.loginModel.custId) forKey:@"custId"];
    [allParas setValue:kSaftToNSString(self.bandCardModel.bankAccNo) forKey:@"bankAcctNo"];
    if (globalData.loginModel.cardHolder) {
        [allParas setValue:kSaftToNSString(data.loginModel.custName) forKey:@"custName"];
        [allParas setValue:kSaftToNSString(data.loginModel.resNo) forKey:@"reqOptId"];
        [allParas setValue:kSaftToNSString(data.loginModel.custName) forKey:@"reqOptName"];
    }
    else {
        [allParas setValue:kSaftToNSString(self.userName) forKey:@"custName"];
        [allParas setValue:kSaftToNSString(data.loginModel.userName) forKey:@"reqOptId"];
        [allParas setValue:kSaftToNSString(self.userName) forKey:@"reqOptName"];
    }

    [allParas setValue:kSaftToNSString(self.bandCardModel.bankCode) forKey:@"bankNo"];
    [allParas setValue:kSaftToNSString(self.bandCardModel.provinceCode) forKey:@"bankProvinceNo"];
    [allParas setValue:kSaftToNSString(self.bandCardModel.cityCode) forKey:@"bankCityNo"];
    [allParas setValue:kSaftToNSString(self.bandCardModel.bankAccName) forKey:@"bankAcctName"];
    [allParas setValue:kSaftToNSString(globalData.custGlobalDataModel.currencyCode) forKey:@"currencyCode"];

    [allParas setValue:kSaftToNSString(self.arrStrings[0]) forKey:@"amount"];
    [allParas setValue:kSaftToNSString(self.bandCardModel.bankBranch) forKey:@"bankBranch"];
    [allParas setValue:kSaftToNSString(self.bandCardModel.isValidAccount) forKey:@"isVerify"];
    [allParas setValue:kSaftToNSString(self.feestr) forKey:@"feeAmt"];
    //银行账号编号
    [allParas setValue:kSaftToNSString(self.bandCardModel.accId) forKey:@"accId"];

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlSaveTransOut parameters:allParas requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    request.tag = 2;
    [GYGIFHUD show];
    [request start];
}

- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    [GYGIFHUD dismiss];
    if (request.tag == 1) {
        self.fee = [responseObject[@"data"] doubleValue] * 0.01;
        //预计银行扣除手续费行
        self.feestr = [self formatString:responseObject[@"data"] decimalPointNum:2];
    }
    else {
        [GYAlertView showMessage:@"货币转银行操作提交成功" confirmBlock:^{
            for (UIViewController* vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:NSClassFromString(@"GYCashAccountViewController")]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }];
        data.user.isNeedRefresh = YES;
    }
    [self.confirmTransferTableView reloadData];
}
- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error
{
    [GYGIFHUD dismiss];
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);

    if (request.tag == 1) {
        WS(weakSelf)
            [GYUtils parseNetWork:error resultBlock:^(NSInteger retCode) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
    }
    else {
        if (request.tag == 2) {
            NSInteger returnCode = [[request.responseObject objectForKey:@"retCode"] integerValue];
            if (returnCode == 43295) {
                [GYUtils showMessage:kLocalized(@"GYHS_MyAccounts_not_doSomething_about_bank_when_importInfo_change")];
                return;
            }
            if (request.retCode == 43268) {
                [GYUtils showMessage:[NSString stringWithFormat:@"该业务暂时不能受理！原因：%@", request.msg]];
                return;
            }
        }

        [GYUtils parseNetWork:error resultBlock:nil];
    }
}
/**
 *  请求拿到个人信息里面的那个name 就是为了来判断是否跟屌丝银行卡的的name是否一样。
 */
- (void)cardHolder
{
    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kHSGetInfo parameters:@{ @"userId" : kSaftToNSString(globalData.loginModel.custId) } requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
         [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary *dic = responseObject[@"data"];
        self.userName = kSaftToNSString(dic[@"name"]);
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.confirmTransferTableView registerNib:[UINib nibWithNibName:@"GYHSButtonCell" bundle:nil] forCellReuseIdentifier:@"GYHSButtonCell"];
    [self.confirmTransferTableView registerNib:[UINib nibWithNibName:@"GYHSLableTextFileTableViewCell" bundle:nil] forCellReuseIdentifier:@"GYHSLableTextFileTableViewCell"];
    [self.confirmTransferTableView registerNib:[UINib nibWithNibName:@"GYHSLabelTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"GYHSLabelTwoTableViewCell"];
    self.confirmTransferTableView.backgroundColor = kDefaultVCBackgroundColor;

    if (!globalData.loginModel.cardHolder)
        [self cardHolder];
    //实例化单例
    data = globalData;

    //设置控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    //添加点击隐藏键盘
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.confirmTransferTableView addGestureRecognizer:tapGesture];
    [self get_transfer_cash_to_bank_fee];
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
        if (indexPath.row > 6) {
            cell.titleLabelWith.constant = 180;
        }
        [cell.detLabel setTextColor:kValueRedCorlor];

        if (indexPath.row == 7) {
            cell.detLabel.text = self.feestr;
        }
        else if (indexPath.row == 1) {
            NSString* str = nil;
            if (self.arrStrings.count > indexPath.row) {
                str = self.arrStrings[indexPath.row];
            }
            if (str.length > 8 && ![globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {
                cell.detLabel.text = [NSString stringWithFormat:@"%@***** ****%@", [str substringToIndex:4], [str substringFromIndex:str.length - 4]];
            }
            else {
                if (self.arrStrings.count > indexPath.row) {
                    cell.detLabel.text = self.arrStrings[indexPath.row];
                }
            }
        }
        else if (indexPath.row == 0 || indexPath.row == 6) {
            [cell.detLabel setTextColor:kNavigationBarColor];
            cell.detLabel.font = [UIFont boldSystemFontOfSize:16]; //加粗
            if (self.arrStrings.count > indexPath.row) {
                cell.detLabel.text = [self formatString:self.arrStrings[indexPath.row] decimalPointNum:2];
            }
        }
        else {
            [cell.detLabel setTextColor:kValueRedCorlor];
            if (self.arrStrings.count > indexPath.row) {
                cell.detLabel.text = self.arrStrings[indexPath.row];
            }
        }
        if (indexPath.row != 7) {
            cell.bottomlb.hidden = YES;
        }
        cell.detLabel.textAlignment = NSTextAlignmentRight;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 1) {
        GYHSLableTextFileTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLableTextFileTableViewCell" forIndexPath:indexPath];
        cell.textField.placeholder = kLocalized(@"GYHS_MyAccounts_input_trading_pwd");
        cell.titleLabel.text = kLocalized(@"GYHS_MyAccounts_trade_pwd");
        cell.textField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textField setSecureTextEntry:YES];
        return cell;
    }
    else {
        GYHSButtonCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSButtonCell" forIndexPath:indexPath];
        [cell.btnTitle setTitle:kLocalized(@"GYHS_MyAccounts_confirm") forState:UIControlStateNormal];
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

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
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
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 2) {
        return 60;
    }
    return 50;
}
//确认汇款按钮点击事件
- (void)nextBtn
{
    if (self.tradepwdstr.length != 8) {
        [GYAlertView showMessage:kLocalized(@"GYHS_MyAccounts_please_enter_trade_pwd")];
        return;
    }
    if (self.inputValue > self.cashAccountValue) {
        [GYAlertView showMessage:kLocalized(@"GYHS_MyAccounts_currencyAccountBalanceInsufficientPleaseRe-enterTheAmountTransferredOut") confirmBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        return;
    }

    [GYAlertView showMessage:kLocalized(@"GYHS_MyAccounts_confirmToApplyForMoneyTransferBankOperations") cancleBlock:^{
        DDLogDebug(@"The user cancle.");
    } confirmBlock:^{
        [self transfer_cash_to_bank];
    }];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self hideKeyboard:nil];
}

- (void)hideKeyboard:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

#pragma mark textfield
- (void)textFieldDidEndEditing:(UITextField*)textField
{
    self.tradepwdstr = textField.text;
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    // modify by songjk 计算长度修改
    NSString* toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    unsigned long len = toBeString.length;

    if (len > 8) {
        [self.view endEditing:YES];

        return NO;
    }

    return YES;
}

/**
 *   Input:str:传入的数字字符串(eg:@"100") decimalPointNum:需要的小数点位数(eg:2)
 *   Output:100.00
 */
- (NSString*)formatString:(NSString*)str decimalPointNum:(NSInteger)decimalPointNum
{

    if (decimalPointNum == 4)
        return [NSString stringWithFormat:@"%.4f", [str doubleValue]];
    else
        return [GYUtils formatCurrencyStyle:[str doubleValue]];
}
#pragma mark 懒加载
- (NSArray*)titileArray
{
    if (!_titileArray) {
        _titileArray = @[ kLocalized(@"GYHS_MyAccounts_apply_transfer_amount"),
            kLocalized(@"GYHS_MyAccounts_transfer_to_bank_account"),
            kLocalized(@"GYHS_MyAccounts_name_of_payee"),
            kLocalized(@"GYHS_MyAccounts_bank"),
            kLocalized(@"GYHS_MyAccounts_bank_open_area"),
            kLocalized(@"GYHS_MyAccounts_local_settlement_currency"),
            kLocalized(@"GYHS_MyAccounts_actual_account_amount"),
            kLocalized(@"GYHS_MyAccounts_transfer_fee"),
        ];
    }
    return _titileArray;
}

- (UITableView*)confirmTransferTableView
{
    if (!_confirmTransferTableView) {
        _confirmTransferTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        _confirmTransferTableView.dataSource = self;
        _confirmTransferTableView.delegate = self;
        [self.view addSubview:_confirmTransferTableView];
    }
    return _confirmTransferTableView;
}

@end
