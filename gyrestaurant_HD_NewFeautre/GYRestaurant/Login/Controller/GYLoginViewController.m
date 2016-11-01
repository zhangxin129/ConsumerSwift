//
//  GYLoginViewController.m
//  GYRestaurant
//
//  Created by kuser on 15/10/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYLoginViewController.h"
#import "GYLoginViewModel.h"
#import "GYMainResViewController.h"
#import "GYLoginEn.h"
#import "GYChageEnvironmentViewController.h"
#import "GYNavigationController.h"
#import "GYencryption.h"
#import "FlatButton.h"
#import "GYRetrievePasswordViewController.h"
#import "IQKeyboardManager.h"

@interface GYLoginViewController ()<UITextFieldDelegate>
{
    UITextField *tfHsno, *tfName, *tfPassword;
}
@end

@implementation GYLoginViewController
#pragma mark - 系统方法
- (void)viewDidLoad
{
   
    [super viewDidLoad];
    
    [self setup];
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    tfHsno.text = [[GYLoginEn sharedInstance] getDefaultUserPwdIsCardUser:NO][0];
//    tfName.text = [[GYLoginEn sharedInstance] getDefaultUserPwdIsCardUser:NO][1];
//    tfPassword.text = [[GYLoginEn sharedInstance] getDefaultUserPwdIsCardUser:NO][2];
    
    tfHsno.text = kGetNSUser(@"resNO")?kGetNSUser(@"resNO"):@"";
    tfName.text =   kGetNSUser(@"userName")?kGetNSUser(@"userName"):@"";
    tfPassword.text = @"";
}

#pragma mark - 自定义方法
/**
 *  初始化信息
 */
