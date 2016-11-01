//
//  GYPayViewController.m
//
//  Created by sqm on 16/8/18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//
/**
 *  支付界面
 */
#import "GYPayViewController.h"
#import "UILabel+Category.h"
#import "GYHSPointPassInputView.h"
#import "GYHSAccountCenter.h"
#import "GYHSToolPayModel.h"
#import <YYKit/YYLabel.h>
#import <YYKit/NSAttributedString+YYText.h>
#import "GYHSStoreHttpTool.h"
#import "GYPaySuccessVC.h"
#import "GYPayView.h"
#import "GYHSPayTool.h"
#import "GYQuickPayViewController.h"

@interface GYPayViewController () <UITextFieldDelegate, GYPayViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel* paymentTitle;
@property (weak, nonatomic) IBOutlet UILabel* paymentValue;
@property (weak, nonatomic) IBOutlet UILabel* transAmounttitle;
@property (weak, nonatomic) IBOutlet UILabel* transAmountValue;
@property (weak, nonatomic) IBOutlet UIImageView *coinImageView;

@property (weak, nonatomic) IBOutlet UILabel* choosePayType;
@property (weak, nonatomic) IBOutlet UIButton* payTip;
@property (weak, nonatomic) IBOutlet UILabel* passWordTitle;
@property (weak, nonatomic) IBOutlet UITextField* passWordTf;
@property (weak, nonatomic) IBOutlet UILabel* tipLabel;
@property (weak, nonatomic) IBOutlet YYLabel* orderLabel;

@property (nonatomic, strong) UIView* payView;
@property (nonatomic, strong) UIButton* nextButton;
@property (nonatomic, strong) NSMutableArray* valueArray;
@property (nonatomic, strong) NSMutableArray* labelArray;
@property (nonatomic, strong) UILabel* payValueLable;
@property (nonatomic, strong) UILabel* balanceValueLable;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic,strong) GYPayView *paymentView;

@end

@implementation GYPayViewController

/**
 *  懒加载数据源
 *
 */
- (NSMutableArray*)labelArray
{
    if (_labelArray == nil) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

- (void)setModel:(GYHSToolPayModel*)model
{
    _model = model;
    _valueArray = [NSMutableArray arrayWithArray:@[
        //                                                   model.orderNo,
        [NSString stringWithFormat:@"%.2f", [model.hsbAmount doubleValue]],
        globalData.config.currencyName,
        [NSString stringWithFormat:@"%.4f", [globalData.config.currencyToHsbRate doubleValue]],
        [GYUtils formatCurrencyStyle:[model.hsbAmount doubleValue] / [globalData.config.currencyToHsbRate doubleValue]]
    ]];
    for (int i = 0; i < self.labelArray.count; i++) {
        UILabel* label = self.labelArray[i];
        label.text = _valueArray[i];
    }
    self.payValueLable.text = [NSString stringWithFormat:@"%.2f", [model.hsbAmount doubleValue]];
    self.balanceValueLable.text = [GYHSAccountCenter defaultCenter].ltbBalance;
}

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDLogInfo(@"Show Controller: %@", [self class]);
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
}

// #pragma mark - SystemDelegate
// #pragma mark TableView Delegate
// #pragma mark - CustomDelegate
// #pragma mark - event response
//#pragma mark - request

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHSPay_ChooseThePaymentMethod");
    self.view.backgroundColor = kWhiteFFFFFF;
    DDLogInfo(@"Load Controller: %@", [self class]);
    [self createRetailView];
    [self createBottomView];
}
/**
 *  创建头部视图
 */
