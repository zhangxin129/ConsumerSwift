//
//  GYHSResetPasswordVC.m
//
//  Created by apple on 16/8/10.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//
/**
 *  重置登录密码操作
 */
#import "GYHSResetPasswordVC.h"
#import "UILabel+Category.h"
#import "GYHSStaffHttpTool.h"



@interface GYHSResetPasswordVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UITextField *userNameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *passwordConfirmTextField;
@property (nonatomic, strong) UITextField *nameTextField;

@end

@implementation GYHSResetPasswordVC

#pragma mark - lazy load

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
    self.title = kLocalized(@"GYHS_StaffManager_ResetLoginPWD");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    DDLogInfo(@"Load Controller: %@", [self class]);
    
    [self createMainView];
    [self createFooterView];
}
/**
 *  创建视图
 */
- (void)createMainView{
    
    _mainView = [[UIView alloc] init];
    _mainView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainView];
    [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(44);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.equalTo(@(kDeviceProportion(kScreenWidth)));
        make.height.equalTo(@(kDeviceProportion(kScreenHeight  - 44 -70)));
    }];
    
    float lableW = 113;
    float textFieldW = 505;
    float spaceW = (kScreenWidth - lableW - textFieldW) / 2;
    
    NSArray *titleArr = @[kLocalized(@"GYHS_StaffManager_LoginUsername:"),kLocalized(@"GYHS_StaffManager_EmployeeName:"),kLocalized(@"GYHS_StaffManager_NewPassword"),kLocalized(@"GYHS_StaffManager_ConfirmNewPassword")];
    for (int i = 0; i < titleArr.count; i++) {
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(spaceW, 21 + i * 40 + i * 20, lableW, 30)];
        titleLab.text = titleArr[i];
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.textColor = kGray333333;
        titleLab.font = kFont32;
        [_mainView addSubview:titleLab];
    }
    
    for (int i = 0; i < titleArr.count; i ++) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(lableW + spaceW, 16 + i * 40 + i * 20, textFieldW, 40)];
        textField.layer.borderColor = kGrayCCCCCC.CGColor;
        textField.layer.borderWidth = 1.0f;
        textField.delegate = self;
        textField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView* passWordLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(10), kDeviceProportion(40))];
        textField.leftView = passWordLeftView;
        textField.tag = i;
        [_mainView addSubview:textField];
        
        if (textField.tag == 0) {
            self.userNameTextField = textField;
            self.userNameTextField.text = _userNameStr;
            self.userNameTextField.enabled = NO;
            self.userNameTextField.backgroundColor = kGreenF5F5F5;
        }else if (textField.tag == 1){
            self.nameTextField = textField;
            self.nameTextField.text = _realNameStr;
            self.nameTextField.enabled = NO;
            self.nameTextField.backgroundColor = kGreenF5F5F5;
        }else if (textField.tag == 2){
            self.passwordTextField = textField;
            self.passwordTextField.secureTextEntry = YES;
            self.passwordTextField.keyboardType = UIKeyboardTypePhonePad;
        }else if (textField.tag == 3){
            self.passwordConfirmTextField = textField;
            self.passwordConfirmTextField.secureTextEntry = YES;
            self.passwordConfirmTextField.keyboardType = UIKeyboardTypePhonePad;
        }
    }
    
}
/**
 * 创建底部按钮视图
 */
- (void)createFooterView{
    _footerView = [[UIView alloc] init];
    _footerView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.16];
    [self.view addSubview:_footerView];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kScreenHeight  - 62 - 70 - 20);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.equalTo(@(kDeviceProportion(kScreenWidth)));
        make.height.equalTo(@(kDeviceProportion(70)));
    }];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.backgroundColor = kRedE50012;
    confirmButton.layer.cornerRadius = 6;
    [confirmButton setTitleColor:kWhiteFFFFFF forState:UIControlStateNormal];
    [confirmButton setTitle:kLocalized(@"GYHS_StaffManager_Confirm") forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(restPwd) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_footerView.mas_top).offset((70 - 33) / 2);
        make.left.equalTo(_footerView.mas_left).offset((kScreenWidth - 120) / 2);
        make.width.equalTo(@(kDeviceProportion(120)));
        make.height.equalTo(@(kDeviceProportion(33)));
    }];
}
/**
 *  发起网络请求
 */
