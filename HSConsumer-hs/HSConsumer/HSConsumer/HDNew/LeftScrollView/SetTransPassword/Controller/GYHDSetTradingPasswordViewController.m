//
//  GYHDSetTradingPasswordViewController.m
//  HSConsumer
//
//  Created by kuser on 16/9/18.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSetTradingPasswordViewController.h"
#import "GYNetRequest.h"
#import "NSString+YYAdd.h"
#import "YYKit.h"
#import "GYHSTools.h"

@interface GYHDSetTradingPasswordViewController ()<GYNetRequestDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextField *textFieldAgain;
@property (nonatomic,copy)NSString *nePassword;//新密码
@property (nonatomic,copy)NSString *confirmPassword;//确认密码
@property (nonatomic,strong)UIButton *confrimBtn;//确定按钮

@end

@implementation GYHDSetTradingPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self addContentView];
}

-(void)addContentView
{
    //交易密码设置Label
    UILabel *trandPwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.5 - 50, 15, 100, 21)];
    trandPwdLabel.text = kLocalized(@"GYHD_HDNew_TrandsPwdSetting");
    trandPwdLabel.textColor = kCorlorFromHexcode(0x000000);
    trandPwdLabel.textAlignment = NSTextAlignmentCenter;
    trandPwdLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:trandPwdLabel];
    //线View
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 46, kScreenWidth, 1)];
    line.backgroundColor = kCorlorFromHexcode(0xebebeb);
    [self.view addSubview:line];
    //新密码Label
    UILabel *newPwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 100, 21)];
    newPwdLabel.text = kLocalized(@"GYHD_HDNew_NewPwd");
    newPwdLabel.textColor = kCorlorFromHexcode(0x000000);
    newPwdLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:newPwdLabel];
    //输入新密码textField
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(120, 60, kScreenWidth - 170, 21)];
    _textField.placeholder = kLocalized(@"GYHD_HDNew_InputNewPwd");
    _textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _textField.font = [UIFont systemFontOfSize:14];
    _textField.delegate = self;
    _textField.tag = 1000;
    _textField.secureTextEntry = YES;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_textField];
    //线view
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 94, kScreenWidth, 1)];
    line1.backgroundColor = kCorlorFromHexcode(0xebebeb);
    [self.view addSubview:line1];
    //确认密码Label
    UILabel *confirmPwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 105, 100, 21)];
    confirmPwdLabel.text = kLocalized(@"GYHD_HDNew_ConfirmPwd");
    confirmPwdLabel.font = [UIFont systemFontOfSize:14];
    confirmPwdLabel.textColor = kCorlorFromHexcode(0x000000);
    [self.view addSubview:confirmPwdLabel];
    //再次输入新密码textField
    _textFieldAgain = [[UITextField alloc]initWithFrame:CGRectMake(120, 105, kScreenWidth - 170, 21)];
    _textFieldAgain.placeholder = kLocalized(@"GYHD_HDNew_AgainInputNewPwd");
      _textFieldAgain.clearButtonMode=UITextFieldViewModeWhileEditing;
    _textFieldAgain.font = [UIFont systemFontOfSize:14];
    _textFieldAgain.tag = 2000;
    _textFieldAgain.delegate = self;
    _textFieldAgain.secureTextEntry = YES;
    _textFieldAgain.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_textFieldAgain];
    //线View
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 140, kScreenWidth, 1)];
    line2.backgroundColor = kCorlorFromHexcode(0xebebeb);
    [self.view addSubview:line2];
    //确定Button
    _confrimBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 160, kScreenWidth - 60, 41)];
    _confrimBtn.titleLabel.textColor = [UIColor whiteColor];
    _confrimBtn.layer.cornerRadius = 15;
    _confrimBtn.clipsToBounds = YES;
    [_confrimBtn setTitle:kLocalized(@"GYHD_HDNew_Confirm") forState:UIControlStateNormal];
    if (self.entranceType == 1) {
        [_confrimBtn setBackgroundColor: [UIColor redColor]];
    }else{
        [_confrimBtn setBackgroundColor: kBtnBlue];
    }
    _confrimBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_confrimBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confrimBtn];
    //温馨提示Label
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 210, kScreenWidth - 60, 21)];
    tipLabel.text = kLocalized(@"GYHD_HDNew_ReminderTrandPwdIsMakeByEightNumber");
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = kCorlorFromHexcode(0x666666);
    [self.view addSubview:tipLabel];
}

#pragma mark --privateMethod
-(void)confirmClick
{
    self.nePassword = self.textField.text;
    self.confirmPassword = self.textFieldAgain.text;
    
    
    if ([GYUtils isBlankString:self.nePassword]) {
        [GYUtils showToast:kLocalized(@"输入新密码")];
        return;
    }
    else if ([GYUtils isBlankString:self.confirmPassword]) {
        [GYUtils showToast:kLocalized(@"再次输入新密码")];
        return;
    }
    if (self.nePassword.length != 8 || !self.nePassword) {
        [GYUtils showMessage:kLocalized(@"GYHD_HDNew_PleaseInputNewEightTrandsPwd")];
        return;
    }
    if (![self.nePassword isEqualToString:self.confirmPassword]) {
        [GYUtils showMessage:kLocalized(@"GYHD_HDNew_NewTrandsPwdAndConfirmPwdNoMatch")];
        return;
    }
    if ([self.confirmPassword isSimpleTransPwd] == NSOrderedStringSame) {
        [GYUtils showMessage:kLocalized(@"GYHD_HDNew_PleaseDonotSetSameNumberPasswordReset")];
        return;
    }
    if ([self.nePassword isSimpleTransPwd] == NSOrderedStringAscending || [self.confirmPassword isSimpleTransPwd] == NSOrderedStringDescending) {
        [GYUtils showMessage:kLocalized(@"GYHD_HDNew_PwdNoSetContinueNmuberPleaseReset")];
        return;
    }
    [self requestData];
}

-(void)requestData
{
    NSMutableDictionary* allParas = [NSMutableDictionary dictionary];
    [allParas setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"custId"];
    [allParas setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"operCustId"];
    NSString *urlString ;
    urlString = kHSsetTradePwdUrlString;
    [allParas setValue:kSaftToNSString([self.nePassword md5String]) forKey:@"tradePwd"];
    [allParas setValue:kSaftToNSString(globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard) forKey:@"userType"];
    GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:urlString parameters:allParas requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
}

#pragma mark --GYNetRequest
-(void)netRequest:(GYNetRequest *)request didSuccessWithData:(NSDictionary *)responseObject
{
    NSString *msg;
    msg=kLocalized(@"GYHD_HDNew_SetTrandsPwdSuccess");
    UIColor *color;
    if (self.entranceType == 1) {
         color = kNavigationBarColor;
    }else{
         color = kBtnBlue;
    }
    [GYUtils showMessage:msg confirm:^{
        [self.view.superview.superview removeFromSuperview];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"setTransPwdSuccessNotification" object:nil
         ];
    } withColor:color];
    
}

#pragma mark - UItextFieldDelegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    if (textField.tag == 1000) {
        NSString* toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        unsigned long len = toBeString.length;
        if (textField) {
            if (len > 8)
                return NO;
        }
    }else{
        
        NSString* toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        unsigned long len = toBeString.length;
        if (textField) {
            if (len > 8)
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