- (void)createRetailView
{

    if (self.type == GYPaymentServiceTypeExchangeHSCurrency) {
        _paymentTitle.text = @"货币账户支付";
        _coinImageView.image = [UIImage imageNamed:@"gyhs_coinToBank_small_icon"];
    }else{
        _paymentTitle.text = @"互生币支付";
        _coinImageView.image = [UIImage imageNamed:@"gypay_hsb"];
    }
    {
        NSMutableAttributedString* tipMsg = [[NSMutableAttributedString alloc] init];
    
        UIImage *image1 = [UIImage imageNamed:@"gypay_tick"];
        NSMutableAttributedString* attachText1 = [NSMutableAttributedString attachmentStringWithContent:image1 contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(kDeviceProportion(39), kDeviceProportion(39)) alignToFont:kFont28 alignment:YYTextVerticalAlignmentCenter];
        [tipMsg appendAttributedString:attachText1];

        [tipMsg appendAttributedString:[[NSAttributedString alloc] initWithString:kLocalized(@"GYHSPay_SuccessfulOrderSubmission,OrderNumber") attributes:@{ NSFontAttributeName : kFont36, NSForegroundColorAttributeName : kGray333333 }]];

        [tipMsg appendAttributedString:[[NSAttributedString alloc] initWithString:self.model.orderNo attributes:@{ NSFontAttributeName : kFont28, NSForegroundColorAttributeName : kRedE50012 }]];

        [tipMsg appendAttributedString:[[NSAttributedString alloc] initWithString:kLocalized(@"GYHSPay_PaymentAmount") attributes:@{ NSFontAttributeName : kFont36, NSForegroundColorAttributeName : kGray333333 }]];

        UIImage* image2 = [UIImage imageNamed:@"gypay_hsb"];
        NSMutableAttributedString* attachText2 = [NSMutableAttributedString attachmentStringWithContent:image2 contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(kDeviceProportion(23), kDeviceProportion(23)) alignToFont:kFont28 alignment:YYTextVerticalAlignmentCenter];
        [tipMsg appendAttributedString:attachText2];
        if (self.type == GYPaymentServiceTypeExchangeHSCurrency) {
            [tipMsg appendAttributedString:[[NSAttributedString alloc] initWithString:[GYUtils formatCurrencyStyle:self.model.cashAmount.doubleValue] attributes:@{ NSFontAttributeName : kFont28, NSForegroundColorAttributeName : kRedE50012 }]];
        }else{
            [tipMsg appendAttributedString:[[NSAttributedString alloc] initWithString:[GYUtils formatCurrencyStyle:self.model.hsbAmount.doubleValue] attributes:@{ NSFontAttributeName : kFont28, NSForegroundColorAttributeName : kRedE50012 }]];
        }
        _orderLabel.attributedText = tipMsg;
    }

    _orderLabel.customBorderType = UIViewCustomBorderTypeBottom;

    if (self.type == GYPaymentServiceTypeExchangeHSCurrency) {
        [[GYHSAccountCenter defaultCenter] updateCashAccount:^(id returnValue) {
            NSMutableAttributedString* tipMsg1 = [[NSMutableAttributedString alloc] init];
            
            [tipMsg1 appendAttributedString:[[NSAttributedString alloc] initWithString:kLocalized(@"GYHSPay_Balance") attributes:@{ NSFontAttributeName : kFont36, NSForegroundColorAttributeName : kGray333333 }]];
            
            [tipMsg1 appendAttributedString:[[NSAttributedString alloc] initWithString:[GYUtils formatCurrencyStyle:[GYHSAccountCenter defaultCenter].cashBanlance.doubleValue] attributes:@{ NSForegroundColorAttributeName : kRedE40011 }]];
            
            _paymentValue.attributedText = tipMsg1;
            
            [_payTip setTitle:kLocalized(@"GYHSPay_YourCurrencyAccountBalanceIsInsufficient,PleaseCchooseAnotherPaymentMethod") forState:UIControlStateNormal];
            [_payTip setTitleColor:kGray666666 forState:UIControlStateNormal];
            if (self.model.cashAmount.doubleValue >[GYHSAccountCenter defaultCenter].cashBanlance.doubleValue ) {
                _payTip.hidden = NO;
            }else {
                _payTip.hidden = YES;
            }

        } failure:^(NSError *error) {
            
        }];
    }else{
        [[GYHSAccountCenter defaultCenter] updateHsbAccount:^(id returnValue) {
            NSMutableAttributedString* tipMsg1 = [[NSMutableAttributedString alloc] init];
            
            [tipMsg1 appendAttributedString:[[NSAttributedString alloc] initWithString:kLocalized(@"GYHSPay_Balance") attributes:@{ NSFontAttributeName : kFont36, NSForegroundColorAttributeName : kGray333333 }]];
            
            [tipMsg1 appendAttributedString:[[NSAttributedString alloc] initWithString:[GYUtils formatCurrencyStyle:[GYHSAccountCenter defaultCenter].ltbBalance.doubleValue] attributes:@{ NSForegroundColorAttributeName : kRedE40011 }]];
            
            _paymentValue.attributedText = tipMsg1;
            
            [_payTip setTitle:kLocalized(@"GYHSPay_YourHSCurrencyAccountBalanceIsInsufficient,PleaseCchooseAnotherPaymentMethod") forState:UIControlStateNormal];
            [_payTip setTitleColor:kGray666666 forState:UIControlStateNormal];
            if (self.model.hsbAmount.doubleValue >[GYHSAccountCenter defaultCenter].ltbBalance.doubleValue ) {
                _payTip.hidden = NO;
            }else {
                _payTip.hidden = YES;
            }
        } failure:^(NSError* error){
            
        }];

    
    }
    
    _transAmounttitle.text = kLocalized(@"GYHSPay_PaymentMoney");
    _transAmounttitle.font = kFont42;
    _transAmounttitle.textColor = kGray333333;
    
    _transAmountValue.textColor = kRedE50012;
    if (self.type == GYPaymentServiceTypeExchangeHSCurrency) {
        _transAmountValue.text = [GYUtils formatCurrencyStyle:self.model.cashAmount.doubleValue];
    }else{
        _transAmountValue.text = [GYUtils formatCurrencyStyle:self.model.hsbAmount.doubleValue];
    }

    {
        NSMutableAttributedString* one = [[NSMutableAttributedString alloc] initWithString:kLocalized(@"GYHSPay_ChooseOtherPaymentMethod")];
        one.font = kFont42;
        one.color = kBlue0A59C2;

        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTipView)];
        _choosePayType.attributedText = one;
        [_choosePayType addGestureRecognizer:tap];
        _choosePayType.userInteractionEnabled = YES;
    }

    _passWordTitle.text = kLocalized(@"GYHSPay_TransactionPassword");
    _passWordTitle.textColor = kGray333333;
    _passWordTitle.font = kFont42;
    
    _passWordTf.placeholder = kLocalized(@"GYHSPay_InputTradePwd");
    _passWordTf.secureTextEntry = YES;
    _passWordTf.delegate = self;
    _passWordTf.keyboardType = UIKeyboardTypeNumberPad;
    _passWordTf.layer.borderColor = kGrayCCCCCC.CGColor;
    _passWordTf.layer.borderWidth = 1;

    _tipLabel.text = kLocalized(@"GYHSPay_Tips: 1 HSCurrency = 1 Yuan");
    _tipLabel.font = kFont28;
    _tipLabel.textColor = kGray666666;
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

}
- (void)choose
{
}
/**
 *  创建底部按钮视图
 */
