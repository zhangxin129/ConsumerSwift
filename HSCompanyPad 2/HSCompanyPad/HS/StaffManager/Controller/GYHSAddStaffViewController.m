//
//  GYHSAddStaffViewController.m
//  HSCompanyPad
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSAddStaffViewController.h"
#import <GYKit/GYPlaceholderTextView.h>
#import "UILabel+Category.h"
#import "GYHSStaffHttpTool.h"
#import "GYUtils+companyPad.h"
/**
 *  新增员工
 */
@interface GYHSAddStaffViewController ()<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *staButton;
@property (nonatomic, strong) UIButton *stoButton;
@property (nonatomic, strong) UITextField *userNameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *passwordConfirmTextField;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *postTextField;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, copy) NSString *stateStr;
@property (nonatomic, strong) GYPlaceholderTextView *desTextView;

@end

@implementation GYHSAddStaffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    NSArray *titleArr = @[kLocalized(@"GYHS_StaffManager_LoginUsername:"),kLocalized(@"GYHS_StaffManager_LoginPassword:"),kLocalized(@"GYHS_StaffManager_ConfirmLoginPassword:"),kLocalized(@"GYHS_StaffManager_EmployeeName:"),kLocalized(@"GYHS_StaffManager_Post:"),kLocalized(@"GYHS_StaffManager_PhoneNumber:"),kLocalized(@"GYHS_StaffManager_State:"),kLocalized(@"GYHS_StaffManager_description:")];
    for (int i = 0; i < titleArr.count; i++) {
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(spaceW, 21 + i * 40 + i * 20, lableW, 30)];
        titleLab.text = titleArr[i];
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.textColor = kGray333333;
        titleLab.font = kFont32;
        [_mainView addSubview:titleLab];
    }

    for (int i = 0; i < 6; i ++) {
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
            textField.placeholder = kLocalized(@"GYHS_StaffManager_EnterFourDigit");
            self.userNameTextField = textField;
            self.userNameTextField.keyboardType = UIKeyboardTypeNumberPad;
        }else if (textField.tag == 1){
            textField.placeholder = kLocalized(@"GYHS_StaffManager_EnterSixDigit");
            self.passwordTextField = textField;
            self.passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
            self.passwordTextField.secureTextEntry = YES;
        }else if (textField.tag == 2){
            textField.placeholder = kLocalized(@"GYHS_StaffManager_EnterSixDigit");
            self.passwordConfirmTextField = textField;
            self.passwordConfirmTextField.secureTextEntry = YES;
            self.passwordConfirmTextField.keyboardType = UIKeyboardTypeNumberPad;
        }else if (textField.tag == 3){
            self.nameTextField = textField;
            self.nameTextField.keyboardType = UIKeyboardTypeDefault;
        }else if (textField.tag == 4){
            self.postTextField = textField;
            self.postTextField.keyboardType = UIKeyboardTypeDefault;
        }else if (textField.tag == 5){
            self.phoneTextField = textField;
            self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
    
    UIButton *staButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [staButton setBackgroundImage:[UIImage imageNamed:@"gyhs_normal"] forState:UIControlStateNormal];
    [staButton setBackgroundImage:[UIImage imageNamed:@"gyhs_select"] forState:UIControlStateSelected];
    [staButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    staButton.tag = 100;
    [_mainView addSubview:staButton];
    [staButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainView.mas_top).offset(388);
        make.left.equalTo(self.view.mas_left).offset(lableW + spaceW);
        make.width.equalTo(@(kDeviceProportion(15)));
        make.height.equalTo(@(kDeviceProportion(15)));
    }];
    self.staButton = staButton;
    
    UILabel *staLable = [[UILabel alloc] init];
    [staLable initWithText:kLocalized(@"GYHS_StaffManager_Enable") TextColor:kGray333333 Font:kFont32 TextAlignment:0];
    [_mainView addSubview:staLable];
    [staLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainView.mas_top).offset(381);
        make.left.equalTo(staButton.mas_left).offset(15 + 5);
        make.width.equalTo(@(kDeviceProportion(40)));
        make.height.equalTo(@(kDeviceProportion(30)));
    }];

    UIButton *stoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [stoButton setBackgroundImage:[UIImage imageNamed:@"gyhs_normal"] forState:UIControlStateNormal];
    [stoButton setBackgroundImage:[UIImage imageNamed:@"gyhs_select"] forState:UIControlStateSelected];
    [stoButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    stoButton.tag = 101;
    [_mainView addSubview:stoButton];
    [stoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainView.mas_top).offset(388);
        make.left.equalTo(staLable.mas_left).offset(40 + 75);
        make.width.equalTo(@(kDeviceProportion(15)));
        make.height.equalTo(@(kDeviceProportion(15)));
    }];
    self.stoButton = stoButton;
    
    UILabel *stoLable = [[UILabel alloc] init];
    [stoLable initWithText:kLocalized(@"GYHS_StaffManager_Disable") TextColor:kGray333333 Font:kFont32 TextAlignment:0];
    [_mainView addSubview:stoLable];
    [stoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainView.mas_top).offset(381);
        make.left.equalTo(stoButton.mas_left).offset(15 + 5);
        make.width.equalTo(@(kDeviceProportion(40)));
        make.height.equalTo(@(kDeviceProportion(30)));
    }];

    
    GYPlaceholderTextView *desTextView = [[GYPlaceholderTextView alloc] init];
    desTextView.maxTextLength = 100;
    desTextView.layer.borderColor = kGrayCCCCCC.CGColor;
    desTextView.layer.borderWidth = 1.0f;
    desTextView.delegate = self;
    desTextView.keyboardType = UIKeyboardTypeDefault;
    desTextView.placeholder = kLocalized(@"GYHS_StaffManager_MaximumOf 100 Words");
    [_mainView addSubview:desTextView];
    [desTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainView.mas_top).offset(436);
        make.left.equalTo(self.view.mas_left).offset(lableW + spaceW);
        make.width.equalTo(@(kDeviceProportion(textFieldW)));
        make.height.equalTo(@(kDeviceProportion(80)));
    }];
    self.desTextView = desTextView;
}
/**
 *  创建底部按钮视图
 */
