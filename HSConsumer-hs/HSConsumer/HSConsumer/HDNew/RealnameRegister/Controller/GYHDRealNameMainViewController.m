//
//  GYHSRealNameMainViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDRealNameMainViewController.h"
#import "GYHDRealNameRegisterViewController.h"
#import "Masonry.h"
#import "GYHDRealNameRegisterSuccessViewController.h"
#import "GYHDRealNameWithPassportAuthViewController.h"
#import "GYHDRealNameWithLicenceAuthViewController.h"
#import "GYHDRealNameWithIdentifyAuthViewController.h"
#import "GYHSTools.h"
#import "GYHDRealNameAuthConfirmViewController.h"
#import "GYHDRealNameAuthWaitingAuditViewController.h"

@interface GYHDRealNameMainViewController ()<GYHDRegisterRightnowDelegate,GYHDContinueAuthenticationDelegate,GYHDIdentifyAuthDelegate,GYHDPassportAuthDelegate,GYHDLicenceAuthDelegate,GYHDAuthConfirmDelegate,GYHDAgainAuthcenticationDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *progressBarImageView;
@property (weak, nonatomic) IBOutlet UIView *childView;
@property (weak, nonatomic) IBOutlet UILabel *authenticationLb;
@property (weak, nonatomic) IBOutlet UILabel *waitingAuditLb;
@property (weak, nonatomic) IBOutlet UILabel *reviewResultsLb;

@property (nonatomic,strong)UIViewController *currentVC;
//实名注册子控制器
@property (nonatomic,strong)GYHDRealNameRegisterViewController *realNameRegisterVC;
@property (nonatomic,strong)GYHDRealNameRegisterSuccessViewController *registerSuccessVC;
//实名认证
@property (nonatomic,strong)GYHDRealNameWithPassportAuthViewController *passportAuthVC;
@property (nonatomic,strong)GYHDRealNameWithLicenceAuthViewController *licenceAuthVC;
@property (nonatomic,strong)GYHDRealNameWithIdentifyAuthViewController *identifyAuthVC;
@property (nonatomic,strong)GYHDRealNameAuthConfirmViewController *authConfirmVC;
//实名认证待审核
@property (nonatomic,strong)GYHDRealNameAuthWaitingAuditViewController *waitingAuditVC;
@property (nonatomic,strong)GYHDRealNameRegisterSuccessViewController *certificationSuccessVC;

@end

