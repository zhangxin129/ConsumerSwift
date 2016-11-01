//
//  ViewController.m
//  HSCompanyPad
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 wangbb. All rights reserved.
//

#import "GYHSGenerationsExchangeHSBVC.h"
#import "GYAlertWithOneButtonView.h"
#import "GYCardReaderView.h"
#import "GYHSAccountCenter.h"
#import "GYHSCodeReaderViewController.h"
#import "GYHSExchageHSBViewController.h"
#import "GYHSExchangeHSBCommonModel.h"
#import "GYHSExchangeLabelView.h"
#import "GYHSPointHttpTool.h"
#import "GYKeyboardTwoButtonView.h"
#import "GYMoreLineTipsView.h"
#import "GYNetwork.h"
#import "GYPOSService.h"
#import "GYPadKeyboradView.h"
#import "GYPointTool.h"
#import "UITextField+GYHSPointTextField.h"
#import "GYPOSService.h"
#import <GYKit/UIButton+GYExtension.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <YYKit/YYTextKeyboardManager.h>
#import "GYTextField.h"


@interface GYHSGenerationsExchangeHSBVC () <GYPadKeyboradViewDelegate, UITextFieldDelegate, GYHSCodeReaderDelegate,GYKeyboardTwoButtonViewDelegate>

@property (nonatomic, weak) GYTextField* textField;
@property (nonatomic, strong) GYHSExchangeLabelView* showLTBView;
@property (nonatomic, strong) GYTextField* inputHSBTextField;
@property (nonatomic, strong) GYTextField* showHSBTextField;
@property (nonatomic, strong) GYMoreLineTipsView* tipView;
@property (nonatomic, strong) GYTextField* inputResNoTextField;
@property (nonatomic, strong) GYTextField* reInputResNoTextField;
@property (nonatomic, strong) GYKeyboardTwoButtonView* otherview;
@property (nonatomic, copy) NSString* overCount;
@property (nonatomic, copy) NSString* status;
@property (nonatomic, strong) NSMutableArray* tipsArray;
@property (nonatomic, strong) GYPOSService* POSService;
@property (nonatomic, strong) GYCardReaderModel * posInfo;
@property (nonatomic, strong) GYCardInfoModel * cardModel; // 互生号和暗码


@end

@implementation GYHSGenerationsExchangeHSBVC

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

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
    [self.inputHSBTextField becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIWindowDidBecomeVisibleNotification object:nil];
    [self getaDataFromService];
    [kDefaultNotificationCenter addObserver:self selector:@selector(getHsCardNumber:) name:GYCardNumAndCipherNotification object:nil];
    [kDefaultNotificationCenter addObserver:self selector:@selector(textchange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [YYTextKeyboardManager defaultManager].keyboardWindow.alpha = 1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)dealloc
{
    [kDefaultNotificationCenter removeObserver:self ];
}

#pragma mark - 键盘显示通知
- (void)keyboardWillShow:(NSNotification*)Notification
{
    [YYTextKeyboardManager defaultManager].keyboardWindow.alpha = 0;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    [self deleteLayerBorder:self.textField];
    [self needLayerBorder:textField];
    self.textField = (GYTextField*)textField;
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
    [self deleteLayerBorder:self.textField];
}

- (void)textchange
{
    if (_inputHSBTextField.text.length == 0) {
        _showHSBTextField.text = @"0.00";
    }


}

#pragma mark - touch event response
- (void)needLayerBorder:(UIView*)view
{
    view.layer.borderWidth = 2;
    view.layer.borderColor = kBlue0A59C1.CGColor;
}

- (void)deleteLayerBorder:(UIView*)view
{
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor clearColor].CGColor;
}

#pragma mark - GYPadKeyboradViewDelegate
- (void)padKeyBoardViewDidClickNumberWithString:(NSString*)aString
{
    if (self.textField == nil) {
        [GYUtils showToast:kLocalized(@"GYHS_ExchageHSB_Please_Select_InputView")];
        return;
    }
    
    self.textField.text = [NSString stringWithFormat:@"%@%@", self.textField.text, aString];
    
    if (self.textField == self.inputHSBTextField) {
        
        self.textField.text = [self.textField inputIntegerField];
        
        _showHSBTextField.text = [NSString stringWithFormat:@"%.2f", (globalData.config.currencyToHsbRate.doubleValue) * ([self.textField deleteFormString].doubleValue)];
        _showHSBTextField.text = [GYUtils formatCurrencyStyle:_showHSBTextField.text.doubleValue];
    }
    
    if (self.textField == self.inputResNoTextField) {
        self.textField.text = [self.textField inputCardField];
    }
   
    if (self.textField == self.reInputResNoTextField) {
        self.textField.text = [self.textField inputCardField];
    }
    
    if (self.inputResNoTextField.text.length == 14 && self.reInputResNoTextField.superview != self.view && self.textField == self.inputResNoTextField) {
        [self addReInputResNoTextField];
    }
}

