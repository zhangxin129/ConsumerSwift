//
//  GYHSExchageHSBVIewController.m
//
//  Created by apple on 16/8/1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSExchageHSBViewController.h"
#import "GYPadKeyboradView.h"
#import "GYHSExchangeLabelView.h"
#import "GYMoreLineTipsView.h"
#import "GYNetwork.h"
#import "GYHSExchangeHSBCommonModel.h"
#import "UITextField+GYHSPointTextField.h"
#import "GYHSPayTool.h"
#import "GYHSAccountCenter.h"
#import "GYHSToolPayModel.h"
#import "GYPayViewController.h"
#import <GYKit/UIButton+GYExtension.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <YYKit/YYTextKeyboardManager.h>
#import "GYTextField.h"
@interface GYHSExchageHSBViewController () <GYPadKeyboradViewDelegate, UITextFieldDelegate>

/*!
 *    快捷支付的底层视图
 */
@property (nonatomic, strong) UIView* baseLeftView;

@property (nonatomic, weak) GYTextField* textField;
@property (nonatomic, strong) GYHSExchangeLabelView* showHSBView;
@property (nonatomic, strong) GYMoreLineTipsView* moreLineTipsView;
@property (nonatomic, strong) GYTextField* inputHSBCountTextField;

@property (nonatomic, strong) GYHSExchangeHSBMaxModel* maxModel; //互生币最大最小的单笔购买数
@property (nonatomic, strong) UIButton* okButton;

@end

@implementation GYHSExchageHSBViewController

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [YYTextKeyboardManager defaultManager].keyboardWindow.alpha = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    @weakify(self);
    [self loadInitViewType:GYStopTypeLogout :^{
        @strongify(self);
        [self initView];
        [self.inputHSBCountTextField becomeFirstResponder];
        self.inputHSBCountTextField.text = @"";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIWindowDidBecomeVisibleNotification object:nil];
        [self getaDataFromNet];
        [self loadMaxHSB];
        
    }];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
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

#pragma mark - 添加边框
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
    
    if (self.textField == self.inputHSBCountTextField) {
        self.textField.text = [self.textField inputIntegerField];
//        self.textField.text = [self.textField inputEditField];
    }
}

- (void)padKeyBoardViewDidClickDelete
{
    if (self.textField == nil) {
        [GYUtils showToast:kLocalized(@"GYHS_ExchageHSB_Please_Select_InputView")];
        return;
    }
    
    if (self.textField.text.length > 0) {
        self.textField.text = [self.textField.text substringToIndex:self.textField.text.length - 1];
    }
    else {
        return;
    }
    
    if (self.textField == self.inputHSBCountTextField) {
        self.textField.text = [self.textField inputEditField];
    }
}

#pragma mark - event
- (void)oKButtonAction
{
    if (![self judgeInputLimitIsOK]) {
        return;
    }
    [self exchangeHsbRequest];
    [self.okButton controlTimeOut];
}

#pragma mark - request
/*!
 *    加载兑换互生币的最大最小数量
 */
- (void)loadMaxHSB
{
    NSString* entType = @"";
    if (globalData.companyType == kCompanyType_Trustcom) {
        entType = @"T";
    }
    else if (globalData.companyType == kCompanyType_Membercom) {
        entType = @"B";
    }
    
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSQueryEntTips) parameter:@{ @"entType" : entType } success:^(id returnValue) {
        
        if ([returnValue[@"retCode"] isEqualToNumber:@200]) {
            self.maxModel = [[GYHSExchangeHSBMaxModel alloc] initWithDictionary:returnValue[@"data"] error:nil];
            NSString *beText;
            if (globalData.companyType == kCompanyType_Trustcom) {
                beText = [NSString stringWithFormat:@"%@%@-%@。",kLocalized(@"GYHS_ExchageHSB_Tips_Front"),[GYUtils formatCurrencyStyle:_maxModel.t_buyHsbMin.doubleValue ],[GYUtils formatCurrencyStyle:_maxModel.t_buyHsbMax.doubleValue]];
                ;
            }
            else   {
                beText = [NSString stringWithFormat:@"%@%@-%@。",kLocalized(@"GYHS_ExchageHSB_Tips_Front"),[GYUtils formatCurrencyStyle:_maxModel.b_buyHsbMin.doubleValue ],[GYUtils formatCurrencyStyle:_maxModel.b_buyHsbMax.doubleValue]];
                ;
            }
          
            self.moreLineTipsView.dataArray = @[ beText ];
        }
        
    } failure:^(NSError* error){
        
    }];
}

/*!
 *    兑换互生币
 */
- (void)exchangeHsbRequest
{
    NSDictionary* dicParams = @{
                                @"channel" : GYChannelType,
                                @"hsResNo" : globalData.loginModel.entResNo,
                                @"custId" : globalData.loginModel.entCustId,
                                @"buyHsbAmt" : [self.inputHSBCountTextField deleteFormString],
                                @"custName" : globalData.loginModel.entCustName,
                                @"userType" : GYUserTypeCompany,
                                @"custType" : globalData.loginModel.entResType,
                                @"optCustId" : globalData.loginModel.custId
                                };
    @weakify(self);
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSExchangeHsb) parameter:dicParams success:^(id returnValue) {
        @strongify(self);
        if ([returnValue[GYNetWorkCodeKey] isEqualToNumber:@200]) {
            GYHSToolPayModel *model = [[GYHSToolPayModel alloc] init];
            model.orderNo = kSaftToNSString(returnValue[GYNetWorkDataKey]);
            model.cashAmount = kSaftToNSString([self.inputHSBCountTextField deleteFormString]);
            GYPayViewController *vc = [[GYPayViewController alloc] initWithNibName:NSStringFromClass([GYPayViewController class]) bundle:nil];
            vc.model = model;
            vc.type = GYPaymentServiceTypeExchangeHSCurrency;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError* error) {
        
    } isIndicator:YES];
}

