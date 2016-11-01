//
//  GYSettingSafeSetSetTradePasswordVC.m
//
//  Created by apple on 16/8/4.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYSettingSafeSetSetTradePasswordVC.h"
#import "GYNetwork.h"

#import <YYKit/YYKit.h>

@interface GYSettingSafeSetSetTradePasswordVC () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField* tradePasswordTextField;
@property (nonatomic, strong) UITextField* newsTradePasswordTextField;
@property (nonatomic, strong) UILabel* tipLabel;
@property (nonatomic, strong) UIButton* comfirmButtom;

@end

@implementation GYSettingSafeSetSetTradePasswordVC

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
    if (_tradePasswordTextField.text.length == 0) {
        [_tradePasswordTextField tipWithContent:kLocalized(@"请输入交易密码") animated:YES];
        return;
    }
    
    
    if (_tradePasswordTextField.text.length != 8) {
        [_tradePasswordTextField tipWithContent:kLocalized(@"GYSetting_Set_Trade_Password_Eight") animated:YES];
        return;
    }
    
    if (_newsTradePasswordTextField.text.length == 0) {
        [_newsTradePasswordTextField tipWithContent:@"请再次输入新密码" animated:YES];
        return;
    }
    
    if (_newsTradePasswordTextField.text.length != 8) {
        [_newsTradePasswordTextField tipWithContent:kLocalized(@"GYSetting_Set_Trade_Password_Eight") animated:YES];
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
    
    if (![_tradePasswordTextField.text isEqualToString:_newsTradePasswordTextField.text]) {
        [_newsTradePasswordTextField tipWithContent:kLocalized(@"GYSetting_Set_Password_Is_Diffrence") animated:YES];
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
                                @"tradePwd" : _tradePasswordTextField.text.md5String,
                                @"operCustId" : globalData.loginModel.custId
                                };
    
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSSetPwdTrade)
          parameter:dicParams
            success:^(id returnValue) {
                
                if ([returnValue[GYNetWorkCodeKey] isEqualToNumber:@200]) {
                    [GYUtils showToast:kLocalized(@"GYSetting_Set_Trade_Password_Success")];
                    globalData.loginModel.isSettingTradePwd = @"1";
                    [self inputViewBeNil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:GYSetSafeChageVCNotification object:nil];
                }
                
            }
            failure:^(NSError* error) {
                
            }
        isIndicator:YES];
}

#pragma mark - private methods
- (void)inputViewBeNil
{
    self.tradePasswordTextField.text = nil;
    self.newsTradePasswordTextField.text = nil;
}

- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    DDLogInfo(@"Load Controller: %@", [self class]);
    
    [self.view addSubview:self.tradePasswordTextField];
    [self.tradePasswordTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.view).offset(kDeviceProportion(16));
        make.left.equalTo(self.view).offset(kDeviceProportion(342));
        make.right.equalTo(self.view).offset(kDeviceProportion(-342));
        make.height.equalTo(@(kDeviceProportion(40)));
    }];
    
    [self.view addSubview:self.newsTradePasswordTextField];
    [self.newsTradePasswordTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.tradePasswordTextField.mas_bottom).offset(kDeviceProportion(20));
        make.left.equalTo(self.view).offset(kDeviceProportion(342));
        make.right.equalTo(self.view).offset(kDeviceProportion(-342));
        make.height.equalTo(@(kDeviceProportion(40)));
    }];
    
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.newsTradePasswordTextField.mas_bottom).offset(kDeviceProportion(20));
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

- (UITextField*)tradePasswordTextField
{
    if (!_tradePasswordTextField) {
        _tradePasswordTextField = [[UITextField alloc] init];
        _tradePasswordTextField.delegate = self;
        _tradePasswordTextField.font = kFont32;
         _tradePasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _tradePasswordTextField.secureTextEntry = YES;
        _tradePasswordTextField.placeholder = kLocalized(@"GYSetting_Set_Please_Input_New_Password");
        _tradePasswordTextField.borderStyle = UITextBorderStyleLine;
        _tradePasswordTextField.leftViewMode = UITextFieldViewModeAlways;
        _tradePasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
        UIImageView* radePasswordLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(40), kDeviceProportion(40))];
        radePasswordLeftView.contentMode = UIViewContentModeCenter;
        radePasswordLeftView.image = [UIImage imageNamed:@"gyset_safe_password"];
        _tradePasswordTextField.leftView = radePasswordLeftView;
    }
    return _tradePasswordTextField;
}

- (UITextField*)newsTradePasswordTextField
{
    if (!_newsTradePasswordTextField) {
        _newsTradePasswordTextField = [[UITextField alloc] init];
        _newsTradePasswordTextField.delegate = self;
         _newsTradePasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _newsTradePasswordTextField.font = kFont32;
        _newsTradePasswordTextField.secureTextEntry = YES;
        _newsTradePasswordTextField.placeholder = kLocalized(@"GYSetting_Set_Please_Input_New_Password_Again");
        _newsTradePasswordTextField.borderStyle = UITextBorderStyleLine;
        _newsTradePasswordTextField.leftViewMode = UITextFieldViewModeAlways;
        _newsTradePasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
        UIImageView* newPassworLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(40), kDeviceProportion(40))];
        newPassworLeftView.contentMode = UIViewContentModeCenter;
        newPassworLeftView.image = [UIImage imageNamed:@"gyset_safe_password"];
        _newsTradePasswordTextField.leftView = newPassworLeftView;
    }
    return _newsTradePasswordTextField;
}

- (UILabel*)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:kLocalized(@"GYSetting_Set_Tip_Trade_Password_Eight") attributes:@{ NSFontAttributeName : kFont28, NSForegroundColorAttributeName : kGray333333 }];
        [attString setAttributes:@{ NSForegroundColorAttributeName : kRedE50012,
                                    NSFontAttributeName : kFont28 }
                           range:NSMakeRange(0, 5)];
        _tipLabel.attributedText = attString;
    }
    return _tipLabel;
}



@end