-(void)restPwd{
    [self requestRestPwd];
}

-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma  mark - UITextFieldDelegate
/**
 *  当输入框开始编辑时，改变输入框边框颜色
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (self.passwordTextField.isEditing) {
        self.passwordTextField.layer.borderColor = kBlue64A9FD.CGColor;
        self.passwordConfirmTextField.layer.borderColor = kGrayCCCCCC.CGColor;
    }else if (self.passwordConfirmTextField.isEditing) {
        self.passwordTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.passwordConfirmTextField.layer.borderColor = kBlue64A9FD.CGColor;
    }
}
#pragma mark UITextFieldDelegate
/**
 *  限制输入框的位数
 */
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString* toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    unsigned long len = toBeString.length;
    if (len > 6) {
        [textField resignFirstResponder];
        return NO;
    }

        return YES;
}


#pragma mark - request
/**
 *  重置登录密码操作的网络请求
 */
- (void)requestRestPwd{
    
    if (self.passwordTextField.text.length == 0) {
        [self.passwordTextField tipWithContent:kLocalized(@"GYHS_StaffManager_PleaseEnterNewPassword") animated:YES];
        return;
    }else{
        if (self.passwordTextField.text.length != 6) {
            [self.passwordTextField tipWithContent:kLocalized(@"GYHS_StaffManager_TheLoginPasswordMustBe 6 Digits") animated:YES];
            return;
        }
        if (![self.passwordTextField.text isValidNumber]) {
            [self.passwordTextField tipWithContent:kLocalized(@"GYHS_StaffManager_LoginPasswordCanBeOnlyPureDigital") animated:YES];
            return;
        }
        if ([self.passwordTextField.text isSimpleLoginPwd] == NSOrderedStringSame) {
            [self.passwordTextField tipWithContent:kLocalized(@"GYHS_StaffManager_DoNotSetTheSamePasswordNumber,PleaseReset") animated:YES];
            return;
        }
        if ([self.passwordTextField.text isSimpleLoginPwd] == NSOrderedStringAscending || [self.passwordTextField.text isSimpleLoginPwd] == NSOrderedStringDescending) {
            [self.passwordTextField tipWithContent:kLocalized(@"GYHS_StaffManager_DoNotSetPasswordDigitalContinuousLiftingArrangement,PleaseReset") animated:YES];
            return;
        }

    
    }
        
        
    if (self.passwordConfirmTextField.text.length == 0) {
        [self.passwordConfirmTextField tipWithContent:kLocalized(@"GYHS_StaffManager_PleaseEnterNewPasswordAgain") animated:YES];
        return;
    }else{
        if (self.passwordConfirmTextField.text.length != 6) {
            [self.passwordConfirmTextField tipWithContent:kLocalized(@"GYHS_StaffManager_TheLoginPasswordMustBe 6 Digits") animated:YES];
            return;
        }
        
        if (![self.passwordConfirmTextField.text isValidNumber]) {
            [self.passwordConfirmTextField tipWithContent:kLocalized(@"GYHS_StaffManager_LoginPasswordCanBeOnlyPureDigital") animated:YES];
            return;
        }
    
    }
    
    if (![self.passwordTextField.text isEqualToString:self.passwordConfirmTextField.text]){
        [self.passwordConfirmTextField tipWithContent:kLocalized(@"GYHS_StaffManager_TwoTimesEnterPasswordsDoNotMatch,PleaseEnterAgain") animated:YES];
        return;
    }
    
    [GYHSStaffHttpTool resetLoginPasswordNewLoginPwd:_passwordTextField.text operCustId:kSaftToNSString(self.oprCustIdStr) userName:_userNameStr success:^(id responsObject) {
        [GYUtils showToast:kLocalized(@"GYHS_StaffManager_ResetSuccess")];
        [self performSelector:@selector(pop) withObject:nil afterDelay:3.0f];
    } failure:^{
        
    }];
    
}

#pragma mark - 键盘收起
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self.view endEditing:YES];
}

@end
