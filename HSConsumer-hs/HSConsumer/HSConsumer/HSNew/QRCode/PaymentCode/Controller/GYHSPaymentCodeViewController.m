//
//  GYHSPaymentCodeViewController.m
//  HSConsumer
//
//  Created by admin on 16/9/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSPaymentCodeViewController.h"
#import "GYHSPayLimitationSetViewController.h"
#import "GYHSPopView.h"
#import "GYHDSetTradingPasswordViewController.h"
#import "OneTimePayCode.h"
#import "YYKit.h"
#import "GYBigPic.h"
#include <stdio.h>
#import "GYHDMessageCenter.h"


@interface GYHSPaymentCodeViewController ()<GYHSPopViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *setBtn;
@property (weak, nonatomic) IBOutlet UILabel *codeNumberLb;
@property (weak, nonatomic) IBOutlet UIImageView *barCodeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *QrCodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *refreshLb;
@property (weak, nonatomic) IBOutlet UIView *setPassView;
@property (nonatomic,strong) NSTimer *time;//定时器
@property (nonatomic,assign) NSInteger informNumber;//截屏次数
@property (nonatomic,strong) GYBigPic *bigPic;
@end

@implementation GYHSPaymentCodeViewController
#pragma mark - The life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self generatePayCode];
    self.informNumber = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshCode)];
    self.refreshLb.userInteractionEnabled = YES;
    [self.refreshLb addGestureRecognizer:tap];
    [self.time isValid];
    //接收设置交易密码成功刷新页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadcheckInfoStatus) name:@"setTransPwdSuccessNotification" object:nil];
     [self loadcheckInfoStatusUrlString];
    
    self.bigPic = [[GYBigPic alloc] init];
    UITapGestureRecognizer *qrCodeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qrCodeTap)];
    self.QrCodeImageView.userInteractionEnabled = YES;
    [self.QrCodeImageView addGestureRecognizer:qrCodeTap];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userlicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self generatePayCode];
    //获取截屏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidTakeScreenshot:)
                                                 name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //将定时器停止，否则可能会内存泄漏
    [self.time invalidate];
    self.time = nil;
}
#pragma - mark 进入前台的通知
-(void)userlicationDidBecomeActive:(NSNotification *)notification
{
    [self generatePayCode];
}
#pragma mark - 放大二维码
-(void)qrCodeTap
{
    [self.bigPic showView:self.QrCodeImageView.image];
}

#pragma mark - 截屏的监听
- (void)userDidTakeScreenshot:(NSNotification *)notification
{
    self.informNumber++;
    if (self.informNumber > 1) {
        return;
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"为避免资金风险，请勿分享支付码，截屏后将自动消失。" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        alert.delegate = self;
    }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.informNumber = 0;
   [self generatePayCode];
}
#pragma mark - 生成二维码和条形码
-(void)generatePayCode
{
    NSString *destDirOC1;
    NSString *destDirOC2;
    if (globalData.loginModel.cardHolder) {
        destDirOC1 = @"21";
        destDirOC2 = globalData.loginModel.resNo;
    }else{
        destDirOC1 = @"22";
        destDirOC2 = globalData.loginModel.userName;
    }
   const char *destDir1 = [destDirOC1 UTF8String];
   const char *destDir2 = [destDirOC2 UTF8String];
    

    NSString *destDirOC3 = kSaftToNSString(globalData.loginModel.secretKey);
    if ([GYUtils isBlankString:destDirOC3]) {
        return;
    }
    const char *destDir3 = [destDirOC3 UTF8String];
    long eeee = globalData.loginModel.timeDifference;
    UInt64 t = ([[NSDate date] timeIntervalSince1970] * 1000 + eeee)/1000;

    char szKey[1024] = {0} ;
    
    if (GeneratePayCode(destDir1, destDir2, destDir3, t,szKey, sizeof(szKey)) !=0) {
        [self generatePayCode];
        return;
    }
    
    NSString *str = [NSString  stringWithUTF8String:szKey];
  
    self.barCodeImageView.image = [GYUtils creatBarCodeWithString:str size:self.barCodeImageView.frame.size];
    self.codeNumberLb.text = kSaftToNSString(str);
    self.QrCodeImageView.image = [GYUtils creatQRCodeWithURLString:str imageViewSize:self.QrCodeImageView.frame.size logoImage:[UIImage imageNamed:@"gyhs_payment_code_person_bg"] logoImageSize:CGSizeMake((2* self.QrCodeImageView.frame.size.width)/9, (2* self.QrCodeImageView.frame.size.width)/9) logoImageWithCornerRadius:0];
    
}
#pragma mark - 定时器
-(void)timerAction
{
     [self generatePayCode];
}
#pragma mark - 设置交易密码成功后重新加载设置支付限额弹出框
-(void)loadcheckInfoStatus
{
    self.setPassView.hidden = YES;
    self.setBtn.hidden = NO;
}

#pragma mark - 设置互生币支付限额(未设置交易密码)
- (IBAction)set:(id)sender {
    kCheckLoginedToRoot
    GYHSPopView *popView = [[GYHSPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    GYHSPayLimitationSetViewController* vc = [[GYHSPayLimitationSetViewController alloc] init];
    vc.tradingPasswordType = GYHSTradingPasswordTypeSet;
    popView.hiddenCloseBtn = YES;
    [popView showView:vc withViewFrame:CGRectMake(20, 30, kScreenWidth - 40, 390)];
}
#pragma mark - 设置互生币支付限额(已设置交易密码)
- (IBAction)setBtn:(id)sender {
    // kCheckLoginedToRoot
    GYHSPopView *popView = [[GYHSPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    GYHSPayLimitationSetViewController* vc = [[GYHSPayLimitationSetViewController alloc] init];
    vc.tradingPasswordType = GYHSTradingPasswordTypeModify;
    popView.hiddenCloseBtn = YES;
    [popView showView:vc withViewFrame:CGRectMake(20, 30, kScreenWidth - 40, 390)];
}
#pragma mark - 刷新
- (IBAction)refresh:(id)sender {
    kCheckLoginedToRoot
    [self.time invalidate];
     self.time = nil;
    [self.time isValid];
    [self generatePayCode];
}
-(void)refreshCode
{
    kCheckLoginedToRoot
    [self.time invalidate];
    self.time = nil;
    [self.time isValid];
    [self generatePayCode];
}
#pragma mark -  查看是否已设置交易密码
- (void)loadcheckInfoStatusUrlString
{
    NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
                            @"perResNo" : kSaftToNSString(globalData.loginModel.resNo),
                            @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard};
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kHScardcheckInfoStatusUrlString parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary *dic = responseObject[@"data"];
        if ([dic[@"isSetTradePwd"] isEqualToNumber:@1]) {
            self.setPassView.hidden = YES;
            self.setBtn.hidden = NO;
        }else{
            self.setPassView.hidden = NO;
            self.setBtn.hidden = YES;
        }
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(NSTimer*)time
{
    if (!_time) {
        _time = [NSTimer timerWithTimeInterval:60 target:self selector:@selector(generatePayCode) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_time forMode:NSDefaultRunLoopMode];
    }
    return _time;
}
@end