@implementation GYHDRealNameMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    self.title = kLocalized(@"GYHD_HDNew_RealNameRegister");
    self.view.backgroundColor = [UIColor whiteColor];
    if ([globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusNoRes]) {
        [self addSonViewController:self.realNameRegisterVC];
        [self.realNameRegisterVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self.childView);
        }];
        return;
    }else if ([globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusHadCertify]){
        [self addSonViewController:self.certificationSuccessVC];
        [self.certificationSuccessVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self.childView);
        }];
         self.progressBarImageView.image = [UIImage imageNamed:@"gyhd_progress_bar4"];
        self.authenticationLb.textColor = kSelectedRed;
        self.waitingAuditLb.textColor = kSelectedRed;
        self.reviewResultsLb.textColor = kSelectedRed;
        return;
    }
    [self getRealNameAuthStatusGotoRelateController];
}
-(void)setNav
{
    self.navigationController.navigationBar.barTintColor = kNavigationBarColor;
    NSMutableDictionary* attDict = [NSMutableDictionary dictionary];
    attDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:attDict];
    UIImageView* leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    leftImage.contentMode = UIViewContentModeScaleAspectFit;
    leftImage.image = [UIImage imageNamed:@"gycommon_nav_back"];
    leftImage.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapSetting = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backClickBtn)];
    [leftImage addGestureRecognizer:tapSetting];
    UIBarButtonItem* leftBackBtn = [[UIBarButtonItem alloc] initWithCustomView:leftImage];
    self.navigationItem.leftBarButtonItem = leftBackBtn;
}
-(void)backClickBtn
{
    for (UIView *view in self.childView.subviews) {
        if (view == self.authConfirmVC.view) {
            [self  goRealnameAuthentication];
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
   
}
#pragma mark -- //查询实名认证状态
- (void)getRealNameAuthStatusGotoRelateController
{
    //实名认证状态查询
    NSMutableDictionary* allParas = [NSMutableDictionary dictionary];
    [allParas setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"perCustId"];
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kQueryRealNameAuthInfoUrlString parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary *dicData = responseObject[@"data"];
        if (([dicData isKindOfClass:[NSNull class]] || dicData == nil || dicData.count == 0)) {
            if ([globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusHadRes]){
                self.registerSuccessVC = nil;
                [self addSonViewController:self.registerSuccessVC];
                [self.registerSuccessVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.right.equalTo(self.childView);
                }];
            }
            return;
        }
        //已经实名注册，查询实名认证信息
        globalData.personInfo.creFaceImg = kSaftToNSString(dicData[@"cerpica"]);
        globalData.personInfo.creBackImg = kSaftToNSString(dicData[@"cerpicb"]);
        globalData.personInfo.creHoldImg = kSaftToNSString(dicData[@"cerpich"]);
        //审核通过
        if ([dicData[@"status"] isEqualToNumber:@2]) {
            [self addSonViewController:self.certificationSuccessVC];
            [self.certificationSuccessVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.equalTo(self.childView);
            }];
            self.progressBarImageView.image = [UIImage imageNamed:@"gyhd_progress_bar4"];
            self.authenticationLb.textColor = kSelectedRed;
            self.waitingAuditLb.textColor = kSelectedRed;
            self.reviewResultsLb.textColor = kSelectedRed;
            //审核中
        } else if ([dicData[@"status"] isEqualToNumber:@0] || [dicData[@"status"] isEqualToNumber:@1]) {
            self.progressBarImageView.image = [UIImage imageNamed:@"gyhd_progress_bar3"];
            self.authenticationLb.textColor = kSelectedRed;
            self.waitingAuditLb.textColor = kSelectedRed;
            self.waitingAuditVC = nil;
            [self addSonViewController:self.waitingAuditVC];
            [self.waitingAuditVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.equalTo(self.childView);
            }];
            self.waitingAuditVC.reviewStatus =  kRealNameAuthStatusApproveWait;
            //驳回 //复审驳回
        } else if ([dicData[@"status"] isEqualToNumber:@3] || [dicData[@"status"] isEqualToNumber:@4]) {
            self.progressBarImageView.image = [UIImage imageNamed:@"gyhd_progress_bar4"];
            self.authenticationLb.textColor = kSelectedRed;
            self.waitingAuditLb.textColor = kSelectedRed;
            self.reviewResultsLb.textColor = kSelectedRed;
            self.waitingAuditVC = nil;
            [self addSonViewController:self.waitingAuditVC];
            [self.waitingAuditVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.equalTo(self.childView);
            }];
            self.waitingAuditVC.reviewStatus =  kRealNameAuthStatusApproveRefuse;
            self.waitingAuditVC.refuseReason = dicData[@"apprContent"];
        }
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