- (void)padKeyBoardViewDidClickDelete
{
    if (self.textField == nil) {
        [GYUtils showToast:kLocalized(@"GYHS_ExchageHSB_Please_Select_InputView")];
        return;
    }
    DDLogInfo(@"点击删除了");
    if (self.textField.text.length > 0) {
        self.textField.text = [self.textField.text substringToIndex:self.textField.text.length - 1];
    }
    else {
        return;
    }
    
    if (self.textField == self.inputHSBTextField) {
        self.textField.text = [self.textField inputEditField];
        
        _showHSBTextField.text = [NSString stringWithFormat:@"%.2f", (globalData.config.currencyToHsbRate.doubleValue) * ([self.textField deleteFormString].doubleValue)];
        _showHSBTextField.text = [GYUtils formatCurrencyStyle:_showHSBTextField.text.doubleValue];
    }
    
    if (self.textField == self.inputResNoTextField) {
        self.textField.text = [self.textField inputCardField];
    }
    
    if (self.textField == self.reInputResNoTextField) {
        self.textField.text = [self.textField inputCardField];
    }
    
    
    if (self.inputResNoTextField.text.length != 14 && self.textField == self.inputResNoTextField) {
        [self removeReInputResNoTextField];
    }
}

#pragma mark - GYHSCodeReaderDelegate
- (void)reader:(GYHSCodeReaderViewController*)reader didScanResult:(NSString*)result
{
    if (result.length >= 14 && [result hasPrefix:@"ID&"] && [GYUtils isHSCardNo:[result substringWithRange:NSMakeRange(3, 11)]]) {
        NSString* cardNumber = [result substringWithRange:NSMakeRange(3, 11)];
        self.inputResNoTextField.text = [GYUtils formatCardNo:cardNumber];
        [reader.navigationController popViewControllerAnimated:YES];
        [self loadDataAccountcheckIsFit];
        if (self.reInputResNoTextField.superview) {
            [self.reInputResNoTextField removeFromSuperview];
        }
    }
    else {
        [reader startScanning];
    }
}

- (void)readerDidCancel:(GYHSCodeReaderViewController*)reader
{
    DDLogInfo(@"撤销");
}

