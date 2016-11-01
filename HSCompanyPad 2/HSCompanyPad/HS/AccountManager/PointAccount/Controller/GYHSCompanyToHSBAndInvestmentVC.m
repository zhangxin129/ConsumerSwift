//
//  GYHSCompanyToHSBAndInvestmentVC.m
//
//  Created by 吴文超 on 16/8/20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSCompanyToHSBAndInvestmentVC.h"
#import "GYHSPointTransformHSBView.h"
#import "GYHSAccountUIFactory.h"
#import "GYPadKeyboradView.h"
#import "GYHSAccountKeyBoard.h"
#import <GYKit/UIView+Extension.h>
#import "UITextField+GYHSPointTextField.h"
#import "GYHSCompanyGeneralDetailCheckVC.h"
#import <GYKit/NSString+NSDecimalNumber.h>
#import "GYAlertShowDataWithOKButtonView.h"
#import "GYHSPointInvestView.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <BlocksKit/BlocksKit+UIKit.h>
#import <YYKit/YYTextKeyboardManager.h>
#import "GYHSAccountHttpTool.h"
#import "UITextField+GYHSPointTextField.h"
#import "GYHSAccountCenter.h"
#import <GYKit/UIButton+GYExtension.h>
#define kLetfwidth kDeviceProportion(20)
#define kInputViewWidth kDeviceProportion(429)
#define kNavigationHeight 44
#define kDistanceHeight kDeviceProportion(24)
#define kCommonHeight kDeviceProportion(45)
#define kConsumeWidth (kLetfwidth + kInputViewWidth)

#define kCommonViewTag 1555
//定义一个转换比率
#define kTransRatio @"1.0"

@interface GYHSCompanyToHSBAndInvestmentVC () <GYHSAccountKeyBoardDelegate, UITextFieldDelegate>

@property (nonatomic, strong) GYHSPointTransformHSBView *pointToHSBView;
@property (nonatomic, strong) GYHSPointInvestView *pointToInvestView;
@property (nonatomic, strong) GYHSAccountKeyBoard *keyView;
@property (nonatomic, strong) UITextField *selectTextfield;
@property (nonatomic, strong) UIButton *clickOKBtn;
@end

@implementation GYHSCompanyToHSBAndInvestmentVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kLocalized(@"GYHS_Account_Point_Transform_HSB");
    @weakify(self);
    [self loadInitViewType:GYStopTypeLogout :^{
        @strongify(self);
        [self initView];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDLogInfo(@"Show Controller: %@", [self class]);
[self.selectTextfield becomeFirstResponder];
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
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - private methods
/**
 *  初始化视图
 */
- (void)initView
{
    self.view.backgroundColor                 = kDefaultVCBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self switchView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIWindowDidBecomeVisibleNotification
                                               object:nil];
}

/**
 *  隐藏键盘
 *
 *  @param Notification 通知对象
 */
- (void)keyboardWillShow:(NSNotification *)Notification

{
    [YYTextKeyboardManager defaultManager].keyboardWindow.alpha = 0;
}

/**
 *  输入框清除方法
 *
 *  @param textField 输入框
 *
 *  @return 输入框
 */
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField == _pointToHSBView.turnOutTf || textField == _pointToInvestView.turnOutTf)
    {
        self.pointToHSBView.turanOutValue = @"";
    }
    return YES;
}
/**
 *  点击外部区域输入框关系
 *
 *  @param touches 点击事件
 *  @param event   视图事件
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    self.selectTextfield = nil;
    
}
/**
 *  区分显示方法
 */
