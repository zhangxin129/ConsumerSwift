//
//  GYHPwdRegistMainVC.m
//  HSConsumer
//
//  Created by wangfd on 16/9/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHPwdRegistMainVC.h"
#import "GYHSRedSelectBtn.h"
#import "GYHSTools.h"
#import "GYHSForgotPasswdVC.h"
#import "GYHSUserRegisterVC.h"
#import "GYHSResetPasswordVC.h"

@interface GYHPwdRegistMainVC () <GYHSForgotPasswdVCDelegate>

@property (weak, nonatomic) IBOutlet GYHSRedSelectBtn* pwdBtn;
@property (weak, nonatomic) IBOutlet GYHSRedSelectBtn* registerBtn;

@property (weak, nonatomic) IBOutlet UIView* titleBGView;
@property (weak, nonatomic) IBOutlet UIView* contentView;

@property (nonatomic, strong) UIViewController* currentVC;
@property (nonatomic, strong) GYHSForgotPasswdVC* pwdVC;
@property (nonatomic, strong) GYHSUserRegisterVC* registerVC;
@property (nonatomic, strong) GYHSResetPasswordVC* resetPwd;

@property (nonatomic, assign) BOOL isPwdSelected;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* pwdBtnLeftConstrains;

@end

@implementation GYHPwdRegistMainVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)pwdAction:(UIButton*)sender
{
    if (sender.selected && (sender.selected == self.isPwdSelected)) {
        return;
    }
    self.isPwdSelected = YES;

    sender.selected = !sender.selected;
    self.registerBtn.selected = NO;
    [self addSonViewController:self.pwdVC];
}

- (IBAction)registerBtn:(UIButton*)sender
{
    if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
        return;
    }

    if (sender.selected && (sender.selected != self.isPwdSelected)) {
        return;
    }
    self.isPwdSelected = NO;

    sender.selected = !sender.selected;
    self.pwdBtn.selected = NO;

    [self addSonViewController:self.registerVC];
}

#pragma mark - GYHSForgotPasswdVCDelegate
- (void)toRestPwdPage:(BOOL)isFindPwdByPhone dataDic:(NSMutableDictionary*)dataDic
{
    self.resetPwd.isFindPwdByPhone = isFindPwdByPhone;

    if (isFindPwdByPhone) {
        self.resetPwd.pwdByPhoneDic = dataDic;
    }
    else {
        self.resetPwd.pwdByQuestionDic = dataDic;
    }

    [self addSonViewController:self.resetPwd];
}

#pragma mark - private
- (void)initView
{
    self.isPwdSelected = YES;

    [self.pwdBtn setTitle:kLocalized(@"密码找回") forState:UIControlStateNormal];
    [self.pwdBtn setTitleColor:kSelectedRed forState:UIControlStateSelected];
    self.pwdBtn.titleLabel.font = kfont(14);

    self.pwdBtn.selected = YES;
    [self addSonViewController:self.pwdVC];

    if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
        self.pwdBtnLeftConstrains.constant = self.view.frame.size.width / 2 - 60;
        [self.registerBtn setTitle:kLocalized(@"") forState:UIControlStateNormal];
        [self.pwdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        self.pwdBtn.lineView.hidden = YES;
    }
    else {
        [self.registerBtn setTitle:kLocalized(@"非持卡人用户注册") forState:UIControlStateNormal];
        [self.registerBtn setTitleColor:kSelectedRed forState:UIControlStateSelected];
        self.registerBtn.titleLabel.font = kfont(14);
    }
}

- (void)addSonViewController:(UIViewController*)vc
{
    if (self.currentVC == vc) {
        return;
    }

    self.currentVC = vc;

    for (UIView* view in self.contentView.subviews) {
        if ([vc.view isEqual:view]) {

            [self.contentView bringSubviewToFront:vc.view];
            return;
        }
    }

    vc.view.frame = self.contentView.bounds;
    [self addChildViewController:vc];
    [self.contentView addSubview:vc.view];
}

#pragma mark - getter and setter
- (GYHSForgotPasswdVC*)pwdVC
{
    if (_pwdVC == nil) {
        _pwdVC = [[GYHSForgotPasswdVC alloc] init];
        _pwdVC.loginType = self.loginType;
        _pwdVC.popType = self.popType;
        _pwdVC.pageType = self.pageType;
        _pwdVC.delegate = self;
    }

    return _pwdVC;
}

- (GYHSUserRegisterVC*)registerVC
{
    if (_registerVC == nil) {
        _registerVC = [[GYHSUserRegisterVC alloc] init];
        _registerVC.pageType = self.pageType;
    }

    return _registerVC;
}

- (GYHSResetPasswordVC*)resetPwd
{
    if (_resetPwd == nil) {
        _resetPwd = [[GYHSResetPasswordVC alloc] init];
        _resetPwd.loginType = self.loginType;
        _resetPwd.popType = self.popType;
        _resetPwd.pageType = self.pageType;
    }

    return _resetPwd;
}

@end
