//
//  GYHDPwdChangeViewController.m
//  HSConsumer
//
//  Created by kuser on 16/9/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDPwdChangeViewController.h"
#import "GYNetRequest.h"
#import "NSString+YYAdd.h"
#import "YYKit.h"
#import "GYBaseControlView.h"
#import "GYHSLoginManager.h"
#import "GYHSLoginViewController.h"
#import "GYAlertView.h"

@interface GYHDPwdChangeViewController ()<UITextFieldDelegate,GYNetRequestDelegate,GYNetRequestDelegate>

@property (nonatomic,strong)UILabel *pwdModifyLabel;//密码修改
@property (nonatomic,strong) UIButton *selectQuestionBtn;//选择问题按钮
@property (nonatomic,strong) UIButton *showQuestionBtn;  //显示问题按钮
@property (nonatomic,strong)UILabel *modifyPwdCategoryLabel;//修改密码类别
@property (nonatomic,strong)UILabel *originalPwdLabel;//原登录密码
@property (nonatomic,strong)UILabel *newsPwdLabel;//原登录密码
@property (nonatomic,strong)UILabel *confirmPwdLabel;//原登录密码
@property (nonatomic,strong)UILabel *pwdCategoryLabel; //密码类别

@property (nonatomic,strong)UITextField *originalPwdTextField; //原登录密码输入
@property (nonatomic,strong)UITextField *newsPwdTextField; //新密码输入
@property (nonatomic,strong)UITextField *confirmPwdTextField; //确认录密码输入
@property (nonatomic,strong)UILabel *tipLabel;//温馨提示

@end

@implementation GYHDPwdChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    //默认登录密码修改
    self.changePasswordType = GYHDLoginPasswordTypeModify;
    [self addContentView];
}

#pragma mark --privateMark

-(void)addContentView
{
    [self setBtnFrame];
    [self setCanChangeFrame];
}

-(void)setBtnFrame
{
    //密码修改Label
    _pwdModifyLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.5 - 70, 15, 100, 21)];
    _pwdModifyLabel.text = kLocalized(@"GYHD_HDNew_SecrectModify");
    _pwdCategoryLabel.textColor =  kCorlorFromHexcode(0x000000);
    _pwdModifyLabel.textAlignment = NSTextAlignmentCenter;
    _pwdModifyLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_pwdModifyLabel];
    //线View
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 46, kScreenWidth, 1)];
    line.backgroundColor = kCorlorFromHexcode(0xebebeb);
    [self.view addSubview:line];
    //修改密码类别label
    _modifyPwdCategoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 100, 21)];
    _modifyPwdCategoryLabel.text = kLocalized(@"GYHD_HDNew_ModifySecrectCategory");
    _modifyPwdCategoryLabel.textColor =  kCorlorFromHexcode(0x000000);
    _modifyPwdCategoryLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_modifyPwdCategoryLabel];
    //确定按钮button
    UIButton *confrimBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 250, kScreenWidth - 60, 41)];
    confrimBtn.titleLabel.textColor = [UIColor whiteColor];
    confrimBtn.layer.cornerRadius = 15;
    confrimBtn.clipsToBounds = YES;
    [confrimBtn setTitle:kLocalized(@"GYHD_HDNew_Confirm") forState:UIControlStateNormal];
    [confrimBtn setBackgroundColor: [UIColor redColor]];
    [confrimBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confrimBtn];
}