#pragma mark -  GYKeyboardTwoButtonViewDelegate
-(void)keyboardTwoButtonViewFirstClick {
     //兑换互生币
    GYHSExchageHSBViewController* vc = [[GYHSExchageHSBViewController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}

-(void)keyboardTwoButtonViewSecondClick:(UIButton*)button {
     //点击ok 代兑互生币
    if ([self judgeInputLimitIsOK]) {
        [button controlTimeOut];
        [self postDataToService];
    }
}

#pragma mark - event

- (void)scanTapAction
{
    [self deleteLayerBorder:self.textField];
    self.textField = nil;
    //扫码
    GYHSCodeReaderViewController* codeReaderVC = [[GYHSCodeReaderViewController alloc] init];
    codeReaderVC.modalPresentationStyle = UIModalPresentationFormSheet;
    codeReaderVC.delegate = self;
    [self.navigationController pushViewController:codeReaderVC animated:YES];
}

- (void)cardTapAction
{
    [self deleteLayerBorder:self.textField];
    self.textField = nil;
    [[GYPOSService sharedInstance] swipingCard];
}

#pragma mark - request
/*!
 *    获取流通币数量
 */
- (void)getaDataFromService
{
    @weakify(self);
    [[GYHSAccountCenter defaultCenter] updateHsbAccount:^(id returnValue) {
        @strongify(self);
        self.showLTBView.textContents = [GYUtils formatCurrencyStyle:[GYHSAccountCenter defaultCenter].ltbBalance.doubleValue];
    }
                                                failure:^(NSError* error){
                                                    
                                                }];
}

/*!
 *    代兑互生币
 */
- (void)postDataToService
{
    NSString * equipmentNo;
    NSString * equipmentType;
    NSString * channelType;
    if (self.cardModel.CipherNum.length) {
//        equipmentNo = self.posInfo.posId;
        equipmentType = GYPOSDeviceCardReader;
    }else{
        NSUUID* deviceUDID = [[UIDevice currentDevice] identifierForVendor];
        NSString* strUDID = [deviceUDID UUIDString];
        strUDID = [strUDID substringToIndex:18];
        equipmentNo = strUDID;
        equipmentType = GYPOSDeviceMoblie;
    }

    
    [GYPointTool shareInstance];
    [[GYPointTool shareInstance] reset];
    [[GYPointTool shareInstance] setBatchNoAndPosRunCode];
    [[GYPointTool shareInstance] getBatchNoAndPosRunCode:^(id model) {
        GYPOSBatchModel* tempModel = [GYPOSBatchModel shareInstance];
        tempModel = (GYPOSBatchModel*)model;
    }];
    @weakify(self);
    [GYHSPointHttpTool getSourceTransNoWithsuccess:^(id responsObject) {
        @strongify(self);
        NSDictionary* dicParams = @{
                                    @"cashAmt" : [_inputHSBTextField deleteFormString],
                                    @"entCustId" : globalData.loginModel.entCustId,
                                    @"entCustName" : globalData.loginModel.entCustName,
                                    @"entCustType" : globalData.loginModel.entResType,
                                    @"entResNo" : globalData.loginModel.entResNo,
                                    @"optCustId" : globalData.loginModel.custId,
                                    @"perResNo" : [self.inputResNoTextField deleteSpaceField],
                                    @"sourceCurrencyCode" : globalData.config.currencyCode,
                                    @"transType" : @"52000",
                                    @"sourceTransDt" : [GYUtils dateToString:[NSDate date]],
                                    @"termRuncode" : [GYPOSBatchModel shareInstance].posRunCode,
                                    @"batchNo" : [GYPOSBatchModel shareInstance].batchNo,
                                    @"originNo" : responsObject,
                                    @"channel":channelType
                                    };
        
        [GYNetwork POST:GY_HSDOMAINAPPENDING(GYPOSProxyBuyHsb)
              parameter:dicParams
                success:^(id returnValue) {
                    
                    [[GYPointTool shareInstance] updatePosRunCode:[GYPOSBatchModel shareInstance].posRunCode];
                    if ([returnValue[GYNetWorkCodeKey] isEqualToNumber:@200]) {
                        [GYUtils showToast:returnValue[@"msg"]];
                        [self getaDataFromService];
                        [self loadDataAccountcheckIsFit];
                    } else {
                        [GYUtils showToast:returnValue[@"msg"]];
                    }
                    
                }
                failure:^(NSError* error) {
                    
                }
            isIndicator:YES];
    }
                                           failure:^{
                                               
                                           }];
}

/*!
 *    检查消费者账号是否已实名注册
 *
 *    @param success success的回调
 */
- (void)loadDataAccountcheckIsFit
{
    NSString* cardStr = [self.inputResNoTextField deleteSpaceField];
    if (![GYUtils isHSCardNo:cardStr]) {
        [self.inputResNoTextField tipWithContent:kLocalized(@"GYHS_Point_Input_Number_Error_Tip") animated:YES];
        [self.inputResNoTextField becomeFirstResponder];
        return;
    }

    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYPOSCheckResNoStatus)
         parameter:@{ @"perResNo" : [self.inputResNoTextField deleteSpaceField],
                      @"token" : globalData.loginModel.token }
           success:^(id returnValue) {
               
               if ([returnValue[GYNetWorkCodeKey] isEqualToNumber:@200]) {
                   self.status = kSaftToNSString(returnValue[GYNetWorkDataKey]);
                   [GYNetwork GET:GY_HSDOMAINAPPENDING(GYPOSQueryCusTip) parameter:@{@"custId":[self.inputResNoTextField deleteSpaceField],@"userType":@"2"} success:^(id returnValue) {
                       if ([returnValue[GYNetWorkCodeKey] isEqualToNumber:@200]) {
                           
                           NSString* count;
                           if ([self.status isEqualToString:@"1"]) {
                               //未实名
                               count  = kSaftToNSString(returnValue[GYNetWorkDataKey][@"notRegDayBuyHsbMax"]);
                           }else {
                               //实名
                               count  = kSaftToNSString(returnValue[GYNetWorkDataKey][@"regDayBuyHsbMax"]);
                           }
                           NSString* useCount = kSaftToNSString(returnValue[GYNetWorkDataKey][@"dayHadBuyHsb"]);
                           if (count && useCount) {
                               self.overCount = [NSString stringWithFormat:@"%.2f",count.doubleValue - useCount.doubleValue];
                               NSString* strText = [NSString stringWithFormat: @"%@%.2f,%@%@%@。",kLocalized(@"GYHS_ExchageHSB_Per_Day_Tips_Front"),count.doubleValue,kLocalized(@"GYHS_ExchageHSB_Per_Day_Tips_Appending"),self.overCount,kLocalized(@"GYHS_ExchageHSB_HSB")];
                               NSMutableAttributedString* hintString = [[NSMutableAttributedString alloc] initWithString:strText attributes:@{NSForegroundColorAttributeName:kGray999999}];
                               //获取要调整颜色的文字位置,调整颜色
                               NSRange range = [[hintString string] rangeOfString:self.overCount options:NSBackwardsSearch];
                               [hintString addAttribute:NSForegroundColorAttributeName value:kRedE40011 range:range];
                               
                               [self.tipsArray replaceObjectAtIndex:2 withObject:hintString];
                               self.tipView.dataArray = self.tipsArray;
                           }
                       }
                   } failure:^(NSError *error) {
                       
                   }];
                   
                   
               }
               
           }
           failure:^(NSError* error) {
               
           }
       isIndicator:YES];
}


