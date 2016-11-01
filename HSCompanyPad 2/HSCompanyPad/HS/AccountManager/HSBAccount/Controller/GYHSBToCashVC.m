//
//  GYHSHSBAccountsToCoinVC.m
//
//  Created by 吴文超 on 16/8/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSBToCashVC.h"
#import "GYHSAccountUIFactory.h"
#import "GYPadKeyboradView.h"
#import "GYHSAccountKeyBoard.h"
#import "GYHSCompanyGeneralDetailCheckVC.h"
#import <GYKit/NSString+NSDecimalNumber.h>
#import "GYAlertShowDataWithOKButtonView.h"
#import "GYHSBToCashView.h"
#import "GYHSExchageHSBViewController.h"
#import <GYKit/UIView+Extension.h>
#import "UITextField+GYHSPointTextField.h"
#import "GYHSAccountHttpTool.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <BlocksKit/BlocksKit+UIKit.h>
#import <YYKit/YYTextKeyboardManager.h>
#import "UITextField+GYHSPointTextField.h"
#import "GYHSAccountCenter.h"
#import "GYHSCompanyHSBlDetailCheckVC.h"
#import <GYKit/UIButton+GYExtension.h>
#define kLetfwidth kDeviceProportion(20)
#define kInputViewWidth kDeviceProportion(429)
#define kNavigationHeight 44
#define kDistanceHeight kDeviceProportion(24)
#define kCommonHeight kDeviceProportion(45)
#define kConsumeWidth (kLetfwidth + kInputViewWidth)

@interface GYHSBToCashVC () <GYHSAccountKeyBoardDelegate, UITextFieldDelegate>

@property (nonatomic, strong) GYHSAccountKeyBoard *keyView;
@property (nonatomic, strong) GYHSBToCashView *hsbToCashView;
@property (nonatomic, strong) UITextField *selectTextfield;
@property (nonatomic, strong) UIButton *clickOKBtn;
@end

@implementation GYHSBToCashVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kLocalized(@"GYHS_Account_HSB_To_Cash");
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
    [YYTextKeyboardManager defaultManager].keyboardWindow.alpha = 0;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [YYTextKeyboardManager defaultManager].keyboardWindow.alpha = 1;
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - private methods
/**
 *  左右两边界面的搭建
 */
- (void)initView
{
    self.view.backgroundColor                 = kDefaultVCBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view
     addSubview:self.hsbToCashView];
    self.keyView.type         = kAccountKeyBoardTypeHSBToCash;
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIWindowDidBecomeVisibleNotification
                                               object:nil];
    self.hsbToCashView.ltbBalance = [GYHSAccountCenter defaultCenter].ltbBalance;
}

/**
 *  通知弹出键盘的方法
 *
 *  @param Notification 通知
 */
- (void)keyboardWillShow:(NSNotification *)Notification

{
    [YYTextKeyboardManager defaultManager].keyboardWindow.alpha = 0;
}

/**
 *  代理方法 输入框清除方法
 *
 *  @param textField 自身输入框
 *
 *  @return 返回布尔值
 */
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField == _hsbToCashView.turnOutTf)
    {
        textField.text                = nil;
        self.hsbToCashView.turnOutFee = @"0.00";
    }
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    self.selectTextfield = nil;
    
}
#pragma mark - private methods
#pragma mark - GYHSKeyViewDelegate  键盘代理
/**
 *  标准键盘添加数字
 *
 *  @param string 具体数字
 */
- (void)padKeyBoardViewDidClickNumberWithString:(NSString *)string;
{
    if (self.selectTextfield == nil)   //空的时候输入 有提示
    {
        [self.selectTextfield tipWithContent:kLocalized(@"GYHS_Account_Please_Select_Edit_Box") animated:YES];
        return;
    }

    else if (self.selectTextfield == _hsbToCashView.turnOutTf)   //输入转出数字
    {
        self.selectTextfield.text = [NSString stringWithFormat:@"%@%@", self.selectTextfield.text, string];
        self.selectTextfield.text = [self.selectTextfield inputIntegerField];

        self.hsbToCashView.turnOutFee = [[NSDecimalNumber decimalNumberWithString:[self.selectTextfield deleteFormString]] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:globalData.config.hsbToHbRate]].stringValue;
    }
    else if (self.selectTextfield == _hsbToCashView.passWordTf)   //输入密码
    {
        self.selectTextfield.text            = [NSString stringWithFormat:@"%@%@", self.selectTextfield.text, string];
        self.selectTextfield.text            = [self.selectTextfield subPassField];
        self.selectTextfield.secureTextEntry = YES; //输入框密码状态
    }
}

