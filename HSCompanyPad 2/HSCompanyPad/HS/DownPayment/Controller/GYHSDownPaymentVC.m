//
//  GYHSDownPaymentVC.m
//
//  Created by apple on 16/8/2.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSDownPaymentVC.h"
#import "GYHSCodeReaderViewController.h"
#import "GYHSPayKeyView.h"
#import "GYHSPointHttpTool.h"
#import "GYHSPointInputView.h"
#import "GYHSPointPassInputView.h"
#import "GYPointTool.h"
#import "UITextField+GYHSPointTextField.h"
#import "GYTextField.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <YYKit/YYTextKeyboardManager.h>
#import "GYPOSService.h"
#import "GYPOSService.h"
#import "GYCardReaderModel.h"
#import <YYKit/UIGestureRecognizer+YYAdd.h>
#import "GYPOSService.h"
#import "GYCardReaderModel.h"
#import <GYKit/UIButton+GYExtension.h>
#define kLetfwidth kDeviceProportion(20)
#define kInputViewWidth kDeviceProportion(429)
#define kCommonHeight kDeviceProportion(45)
#define KLineHeight kDeviceProportion(3)
@interface GYHSDownPaymentVC () <GYHSPayKeyDelegate, UITextFieldDelegate, GYHSPointInputDelegate, GYHSCodeReaderDelegate>
@property (nonatomic, weak) GYHSPointInputView* cardView;
@property (nonatomic, weak) GYHSPointInputView* consumeView;
@property (nonatomic, weak) GYHSPointInputView* HSBView;
@property (nonatomic, weak) GYHSPayKeyView* keyView;
@property (nonatomic, weak) GYHSPointPassInputView* passwordView;
@property (nonatomic, strong) GYPOSBatchModel* batchModel; // 批次号和终端流水号
@property (nonatomic, strong) GYPointTool* pointTool; /**积分获取工具*/
@property (nonatomic, strong) GYCardReaderModel * posInfo;
@property (nonatomic, strong) GYPOSService* POSService;
@property (nonatomic, strong) GYCardInfoModel * cardModel; // 互生号和暗码
@property (nonatomic, strong) UITextField* selectField;
@property (nonatomic, copy) NSString* consumeString; //预付金额
@end

@implementation GYHSDownPaymentVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIWindowDidBecomeVisibleNotification object:nil];
    [kDefaultNotificationCenter addObserver:self selector:@selector(getHsCardNumber:) name:GYCardNumAndCipherNotification object:nil];
    [kDefaultNotificationCenter addObserver:self selector:@selector(submit:) name:GYPOSShounldInputTradingPasswordNotification object:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.passwordView.passField.userInteractionEnabled = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
    [kDefaultNotificationCenter removeObserver:self];
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHS_Down_Hsb_Down");
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    //互生卡行
    GYHSPointInputView* cardView = [[GYHSPointInputView alloc] initWithFrame:CGRectMake(kLetfwidth, kLetfwidth + kNavigationHeight, kInputViewWidth, kCommonHeight) imageName:@"gyhs_payment_card" placeholder:kLocalized(@"GYHS_Down_Swipe_Input_Number")];
    cardView.textfield.delegate = self;
    cardView.isShowRightView = YES;
    cardView.delegate = self;
    [cardView.textfield becomeFirstResponder];
    [self.view addSubview:cardView];
    self.cardView = cardView;
    
    GYHSPointInputView* consumeView = [[GYHSPointInputView alloc] initWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(self.cardView.frame) + KLineHeight, kInputViewWidth, kCommonHeight) imageName:@"gyhs_payment_amount" placeholder:kLocalized(@"GYHS_Down_Input_Payment_Cash")];
    consumeView.textfield.delegate = self;
    [self.view addSubview:consumeView];
    self.consumeView = consumeView;
    
    GYHSPointInputView* HSBView = [[GYHSPointInputView alloc] initWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(self.consumeView.frame) + KLineHeight, kInputViewWidth, kCommonHeight) imageName:@"gyhs_HSBCoin_min" placeholder:kLocalized(@"GYHS_Down_Real_Cash")];
    HSBView.userInteractionEnabled = NO;
    HSBView.textfield.text = @"0.00";
    [self.view addSubview:HSBView];
    self.HSBView = HSBView;
    
    GYHSPayKeyView* keyView = [[GYHSPayKeyView alloc] init];
    keyView.delegate = self;
    [self.view addSubview:keyView];
    self.keyView = keyView;
    [self.keyView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavigationHeight);
        make.left.equalTo(self.view).offset(CGRectGetMaxX(self.consumeView.frame) + kLetfwidth);
    }];
    
    //输入密码行
    GYHSPointPassInputView* passwordView = [[GYHSPointPassInputView alloc] initWithFrame:CGRectMake(kLetfwidth, self.view.height - kLetfwidth - kCommonHeight - kMainHeadHeight, kInputViewWidth, kCommonHeight) type:kPasswordTrade];
    passwordView.passField.delegate = self;
    passwordView.hidden = YES;
    [self.view addSubview:passwordView];
    self.passwordView = passwordView;
    
    @weakify(self);
    self.passwordView.passField.userInteractionEnabled = NO;
    UIGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id _Nonnull sender) {
        @strongify(self);
        if (![self.POSService.posInfo isConnected]) {
            self.passwordView.passField.userInteractionEnabled = YES;
            [self.passwordView.passField becomeFirstResponder];
            
        } else {
            @strongify(self);
            if (![self isDataAllright]) {
                return ;
            }
            [self.selectField resignFirstResponder];
            [self selectView:self.passwordView];
            [self.POSService confirkHSpay:self.consumeString];
        }
        
    }];
    [self.passwordView addGestureRecognizer:tap];

}