#pragma mark - private methods
/*!
 *    初始化视图
 */
- (void)setUp
{
    self.view.backgroundColor = [UIColor colorWithRed:228 / 255.0 green:229 / 255.0 blue:245 / 255.0 alpha:1];
    self.title = kLocalized(@"GYHS_ExchageHSB_Generations_HSB");
    
    [self.view addSubview:self.otherview];
    [self.otherview mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(44);
        make.width.equalTo(@(kDeviceProportion(130)));
    }];
    
    GYPadKeyboradView *keyView = [[GYPadKeyboradView alloc] init];
    keyView.delegate = self;
    [self.view addSubview:keyView];
    [keyView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(self.otherview.mas_left).offset(kDeviceProportion(5));
        make.top.equalTo(self.view).offset(44);
        make.left.equalTo(self.view.mas_left).offset(kDeviceProportion(469));
        make.bottom.equalTo(self.view.mas_bottom);
    }];

    [self.view addSubview:self.showLTBView];
    [self.showLTBView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.view).offset(kDeviceProportion(20) + 44);
        make.left.equalTo(self.view).offset(kDeviceProportion(20));
        make.width.equalTo(@(kDeviceProportion(429)));
        make.height.equalTo(@(kDeviceProportion(45)));
    }];
    
    [self.view addSubview:self.inputHSBTextField];
    [self.inputHSBTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.showLTBView.mas_bottom).offset(kDeviceProportion(3));
        make.left.equalTo(self.showLTBView.mas_left);
        make.width.equalTo(@(kDeviceProportion(429)));
        make.height.equalTo(@(kDeviceProportion(45)));
    }];
    
    //添加默认
    self.textField = self.inputHSBTextField;
    [self needLayerBorder:self.textField];
    
    [self.view addSubview:self.showHSBTextField];
    [self.showHSBTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.inputHSBTextField.mas_bottom).offset(kDeviceProportion(3));
        make.left.equalTo(self.showLTBView.mas_left);
        make.width.equalTo(@(kDeviceProportion(429)));
        make.height.equalTo(@(kDeviceProportion(45)));
    }];
    
    [self.view addSubview:self.tipView];
    [self.tipView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view).offset(kDeviceProportion(20));
        make.top.equalTo(self.showHSBTextField.mas_bottom).offset(kDeviceProportion(3));
        make.width.equalTo(@(kDeviceProportion(429)));
        make.height.equalTo(@(kDeviceProportion(120)));
    }];
    
    [self.view addSubview:self.inputResNoTextField];
    [self.inputResNoTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.tipView.mas_bottom).offset(kDeviceProportion(24));
        make.left.equalTo(self.view).offset(kDeviceProportion(20));
        make.width.equalTo(@(kDeviceProportion(429)));
        make.height.equalTo(@(kDeviceProportion(45)));
    }];
    
    [self chageTips];
}