- (void)switchView
{
    switch (self.vcType)
    {
        case kPointTransformHSB: {
            [self.pointToInvestView removeFromSuperview];
            self.title = kLocalized(@"GYHS_Account_Point_Transform_HSB");
            [self.view
             addSubview:self.pointToHSBView];
            self.pointToHSBView.canUsePoints = [GYHSAccountCenter defaultCenter].canUsePoints;
            self.pointToHSBView.turanOutValue = self.pointToHSBView.turnOutTf.text;
            self.keyView.type                = kAccountKeyBoardTypePointToHSB;
            [self.pointToHSBView.turnOutTf becomeFirstResponder];
        } break;
        case kPointInvestment: {
            [self.pointToHSBView removeFromSuperview];
            self.title = kLocalized(@"GYHS_Account_Point_Investment");
            [self.view
             addSubview:self.pointToInvestView];

            self.pointToInvestView.canUsePoints = [GYHSAccountCenter defaultCenter].canUsePoints;
            self.keyView.type                   = kAccountKeyBoardTypePointToInvest;
            [self.pointToInvestView.turnOutTf becomeFirstResponder];
        } break;
    }
    self.clickOKBtn = self.keyView.clickOKBtn;
}

//#pragma mark - GYPadKeyboradViewDelegate

#pragma mark - GYHSKeyViewDelegate  键盘代理
/**
 *  添加数字
 *
 *  @param string 具体标准键盘的数字
 */
- (void)padKeyBoardViewDidClickNumberWithString:(NSString *)string;
{
    if (self.selectTextfield == nil)
    {
        [self.selectTextfield tipWithContent:kLocalized(@"GYHS_Account_Please_Select_Edit_Box") animated:YES];
        return;
    }

    else if (self.selectTextfield == _pointToHSBView.turnOutTf || self.selectTextfield == _pointToInvestView.turnOutTf)
    {
        self.selectTextfield.text         = [NSString stringWithFormat:@"%@%@", self.selectTextfield.text, string];
        self.selectTextfield.text         = [self.selectTextfield inputIntegerField];
        self.pointToHSBView.turanOutValue = _selectTextfield.text;
    }
    else if (self.selectTextfield == _pointToHSBView.passWordTf || self.selectTextfield == _pointToInvestView.passWordTf)
    {
        self.selectTextfield.text            = [NSString stringWithFormat:@"%@%@", self.selectTextfield.text, string];
        self.selectTextfield.text            = [self.selectTextfield subPassField];
        self.selectTextfield.secureTextEntry = YES; //输入框密码状态
    }
}
#pragma mark-----标记输入框将要开始的时候

/**
 *  //删除数字
 */
- (void)padKeyBoardViewDidClickDelete
{
    if (self.selectTextfield == nil)
    {
        [self.selectTextfield tipWithContent:kLocalized(@"GYHS_Account_Please_Select_Edit_Box") animated:YES];
        return;
    }
    if (self.selectTextfield.text.length > 0)
    {
        if (self.selectTextfield == _pointToHSBView.turnOutTf || self.selectTextfield == _pointToInvestView.turnOutTf)
        {
            self.selectTextfield.text = [self.selectTextfield.text
                                         substringToIndex:self.selectTextfield.text.length - 1];
            self.selectTextfield.text = [self.selectTextfield inputEditField];

            self.pointToHSBView.turanOutValue = _selectTextfield.text;
        }
        else if (self.selectTextfield == _pointToHSBView.passWordTf || self.selectTextfield == _pointToInvestView.passWordTf)
        {
            self.selectTextfield.text = [self.selectTextfield.text
                                         substringToIndex:self.selectTextfield.text.length - 1];
            self.selectTextfield.text = [self.selectTextfield subPassField]; //处理  点
        }
    }
}

#pragma mark-----根据tag值进行按钮判断
/**
 *  根据事件类型进行处理
 *
 *  @param event 事件类型
 */