-(void)setCanChangeFrame
{
    //修改这
    _pwdCategoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(135, 60, kScreenWidth - 170, 21)];
    _pwdCategoryLabel.text = kLocalized(@"GYHD_HDNew_LoginPwdModify");    _pwdCategoryLabel.textColor = kCorlorFromHexcode(0x666666);
    _pwdCategoryLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_pwdCategoryLabel];
    //选择问题Button
    _selectQuestionBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 55, 65, 13 , 7)];
    [_selectQuestionBtn setBackgroundImage:[UIImage imageNamed:@"gy_hd_red_down_arrow"] forState:UIControlStateNormal];
    [_selectQuestionBtn addTarget:self action:@selector(selectQuestion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectQuestionBtn];
    //显示问题Button
    _showQuestionBtn = [[UIButton alloc]initWithFrame:CGRectMake(135, 60,  kScreenWidth - 170,21)];
    [_showQuestionBtn addTarget:self action:@selector(selectQuestion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_showQuestionBtn];
    
    if (self.isFirstNumber == 1) {
        _selectQuestionBtn.hidden = NO;
        _showQuestionBtn.hidden = NO;
    }else if(self.isFirstNumber == 2){
        _selectQuestionBtn.hidden = YES;
        _showQuestionBtn.hidden = YES;
    }
    //线View
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 92, kScreenWidth, 1)];
    line1.backgroundColor = kCorlorFromHexcode(0xebebeb);
    [self.view addSubview:line1];
    //原密码Label
    _originalPwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 105, 100, 21)];
    if (self.changePasswordType == GYHDLoginPasswordTypeModify) {
        _originalPwdLabel.text = kLocalized(@"GYHD_HDNew_OriginLoginPwd");
    }else{
        _originalPwdLabel.text = kLocalized(@"GYHD_HDNew_OriginTrandsPwd");
    }
    _originalPwdLabel.textColor =  kCorlorFromHexcode(0x000000);
    _originalPwdLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_originalPwdLabel];
    //原密码输入textField
    _originalPwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(135, 105, kScreenWidth - 170, 21)];
    _originalPwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _originalPwdTextField.delegate = self;
    _originalPwdTextField.tag = 3000;
    if (self.changePasswordType == GYHDLoginPasswordTypeModify) {
        _originalPwdTextField.placeholder = kLocalized(@"GYHD_HDNew_InputOriginLoginPwd");
    }else{
        _originalPwdTextField.placeholder = kLocalized(@"GYHD_HDNew_InputOriginTrandsPwd");
    }
    _originalPwdTextField.font = [UIFont systemFontOfSize:14];
    _originalPwdTextField.secureTextEntry = YES;
    _originalPwdTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_originalPwdTextField];
    //线View
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 138, kScreenWidth, 1)];
    line2.backgroundColor = kCorlorFromHexcode(0xebebeb);
    [self.view addSubview:line2];
    //新密码Label
    _newsPwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 151, 100, 21)];
    _newsPwdLabel.textColor =  kCorlorFromHexcode(0x000000);
    if (self.changePasswordType == GYHDLoginPasswordTypeModify) {
        _newsPwdLabel.text = kLocalized(@"GYHD_HDNew_NewPwd");
    }else{
        _newsPwdLabel.text = kLocalized(@"GYHD_HDNew_NewTrandsPwd");
    }
    _newsPwdLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_newsPwdLabel];
    //新密码输入textField
    _newsPwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(135, 151, kScreenWidth - 170, 21)];
    _newsPwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _newsPwdTextField.delegate = self;
    _newsPwdTextField.keyboardType = UIKeyboardTypeNumberPad;
    if (self.changePasswordType == GYHDLoginPasswordTypeModify) {
        _newsPwdTextField.placeholder = kLocalized(@"GYHD_HDNew_InputNewLoginPwd");
    }else{
        _newsPwdTextField.placeholder = kLocalized(@"GYHD_HDNew_AgainInputNewPwd");
    }
    _newsPwdTextField.font = [UIFont systemFontOfSize:14];
    _newsPwdTextField.secureTextEntry = YES;
    _newsPwdTextField.keyboardType = UIKeyboardTypeNumberPad;
    _newsPwdTextField.tag = 4000;
    [self.view addSubview:_newsPwdTextField];
    //线View
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 184, kScreenWidth, 1)];
    line3.backgroundColor = kCorlorFromHexcode(0xebebeb);
    [self.view addSubview:line3];
    //确定密码Label
    _confirmPwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 195, 100, 21)];
    _confirmPwdLabel.textColor =  kCorlorFromHexcode(0x000000);
    _confirmPwdLabel.text = kLocalized(@"GYHD_HDNew_ConfirmPwd");
    _confirmPwdLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_confirmPwdLabel];
    //确定密码输入框TextField
    _confirmPwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(135, 195, kScreenWidth - 170, 21)];
    _confirmPwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _confirmPwdTextField.delegate = self;
    _confirmPwdTextField.secureTextEntry = YES;
    _confirmPwdTextField.keyboardType = UIKeyboardTypeNumberPad;
    _confirmPwdTextField.tag = 5000;
    if (self.changePasswordType == GYHDLoginPasswordTypeModify) {
        _confirmPwdTextField.placeholder = kLocalized(@"GYHD_HDNew_AgainInputNewLoginPwd");
    }else{
        _confirmPwdTextField.placeholder = kLocalized(@"GYHD_HDNew_AgainInputPwd");
    }
    _confirmPwdTextField.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_confirmPwdTextField];
    //线View
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0, 230, kScreenWidth, 1)];
    line4.backgroundColor = kCorlorFromHexcode(0xebebeb);
    [self.view addSubview:line4];
    //温馨提示Label
    _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 280, kScreenWidth - 60, 61)];
    _tipLabel.text = kLocalized(@"GYHD_HDNew_EspeciallyTipLoginPwdIsSixNumber");    _tipLabel.numberOfLines = 0;
    _tipLabel.font = [UIFont systemFontOfSize:14];
    _tipLabel.textColor =  kCorlorFromHexcode(0x666666);
    [self.view addSubview:_tipLabel];
}