/*!
 *    温馨提示
 */
- (void)chageTips
{
    [self.tipsArray removeAllObjects];
    NSString* strText1 = [NSString stringWithFormat:@"%@%@-%@%@；", kLocalized(@"GYHS_ExchageHSB_Real_Name_Tips_Front"), [GYUtils formatCurrencyStyle:globalData.config.regBuyHsbMin.doubleValue], [GYUtils formatCurrencyStyle:globalData.config.regBuyHsbMax.doubleValue], kLocalized(@"GYHS_ExchageHSB_HSB")];
    
    NSString* strText2 = [NSString stringWithFormat:@"%@%@-%@%@；", kLocalized(@"GYHS_ExchageHSB_No_Real_Name_Tips_Front"), [GYUtils formatCurrencyStyle:globalData.config.notRegBuyHsbMin.doubleValue], [GYUtils formatCurrencyStyle:globalData.config.notRegBuyHsbMax.doubleValue], kLocalized(@"GYHS_ExchageHSB_HSB")];
    
    NSString* strText3 = kLocalized(@"GYHS_ExchageHSB_Input_Tips_Front");
    
    [self.tipsArray addObjectsFromArray:@[ strText1, strText2, strText3 ]];
    self.tipView.dataArray = self.tipsArray;
}

/*!
 *    移除二次输入互生号的输入框
 */
- (void)removeReInputResNoTextField
{
    [self chageTips];
    [self.reInputResNoTextField removeFromSuperview];
}

/*!
 *    添加二次输入互生号的输入框
 */
- (void)addReInputResNoTextField
{
    [self.view addSubview:self.reInputResNoTextField];
    //这里是要请求输入的消费者账号的实名状态
    [self loadDataAccountcheckIsFit];
    
    [self.reInputResNoTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_inputResNoTextField.mas_bottom).offset(kDeviceProportion(kDeviceProportion(3)));
        make.left.equalTo(self.view).offset(kDeviceProportion(20));
        make.width.equalTo(@(kDeviceProportion(429)));
        make.height.equalTo(@(kDeviceProportion(45)));
    }];
}

/*!
 *    对输入进行判断
 *
 *    @return 输入的是否正确
 */
- (BOOL)judgeInputLimitIsOK
{
    
    if ([self.inputHSBTextField deleteFormString].length == 0) {
        [self.inputHSBTextField tipWithContent:kLocalized(@"GYHS_ExchageHSB_Please_Input_Money_Number") animated:YES];
        return NO;
    }
    
    NSDecimalNumber* numberTotal = [[NSDecimalNumber alloc] initWithString:[self.showLTBView.textContents stringByReplacingOccurrencesOfString:@"," withString:@""]];
    NSDecimalNumber* numberInput = [[NSDecimalNumber alloc] initWithString:[self.inputHSBTextField deleteFormString]];
    if (numberTotal.doubleValue < numberInput.doubleValue) {
        [self.inputHSBTextField tipWithContent:kLocalized(@"GYHS_ExchageHSB_HSB_Balance_Insufficient") animated:YES];
        return NO;
    }
    
    if (self.inputResNoTextField.text.length != 14) {
        [self.inputResNoTextField tipWithContent:kLocalized(@"GYHS_ExchageHSB_Please_Input_Card_Or_ResNo") animated:YES];
        return NO;
    }
    
    if (![self.inputResNoTextField.text isEqualToString:self.reInputResNoTextField.text] && self.reInputResNoTextField.superview) {
        [self.reInputResNoTextField tipWithContent:kLocalized(@"GYHS_ExchageHSB_Diffrence_Of_Two_ResNo") animated:YES];
        return NO;
    }
    
    if (![self.status isEqualToString:@"1"]) {
        if ([self.inputHSBTextField deleteFormString].doubleValue < globalData.config.regBuyHsbMin.doubleValue || [self.inputHSBTextField deleteFormString].doubleValue > globalData.config.regBuyHsbMax.doubleValue) {

            [self.inputHSBTextField tipWithContent:[NSString stringWithFormat:kLocalized(@"%@%@-%@%@"), kLocalized(@"GYHS_ExchageHSB_Real_Name_Tips_Front"), [GYUtils formatCurrencyStyle:globalData.config.regBuyHsbMin.doubleValue], [GYUtils formatCurrencyStyle:globalData.config.regBuyHsbMax.doubleValue], kLocalized(@"GYHS_ExchageHSB_HSB")] animated:YES];
            return NO;
        }
    }
    else {
        if ([self.inputHSBTextField deleteFormString].doubleValue < globalData.config.notRegBuyHsbMin.doubleValue || [self.inputHSBTextField deleteFormString].doubleValue > globalData.config.notRegBuyHsbMax.doubleValue) {
            [self.inputHSBTextField tipWithContent:[NSString stringWithFormat:kLocalized(@"%@%@-%@%@"), kLocalized(@"GYHS_ExchageHSB_No_Real_Name_Tips_Front"), [GYUtils formatCurrencyStyle:globalData.config.notRegBuyHsbMin.doubleValue], [GYUtils formatCurrencyStyle:globalData.config.notRegBuyHsbMax.doubleValue], kLocalized(@"GYHS_ExchageHSB_HSB")] animated:YES];
            return NO;
        }
    }
    
    if ([self.inputHSBTextField deleteFormString].doubleValue > self.overCount.doubleValue) {
        [self.inputHSBTextField tipWithContent:kLocalized(@"GYHS_ExchageHSB_NumberUsersExchangeMaxTip") animated:YES];
        return NO;
    }
    
    return YES;
}

