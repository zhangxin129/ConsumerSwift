//
//  aaaaaViewController.m
//  HSConsumer
//
//  Created by apple on 15/12/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  支付限额设置

#import "GYPayLimitationSettingController.h"
#import "InputCellStypeView.h"
#import "GYAlertView.h"
#import "GYHsbPayLimitModel.h"
#import "MJExtension.h"
#import "GYHSLoginManager.h"
#import "UIButton+GYExtension.h"
#import "NSString+YYAdd.h"

@interface GYPayLimitationSettingController () <UITextFieldDelegate, GYNetRequestDelegate> {
    __weak IBOutlet InputCellStypeView* cellSingleCurrencyPayLimitation;
    __weak IBOutlet InputCellStypeView* cellSingleDayPayLimitation;
    __weak IBOutlet InputCellStypeView* cellInputPassword; //交易密码行

    __weak IBOutlet UIView* vCellback; //验证码行
    __weak IBOutlet UILabel* lbVerificationcodeTitle;
    __weak IBOutlet UITextField* tfVerificationCode;
    __weak IBOutlet UILabel* lbVerificationCode;

    GlobalData* data; //全局单例
}
@property (weak, nonatomic) IBOutlet UIScrollView* scrollViewLimitation;

@property (weak, nonatomic) IBOutlet UISwitch* switchCurrencyPay; //单笔限额开关

@property (weak, nonatomic) IBOutlet UISwitch* switchDayPay; //单日限额开关

@property (weak, nonatomic) IBOutlet UITextField* currencyPaytextField; //单笔限额输入框

@property (weak, nonatomic) IBOutlet UITextField* dayPayTextField; //单日限额输入框

@property (nonatomic, copy) NSString* code;
@property (nonatomic, copy) NSString* currencyPayLimit; //单笔限额开关的状态
@property (nonatomic, copy) NSString* dayPayLimit; //单日限额开关的状态
@property (nonatomic, assign) BOOL isSelected; //是否选中
@property (nonatomic, strong) GYHsbPayLimitModel* model;

@property (nonatomic, copy) NSString* sysPayDayMax; //单日最大值
@property (nonatomic, copy) NSString* sysPayMax; //单笔最大值

@end

