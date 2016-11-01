//
//  GYChangeLoginPwdViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYChangeLoginPwdViewController.h"
#import "GYHSLoginManager.h"
#import "GYHSLoginViewController.h"
#import "NSString+GYExtension.h"

@interface GYChangeLoginPwdViewController () <GYNetRequestDelegate>

@end

@implementation GYChangeLoginPwdViewController {

    __weak IBOutlet UIView* lbUpBackground; //背景view

    __weak IBOutlet UILabel* lbConfirmPasswd; //背景view

    __weak IBOutlet UILabel* lbOldPasswd; //背景view

    __weak IBOutlet UIView* vNewPasswordBg; //背景view

    __weak IBOutlet UILabel* lbNewPassword; //新密码

    __weak IBOutlet UIView* vNewPasswordAgainBg; //再次输入新密码
}

#pragma mark - life cycle
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //设置边框
    [self setTextColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    self.title = kLocalized(@"GYHS_Pwd_Change");
    //修改国际化名称
    [self modifyName];
    [self setTextFieldPlaceHoderText];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

#pragma mark - SystemDelegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString* toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    unsigned long len = toBeString.length;

    if (textField) {
        if (len > 6)
            return NO;
    }

    DDLogDebug(@"%@", string);
    return [GYUtils isValidNumber:string];
}

#pragma mark TableView Delegate

#pragma mark - CustomDelegate
#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    [GYGIFHUD dismiss];
    NSString* message;
    if (![responseObject isKindOfClass:[NSNull class]]) {
        switch ([responseObject[@"retCode"] integerValue]) {
        case 601: {
            message = kLocalized(@"GYHS_Pwd_PasswordChangeFailedOldPasswordMistake");
            [GYUtils showToast:message];
            return;
        } break;
        case 200: {
            message = kLocalized(@"GYHS_Pwd_Password_Changed_Whether_Choose_To_Login_Again");
            WS(weakSelf)
                [GYUtils showMessge:message confirm:^{
                    // 清除登录信息跳转到登录界面
                    [[GYHSLoginManager shareInstance] reLogin];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } cancleBlock:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];

        } break;
        default: {
            [GYUtils showToast:kErrorMsg];
        } break;
        }
    }
}
- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    [GYGIFHUD dismiss];
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}

#pragma mark - event response
- (void)hidenKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)loadDataFromNetwork
{
    NSString* oldPwd = [self.OldPassword.text md5String16:globalData.loginModel.custId];
    NSString* newPwd = [self.NewPassword.text md5String16:globalData.loginModel.custId];

    NSDictionary* dict = @{ @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard,
        @"custId" : kSaftToNSString(globalData.loginModel.custId),
        @"oldLoginPwd" : kSaftToNSString(oldPwd),
        @"newLoginPwd" : kSaftToNSString(newPwd)
    };
    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlUpdateLoginPwd parameters:dict requestMethod:GYNetRequestMethodPUT requestSerializer:GYNetRequestSerializerJSON];
    [request start];
}

