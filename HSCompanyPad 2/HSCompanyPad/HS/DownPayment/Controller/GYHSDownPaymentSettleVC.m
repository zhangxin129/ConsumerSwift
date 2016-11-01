//
//  GYHSDownPaymentSettleVC.m
//
//  Created by apple on 16/8/4.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSDownPaymentSettleVC.h"
#import "GYHSCodeReaderViewController.h"
#import "GYHSPayKeyView.h"
#import "GYHSPaymentAlertView.h"
#import "GYHSPaymentCheckModel.h"
#import "GYHSPaymentSettleView.h"
#import "GYHSPointHttpTool.h"
#import "GYHSPointInputView.h"
#import "GYHSPublicMethod.h"
#import "GYPointTool.h"
#import "GYPOSService.h"
#import "GYCardReaderModel.h"
#import "GYSettingPointRateSetViewController.h"
#import <GYKit/NSString+NSDecimalNumber.h>
#import "UITextField+GYHSPointTextField.h"
#import "GYTextField.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <YYKit/YYTextKeyboardManager.h>
#import "GYPOSService.h"
#import <GYKit/UIButton+GYExtension.h>
#define kLetfwidth kDeviceProportion(20)
@interface GYHSDownPaymentSettleVC () <GYHSPayKeyDelegate, UITextFieldDelegate, GYHSPointInputDelegate, GYHSPaymentSetPointDelegate, GYHSCodeReaderDelegate>
@property (nonatomic, weak) GYHSPayKeyView* keyView;
@property (nonatomic, weak) GYHSPaymentSettleView* settltView;
@property (nonatomic, strong) UITextField* selectField;
@property (nonatomic, copy) NSString* consumeString; //消费金额
@property (nonatomic, copy) NSString* realAmount; //实付金额
@property (nonatomic, strong) GYPOSBatchModel* batchModel; // 批次号和终端流水号
@property (nonatomic, strong) GYPointTool* pointTool; /**积分获取工具*/
@property (nonatomic, strong) GYCardReaderModel * posInfo;
@property (nonatomic, strong) GYPOSService* POSService;
@property (nonatomic, strong) GYCardInfoModel * cardModel; // 互生号和暗码
@end

@implementation GYHSDownPaymentSettleVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
     [kDefaultNotificationCenter addObserver:self selector:@selector(getHsCardNumber:) name:GYCardNumAndCipherNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
    [kDefaultNotificationCenter removeObserver:self];
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHS_Down_Payment_Settle");
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIWindowDidBecomeVisibleNotification object:nil];
    
    self.realAmount = @"0.00";
    GYHSPaymentSettleView* settltView = [[GYHSPaymentSettleView alloc] init];
    settltView.delegate = self;
    settltView.consumView.textfield.delegate = self;
    settltView.cardView.textfield.delegate = self;
    settltView.cardView.isShowRightView = YES;
    settltView.cardView.delegate = self;
    [settltView.cardView.textfield becomeFirstResponder];
    [self.view addSubview:settltView];
    self.settltView = settltView;
    
    GYHSPayKeyView* keyView = [[GYHSPayKeyView alloc] init];
    keyView.delegate = self;
    [self.view addSubview:keyView];
    self.keyView = keyView;
    [self.keyView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavigationHeight);
        make.left.equalTo(self.view).offset(settltView.width + kLetfwidth);
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField*)textField
{
    if (textField == self.settltView.consumView.textfield) {
        self.settltView.HSBView.textfield.text = @"0.00";
        self.settltView.pointView.textfield.text = @"0.00";
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    if (self.selectField) {
        [self deleteView:(UIView*)[self.selectField superview]];
    }
    self.selectField = textField;
    [self selectView:(UIView*)[self.selectField superview]];
}

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
- (void)keyPayAddWithString:(NSString*)string
{
    if (self.selectField == nil) {
        [GYUtils showToast:kLocalized(@"GYHS_Down_Select_Edit_Field")];
        return;
    }
    self.selectField.text = [NSString stringWithFormat:@"%@%@", self.selectField.text, string];
    [self handleTextField];
}
- (void)keyPayDeleteWithString
{
    if (self.selectField == nil) {
        [GYUtils showToast:kLocalized(@"GYHS_Down_Select_Edit_Field")];
        return;
    }
    if (self.selectField.text.length > 0) {
        self.selectField.text = [self.selectField.text substringToIndex:self.selectField.text.length - 1];
        [self handleTextField];
    }
}
- (void)keyClick:(NSInteger)index
{
    if (index == 0) {
        //清除
        self.settltView.cardView.textfield.text = @"";
        self.settltView.cashView.textfield.text = @"";
        self.settltView.consumView.textfield.text = @"";
        self.settltView.HSBView.textfield.text = @"0.00";
        self.settltView.pointView.textfield.text = @"0.00";
        [self.settltView.cardView.textfield becomeFirstResponder];
    }
    else {
        //OK
        if ([self isDataAllright]) {
            //            NSString* str = @"预付定金\n消费金额\n互生币\n积分比例\n消费积分";
            NSString* str = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@", kLocalized(@"GYHS_Down_Payment"), kLocalized(@"GYHS_Down_Consume_Cash"), kLocalized(@"GYHS_Down_Hsb"), kLocalized(@"GYHS_Down_Point_Rate"), kLocalized(@"GYHS_Down_Consume_Point")];
            NSMutableAttributedString* leftMessage = [[NSMutableAttributedString alloc] initWithString:str];
            //预付定金
            NSString* paymentStr = self.settltView.cashView.textfield.text;
            //消费金额
            NSString* consumeStr = [GYHSPublicMethod keepTwoDecimal:self.consumeString];
            //互生币
            NSString* hsbStr = self.settltView.HSBView.textfield.text;
            //积分比例
            NSString* pointStr = self.settltView.pointRate;
            //消费积分
            NSString* pointCashStr = self.settltView.pointView.textfield.text;
            NSString* rightStr = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@", paymentStr, consumeStr, hsbStr, pointStr, pointCashStr];
            NSMutableAttributedString* rightMessage = [[NSMutableAttributedString alloc] initWithString:rightStr];
            @weakify(self);
            [GYHSPaymentAlertView alertWithTitle:kLocalized(@"GYHS_Down_Warm_Tip")
                                         Message:kLocalized(@"GYHS_Down_Sure_Down_Settle")
                                   leftAttribute:leftMessage
                                  rightAttribute:rightMessage
                                        topColor:TopColorBlue
                                    comfirmBlock:^{
                                        @strongify(self);
                                        [self.keyView.sureBtn controlTimeOut];
                                        //预付定金结算
                                        [self request];
                                    }];
        }
    }
}

#pragma mark - GYHSPointInputDelegate
- (void)clickRightAction:(NSInteger)index
{
    if (index == 1) {
        //刷卡
         [[GYPOSService sharedInstance] swipingCard];
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
       if ([GYUtils isPointCode:result]) {
        self.settltView.cardView.textfield.text = [GYUtils formatCardNo:[GYUtils PointCode:result]];
        [self clearUI];
        [reader.navigationController popViewControllerAnimated:YES];
    }else{
        [reader startScanning];
    }

}

#pragma mark - 数据是否正确
- (BOOL)isDataAllright
{
    if (self.selectField == nil) {
        [GYUtils showToast:kLocalized(@"GYHS_Down_Select_Edit_Field")];
    }
    NSString* cardStr = [self.settltView.cardView.textfield deleteSpaceField];
    if (![GYUtils isHSCardNo:cardStr]) {
        [self.settltView.cardView.textfield tipWithContent:kLocalized(@"GYHS_Down_Input_Number_Error_Tip") animated:YES];
        [self.settltView.cardView.textfield becomeFirstResponder];
        return NO;
    }
    if (!self.settltView.cashView.textfield.text.length) {
        [self.settltView.cashView.textfield tipWithContent:kLocalized(@"GYHS_Down_Settle_Down_Cash") animated:YES];

        return NO;
    }
    if (self.settltView.consumView.textfield.text.length == 0) {
        [self.settltView.consumView.textfield tipWithContent:kLocalized(@"GYHS_Down_Input_Consume_Cash") animated:YES];
        [self.settltView.consumView.textfield becomeFirstResponder];
        return NO;
    }
    if ([self.settltView.pointView.textfield.text doubleValue] < 0.1) {
        [self.settltView.pointView.textfield tipWithContent:kLocalized(@"GYHS_Down_Point_Cash_Tip") animated:YES];
        return NO;
    }
    //消费金额*抵扣券最大比例
    NSDecimalNumber* consumNumber = [[NSDecimalNumber decimalNumberWithString:self.consumeString] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:[GlobalData shareInstance].couponRate]];
    //实付金额
    NSDecimalNumber* realNumber = [[NSDecimalNumber decimalNumberWithString:self.consumeString] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:self.settltView.volumeAmount]];
    NSComparisonResult result = [consumNumber compare:realNumber];
    if (result == NSOrderedDescending) {
        [GYUtils showToast:[NSString stringWithFormat:@"%@%.f%%", kLocalized(@"GYHS_Down_Deductible_Amount_Tip"), [GlobalData shareInstance].couponRate.doubleValue * 100]];
        
        return NO;
    }
    //互生币比较
    if ([[self.settltView.HSBView.textfield deleteFormString] doubleValue] > [self.settltView.model.transAmount doubleValue]) {
        [GYUtils showToast:kLocalized(@"GYHS_Down_Settle_Cash_Tip")];
        return NO;
    }
    return YES;
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
            
           self.settltView.cardView.textfield.text = [GYUtils formatCardNo:arrCardAndCipher.firstObject];
            
            self.cardModel.HSCardNum = arrCardAndCipher[0];
            self.cardModel.CipherNum = arrCardAndCipher[1];

        }
    }
    
    
}