- (void)setup
{
    UIButton *bShow = [UIButton buttonWithType:UIButtonTypeCustom];
    bShow.frame = CGRectMake(0, 0, 80, 40);
    [bShow setAttributedTitle:[[NSAttributedString alloc] initWithString:kLocalized(@"SignIn") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kBackFont]}] forState:UIControlStateNormal];
    UIBarButtonItem *bbiShow = [[UIBarButtonItem alloc] initWithCustomView:bShow];
    self.navigationItem.leftBarButtonItem = bbiShow;
    
    UIImageView *iconImage = [[UIImageView alloc]init];
    iconImage.image = [UIImage imageNamed:@"background"];
    iconImage.userInteractionEnabled = YES;
    [self.view addSubview:iconImage];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
        
    }];
    
    
    UIView *loginBackView = [[UIView alloc] init];
    loginBackView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.5];
    loginBackView.userInteractionEnabled = YES;
    [self.view addSubview:loginBackView];
    [loginBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@300);
        make.height.equalTo(@400);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        
        
    }];
    
    UILabel *lbTitleView = [[UILabel alloc] init];
    lbTitleView.text = kLocalized(@"LoginEnterpriseIndependentPlatform");
    lbTitleView.font = [UIFont systemFontOfSize:20];
    lbTitleView.textColor = [UIColor whiteColor];
    lbTitleView.backgroundColor = [UIColor clearColor];
    [loginBackView addSubview:lbTitleView];
    [lbTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.left.offset(30);
        make.right.equalTo(loginBackView.mas_right).offset(-30);
        make.top.equalTo(loginBackView.mas_top).offset(20);
        
    }];
    
    UIImageView *ivImgHsno = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resno"]];
    ivImgHsno.contentMode = UIViewContentModeCenter;
    ivImgHsno.backgroundColor = [UIColor colorWithRed:182*100/255 *.01 green:182*100/255 *.01 blue:182*100/255 *.01 alpha:1];
    [loginBackView addSubview:ivImgHsno];
    [ivImgHsno mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.top.equalTo(lbTitleView.mas_bottom).offset(20);
        make.left.equalTo(loginBackView.mas_left).offset(30);
    }];
    
    tfHsno = [[UITextField alloc] init];
    UIView *leftViewHsno  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    tfHsno.leftView = leftViewHsno;
    tfHsno.leftViewMode = UITextFieldViewModeAlways;
    tfHsno.placeholder = kLocalized(@"InputEnterpriseNumber");
    tfHsno.delegate = self;
    tfHsno.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    tfHsno.backgroundColor = [UIColor whiteColor];
    tfHsno.keyboardType = UIKeyboardTypeNumberPad;
    [loginBackView addSubview:tfHsno];
    [tfHsno mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.top.equalTo(lbTitleView.mas_bottom).offset(20);
        make.left.equalTo(ivImgHsno.mas_right).offset(0);
        make.right.equalTo(loginBackView.mas_right).offset(-30);
    }];
    
    
    UIImageView *ivImgName = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"name"]];
    ivImgName.contentMode = UIViewContentModeCenter;
    ivImgName.backgroundColor =[UIColor colorWithRed:182*100/255 *.01 green:182*100/255 *.01 blue:182*100/255 *.01 alpha:1];
    [loginBackView addSubview:ivImgName];
    [ivImgName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.top.equalTo(ivImgHsno.mas_bottom).offset(20);
        make.left.equalTo(loginBackView.mas_left).offset(30);
    }];
    
    tfName = [[UITextField alloc] init];
    UIView *leftViewName = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    tfName.leftView = leftViewName;
    tfName.leftViewMode = UITextFieldViewModeAlways;
    tfName.placeholder = kLocalized(@"InputEnterpriseUsername");
    tfName.delegate = self;
    tfName.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfName.backgroundColor = [UIColor whiteColor];
    tfName.keyboardType = UIKeyboardTypeNumberPad;
    [loginBackView addSubview:tfName];
    [tfName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.top.equalTo(ivImgHsno.mas_bottom).offset(20);
        make.left.equalTo(ivImgName.mas_right).offset(0);
        make.right.equalTo(loginBackView.mas_right).offset(-30);
        
    }];
    
    UIImageView *ivImgPassword = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginpassword"]];
    ivImgPassword.contentMode = UIViewContentModeCenter;
    ivImgPassword.backgroundColor = [UIColor colorWithRed:182*100/255 *.01 green:182*100/255 *.01 blue:182*100/255 *.01 alpha:1];
    [loginBackView addSubview:ivImgPassword];
    [ivImgPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.top.equalTo(tfName.mas_bottom).offset(20);
        make.left.equalTo(loginBackView.mas_left).offset(30);
    }];
    
    tfPassword = [[UITextField alloc] init];
    UIView *leftViewPassword = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    tfPassword.leftView = leftViewPassword;
    tfPassword.leftViewMode = UITextFieldViewModeAlways;
    tfPassword.placeholder = kLocalized(@"InputEnterpriseLoginPassword");
    tfPassword.secureTextEntry = YES;
    tfPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfPassword.delegate = self;
    tfPassword.backgroundColor = [UIColor whiteColor];
    tfPassword.keyboardType = UIKeyboardTypeNumberPad;
    [loginBackView addSubview:tfPassword];
    [tfPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.top.equalTo(tfName.mas_bottom).offset(20);
        make.left.equalTo(ivImgPassword.mas_right).offset(0);
        make.right.equalTo(loginBackView.mas_right).offset(-30);
    }];
    
    
    UIButton *btnForgetPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnForgetPassword setTitle:kLocalized(@"ForgotPassword") forState:UIControlStateNormal];
    [btnForgetPassword setTitleColor:[UIColor colorWithRed:225 * 100/255 *.01 green:216 *100/255 *.01 blue:35 *100/255 *.01 alpha:1] forState:UIControlStateNormal];
    [btnForgetPassword addTarget:self action:@selector(btnForgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [loginBackView addSubview:btnForgetPassword];
    [btnForgetPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginBackView.mas_left).offset(30);
        make.top.equalTo(ivImgPassword.mas_bottom).offset(20);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    
    FlatButton *btnForLogin = [FlatButton button];
    [btnForLogin setTitle:kLocalized(@"SignIn") forState:UIControlStateNormal];
    btnForLogin.backgroundColor = [UIColor colorWithRed:229 * 100/255 *.01 green:135 *100/255 *.01 blue:39 *100/255 *.01 alpha:1];
    [btnForLogin addTarget:self action:@selector(btnLoginIn) forControlEvents:UIControlEventTouchUpInside];
    btnForLogin.titleLabel.font = [UIFont systemFontOfSize:24];
    [loginBackView addSubview:btnForLogin];
    [btnForLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginBackView.mas_left).offset(30);
        make.right.equalTo(loginBackView.mas_right).offset(-30);
        make.top.equalTo(btnForgetPassword.mas_bottom).offset(30);
        make.height.equalTo(@40);
    }];
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"互生(企业)Pad版本目前只提供餐饮业务，其他业务敬请期待!";
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:24];
    tipLabel.backgroundColor = [UIColor colorWithWhite:.5 alpha:.5];
    [iconImage addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *
                                    
                                    make) {
        
        make.centerX.equalTo(iconImage);
        make.top.equalTo(iconImage.mas_top).offset(90);
     
    }];
    
    FlatButton *chooseEnBtn = [FlatButton button];
    chooseEnBtn.frame = CGRectMake(0, 2, 40, 40);
    [chooseEnBtn addTarget:self action:@selector(chooseEnBtn) forControlEvents:UIControlEventTouchUpInside];
    [chooseEnBtn setImage:[UIImage imageNamed:@"btn_set"] forState:UIControlStateNormal];
    chooseEnBtn.adjustsImageWhenHighlighted = NO;
    UIBarButtonItem *biChoseEn = [[UIBarButtonItem alloc] initWithCustomView:chooseEnBtn];
    self.navigationItem.rightBarButtonItem = biChoseEn;
    
    
    if ([ GYLoginEn isReleaseEn] || ([GYLoginEn getInitLoginLine] == kLoginEn_demo)) {
        chooseEnBtn.hidden = YES;
    }else{
        chooseEnBtn.hidden = NO;
    }

    
}

