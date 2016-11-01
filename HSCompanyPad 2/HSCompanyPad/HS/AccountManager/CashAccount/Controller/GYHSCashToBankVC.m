//
//  GYHSCompanyCoinAccountsToBankVC.m
//
//  Created by 吴文超 on 16/8/5.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSCashToBankVC.h"
#import "GYHSAccountUIFactory.h"
#import "GYPadKeyboradView.h"
#import "GYHSAccountKeyBoard.h"
#import <GYKit/UIView+Extension.h>
#import "UITextField+GYHSPointTextField.h"
#import "GYHSCompanyGeneralDetailCheckVC.h"
#import <GYKit/NSString+NSDecimalNumber.h>
#import "GYAlertShowDataWithOKButtonView.h"
#import <GYKit/UIButton+GYExtension.h>
#import "GYHSCashToBankView.h"
#import "GYHSAccountHttpTool.h"
#import "GYHSBankCardCityModel.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "GYHSAccountCenter.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <YYKit/YYTextKeyboardManager.h>
#import "GYHSAccountCenter.h"
#import "GYHSBankAccountMainVC.h"
#import "GYHSBankListModel.h"
#import <MJExtension/MJExtension.h>
#define kLeftWidth kDeviceProportion(20)
#define kInputViewWidth kDeviceProportion(429)
#define kNavigationHeight 44
#define kDistanceHeight kDeviceProportion(24)
#define kCommonHeight kDeviceProportion(45)
#define kConsumeWidth (kLeftWidth + kInputViewWidth)

@interface GYHSCashToBankVC () <GYHSAccountKeyBoardDelegate, UITextFieldDelegate, GYHSCashToBankViewDelegate, GYHSSelectBankAccountDelegate>

@property (nonatomic, strong) GYHSAccountKeyBoard* keyView;
@property (nonatomic, strong) GYHSCashToBankView* leftView;
@property (nonatomic, strong) UITextField* selectTextfield;

@property (nonatomic, strong) GYHSBankListModel* defaultModel;
@property (nonatomic, copy) NSString* getBankTransFee; //货币转银行手续费
@property (nonatomic, strong) GYHSCashToBankView* noCardView;
@property (nonatomic, strong) UIButton* clickOKBtn;
@end

@implementation GYHSCashToBankVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kLocalized(@"GYHS_Account_CashToBank");
    @weakify(self);
    [self loadInitViewType:GYStopTypeLogout :^{
        @strongify(self);
        [self initView];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    [YYTextKeyboardManager defaultManager].keyboardWindow.alpha = 1;
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// #pragma mark - SystemDelegate
// #pragma mark TableView Delegate
// #pragma mark - CustomDelegate
/**
 *  货币转银行点击添加银行账户的代理
 *
 *  @param cashView 左边视图
 */
- (void)cashToBankViewDidClickSelectedBankAccount:(GYHSCashToBankView*)cashView
{
    if (_noCardView) {
        self.selectTextfield = _noCardView.originTurnOutTf;
    }
    else if (_leftView) {
        self.selectTextfield = _leftView.turnOutTf;
    }
    [self.view endEditing:YES];
    GYHSBankAccountMainVC* accountVC = [[GYHSBankAccountMainVC alloc] init];
    [self.navigationController
     pushViewController:accountVC
     animated:YES];
    accountVC.delegate = self;
}

/**
 *  从银行界面选中返回的代理方法
 *
 *  @param model 银行信息
 */
- (void)selectBankAccountWithModel:(GYHSBankListModel*)model
{
    //这里需要对两种界面进行处理 如果前面界面是 nocard 那么删掉重新换leftView
    
    if (!self.defaultModel) {
        NSString* str = _noCardView.originTurnOutTf.text;
        [_noCardView removeFromSuperview];
        _noCardView = nil;
        [self.view
         addSubview:self.leftView];
        @weakify(self);
        [self.leftView mas_makeConstraints:^(MASConstraintMaker* make) {
            @strongify(self);
            
            make.top.equalTo(self.view).offset(kNavigationHeight);
            make.left.bottom.equalTo(self.view);
            make.width.equalTo(@(kDeviceProportion(469)));
        }];
        self.leftView.turnOutTf.text = str;
        [self.leftView.turnOutTf becomeFirstResponder];
        self.leftView.cashBalance = [GYHSAccountCenter defaultCenter].cashBanlance;
    }
    
    self.defaultModel = model;
    self.leftView.model = model;
}

/**
 *  从银行界面删除返回的代理方法
 *
 *  @param Notification 返回通知
 */
- (void)deleteBankCard:(NSNotification*)Notification
{
    GYHSBankListModel* model = Notification.object;
    
    //这里判断下 如果删除银行账户 和 默认的 银行账户一致的时候 需要清空左边
    if ([model.accId
         isEqualToString:self.defaultModel.accId]) {
        NSString* str = self.leftView.turnOutTf.text;
        [self.leftView removeFromSuperview];
        [self.view
         addSubview:self.noCardView];
        @weakify(self);
        [self.noCardView mas_makeConstraints:^(MASConstraintMaker* make) {
            @strongify(self);
            
            make.top.equalTo(self.view).offset(kNavigationHeight);
            make.left.bottom.equalTo(self.view);
            make.width.equalTo(@(kDeviceProportion(469)));
        }];
        self.noCardView.originTurnOutTf.text = str;
        [self.noCardView.originTurnOutTf becomeFirstResponder];
        self.noCardView.cashBalance = [GYHSAccountCenter defaultCenter].cashBanlance; //
        self.defaultModel = nil;
    }
}

// #pragma mark - event response

#pragma mark - private methods
/**
 *  初始化视图
 */
- (void)initView
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIWindowDidBecomeVisibleNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteBankCard:)
                                                 name:GYDeleteBankCardSNotification
                                               object:nil];
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view
     addSubview:self.keyView];
    @weakify(self);
    [_keyView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavigationHeight);
        make.left.equalTo(self.view).offset(kDeviceProportion(469) + kLeftWidth);
    }];
    
    [self getDefaultBankCard];
}

