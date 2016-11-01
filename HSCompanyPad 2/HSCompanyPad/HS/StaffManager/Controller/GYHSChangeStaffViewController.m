//
//  GYHSChangeStaffViewController.m
//
//  Created by apple on 16/8/10.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//
/**
 *  修改员工操作
 */
#import "GYHSChangeStaffViewController.h"
#import <GYKit/GYPlaceholderTextView.h>
#import "UILabel+Category.h"
#import "GYHSResetPasswordVC.h"
#import "GYHSStaffHttpTool.h"


@interface GYHSChangeStaffViewController ()<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *staButton;
@property (nonatomic, strong) UIButton *stoButton;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *rePasswordButton;
@property (nonatomic, strong) UITextField *userNameTextField;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *postTextField;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) GYPlaceholderTextView *desTextView;
@property (nonatomic, copy) NSString *stateStr;

@end

@implementation GYHSChangeStaffViewController

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
    self.title = kLocalized(@"GYHS_StaffManager_ModifyOperator");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    DDLogInfo(@"Load Controller: %@", [self class]);
    
    [self createMainView];
    [self createFooterView];
}

#pragma mark - event

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
    
    NSArray *titleArr = @[kLocalized(@"GYHS_StaffManager_LoginUsername:"),kLocalized(@"GYHS_StaffManager_LoginPassword:"),kLocalized(@"GYHS_StaffManager_EmployeeName:"),kLocalized(@"GYHS_StaffManager_Post:"),kLocalized(@"GYHS_StaffManager_PhoneNumber:"),kLocalized(@"GYHS_StaffManager_State:"),kLocalized(@"GYHS_StaffManager_description:")];
    for (int i = 0; i < titleArr.count; i++) {
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(spaceW, 21 + i * 40 + i * 20, lableW, 30)];
        titleLab.text = titleArr[i];
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.textColor = kGray333333;
        titleLab.font = kFont32;
        [_mainView addSubview:titleLab];
    }
    
    UITextField *userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(lableW + spaceW, 16, textFieldW, 40)];
    userNameTextField.layer.borderColor = kGrayCCCCCC.CGColor;
    userNameTextField.layer.borderWidth = 1.0f;
    userNameTextField.delegate = self;
    userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* passWordLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(10), kDeviceProportion(40))];
    userNameTextField.leftView = passWordLeftView;
    userNameTextField.tag = 0;
    [_mainView addSubview:userNameTextField];
    self.userNameTextField = userNameTextField;
    self.userNameTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.userNameTextField.text = _model.userName;
    self.userNameTextField.enabled = NO;    
    _rePasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rePasswordButton.backgroundColor = [UIColor whiteColor];
    [_rePasswordButton setTitle:kLocalized(@"GYHS_StaffManager_ResetLoginPWD") forState:UIControlStateNormal];
    [_rePasswordButton setTitleColor:kBlue0A59C2 forState:UIControlStateNormal];
    [_rePasswordButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:_rePasswordButton];
    [_rePasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userNameTextField.mas_top).offset( 40 + 25);
        make.left.equalTo(self.view.mas_left).offset(lableW + spaceW);
        make.width.equalTo(@(kDeviceProportion(120)));
        make.height.equalTo(@(kDeviceProportion(30)));
    }];
    
    
    for (int i = 2; i < 5; i ++) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(lableW + spaceW, 16 + i * 40 + i * 20, textFieldW, 40)];
        textField.layer.borderColor = kGrayCCCCCC.CGColor;
        textField.layer.borderWidth = 1.0f;
        textField.delegate = self;
        textField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView* passWordLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(10), kDeviceProportion(40))];
        textField.leftView = passWordLeftView;
        textField.tag = i;
        [_mainView addSubview:textField];
        
        if (textField.tag == 2){
            self.nameTextField = textField;
            self.nameTextField.text = _model.realName;
            self.nameTextField.keyboardType = UIKeyboardTypeDefault;
        }else if (textField.tag == 3){
            self.postTextField = textField;
            self.postTextField.text = _model.operDuty;
            self.postTextField.keyboardType = UIKeyboardTypeDefault;
        }else if (textField.tag == 4){
            self.phoneTextField = textField;
            self.phoneTextField.text = _model.mobile;
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
        make.top.equalTo(_mainView.mas_top).offset(328);
        make.left.equalTo(self.view.mas_left).offset(lableW + spaceW);
        make.width.equalTo(@(kDeviceProportion(15)));
        make.height.equalTo(@(kDeviceProportion(15)));
    }];
    self.staButton = staButton;
    
    UILabel *staLable = [[UILabel alloc] init];
    [staLable initWithText:kLocalized(@"GYHS_StaffManager_Enable") TextColor:kGray333333 Font:kFont32 TextAlignment:0];
    [_mainView addSubview:staLable];
    [staLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainView.mas_top).offset(321);
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
        make.top.equalTo(_mainView.mas_top).offset(328);
        make.left.equalTo(staLable.mas_left).offset(40 + 75);
        make.width.equalTo(@(kDeviceProportion(15)));
        make.height.equalTo(@(kDeviceProportion(15)));
    }];
    self.stoButton = stoButton;
    
    if ([_model.accountStatus isEqualToString:@"0"]) {
        self.staButton.selected = YES;
        _stateStr = @"0";
    }else if ([_model.accountStatus isEqualToString:@"1"]){
        self.stoButton.selected = YES;
        _stateStr = @"1";
    }
    
    UILabel *stoLable = [[UILabel alloc] init];
    [stoLable initWithText:kLocalized(@"GYHS_StaffManager_Disable") TextColor:kGray333333 Font:kFont32 TextAlignment:0];
    [_mainView addSubview:stoLable];
    [stoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainView.mas_top).offset(321);
        make.left.equalTo(stoButton.mas_left).offset(15 + 5);
        make.width.equalTo(@(kDeviceProportion(40)));
        make.height.equalTo(@(kDeviceProportion(30)));
    }];
    
    
    GYPlaceholderTextView *desTextView = [[GYPlaceholderTextView alloc] init];
    desTextView.layer.borderColor = kGrayCCCCCC.CGColor;
    desTextView.layer.borderWidth = 1.0f;
    desTextView.delegate = self;
    desTextView.keyboardType = UIKeyboardTypeDefault;
    desTextView.placeholder = kLocalized(@"GYHS_StaffManager_MaximumOf 100 Words");
    desTextView.maxTextLength = 100;
    [_mainView addSubview:desTextView];
    [desTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainView.mas_top).offset(376);
        make.left.equalTo(self.view.mas_left).offset(lableW + spaceW);
        make.width.equalTo(@(kDeviceProportion(textFieldW)));
        make.height.equalTo(@(kDeviceProportion(80)));
    }];
    self.desTextView = desTextView;
    self.desTextView.text = _model.remark;
}
/**
 *  创建底部按钮视图
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
 *
 */