#pragma  mark -- GYHDRegisterRightnowDelegate
-(void)RightnowRegister
{
    self.registerSuccessVC = nil;
    [self addSonViewController:self.registerSuccessVC];
    [self.registerSuccessVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.childView);
    }];
}
#pragma mark -- GYHDContinueAuthenticationDelegate继续认证
-(void)ContinueAuthentication
{
    self.progressBarImageView.image = [UIImage imageNamed:@"gyhd_progress_bar2"];
    self.authenticationLb.textColor = kSelectedRed;
    [self goRealnameAuthentication];
}
-(void)goRealnameAuthentication
{
    if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify]) {
        [self addSonViewController:self.identifyAuthVC];
        [self.identifyAuthVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self.childView);
        }];
    }
    else if ([globalData.loginModel.creType isEqualToString:kCertypePassport]) {
        [self addSonViewController:self.passportAuthVC];
        [self.passportAuthVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self.childView);
        }];
    }
    else {
        [self addSonViewController:self.licenceAuthVC];
        [self.licenceAuthVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self.childView);
        }];
    }
}
#pragma mark -- 实名认证下一步 身份证  护照  营业执照
-(void)identifyAuth:(NSMutableDictionary *)dictInside
{
    [self addSonViewController:self.authConfirmVC];
    self.authConfirmVC.dictInside = dictInside;
    [self.authConfirmVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.childView);
    }];
}
-(void)passportAuth:(NSMutableDictionary *)dictInside
{
    [self addSonViewController:self.authConfirmVC];
    self.authConfirmVC.dictInside = dictInside;
    [self.authConfirmVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.childView);
    }];
}
-(void)licenceAuth:(NSMutableDictionary *)dictInside
{
    [self addSonViewController:self.authConfirmVC];
    self.authConfirmVC.dictInside = dictInside;
    [self.authConfirmVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.childView);
    }];
}
#pragma mark -- GYHDAuthConfirmDelegate 提交实名认证成功
-(void)confirmRealNameAuth
{
    self.authenticationLb.textColor = kSelectedRed;
    self.waitingAuditLb.textColor = kSelectedRed;
    self.waitingAuditVC = nil;
    [self addSonViewController:self.waitingAuditVC];
    self.progressBarImageView.image = [UIImage imageNamed:@"gyhd_progress_bar3"];
    [self.waitingAuditVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.childView);
    }];
}
#pragma mark -- GYHDAgainAuthcenticationDelegate  重新申请认证
-(void)againAuth
{
    self.waitingAuditLb.textColor = kGrayLbCorlor;
    self.reviewResultsLb.textColor = kGrayLbCorlor;
    self.progressBarImageView.image = [UIImage imageNamed:@"gyhd_progress_bar2"];
    [self goRealnameAuthentication];
}
#pragma mark - private methods
- (void)addSonViewController:(UIViewController*)vc
{
    if (self.currentVC == vc) {
        return;
    }
    self.currentVC = vc;
    if (self.childViewControllers.count >= 1) {
        for (UIViewController* v in self.childViewControllers) {
            [v.view removeFromSuperview];
            [v removeFromParentViewController];
        }
    }
    vc.view.frame = self.childView.bounds;
    [self addChildViewController:vc];
    [self.childView addSubview:vc.view];
}
#pragma mark -- 懒加载
//实名注册
-(GYHDRealNameRegisterViewController*)realNameRegisterVC
{
    if (!_realNameRegisterVC) {
        _realNameRegisterVC = [[GYHDRealNameRegisterViewController alloc] init];
        _realNameRegisterVC.rightnowDelegate = self;
    }
    return _realNameRegisterVC;
}
//实名注册成功
-(GYHDRealNameRegisterSuccessViewController*)registerSuccessVC
{
    if (!_registerSuccessVC) {
        _registerSuccessVC = [[GYHDRealNameRegisterSuccessViewController alloc] init];
       _registerSuccessVC.continueDelegate = self;
    }
    return _registerSuccessVC;
}
//实名认证
-(GYHDRealNameWithIdentifyAuthViewController*)identifyAuthVC
{
    if (!_identifyAuthVC) {
        _identifyAuthVC = [[GYHDRealNameWithIdentifyAuthViewController alloc] init];
        _identifyAuthVC.identifyDelegate = self;
    }
    return _identifyAuthVC;
}
-(GYHDRealNameWithLicenceAuthViewController*)licenceAuthVC
{
    if (!_licenceAuthVC) {
        _licenceAuthVC = [[GYHDRealNameWithLicenceAuthViewController alloc] init];
        _licenceAuthVC.licenceDelegate = self;
    }
    return _licenceAuthVC;
}
-(GYHDRealNameWithPassportAuthViewController*)passportAuthVC
{
    if (!_passportAuthVC) {
        _passportAuthVC = [[GYHDRealNameWithPassportAuthViewController alloc] init];
        _passportAuthVC.passportDelegate = self;
    }
    return _passportAuthVC;
}
//实名认证下一步
-(GYHDRealNameAuthConfirmViewController*)authConfirmVC
{
    if (!_authConfirmVC) {
        _authConfirmVC = [[GYHDRealNameAuthConfirmViewController alloc] init];
        _authConfirmVC.confirmDelegate = self;
    }
    return _authConfirmVC;
}
//实名认证待审核
-(GYHDRealNameAuthWaitingAuditViewController*)waitingAuditVC
{
    if (!_waitingAuditVC) {
        _waitingAuditVC = [[GYHDRealNameAuthWaitingAuditViewController alloc] init];
        _waitingAuditVC.againAuthDelegate = self;
    }
    return _waitingAuditVC;
}
//实名认证成功
-(GYHDRealNameRegisterSuccessViewController*)certificationSuccessVC
{
    if (!_certificationSuccessVC) {
        _certificationSuccessVC = [[GYHDRealNameRegisterSuccessViewController alloc] init];
    }
    return _certificationSuccessVC;
}

@end