-(void)selectQuestion
{
    CGPoint point = CGPointMake(_selectQuestionBtn.frame.origin.x - 222 + 45, (kScreenHeight - 333 - 65) * 0.5 + 46);
    NSArray *titles = @[kLocalized(@"GYHD_HDNew_LoginPwdModify"), kLocalized(@"GYHD_HDNew_TrandsPwdModify")];
    GYBaseControlView *pop = [[GYBaseControlView alloc] initWithPoint:point titles:titles images:nil width:222 selectName:_pwdCategoryLabel.text];
    pop.selectRowAtIndex = ^(NSInteger index){
        
        _pwdCategoryLabel.text = titles[index];
        _originalPwdTextField.text = nil;
        _newsPwdTextField.text = nil;
        _confirmPwdTextField.text = nil;
        if (index == 0) {
            self.changePasswordType = GYHDLoginPasswordTypeModify;
        }else{
            self.changePasswordType = GYHDTradingPasswordTypeModify;
        }
        [self addContentWordChange];
    };
    [pop show];
}

-(void)confirmClick
{
    if (self.changePasswordType == GYHDLoginPasswordTypeModify) {
        
        [self modefyLoginPwd];
    }else{
        
        [self modefyTrandsPwd];
    }
}

//修改登录密码
-(void)modefyLoginPwd
{
    if ([GYUtils isBlankString:self.originalPwdTextField.text]) {
        [GYUtils showToast:kLocalized(@"输入原登录密码")];
        return;
    }
    else if ([GYUtils isBlankString:self.newsPwdTextField.text]) {
        [GYUtils showToast:kLocalized(@"输入新登录密码")];
        return;
    }
    else if ([GYUtils isBlankString:self.confirmPwdTextField.text]) {
        [GYUtils showToast:kLocalized(@"再次输入新登录密码")];
        return;
    }
    else if (self.originalPwdTextField.text.length != 6 || self.newsPwdTextField.text.length != 6) {
        [GYUtils showToast:kLocalized(@"GYHD_HDNew_PleaseEnterPassword6Number")];
        return;
    }
    else if ([self.originalPwdTextField.text isEqualToString:self.newsPwdTextField.text]) {
        [GYUtils showToast:kLocalized(@"GYHD_HDNew_TheOldPasswordAndNewPasswordNotBeTheSamePleaseInputAgain")];
        return;
    }
    else if (![self.newsPwdTextField.text isEqualToString:self.confirmPwdTextField.text]) {
        [GYUtils showToast:kLocalized(@"GYHD_HDNew_TwoInputPasswordAreDifferent")];
        _confirmPwdTextField.clearsOnBeginEditing = YES;
        return;
    }  else if ([self.newsPwdTextField.text isSimpleLoginPwd] == NSOrderedStringSame) {
        [GYUtils showMessage:kLocalized(@"GYHD_HDNew_PleaseDonotSetSameNumberPasswordReset")];
        return;
    }
    else if ([self.newsPwdTextField.text isSimpleLoginPwd] == NSOrderedStringAscending || [self.confirmPwdTextField.text isSimpleTransPwd] == NSOrderedStringDescending) {
        [GYUtils showMessage:kLocalized(@"GYHD_HDNew_PwdNoSetContinueNmuberPleaseReset")];
        return;
    }
    WS(weakSelf)
    
    [GYUtils showMessge:kLocalized(@"确定要修改密码吗?") confirm:^{
        [weakSelf modifyLoginPwdNetwork];
    } cancleBlock:^{
        
    }];
}