#pragma mark - btnAction
/**系统环境切换*/
- (void)chooseEnBtn
{
    GYChageEnvironmentViewController *vcEnviroment = [[GYChageEnvironmentViewController alloc] init];
    vcEnviroment.title = kLocalized(@"PleaseSelectTheEnvironment");
    [self.navigationController pushViewController:vcEnviroment animated:YES];
}

/**忘记密码*/
- (void)btnForgetPassword{
    
   [self customAlertView:kLocalized(@"PleaseLoginhttp://hsxtRetrievePassword")];
    
//    GYRetrievePasswordViewController *ctl = [[GYRetrievePasswordViewController alloc] init];
//    [self.navigationController pushViewController:ctl animated:YES];
}

/**登陆*/
- (void)btnLoginIn{
    
    [self.view endEditing:YES];
    
    NSString *resNO = tfHsno.text;
    NSString *userName = tfName.text;
    NSString *pwd = tfPassword.text;
    
    if (resNO.length != 11)    {
        [self customAlertView:kLocalized(@"HSNumberIsNotFormattedCorrectly")];
        return;
    }
    
    if (userName.length != 4) {
        [self customAlertView:kLocalized(@"UserNameIsNotFormattedCorrectly")];
        return;
    }
    
    if (pwd.length != 6)
    {
        [self customAlertView:kLocalized(@"PasswordIsNotFormattedCorrectly")];
        return;
    }
    
    if ([Utils checkHSCardIsNotServicesCompany:resNO]) {
        [self customAlertView:kLocalized(@"ThisUserIsNotALegitimateBusinessUsers")];
        return;
    }
    GYLoginViewModel *login  = [[GYLoginViewModel alloc]init];
    
    [self modelRequestNetwork:login :^(id resultDic) {
        
        GYGlobalData *data = resultDic;
        if (data.loginModel.shopName.length > 0 && data.loginModel.shopId.length > 0) {
            kSetNSUser(@"shopName", data.loginModel.shopName);
            kSetNSUser(@"shopId", data.loginModel.shopId);
        }
        
        kSetNSUser(@"vshopStatus", data.loginModel.vshopStatus);
        
        kSetNSUser(@"resNO", resNO);
        kSetNSUser(@"userName", userName);
//        [globalData.loginModel.vshopStatus isEqualToString:@"1"] &&
        if ((globalData.loginModel.shopId.length > 0 || globalData.currentRole == roleTypeTrusteeshipCompanySystemAdministrator || globalData.currentRole == roleTypeMemberCompanySystemAdministrator)) {
            [self LoadMainView];
        }else if (globalData.loginModel.shopId.length == 0){
            kNotice(kLocalized(@"LoginFailedForUserIsNotAssociatedOperatingPoint!"));
            }
        
        else if([globalData.loginModel.vshopStatus isEqualToString:@"0"]){
            kNotice(kLocalized(@"StoreDidNotOpen,PleaseOpen!"));
        }else if (globalData.loginModel.shopId.length == 0){
            kNotice(kLocalized(@"LoginFailedForUserIsNotAssociatedOperatingPoint!"));
        }
        
    } isIndicator:YES];
    [login loginWithResNo:resNO userName:userName password:pwd];
    kSetNSUser(@"maxFood", @"3");
    kSetNSUser(@"lockTime", @"3");
}


/**
 *
 *加载登陆主要界面
 *
 */
- (void)LoadMainView{
    
    GYMainResViewController *vcMain = [[GYMainResViewController alloc] init];
    GYNavigationController *ncMain = [[GYNavigationController alloc] initWithRootViewController:vcMain];
    self.view.window.rootViewController = ncMain;
    [self notifyWithText:kLocalized(@"LoginSuccessful")];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
         NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (textField == tfHsno) {
            if (toBeString.length > 11) {
                [textField resignFirstResponder];
                [self notifyWithText:kLocalized(@"HS-numberYouEnteredCanNotBeMoreThan11Bits!")];
            }else{
                return YES;
            }
        }
        
        if (textField == tfName) {
            if (toBeString.length > 4) {
                [textField resignFirstResponder];
                 [self notifyWithText:kLocalized(@"UsernameYouEnteredCanNotBeMoreThan4Bits!")];
            }else{
                return YES;
            }
        }
        
        if (textField == tfPassword) {
            if (toBeString.length > 6) {
                [textField resignFirstResponder];
                 [self notifyWithText:kLocalized(@"PasswordYouEnteredCanNotBeMoreThan6Bits!")];
            }else{
                return YES;
            }
        }

    
    return YES;
}

@end