#pragma mark - GYHSPayKeyDelegate
- (void)keyPayAddWithString:(NSString*)string
{
    if (self.selectField == nil) {
        [GYUtils showToast:kLocalized(@"GYHS_Down_Select_Edit_Field")];
        return;
    }
    self.selectField.text = [NSString stringWithFormat:@"%@%@", self.selectField.text, string];
    [self dealWithField];
}

- (void)keyPayDeleteWithString
{
    if (self.selectField == nil) {
        [GYUtils showToast:kLocalized(@"GYHS_Down_Select_Edit_Field")];
        return;
    }
    if (self.selectField.text.length > 0) {
        self.selectField.text = [self.selectField.text substringToIndex:self.selectField.text.length - 1];
        [self dealWithField];
    }
}

- (void)dealWithField
{
    if (self.selectField == self.cardView.textfield) {
        self.selectField.text = [self.selectField inputCardField];
    }
    if (self.selectField == self.consumeView.textfield) {
        if (!self.selectField.text.length) {
            self.HSBView.textfield.text = @"0.00";
            self.consumeString = @"";
            return;
        }
        self.selectField.text = [self.selectField inputEditField];
        NSString* consumeStr = [self.selectField deleteFormString];
        self.consumeString = [NSString stringWithFormat:@"%.2f",consumeStr.doubleValue];
        NSDecimalNumber* consumeDeciaml = [NSDecimalNumber decimalNumberWithString:consumeStr];
        NSDecimalNumber* HSBRateDeicmal = [NSDecimalNumber decimalNumberWithString:globalData.config.currencyToHsbRate];
        self.HSBView.textfield.text = [consumeDeciaml decimalNumberByMultiplyingBy:HSBRateDeicmal].stringValue;
        self.HSBView.textfield.text = [UITextField keepTwoDeciaml:self.HSBView.textfield.text];
    }
    if (self.selectField == self.passwordView.passField) {
        self.selectField.text = [self.selectField subPassField];
    }
}

- (void)keyClick:(NSInteger)index
{
    if (index == 0) {
        //清除
        self.cardView.textfield.text = @"";
        self.consumeView.textfield.text = @"";
        self.consumeString = @"";
        self.HSBView.textfield.text = @"0.00";
        self.passwordView.hidden = YES;
        self.passwordView.passField.text = @"";
        [self.cardView.textfield becomeFirstResponder];
    }
    else {
        //预付定金请求
        if ([self isDataAllright]) {
            if (self.passwordView.hidden) {
                self.passwordView.hidden = NO;
                return;
            }
            if (self.passwordView.passField.text.length != 8) {
                [self.passwordView.passField tipWithContent:kLocalized(@"GYHS_Down_Consume_Input_Trade_Passwd") animated:YES];
                [self.passwordView.passField becomeFirstResponder];
                return;
            }
            @weakify(self);
            [GYAlertView alertWithTitle:kLocalized(@"GYHS_Down_Tip")
                                Message:kLocalized(@"GYHS_Down_Sure_HSB_Down")
                               topColor:TopColorBlue
                           comfirmBlock:^{
                               @strongify(self);
                               [self request];
                               [self.keyView.sureBtn controlTimeOut];
                           }];
        }
    }
}

