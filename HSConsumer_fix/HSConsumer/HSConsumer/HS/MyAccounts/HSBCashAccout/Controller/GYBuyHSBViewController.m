//
//  GYOnlineBuyHSBViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-24.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYBuyHSBViewController.h"
#import "InputCellStypeView.h"
#import "ViewCellStyle.h"
#import "UIActionSheet+Blocks.h"
#import "GYGIFHUD.h"
#import "GYAlertView.h"
#import "GYCashBuyHSBOtherPaidStyleViewController.h"
#import "GYHSLoginManager.h"

@interface GYBuyHSBViewController () <UITextFieldDelegate> {
    IBOutlet UIScrollView* scvContainer; //滚动容器

    IBOutlet ViewCellStyle* viewRowAvailable;

    IBOutlet InputCellStypeView* viewRowInputAmount; //输入行
    IBOutlet InputCellStypeView* viewRowCurrency; //币种行

    IBOutlet InputCellStypeView* viewRowToHSDRate; //转换比例行
    IBOutlet InputCellStypeView* viewRowChangeConvertCash; //折合货币金额
    IBOutlet InputCellStypeView* viewRowShouldPaymentAmount; //应支付金额

    IBOutlet UILabel* lbTipMin0;
    IBOutlet UILabel* lbTipMin1;
    IBOutlet UILabel* lbTipMin2;
    IBOutlet UILabel* lbTipMin3;

    IBOutlet UIImageView* ivItem1; //说明各项前面的小图标
    IBOutlet UIImageView* ivItem2;
    IBOutlet UIImageView* ivItem3;

    IBOutlet UIButton* btnNext; //下一步按钮

    double inputValue; //购互生币数
    double todayCanBuyHSBAmount; //今日还可以购互生币数  持卡人
    double todatCanHanderHSBAmount; ///今日还可以兑换互生币数量 非持卡人

    NSString* realnameAuthErrorInfo;
    NSString* noRealnameAuthErrorInfo;
}
@property (nonatomic, copy) NSString* transNo; //流水号
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* tip2Height;
@property (nonatomic, strong) NSString* userName;

@property (nonatomic, strong) NSString* notRegisteredBuyHsbMaxmum;
@property (nonatomic, strong) NSString* notRegisteredBuyHsbMinimum;
@property (nonatomic, strong) NSString* registeredBuyHsbMaxmum;
@property (nonatomic, strong) NSString* registeredBuyHsbMinimum;

@end

