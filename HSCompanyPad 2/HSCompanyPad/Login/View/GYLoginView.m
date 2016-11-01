//
//  GYLoginView.m
//  HSCompanyPad
//
//  Created by User on 16/8/1.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYLoginView.h"
#import <GYKit/UIView+Extension.h>
#import "GYForgetPassView.h"
#import <GYKit/GYUtils.h>
#import "GYLoginHttpTool.h"
#import "GYMainViewController.h"
#import "AppDelegate.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <GYKit/CALayer+Transition.h>
#import "GYChangeEnView.h"

@interface GYLoginView ()
#define kLineHeight 50
#define kLoginMargin 30
@property (nonatomic, assign) LoginType type; //登录类型
@property (weak, nonatomic) IBOutlet UISegmentedControl* segment; //账号切换
@property (weak, nonatomic) IBOutlet UILabel* wrongPassLabel; //错误密码提示
@property (weak, nonatomic) IBOutlet UIView* cardBackView; //互生号背景view
@property (weak, nonatomic) IBOutlet UIView* pNumBackView;
@property (weak, nonatomic) IBOutlet UIView* passwordBackView;
@property (weak, nonatomic) IBOutlet UIButton* logBtn;
@property (weak, nonatomic) IBOutlet UITextField* companyHsCardTF; //企业互生号
@property (weak, nonatomic) IBOutlet UITextField* numberTF; //员工操作号
@property (weak, nonatomic) IBOutlet UITextField* passwordTF; //登录密码输入
@property (weak, nonatomic) IBOutlet UIImageView* cardImageView;
@property (weak, nonatomic) IBOutlet UIImageView* personImageView;
@property (weak, nonatomic) IBOutlet UIImageView* passImageView;
@property (weak, nonatomic) IBOutlet UIButton* changeBtn; //切换环境按钮
@property (weak, nonatomic) IBOutlet UIButton* loginBtn; //登录按钮
@property (weak, nonatomic) IBOutlet UIButton* forgetBtn; //忘记密码按钮
@end
@implementation GYLoginView



- (void)awakeFromNib
{
    [super awakeFromNib];

    CGRect segmentFrame = self.segment.frame;
    
    segmentFrame.size.height = 45;
    
    [self.segment setFrame:segmentFrame];
    
    NSMutableAttributedString* attr = [[NSMutableAttributedString alloc]
        initWithString:kLocalized(@"GYHS_Login_Login_Password_Error")];
    NSTextAttachment* imageMent = [[NSTextAttachment alloc] init];
    
    imageMent.image = kLoadPng(@"gy_error_red");
    imageMent.bounds = CGRectMake(2, -5, 20, 20);
    
    NSAttributedString* imageAttr =
        [NSAttributedString attributedStringWithAttachment:imageMent];
        
    [attr insertAttributedString:imageAttr atIndex:0];
    
    self.wrongPassLabel.attributedText = attr;
    _companyHsCardTF.delegate = self;
    
    _numberTF.delegate = self;
    _passwordTF.delegate = self;
    
    _logBtn.layer.cornerRadius = 6;
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:NO];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    self.type = kLoginCompanyType;
    
    if (kGetNSUser(GYLoginResNoKey)) {
        _companyHsCardTF.text = kGetNSUser(GYLoginResNoKey)[@"resNo"];
        _numberTF.text = kGetNSUser(GYLoginResNoKey)[@"userName"];
    }
}

#pragma mark -method

- (void)updateConstraints
{
    [super updateConstraints];
    _cardBackView.customBorderType = UIViewCustomBorderTypeAll;
    _pNumBackView.customBorderType = UIViewCustomBorderTypeAll;
    _passwordBackView.customBorderType = UIViewCustomBorderTypeAll;
    _cardImageView.customBorderType = UIViewCustomBorderTypeRight;
    _personImageView.customBorderType = UIViewCustomBorderTypeRight;
    _passImageView.customBorderType = UIViewCustomBorderTypeRight;

}
- (void)show
{
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIViewController* rootVC = delegate.window.rootViewController;
    UIView* maskView = [[UIView alloc] initWithFrame:rootVC.view.bounds];
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f];
    [rootVC.view addSubview:maskView];
    [self.layer bouceAnimation];
    [maskView addSubview:self];
    [self setCenter:maskView.center];
    @weakify(self);
    [self mas_updateConstraints:^(MASConstraintMaker* make) {
         @strongify(self);
        make.top.mas_equalTo(97);
        make.width.mas_equalTo(500);
        make.centerX.equalTo(self.superview.mas_centerX);
        make.bottom.mas_equalTo(-45);
    }];
}

- (IBAction)dimissBtnAction:(id)sender
{

    [self dismiss];
}