- (void)createBottomView{
    
    UIView* bottomBackView = [[UIView alloc] init];
    bottomBackView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.16];
    [self.view addSubview:bottomBackView];
    [bottomBackView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(kDeviceProportion(70)));
    }];
    
    UIButton* nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.layer.cornerRadius = 5;
    nextButton.layer.borderWidth = 1;
    nextButton.layer.borderColor = kWhiteFFFFFF.CGColor;
    nextButton.layer.masksToBounds = YES;
    nextButton.enabled = NO;
    [nextButton setTitle:kLocalized(@"GYHSPay_confirmPay") forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setBackgroundColor:kGray333333];
    [nextButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackView addSubview:nextButton];
    self.nextButton = nextButton;
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@(kDeviceProportion(33)));
        make.width.equalTo(@(kDeviceProportion(120)));
        make.centerX.centerY.equalTo(bottomBackView);
    }];
    
    
}

- (void)btnAction:(UIButton *)sender{
    if(self.type == GYPaymentServiceTypeExchangeHSCurrency){
        [self requestExchangeHSB];
    }else if(self.type == GYPaymentServiceTypePayAnnualFee){
        [self requestPayYearFeeByHSB];
    }else{
        [self requestHSBPayment];
    }
}
/**
 *  创建选择支付方式的弹出视图
 */