#pragma mark - 互生卡改变清空数据
- (void)clearUI
{
    self.settltView.cashView.textfield.text = @"";
}

#pragma mark - 预付定金结算
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
    NSString* transType = [self.settltView.model.transType stringByReplacingCharactersInRange:NSMakeRange(3, 1) withString:@"8"];
    [GYHSPointHttpTool getSourceTransNoWithsuccess:^(id responsObject) {
        @strongify(self);
        NSString* sourceTransNo = responsObject;
        NSString* pointSum = self.settltView.pointView.textfield.text;
        //互生卡号
        NSString* cardStr = [self.settltView.cardView.textfield deleteSpaceField];
        [GYHSPointHttpTool earnestSettleWithTransType:transType
                                             pointSum:pointSum
                                             perResNO:cardStr
                                    sourceTransAmount:self.realAmount
                                          equipmentNo:equipmentNo
                                        equipmentType:equipmentType
                                        sourceBatchNo:self.batchModel.batchNo
                                          transAmount:self.realAmount
                                            pointRate:self.settltView.pointRate
                                          termRunCode:self.batchModel.posRunCode
                                     oldSourceTransNo:self.settltView.model.sourceTransNo
                                        sourceTransNo:sourceTransNo
                                          orderAmount:self.consumeString
                                     deductionVoucher:self.settltView.volumePage
                                              success:^(id responsObject) {
                                                  if (kHTTPSuccessResponse(responsObject)) {
                                                      [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"GYHS_Down_Settle_Hsb_Down_Success")
                                                                                        topColor:TopColorBlue
                                                                                    comfirmBlock:^{
                                                              [self successEmpty];
                                                                                    }];
                                                  } else {
                                                      //201进行冲正
                                                      [GYHSPointHttpTool correctWithTransType:@"21810"
                                                                                      transNo:sourceTransNo
                                                                                 returnReason:kLocalized(@"GYHS_Down_Settle_Hsb_Down_Fail")
                                                                               equitpmentType:equipmentType
                                                                                     initiate:equipmentType
                                                                                  termRunCode:self.batchModel.posRunCode
                                                                                     perResNo:cardStr
                                                                                  equipmentNo:equipmentNo
                                                                                   secretCode:@""
                                                                                sourceBatchNo:self.batchModel.batchNo
                                                                                      success:^(id responsObject) {
                                                                                      
                                                                                      }
                                                                                      failure:^{
                                                                                      
                                                                                      }];
                                                  }
                                              }
                                              failure:^{
                                              
                                              }];
    }
        failure:^{
        
        }];
}