#pragma mark - lazy load
- (NSMutableArray*)tipsArray
{
    if (!_tipsArray) {
        _tipsArray = [NSMutableArray array];
    }
    return _tipsArray;
}
/*!
 *    键盘右边
 *
 *    @return 键盘的2个按钮
 */
- (GYKeyboardTwoButtonView*)otherview
{
    if (!_otherview) {
        _otherview = [[GYKeyboardTwoButtonView alloc] initWithTitle:kLocalized(@"GYHS_ExchageHSB_Exchage_HSB_Two_Line")];
        _otherview.delegate = self;
    }
    return _otherview;
}

/*!
 *    温馨提示
 *
 *    @return tipView
 */
- (GYMoreLineTipsView*)tipView
{
    if (!_tipView) {
        _tipView = [[GYMoreLineTipsView alloc] init];
    }
    return _tipView;
}

- (GYHSExchangeLabelView*)showLTBView
{
    if (!_showLTBView) {
        _showLTBView = [[GYHSExchangeLabelView alloc] initWithTitle:kLocalized(@"GYHS_ExchageHSB_Your_LTB_Balance_Colon")];
        _showLTBView.backgroundColor = kWhiteFFFFFF;
    }
    return _showLTBView;
}

/*!
 *    输入互生币的输入框
 *
 *    @return inputHSBTextField
 */
- (GYTextField*)inputHSBTextField
{
    if (!_inputHSBTextField) {
        GYTextField* inputHSBTextField = [[GYTextField alloc] init];
        inputHSBTextField.placeholder = kLocalized(@"GYHS_ExchageHSB_Please_Input_Money_Number");
        UIImageView* leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhs_point_cash"]];
        leftView.contentMode = UIViewContentModeCenter;
        leftView.frame = CGRectMake(0, 0, 43, 43);
        inputHSBTextField.leftView = leftView;
        inputHSBTextField.leftViewMode = UITextFieldViewModeAlways;
        inputHSBTextField.delegate = self;
        inputHSBTextField.backgroundColor = [UIColor whiteColor];
        inputHSBTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        inputHSBTextField.inputView = [[UIView alloc]initWithFrame:CGRectZero];
        _inputHSBTextField = inputHSBTextField;
    }
    return _inputHSBTextField;
}

/*!
 *    显示互生币的输入框（输入禁用）
 *
 *    @return showHSBTextField
 */