/*!
 *    获取互生币
 */
- (void)getaDataFromNet
{
    @weakify(self);
    [[GYHSAccountCenter defaultCenter] updateHsbAccount:^(id returnValue) {
        @strongify(self);
        self.showHSBView.textContents = [GYUtils formatCurrencyStyle:[GYHSAccountCenter defaultCenter].ltbBalance.doubleValue];
    } failure:^(NSError* error){
        
    }];
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHS_ExchageHSB_Exchage_HSB");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    DDLogInfo(@"Load Controller: %@", [self class]);
    [self addKeyBoard];
    [self addLeftView];
}

- (void)addKeyBoard
{
    [self.view addSubview:self.okButton];
    [self.okButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(self.view).offset(-13);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(kNavigationHeight+kDeviceProportion(10));
        make.width.equalTo(@(kDeviceProportion(130)));
    }];
    
    GYPadKeyboradView* view = [[GYPadKeyboradView alloc] init];
    view.delegate = self;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(_okButton.mas_left).offset(kDeviceProportion(5));
        make.top.equalTo(self.view).offset(44);
        make.left.equalTo(self.view.mas_left).offset(kDeviceProportion(469));
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)addLeftView
{
    if (self.baseLeftView.superview) {
        [self.baseLeftView removeFromSuperview];
        for (id view in self.baseLeftView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    [self.view addSubview:self.baseLeftView];
    [self.baseLeftView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(self.view).offset(kDeviceProportion(20));
        make.top.equalTo(self.view).offset(kDeviceProportion(20) + kNavigationHeight);
        make.bottom.equalTo(self.view);
        make.width.equalTo(@(kDeviceProportion(429)));
    }];
    
    [_baseLeftView addSubview:self.showHSBView];
    [self.showHSBView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.top.equalTo(_baseLeftView);
        make.height.equalTo(@(kDeviceProportion(45)));
    }];
    
    [_baseLeftView addSubview:self.moreLineTipsView];
    [self.moreLineTipsView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(_baseLeftView);
        make.top.equalTo(_showHSBView.mas_bottom).offset(kDeviceProportion(3));
        make.height.equalTo(@(kDeviceProportion(52)));
    }];
    
    [_baseLeftView addSubview:self.inputHSBCountTextField];
    [self.inputHSBCountTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(_baseLeftView);
        make.top.equalTo(_moreLineTipsView.mas_bottom).offset(kDeviceProportion(24));
        make.height.equalTo(_showHSBView.mas_height);
    }];
    
    self.textField = self.inputHSBCountTextField;
    [self needLayerBorder:self.textField];
}

/*!
 *    对输入做限制
 *
 *    @return 输入做限制是否正确
 */
- (BOOL)judgeInputLimitIsOK
{
    if (_inputHSBCountTextField.text.length == 0) {
        [_inputHSBCountTextField tipWithContent:kLocalized(@"GYHS_ExchageHSB_Please_Input_HSB_Count") animated:YES];
        return NO;
    }
    
    if ([_inputHSBCountTextField deleteFormString].doubleValue < _maxModel.t_buyHsbMin.doubleValue || [_inputHSBCountTextField deleteFormString].doubleValue > _maxModel.t_buyHsbMax.doubleValue) {
        [GYUtils showToast:[NSString stringWithFormat:@"%@%@-%@", kLocalized(@"GYHS_ExchageHSB_Tips_Front"), [GYUtils formatCurrencyStyle:_maxModel.t_buyHsbMin.doubleValue], [GYUtils formatCurrencyStyle:_maxModel.t_buyHsbMax.doubleValue]]];
        return NO;
    }
    return YES;
}

#pragma mark - lazy load
- (UIButton*)okButton
{
    if (!_okButton) {
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okButton setBackgroundImage:[UIImage imageNamed:@"gyhs_long_ok"] forState:UIControlStateNormal];
        [_okButton addTarget:self action:@selector(oKButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okButton;
}

- (UIView*)baseLeftView
{
    if (!_baseLeftView) {
        _baseLeftView = [[UIView alloc] init];
        _baseLeftView.backgroundColor = kDefaultVCBackgroundColor;
    }
    return _baseLeftView;
}

- (GYHSExchangeLabelView*)showHSBView
{
    if (!_showHSBView) {
        _showHSBView = [[GYHSExchangeLabelView alloc] initWithTitle:kLocalized(@"GYHS_ExchageHSB_LTB_Balance_Colon")];
        _showHSBView.backgroundColor = kWhiteFFFFFF;
    }
    return _showHSBView;
}

- (GYMoreLineTipsView*)moreLineTipsView
{
    if (!_moreLineTipsView) {
        _moreLineTipsView = [[GYMoreLineTipsView alloc] init];
        _moreLineTipsView.backgroundColor = kWhiteFFFFFF;
    }
    return _moreLineTipsView;
}

- (GYTextField*)inputHSBCountTextField
{
    if (!_inputHSBCountTextField) {
        _inputHSBCountTextField = [[GYTextField alloc] init];
        _inputHSBCountTextField.placeholder = kLocalized(@"GYHS_ExchageHSB_Please_Input_HSB_Count");
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhs_HSBCoin"]];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.frame = CGRectMake(0, 0, 43, 43);
        _inputHSBCountTextField.leftView = imageView;
        _inputHSBCountTextField.leftViewMode = UITextFieldViewModeAlways;
        _inputHSBCountTextField.delegate = self;
        _inputHSBCountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputHSBCountTextField.backgroundColor = kWhiteFFFFFF;
        _inputHSBCountTextField.inputView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _inputHSBCountTextField;
}

@end