@implementation GYPayLimitationSettingController
- (void)get_payLimit_info //查询互生币支付限额
{
    NSDictionary* allParas = @{ @"custId" : kSaftToNSString(data.loginModel.custId),
        @"systemType" : kSystemTypeConsumer };

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kHsbQueryPayLimitUrlString parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    request.tag = 1;
    [GYGIFHUD show];
    [request start];
}
- (void)push_modify_payLimit_info:(UIButton*)btn
{
    [self.view endEditing:YES];

    if (!cellInputPassword.tfRightTextField.text || cellInputPassword.tfRightTextField.text.length != 8) {
        [self.view makeToast:kLocalized(@"GYHS_MyAccounts_pleaseEnterTheCorrectPassword") duration:1 position:CSToastPositionCenter];
        return;
    }
    if (tfVerificationCode.text.length == 0) {
        [GYUtils showToast:kLocalized(@"GYHS_MyAccounts_pleaseInputVerificationCode")];
        return;
    }

    if (![[tfVerificationCode.text lowercaseString] isEqualToString:[lbVerificationCode.text lowercaseString]]) {
        [self.view makeToast:kLocalized(@"GYHS_MyAccounts_validationError") duration:1 position:CSToastPositionCenter];
        return;
    }

    if ([cellInputPassword.tfRightTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {

        [self.view makeToast:kLocalized(@"GYHS_MyAccounts_pleaseInputTradeCode") duration:1 position:CSToastPositionCenter];
        return;
    }
    if ([self.dayPayTextField.text doubleValue] > [self.sysPayDayMax doubleValue] && self.sysPayDayMax) {
        [self.view makeToast:[NSString stringWithFormat:@"%@%@", kLocalized(@"GYHS_MyAccounts_dailyPayIsNotGreaterThanTheLimit"), self.sysPayDayMax] duration:1 position:CSToastPositionCenter];
        return;
    }
    if ([self.currencyPaytextField.text doubleValue] > [self.sysPayMax doubleValue] && self.sysPayMax) {
        [self.view makeToast:[NSString stringWithFormat:@"%@%@", kLocalized(@"GYHS_MyAccounts_singlePayNoMoreThanTheLimit"), self.sysPayMax] duration:1 position:CSToastPositionCenter];
        return;
    }

    NSString* currencyPaystr = [GYUtils deformatterCurrencyStyle:self.currencyPaytextField.text flag:@","];
    NSString* dayPaystr = [GYUtils deformatterCurrencyStyle:self.dayPayTextField.text flag:@","];

    if ([self.currencyPaytextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        currencyPaystr = @"0";
    }
    if ([self.dayPayTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        dayPaystr = @"0";
    }
    [GYGIFHUD show];

    NSDictionary* allParas = @{ @"custId" : kSaftToNSString(data.loginModel.custId),
        @"custName" : globalData.loginModel.cardHolder ? kSaftToNSString(globalData.loginModel.custName) : globalData.loginModel.userName, //非持卡人传userName
        @"hsResNo" : kSaftToNSString(data.loginModel.resNo),
        @"systemType" : kSaftToNSString(kSystemTypeConsumer),
        @"payMax" : [self.currencyPayLimit isEqualToString:@"Y"] ? kSaftToNSString(currencyPaystr) : @"0", //不设置传0
        @"payDayMax" : [self.dayPayLimit isEqualToString:@"Y"] ? kSaftToNSString(dayPaystr) : @"0",

        @"payMaxSwitch" : kSaftToNSString(self.currencyPayLimit),
        @"payDayMaxSwitch" : kSaftToNSString(self.dayPayLimit),

        @"transPwd" : kSaftToNSString([cellInputPassword.tfRightTextField.text md5String]),
        @"userType" : kSaftToNSString(globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard) };
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kHsbSetPayLimitUrlString parameters:allParas requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON];
    request.tag = 2;
    btn.tag = 100;
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
    [btn controlTimeOut];
}
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    [GYGIFHUD dismiss];
    if (request.tag == 1) {
        NSDictionary* dict = responseObject[@"data"];
        self.model = [GYHsbPayLimitModel mj_objectWithKeyValues:responseObject[@"data"]];
        [self setValues];
        self.sysPayDayMax = dict[@"sysPayDayMax"];
        self.sysPayMax = dict[@"sysPayMax"];
    }
    else {
        UIButton* btn = (UIButton*)[self.view viewWithTag:100];
        [self get_payLimit_info];
        [GYAlertView showMessage:kLocalized(@"GYHS_MyAccounts_setTheAlternateCurrencyPayLimitationSuccess")];
        self.isSelected = NO;
        btn.selected = self.isSelected;
        cellSingleCurrencyPayLimitation.hidden = NO;
        cellSingleDayPayLimitation.hidden = NO;
        self.scrollViewLimitation.hidden = YES;
        btn.frame = CGRectMake(20, 110, kScreenWidth - 40, 44);
        [self.view addSubview:btn];
        [self reloadInputViews];
        //[self setTextFieldIsEnable:NO];
        cellInputPassword.hidden = YES;
        vCellback.hidden = YES;
    }
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
        [GYUtils parseNetWork:error resultBlock:nil];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    data = globalData;
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    self.currencyPayLimit = @"N";
    self.dayPayLimit = @"N";
    self.isSelected = NO;
    self.scrollViewLimitation.hidden = YES;
    self.currencyPaytextField.delegate = self;
    self.dayPayTextField.delegate = self;
    UIButton* btnChage = [UIButton buttonWithType:UIButtonTypeCustom];
    btnChage.frame = CGRectMake(20, 110, kScreenWidth - 40, 44);
    [btnChage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnChage setBackgroundImage:[UIImage imageNamed:@"hs_btn_confirm_bg.png"] forState:UIControlStateNormal];
    [btnChage setTitle:kLocalized(@"GYHS_MyAccounts_modify") forState:UIControlStateNormal];
    [btnChage setTitle:kLocalized(@"GYHS_MyAccounts_save") forState:UIControlStateSelected];
    [btnChage addTarget:self action:@selector(changeData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnChage];
    cellSingleCurrencyPayLimitation.lbLeftlabel.text = kLocalized(@"GYHS_MyAccounts_HSBCurrencyPayLimitation");
    cellSingleCurrencyPayLimitation.tfRightTextField.textColor = kNavigationBarColor;
    cellSingleCurrencyPayLimitation.tfRightTextField.userInteractionEnabled = NO;
    cellSingleCurrencyPayLimitation.tfRightTextField.placeholder = @"";
    cellSingleDayPayLimitation.lbLeftlabel.text = kLocalized(@"GYHS_MyAccounts_HSBDailyTransactionLimit");
    cellSingleDayPayLimitation.tfRightTextField.textColor = kNavigationBarColor;
    cellSingleDayPayLimitation.tfRightTextField.userInteractionEnabled = NO;
    cellSingleDayPayLimitation.tfRightTextField.placeholder = @"";
    cellInputPassword.lbLeftlabel.text = kLocalized(@"GYHS_MyAccounts_trade_pwd");
    cellInputPassword.tfRightTextField.userInteractionEnabled = YES;
    cellInputPassword.tfRightTextField.placeholder = kLocalized(@"GYHS_MyAccounts_input_trading_pwd");
    [cellInputPassword.tfRightTextField addTarget:self action:@selector(pwdLimit) forControlEvents:UIControlEventEditingChanged];
    lbVerificationcodeTitle.text = kLocalized(@"GYHS_MyAccounts_verification_code");
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getCodeText)];
    lbVerificationCode.userInteractionEnabled = YES;
    [lbVerificationCode addGestureRecognizer:tap];
    cellInputPassword.hidden = YES;
    vCellback.hidden = YES;
    lbVerificationcodeTitle.textColor = kCellItemTitleColor;
    tfVerificationCode.textColor = kCellItemTextColor;
    tfVerificationCode.placeholder = kLocalized(@"GYHS_MyAccounts_inputDynamicVerificationCode");
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self get_payLimit_info];
}
#pragma mark - 自定义方法
- (void)pwdLimit
{
    if (cellInputPassword.tfRightTextField.text.length > 8) {
        cellInputPassword.tfRightTextField.text = [cellInputPassword.tfRightTextField.text substringToIndex:8];
        [self.view endEditing:YES];
    }
}
- (void)setValues
{
    cellSingleCurrencyPayLimitation.tfRightTextField.text = [self.model.payMaxSwitch isEqualToString:@"Y"] ? [GYUtils formatCurrencyStyle:self.model.payMax.doubleValue] : @"-";
    cellSingleDayPayLimitation.tfRightTextField.text = [self.model.payDayMaxSwitch isEqualToString:@"Y"] ? [GYUtils formatCurrencyStyle:self.model.payDayMax.doubleValue] : @"-";
    // 在4S时字体要调整下
    if (kScreenWidth == 320) {
        [self sizeToFitForTextField:cellSingleCurrencyPayLimitation.tfRightTextField];
        [self sizeToFitForTextField:cellSingleDayPayLimitation.tfRightTextField];
    }
    [self reloadInputViews];
}
- (void)sizeToFitForTextField:(UITextField*)textField
{
    NSUInteger textLength = textField.text.length;
    DDLogDebug(@"%lu", (unsigned long)textLength);
    if (textLength > 15) {
        [textField setFont:[UIFont systemFontOfSize:13]];
    }
    else if (textLength > 10) {
        [textField setFont:[UIFont systemFontOfSize:14]];
    }
}
- (void)changeData:(UIButton*)btn
{
    [self.view endEditing:YES];
    if (btn.selected == NO) { //修改
        self.isSelected = YES;
        btn.selected = self.isSelected;
        self.scrollViewLimitation.hidden = NO;
        btn.frame = CGRectMake(20, 445, kScreenWidth - 40, 44);
        [self.scrollViewLimitation addSubview:btn];
        [self reloadInputViews];
        cellSingleCurrencyPayLimitation.hidden = YES;
        cellSingleDayPayLimitation.hidden = YES;
        cellInputPassword.hidden = NO;
        cellInputPassword.tfRightTextField.text = @"";
        vCellback.hidden = NO;
        tfVerificationCode.text = @"";
        [self.switchCurrencyPay addTarget:self action:@selector(switchCurrencyChange:) forControlEvents:UIControlEventValueChanged];
        [self.switchDayPay addTarget:self action:@selector(switchDayChange:) forControlEvents:UIControlEventValueChanged];
        [self switchCurrencyChange:self.switchCurrencyPay];
        [self switchDayChange:self.switchDayPay];
        [self getCodeText];
        [self setModifyValues];
    }
    else { //保存

        if (self.switchCurrencyPay.on && [GYUtils checkStringInvalid:self.currencyPaytextField.text]) {
            [self.view makeToast:kLocalized(@"GYHS_MyAccounts_pleaseInputPerLimitPay") duration:1 position:CSToastPositionCenter];
        }
        else if (self.switchDayPay.on && [GYUtils checkStringInvalid:self.dayPayTextField.text]) {
            [self.view makeToast:kLocalized(@"GYHS_MyAccounts_pleaseInputPerDayLimitPay") duration:1 position:CSToastPositionCenter];
        }
        else {
            if (self.switchCurrencyPay.on && self.switchDayPay.on) {
                if (kSaftToDouble(self.currencyPaytextField.text) <= kSaftToDouble(self.dayPayTextField.text)) {
                    [self push_modify_payLimit_info:btn];
                }
                else {
                    [self.view makeToast:kLocalized(@"GYHS_MyAccounts_perLimitPayDontMorethan") duration:1 position:CSToastPositionCenter];
                }
            }
            else {
                [self push_modify_payLimit_info:btn];
            }
        }
    }
}