#pragma mark - GYHSPointInputDelegate
- (void)clickRightAction:(NSInteger)index
{
    [self.cardView.textfield becomeFirstResponder];
    if (index == 1) {
        //刷卡
         [[GYPOSService sharedInstance] swipingCard];
        self.passwordView.passField.userInteractionEnabled = NO;
    }
    else {
        //扫一扫
        GYHSCodeReaderViewController* codeReaderVC = [[GYHSCodeReaderViewController alloc] init];
        codeReaderVC.modalPresentationStyle = UIModalPresentationFormSheet;
        codeReaderVC.title = kLocalized(@"GYHS_Down_Scan_To");
        codeReaderVC.delegate = self;
        [self.navigationController pushViewController:codeReaderVC animated:YES];
    }
}

#pragma mark - GYHSCodeReaderDelegate
- (void)reader:(GYHSCodeReaderViewController*)reader didScanResult:(NSString*)result
{
    if (result.length >= 14 && [result hasPrefix:@"ID&"] && [GYUtils isHSCardNo:[result substringWithRange:NSMakeRange(3, 11)]]) {
        NSString* cardNumber = [result substringWithRange:NSMakeRange(3, 11)];
        self.cardView.textfield.text = [GYUtils formatCardNo:cardNumber];
        [reader.navigationController popViewControllerAnimated:YES];
    }
    else {
        [reader startScanning];
    }
//    if ([GYUtils isConsumptionCode:result]) {
//        self.cardView.textfield.text = [GYUtils formatCardNo:[GYUtils consumptionCode:result]];
//        [reader.navigationController popViewControllerAnimated:YES];
// 
//    }else {
//        [reader startScanning];
//    }
}

#pragma mark - 数据是否正确
- (BOOL)isDataAllright
{
    if (self.selectField == nil) {
        [GYUtils showToast:kLocalized(@"GYHS_Down_Select_Edit_Field")];
        return NO;
    }
    
    NSString* cardStr = [self.cardView.textfield deleteSpaceField];
    if (![GYUtils isHSCardNo:cardStr]) {
        [self.cardView.textfield tipWithContent:kLocalized(@"GYHS_Down_Input_Number_Error_Tip") animated:YES];
        [self.cardView.textfield becomeFirstResponder];
        return NO;
    }
    if (self.consumeString.length == 0) {
        [self.consumeView.textfield tipWithContent:kLocalized(@"GYHS_Down_Input_Cash") animated:YES];
        [self.consumeView.textfield becomeFirstResponder];
        return NO;
    }
    if ([self.consumeString doubleValue] <= 0.0f) {
        [self.consumeView.textfield tipWithContent:kLocalized(@"GYHS_Down_Input_More_Cash") animated:YES];
        [self.consumeView.textfield becomeFirstResponder];
        return NO;
    }
    return YES;
}

#pragma 预付定金请求
- (void)request
{
    NSString* equipmentNo;
    NSString* equipmentType;
    if (self.cardModel.CipherNum.length) {
        equipmentNo = self.posInfo.posId;
        equipmentType = GYPOSDeviceCardReader;
    }else{
        NSUUID* deviceUDID = [[UIDevice currentDevice] identifierForVendor];
        NSString* strUDID = [deviceUDID UUIDString];
        strUDID = [strUDID substringToIndex:18];
        equipmentNo = strUDID;
        equipmentType = GYPOSDeviceMoblie;
    }
    @weakify(self);
    [GYHSPointHttpTool getSourceTransNoWithsuccess:^(id responsObject) {
        @strongify(self);
        NSString* sourceTransNo = responsObject;
        //互生卡号
        NSString* cardStr = [self.cardView.textfield deleteSpaceField];
        [GYHSPointHttpTool prePointWithSourceTransNo:sourceTransNo
                                           transType:@"21700"
                                   sourceTransAmount:self.consumeString
                                         transAmount:self.consumeString
                                            perResNo:cardStr
                                         channelType:@"5"
                                         equipmentNo:equipmentNo
                                       equipmentType:equipmentType
                                       sourceBatchNo:self.batchModel.batchNo
                                         termRunCode:self.batchModel.posRunCode
                                          secretCode:@""
                                            transPwd:self.passwordView.passField.text
                                             success:^(id responsObject) {
                                                 if (kHTTPSuccessResponse(responsObject)) {
                                                     [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"GYHS_Down_Hsb_Down_Success")
                                                                                       topColor:TopColorBlue
                                                                                   comfirmBlock:^{
                                                                [self dealSuccess];
                                                                                   }];
                                                 } else {
                                                     [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"GYHS_Down_Hsb_Down_Fail")
                                                                                       topColor:TopColorRed
                                                                                   comfirmBlock:^{
                                                                                       [GYHSPointHttpTool correctWithTransType:@"21710"
                                                                                                                       transNo:sourceTransNo
                                                                                                                  returnReason:kLocalized(kLocalized(@"GYHS_Down_Payment_Correct"))
                                                                                                                equitpmentType:equipmentType
                                                                                                                      initiate:@"MOBILE"
                                                                                                                   termRunCode:self.batchModel.posRunCode
                                                                                                                      perResNo:cardStr
                                                                                                                   equipmentNo:equipmentNo
                                                                                                                    secretCode:@""
                                                                                                                 sourceBatchNo:self.batchModel.batchNo
                                                                                                                       success:^(id responsObject) {
                                                                                                                       
                                                                                                                       }
                                                                                                                       failure:^{
                                                                                                                       
                                                                                                                       }];
                                                                                   }];
                                                 }
                                             }
                                             failure:^{
                                                 self.passwordView.passField.text = nil;
                                             }];
    }
        failure:^{
        
        }];
}

