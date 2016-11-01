//
//  GYCashBuyHSBOtherPaidStyleViewController.m
//  HSConsumer
//
//  Created by apple on 15/12/17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYCashBuyHSBOtherPaidStyleViewController.h"
#import "GYAlertView.h"
#import "NSString+YYAdd.h"
#import "GYBaseQueryListViewController.h"
#import "GYOtherPayStyleViewController.h"
#import "UIButton+GYExtension.h"
#import "GYHSLoginManager.h"
#import "GYAccounTradeAlertView.h"
#import "UIButton+GYTimeOut.h"

@interface GYCashBuyHSBOtherPaidStyleViewController () <UITextFieldDelegate>

    {

    GlobalData* data; //全局单例
}

@property (weak, nonatomic) IBOutlet UIScrollView* svBackView;

//提示
@property (weak, nonatomic) IBOutlet UILabel* titleRemainLabel;
//订单号
@property (weak, nonatomic) IBOutlet UILabel* orderNumberLabel;
//应付金额
@property (weak, nonatomic) IBOutlet UILabel* shouldPayMoneyLabel;
//现金吗账户余额
@property (weak, nonatomic) IBOutlet UILabel* cashAccountBalanceLabel;
//将付金额
@property (weak, nonatomic) IBOutlet UILabel* willPayMoneyLabel;
//选择其他支付方式
@property (weak, nonatomic) IBOutlet UIButton* ohterPayWayBtn;
//支付密码
@property (weak, nonatomic) IBOutlet UITextField* payPasswordTextField;
//忘记密码
@property (weak, nonatomic) IBOutlet UIButton* forgetPasswordBtn;
//确认付款
@property (weak, nonatomic) IBOutlet UIButton* confirmPayBtn;
@property (weak, nonatomic) IBOutlet UILabel* shouldPayMoneyTitleLabel; //应付金额:
@property (weak, nonatomic) IBOutlet UILabel* currencyAccountPayLabel; //货币账户支付
@property (weak, nonatomic) IBOutlet UILabel* accountBalanceTitleLabel; //余额:
@property (weak, nonatomic) IBOutlet UILabel* payMoneyTitleLabel; //支付金额
@property (weak, nonatomic) IBOutlet UILabel* tradePasswordTitleLabel; //交易密码

@end

@implementation GYCashBuyHSBOtherPaidStyleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.svBackView.backgroundColor = kDefaultVCBackgroundColor;
    data = globalData;

    self.svBackView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.confirmPayBtn.frame) + 20);

    self.titleRemainLabel.text = @"订单提交成功,请您尽快付款!";
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号:%@", self.transNo];
    self.shouldPayMoneyLabel.text = [GYUtils formatCurrencyStyle:self.inputValue];
    self.willPayMoneyLabel.text = [GYUtils formatCurrencyStyle:self.inputValue];

    self.shouldPayMoneyTitleLabel.text = kLocalized(@"GYHS_MyAccounts_exchange_HSCoin_amount");
    self.currencyAccountPayLabel.text = kLocalized(@"GYHS_MyAccounts_currencyAccountPay");
    self.accountBalanceTitleLabel.text = kLocalized(@"GYHS_MyAccounts_balances");
    self.payMoneyTitleLabel.text = kLocalized(@"GYHS_MyAccounts_pay_amount");
    [self.ohterPayWayBtn setTitle:kLocalized(@"GYHS_MyAccounts_choose_other_pay_way") forState:UIControlStateNormal];
    self.tradePasswordTitleLabel.text = kLocalized(@"GYHS_MyAccounts_trade_pwd");
    self.payPasswordTextField.placeholder = kLocalized(@"GYHS_MyAccounts_input_transaction_password");
    [self.forgetPasswordBtn setTitle:kLocalized(@"GYHS_MyAccounts_forgot_pwd") forState:UIControlStateNormal];
    [self.confirmPayBtn setTitle:kLocalized(@"GYHS_MyAccounts_ok") forState:UIControlStateNormal];

    self.payPasswordTextField.delegate = self;
    [self get_cash_act_info];

    // 暂时屏蔽掉其他支付方式。
    //    self.ohterPayWayBtn.hidden = YES;
}