- (void)createFooterView{
    _footerView = [[UIView alloc] init];
     _footerView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.16];     [self.view addSubview:_footerView];
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
    [confirmButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.tag = 102;
    [_footerView addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_footerView.mas_top).offset((70 - 33) / 2);
        make.left.equalTo(_footerView.mas_left).offset((kScreenWidth - 120) / 2);
        make.width.equalTo(@(kDeviceProportion(120)));
        make.height.equalTo(@(kDeviceProportion(33)));
    }];
}
/**
 *  按钮的触发事件
 */
- (void)btnAction:(UIButton *)button{
    if (button.tag == 100) {
        button.selected = !button.selected;
        if (button.selected == YES) {
            self.stoButton.selected = NO;
            self.stateStr = @"0";
        }else{
            self.staButton.selected = YES;
        }
    }else if (button.tag == 101){
        button.selected = !button.selected;
        if (button.selected == YES) {
            self.staButton.selected = NO;
            self.stateStr = @"1";
        }else{
            self.stoButton.selected = YES;
        }
    }else if (button.tag == 102){
        [self addStaffRequest];
    }

}
/**
 *  新增员工操作的网络请求
 */
- (void)addStaffRequest{
    if (![self isDataAllRight]) {
        return;
    }
//    NSString *nameStr;
//    nameStr = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    NSString *nameString;
//    nameString = [nameStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
        [GYHSStaffHttpTool addOperatorUserName:self.userNameTextField.text loginPwd:self.passwordTextField.text realName:self.nameTextField.text operDuty:self.postTextField.text remark:self.desTextView.text accountStatus:_stateStr mobile:self.phoneTextField.text success:^(id responsObject) {
            [GYUtils showToast:kLocalized(@"GYHS_StaffManager_AddNewOperatorSuccess")];
            [self performSelector:@selector(pop) withObject:nil afterDelay:3.0f];
        } failure:^{
            
        }];

}
/**
 *  判断新增员工操作的先决条件，对各输入框进行限制
 */