- (void)dealSuccess
{
    self.cardView.textfield.text = @"";
    self.consumeView.textfield.text = @"";
    self.consumeString = @"";
    self.HSBView.textfield.text = @"0.00";
    self.passwordView.hidden = YES;
    self.passwordView.passField.text = @"";
    [self.cardView.textfield becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField*)textField
{
    if (textField == self.consumeView.textfield) {
        self.consumeView.textfield.text = @"";
        self.HSBView.textfield.text = @"0.00";
        self.consumeString = @"";
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    [self deleteView:self.passwordView];
    [self selectView:(UIView*)[textField superview]];
    self.selectField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self deleteView:(UIView*)[textField superview]];
    
}

#pragma mark -编辑框处理
- (void)selectView:(UIView*)selectView
{
    selectView.layer.borderWidth = 1;
    selectView.layer.borderColor = [[UIColor redColor] CGColor];
}

- (void)deleteView:(UIView*)deleteView
{
    deleteView.layer.borderWidth = 0;
    deleteView.layer.borderColor = [[UIColor clearColor] CGColor];
}

#pragma mark - 键盘显示通知
- (void)keyboardWillShow:(NSNotification*)Notification

{
    [YYTextKeyboardManager defaultManager].keyboardWindow.alpha = 0;
}

#pragma mark - 处理刷卡器相关
- (void)getHsCardNumber:(NSNotification*)notice
{
    NSString* cardNumAndCipher = [notice object];
    if (cardNumAndCipher && cardNumAndCipher.length > 0) {
        NSArray* arrCardAndCipher = [cardNumAndCipher componentsSeparatedByString:@","];
        if (arrCardAndCipher.count == 2 ) { //当刷卡信息置空的时候赋值
            self.cardView.textfield.text = [GYUtils formatCardNo:arrCardAndCipher.firstObject];
            self.cardModel.HSCardNum = arrCardAndCipher[0];
            self.cardModel.CipherNum = arrCardAndCipher[1];
        }
    }
    
    
}

#pragma mark - 获取交易密码
- (void)submit:(NSNotification*)notice
{
    if ([[notice name] isEqualToString:GYPOSShounldInputTradingPasswordNotification]) {
        self.passwordView.passField.text = [notice object];
        [self request];
    }
}
#pragma mark - lazy load
- (GYPointTool*)pointTool
{
    if (_pointTool == nil) {
        _pointTool = [GYPointTool shareInstance];
    }
    return _pointTool;
}

- (GYPOSBatchModel*)batchModel
{
    if (_batchModel == nil) {
        _batchModel = [GYPOSBatchModel shareInstance];
    }
    return _batchModel;
}

- (GYCardInfoModel *)cardModel
{
    if (_cardModel == nil) {
        _cardModel = [[GYCardInfoModel alloc]init];
    }
    return _cardModel;
}

- (GYCardReaderModel*)posInfo
{
    _posInfo = self.POSService.posInfo;
    return _posInfo;
}

- (GYPOSService*)POSService
{
    if (_POSService == nil) {
        _POSService = [GYPOSService sharedInstance];
    }
    return _POSService;
}


@end