- (void)dismiss
{

    if (self.superview) {
    
        [self.superview removeFromSuperview];
    }
    [self removeFromSuperview];
}
- (IBAction)changeSegment:(id)sender
{

    UISegmentedControl* curSegment = (UISegmentedControl*)sender;
    
    if (curSegment.selectedSegmentIndex == 0) {
        //选中企业互生号登录
        self.type = kLoginCompanyType;
        
        [self.passwordBackView mas_remakeConstraints:^(MASConstraintMaker* make) {
        
            make.top.equalTo(self.pNumBackView.mas_bottom).offset(20);
            
            make.left.width.height.equalTo(self.pNumBackView);
            
        }];
        self.companyHsCardTF.placeholder = kLocalized(@"GYHS_Login_Please_Input_ResNO");
        self.pNumBackView.hidden = NO;
    }
    else {
        //互生号登录
        self.type = kLoginHSCardType;
        
        [self.passwordBackView mas_remakeConstraints:^(MASConstraintMaker* make) {
        
            make.left.right.top.bottom.equalTo(self.pNumBackView);
            
        }];
        self.companyHsCardTF.placeholder = kLocalized(@"GYHS_Login_Please_Input_ResNO_Card");
        
        self.pNumBackView.hidden = YES;
    }
    
    [self layoutIfNeeded];
}

//忘记密码
- (IBAction)forgetPassAction:(id)sender
{

    [self dismiss];
    [GYForgetPassView show];
}
//点击登录
- (IBAction)loginAction:(id)sender
{

    if (self.type == kLoginCompanyType) {
    
        if (self.companyHsCardTF.text.length != 11) {
            [self.companyHsCardTF tipWithContent:kLocalized(@"GYHS_Login_Please_Input_ResNO_Eleven") animated:YES];
            
            [self shakeLoginView];
            return;
        }
        if ([GYUtils isServiceHSCardNo:self.companyHsCardTF.text]) {
            [self.companyHsCardTF tipWithContent:kLocalized(@"GYHS_Login_DoNotSupportServiceCompanyAccountLogin") animated:YES];
            [self shakeLoginView];
            return;
        }
        
        if (self.numberTF.text.length != 4) {
            [self.numberTF tipWithContent:kLocalized(@"GYHS_Login_Please_Input_UserName_Four") animated:YES];
            [self shakeLoginView];
            return;
        }
        
        if (self.passwordTF.text.length != 6) {
            [self.passwordTF tipWithContent:kLocalized(@"GYHS_Login_Please_Input_Login_Password_Six") animated:YES];
            [self shakeLoginView];
            return;
        }
        if ([self.delegate respondsToSelector:@selector(loginView:resNo:userName:password:)]) {
            [self.delegate loginView:self resNo:self.companyHsCardTF.text userName:self.numberTF.text password:self.passwordTF.text];
        }
    }
    else {
    
        //判断用户密码合法性
        if (self.companyHsCardTF.text.length != 11) {
            [self.companyHsCardTF tipWithContent:kLocalized(@"GYHS_Login_Please_Input_Login_Ent_ResNO_Eleven") animated:YES];
            [self shakeLoginView];
            return;
        }
        
        if (self.passwordTF.text.length != 6) {
            [self.passwordTF tipWithContent:kLocalized(@"GYHS_Login_Please_Input_Login_Password_Six") animated:YES];
            [self shakeLoginView];
            return;
        }
        if ([self.delegate respondsToSelector:@selector(loginView:resNo:userName:password:)]) {
            [self.delegate loginView:self resNo:self.companyHsCardTF.text userName:nil password:self.passwordTF.text];
        }
    }
}


- (void)shakeLoginView
{
    [self.layer shakeAnimation];
}

- (void)showWrongLabel
{

    self.wrongPassLabel.hidden = NO;
}
- (void)hideWrongLabel
{
    self.wrongPassLabel.hidden = YES;
}

#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField*)textField
{

    if (self.companyHsCardTF.isEditing) {
    
        self.cardBackView.layer.borderColor = [UIColor blueColor].CGColor;
        self.pNumBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.passwordBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    else if (self.numberTF.isEditing) {
    
        self.cardBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.pNumBackView.layer.borderColor = [UIColor blueColor].CGColor;
        self.passwordBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    else if (self.passwordTF.isEditing) {
    
        self.cardBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.pNumBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.passwordBackView.layer.borderColor = [UIColor blueColor].CGColor;
    }
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{

    NSString* toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (![toBeString isValidNumber]) {
        return NO;
    }
    
    if ([textField isEqual:self.companyHsCardTF] && toBeString.length > 11) {
        [self endEditing:YES];
        return NO;
    }
    
    else if ([textField isEqual:self.numberTF] && toBeString.length > 4) {
    
        [self endEditing:YES];
        return NO;
    }
    
    else if ([textField isEqual:self.passwordTF] && toBeString.length > 6) {
    
        [self endEditing:YES];
        return NO;
    }
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.passwordTF) {
        [self loginAction:nil];
    }
    return YES;
}

- (IBAction)changeEnv:(id)sender
{
    GYChangeEnView* view = [[GYChangeEnView alloc] initWithFrame:self.bounds];
    [self addSubview:view];
    [view.layer bouceAnimation];
}

- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
    [self endEditing:YES];
}

@end