- (void)showTipView
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [button addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.button = button;
    
    _paymentView = [[[NSBundle mainBundle]loadNibNamed:@"GYPayView" owner:self options:nil]firstObject];
    _paymentView.delegate = self;
    _paymentView.frame = CGRectMake(CGRectGetMaxX(_choosePayType.frame) + 10, CGRectGetMaxY(_paymentValue.frame) + 10, 300, 300);
    _paymentView.accountStr = _model.cashAmount;
    [self.button addSubview:_paymentView];

}

- (void)remove{

    [self.button removeFromSuperview];

}

#pragma mark-- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            if (toBeString.length > 8) {
            [textField resignFirstResponder];
//            [GYUtils showToast:kLocalized(@"GYHS_HSStore_PurchaseTools_PostCodeCannotMoreThanSixDigit")];
        }else{
            return YES;
        }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField*)textField
{
    [self.nextButton setBackgroundColor:kRedE50012];
    self.nextButton.enabled = YES;
}
/**
 *  互生币支付的网络接口
 */
- (void)requestHSBPayment{
        [GYHSStoreHttpTool HSBpayToolOrderOrderNo:_model.orderNo payChannel:[NSNumber numberWithInteger:[GYPayChannelHSBPay integerValue]] tradePwd:_passWordTf.text success:^(id responsObject) {
    
            if (kHTTPSuccessResponse(responsObject)) {
                [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"GYHS_HSStore_PerCardCustomization_OrderProcessedSuccessful") topColor:1 comfirmBlock:^{
                    GYPaySuccessVC *paySuccessVC = [[GYPaySuccessVC alloc] init];
                    if (self.isQueryDetailVC == YES) {
                        paySuccessVC.isQueryDetailVC = YES;
                    }
                    switch (self.type) {
                        case GYPaymentServiceTypeToolPurchase:{
                            paySuccessVC.type = GYPaymentTypeToolPurchase;
                        }
                        break;
                        case GYPaymentServiceTypeResourcePurchase:{
                            paySuccessVC.type = GYPaymentTypeResourcePurchase;
                        }
                        case GYPaymentServiceTypePersonalCard:{
                            paySuccessVC.type = GYPaymentTypePersonalCard;
                        }
                            break;
                        case GYPaymentServiceTypePayAnnualFee:{
                            paySuccessVC.type = GYPaymentTypePayAnnualFee;
                        }
                        default:
                            break;
                    }
                    paySuccessVC.payStr = _model.hsbAmount;
                    [self.navigationController pushViewController:paySuccessVC animated:YES];
                   }];
            }else{
                [GYUtils showToast:kLocalized(@"GYHSPay_HSCurrencyPaymentFailure")];
            }
    
        } failure:^{
            
        }];
}
/**
 *  互生币缴纳年费
 */
- (void)requestPayYearFeeByHSB{
    [GYHSPayTool payAnnualFeeOrderOrderNo:_model.orderNo payChannel:GYPayChannelHSBPay bindingNo:@"" smsCode:@"" tradePwd:self.passWordTf.text success:^(id responsObject) {
        if (kHTTPSuccessResponse(responsObject)) {
            [GYUtils showToast:kLocalized(@"GYHSPay_OrderPaymentProcessingSuccess")];
            GYPaySuccessVC *paySuccessVC = [[GYPaySuccessVC alloc] init];
            if (self.isQueryDetailVC == YES) {
                paySuccessVC.isQueryDetailVC = YES;
            }else{
                paySuccessVC.type = GYPaymentTypePayAnnualFee;
            }
            paySuccessVC.payStr = _model.hsbAmount;
            [self.navigationController pushViewController:paySuccessVC animated:YES];
        }else{
        }

    } failure:^{
        
    }];

}
#pragma mark-易联支付
/**
 *  易联支付的网络接口
 */
