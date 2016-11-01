//
//  GYHSConsumePointVC.m
//
//  Created by apple on 16/7/27.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSConsumePointVC.h"
#import "GYHSCodeReaderViewController.h"
#import "GYHSConsumerView.h"
#import "GYHSKeyView.h"
#import "GYHSPointCheckVC.h"
#import "GYHSPointHttpTool.h"
#import "GYHSPointInputView.h"
#import "GYHSPointPassInputView.h"
#import "GYHSPointScanView.h"
#import "GYHSPublicMethod.h"
#import "GYPadKeyboradView.h"
#import "GYPointTool.h"
#import "GYPOSService.h"
#import "GYCardReaderModel.h"
#import "GYSettingPointRateSetViewController.h"
#import <GYKit/NSString+NSDecimalNumber.h>
#import "UITextField+GYHSPointTextField.h"
#import <GYKit/UIView+Extension.h>
#import "GYTextField.h"
#import <YYKit/UIGestureRecognizer+YYAdd.h>
#import <BlocksKit/BlocksKit+UIKit.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <YYKit/YYTextKeyboardManager.h>
#import <GYKit/UIButton+GYExtension.h>
#define kLetfwidth kDeviceProportion(20)
#define kInputViewWidth kDeviceProportion(429)
#define kDistanceHeight kDeviceProportion(24)
#define kCommonHeight kDeviceProportion(45)
#define kScanHeight kDeviceProportion(210)
#define kConsumeWidth (kLetfwidth + kInputViewWidth)
#define kHSBNavColor [UIColor colorWithHexString:@"#f2b80a"]
#define kScanNavColor [UIColor colorWithHexString:@"#87b500"]
@interface GYHSConsumePointVC () <GYHSKeyViewDelegate, UITextFieldDelegate, GYHSCheckScanDelegate, GYHSPointInputDelegate, GYHSCodeReaderDelegate, GYHSConsumerDelegate>
@property (nonatomic, weak) GYHSConsumerView* consumePointView;
@property (nonatomic, weak) GYHSPointInputView* inputCardView;
@property (nonatomic, weak) GYHSKeyView* keyView;
@property (nonatomic, strong) UITextField* selectField;
@property (nonatomic, weak) GYHSPointPassInputView* passwordView;
@property (nonatomic, weak) GYHSPointScanView* scanView;
@property (nonatomic, strong) GYPOSBatchModel* batchModel; // 批次号和终端流水号
@property (nonatomic, strong) GYPointTool* pointTool; /**积分获取工具*/
@property (nonatomic, strong) GYCardReaderModel * posInfo;
@property (nonatomic, strong) GYPOSService* POSService;
@property (nonatomic, strong) GYCardInfoModel * cardModel; // 互生号和暗码
@property (nonatomic, copy) NSString* consumeString; //消费金额
@property (nonatomic, strong) NSMutableArray* scanArray;
@property (nonatomic, copy) NSString* equipmentStr; //设备号
@property (nonatomic, copy) NSString* dateStr; //二维码生成时间
@property (nonatomic, copy) NSString* transNo; //交易流水号
@end

