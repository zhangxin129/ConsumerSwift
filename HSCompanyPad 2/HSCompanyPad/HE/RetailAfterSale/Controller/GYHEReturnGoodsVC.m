//
//  GYHEReturnGoodsVC.m
//
//  Created by apple on 16/8/24.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHEReturnGoodsVC.h"
#import "UILabel+Category.h"
#import <YYKit/UIGestureRecognizer+YYAdd.h>
#import "GYHSPointPassInputView.h"
#import <GYKit/UIButton+GYExtension.h>
#import "GYHEReAfSaleHttpTool.h"
#import "GYPointTool.h"

@interface GYHEReturnGoodsVC () <UITextFieldDelegate>

@property (nonatomic, strong) UIView* mainView;
@property (nonatomic, strong) UIView* footerView;
@property (nonatomic, strong) UIButton* confirmButton;
@property (nonatomic, strong) UITextField* inputMoneyTextField;
@property (nonatomic, strong) GYHSPointPassInputView* inputPasswordView;
// 批次号和终端流水号
@property (nonatomic, strong) GYPOSBatchModel* BatchNoAndPosRunCodeModel;
@property (nonatomic, strong) GYPointTool* rateTool;

@end

@implementation GYHEReturnGoodsVC

#pragma mark - lazy load
- (GYPOSBatchModel*)BatchNoAndPosRunCodeModel
{
    if (_BatchNoAndPosRunCodeModel == nil) {
        _BatchNoAndPosRunCodeModel = [GYPOSBatchModel shareInstance];
    }
    return _BatchNoAndPosRunCodeModel;
}