//修改交易密码
-(void)modefyTrandsPwd
{
    
    if ([GYUtils isBlankString:self.originalPwdTextField.text]) {
        [GYUtils showToast:kLocalized(@"输入原交易密码")];
        return;
    }
    else if ([GYUtils isBlankString:self.newsPwdTextField.text]) {
        [GYUtils showToast:kLocalized(@"输入新密码")];
        return;
    }
    else if ([GYUtils isBlankString:self.confirmPwdTextField.text]) {
        [GYUtils showToast:kLocalized(@"再次输入新密码")];
        return;
    }else if (self.originalPwdTextField.text.length != 8 || self.newsPwdTextField.text.length != 8) {
        [GYUtils showToast:kLocalized(@"请输入8位交易密码")];
        return;
    }
    else if ([self.originalPwdTextField.text isEqualToString:self.newsPwdTextField.text]) {
        [GYUtils showToast:kLocalized(@"新密码不能与原密码相同")];
        return;
    }
    else if (![self.newsPwdTextField.text isEqualToString:self.confirmPwdTextField.text]) {
        [GYUtils showMessage:kLocalized(@"新交易密码与确认密码不一致")];
        _confirmPwdTextField.clearsOnBeginEditing = YES;
        return;
    }  else if ([self.newsPwdTextField.text isSimpleTransPwd] == NSOrderedStringSame) {
        [GYUtils showMessage:kLocalized(@"密码请不要设为相同的数字，请重新设置")];
        return;
    }
    else if ([self.newsPwdTextField.text isSimpleTransPwd] == NSOrderedStringAscending || [self.confirmPwdTextField.text isSimpleTransPwd] == NSOrderedStringDescending) {
        [GYUtils showMessage:kLocalized(@"GYHD_HDNew_PwdNoSetContinueNmuberPleaseReset")];
        return;
    }
    
    WS(weakSelf)
    [GYUtils showMessge:kLocalized(@"GYHD_HDNew_SureModifyTrandsPwd") confirm:^{
        [weakSelf modifyTrandsPwdNetwork];
    } cancleBlock:^{
        
    }];
}
//修改交易密码网络请求
-(void)modifyTrandsPwdNetwork
{
     NSLog(@"网络请求修改交易密码");
    NSMutableDictionary* allParas = [NSMutableDictionary dictionary];
    [allParas setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"custId"];
    [allParas setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"operCustId"];
    NSString *urlString ;
    urlString = kHSupdateTradePwdUrlString;
    [allParas setValue:kSaftToNSString([self.originalPwdTextField.text md5String]) forKey:@"oldTradePwd"];
    [allParas setValue:kSaftToNSString([self.newsPwdTextField.text md5String]) forKey:@"newTradePwd"];
    [allParas setValue:kSaftToNSString(globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard) forKey:@"userType"];
    GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:urlString parameters:allParas requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    request.tag = 20000;
    [request start];
}
//修改登录密码网络请求
-(void)modifyLoginPwdNetwork
{
    NSLog(@"网络请求修改登录密码成功");
    NSString* oldPwd = [self.originalPwdTextField.text md5String16:globalData.loginModel.custId];
    NSString* newPwd = [self.newsPwdTextField.text md5String16:globalData.loginModel.custId];
    NSDictionary* dict = @{ @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard,
                            @"custId" : kSaftToNSString(globalData.loginModel.custId),
                            @"oldLoginPwd" : kSaftToNSString(oldPwd),
                            @"newLoginPwd" : kSaftToNSString(newPwd)
                            };
    
    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlUpdateLoginPwd parameters:dict requestMethod:GYNetRequestMethodPUT requestSerializer:GYNetRequestSerializerJSON];
    request.tag = 10000;
    [request start];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    [GYGIFHUD dismiss];
    NSString* message;
    if (request.tag == 10000){
        if (![responseObject isKindOfClass:[NSNull class]]) {
            switch ([responseObject[@"retCode"] integerValue]) {
                case 601: {
                    message = kLocalized(@"GYHD_HDNew_PasswordChangeFailedOldPasswordMistake");
                    [GYUtils showToast:message];
                    return;
                } break;
                case 200: {
                    message = kLocalized(@"GYHD_HDNew_PwdModifyWhetherChooseLoginAgain");
                    [GYAlertView showMessage:message cancleButtonTitle:@"否" confirmButtonTitle:@"是" cancleBlock:^{
                        
                        [self.view.superview.superview removeFromSuperview];
                    } confirmBlock:^{
                        // 清除登录信息跳转到登录界面
                        [self.view.superview.superview removeFromSuperview];
                        [[GYHSLoginManager shareInstance] reLogin];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"hideSlideMenuNotification" object:nil
                         ];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"notHideSlideMenuNotification" object:nil
                         ];
                    }];
                } break;
                default: {
                    [GYUtils showToast:kErrorMsg];
                } break;
            }
        }
    }
    if (request.tag == 20000) {
        NSString *msg;
        if(self.changePasswordType == GYHDTradingPasswordTypeModify){
            msg =kLocalized(@"GYHD_HDNew_ModifyTrandsPwdSuccess");
        }
        [GYUtils showMessage:msg confirm:^{
            
            [self.view.superview.superview removeFromSuperview];
//            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    if (netRequest.retCode == 160360) {//特殊处理
        [GYUtils showMessage:kLocalized(@"GYHD_HDNew_OriginalTransPwdMistakePleaseEnterAgain") confirm:^{
        }];
        return;
    }
    [GYGIFHUD dismiss];
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}

//切换修改密码，更新内容文字
-(void)addContentWordChange
{
    if (self.changePasswordType == GYHDLoginPasswordTypeModify) {
        _originalPwdLabel.text = kLocalized(@"GYHD_HDNew_OriginLoginPwd");
        _newsPwdLabel.text = kLocalized(@"GYHD_HDNew_NewPwd");
        _tipLabel.text = kLocalized(@"GYHD_HDNew_EspeciallyTipLoginPwdIsSixNumber");
        _originalPwdTextField.placeholder = kLocalized(@"GYHD_HDNew_InputOriginLoginPwd");
        _newsPwdTextField.placeholder = kLocalized(@"GYHD_HDNew_InputNewLoginPwd");
        _confirmPwdTextField.placeholder = kLocalized(@"GYHD_HDNew_AgainInputNewLoginPwd");
    }else{
        _originalPwdLabel.text = kLocalized(@"GYHD_HDNew_OriginTrandsPwd");
        _newsPwdLabel.text =  kLocalized(@"GYHD_HDNew_NewTrandsPwd");
        _tipLabel.text =  kLocalized(@"GYHD_HDNew_ReminderTrandPwdIsMakeByEightNumber");
        _originalPwdTextField.placeholder = kLocalized(@"GYHD_HDNew_InputOriginTrandsPwd");
        _newsPwdTextField.placeholder = kLocalized(@"GYHD_HDNew_InputNewPwd");
        _confirmPwdTextField.placeholder =  kLocalized(@"GYHD_HDNew_AgainInputNewPwd");
    }
}

#pragma mark - SystemDelegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    //设置输入的最大位数
    NSInteger totalNumber;
    if (self.changePasswordType == GYHDLoginPasswordTypeModify) {
        totalNumber = 6;
    }else{
        totalNumber = 8;
    }
    if (textField.tag == 3000) {  //原登录密码，交易密码
        NSString* toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        unsigned long len = toBeString.length;
        if (textField) {
            if (len > totalNumber)
                return NO;
        }
    }else if(textField.tag == 4000) { //新登录密码，交易密码
        NSString* toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        unsigned long len = toBeString.length;
        if (textField) {
            if (len > totalNumber)
                return NO;
        }
    }else if (textField.tag == 5000){  //确认登录密码，交易密码
        NSString* toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        unsigned long len = toBeString.length;
        if (textField) {
            if (len > totalNumber)
                return NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