/**
 *  隐藏键盘
 *
 *  @param Notification 得到通知
 */
- (void)keyboardWillShow:(NSNotification*)Notification

{
    [YYTextKeyboardManager defaultManager].keyboardWindow.alpha = 0;
}

- (BOOL)textFieldShouldBeginEditing:(GYTextField*)textField
{
    if (textField == _leftView.turnOutTf || textField == _noCardView.originTurnOutTf) {
        
        [YYTextKeyboardManager defaultManager].keyboardWindow.alpha = 0;
    }
    return YES;
}
/**
 *  外部点击的代理方法
 *
 *  @param touches 点击
 *  @param event   事件类型
 */
- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
    [self.view endEditing:YES];
    self.selectTextfield = nil;
}
/**
 *  按照格式的银行卡号
 *
 *  @param cardNo 输入号码
 *
 *  @return 返回空格符的银行卡号
 */
- (NSString*)formatBankCardNo:(NSString*)cardNo
{
    
    NSString* formatCardNo;
    for (int i = 0; i <= cardNo.length / 4; i++) {
        if (i == cardNo.length / 4) {
            NSString* cardNoEnd = [cardNo substringWithRange:NSMakeRange(0 + 4 * i, cardNo.length - i * 4)];
            formatCardNo = [NSString stringWithFormat:@"%@ %@", formatCardNo, cardNoEnd];
        }
        else {
            NSString* cardNoGap = [cardNo substringWithRange:NSMakeRange(0 + 4 * i, 4)];
            formatCardNo = !formatCardNo ? [NSString stringWithFormat:@"%@", cardNoGap] : [NSString stringWithFormat:@"%@ %@", formatCardNo, cardNoGap];
        }
    }
    
    return formatCardNo;
}

#pragma mark - GYHSKeyViewDelegate  键盘代理
/**
 *  从数字键盘得到数字
 *
 *  @param string 具体字符
 */
- (void)padKeyBoardViewDidClickNumberWithString:(NSString*)string;
{
    if (self.selectTextfield == nil) //空的时候输入 有提示
    {
        [self.selectTextfield tipWithContent:kLocalized(@"GYHS_Account_Please_Select_Edit_Box") animated:YES];
        return;
    }
    
    else if (self.selectTextfield == _leftView.turnOutTf || self.selectTextfield == _noCardView.originTurnOutTf) //输入转出数字
    {
        self.selectTextfield.text = [NSString stringWithFormat:@"%@%@", self.selectTextfield.text, string];
        self.selectTextfield.text = [self.selectTextfield inputIntegerField];
    }
    else if (self.selectTextfield == _leftView.passWordTf) //输入密码
    {
        self.selectTextfield.text = [NSString stringWithFormat:@"%@%@", self.selectTextfield.text, string];
        self.selectTextfield.text = [self.selectTextfield subPassField];
        self.selectTextfield.secureTextEntry = YES; //输入框密码状态
    }
}