- (BOOL)isDataAllRight{
    
    if (self.userNameTextField.text.length == 0) {
        [self.userNameTextField tipWithContent:kLocalized(@"GYHS_StaffManager_PleaseEnterLoginUsername") animated:YES];
        return NO;
    }else{
        if (![self.userNameTextField.text isValidNumber]) {
            [self.userNameTextField tipWithContent:kLocalized(@"GYHS_StaffManager_LoginUsernameCanBeOnlyPureDigital") animated:YES];
            return NO;
        }
        
        if (self.userNameTextField.text.length != 4) {
            [self.userNameTextField tipWithContent:kLocalized(@"GYHS_StaffManager_PleaseEnterTheCorrectUsername") animated:YES];
            return NO;
        }
        
        if (self.userNameTextField.text.integerValue > 999){
            [self.userNameTextField tipWithContent:kLocalized(@"GYHS_StaffManager_OperatorUsernameOfTheFirstDigitShallBe0!") animated:YES];
            return NO;
            
        }
    }
    
    if (self.passwordTextField.text.length == 0) {
         [self.passwordTextField tipWithContent:kLocalized(@"GYHS_StaffManager_PleaseEnterLoginPassword") animated:YES];
        return NO;
    }else{
        if (self.passwordTextField.text.length != 6) {
            [self.passwordTextField tipWithContent:kLocalized(@"GYHS_StaffManager_TheLoginPasswordMustBe 6 Digits") animated:YES];
            return NO;
        }
        
        if (![self.passwordTextField.text isValidNumber]) {
            [self.passwordTextField tipWithContent:kLocalized(@"GYHS_StaffManager_LoginPasswordCanBeOnlyPureDigital") animated:YES];
            return NO;
        }
        
        if ([self.passwordTextField.text isSimpleLoginPwd] == NSOrderedStringSame) {
            [self.passwordTextField tipWithContent:kLocalized(@"GYHS_StaffManager_DoNotSetTheSamePasswordNumber,PleaseReset") animated:YES];
            return NO;
        }
        
        if ([self.passwordTextField.text isSimpleLoginPwd] == NSOrderedStringAscending || [self.passwordTextField.text isSimpleLoginPwd] == NSOrderedStringDescending) {
            [self.passwordTextField tipWithContent:kLocalized(@"GYHS_StaffManager_DoNotSetPasswordDigitalContinuousLiftingArrangement,PleaseReset") animated:YES];
            return NO;
        }
    }
    
    if (self.passwordConfirmTextField.text.length == 0) {
        [self.passwordConfirmTextField tipWithContent:kLocalized(@"请再次输入登录密码") animated:YES];
        return NO;
    }else{
        
        if (self.passwordConfirmTextField.text.length != 6) {
            [self.passwordConfirmTextField tipWithContent:kLocalized(@"GYHS_StaffManager_TheLoginPasswordMustBe 6 Digits") animated:YES];
            return NO;
        }

        if (![self.passwordConfirmTextField.text isValidNumber]) {
            [self.passwordConfirmTextField tipWithContent:kLocalized(@"GYHS_StaffManager_LoginPasswordCanBeOnlyPureDigital") animated:YES];
            return NO;
        }
        
    }
    
    if (![self.passwordTextField.text isEqualToString:self.passwordConfirmTextField.text]) {
        [self.passwordConfirmTextField tipWithContent:kLocalized(@"GYHS_StaffManager_TwoTimesEnterPasswordsDoNotMatch") animated:YES];
        return NO;
    }
    
    if (self.nameTextField.text.length == 0) {
        [self.nameTextField tipWithContent:kLocalized(@"GYHS_StaffManager_PleaseEnterEmployeeName") animated:YES];
        return NO;
    }else{
        if (self.nameTextField.text.length > 20) {
            [self.nameTextField tipWithContent:kLocalized(@"GYHS_StaffManager_TheNameCannotExceed 20 Characters") animated:YES];
            return NO;
        }

    }
    
    if (self.postTextField.text.length > 50) {
        [self.postTextField tipWithContent:kLocalized(@"GYHS_StaffManager_PositionCannotExceed 50 Words") animated:YES];
        return NO;
    }

    if (self.phoneTextField.text.length == 0) {
        [self.phoneTextField tipWithContent:kLocalized(@"请输入手机号码") animated:YES];
        return NO;
    }else{
        if (![GYUtils isValidMobileNumber:self.phoneTextField.text]) {
            [self.phoneTextField tipWithContent:kLocalized(@"GYHS_StaffManager_EnterThePhoneNumberIncorrect") animated:YES];
            return NO;
        }
    }
    
    if (self.stateStr.length == 0) {
        [GYUtils showToast:kLocalized(@"GYHS_StaffManager_PleaseSelectState")];
        return NO;
    }
    return YES;
}