//返回到上级控制器
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//push到下级控制器
- (IBAction)btnNextStep:(id)sender
{
    if ([GYUtils isBlankString:self.OldPassword.text]) {
        [GYUtils showToast:kLocalized(@"GYHS_Pwd_PleaseEnterTheOldPassword")];
        return;
    }
    else if ([GYUtils isBlankString:self.NewPassword.text]) {
        [GYUtils showToast:kLocalized(@"GYHS_Pwd_EnterNewPassword")];
        return;
    }
    else if ([GYUtils isBlankString:self.NewPasswordAgain.text]) {
        [GYUtils showToast:kLocalized(@"GYHS_Pwd_EnterPasswordConfirmation")];
        return;
    }
    /////这段代码不知有何用！
    else if (self.OldPassword.text.length != 6 || self.NewPassword.text.length != 6) {
        [GYUtils showToast:kLocalized(@"GYHS_Pwd_PleaseEnterPassword6Number")];
        return;
    }
    else if ([self.OldPassword.text isEqualToString:self.NewPassword.text]) {
        [GYUtils showToast:kLocalized(@"GYHS_Pwd_TheOldPasswordAndNewPasswordNotBeTheSamePleaseInputAgain")];
        return;
    }
    else if (![self.NewPassword.text isEqualToString:self.NewPasswordAgain.text]) {
        [GYUtils showToast:kLocalized(@"GYHS_Pwd_TwoInputPasswordAreDifferent")];
        _NewPasswordAgain.clearsOnBeginEditing = YES;
        return;
    }

    //判断是不是数字，不是数字就提示用户
    else if (![GYUtils isValidNumber:self.OldPassword.text]) {
        [GYUtils showToast:kLocalized(@"GYHS_Pwd_PleaseEnterTheCorrectOldPassword")];
        return;
    }
    else if (![GYUtils isValidNumber:self.NewPassword.text]) {
        [GYUtils showToast:kLocalized(@"GYHS_Pwd_PleaseEnterTheCorrectNewPassword")];
        return;
    }
    else if (![GYUtils isValidNumber:self.NewPasswordAgain.text]) {
        [GYUtils showToast:kLocalized(@"GYHS_Pwd_PleaseEnterTheCorrectConfirmationPassword")];
        return;
    }
    else if ([self.NewPassword.text isSimpleLoginPwd] == NSOrderedStringSame) {
        [GYUtils showMessage:kLocalized(@"GYHS_Pwd_Please_Donot_Set_Same_Number_Password_Reset")];
        return;
    }
    else if ([self.NewPassword.text isSimpleLoginPwd] == NSOrderedStringAscending || [self.NewPasswordAgain.text isSimpleTransPwd] == NSOrderedStringDescending) {
        [GYUtils showMessage:kLocalized(@"GYHS_Pwd_Password_Please_Donot_Set_Continuous_Lifting_Arrangement_Rreset")];
        return;
    }

    WS(weakSelf)
        [GYUtils showMessge:kLocalized(@"GYHS_Pwd_Sure_Modify_Login_Password") confirm:^{
        [weakSelf loadDataFromNetwork];
        } cancleBlock:^{

        }];
}

#pragma mark - private methods
//设置文本颜色
- (void)setTextColor
{
    [self setBorderWithView:lbUpBackground WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [self setBorderWithView:vNewPasswordBg WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [self setBorderWithView:vNewPasswordAgainBg WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [vNewPasswordAgainBg addBottomBorder];
    self.WaringLabel.textColor = kCellItemTextColor;
    lbConfirmPasswd.textColor = kCellItemTitleColor;
    lbOldPasswd.textColor = kCellItemTitleColor;
    lbNewPassword.textColor = kCellItemTitleColor;
}

//设置占位符
- (void)setTextFieldPlaceHoderText
{
    [GYUtils setPlaceholderAttributed:self.OldPassword withSystemFontSize:17.0 withColor:kTextFieldPlaceHolderColor];
    [GYUtils setPlaceholderAttributed:self.NewPassword withSystemFontSize:17.0 withColor:kTextFieldPlaceHolderColor];
    [GYUtils setPlaceholderAttributed:self.NewPasswordAgain withSystemFontSize:17.0 withColor:kTextFieldPlaceHolderColor];
}

//修改国际化名称
- (void)modifyName
{
    lbConfirmPasswd.text = kLocalized(@"GYHS_Pwd_Login_Confirm_Pwd");
    lbOldPasswd.text = kLocalized(@"GYHS_Pwd_Old_Pwd");
    lbNewPassword.text = kLocalized(@"GYHS_Pwd_New_Pwd");
    self.WaringLabel.text = kLocalized(@"GYHS_Pwd_Pwd_By_6To20_English_Letters_Numbers_Or_Symbols");
    [self.BtnnextStep setTitle:kLocalized(@"GYHS_Pwd_Confirm") forState:UIControlStateNormal];
    self.WaringLabel.font = [UIFont systemFontOfSize:14];

    //下一步btn
    [self.BtnnextStep setBackgroundImage:[UIImage imageNamed:@"hs_btn_confirm_bg.png"] forState:UIControlStateNormal];
    self.OldPassword.placeholder = kLocalized(@"GYHS_Pwd_Input_Old_Pwd");
    self.NewPassword.placeholder = kLocalized(@"GYHS_Pwd_Input_New_Pwd");
    self.NewPasswordAgain.placeholder = kLocalized(@"GYHS_Pwd_Input_New_Pwd_Again");
}

//设置分割线方法。
- (void)setBorderWithView:(UIView*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor*)color
{

    [view addTopBorder];
    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = radius;
    
}

#pragma mark - getters and setters


@end