- (GYPointTool*)rateTool
{
    if (_rateTool == nil) {
        _rateTool = [GYPointTool shareInstance];
    }
    return _rateTool;
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

#pragma mark - private methods
- (void)initView
{
    // 获取批次号信息
    [self.rateTool setBatchNoAndPosRunCode];
    [self.rateTool getBatchNoAndPosRunCode:^(id model){
        //        self.batchCodeModel = model;
    }];
    
    self.title = kLocalized(@"线下交易退货");
    self.view.backgroundColor = kWhiteFFFFFF;
    [self createMainView];
    [self createFooterView];
}

#pragma mark - event
- (void)createMainView
{
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kDeviceProportion(kScreenWidth), kDeviceProportion(kScreenHeight - 44 - 70))];
    [self.view addSubview:_mainView];
    _mainView.backgroundColor = kWhiteFFFFFF;
    
    UIView* plainView = [[UIView alloc] init];
    plainView.layer.borderColor = kGrayDDDDDD.CGColor;
    plainView.layer.borderWidth = 1.0f;
    [_mainView addSubview:plainView];
    [plainView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@(kDeviceProportion(204)));
        make.width.equalTo(@(kDeviceProportion(400)));
        make.top.equalTo(_mainView.mas_top).offset(50);
        make.left.equalTo(_mainView.mas_left).offset(87);
    }];
    
    NSArray* titleArray = @[ @"互生号", @"流水号", @"交易日期", @"交易金额", @"交易积分" ];
    NSArray* valueArray = @[ [GYUtils formatCardNo:_model.perResNo], _model.sourceTransNo, _model.sourceTransDate, _model.sourceTransAmount, _model.entPoint ];
    
    for (int i = 0; i < titleArray.count; i++) {
        UILabel* titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, i * 40 + i * 1, kDeviceProportion(120), kDeviceProportion(40))];
        titleLable.backgroundColor = kGreenF5F5F5;
        titleLable.customBorderType = UIViewCustomBorderTypeBottom;
        [titleLable initWithText:titleArray[i] TextColor:kGray333333 Font:kFont32 TextAlignment:0];
        [plainView addSubview:titleLable];
        UILabel* blackLable = [[UILabel alloc] initWithFrame:CGRectMake(0, i * 40 + i * 1, kDeviceProportion(10), kDeviceProportion(40))];
        blackLable.backgroundColor = kGreenF5F5F5;
        blackLable.customBorderType = UIViewCustomBorderTypeBottom;
        [plainView addSubview:blackLable];
        
        UILabel* valueLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLable.frame) + 10, i * 40 + i * 1, kDeviceProportion(260), kDeviceProportion(40))];
        [valueLable initWithText:valueArray[i] TextColor:kGray333333 Font:kFont32 TextAlignment:0];
        [plainView addSubview:valueLable];
        
        UILabel* whiteLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLable.frame), i * 40 + i * 1, kDeviceProportion(10), kDeviceProportion(40))];
        whiteLable.backgroundColor = kWhiteFFFFFF;
        whiteLable.customBorderType = UIViewCustomBorderTypeBottom;
        [plainView addSubview:whiteLable];
    }
    
    UILabel* inputMoneyLable = [[UILabel alloc] init];
    [inputMoneyLable initWithText:kLocalized(@"输入退货金额：") TextColor:kGray333333 Font:kFont32 TextAlignment:0];
    [_mainView addSubview:inputMoneyLable];
    [inputMoneyLable mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@(kDeviceProportion(40)));
        make.width.equalTo(@(kDeviceProportion(400)));
        make.top.equalTo(_mainView.mas_top).offset(100);
        make.left.equalTo(plainView.mas_left).offset(400 + 50);
    }];
    
    _inputMoneyTextField = [[UITextField alloc] init];
    _inputMoneyTextField.keyboardType = UIKeyboardTypeNumberPad;
    _inputMoneyTextField.layer.borderColor = kGrayDDDDDD.CGColor;
    _inputMoneyTextField.layer.borderWidth = 1.0f;
    _inputMoneyTextField.delegate = self;
    [_mainView addSubview:_inputMoneyTextField];
    [_inputMoneyTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@(kDeviceProportion(40)));
        make.width.equalTo(@(kDeviceProportion(270)));
        make.top.equalTo(_mainView.mas_top).offset(100);
        make.left.equalTo(inputMoneyLable.mas_left).offset(130);
    }];
    
    _inputPasswordView = [[GYHSPointPassInputView alloc] initWithFrame:CGRectMake(87 + 400 + 50, 100 + 40 + 20, kDeviceProportion(400), kDeviceProportion(40)) type:kPasswordLogin];
    _inputPasswordView.layer.borderColor = kGrayDDDDDD.CGColor;
    _inputPasswordView.layer.borderWidth = 1.0f;
    _inputPasswordView.passField.delegate = self;
    [_inputPasswordView.passField addTarget:self action:@selector(passText:) forControlEvents:UIControlEventEditingChanged];
    [_mainView addSubview:_inputPasswordView];
}
- (void)createFooterView
{
    _footerView = [[UIView alloc] init];
    _footerView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.16];
    [self.view addSubview:_footerView];
    [_footerView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(kDeviceProportion(70)));
    }];
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton.layer.cornerRadius = 5;
    _confirmButton.layer.borderWidth = 1;
    _confirmButton.layer.borderColor = kRedE50012.CGColor;
    _confirmButton.layer.masksToBounds = YES;
    [_confirmButton setTitle:kLocalized(@"完成") forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmButton setBackgroundColor:kRedE50012];
    [_confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_confirmButton];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@(kDeviceProportion(33)));
        make.width.equalTo(@(kDeviceProportion(164)));
        make.centerX.centerY.equalTo(_footerView);
    }];
}

- (void)passText:(UITextField*)textfield
{
    if (textfield.text.length > 6) {
        [textfield resignFirstResponder];
        textfield.text = [textfield.text substringToIndex:6];
    }
}