-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma  mark - UITextFieldDelegate
/**
 *  当输入框进行编辑时，改变输入框边框的颜色
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField{

    if (self.userNameTextField.isEditing) {
        self.userNameTextField.layer.borderColor = kBlue64A9FD.CGColor;
        self.passwordTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.passwordConfirmTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.nameTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.postTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.phoneTextField.layer.borderColor = kGrayCCCCCC.CGColor;
    }else if (self.passwordTextField.isEditing) {
        self.userNameTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.passwordTextField.layer.borderColor = kBlue64A9FD.CGColor;
        self.passwordConfirmTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.nameTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.postTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.phoneTextField.layer.borderColor = kGrayCCCCCC.CGColor;
    }else if (self.passwordConfirmTextField.isEditing) {
        self.userNameTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.passwordTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.passwordConfirmTextField.layer.borderColor = kBlue64A9FD.CGColor;
        self.nameTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.postTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.phoneTextField.layer.borderColor = kGrayCCCCCC.CGColor;
    }else if (self.nameTextField.isEditing) {
        self.userNameTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.passwordTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.passwordConfirmTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.nameTextField.layer.borderColor = kBlue64A9FD.CGColor;
        self.postTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.phoneTextField.layer.borderColor = kGrayCCCCCC.CGColor;
    }else if (self.postTextField.isEditing) {
        self.userNameTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.passwordTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.passwordConfirmTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.nameTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.postTextField.layer.borderColor = kBlue64A9FD.CGColor;
        self.phoneTextField.layer.borderColor = kGrayCCCCCC.CGColor;
    }else if (self.phoneTextField.isEditing) {
        self.userNameTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.passwordTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.passwordConfirmTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.nameTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.postTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.phoneTextField.layer.borderColor = kBlue64A9FD.CGColor;
    }

}
/**
 *  限制输入框的位数
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == _userNameTextField) {
        if (toBeString.length > 4) {
            [textField resignFirstResponder];
            [textField tipWithContent:kLocalized(@"GYHS_StaffManager_LoginUsernameCannotMoreThanFourDigit") animated:YES];
        }else{
            return YES;
        }
    }else if (textField == _passwordTextField){
        if (toBeString.length > 6) {
            [textField resignFirstResponder];
            [textField tipWithContent:kLocalized(@"GYHS_StaffManager_LoginPasswordCannotMoreThanSixDigit") animated:YES];
        }else{
            return YES;
        }
    }else if (textField == _passwordConfirmTextField){
        if (toBeString.length > 6) {
            [textField resignFirstResponder];
            [textField tipWithContent:kLocalized(@"GYHS_StaffManager_LoginPasswordCannotMoreThanSixDigit") animated:YES];
        }else{
            return YES;
        }

    }else if (textField == _nameTextField){
        NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
        if (![string isEqualToString:tem]) {
            return NO;
        }
    }
//    else if (textField == _postTextField){
//        if (toBeString.length > 50) {
//            [textField resignFirstResponder];
//            [textField tipWithContent:kLocalized(@"GYHS_StaffManager_PositionCannotExceed 50 Words") animated:YES];
//        }
//    }


    return YES;
}


#pragma  mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView{

}
@end