#pragma mark - 网络数据交换
- (void)get_cash_act_info //现金货币余额
{

    NSDictionary* allFixParas = @{
        @"accCategory" : kTypeCashBalanceDetail,
        @"systemType" : kSystemTypeConsumer
    };
    NSMutableDictionary* allParas = [NSMutableDictionary dictionaryWithDictionary:allFixParas];

    [allParas setValue:data.loginModel.custId forKey:@"custId"];

    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kAccountBalanceDetailUrlString parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
         NSDictionary *dic = responseObject;
        data.user.cashAccBal = [dic[@"data"][@"accountBalance"] doubleValue];
        self.cashAccountBalanceLabel.text = [GYUtils formatCurrencyStyle:data.user.cashAccBal];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)get_cash_trans_hsd:(UIButton*)button //兑换互生币 - 货币支付
{

    NSDictionary* allFixParas = @{
        @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard,
        @"pwd" : [self.payPasswordTextField.text md5String]
    };
    NSMutableDictionary* allParas = [NSMutableDictionary dictionaryWithDictionary:allFixParas];

    [allParas setValue:kSaftToNSString(data.loginModel.custId) forKey:@"custId"];
    [allParas setValue:kSaftToNSString(self.transNo) forKey:@"transNo"];

    [GYGIFHUD show];
    [button controlTimeOut];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kHSExchangeHsbByHbUrlString parameters:allParas requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            NSInteger errorRetCode = [error code];
            if (errorRetCode == -9000) {
                [GYAlertView showMessage:kLocalized(@"GYHE_SC_ServiceUnavailability")
                            confirmBlock:^{
                                [self.navigationController popViewControllerAnimated:YES];
                            }];
                return;
            }
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        data.user.isNeedRefresh = YES;
        [GYAlertView showMessage:kLocalized(@"GYHS_MyAccounts_order_is_pay_success") confirmBlock:^{ [self popToOrderDetail];
        }];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

#pragma mark - 富文本交易成功提示框
- (void)showTradeMessge:(NSString*)message messageAttributedTextRange:(NSRange)messageAttributedTextRange isSuccuess:(BOOL)isSuccuess
{

    // 定制段落的样式
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    // 段落属性设置
    // 首行缩进
    style.firstLineHeadIndent = 5;
    // 行间隔
    style.lineSpacing = 7;
    NSMutableAttributedString* messageAttributedString = [[NSMutableAttributedString alloc] initWithString:message attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12], NSParagraphStyleAttributeName : style }];
    [messageAttributedString addAttribute:NSForegroundColorAttributeName value:kNavigationBarColor range:messageAttributedTextRange];

    [GYAlertView showAttributedMessage:messageAttributedString confirmBlock:^{
        [self popToOrderDetail];
    }];
}

- (IBAction)ohterPayWayBtn:(id)sender
{
    for (UIViewController* popVc in self.navigationController.viewControllers) { //如果栈中有就直接回去
        if ([popVc isKindOfClass:[GYOtherPayStyleViewController class]]) {
            [self.navigationController popToViewController:popVc animated:YES];
            return;
        }
    }

    GYOtherPayStyleViewController* vc = kLoadVcFromClassStringName(NSStringFromClass([GYOtherPayStyleViewController class]));
    vc.title = kLocalized(@"GYHS_MyAccounts_chooseOtherPaymentWay");
    vc.transNo = self.transNo;
    vc.inputValue = self.inputValue;

    vc.currentPayStyle = payStyleWithQuickPayment;
    vc.currentFunctionType = GYFunctionTypeWithBuyHSB;
    vc.tradeTitle = self.navigationItem.title;

    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)forgetPasswordBtn:(id)sender
{

    NSString* message = kLocalized(@"GYHS_MyAccounts_mobile_terminal_not_support\n_password_reset_service");
    // 定制段落的样式
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    // 段落属性设置
    // 首行缩进
    style.firstLineHeadIndent = 5;
    // 行间隔
    style.lineSpacing = 7;

    NSMutableAttributedString* messageAttributedString = [[NSMutableAttributedString alloc] initWithString:message attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12], NSParagraphStyleAttributeName : style }];

    GYAccounTradeAlertView* confirmAlertView = [[GYAccounTradeAlertView alloc] init];
    [self.view addSubview:confirmAlertView];

    [GYAlertView showAttributedMessage:messageAttributedString confirmBlock:nil];
}

- (IBAction)confirmPayBtn:(id)sender
{
    if (self.inputValue > data.user.cashAccBal) {
        [GYUtils showToast:@"账户余额不足!"];
        return;
    }

    if (self.payPasswordTextField.text.length != 8) {
        [GYAlertView showMessage:kLocalized(@"GYHS_MyAccounts_please_enter_trade_pwd")];
        return;
    }

    [self get_cash_trans_hsd:sender];
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    // modify by songjk 计算长度修改
    NSString* toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    unsigned long len = toBeString.length;
    if (textField == self.payPasswordTextField) {
        if (len > 8) {
            [self.view endEditing:YES];

            return NO;
        }
    }
    return YES;
}

- (void)popToOrderDetail
{

    //    GYBaseQueryListViewController *vcDetail = kLoadVcFromClassStringName(NSStringFromClass([GYBaseQueryListViewController class]));
    //    vcDetail.isShowBtnDetail = YES;
    //    vcDetail.detailsCode = kDetailsCode_HSDToCash;
    //    vcDetail.arrLeftParas = @[@"0", @"2", @"1"];
    //    vcDetail.arrRightParas = @[
    //                               [GYBaseQueryListViewController getDateRangeFromTodayWithDays:0],//今天
    //                               [GYBaseQueryListViewController getDateRangeFromTodayWithDays:6],//最近1周 要减1天
    //                               [GYBaseQueryListViewController getDateRangeFromTodayWithDays:29],//最近1月 要减1天
    //                               [GYBaseQueryListViewController getDateRangeFromTodayWithDays:30 * 3 - 1]//最近3月 要减1天
    //                               ];
    //    vcDetail.navigationItem.title = @"流通币明细查询栏";;
    //    if (!vcDetail) {
    //        return;
    //    }
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];

}

@end