@implementation GYHSConsumePointVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kLocalized(@"GYHS_Point_Consume");
    @weakify(self);
    [self loadInitViewType:GYStopTypeAll :^{
        @strongify(self);
        [self initView];
        [kDefaultNotificationCenter addObserver:self selector:@selector(getHsCardNumber:) name:GYCardNumAndCipherNotification object:nil];
        // 得到交易密码
        [kDefaultNotificationCenter addObserver:self selector:@selector(backInfo:) name:GYPOSShounldInputTradingPasswordNotification object:nil];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.passwordView.passField.userInteractionEnabled = NO;
    if (self.selectField) {
        [self.selectField becomeFirstResponder];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIWindowDidBecomeVisibleNotification object:nil];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    if (self.keyView) {
        switch (self.keyView.pointPay) {
        case kPointPayCash:
            self.navigationController.navigationBar.barTintColor = kBlue0A59C2;
            break;
        case kPointPayHSB:
            self.navigationController.navigationBar.barTintColor = kHSBNavColor;
            break;
        case kPointPayScan:
            self.navigationController.navigationBar.barTintColor = kScanNavColor;
            
            break;
        default:
            break;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = kBlue0A59C2;
  
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
    [kDefaultNotificationCenter  removeObserver:self];

}

#pragma mark - private methods
- (void)initView
{
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    GYHSConsumerView* consumePointView = [[GYHSConsumerView alloc] init];
    consumePointView.consumView.textfield.delegate = self;
    consumePointView.delegate = self;
    @weakify(self);
    consumePointView.cleanBlock = ^{
        @strongify(self);
        self.scanView.hidden = YES;
    };
    [self.view addSubview:consumePointView];
    self.consumePointView = consumePointView;
    [self.consumePointView.consumView.textfield becomeFirstResponder];
    
    //键盘
    GYHSKeyView* keyView = [[GYHSKeyView alloc] init];
    keyView.delegate = self;
    [self.view addSubview:keyView];
    self.keyView = keyView;
    self.keyView.pointPay = kPointPayCash;
    [self.keyView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavigationHeight);
        make.left.equalTo(self.view).offset(self.consumePointView.width + kLetfwidth);
    }];
    
    //输入互生卡号
    GYHSPointInputView* inputCardView = [[GYHSPointInputView alloc] initWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(self.consumePointView.frame) + kDistanceHeight, kInputViewWidth, kCommonHeight) imageName:@"gyhs_img_cardNumber" placeholder:kLocalized(@"GYHS_Point_Swipe_Input_Number")];
    inputCardView.textfield.delegate = self;
    inputCardView.delegate = self;
    inputCardView.isShowRightView = YES;
    [self.view addSubview:inputCardView];
    self.inputCardView = inputCardView;
    
    //输入密码行
    GYHSPointPassInputView* passwordView = [[GYHSPointPassInputView alloc] initWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(self.inputCardView.frame) + 6, kInputViewWidth, kCommonHeight) type:kPasswordTrade];
    passwordView.passField.delegate = self;
    passwordView.hidden = YES;
    [self.view addSubview:passwordView];
    self.passwordView = passwordView;
    
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
            if (self.keyView.pointPay == kPointPayHSB) {
                NSString* cardStr = [self.inputCardView.textfield deleteSpaceField];
                if (![GYUtils isHSCardNo:cardStr]) {
                    [self.inputCardView.textfield tipWithContent:kLocalized(@"GYHS_Point_Input_Number_Error_Tip") animated:YES];
                    [self.inputCardView.textfield becomeFirstResponder];
                    return;
                }
            }
            [self.selectField resignFirstResponder];
            [self selectView:self.passwordView];
            [self.POSService confirkHSpay:self.consumePointView.realView.textfield.text];
        }
        
    }];
    [self.passwordView addGestureRecognizer:tap];
    //二维码图
    GYHSPointScanView* scanView = [[GYHSPointScanView alloc] init];
    scanView.hidden = YES;
    scanView.delegate = self;
    [self.view addSubview:scanView];
    self.scanView = scanView;
    [self.scanView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.equalTo(self.view).offset(CGRectGetMaxY(self.consumePointView.frame) + kDistanceHeight);
        make.bottom.equalTo(self.view).offset(-kDistanceHeight);
        make.left.equalTo(self.view).offset(kLetfwidth);
        make.width.mas_equalTo(kInputViewWidth);
    }];
}