/**
 *  标准键盘删除数字
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
        if (self.selectTextfield == _hsbToCashView.turnOutTf)
        {
            self.selectTextfield.text = [self.selectTextfield.text
                                         substringToIndex:self.selectTextfield.text.length - 1];
            self.selectTextfield.text = [self.selectTextfield inputEditField];
            if (self.selectTextfield.text.length == 0)
            {
                self.hsbToCashView.turnOutFee = @"0.00";
            }
            else
            {
                self.hsbToCashView.turnOutFee = [[NSDecimalNumber decimalNumberWithString:[self.selectTextfield deleteFormString]] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:globalData.config.hsbToHbRate]].stringValue;
            }
        }
        else if (self.selectTextfield == _hsbToCashView.passWordTf)
        {
            self.selectTextfield.text = [self.selectTextfield.text
                                         substringToIndex:self.selectTextfield.text.length - 1];
            self.selectTextfield.text = [self.selectTextfield subPassField]; //处理  点  的问题
        }
    }
}

#pragma mark - GYHSKeyViewDelegate  键盘代理

#pragma mark-----根据tag值进行按钮判断
/**
 *  键盘点击根据事件类型来进行处理
 *
 *  @param event 事件类型
 */
- (void)padKeyBoardViewDidClickEvent:(kAccountKeyBoardButtonEvent)event
{
    switch (event)
    {
        case kAccountKeyBoardButtonEventShowDetail: {
            
            [self.view endEditing:YES];
            if (globalData.companyType != kCompanyType_Membercom)
            {
                GYHSCompanyHSBlDetailCheckVC *checkVC = [[GYHSCompanyHSBlDetailCheckVC alloc] init];

                [self.navigationController
                 pushViewController:checkVC
                           animated:YES];
            }
            else
            {
                GYHSCompanyGeneralDetailCheckVC *checkVC = [[GYHSCompanyGeneralDetailCheckVC alloc] init];
                checkVC.checkType  = kListViewCheckFiveItems;
                checkVC.detailType = kHsbDetailCheckType;
                [self.navigationController
                 pushViewController:checkVC
                           animated:YES];
            }
        } break;
        case kAccountKeyBoardButtonEventSwitch: {
            
            [self.view endEditing:YES];
            GYHSExchageHSBViewController *vc = [[GYHSExchageHSBViewController alloc] init];
            [self.navigationController
             pushViewController:vc
                       animated:YES];
        } break;

        case kAccountKeyBoardButtonEventOK: {


            NSDecimalNumber *canUseOriginal = [[NSDecimalNumber decimalNumberWithString:[GYHSAccountCenter defaultCenter].ltbBalance] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf", 300.0]]];

            NSDecimalNumber *inputUseOriginal;
            if (_hsbToCashView.turnOutTf.text && [_hsbToCashView.turnOutTf deleteFormString].length > 0)
            {
                inputUseOriginal = [NSDecimalNumber decimalNumberWithString:[_hsbToCashView.turnOutTf deleteFormString]];
            }
            else
            {
                inputUseOriginal = [NSDecimalNumber zero];
            }




            NSDecimalNumber *decHsbToHbRate = [NSDecimalNumber decimalNumberWithString:globalData.config.hsbToHbRate];
            NSDecimalNumber *fee            = [inputUseOriginal decimalNumberByMultiplyingBy:decHsbToHbRate];


            if (_hsbToCashView.turnOutTf.text.length == 0)
            {


                [_hsbToCashView.turnOutTf tipWithContent:kLocalized(@"GYHS_Account_Please_Enter_Transfer_Number_HSB") animated:YES];
                [_hsbToCashView.turnOutTf becomeFirstResponder];
                return;
            }

            if ([[inputUseOriginal decimalNumberByAdding:fee] compare:canUseOriginal] == NSOrderedDescending)
            {


                [_hsbToCashView.turnOutTf tipWithContent:kLocalized(@"GYHS_Account_Transfer_Account_Number_Can_Not_Be_Larger_Than_The_Remainder") animated:YES];
                [_hsbToCashView.turnOutTf becomeFirstResponder];
                return;
            }

            //如果转出数大于可用余数 交易错误 提示交易数不能大于可用余数//如果转出数小于零 也提示错误
            if ([inputUseOriginal compare:[NSDecimalNumber decimalNumberWithString:globalData.config.hsbToHbMin]] == NSOrderedAscending)
            {


                [_hsbToCashView.turnOutTf tipWithContent:[kLocalized(@"GYHS_Account_Can_Not_Be_Less_Than") stringByAppendingString:[NSString stringWithFormat:@"%.0f", globalData.config.hsbToHbMin.doubleValue]] animated:YES];
                [_hsbToCashView.turnOutTf becomeFirstResponder];
                return;
            }

            if ([inputUseOriginal compare:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.0f", [_hsbToCashView.turnOutTf deleteFormString].doubleValue]]] != NSOrderedSame)
            {


                [_hsbToCashView.turnOutTf tipWithContent:kLocalized(@"GYHS_Account_The_Number_Must_Be_An_Integer") animated:YES];
                [_hsbToCashView.turnOutTf becomeFirstResponder];
                return;
            }

            if (_hsbToCashView.passWordTf.text.length != 8)
            {


                [_hsbToCashView.passWordTf tipWithContent:kLocalized(@"GYHS_Account_Please_Enter_The_Correct_Password_Length") animated:YES];
                [_hsbToCashView.passWordTf becomeFirstResponder];
                return;
            }


            [GYAlertShowDataWithOKButtonView alertHSBToCoin:kLocalized(@"OK")
                                                   topColor:TopColorBlue
                                                  canUseNum:[GYUtils formatCurrencyStyle:canUseOriginal.doubleValue]
                                                   inputNum:[GYUtils formatCurrencyStyle:inputUseOriginal.doubleValue]
                                                     feeNum:[GYUtils formatCurrencyStyle:_hsbToCashView.turnOutFee.doubleValue]
                                                     addNum:[GYUtils formatCurrencyStyle:
                                                             [inputUseOriginal decimalNumberBySubtracting:[inputUseOriginal decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:globalData.config.hsbToHbRate]]].doubleValue]
                                               comfirmBlock:^{
                                                   
                                                   [_clickOKBtn controlTimeOut];
                [GYHSAccountHttpTool hsbToCashWithFromHsbAmt:[_hsbToCashView.turnOutTf deleteFormString]
                                                   toCashAmt:_hsbToCashView.turnOutFee
                                                    password:_hsbToCashView.passWordTf.text
                                                     success:^(id responsObject) {

                    _hsbToCashView.turnOutTf.text = nil;
                    _hsbToCashView.turnOutFee = @"0.00";
                    _hsbToCashView.passWordTf.text = nil;
                    [[GYHSAccountCenter defaultCenter]updateHsbAccount:^(id returnValue) {
                        _hsbToCashView.ltbBalance = [GYHSAccountCenter defaultCenter].ltbBalance;
                    }
                                                               failure:^(NSError *error) {
                    }];
                                                         [GYAlertShowDataWithOKButtonView oneTipAlertWithComfirmTitle:kLocalized(@"GYHS_Account_Alternate_Currency_Turn_Monetary_Success") isBlueTopColor:YES comfirmBlock:^{
                                                             //
                                                         }];
                }
                                                     failure:^{

                    _hsbToCashView.passWordTf.text = nil;

                    [_hsbToCashView.passWordTf becomeFirstResponder];
                }];
            }];
        }

        break;
    }
}

#pragma mark - event

#pragma mark - request
#pragma mark - lazy load

- (GYHSAccountKeyBoard *)keyView
{
    if (!_keyView)
    {
        _keyView          = [[GYHSAccountKeyBoard alloc] init];
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
        self.clickOKBtn = _keyView.clickOKBtn;
    }

    return _keyView;
}

- (GYHSBToCashView *)hsbToCashView
{
    if (!_hsbToCashView)
    {
        _hsbToCashView = [[GYHSBToCashView alloc] init];

        @weakify(self);
        _hsbToCashView.turnOutTf.bk_didBeginEditingBlock = ^(UITextField *textField) {
            @strongify(self);
            self.selectTextfield = textField;
            textField.delegate   = self;
        };
        _hsbToCashView.passWordTf.bk_didBeginEditingBlock = ^(UITextField *textField) {
            @strongify(self);
            self.selectTextfield = textField;
            textField.delegate   = self;
        };
        _hsbToCashView.turnOutTf.bk_shouldBeginEditingBlock = ^(UITextField *textField) {


            return YES;
        };


        _hsbToCashView.turnOutTf.bk_didEndEditingBlock = ^(UITextField *textField) {

        };
        _hsbToCashView.passWordTf.bk_didEndEditingBlock = ^(UITextField *textField) {

        };
        [_hsbToCashView.turnOutTf becomeFirstResponder];
    }
    return _hsbToCashView;
}

@end