- (void)padKeyBoardViewDidClickEvent:(kAccountKeyBoardButtonEvent)event
{
    switch (event)
    {
        case kAccountKeyBoardButtonEventSwitch: {
            self.vcType = self.vcType == kPointTransformHSB ? kPointInvestment : kPointTransformHSB;
            [self switchView];
        } break;
        case kAccountKeyBoardButtonEventShowDetail: {
            
            [self.view endEditing:YES];
            GYHSCompanyGeneralDetailCheckVC *checkVC = [[GYHSCompanyGeneralDetailCheckVC alloc] init];
            checkVC.checkType  = kListViewCheckFiveItems;
            checkVC.detailType = kPointDetailCheckType;
            [self.navigationController
             pushViewController:checkVC
                       animated:YES];
        } break;

        case kAccountKeyBoardButtonEventOK: {
#pragma mark-----在积分转互生币界面 点OK情况
            if (_vcType == kPointTransformHSB)
            {

                NSDecimalNumber *canUseOriginal = [NSDecimalNumber decimalNumberWithString:[GYHSAccountCenter defaultCenter].canUsePoints];
                NSDecimalNumber *inputUseOriginal;
                if (_pointToHSBView.turnOutTf.text && [_pointToHSBView.turnOutTf deleteFormString].length > 0)
                {
                    inputUseOriginal = [NSDecimalNumber decimalNumberWithString:[_pointToHSBView.turnOutTf deleteFormString]];
                }
                else
                {
                    inputUseOriginal = [NSDecimalNumber zero];
                }

                if (_pointToHSBView.turnOutTf.text.length == 0)
                {


                    [_pointToHSBView.turnOutTf tipWithContent:kLocalized(@"GYHS_Account_Please_Enter_The_Transfer_Volume") animated:YES];
                    [_pointToHSBView.turnOutTf becomeFirstResponder];
                    return;
                }
                if ([inputUseOriginal compare:canUseOriginal] == NSOrderedDescending)
                {


                    [_pointToHSBView.turnOutTf tipWithContent:kLocalized(@"GYHS_Account_Transfer_Account_Number_Can_Not_Be_Larger_Than_The_Remainder") animated:YES];
                    [_pointToHSBView.turnOutTf becomeFirstResponder];
                    return;
                }
                if ([inputUseOriginal compare:[NSDecimalNumber decimalNumberWithString:globalData.config.pointMin]] == NSOrderedAscending)
                {


                    [_pointToHSBView.turnOutTf tipWithContent:[kLocalized(@"GYHS_Account_Can_Not_Be_Less_Than") stringByAppendingString:[NSString stringWithFormat:@"%.0f", globalData.config.pointMin.doubleValue]] animated:YES];
                    [_pointToHSBView.turnOutTf becomeFirstResponder];
                    return;
                }
                if ([inputUseOriginal compare:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.0f", [_pointToHSBView.turnOutTf deleteFormString].doubleValue]]] != NSOrderedSame)
                {


                    [_pointToHSBView.turnOutTf tipWithContent:kLocalized(@"GYHS_Account_The_Number_Must_Be_An_Integer") animated:YES];
                    [_pointToHSBView.turnOutTf becomeFirstResponder];
                    return;
                }

                if (_pointToHSBView.passWordTf.text.length != 8)
                {


                    [_pointToHSBView.passWordTf tipWithContent:kLocalized(@"GYHS_Account_Please_Enter_The_Correct_Password_Length") animated:YES];
                    [_pointToHSBView.passWordTf becomeFirstResponder];
                    return;
                }
                
                [GYAlertShowDataWithOKButtonView alertWithMessage:kLocalized(@"OK")
                                                         topColor:TopColorBlue
                                                        canUseNum:[GYUtils formatCurrencyStyle:[[GYHSAccountCenter defaultCenter].canUsePoints doubleValue]]
                                                       turnOutNum:[GYUtils formatCurrencyStyle:inputUseOriginal.doubleValue]
                                                    changeCoinNum:[GYUtils formatCurrencyStyle:[inputUseOriginal decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:kTransRatio]].doubleValue ]
                                                     comfirmBlock:^{
                                                         [_clickOKBtn controlTimeOut];
                    [GYHSAccountHttpTool createPvToHsbWithAmount:[_pointToHSBView.turnOutTf deleteFormString]
                                                        passWord:_pointToHSBView.passWordTf.text
                                                         success:^(id responsObject) {

                        _pointToHSBView.turanOutValue = @"0.00";
                        _pointToHSBView.turnOutTf.text = nil;
                        _pointToHSBView.passWordTf.text = nil;
                        [[GYHSAccountCenter defaultCenter]updatePointAccount:^(id returnValue) {
                            _pointToHSBView.canUsePoints = [GYHSAccountCenter defaultCenter].canUsePoints;
                        }
                                                                     failure:^(NSError *error) {
                        }];
                                                             //弹窗
                                                             [GYAlertShowDataWithOKButtonView oneTipAlertWithComfirmTitle:kLocalized(@"GYHS_Account_Integral_To_Alternate_Currency_Success_Two") isBlueTopColor:YES comfirmBlock:^{
                                                                 //
                                                             }];
                    }
                                                         failure:^{

                        _pointToHSBView.passWordTf.text = nil;
                        [_pointToHSBView.passWordTf becomeFirstResponder];
                    }];
                }];
            }
            else
            {


                NSDecimalNumber *canUseOriginal = [NSDecimalNumber decimalNumberWithString:[GYHSAccountCenter defaultCenter].canUsePoints];
                NSDecimalNumber *inputUseOriginal;
                if (_pointToInvestView.turnOutTf.text && [_pointToInvestView.turnOutTf deleteFormString].length > 0)
                {
                    inputUseOriginal = [NSDecimalNumber decimalNumberWithString:[_pointToInvestView.turnOutTf deleteFormString]];
                }
                else
                {
                    inputUseOriginal = [NSDecimalNumber zero];
                }

                if (_pointToInvestView.turnOutTf.text.length == 0)
                {


                    [_pointToInvestView.turnOutTf tipWithContent:kLocalized(@"GYHS_Account_Please_Enter_The_Investment_Volume_Fraction") animated:YES];
                    [_pointToInvestView.turnOutTf becomeFirstResponder];
                    return;
                }
                if ([inputUseOriginal compare:canUseOriginal] == NSOrderedDescending)
                {


                    [_pointToInvestView.turnOutTf tipWithContent:kLocalized(@"GYHS_Account_Transfer_Account_Number_Can_Not_Be_Larger_Than_The_Remainder") animated:YES];
                    [_pointToInvestView.turnOutTf becomeFirstResponder];
                    return;
                }
                if ([inputUseOriginal compare:[NSDecimalNumber decimalNumberWithString:globalData.config.investPointMin]] == NSOrderedAscending)
                {


                    [_pointToInvestView.turnOutTf tipWithContent:[kLocalized(@"GYHS_Account_Can_Not_Be_Less_Than") stringByAppendingString:[NSString stringWithFormat:@"%.0f", globalData.config.investPointMin.doubleValue] ] animated:YES];
                    [_pointToInvestView.turnOutTf becomeFirstResponder];
                    return;
                }
                if ([inputUseOriginal compare:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.0f", [_pointToInvestView.turnOutTf deleteFormString].doubleValue]]] != NSOrderedSame)
                {


                    [_pointToInvestView.turnOutTf tipWithContent:kLocalized(@"GYHS_Account_The_Number_Must_Be_An_Integer") animated:YES];
                    [_pointToInvestView.turnOutTf becomeFirstResponder];
                    return;
                }

                else if (((long)inputUseOriginal.doubleValue % 100) != 0)
                {


                    [_pointToInvestView.turnOutTf tipWithContent:kLocalized(@"GYHS_Account_The_Number_Of_Turns_Out_To_Be_An_Integer_Multiple_Of_100") animated:YES];
                    [_pointToInvestView.turnOutTf becomeFirstResponder];
                    return;
                }

                if (_pointToInvestView.passWordTf.text.length != 8)
                {


                    [_pointToInvestView.passWordTf tipWithContent:kLocalized(@"GYHS_Account_Please_Enter_A_8_Transaction_Password") animated:YES];
                    [_pointToInvestView.passWordTf becomeFirstResponder];
                    return;
                }

                [GYAlertShowDataWithOKButtonView alertPointInvestment:kLocalized(@"GYHS_Account_Alternate_Currency_Exchange_Success")
                                                             topColor:TopColorBlue
                                                            canUseNum:[GYUtils formatCurrencyStyle:[[GYHSAccountCenter defaultCenter].canUsePoints doubleValue]]
                                                           turnOutNum:[GYUtils formatCurrencyStyle:inputUseOriginal.doubleValue]
                                                         comfirmBlock:^{
                                                             [_clickOKBtn controlTimeOut];
                    [GYHSAccountHttpTool createPointInvestWithInvestAmount:[_pointToInvestView.turnOutTf deleteFormString]
                                                                  passWord:_pointToInvestView.passWordTf.text
                                                                   success:^(id responsObject) {

                        _pointToInvestView.turnOutTf.text = nil;
                        _pointToInvestView.passWordTf.text = nil;
                        [[GYHSAccountCenter defaultCenter]updatePointAccount:^(id returnValue) {
                            _pointToInvestView.canUsePoints = [GYHSAccountCenter defaultCenter].canUsePoints;
                        }
                                                                     failure:^(NSError *error) {
                        }];
                                                                       [GYAlertShowDataWithOKButtonView oneTipAlertWithComfirmTitle:kLocalized(@"GYHS_Account_Integral_Investment_Application_Success") isBlueTopColor:YES comfirmBlock:^{
                                                                           //
                                                                       }];
                    }
                                                                   failure:^{

                        _pointToInvestView.passWordTf.text = nil;
                        [_pointToInvestView.passWordTf becomeFirstResponder];

                    }];
                }];
            }
        } break;
    }
}

#pragma mark - lazy load

- (GYHSAccountKeyBoard *)keyView
{
    if (!_keyView)
    {
        _keyView          = [[GYHSAccountKeyBoard alloc] init];
        _keyView.type     = kAccountKeyBoardTypePointToHSB;
        _keyView.delegate = self;
        [self.view
         addSubview:_keyView];
        @weakify(self);
        [_keyView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.bottom.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(kNavigationHeight);
            make.left.equalTo(self.view).offset(kDeviceProportion(469) + kLetfwidth);
        }];
    }
    self.clickOKBtn = _keyView.clickOKBtn;
    return _keyView;
}

- (GYHSPointTransformHSBView *)pointToHSBView
{
    if (!_pointToHSBView)
    {
        _pointToHSBView = [[GYHSPointTransformHSBView alloc] init];
        @weakify(self);
        _pointToHSBView.turnOutTf.bk_didBeginEditingBlock = ^(UITextField *textField) {
            @strongify(self);
            self.selectTextfield = textField;
            textField.delegate   = self;
        };
        _pointToHSBView.passWordTf.bk_didBeginEditingBlock = ^(UITextField *textField) {
            @strongify(self);
            self.selectTextfield = textField;
            textField.delegate   = self;
        };
        _pointToHSBView.turnOutTf.bk_shouldBeginEditingBlock = ^(UITextField *textField) {


            return YES;
        };

        _pointToHSBView.turnOutTf.bk_didEndEditingBlock = ^(UITextField *textField) {

        };
        _pointToHSBView.passWordTf.bk_didEndEditingBlock = ^(UITextField *textField) {

        };
    }

    return _pointToHSBView;
}

- (GYHSPointInvestView *)pointToInvestView
{
    if (!_pointToInvestView)
    {
        _pointToInvestView = [[GYHSPointInvestView alloc] init];
        @weakify(self);
        _pointToInvestView.turnOutTf.bk_didBeginEditingBlock = ^(UITextField *textField) {
            @strongify(self);
            self.selectTextfield = textField;
            textField.delegate   = self;
        };
        _pointToInvestView.passWordTf.bk_didBeginEditingBlock = ^(UITextField *textField) {
            @strongify(self);
            self.selectTextfield = textField;
            textField.delegate   = self;
        };
        _pointToInvestView.turnOutTf.bk_shouldBeginEditingBlock = ^(UITextField *textField) {


            return YES;
        };

        _pointToInvestView.turnOutTf.bk_didEndEditingBlock = ^(UITextField *textField) {

        };
        _pointToInvestView.passWordTf.bk_didEndEditingBlock = ^(UITextField *textField) {

        };
    }

    return _pointToInvestView;
}

@end