#pragma mark - 处理刷卡器相关
- (void)getHsCardNumber:(NSNotification*)notice
{
    NSString* cardNumAndCipher = [notice object];
    if (cardNumAndCipher && cardNumAndCipher.length > 0) {
        NSArray* arrCardAndCipher = [cardNumAndCipher componentsSeparatedByString:@","];
        if (arrCardAndCipher.count == 2 ) { //当刷卡信息置空的时候赋值
            self.inputCardView.textfield.text = [GYUtils formatCardNo:arrCardAndCipher.firstObject];
            self.cardModel.HSCardNum = arrCardAndCipher[0];
            self.cardModel.CipherNum = arrCardAndCipher[1];
        }
    }
}

#pragma mark - 键盘显示通知
- (void)keyboardWillShow:(NSNotification*)Notification

{
    [YYTextKeyboardManager defaultManager].keyboardWindow.alpha = 0;
}

#pragma mark - 获取8位交易密码
- (void)backInfo:(NSNotification*)notice
{
    if ([[notice name] isEqualToString:GYPOSShounldInputTradingPasswordNotification]) {
        self.passwordView.passField.text = [notice object];
        [self requestHSB];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField*)textField
{
    if (textField == self.consumePointView.consumView.textfield) {
        self.consumePointView.realView.textfield.text = @"";
        self.consumePointView.HSBView.textfield.text = @"0.00";
        self.consumePointView.pointView.textfield.text = @"0.00";
        self.scanView.hidden = YES;
    }else if (textField == self.inputCardView.textfield){
        self.inputCardView.textfield.text = @"";
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

#pragma mark - GYHSKeyViewDelegate
- (void)keyAddWithString:(NSString*)string;
{
    self.scanView.hidden = YES;
    if (self.selectField == self.consumePointView.consumView.textfield) {
        self.selectField.text = [NSString stringWithFormat:@"%@%@", self.selectField.text, string];
        [self handleTextField];
    }
    else if (self.selectField == self.inputCardView.textfield) {
        self.cardModel = nil;
        self.selectField.text = [NSString stringWithFormat:@"%@%@", self.selectField.text, string];
        self.selectField.text = [self.selectField inputCardField];
    }
    else if (self.selectField == self.passwordView.passField) {
        self.selectField.text = [NSString stringWithFormat:@"%@%@", self.selectField.text, string];
        self.selectField.text = [self.selectField subPassField];
    }
}

- (void)keyDeleteWithString;
{
    self.scanView.hidden = YES;
    if (self.selectField.text.length > 0) {
        if (self.selectField == self.consumePointView.consumView.textfield) {
            self.selectField.text = [self.selectField.text substringToIndex:self.selectField.text.length - 1];
            if (!self.selectField.text.length) {
                self.consumePointView.realView.textfield.text = @"";
                self.consumePointView.HSBView.textfield.text = @"0.00";
                self.consumePointView.pointView.textfield.text = @"0.00";
            }
            else {
                [self handleTextField];
            }
        }
        else if (self.selectField == self.inputCardView.textfield) {
            self.cardModel = nil;
            self.selectField.text = [self.selectField.text substringToIndex:self.selectField.text.length - 1];
            self.selectField.text = [self.selectField inputCardField];
        }
        else if (self.selectField == self.passwordView.passField) {
            self.selectField.text = [self.selectField.text substringToIndex:self.selectField.text.length - 1];
            self.selectField.text = [self.selectField subPassField];
        }
    }
}

#pragma mark - 处理输入框
- (void)handleTextField
{
    self.selectField.text = [self.selectField inputEditField];
    NSString* consumeStr = [self.selectField deleteFormString];
    self.consumeString = consumeStr;
    NSDecimalNumber* consumeDeciaml = [NSDecimalNumber decimalNumberWithString:consumeStr];
    NSDecimalNumber* volumeDecimal = [NSDecimalNumber decimalNumberWithString:self.consumePointView.volumeAmount];
    NSDecimalNumber* HSBRateDeicmal = [NSDecimalNumber decimalNumberWithString:globalData.config.currencyToHsbRate];
    self.consumePointView.realView.textfield.text = [consumeDeciaml decimalNumberByAdding:volumeDecimal].stringValue;
    self.consumePointView.realView.textfield.text = [UITextField keepTwoDeciaml:self.consumePointView.realView.textfield.text];
    self.consumePointView.HSBView.textfield.text = [[consumeDeciaml decimalNumberByAdding:volumeDecimal] decimalNumberByMultiplyingBy:HSBRateDeicmal].stringValue;
    self.consumePointView.HSBView.textfield.text = [UITextField keepTwoDeciaml:self.consumePointView.HSBView.textfield.text];
    NSDecimalNumber* pointDeciaml = [[NSDecimalNumber decimalNumberWithString:self.consumePointView.pointRate] decimalNumberByMultiplyingBy:consumeDeciaml];
    NSString* pointString = [pointDeciaml.stringValue stringMultiplyStringToUpTwodecimalplaces:globalData.config.currencyToHsbRate].stringValue;
    self.consumePointView.pointView.textfield.text = [GYHSPublicMethod keepTwoDecimal:pointString];
}

- (void)keyClick:(NSInteger)index;
{
    switch (self.keyView.pointPay) {
    case kPointPayCash:
        self.inputCardView.hidden = NO;
        self.passwordView.hidden = YES;
        break;
    case kPointPayHSB:
        self.inputCardView.hidden = NO;
        self.passwordView.hidden = NO;
        break;
    case kPointPayScan:
        self.inputCardView.hidden = YES;
        self.passwordView.hidden = YES;
        break;
        
    default:
        break;
    }
    self.scanView.hidden = YES;
    if (index == 0) {
        //积分记录查询
        GYHSPointCheckVC* checkVC = [[GYHSPointCheckVC alloc] init];
        [self.navigationController pushViewController:checkVC animated:YES];
        return;
    }
    if (index == 3) {
        //点击ok确认
        if ([self isDataAllright]) {
            
            if (self.keyView.pointPay == kPointPayCash || self.keyView.pointPay == kPointPayHSB) {
            
                NSString* cardStr = [self.inputCardView.textfield deleteSpaceField];
                if (![GYUtils isHSCardNo:cardStr]) {
                    [self.inputCardView.textfield tipWithContent:kLocalized(@"GYHS_Point_Input_Number_Error_Tip") animated:YES];
                    [self.inputCardView.textfield becomeFirstResponder];
                    return;
                }
                if (self.keyView.pointPay == kPointPayCash) {
                    //现金支付请求
                    [self requestCash];
                }
                else {
                    if (self.passwordView.passField.text.length != 8) {
                        [self.passwordView.passField tipWithContent:kLocalized(@"GYHS_Point_Consume_Input_Trade_Passwd") animated:YES];
                        if (![self.POSService.posInfo isConnected]) {
                            self.passwordView.passField.userInteractionEnabled = YES;
                            [self.passwordView.passField becomeFirstResponder];
                            
                        }else{
                            [self.selectField resignFirstResponder];
                            [self selectView:self.passwordView];
                        }
                        return;
                    }
                    //互生币支付请求
                    [self requestHSB];
                }
            }
            else {
                [self.pointTool updatePosRunCode:self.batchModel.posRunCode];
                //获取交易流水号
                @weakify(self);
                [GYHSPointHttpTool getSourceTransNoWithsuccess:^(id responsObject) {
                    @strongify(self);
                    self.transNo = responsObject;
                    [self.scanArray removeAllObjects];
                    self.scanView.scanImageView.image = [GYUtils createQRImageWithString:[self.scanArray componentsJoinedByString:@"&"] size:self.scanView.scanImageView.size];
                    //二维码成图
                    self.scanView.hidden = NO;
                }
                    failure:^{
                    
                    }];
            }
            [self.keyView.sureBtn controlTimeOut];//对点击时间做一个控制
        }
    }
    else {
        [self.consumePointView.consumView.textfield becomeFirstResponder];
    }
}

#pragma mark - 数据是否正确
- (BOOL)isDataAllright
{
    if (self.consumePointView.consumView.textfield.text.length == 0) {
        //        [GYUtils showToast:kLocalized(@"GYHS_Point_Input_Consume_Cash")];
        [self.consumePointView.consumView.textfield tipWithContent:kLocalized(@"GYHS_Point_Input_Consume_Cash") animated:YES];
        [self.consumePointView.consumView.textfield becomeFirstResponder];
        return NO;
    }
    
    //消费金额*抵扣券最大比例
    NSDecimalNumber* consumNumber = [[NSDecimalNumber decimalNumberWithString:self.consumeString] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:[GlobalData shareInstance].couponRate]];
    //实付金额
    NSString* realString = [self.consumePointView.realView.textfield deleteFormString];
    NSDecimalNumber* realNumber = [NSDecimalNumber decimalNumberWithString:realString];
    NSComparisonResult result = [consumNumber compare:realNumber];
    if (result == NSOrderedDescending) {
        [GYUtils showToast:[NSString stringWithFormat:@"%@%.f%%", kLocalized(@"GYHS_Point_Deductible_Amount_Tip"), [GlobalData shareInstance].couponRate.doubleValue * 100]];
        
        return NO;
    }
    
    if ([self.consumePointView.pointView.textfield.text doubleValue] < 0.1) {
        [self.consumePointView.pointView.textfield tipWithContent:kLocalized(@"GYHS_Point_Point_Cash_Tip") animated:YES];
        return NO;
    }
    
    return YES;
}

#pragma mark - 现金支付
- (void)requestCash
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
        NSString* pointSum = self.consumePointView.pointView.textfield.text;
        //实付金额
        NSString* realPay = [self.consumePointView.realView.textfield deleteFormString];
        //实付互生币
        NSString* realHSB = [self.consumePointView.HSBView.textfield deleteFormString];
        //互生卡号
        NSString* cardStr = [self.inputCardView.textfield deleteSpaceField];
        [GYHSPointHttpTool newPointWithSourceTransNo:sourceTransNo
                                   sourceTransAmount:realPay
                                            pointSum:pointSum
                                           transType:@"23000"
                                         transAmount:realHSB
                                         orderAmount:self.consumeString
                                    deductionVoucher:self.consumePointView.volumePage
                                            perResNo:cardStr
                                         equipmentNo:equipmentNo
                                       equipmentType:equipmentType
                                       sourceBatchNo:self.batchModel.batchNo
                                           pointRate:self.consumePointView.pointRate
                                         termRunCode:self.batchModel.posRunCode
                                          secretCode:@""
                                            transPwd:@""
                                             success:^(id responsObject) {
                                                 if (kHTTPSuccessResponse(responsObject)) {
                                                     [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"GYHS_Point_Deal_Success")
                                                                                       topColor:TopColorBlue
                                                                                   comfirmBlock:^{
                                                                                       [self successEmpty];
                                                                                   }];
                                                 } else {
         [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"GYHS_Point_Deal_Fail")
                                           topColor:TopColorRed
                                       comfirmBlock:^{
               [GYHSPointHttpTool correctWithTransType:@"23010"
                                               transNo:sourceTransNo
                                          returnReason:kLocalized(@"GYHS_Point_Hsb_Correct")
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
                                             
                                             }];
    }
        failure:^{
        
        }];
}

#pragma mark - 互生币支付
- (void)requestHSB
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
        NSString* pointSum = self.consumePointView.pointView.textfield.text;
        //实付金额
        NSString* realPay = [self.consumePointView.realView.textfield deleteFormString];
        //实付互生币
        NSString* realHSB = [self.consumePointView.HSBView.textfield deleteFormString];
        //互生卡号
        NSString* cardStr = [self.inputCardView.textfield deleteSpaceField];
        [GYHSPointHttpTool newPointWithSourceTransNo:sourceTransNo
                                   sourceTransAmount:realPay
                                            pointSum:pointSum
                                           transType:@"21000"
                                         transAmount:realHSB
                                         orderAmount:self.consumeString
                                    deductionVoucher:self.consumePointView.volumePage
                                            perResNo:cardStr
                                         equipmentNo:equipmentNo
                                       equipmentType:equipmentType
                                       sourceBatchNo:self.batchModel.batchNo
                                           pointRate:self.consumePointView.pointRate
                                         termRunCode:self.batchModel.posRunCode
                                          secretCode:@""
                                            transPwd:self.passwordView.passField.text
                                             success:^(id responsObject) {
                                                 if (kHTTPSuccessResponse(responsObject)) {
                                                     [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"GYHS_Point_Hsb_Pay_Success")
                                                                                       topColor:TopColorBlue
                                                                                   comfirmBlock:^{
                                                                                       [self successEmpty];
                                                                                   }];
                                                 } else {
                                                     [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"GYHS_Point_Deal_Fail")
                                                                                       topColor:TopColorRed
                                                                                   comfirmBlock:^{
                                                                                       [GYHSPointHttpTool correctWithTransType:@"21010"
                                                                                           transNo:sourceTransNo
                                                                                           returnReason:kLocalized(@"GYHS_Point_Hsb_Correct")
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
#pragma mark - 二维码支付查询
- (void)requestScan
{
    @weakify(self);
    [GYHSPointHttpTool checkScanPayWithTermRunCode:self.batchModel.posRunCode
        batchNo:self.batchModel.batchNo
        equipmentNo:self.equipmentStr
        entCustId:globalData.loginModel.entCustId
        entResNo:globalData.loginModel.entResNo
        sourcePosDate:self.dateStr
        success:^(id responsObject) {
                                            @strongify(self);
                                               if ([responsObject[GYNetWorkDataKey] isKindOfClass:[NSNull class]]) {
                                                   [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"GYHS_Point_No_Payment_Tip")
                                                                                     topColor:TopColorRed
                                                                                 comfirmBlock:^{
                                                                                 
                                                                                 }];
                                               } else {
                                                   [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"GYHS_Point_Deal_Success")
                                                                                     topColor:TopColorBlue
                                                                                 comfirmBlock:^{
                                                                                     @strongify(self);
                                                          [self successEmpty];
                                                                                 }];
                                               }
        }
        failure:^{
        
        }];
}

#pragma mark - 成功后清空数据
- (void)successEmpty
{
    self.consumePointView.consumView.textfield.text = @"";
    self.consumePointView.realView.textfield.text = @"";
    self.consumePointView.HSBView.textfield.text = @"0.00";
    self.consumePointView.pointView.textfield.text = @"0.00";
    self.inputCardView.textfield.text = @"";
    self.passwordView.passField.text = @"";
    [self.consumePointView.consumView.textfield becomeFirstResponder];
    [self.consumePointView.volumeBtn setTitle:kLocalized(@"GYHS_Point_Volume") forState:UIControlStateNormal];
    self.consumePointView.volumeAmount = @"0.00";
    self.consumePointView.volumePage = @"0";
    self.consumePointView.volumeBtn.backgroundColor = kGrayc8c8d8;
    self.scanView.hidden = YES;
}

#pragma mark - GYHSCheckScanDelegate
- (void)scanClick
{
    //二维码查询
    [self requestScan];
}

#pragma mark - GYHSPointInputDelegate
- (void)clickRightAction:(NSInteger)index
{
    [self.inputCardView.textfield becomeFirstResponder];
    if (index == 1) {
          [[GYPOSService sharedInstance] swipingCard];
        self.passwordView.passField.userInteractionEnabled = NO;

    }
    else {
        //扫一扫
        GYHSCodeReaderViewController* codeReaderVC = [[GYHSCodeReaderViewController alloc] init];
        codeReaderVC.modalPresentationStyle = UIModalPresentationFormSheet;
        codeReaderVC.delegate = self;
        [self.navigationController pushViewController:codeReaderVC animated:YES];
    }
}

#pragma mark - GYHSCodeReaderDelegate
- (void)reader:(GYHSCodeReaderViewController*)reader didScanResult:(NSString*)result
{
    if ([GYUtils isPointCode:result]) {
        self.inputCardView.textfield.text = [GYUtils formatCardNo:[GYUtils PointCode:result]];
        [reader.navigationController popViewControllerAnimated:YES];
    }else{
        [reader startScanning];
    }
    
}

#pragma mark - GYHSConsumerDelegate
- (void)popSetPointRate
{
    GYSettingPointRateSetViewController* setVc = [[GYSettingPointRateSetViewController alloc] init];
    [self.navigationController pushViewController:setVc animated:YES];
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
- (NSMutableArray*)scanArray
{
    if (_scanArray == nil || !_scanArray.count) {
        // MH&11位企业互生号&19位企业客户号&6位终端流水号&6位批次号&18位手机标识码&14位日期时间（YYYYMMDDHHmmss）&3位货币代码（49）&12位交易金额（4）&4位积分比例（48用法六）&12企业承兑积分额（48用法六）&12互生币金额（48用法六）&（12位）交易流水号&(不限制长度)企业名称。 从交易日期开始做加密 组合前两位，企业互生号，设备标示为密钥做aes加密
        NSUUID* deviceUDID = [[UIDevice currentDevice] identifierForVendor];
        NSString* strUDID = [deviceUDID UUIDString];
        strUDID = [strUDID substringToIndex:18];
        self.equipmentStr = strUDID;
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString* strDate = [dateFormatter stringFromDate:[NSDate date]];
        self.dateStr = strDate;
        //12位交易金额
        NSString* transAmount = [GYHSPublicMethod transAmount:self.consumeString];
        //4位积分比例
        NSString* strpoint = [self.consumePointView.pointRate substringFromIndex:2];
        //积分额
        NSString* pointAmount = [GYHSPublicMethod transAmount:self.consumePointView.pointView.textfield.text];
        //互生币金额
        NSString* HSBAmount = [GYHSPublicMethod transAmount:[NSString stringWithFormat:@"%.2f", self.consumeString.doubleValue * globalData.config.currencyToHsbRate.doubleValue]];
        
        //实付金额
        NSString* payAmount = [GYHSPublicMethod transAmount:[self.consumePointView.realView.textfield deleteFormString]];
        //抵扣券张数
        NSString* tiketNumber = [GYHSPublicMethod transferTicket:self.consumePointView.volumePage];
        //交易流水后面加3
        NSString* transNumber = self.transNo;
        //从交易日期开始做加密
        NSString* fromDateString = [NSString stringWithFormat:@"%@&%@&%@&%@&%@&%@&%@&%@&%@&%@", strDate, globalData.config.currencyCode, transAmount, strpoint, pointAmount, HSBAmount, payAmount, tiketNumber, transNumber, globalData.loginModel.entCustName];
        //密钥
        NSString* key = [NSString stringWithFormat:@"%@&%@&%@", @"M1", globalData.loginModel.entResNo, strUDID];
        NSString * keyString = [fromDateString encodeWithKey: key];
        
        _scanArray = [NSMutableArray arrayWithArray:@[ @"M1",
                                                       globalData.loginModel.entResNo,
                                                       globalData.loginModel.entCustId,
                                                       self.batchModel.posRunCode == nil ? @"" : self.batchModel.posRunCode,
                                                       self.batchModel.batchNo == nil ? @"" : self.batchModel.batchNo,
                                                       strUDID,
                                                       keyString ]];
    }
    return _scanArray;
}


@end