- (void)switchCurrencyChange:(UISwitch*)swit
{
    if (swit.on) {
        [self setTextFieldIsEnable:YES];
        self.currencyPaytextField.placeholder = kLocalized(@"GYHS_MyAccounts_inputPerHSBLimitPay");
    }
    else {
        self.currencyPaytextField.placeholder = @"-";
        self.currencyPaytextField.text = @"";
        self.currencyPayLimit = @"N";
        [self setTextFieldIsEnable:NO];
    }
}

- (void)switchDayChange:(UISwitch*)swit
{
    if (swit.on) {
        self.dayPayTextField.placeholder = kLocalized(@"GYHS_MyAccounts_inputPerDayHSBLimitPay");
        [self setdayTextFieldIsEnable:YES];
    }
    else {
        self.dayPayTextField.placeholder = @"-";
        self.dayPayTextField.text = @"";
        self.dayPayLimit = @"N";
        [self setdayTextFieldIsEnable:NO];
    }
}

/*随机生成验证码*/
- (void)getCodeText
{
    self.code = [GYUtils getRandomString:4];
    lbVerificationCode.text = self.code;
    DDLogDebug(@"%@", self.code);
    NSInteger i = random() % 10;
    NSNumber* number;
    if (rand() % 2 == 0) {
        number = [NSNumber numberWithFloat:-i * .1];
    }
    else {
        number = [NSNumber numberWithFloat:i * .1];
    }
    lbVerificationCode.attributedText = [[NSAttributedString alloc] initWithString:lbVerificationCode.text attributes:@{ NSKernAttributeName : number, NSForegroundColorAttributeName : [UIColor blackColor] }];
}