/**
 *  从数字键盘点击删除键
 */
- (void)padKeyBoardViewDidClickDelete
{
    if (self.selectTextfield == nil) {
        [self.selectTextfield tipWithContent:kLocalized(@"GYHS_Account_Please_Select_Edit_Box") animated:YES];
        return;
    }
    if (self.selectTextfield.text.length > 0) {
        if (self.selectTextfield == _leftView.turnOutTf || self.selectTextfield == _noCardView.originTurnOutTf) {
            self.selectTextfield.text = [self.selectTextfield.text
                                         substringToIndex:self.selectTextfield.text.length - 1];
            self.selectTextfield.text = [self.selectTextfield inputEditField];
        }
        else if (self.selectTextfield == _leftView.passWordTf) {
            self.selectTextfield.text = [self.selectTextfield.text
                                         substringToIndex:self.selectTextfield.text.length - 1];
            self.selectTextfield.text = [self.selectTextfield subPassField]; //处理  点  的问题
        }
    }
}

#pragma mark - 根据tag值进行按钮判断
/**
 *  键盘事件的点击处理
 *
 *  @param event 事件类型
 */
- (void)padKeyBoardViewDidClickEvent:(kAccountKeyBoardButtonEvent)event
{
    switch (event) {
        case kAccountKeyBoardButtonEventShowDetail: {
            
            [self.view endEditing:YES];
            GYHSCompanyGeneralDetailCheckVC* checkVC = [[GYHSCompanyGeneralDetailCheckVC alloc] init];
            checkVC.checkType = kListViewCheckFiveItems;
            checkVC.detailType = kCashDetailCheckType;
            [self.navigationController
             pushViewController:checkVC
             animated:YES];
        } break;
        case kAccountKeyBoardButtonEventOK: {
            
            NSDecimalNumber* canUseOriginal = [NSDecimalNumber decimalNumberWithString:[GYHSAccountCenter defaultCenter].cashBanlance];
            
            NSDecimalNumber* inputUseOriginal;
            if (_leftView.turnOutTf.text && [_leftView.turnOutTf deleteFormString].length > 0) {
                inputUseOriginal = [NSDecimalNumber decimalNumberWithString:[_leftView.turnOutTf deleteFormString]];
            }
            else {
                inputUseOriginal = [NSDecimalNumber zero];
            }
            
            NSDecimalNumber* hbToBankMax = [NSDecimalNumber decimalNumberWithString:globalData.config.hbToBankMax];
            
            //如果转出数大于可用余数 交易错误 提示交易数不能大于可用余数//如果转出数小于零 也提示错误
            if (self.defaultModel == nil) {
                [GYUtils showToast:kLocalized(@"GYHS_Account_Please_Choose_Transfer_Account")];
                
                return;
            }
            if (_leftView.turnOutTf.text.length == 0) {
                
                [_leftView.turnOutTf tipWithContent:kLocalized(@"GYHS_Account_Please_Enter_The_Transfer_Amount") animated:YES];
                return;
            }
            if ([inputUseOriginal compare:hbToBankMax] == NSOrderedDescending) {
                
                [_leftView.turnOutTf tipWithContent:kLocalized(@"GYHS_Account_Can_Not_Be_Greater_Than_The_Maximum_Limit") animated:YES];
                [_leftView.turnOutTf becomeFirstResponder];
                return;
            }
 NSDecimalNumber *hbToBankMin = [NSDecimalNumber decimalNumberWithString:globalData.config.hbToBankMin];
            if ([inputUseOriginal compare:hbToBankMin] == NSOrderedAscending)
            {
                
                [_leftView.turnOutTf tipWithContent:[kLocalized(@"GYHS_Account_Can_Not_Be_Less_Than") stringByAppendingString:[NSString stringWithFormat:kLocalized(@"%.0f"), globalData.config.hbToBankMin.doubleValue]] animated:YES];
                [_leftView.turnOutTf becomeFirstResponder];
                return;
            }
            
            if (_leftView.passWordTf.text.length != 8)
            {

                [_leftView.passWordTf tipWithContent:kLocalized(@"GYHS_Account_Please_Enter_The_Correct_Password_Length") animated:YES];
                [_leftView.passWordTf becomeFirstResponder];
                return;
            }
            
            @weakify(self);
            [GYHSAccountHttpTool getBankTransFeeWithTransAmount:[NSString stringWithFormat:@"%@", inputUseOriginal]
                                                  inAccBankCode:self.defaultModel.bankCode
                                                  inAccCityCode:self.defaultModel.cityCode
                                                        success:^(id responsObject) {
                @strongify(self);
                self.getBankTransFee = responsObject;
               
                NSDecimalNumber *cashToBankTotalFee;
                if (!self.getBankTransFee)
                {
                    cashToBankTotalFee = [NSDecimalNumber zero];
                }
                else
                {
                    cashToBankTotalFee = [NSDecimalNumber decimalNumberWithString:self.getBankTransFee];//假定手续费按4.00
                }


                
                if ([inputUseOriginal compare:canUseOriginal] == NSOrderedDescending)
                {

                    [_leftView.turnOutTf tipWithContent:kLocalized(@"GYHS_Account_Transfer_Account_Number_Can_Not_Be_Larger_Than_The_Remainder") animated:YES];
                    [_leftView.turnOutTf becomeFirstResponder];
                    return;
                }
                
                                                            if(!self.defaultModel.openArea){
                                                            [self.defaultModel getLocation:^(NSString *local) {
                                                                //
                                                            }];
                                                            }
                [GYAlertShowDataWithOKButtonView alertCoinToBank:@""
                                                        topColor:TopColorBlue
                                                       canUseNum:[GYUtils formatCurrencyStyle:[[GYHSAccountCenter defaultCenter].cashBanlance doubleValue]]
                                                        cardName:_defaultModel.bankName
                                                         cardNum:[self formatBankCardNo:_defaultModel.bankAccNo]
                                                      turnOutNum:[GYUtils formatCurrencyStyle:[[_leftView.turnOutTf deleteFormString] doubleValue]]
                                                         turnFee:[GYUtils formatCurrencyStyle:[self.getBankTransFee doubleValue]]
                                                  isValidAccount:self.defaultModel.isValidAccount
                                                     bankAccName:self.defaultModel.bankAccName
                                                        cityName:self.defaultModel.openArea
                                                    comfirmBlock:^{
                    @strongify(self);
                                                        [self.clickOKBtn controlTimeOut];
                    [GYHSAccountHttpTool saveTransOutWithBankProvinceNo:self.defaultModel.provinceCode
                                                            transReason:@"dd"
                                                                 bankNo:self.defaultModel.bankCode
                                                             bankAcctNo:self.defaultModel.bankAccNo
                                                             bankCityNo:self.defaultModel.cityCode
                                                               isVerify:self.defaultModel.isValidAccount
                                                               transPwd:_leftView.passWordTf.text
                                                                 amount:[_leftView.turnOutTf deleteFormString]
                                                           bankAcctName:self.defaultModel.bankAccName
                                                               reqOptId:globalData.loginModel.custId
                                                             bankBranch:self.defaultModel.bankBranch
                                                                  accId:self.defaultModel.accId
                                                                 feeAmt:self.getBankTransFee
                                                                success:^(id responsObject) {

                        _leftView.turnOutTf.text = nil;
                        _leftView.passWordTf.text = nil;
                        [[GYHSAccountCenter defaultCenter]updateCashAccount:^(id returnValue) {
                            @strongify(self);
                            self.leftView.cashBalance = [GYHSAccountCenter defaultCenter].cashBanlance;
                        }
                                                                    failure:^(NSError *error) {
                        }];
                                                                    [GYAlertShowDataWithOKButtonView oneTipAlertWithComfirmTitle:kLocalized(@"GYHS_Account_Money_Transfer_To_The_Bank") isBlueTopColor:YES comfirmBlock:^{
                                                                        //
                                                                    }];
                    }
                                                                failure:^{

                        _leftView.passWordTf.text = nil;
                        [_leftView.passWordTf becomeFirstResponder];
                    }];
                }];
            }
                                                        failure:^{
                                                        }];
        } break;
        default:
            break;
    }
}