- (void)btnAction:(UIButton *)button{
    if (button.tag == 100) {
        button.selected = !button.selected;
        if (button.selected == YES) {
            self.stateStr = @"0";
            self.stoButton.selected = NO;
        }else{
            self.staButton.selected = YES;
        }
    }else if (button.tag == 101){
        button.selected = !button.selected;
        if (button.selected == YES) {
            self.stateStr = @"1";
            self.staButton.selected = NO;
        }else{
            self.stoButton.selected = YES;
        }
    }else if (button.tag == 102){
        [self requestChangeOpretor];
    }
    if (button == _rePasswordButton) {
        GYHSResetPasswordVC *resetPasswordVC = [[GYHSResetPasswordVC alloc] init];
        resetPasswordVC.realNameStr = _model.realName;
        resetPasswordVC.userNameStr = _model.userName;
        resetPasswordVC.oprCustIdStr = self.adminCustId;
        [self.navigationController pushViewController:resetPasswordVC animated:YES];
    }
}

-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - request
/**
 *  修改员工操作的网络请求
 */
- (void)requestChangeOpretor{
    
    if (![self isDataAllRight]) {
        return;
    }
        [GYHSStaffHttpTool editOperatorRealName:_nameTextField.text operDuty:_postTextField.text operCustId:_model.operCustId remark:_desTextView.text mobile:_phoneTextField.text accountStatus:_stateStr success:^(id responsObject) {
            [GYUtils showToast:kLocalized(@"GYHS_StaffManager_UpdateSuccess")];
            [self performSelector:@selector(pop) withObject:nil afterDelay:3.0f];
        } failure:^{
            
        }];

}
/**
 *  判断进行修改员工操作的先决条件
 */
- (BOOL)isDataAllRight{
    
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


#pragma  mark - UITextFieldDelegate
/**
 *  当输入框进入编辑时，改变边框的颜色
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (self.userNameTextField.isEditing) {
        self.userNameTextField.layer.borderColor = kBlue64A9FD.CGColor;
        self.nameTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.postTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.phoneTextField.layer.borderColor = kGrayCCCCCC.CGColor;
    }else if (self.nameTextField.isEditing) {
        self.userNameTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.nameTextField.layer.borderColor = kBlue64A9FD.CGColor;
        self.postTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.phoneTextField.layer.borderColor = kGrayCCCCCC.CGColor;
    }else if (self.postTextField.isEditing) {
        self.userNameTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.nameTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.postTextField.layer.borderColor = kBlue64A9FD.CGColor;
        self.phoneTextField.layer.borderColor = kGrayCCCCCC.CGColor;
    }else if (self.phoneTextField.isEditing) {
        self.userNameTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.nameTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.postTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.phoneTextField.layer.borderColor = kBlue64A9FD.CGColor;
    }
    
}
/**
 *  限制输入框的位数
 */
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    
    if (textField == _nameTextField){
        NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
        if (![string isEqualToString:tem]) {
            return NO;
        } 
    }
//    NSString* toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//   if (textField == _postTextField){
//        if (toBeString.length > 50) {
//            [textField resignFirstResponder];
//            [textField tipWithContent:kLocalized(@"GYHS_StaffManager_PositionCannotExceed 50 Words") animated:YES];
//        }
//    }else if (textField == _nameTextField){
//        if (toBeString.length > 20) {
//            [textField resignFirstResponder];
//            [textField tipWithContent:kLocalized(@"GYHS_StaffManager_TheNameCannotExceed 20 Characters") animated:YES];
//        }
//    }
    return YES;
}
#pragma mark - 键盘收起
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self.view endEditing:YES];
}
#pragma  mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView{
    
}
@end