//设置textField是否可编辑
- (void)setTextFieldIsEnable:(BOOL)isEnable
{
    self.currencyPaytextField.userInteractionEnabled = isEnable;
    self.currencyPayLimit = isEnable ? @"Y" : @"N";
}

//设置textField是否可编辑
- (void)setdayTextFieldIsEnable:(BOOL)isEnable
{
    self.dayPayTextField.userInteractionEnabled = isEnable;
    self.dayPayLimit = isEnable ? @"Y" : @"N";
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString* beStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == tfVerificationCode) {
        if (beStr.length > 4) {
            textField.text = [beStr substringToIndex:4];
            return NO;
        }
    }
    if (textField == cellInputPassword.tfRightTextField) {
        if (beStr.length > 8) {
            textField.text = [beStr substringToIndex:8];
            return NO;
        }
    }
    if (textField == self.currencyPaytextField) {
        if (beStr.length > 10) {
            textField.text = [beStr substringToIndex:10];
            return NO;
        }
    }
    if (textField == self.dayPayTextField) {
        if (beStr.length > 10) {
            textField.text = [beStr substringToIndex:10];
            return NO;
        }
    }
    if (beStr.length > 0) {
        NSCharacterSet* cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString* filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }

    return YES;
}

- (void)setModifyValues
{
    if ([self.model.payMaxSwitch isEqualToString:@"Y"]) {
        self.currencyPaytextField.text = self.model.payMax;
    }
    else {
        [self.switchCurrencyPay setOn:NO animated:NO];
        [self switchCurrencyChange:self.switchCurrencyPay];
    }
    if ([self.model.payDayMaxSwitch isEqualToString:@"Y"]) {
        self.dayPayTextField.text = self.model.payDayMax;
    } else {
        [self.switchDayPay setOn:NO animated:NO];
        [self switchDayChange:self.switchDayPay];
    }
}
@end