- (void)resquestYLPayment{
        NSString *operateCode = @"";
        switch (self.type) {
            case GYPaymentServiceTypeToolPurchase:
            {
                operateCode = GYYLPayPurchaseTool;
            }
                break;
            case GYPaymentServiceTypePersonalCard:
            {
                operateCode = GYYLPayPersonalityCard;
            }
                break;
            case GYPaymentServiceTypeResourcePurchase:
            {
                operateCode = GYYLPayPurchaseHSCard;
            }
                break;
            case GYPaymentServiceTypePayAnnualFee:
            {
                operateCode = GYYLPayAnnualFee;
            }
                break;
            case GYPaymentServiceTypeExchangeHSCurrency:
            {
                operateCode = GYYLPayExchangeHSB;
            }
                break;
            default:
                break;
        }
    
        
        [GYHSPayTool payOperateForYiPaymentWithOperateCode:operateCode orderNo:_model.orderNo transAmount:_model.hsbAmount success:^(id responsObject) {
            [GYHSPayTool ylPayWithOrderParameter:responsObject success:^(id responsObject) {
                
                [GYUtils showToast:kLocalized(@"GYHSPay_PaymentSuccessful")];
                
                GYPaySuccessVC *paySuccessVC = [[GYPaySuccessVC alloc] init];
                if (self.isQueryDetailVC == YES) {
                    paySuccessVC.isQueryDetailVC = YES;
                }else{
                    if (self.type == GYPaymentServiceTypeToolPurchase) {
                        paySuccessVC.type = GYPaymentTypeToolPurchase;
                    }else if (self.type == GYPaymentServiceTypeResourcePurchase){
                        paySuccessVC.type = GYPaymentTypeResourcePurchase;
                    }else if (self.type == GYPaymentServiceTypePersonalCard){
                        paySuccessVC.type = GYPaymentTypePersonalCard;
                    }else if (self.type == GYPaymentServiceTypePayAnnualFee){
                        paySuccessVC.type = GYPaymentTypePayAnnualFee;
                    }else if (self.type == GYPaymentServiceTypeExchangeHSCurrency){
                        paySuccessVC.type = GYPaymentTypeExchangeHSCurrency;
                    }
                
                }
                paySuccessVC.payStr = _model.hsbAmount;
                [self.navigationController pushViewController:paySuccessVC animated:YES];
            } failure:^{
                
                [GYUtils showToast:kLocalized(@"GYHSPay_PaymentFailure")];
            } cancel:^{
                [GYUtils showToast:kLocalized(@"GYHSPay_UnPay")];
            }];
            
        } failure:^{
            
        }];
    
}
/**
 *  兑换互生币
 */
- (void)requestExchangeHSB{
    [GYHSPayTool paymentBycurrencyWithTransNo:_model.orderNo password:self.passWordTf.text success:^(id responsObject) {
        if (kHTTPSuccessResponse(responsObject)) {
            [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"GYHS_HSStore_PerCardCustomization_OrderProcessedSuccessful") topColor:1 comfirmBlock:^{
                 GYPaySuccessVC *paySuccessVC = [[GYPaySuccessVC alloc] init];
                paySuccessVC.type = GYPaymentTypeExchangeHSCurrency;
                paySuccessVC.payStr = _model.cashAmount;
                [self.navigationController pushViewController:paySuccessVC animated:YES];
            }];
        }else{
        }

    } failure:^{
        
    }];

}

#pragma mark -- GYPayViewDelegate
- (void)ylPaymentAction{

    [self resquestYLPayment];
   
}
/**
 *  进去快捷支付的事件
 */
- (void)quickPaymentAction{
    GYQuickPayViewController *quickPayViewController = [[GYQuickPayViewController alloc] init];
    quickPayViewController.model = _model;

    if (self.isQueryDetailVC == YES) {
        quickPayViewController.isQueryDetailVC = YES;
    }
    switch (self.type) {
        case GYPaymentServiceTypeToolPurchase:
        {
            quickPayViewController.type = QuickPaymentTypeTool;
        }
        break;
        case GYPaymentServiceTypeResourcePurchase:
        {
            quickPayViewController.type = QuickPaymentTypeHSCardPurchase;
        }
            break;
        case GYPaymentServiceTypePersonalCard:
        {
            quickPayViewController.type = QuickPaymentTypePersonCardOrder;
        }
            break;
        case GYPaymentServiceTypePayAnnualFee:
        {
            quickPayViewController.type = QuickPaymentTypeFee;
        }
            break;
        case GYPaymentServiceTypeExchangeHSCurrency:
        {
            quickPayViewController.type = QuickPaymentTypeBehalf;
        }
            break;
        default:
        break;
    }
    
    [self.navigationController pushViewController:quickPayViewController animated:YES ];
}

@end