- (void)confirmButtonAction:(UIButton*)sender
{
    if (![self isAllRight]) {
        return;
    }
    if (_inputPasswordView.passField.text.length != 6) {
        [_inputPasswordView.passField tipWithContent:kLocalized(@"GYHE_ReturnGoods_PleaseEnter6-digitLoginPassword") animated:YES];
        return;
    }
    
    [sender controlTimeOutWithSecond:5];
    [self requestSubmit];
}
#pragma mark - request
- (void)requestSubmit
{
    NSString* equipmentNo;
    NSString* equipmentType;
    if (self.model.strCipherNum.length < 3) {
        NSUUID* deviceUDID = [[UIDevice currentDevice] identifierForVendor];
        NSString* strUDID = [deviceUDID UUIDString];
        strUDID = [strUDID substringToIndex:18];
        equipmentNo = strUDID;
        equipmentType = GYPOSDeviceMoblie;
    }
    @weakify(self);
    [GYHEReAfSaleHttpTool getSourceTransNoWithsuccess:^(id responsObject) {
        @strongify(self);
        NSString* sourceTransNo = responsObject;
        NSString* transType = [self.model.transType stringByReplacingCharactersInRange:NSMakeRange(3, 1) withString:@"2"];
        NSString* transAmount = [NSString stringWithFormat:@"%.2f", [self.inputMoneyTextField.text doubleValue] * [globalData.config.currencyToHsbRate doubleValue]];
        [GYHEReAfSaleHttpTool returnGoodsWithOldTransNo:self.model.sourceTransNo sourceTransNo:sourceTransNo sourceTransAmount:self.inputMoneyTextField.text transAmount:transAmount termRunCode:self.BatchNoAndPosRunCodeModel.posRunCode equipmentNo:equipmentNo secretCode:@"" transPwd:self.inputPasswordView.passField.text transType:transType perResNo:self.model.perResNo strBatchNo:self.BatchNoAndPosRunCodeModel.batchNo  success:^(id responsObject) {
            if (kHTTPSuccessResponse(responsObject)) {
//                [kDefaultNotificationCenter postNotificationName:GYOrderPayNotification object:nil];
//                [GYUtils alertWithContext:kLocalized(@"退货成功")
//                              buttonTitle:kLocalized(@"确定")
//                                  dismiss:^{
//                                      
//                                  }];
            } else {
//                [GYUtils alertWithContext:kLocalized(@"退货失败")
//                              buttonTitle:kLocalized(@"确定")
//                                  dismiss:^{
//                                  }];
                self.inputPasswordView.passField.text = nil;
                NSString* transTypeRevo = [transType substringFromIndex:1];
                transTypeRevo = [transTypeRevo stringByReplacingCharactersInRange:NSMakeRange(3, 1) withString:@"1"];
                
//                [GYMcardHttpTool correctWithTransType:transTypeRevo
//                                              transNo:self.returnModel.transNo
//                                         returnReason:kLocalized(@"POS_ReturnCorrect")
//                                       equitpmentType:equipmentType
//                                             initiate:@"MOBILE"
//                                          termRunCode:self.BatchNoAndPosRunCodeModel.posRunCode
//                                             perResNo:self.returnModel.perResNo
//                                          equipmentNo:equipmentNo
//                                           secretCode:self.returnModel.strCipherNum ? self.returnModel.strCipherNum:@""
//                                        sourceBatchNo:self.BatchNoAndPosRunCodeModel.batchNo
//                                              success:^(id responsObject) {
//                                              }
//                                              failure:^{
//                                              }];
//            }

        }
        
        } failure:^{
        
        }];
    } failure:^{
    
    }];
}

#pragma mark-- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField*)textField
{
}

- (BOOL)isAllRight
{
    if ([self.inputMoneyTextField.text doubleValue] <= 0) {
        [self.inputMoneyTextField tipWithContent:kLocalized(@"GYHE_ReturnGoods_ReturnsMustBeMoreThanZero") animated:YES];
        return NO;
    }
    
    if ([self.inputMoneyTextField.text doubleValue] > [self.model.transAmount doubleValue]) {
        [self.inputMoneyTextField tipWithContent:kLocalized(@"GYHE_ReturnGoods_TheReturnAmountCannotBeGreaterThanTheAmountActuallyPaidForTheOrder") animated:YES];
        
        return NO;
    }
    return YES;
}


@end