#pragma mark - 网络请求方法
/**
 *  得到默认银行卡
 */
- (void)getDefaultBankCard
{
    @weakify(self);
    [GYHSAccountHttpTool getListBindBank:^(id responsObject) {
        NSArray *bankListArr = responsObject;
        if (bankListArr.count > 0)
        {
            for (NSDictionary *dict in responsObject)
            {
                GYHSBankListModel *model = [GYHSBankListModel mj_objectWithKeyValues:dict];
                if ([model.isDefault
                     isEqualToString:@"1"])
                {//有默认银行卡 那么就加载左边的带银行卡的视图
                    [self.view
                     addSubview:self.leftView];
                    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
                        @strongify(self);
                        
                        make.top.equalTo(self.view).offset(kNavigationHeight);
                        make.left.bottom.equalTo(self.view);
                        make.width.equalTo(@(kDeviceProportion(469)));
                    }];
                    
                    self.leftView.cashBalance = [GYHSAccountCenter defaultCenter].cashBanlance; //
                    
                    self.defaultModel = model;
                    self.leftView.model = model;
                    return;
                }
            }
        }
        if (!self.defaultModel)      //假如为空的时候如何处理
        {
            [self.view
             addSubview:self.noCardView];
            [self.noCardView mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                
                make.top.equalTo(self.view).offset(kNavigationHeight);
                make.left.bottom.equalTo(self.view);
                make.width.equalTo(@(kDeviceProportion(469)));
            }];
            
            self.noCardView.cashBalance = [GYHSAccountCenter defaultCenter].cashBanlance;     //
            
        }
    }
                                 failure:^{
                                 }];
}

