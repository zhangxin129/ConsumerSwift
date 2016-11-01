//
//  GYSettingSafeSetModifyPassWordVC.m
//
//  Created by apple on 16/8/4.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYSettingSafeSetModifyLoginPassWordVC.h"
#import "GYNetwork.h"


@interface GYSettingSafeSetModifyLoginPassWordVC () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField* oldLoginPasswordTextField;
@property (nonatomic, strong) UITextField* newsLoginPasswordTextField;
@property (nonatomic, strong) UITextField* againLoginPasswordTextField;
@property (nonatomic, strong) UILabel* tipLabel;
@property (nonatomic, strong) UIButton* comfirmButtom;
@end

@implementation GYSettingSafeSetModifyLoginPassWordVC

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
    [self inputViewBeNil];
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    
    NSString* beText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (![beText isValidNumber]) {
        return NO;
    }
    
    if (beText.length > 6) {
        textField.text = [beText substringToIndex:6];
        [textField tipWithContent:kLocalized(@"GYSetting_Set_Login_Password_Six") animated:YES];
        return NO;
    }
    return YES;
}

#pragma mark - event
- (void)comfirmButtonAction
{
    if (_oldLoginPasswordTextField.text.length == 0) {
        [_oldLoginPasswordTextField tipWithContent:kLocalized(@"GYSetting_Set_Login_Password_Old_Input") animated:YES];
        return;
    }
    
    if (_newsLoginPasswordTextField.text.length == 0) {
        [_newsLoginPasswordTextField tipWithContent:kLocalized(@"GYSetting_Set_Login_Password_New_Input") animated:YES];
        return;
    }
    
    if (_againLoginPasswordTextField.text.length == 0) {
        [_againLoginPasswordTextField tipWithContent:kLocalized(@"GYSetting_Set_Login_Password_New_Input_Again") animated:YES];
        return;
    }
    
    if (_oldLoginPasswordTextField.text.length != 6) {
        [_oldLoginPasswordTextField tipWithContent:kLocalized(@"GYSetting_Set_Login_Password_Six_Combination") animated:YES];
        return;
    }
    if (_newsLoginPasswordTextField.text.length != 6) {
        [_newsLoginPasswordTextField tipWithContent:kLocalized(@"GYSetting_Set_Login_Password_Six_Combination") animated:YES];
        return;
    }
    if (_againLoginPasswordTextField.text.length != 6) {
        [_againLoginPasswordTextField tipWithContent:kLocalized(@"GYSetting_Set_Login_Password_Six_Combination") animated:YES];
        return;
    }

  
    if ([_oldLoginPasswordTextField.text isEqualToString:_newsLoginPasswordTextField.text]) {
        [_newsLoginPasswordTextField tipWithContent:kLocalized(@"GYSetting_Set_Login_Password_Old_New_Diffrence") animated:YES];
           return;
    }
    
    NSComparisonStringResult result = [_newsLoginPasswordTextField.text isSimpleLoginPwd];
    if (result == NSOrderedStringSame) {
        [_newsLoginPasswordTextField tipWithContent:kLocalized(@"GYSetting_Set_Password_Same_Number") animated:YES];
        return;
    }
    
    if (result == NSOrderedStringAscending || result == NSOrderedStringDescending) {
        [_newsLoginPasswordTextField tipWithContent:kLocalized(@"GYSetting_Set_Password_Not_Up_And_Down") animated:YES];
        return;
    }
    
    if (![_newsLoginPasswordTextField.text isEqualToString:_againLoginPasswordTextField.text]) {
        [_againLoginPasswordTextField tipWithContent:kLocalized(@"GYSetting_Set_Password_Is_Diffrence") animated:YES];
        return;
    }
    
    [self putDataToServerce];
}

#pragma mark - request
- (void)putDataToServerce
{
    NSDictionary* dicParams = @{
                                @"custId" : globalData.loginModel.custId,
                                @"userType" : @"3", //操作员
                                @"oldLoginPwd" : [_oldLoginPasswordTextField.text encodeWithKey:globalData.loginModel.custId],
                                @"newLoginPwd" : [_newsLoginPasswordTextField.text encodeWithKey:globalData.loginModel.custId]
                                };
    
    [GYNetwork PUT:GY_HSDOMAINAPPENDING(GYHSUpdateLoginPwd)
         parameter:dicParams
           success:^(id returnValue) {
               if ([returnValue[GYNetWorkCodeKey] isEqualToNumber:@200]) {
                   [GYUtils showToast:kLocalized(@"GYSetting_Set_Modify_Login_Password_Success")];
                   [self inputViewBeNil];
               }
           }
           failure:^(NSError* error){
               
           }];
}

#pragma mark - private methods
- (void)inputViewBeNil
{
    self.oldLoginPasswordTextField.text = nil;
    self.newsLoginPasswordTextField.text = nil;
    self.againLoginPasswordTextField.text = nil;
}

- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    DDLogInfo(@"Load Controller: %@", [self class]);
    
    [self.view addSubview:self.oldLoginPasswordTextField];
    [self.oldLoginPasswordTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.view).offset(kDeviceProportion(16));
        make.left.equalTo(self.view).offset(kDeviceProportion(342));
        make.right.equalTo(self.view).offset(kDeviceProportion(-342));
        make.height.equalTo(@(kDeviceProportion(40)));
    }];
    
    [self.view addSubview:self.newsLoginPasswordTextField];
    [self.newsLoginPasswordTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.oldLoginPasswordTextField.mas_bottom).offset(kDeviceProportion(20));
        make.left.equalTo(self.view).offset(kDeviceProportion(342));
        make.right.equalTo(self.view).offset(kDeviceProportion(-342));
        make.height.equalTo(@(kDeviceProportion(40)));
    }];
    
    [self.view addSubview:self.againLoginPasswordTextField];
    [self.againLoginPasswordTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.newsLoginPasswordTextField.mas_bottom).offset(kDeviceProportion(20));
        make.left.equalTo(self.view).offset(kDeviceProportion(342));
        make.right.equalTo(self.view).offset(kDeviceProportion(-342));
        make.height.equalTo(@(kDeviceProportion(40)));
    }];
    
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.againLoginPasswordTextField.mas_bottom).offset(kDeviceProportion(20));
        make.left.equalTo(self.view).offset(kDeviceProportion(342));
        make.right.equalTo(self.view).offset(kDeviceProportion(-342));
        make.height.equalTo(@(kDeviceProportion(40)));
    }];
    
    UIView* bottomBackView = [[UIView alloc] init];
    bottomBackView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.16];
    [self.view addSubview:bottomBackView];
    [bottomBackView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(kDeviceProportion(70)));
    }];
    
    [bottomBackView addSubview:self.comfirmButtom];
    [self.comfirmButtom mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@(kDeviceProportion(33)));
        make.width.equalTo(@(kDeviceProportion(120)));
        make.centerX.centerY.equalTo(bottomBackView);
    }];
}

#pragma mark - lazy load
- (UIButton*)comfirmButtom
{
    if (!_comfirmButtom) {
        _comfirmButtom = [[UIButton alloc] init];
        _comfirmButtom.layer.cornerRadius = 5;
        _comfirmButtom.layer.borderWidth = 1;
        _comfirmButtom.layer.borderColor = kRedE50012.CGColor;
        _comfirmButtom.layer.masksToBounds = YES;
        [_comfirmButtom setTitle:kLocalized(@"GYSetting_Comfirm") forState:UIControlStateNormal];
        [_comfirmButtom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_comfirmButtom setBackgroundColor:kRedE50012];
        [_comfirmButtom addTarget:self action:@selector(comfirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _comfirmButtom;
}

- (UITextField*)oldLoginPasswordTextField
{
    if (!_oldLoginPasswordTextField) {
        _oldLoginPasswordTextField = [[UITextField alloc] init];
        _oldLoginPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _oldLoginPasswordTextField.delegate = self;
        _oldLoginPasswordTextField.font = kFont32;
        _oldLoginPasswordTextField.secureTextEntry = YES;
        _oldLoginPasswordTextField.placeholder = kLocalized(@"GYSetting_Set_Login_Password_Old");
        _oldLoginPasswordTextField.borderStyle = UITextBorderStyleLine;
        _oldLoginPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
        _oldLoginPasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
        UIImageView* oldPasswordLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(40), kDeviceProportion(40))];
        oldPasswordLeftView.contentMode = UIViewContentModeCenter;
        oldPasswordLeftView.image = [UIImage imageNamed:@"gyset_safe_password"];
        _oldLoginPasswordTextField.leftView = oldPasswordLeftView;
    }
    return _oldLoginPasswordTextField;
}

- (UITextField*)newsLoginPasswordTextField
{
    if (!_newsLoginPasswordTextField) {
        _newsLoginPasswordTextField = [[UITextField alloc] init];
        _newsLoginPasswordTextField.font = kFont32;
        _newsLoginPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _newsLoginPasswordTextField.delegate = self;
        _newsLoginPasswordTextField.secureTextEntry = YES;
        _newsLoginPasswordTextField.placeholder = kLocalized(@"GYSetting_Set_Login_Password_New");
        _newsLoginPasswordTextField.borderStyle = UITextBorderStyleLine;
        _newsLoginPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
        _newsLoginPasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
        UIImageView* newPasswordLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(40), kDeviceProportion(40))];
        newPasswordLeftView.contentMode = UIViewContentModeCenter;
        newPasswordLeftView.image = [UIImage imageNamed:@"gyset_safe_password"];
        _newsLoginPasswordTextField.leftView = newPasswordLeftView;
    }
    return _newsLoginPasswordTextField;
}

- (UITextField*)againLoginPasswordTextField
{
    if (!_againLoginPasswordTextField) {
        _againLoginPasswordTextField = [[UITextField alloc] init];
        _againLoginPasswordTextField.font = kFont32;
        _againLoginPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _againLoginPasswordTextField.delegate = self;
        _againLoginPasswordTextField.secureTextEntry = YES;
        _againLoginPasswordTextField.placeholder = kLocalized(@"GYSetting_Set_Please_Input_New_Password_Again");
        _againLoginPasswordTextField.borderStyle = UITextBorderStyleLine;
        _againLoginPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
        _againLoginPasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
        UIImageView* againPasswordLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(40), kDeviceProportion(40))];
        againPasswordLeftView.contentMode = UIViewContentModeCenter;
        againPasswordLeftView.image = [UIImage imageNamed:@"gyset_safe_password"];
        _againLoginPasswordTextField.leftView = againPasswordLeftView;
    }
    return _againLoginPasswordTextField;
}

- (UILabel*)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:kLocalized(@"GYSetting_Set_Tip_Login_Password_Six")
                                                                                      attributes:@{ NSFontAttributeName : kFont28,
                                                                                                    NSForegroundColorAttributeName : kGray333333 }];
        [attString setAttributes:@{ NSForegroundColorAttributeName :kRedE50012,
                                    NSFontAttributeName : kFont28 }
                           range:NSMakeRange(0, 5)];
        _tipLabel.attributedText = attString;
    }
    return _tipLabel;
}


@end