#pragma mark - 成功后清空数据
- (void)successEmpty
{
    self.settltView.cardView.textfield.text = @"";
    self.settltView.cashView.textfield.text = @"";
    self.settltView.consumView.textfield.text = @"";
    self.settltView.HSBView.textfield.text = @"0.00";
    self.settltView.pointView.textfield.text = @"0.00";
    [self.settltView.cardView.textfield becomeFirstResponder];
    [self.settltView.volumeBtn setTitle:kLocalized(@"GYHS_Point_Volume") forState:UIControlStateNormal];
    self.settltView.volumeAmount = @"0.00";
    self.settltView.volumePage = @"0";
    self.settltView.volumeBtn.backgroundColor = kGrayc8c8d8;
}

#pragma mark - 编辑框处理
- (void)handleTextField
{
    if (self.selectField == self.settltView.cardView.textfield) {
        self.cardModel = nil;
        [self clearUI];
        self.selectField.text = [self.selectField inputCardField];
    }
    else if (self.selectField == self.settltView.consumView.textfield) {
        if (!self.selectField.text.length) {
            self.settltView.HSBView.textfield.text = @"0.00";
            self.settltView.pointView.textfield.text = @"0.00";
        }
        else {
            self.selectField.text = [self.selectField inputEditField];
            NSString* consumeStr = [self.selectField deleteFormString];
            self.consumeString = consumeStr;
            NSDecimalNumber* consumeDeciaml = [NSDecimalNumber decimalNumberWithString:consumeStr];
            NSDecimalNumber* volumeDecimal = [NSDecimalNumber decimalNumberWithString:self.settltView.volumeAmount];
            NSDecimalNumber* HSBRateDeicmal = [NSDecimalNumber decimalNumberWithString:globalData.config.currencyToHsbRate];
            NSDecimalNumber* realDeciaml = [consumeDeciaml decimalNumberByAdding:volumeDecimal];
            self.realAmount = realDeciaml.stringValue;
            self.settltView.HSBView.textfield.text = [realDeciaml decimalNumberByMultiplyingBy:HSBRateDeicmal].stringValue;
            self.settltView.HSBView.textfield.text = [UITextField keepTwoDeciaml:self.settltView.HSBView.textfield.text];
            NSDecimalNumber* pointDeciaml = [[NSDecimalNumber decimalNumberWithString:self.settltView.pointRate] decimalNumberByMultiplyingBy:consumeDeciaml];
            NSString* pointString = [pointDeciaml.stringValue stringMultiplyStringToUpTwodecimalplaces:globalData.config.currencyToHsbRate].stringValue;
            self.settltView.pointView.textfield.text = [GYHSPublicMethod keepTwoDecimal:pointString];
        }
    }
}

#pragma mark - GYHSPaymentSetPointDelegate
- (void)popPointRate
{
    GYSettingPointRateSetViewController* setVc = [[GYSettingPointRateSetViewController alloc] init];
    [self.navigationController pushViewController:setVc animated:YES];
}

#pragma mark - lazy load
- (GYPointTool*)pointTool
{
    if (_pointTool == nil) {
        _pointTool =  [GYPointTool shareInstance];
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
