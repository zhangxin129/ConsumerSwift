//
//  GYQuitEmailBandingViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-31.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYModifyEmailBandingViewController.h"
#import "InputCellStypeView.h"
#import "GYAlertView.h"
#import "GYHSLoginManager.h"
#import "NSString+GYExtension.h"

@interface GYModifyEmailBandingViewController () <GYNetRequestDelegate>
// 验证码倒计时时间

@property (nonatomic, assign) int leftTime;
@end

@implementation GYModifyEmailBandingViewController {
    __weak IBOutlet UILabel* lbTips;

    __weak IBOutlet UIButton* btnNextStep;

    __weak IBOutlet InputCellStypeView* InputOldEmail;

    __weak IBOutlet InputCellStypeView* InputNewEmail;

    __weak IBOutlet InputCellStypeView* InputPasswordRow;
    NSTimer* smsTimer;
}

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kDefaultVCBackgroundColor;

    //国际化修改名称
    [self modifyName];
}

- (void)dealloc //销毁定时器
{
    if (smsTimer) {
        [smsTimer invalidate];
        smsTimer = nil;
    }
}

#pragma mark - SystemDelegate

#pragma mark textfield Delegate
- (void)textFieldDidEndEditing:(UITextField*)textField
{

    if (textField.tag == 10) {
        _strOldMail = textField.text;
    }
    else {
        _strNewMail = textField.text;
    }
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    // modify by songjk 计算长度修改
    NSString* toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    unsigned long len = toBeString.length;
    if (textField == InputPasswordRow.tfRightTextField) {
        if (len > 6)
            return NO;
    }
    return YES;
}

#pragma mark TableView Delegate

#pragma mark - CustomDelegate

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    [GYGIFHUD dismiss];
    if ([responseObject[@"retCode"] integerValue] == 200) {
        globalData.loginModel.isAuthEmail = kAuthNo;
        globalData.loginModel.email = InputNewEmail.tfRightTextField.text;

        [GYAlertView showMessage:[NSString stringWithFormat:kLocalized(@"%@%@%@"), kLocalized(@"GYHS_Banding_Validation_Email_Sent%@Please_Login_Email_Complete_Binding"), InputNewEmail.tfRightTextField.text, kLocalized(@"GYHS_Binding_Login_Your_Email_Finish_Banding")] confirmBlock:^{

        }];
        // 验证发送成功后才开始计时
        _leftTime = 120;
        smsTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(gcTimerEvent:) userInfo:nil repeats:YES];
        btnNextStep.userInteractionEnabled = NO;
    }
    else {
        [GYAlertView showMessage:kErrorMsg];
    }
}

- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error
{
    [GYGIFHUD dismiss];
    [GYUtils parseNetWork:error resultBlock:nil];
}

#pragma mark - event response
- (void)gcTimerEvent:(NSTimer*)timer
{
    _leftTime--;
    [btnNextStep setTitle:[NSString stringWithFormat:kLocalized(@"GYHS_Binding_To_Resend"), _leftTime] forState:UIControlStateNormal];

    if (_leftTime == 0) {
        [smsTimer invalidate];
        smsTimer = nil;
        btnNextStep.userInteractionEnabled = YES;
        [btnNextStep setTitle:kLocalized(@"GYHS_Banding_ImmediatelyChange") forState:UIControlStateNormal];
    }
}

- (IBAction)btnGotoNextPage:(id)sender
{

    [self loadDataFromNetwork];
}

#pragma mark - private methods
- (void)modifyName
{
    self.title = kLocalized(@"GYHS_Banding_Modify_Email");
    
    [btnNextStep setBackgroundImage:[UIImage imageNamed:@"hs_btn_confirm_bg.png"] forState:UIControlStateNormal];
    [btnNextStep setTitle:kLocalized(@"GYHS_Banding_ImmediatelyChange") forState:UIControlStateNormal];

    InputOldEmail.lbLeftlabel.text = kLocalized(@"GYHS_Binding_New_Email");
    InputOldEmail.tfRightTextField.placeholder = kLocalized(@"GYHS_Banding_Enter_New_Email");
    InputNewEmail.lbLeftlabel.text = kLocalized(@"GYHS_Banding_ConfirmationEmail");
    InputNewEmail.tfRightTextField.placeholder = kLocalized(@"GYHS_Banding_EnterNewEmailAgain");
    InputPasswordRow.lbLeftlabel.text = kLocalized(@"GYHS_Banding_Verified_Pwd");
    InputPasswordRow.tfRightTextField.placeholder = kLocalized(@"GYHS_Banding_Placeholder_Verified_Pwd");
    InputPasswordRow.tfRightTextField.delegate = self;

    //设置提示信息
    lbTips.textColor = kCellItemTextColor;
    lbTips.text = kLocalized(@"GYHS_Banding_Quit_Email_Banding_Tips");
}

- (void)loadDataFromNetwork
{

    [self.view endEditing:YES];
    if ([GYUtils isBlankString:InputNewEmail.tfRightTextField.text]) {
        [GYAlertView showMessage:kLocalized(@"GYHS_Banding_PleaseEnterNewEmail")];
        return;
    }
    else if ([GYUtils isBlankString:InputOldEmail.tfRightTextField.text]) {
        [GYAlertView showMessage:kLocalized(@"GYHS_Banding_PleaseEnterNewEmail")];
        return;
    }
    else if ([GYUtils isBlankString:InputPasswordRow.tfRightTextField.text]) {
        [GYAlertView showMessage:kLocalized(@"GYHS_Banding_PleaseInputPassword")];
        return;
    }

    NSMutableDictionary* allParas = [NSMutableDictionary dictionary];
    if (globalData.loginModel.cardHolder) { //持卡人与非持卡人修改绑定邮箱的接口不一样
        [allParas setValue:InputNewEmail.tfRightTextField.text forKey:@"email"];
        [allParas setValue:globalData.loginModel.custId forKey:@"custId"];
        [allParas setValue:[InputPasswordRow.tfRightTextField.text md5String16:globalData.loginModel.custId] forKey:@"loginPwd"];
    }
    else {
        [allParas setValue:InputNewEmail.tfRightTextField.text forKey:@"email"];
        [allParas setValue:globalData.loginModel.custId forKey:@"perCustId"];
        [allParas setValue:[InputPasswordRow.tfRightTextField.text md5String16:globalData.loginModel.custId] forKey:@"loginPassword"];
    }

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:(globalData.loginModel.cardHolder ? kModifyEmailBandingUrlString : kNocardModifyEmailBandingUrlString)parameters:allParas requestMethod:GYNetRequestMethodPUT requestSerializer:GYNetRequestSerializerJSON];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [GYGIFHUD show];
    [request start];
}

- (void)setBorderWithView:(UIView*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor*)color
{
    [view addTopBorder];
    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = radius;
}

#pragma mark - getters and setters

@end