- (GYTextField*)showHSBTextField
{
    if (!_showHSBTextField) {
        _showHSBTextField = [[GYTextField alloc] init];
        UIImageView* leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhs_HSBCoin"]];
        leftView.contentMode = UIViewContentModeCenter;
        leftView.frame = CGRectMake(0, 0, kDeviceProportion(45), kDeviceProportion(45));
        _showHSBTextField.leftView = leftView;
        _showHSBTextField.leftViewMode = UITextFieldViewModeAlways;
        _showHSBTextField.enabled = NO;
        _showHSBTextField.text = @"0.00";
        _showHSBTextField.backgroundColor = [UIColor whiteColor];
        _showHSBTextField.inputView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _showHSBTextField;
}

/*!
 *    输入互生号的输入框
 *
 *    @return inputResNoTextField
 */
- (GYTextField*)inputResNoTextField
{
    if (!_inputResNoTextField) {
        GYTextField* inputResNoTextField = [[GYTextField alloc] init];
        inputResNoTextField.placeholder = kLocalized(@"GYHS_ExchageHSB_Please_Input_Card_Or_ResNo");
        inputResNoTextField.delegate = self;
        inputResNoTextField.backgroundColor = [UIColor whiteColor];
        UIImageView* leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhs_img_cardNumber"]];
        leftView.contentMode = UIViewContentModeCenter;
        leftView.frame = CGRectMake(0, 0, kDeviceProportion(45), kDeviceProportion(45));
        inputResNoTextField.leftView = leftView;
        inputResNoTextField.leftViewMode = UITextFieldViewModeAlways;
        
        UIView* baseRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(90), kDeviceProportion(45))];
        UIImageView* cardRightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhs_card_post"]];
        cardRightView.userInteractionEnabled = YES;
        cardRightView.contentMode = UIViewContentModeCenter;
        cardRightView.frame = CGRectMake(0, 0, kDeviceProportion(45), kDeviceProportion(45));
        [baseRightView addSubview:cardRightView];
        UITapGestureRecognizer* cardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapAction)];
        [cardRightView addGestureRecognizer:cardTap];
        
        UIImageView* scanRightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhs_scan_image"]];
        scanRightView.userInteractionEnabled = YES;
        scanRightView.contentMode = UIViewContentModeCenter;
        scanRightView.frame = CGRectMake(kDeviceProportion(45), 0, kDeviceProportion(45), kDeviceProportion(45));
        [baseRightView addSubview:scanRightView];
        UITapGestureRecognizer* scanTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanTapAction)];
        [scanRightView addGestureRecognizer:scanTap];
        
        inputResNoTextField.rightView = baseRightView;
        inputResNoTextField.rightViewMode = UITextFieldViewModeAlways;
        inputResNoTextField.inputView = [[UIView alloc]initWithFrame:CGRectZero];
         inputResNoTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputResNoTextField = inputResNoTextField;
        
    }
    return _inputResNoTextField;
}

/*!
 *    再次输入互生号的输入框
 *
 *    @return reInputResNoTextField
 */
- (GYTextField*)reInputResNoTextField
{
    if (!_reInputResNoTextField) {
        GYTextField*reInputResNoTextField = [[GYTextField alloc] init];
        reInputResNoTextField.placeholder = kLocalized(@"GYHS_ExchageHSB_Please_Input_ResNo_Again");
        reInputResNoTextField.delegate = self;
        reInputResNoTextField.backgroundColor = [UIColor whiteColor];
        UIImageView* leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhs_img_cardNumber"]];
        leftView.contentMode = UIViewContentModeCenter;
        leftView.frame = CGRectMake(0, 0, kDeviceProportion(45), kDeviceProportion(45));
        reInputResNoTextField.leftView = leftView;
        reInputResNoTextField.leftViewMode = UITextFieldViewModeAlways;
        reInputResNoTextField.inputView = [[UIView alloc]initWithFrame:CGRectZero];
        reInputResNoTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _reInputResNoTextField = reInputResNoTextField;
    }
    return _reInputResNoTextField;
}

#pragma mark - 处理刷卡器相关
- (void)getHsCardNumber:(NSNotification*)notice
{
    NSString* cardNumAndCipher = [notice object];
    if (cardNumAndCipher && cardNumAndCipher.length > 0) {
        NSArray* arrCardAndCipher = [cardNumAndCipher componentsSeparatedByString:@","];
        if (arrCardAndCipher.count == 2) { //当刷卡信息置空的时候赋值
            self.inputResNoTextField.text = arrCardAndCipher.firstObject;
            self.inputResNoTextField.text = [self.inputResNoTextField inputCardField];
            self.cardModel.HSCardNum = arrCardAndCipher[0];
            self.cardModel.CipherNum = arrCardAndCipher[1];
            [self loadDataAccountcheckIsFit];
            if (self.reInputResNoTextField.superview) {
                [self.reInputResNoTextField removeFromSuperview];
            }
        }
    }
}


@end
