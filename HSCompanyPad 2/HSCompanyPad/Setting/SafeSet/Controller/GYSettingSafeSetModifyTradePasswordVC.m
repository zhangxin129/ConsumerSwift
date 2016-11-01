//
//  GYSettingSafeSetModifyTradePasswordVC.m
//
//  Created by apple on 16/8/4.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYSettingSafeSetModifyTradePasswordVC.h"
#import "GYNetwork.h"
#import <YYKit/YYKit.h>


@interface GYSettingSafeSetModifyTradePasswordVC () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField* oldTradePasswordTextField;
@property (nonatomic, strong) UITextField* newsTradePasswordTextField;
@property (nonatomic, strong) UITextField* againTradePasswordTextField;
@property (nonatomic, strong) UILabel* tipLabel;
@property (nonatomic, strong) UIButton* comfirmButtom;

@end

@implementation GYSettingSafeSetModifyTradePasswordVC

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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

        NSString *beText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (![beText isValidNumber]) {
        return NO;
    }

        if (beText.length > 8) {
            textField.text = [beText substringToIndex:8];
            [textField tipWithContent:kLocalized(@"GYSetting_Set_Trade_Password_Eight") animated:YES];
            return NO;
        }
        return YES;
}

#pragma mark - event
- (void)comfirmButtonAction
{

    if (_oldTradePasswordTextField.text.length == 0) {
        [_oldTradePasswordTextField tipWithContent:kLocalized(@"请输入原交易密码") animated:YES];
        return;
    }
    
    if (_oldTradePasswordTextField.text.length != 8) {
        [_oldTradePasswordTextField tipWithContent:kLocalized(@"GYSetting_Set_Password_Eight") animated:YES];
        return;
    }
    
    if (_newsTradePasswordTextField.text.length == 0) {
        [_newsTradePasswordTextField tipWithContent:kLocalized(@"请输入新交易密码") animated:YES];
        return;
    }
    
    if (_newsTradePasswordTextField.text.length != 8) {
        [_newsTradePasswordTextField tipWithContent:kLocalized(@"GYSetting_Set_Password_Eight") animated:YES];
        return;
    }
    if ([_oldTradePasswordTextField.text isEqualToString:_newsTradePasswordTextField.text]) {
        [_oldTradePasswordTextField tipWithContent:kLocalized(@"GYSetting_Set_Trade_Password_New_And_Old_Diffrence")  animated:YES];
        return;
    }
    
    if (_againTradePasswordTextField.text.length == 0) {
        [_againTradePasswordTextField tipWithContent:@"请再次输入新交易密码" animated:YES];
        return;
    }
    
    NSComparisonStringResult result = [_newsTradePasswordTextField.text isSimpleTransPwd];
    if (result == NSOrderedStringSame) {
        [_newsTradePasswordTextField tipWithContent:kLocalized(@"GYSetting_Set_Password_Same_Number") animated:YES];
        return;
    }
    
    if (result == NSOrderedStringAscending || result == NSOrderedStringDescending) {
        [_newsTradePasswordTextField tipWithContent:kLocalized(@"GYSetting_Set_Password_Not_Up_And_Down") animated:YES];
        return;
    }
    

    if (![_againTradePasswordTextField.text isEqualToString:_newsTradePasswordTextField.text]) {
        [_againTradePasswordTextField tipWithContent:kLocalized(@"GYSetting_Set_Password_Is_Diffrence") animated:YES];
        return;
    }
    
    [self postDataToService];
}

#pragma mark - request
- (void)postDataToService
{
    NSDictionary* dicParams = @{
                                @"custId" : globalData.loginModel.entCustId,
                                @"userType" : @"4", //操作员
                                @"newTradePwd" : _newsTradePasswordTextField.text.md5String ,
                                @"oldTradePwd" : _oldTradePasswordTextField.text.md5String,
                                @"operCustId" : globalData.loginModel.custId
                                };
    
    [GYNetwork PUT:GY_HSDOMAINAPPENDING(GYHSSetUpdateTradePwd) parameter:dicParams success:^(id returnValue) {
        if ([returnValue[GYNetWorkCodeKey] isEqualToNumber:@200]) {
            [GYUtils showToast:kLocalized(@"GYSetting_Set_Modify_Trade_Password_Success")];
            [self inputViewBeNil];
        }
    } failure:^(NSError *error) {
        
    } isIndicator:YES];
}


- (void) inputViewBeNil {
    self.oldTradePasswordTextField.text = nil;
    self.newsTradePasswordTextField.text = nil;
    self.againTradePasswordTextField.text = nil;
}

- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    DDLogInfo(@"Load Controller: %@", [self class]);
    
    [self.view addSubview:self.oldTradePasswordTextField];
    [self.oldTradePasswordTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.view).offset(kDeviceProportion(16));
        make.left.equalTo(self.view).offset(kDeviceProportion(342));
        make.right.equalTo(self.view).offset(kDeviceProportion(-342));
        make.height.equalTo(@(kDeviceProportion(40)));
    }];
    
    [self.view addSubview:self.newsTradePasswordTextField];
    [self.newsTradePasswordTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.oldTradePasswordTextField.mas_bottom).offset(kDeviceProportion(20));
        make.left.equalTo(self.view).offset(kDeviceProportion(342));
        make.right.equalTo(self.view).offset(kDeviceProportion(-342));
        make.height.equalTo(@(kDeviceProportion(40)));
    }];
    
    [self.view addSubview:self.againTradePasswordTextField];
    [self.againTradePasswordTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.newsTradePasswordTextField.mas_bottom).offset(kDeviceProportion(20));
        make.left.equalTo(self.view).offset(kDeviceProportion(342));
        make.right.equalTo(self.view).offset(kDeviceProportion(-342));
        make.height.equalTo(@(kDeviceProportion(40)));
    }];
    
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.againTradePasswordTextField.mas_bottom).offset(kDeviceProportion(20));
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

- (UITextField*)oldTradePasswordTextField
{
    if (!_oldTradePasswordTextField) {
        _oldTradePasswordTextField = [[UITextField alloc] init];
        _oldTradePasswordTextField.delegate = self;
        _oldTradePasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _oldTradePasswordTextField.font = kFont32;
        _oldTradePasswordTextField.secureTextEntry = YES;
        _oldTradePasswordTextField.placeholder = kLocalized(@"GYSetting_Set_Trade_Password_Old");
        _oldTradePasswordTextField.borderStyle = UITextBorderStyleLine;
        _oldTradePasswordTextField.leftViewMode = UITextFieldViewModeAlways;
        _oldTradePasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
        UIImageView* oldPasswordLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(40), kDeviceProportion(40))];
        oldPasswordLeftView.contentMode = UIViewContentModeCenter;
        oldPasswordLeftView.image = [UIImage imageNamed:@"gyset_safe_password"];
        _oldTradePasswordTextField.leftView = oldPasswordLeftView;
    }
    return _oldTradePasswordTextField;
}

- (UITextField*)newsTradePasswordTextField
{
    if (!_newsTradePasswordTextField) {
        _newsTradePasswordTextField = [[UITextField alloc] init];
        _newsTradePasswordTextField.delegate = self;
        _newsTradePasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _newsTradePasswordTextField.font = kFont32;
        _newsTradePasswordTextField.secureTextEntry = YES;
        _newsTradePasswordTextField.placeholder = kLocalized(@"GYSetting_Set_Trade_Password_New");
        _newsTradePasswordTextField.borderStyle = UITextBorderStyleLine;
        _newsTradePasswordTextField.leftViewMode = UITextFieldViewModeAlways;
        _newsTradePasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
        UIImageView* newPasswordLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(40), kDeviceProportion(40))];
        newPasswordLeftView.contentMode = UIViewContentModeCenter;
        newPasswordLeftView.image = [UIImage imageNamed:@"gyset_safe_password"];
        _newsTradePasswordTextField.leftView = newPasswordLeftView;
    }
    return _newsTradePasswordTextField;
}

- (UITextField*)againTradePasswordTextField
{
    if (!_againTradePasswordTextField) {
        _againTradePasswordTextField = [[UITextField alloc] init];
        _againTradePasswordTextField.delegate = self;
        _againTradePasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _againTradePasswordTextField.font = kFont32;
        _againTradePasswordTextField.secureTextEntry = YES;
        _againTradePasswordTextField.placeholder = kLocalized(@"GYSetting_Set_Trade_Password_New_Again");
        _againTradePasswordTextField.borderStyle = UITextBorderStyleLine;
        _againTradePasswordTextField.leftViewMode = UITextFieldViewModeAlways;
        _againTradePasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
        UIImageView* againPasswordLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(40), kDeviceProportion(40))];
        againPasswordLeftView.contentMode = UIViewContentModeCenter;
        againPasswordLeftView.image = [UIImage imageNamed:@"gyset_safe_password"];
        _againTradePasswordTextField.leftView = againPasswordLeftView;
    }
    return _againTradePasswordTextField;
}

- (UILabel*)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:kLocalized(@"GYSetting_Set_Tip_Trade_Password_Eight") attributes:@{ NSFontAttributeName : kFont28,
                                                                                                                                 NSForegroundColorAttributeName :kGray333333 }];
        [attString setAttributes:@{ NSForegroundColorAttributeName : kRedE50012,
                                    NSFontAttributeName : kFont28 }
                           range:NSMakeRange(0, 5)];
        _tipLabel.attributedText = attString;
    }
    return _tipLabel;
}


@end