#pragma mark - lazy load

- (GYHSAccountKeyBoard*)keyView
{
    if (!_keyView) {
        _keyView = [[GYHSAccountKeyBoard alloc] init];
        _keyView.type = kAccountKeyBoardTypeCashToBank;
        _keyView.delegate = self;
        self.clickOKBtn = _keyView.clickOKBtn;
    }
    
    return _keyView;
}

- (GYHSCashToBankView*)leftView
{
    if (!_leftView) {
        _leftView = [[GYHSCashToBankView alloc] init];
        [_leftView initCommanView];
        _leftView.delegate = self;
        _leftView.turnOutTf.delegate = self;
        _leftView.turnOutTf.inputView = [[UIView alloc] initWithFrame:CGRectZero];
        @weakify(self);
        _leftView.turnOutTf.bk_didBeginEditingBlock = ^(UITextField* textField) {
            @strongify(self);
            self.selectTextfield = textField;
        };
        _leftView.passWordTf.bk_didBeginEditingBlock = ^(UITextField* textField) {
            @strongify(self);
            self.selectTextfield = textField;
        };
        _leftView.turnOutTf.bk_shouldBeginEditingBlock = ^(UITextField* textField) {
            
            return YES;
        };
        
        _leftView.turnOutTf.bk_didEndEditingBlock = ^(UITextField* textField) {
            
        };
        _leftView.passWordTf.bk_didEndEditingBlock = ^(UITextField* textField) {
            
        };
        [_leftView.turnOutTf becomeFirstResponder];
        _selectTextfield = _leftView.turnOutTf;
    }
    
    return _leftView;
}

- (GYHSCashToBankView*)noCardView
{
    if (!_noCardView) {
        _noCardView = [[GYHSCashToBankView alloc] init];
        [_noCardView initNoCardView];
        _noCardView.delegate = self;
        _noCardView.originTurnOutTf.delegate  = self;
        _noCardView.originTurnOutTf.inputView = [[UIView alloc] initWithFrame:CGRectZero];
        @weakify(self);
        _noCardView.originTurnOutTf.bk_didBeginEditingBlock = ^(UITextField *textField) {
            @strongify(self);
            self.selectTextfield = textField;
        };
        
        _noCardView.originTurnOutTf.bk_shouldBeginEditingBlock = ^(UITextField *textField) {
            return YES;
        };
        
        _noCardView.originTurnOutTf.bk_didEndEditingBlock = ^(UITextField *textField) {
            
        };
        [_noCardView.originTurnOutTf becomeFirstResponder];
        _selectTextfield = _noCardView.originTurnOutTf;
    }
    
    return _noCardView;
}



@end