@implementation GYBuyHSBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //设置控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    [scvContainer setContentSize:CGSizeMake(0, CGRectGetMaxY(btnNext.frame) + 80)];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGesture.cancelsTouchesInView = NO;
    [scvContainer addGestureRecognizer:tapGesture];

    viewRowAvailable.ivTitle.image = kLoadPng(@"hs_cell_img_HSC_to_cash_acc"); //设置图标
    viewRowAvailable.lbActionName.text = kLocalized(@"GYHS_MyAccounts_circulationcoin_balance");

    viewRowInputAmount.lbLeftlabel.text = kLocalized(@"GYHS_MyAccounts_exchange_hsCoin_count");
    [viewRowInputAmount.tfRightTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    [viewRowInputAmount.tfRightTextField setTextColor:[UIColor blackColor]];
    viewRowInputAmount.tfRightTextField.placeholder = kLocalized(@"GYHS_MyAccounts_input_HSCoin");
    viewRowInputAmount.tfRightTextField.delegate = self;

    viewRowCurrency.lbLeftlabel.text = kLocalized(@"GYHS_MyAccounts_local_settlement_currency");
    [viewRowCurrency.tfRightTextField setTextColor:kValueRedCorlor];
    // viewRowCurrency.tfRightTextField.placeholder=kLocalized(@"GYHS_MyAccounts_pleaseInput");

    viewRowToHSDRate.lbLeftlabel.text = kLocalized(@"GYHS_MyAccounts_hsCointoCash_rate");
    viewRowToHSDRate.tfRightTextField.text = [NSString stringWithFormat:@"%.4f", [globalData.custGlobalDataModel.hsbToHbRate doubleValue] * 100];
    [viewRowToHSDRate.tfRightTextField setTextColor:kValueRedCorlor];
    viewRowToHSDRate.tfRightTextField.placeholder = kLocalized(@"GYHS_MyAccounts_pleaseInput");

    viewRowChangeConvertCash.lbLeftlabel.text = kLocalized(@"GYHS_MyAccounts_buyHSCoinConvertCash");
    [viewRowChangeConvertCash.tfRightTextField setTextColor:kValueRedCorlor];
    viewRowChangeConvertCash.tfRightTextField.placeholder = kLocalized(@"GYHS_MyAccounts_pleaseInput");

    viewRowShouldPaymentAmount.lbLeftlabel.text = kLocalized(@"GYHS_MyAccounts_buyHSCoinShouldPaymentAmount");
    [viewRowShouldPaymentAmount.tfRightTextField setTextColor:kValueRedCorlor];
    viewRowShouldPaymentAmount.tfRightTextField.placeholder = kLocalized(@"GYHS_MyAccounts_pleaseInput");

    viewRowCurrency.tfRightTextField.text = globalData.custGlobalDataModel.currencyName;

    lbTipMin3.font = [UIFont systemFontOfSize:12];

    [lbTipMin0 setTextColor:kCellItemTextColor];
    [lbTipMin1 setTextColor:kCellItemTextColor];
    [lbTipMin2 setTextColor:kCellItemTextColor];
    [lbTipMin3 setTextColor:kCellItemTextColor];

    //设置说明项前图标颜色
    ivItem1.image = nil;
    [ivItem1 setBackgroundColor:kCorlorFromHexcode(0xef4136)];
    ivItem2.image = nil;
    [ivItem2 setBackgroundColor:kCorlorFromHexcode(0xef4136)];
    ivItem3.image = nil;
    [ivItem3 setBackgroundColor:kCorlorFromHexcode(0xef4136)];



    [GYUtils setFontSizeToFitWidthWithLabel:lbTipMin3 labelLines:2];

    [self get_cash_act_info];

    lbTipMin0.text = [NSString stringWithFormat:@"%@:", kLocalized(@"GYHS_MyAccounts_well_tip")];

    [btnNext setTitle:kLocalized(@"GYHS_MyAccounts_go_to_pay") forState:UIControlStateNormal];
    [btnNext.titleLabel setFont:kButtonTitleDefaultFont];
    [btnNext addTarget:self action:@selector(btnNextClick:) forControlEvents:UIControlEventTouchUpInside];

    if (globalData.loginModel.cardHolder) {
        self.userName = globalData.loginModel.custName;
    }
    else {
        [self queryUserInfo];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    //设置初始值
    todayCanBuyHSBAmount = 0;
    inputValue = 0.0;
    viewRowInputAmount.tfRightTextField.text = @"";

    [viewRowChangeConvertCash.tfRightTextField setText:@"0.00"];
    [viewRowShouldPaymentAmount.tfRightTextField setText:@"0.00"];

    [self loadqueryCusTipsUrlString];
}

//下一步操作
- (void)btnNextClick:(id)sender
{

    inputValue = [viewRowInputAmount.tfRightTextField.text doubleValue];
    [viewRowInputAmount.tfRightTextField resignFirstResponder];
    if (globalData.loginModel.cardHolder) {
        if (todayCanBuyHSBAmount <= 0 || inputValue > todayCanBuyHSBAmount) {
            [GYAlertView showMessage:kLocalized(@"GYHS_MyAccounts_forAlternateCurrencyAmountMoreThanTheDailyLimit")];
            return;
        }
    }
    else {
        if (todatCanHanderHSBAmount <= 0 || inputValue > todatCanHanderHSBAmount) {
            [GYAlertView showMessage:kLocalized(@"GYHS_MyAccounts_forAlternateCurrencyAmountMoreThanTheDailyLimit")];
            return;
        }
    }

    if (viewRowInputAmount.tfRightTextField && viewRowInputAmount.tfRightTextField.text.length > 0 && inputValue > 0) { //输入合法
        if (globalData.loginModel.cardHolder) { // 区分持卡人与非持卡人
            if ([globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusHadRes] ||
                [globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusHadCertify]) { //实名注册的

                if (!((inputValue >= self.registeredBuyHsbMinimum.doubleValue) && (inputValue <= self.registeredBuyHsbMaxmum.doubleValue))) {
                    [GYAlertView showMessage:realnameAuthErrorInfo];
                    return;
                }
            }
            else {
                if ((inputValue < self.notRegisteredBuyHsbMinimum.doubleValue)) {
                    [GYAlertView showMessage:noRealnameAuthErrorInfo];
                    return;
                }
                if ((inputValue > self.notRegisteredBuyHsbMaxmum.doubleValue)) {
                    [GYAlertView showMessage:noRealnameAuthErrorInfo];
                    return;
                }
            }
        }
        else {

            if (self.userName.length > 0) { //填写真实姓名

                if (!((inputValue >= self.registeredBuyHsbMinimum.doubleValue) && (inputValue <= self.registeredBuyHsbMaxmum.doubleValue))) {
                    [GYAlertView showMessage:realnameAuthErrorInfo];
                    return;
                }
            }
            else {
                if ((inputValue < self.notRegisteredBuyHsbMinimum.doubleValue)) {
                    [GYAlertView showMessage:noRealnameAuthErrorInfo];
                    return;
                }
                if ((inputValue > self.notRegisteredBuyHsbMaxmum.doubleValue)) {
                    [GYAlertView showMessage:noRealnameAuthErrorInfo];
                    return;
                }
            }
        }

        //add by zxm 20151228
        [self get_hsb_transfer_cash]; //请求兑换成功后跳转到支付界面
    }
    else { //输入不合法
        [GYAlertView showMessage:kLocalized(@"GYHS_MyAccounts_pleaseEnterTheExchangeQuantity")];
    }
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self hideKeyboard:nil];
}

- (void)hideKeyboard:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
//输入积分数，同步显示将转成现金数
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    // modify by songjk 计算长度修改
    NSString* toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    unsigned long len = toBeString.length;
    if (len > 12)
        return NO;

    NSString* str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    inputValue = [str doubleValue];

    if (inputValue < 0)
        return NO;

    double v1 = [globalData.custGlobalDataModel.currencyToHsbRate doubleValue] * inputValue;
    double v2 = [globalData.custGlobalDataModel.currencyToHsbRate doubleValue] * inputValue;

    [viewRowChangeConvertCash.tfRightTextField setText:[GYUtils formatCurrencyStyle:v1]];
    [viewRowShouldPaymentAmount.tfRightTextField setText:[GYUtils formatCurrencyStyle:v2]];

    return YES;
}

#pragma mark - 接口重构  by xiaoxh 20160330
- (void)get_cash_act_info //现金货币余额  用来判断是进入快捷支付 还是货币
{
    NSMutableDictionary* allParas = [[NSMutableDictionary alloc] init];
    [allParas setValue:kTypeCashBalanceDetail forKey:@"accCategory"];
    [allParas setValue:kSystemTypeConsumer forKey:@"systemType"];
    [allParas setValue:globalData.loginModel.custId forKey:@"custId"];
    [GYGIFHUD show];
    GYNetRequest *request =[[GYNetRequest alloc] initWithBlock:kAccountBalanceDetailUrlString parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary *dic = responseObject;
        globalData.user.cashAccBal = [dic[@"data"][@"accountBalance"] doubleValue];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

#pragma mark - 网络数据交换
//查询消费者兑换互生币温馨提示数据
- (void)loadqueryCusTipsUrlString
{
    NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
        @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard };

    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kHScardqueryCusTipsUrlString parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary *dic = responseObject[@"data"];
        globalData.user.todayBuyHsbTotalAmount = [dic[@"dayHadBuyHsb"] intValue];
        if (globalData.loginModel.cardHolder) {////持卡人
            
            self.notRegisteredBuyHsbMaxmum = dic[@"notRegBuyHsbMax"];
            self.notRegisteredBuyHsbMinimum= dic[@"notRegBuyHsbMin"];
            self.registeredBuyHsbMaxmum = dic[@"regBuyHsbMax"];
            self.registeredBuyHsbMinimum = dic[@"regBuyHsbMin"];
            
            
            lbTipMin1.text = [NSString stringWithFormat:kLocalized(@"GYHS_MyAccounts_userCanBuyHSCoinOneOrder"), [dic[@"regBuyHsbMin"] intValue], [dic[@"regBuyHsbMax"] intValue]];
            realnameAuthErrorInfo = [NSString stringWithFormat:kLocalized(@"GYHS_MyAccounts_exchange_HSCoin_range"), [dic[@"regBuyHsbMin"] intValue], [dic[@"regBuyHsbMax"] intValue]];
            
            lbTipMin2.text = [NSString stringWithFormat:kLocalized(@"GYHS_MyAccounts_unRealNameRegist_user_exchange_HSCoin_range"), [dic[@"notRegBuyHsbMin"] intValue], [dic[@"notRegBuyHsbMax"] intValue]];
            noRealnameAuthErrorInfo = [NSString stringWithFormat:kLocalized(@"GYHS_MyAccounts_unRealNameRegist_user_exchange_HSCoin_info"), [dic[@"notRegBuyHsbMin"] intValue], [dic[@"notRegBuyHsbMax"] intValue]];
            
            //将今日还可以兑换数量变成 红色
            NSString *key = ![globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusNoRes] ? @"regDayBuyHsbMax" :@"notRegDayBuyHsbMax" ;//标记是否实名注册的获取最大限额的key
            todayCanBuyHSBAmount = [dic[key] doubleValue] - [dic[@"dayHadBuyHsb"] doubleValue];
            NSString *str = [NSString stringWithFormat:@"每日兑换互生币数量最多为%zd，今日还可以兑换%.2f互生币。",  [dic[key] intValue], todayCanBuyHSBAmount];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:nil];
            [attStr addAttribute:NSForegroundColorAttributeName value:kNavigationBarColor range:[str rangeOfString:[NSString stringWithFormat:@"%.2f", todayCanBuyHSBAmount]]];
            lbTipMin3.attributedText = attStr;
            
        } else {///非持卡人
            
            self.notRegisteredBuyHsbMaxmum = dic[@"notRegBuyHsbMax"];
            self.notRegisteredBuyHsbMinimum= dic[@"notRegBuyHsbMin"];
            self.registeredBuyHsbMaxmum = dic[@"regBuyHsbMax"];
            self.registeredBuyHsbMinimum = dic[@"regBuyHsbMin"];
            
            lbTipMin1.text =  [NSString stringWithFormat:@"已填真实姓名用户单笔兑换数量为%.0f-%.0f互生币", [dic[@"regBuyHsbMin"] doubleValue], [dic[@"regBuyHsbMax"] doubleValue]];
            realnameAuthErrorInfo = [NSString stringWithFormat:@"已填真实姓名用户单笔兑换数量为%.0f-%.0f，请正确输入兑换数量", [dic[@"regBuyHsbMin"] doubleValue], [dic[@"regBuyHsbMax"] doubleValue]];
            
            
            lbTipMin2.text = [NSString stringWithFormat:@"未填真实姓名用户单笔兑换数量为%.0f-%.0f互生币", [dic[@"notRegBuyHsbMin"] doubleValue], [dic[@"notRegBuyHsbMax"] doubleValue]];
            noRealnameAuthErrorInfo = [NSString stringWithFormat:@"未填真实姓名用户单笔兑换数量为%.0f-%.0f，请正确输入兑换数量", [dic[@"notRegBuyHsbMin"] doubleValue], [dic[@"notRegBuyHsbMax"] doubleValue]];
            double buyHsb = [dic[self.userName.length > 0 ? @"regDayBuyHsbMax": @"notRegDayBuyHsbMax"] doubleValue] - [dic[@"dayHadBuyHsb"] doubleValue];
            
            todatCanHanderHSBAmount = buyHsb;
            NSString *str = [NSString stringWithFormat:@"每日兑换互生币数量最多为%.0f，今日还可以兑换%.2f互生币。", [dic[self.userName.length > 0 ? @"regDayBuyHsbMax": @"notRegDayBuyHsbMax"] doubleValue], buyHsb];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:nil];
            [attStr addAttribute:NSForegroundColorAttributeName value:kNavigationBarColor range:[str rangeOfString:[NSString stringWithFormat:@"%.2f", buyHsb]]];
            lbTipMin3.attributedText = attStr;
        }
        [self reloadInputViews];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)get_hsb_transfer_cash //兑换互生币
{
    NSString* amount = [NSString stringWithFormat:@"%.2f", [viewRowInputAmount.tfRightTextField.text doubleValue]];
    NSDictionary* allFixParas = @{
        @"channel" : kChannelMOBILE,
        @"buyHsbAmt" : kSaftToNSString(amount),
        @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard
    };
    NSMutableDictionary* allParas = [NSMutableDictionary dictionaryWithDictionary:allFixParas];
    if (globalData.loginModel.cardHolder) {
        //        @"custType": kCustTypeHSD,
        [allParas setValue:kCustTypeCard forKey:@"custType"];
    }
    else {
        [allParas setValue:kCustTypeNoCard forKey:@"custType"];
    }

    [allParas setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"custId"];

    [allParas setValue:globalData.loginModel.resNo ? kSaftToNSString(globalData.loginModel.resNo) : kSaftToNSString(globalData.loginModel.userName) forKey:@"hsResNo"];
    [allParas setValue:kSaftToNSString(self.userName) forKey:@"custName"];

    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kHSExchangeHsbUrlString parameters:allParas requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        NSDictionary *dic = responseObject;
        if (error) {
            NSInteger  errorRetCode = [error code];
            if ( errorRetCode == 43268)
            {
                [GYUtils showMessage:[NSString stringWithFormat:@"该业务暂时不能受理！原因：%@",dic[@"msg"]]];
                return;
                return ;
            }
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        self.transNo = kSaftToNSString(dic[@"data"]);
        NSString *shouldPayStr = viewRowShouldPaymentAmount.tfRightTextField.text;
        shouldPayStr = [shouldPayStr stringByReplacingOccurrencesOfString:@"," withString:@""];
        GYCashBuyHSBOtherPaidStyleViewController *currencyVC = kLoadVcFromClassStringName(NSStringFromClass([GYCashBuyHSBOtherPaidStyleViewController class]));
        currencyVC.inputValue = [shouldPayStr doubleValue];
        currencyVC.transNo = self.transNo;
        
        currencyVC.navigationItem.title = kLocalized(@"GYHS_MyAccounts_exchange_HSCoin_confirm");
        [self.navigationController pushViewController:currencyVC animated:YES];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)queryUserInfo
{
    self.userName = @"";

    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kHSGetInfo parameters:@{ @"userId" : kSaftToNSString(globalData.loginModel.custId) } requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
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

@end
