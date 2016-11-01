//
//  GYHMainViewController.m
//  HSConsumer
//
//  Created by wangfd on 16/9/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSMainViewController.h"
#import "GYEasyBuyModel.h"
#import "GYHSCardInfoVC.h"
#import "GYHSCollectionCodeModel.h"
#import "GYHSExchangeHSBViewController.h"
#import "GYHSIntegralCodeViewController.h"
#import "GYHSLoginMainVC.h"
#import "GYHSMainHeaderView.h"
#import "GYHSMyAccountMainViewController.h"
#import "GYHSOrderPayConfirmVC.h"
#import "GYHSPaymentCodeViewController.h"
#import "GYHSQRPayModel.h"
#import "GYHSScanCodePaymentViewController.h"
#import "GYHSScanCodeTradeVoucherViewController.h"
#import "GYQRCodeReaderViewController.h"
#import "GYShopDescribeController.h"
#import "MJExtension.h"
#import "Masonry.h"
#import "GYHDMessageCenter.h"
#import "GYHSVoucherModel.h"

@interface GYHSMainViewController () <GYHSMainHeaderViewDelegate, GYQRCodeReaderDelegate, GYHSScanCodePaymentDelegate, GYHDMessageCenterDelegate>

@property (weak, nonatomic) IBOutlet UIView* headView;
@property (weak, nonatomic) IBOutlet UIView* contentView;
@property (nonatomic, strong) GYHSMainHeaderView* mainHeaderView;

@property (nonatomic, strong) UIViewController* currentVC;
@property (nonatomic, strong) GYQRCodeReaderViewController* scanCodeVC;
@property (nonatomic, strong) GYHSIntegralCodeViewController* integralCodeVC;
@property (nonatomic, strong) GYHSPaymentCodeViewController* paymentCodeVC;
@property (nonatomic, strong) GYHSExchangeHSBViewController* exchangeHSVC;
@property (nonatomic, strong) GYHSMyAccountMainViewController* accountMainVC;
@property (nonatomic, strong) GYHSLoginMainVC* loginVC;

@property (weak, nonatomic) IBOutlet UIButton* toMainBtn;
@property (nonatomic, assign) BOOL isViewDidLoad;
@property (nonatomic, assign) NSInteger codeType;

@end

@implementation GYHSMainViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isViewDidLoad = YES;

    [self.headView addSubview:self.mainHeaderView];

    if (!globalData.isLogined) {
        [self showLoginView];
    }
    else {
        [self.mainHeaderView resetSelectFlag:0];
        [self addSonViewController:self.accountMainVC];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucessedAction) name:kGYHSLoginMainVCLoginSucessedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toLoginMain) name:kGYHSToLoginMainVCNotification object:nil];
    [GYHDMessageCenter sharedInstance].delegate = self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.mainHeaderView.frame = CGRectMake(0, 0, kScreenWidth, 140);
    if (globalData.isLogined) {
        if (!globalData.loginModel.cardHolder) {
            self.mainHeaderView.integralCodeView.hidden = YES;
            CGRect rect = self.mainHeaderView.paymentCodeView.frame;
            rect.origin.x = kScreenWidth / 2 - kScreenWidth / 8;
            self.mainHeaderView.paymentCodeView.frame = rect;
        }
        else {
            CGRect rect = self.mainHeaderView.paymentCodeView.frame;
            self.mainHeaderView.paymentCodeView.frame = rect;
            rect.origin.x = kScreenWidth / 4;
            self.mainHeaderView.integralCodeView.hidden = NO;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.isViewDidLoad = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showMainView
{
    if (!self.isViewDidLoad) {
        DDLogDebug(@"The viewDidLoad is not run.");
        return;
    }

    [self.mainHeaderView resetSelectFlag:0];

    if (!globalData.isLogined) {
        [self showLoginView];
    }
    else {

        [self addSonViewController:self.accountMainVC];
        [self.accountMainVC showMainView];
    }
}

- (void)showLoginView
{
    if (!globalData.isLogined) {
        [self.mainHeaderView resetSelectFlag:0];
        [self addSonViewController:self.loginVC];
    }
}

#pragma mark - GYHSMainHeaderViewDelegate
- (void)sweepCodePayAction:(UIButton*)button
{
    if (!globalData.isLogined) {
        [self showLoginView];
    }
    else {
        if (![self cameraAvailable]) {
            [GYUtils showMessage:kLocalized(@"GYHS_Main_The_Device_Not_Support_The_Camera")];
            return;
        }
        [self addSonViewController:self.scanCodeVC];
        [self.scanCodeVC.view mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.left.right.equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView).offset(-35);
        }];
    }
}

- (void)paymentCodeAction:(UIButton*)button
{
    if (!globalData.isLogined) {
        [self showLoginView];
    }
    else {
        [self addSonViewController:self.paymentCodeVC];
    }
}

- (void)integralCodeAction:(UIButton*)button
{
    if (!globalData.isLogined) {
        [self showLoginView];
    }
    else {
        [self addSonViewController:self.integralCodeVC];
    }
}

#pragma mark-- 兑换互生币
- (void)exchangeHSMoneyAction:(UIButton*)button
{
    if (!globalData.isLogined) {
        [self showLoginView];
    }
    else {
        [self addSonViewController:self.exchangeHSVC];
        [self.exchangeHSVC.view mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.bottom.left.right.equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView).offset(-35);
        }];
    }
}

#pragma mark - GYQRCodeReaderDelegate
- (void)reader:(GYQRCodeReaderViewController*)reader didScanResult:(NSString*)result
{
    [reader stopScanning];
    [self settleQRScanString:result];
}

- (void)readerDidCancel:(GYQRCodeReaderViewController*)reader
{
}

#pragma mark - action
- (IBAction)toMain:(UIButton*)sender
{
    if (self.codeType == 1000) {
    }
    [self showMainView];
}

- (void)loginSucessedAction
{
    [self.accountMainVC refreshIsHaveCard];
    if (!globalData.loginModel.cardHolder) {
        self.mainHeaderView.integralCodeView.hidden = YES;
        CGRect rect = self.mainHeaderView.paymentCodeView.frame;
        rect.origin.x = kScreenWidth / 2 - kScreenWidth / 8;
        self.mainHeaderView.paymentCodeView.frame = rect;
    }
    else {
        self.mainHeaderView.integralCodeView.hidden = NO;
        CGRect rect = self.mainHeaderView.paymentCodeView.frame;
        rect.origin.x = kScreenWidth / 4;
        self.mainHeaderView.paymentCodeView.frame = rect;
    }
    [self toMain:nil];
}

- (void)toLoginMain
{
    [self showLoginView];
}

#pragma mark - private methods
- (void)addSonViewController:(UIViewController*)vc
{
    if (self.currentVC == vc) {
        return;
    }

    self.currentVC = vc;
    self.codeType = 2000;
    self.toMainBtn.hidden = NO;
    if (self.childViewControllers.count >= 1) {
        for (UIViewController* v in self.childViewControllers) {
            [v.view removeFromSuperview];
            [v removeFromParentViewController];
        }
    }

    vc.view.frame = self.contentView.bounds;
    [self addChildViewController:vc];
    [self.contentView addSubview:vc.view];

    if (vc != self.accountMainVC && vc != self.loginVC) {
        [self.contentView bringSubviewToFront:_toMainBtn];
    }
}

- (BOOL)cameraAvailable
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied || ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return NO;
    }

    return YES;
}

#pragma mark - getter and setter
- (GYHSMainHeaderView*)mainHeaderView
{
    if (!_mainHeaderView) {
        _mainHeaderView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHSMainHeaderView class]) owner:self options:nil].lastObject;
        _mainHeaderView.delegate = self;
    }

    return _mainHeaderView;
}

- (GYQRCodeReaderViewController*)scanCodeVC
{
    if (_scanCodeVC == nil) {

        _scanCodeVC = [[GYQRCodeReaderViewController alloc] init];
        _scanCodeVC.modalPresentationStyle = UIModalPresentationFormSheet;
        _scanCodeVC.limitTopMagin = 140;
        _scanCodeVC.delegate = self;
        _scanCodeVC.hidesBottomBarWhenPushed = YES;
    }

    return _scanCodeVC;
}

- (GYHSIntegralCodeViewController*)integralCodeVC
{
    if (_integralCodeVC == nil) {
        _integralCodeVC = [[GYHSIntegralCodeViewController alloc] init];
    }

    return _integralCodeVC;
}

- (GYHSPaymentCodeViewController*)paymentCodeVC
{
    if (_paymentCodeVC == nil) {
        _paymentCodeVC = [[GYHSPaymentCodeViewController alloc] init];
    }

    return _paymentCodeVC;
}

- (GYHSExchangeHSBViewController*)exchangeHSVC
{
    if (_exchangeHSVC == nil) {
        _exchangeHSVC = [[GYHSExchangeHSBViewController alloc] init];
    }

    return _exchangeHSVC;
}

- (GYHSMyAccountMainViewController*)accountMainVC
{
    if (_accountMainVC == nil) {
        _accountMainVC = [[GYHSMyAccountMainViewController alloc] init];
    }

    return _accountMainVC;
}

- (GYHSLoginMainVC*)loginVC
{
    if (_loginVC == nil) {
        _loginVC = [[GYHSLoginMainVC alloc] init];
        _loginVC.popType = GYHSLoginVCNoShowPopView;
        _loginVC.pageType = GYHSLoginVCPageTypeHS;
        _loginVC.loginType = GYHSLoginViewControllerTypeHashsCard;
    }

    return _loginVC;
}

#pragma mark - 处理二维码字符串
- (void)settleQRScanString:(NSString*)scranString
{

    WS(weakSelf)
    // 商城生成的二维码
    if (([scranString hasPrefix:@"https://"] && [GYUtils isValidNumber:[scranString substringWithRange:NSMakeRange(8, 11)]]) || ([scranString hasPrefix:@"http://"] && [GYUtils isValidNumber:[scranString substringWithRange:NSMakeRange(7, 11)]])) { //企业端生成的二维码
        NSString* hsreNo = @"";
        if ([scranString hasPrefix:@"https://"]) {
            hsreNo = [scranString substringWithRange:NSMakeRange(8, 11)];
        }
        else {
            hsreNo = [scranString substringWithRange:NSMakeRange(7, 11)];
        }
        [GYGIFHUD show];
        GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:GetVShopShortlyInfoUrl
                                                         parameters:@{ @"key" : globalData.loginModel.token,
                                                             @"resourceNo" : hsreNo }
                                                      requestMethod:GYNetRequestMethodGET
                                                  requestSerializer:GYNetRequestSerializerJSON
                                                       respondBlock:^(NSDictionary* responseObject, NSError* error) {
                [GYGIFHUD dismiss];
                if (error) {
                    NSInteger  errorRetCode = [error code];
                    if ( errorRetCode == 220)
                    {
                        [GYUtils showToast:kLocalized(@"GYHS_Main_POS_This_Deal_Paid")];
                    } else {
                        DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
                        [GYUtils parseNetWork:error resultBlock:nil];
                    }
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    [self.scanCodeVC startScanning];
                    return ;
                }
                GYShopDescribeController* vc = [[GYShopDescribeController alloc] init];
                ShopModel* model = [[ShopModel alloc] init];
                model.strVshopId = responseObject[@"data"][@"vShopId"];
                vc.shopModel = model;
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];

                                                       }];
        [request commonParams:[GYUtils netWorkCommonParams]];
        [request start];
    }
    //互生卡号
    else if (scranString.length == 14 && [scranString hasPrefix:@"ID"]) {

        scranString = [scranString substringFromIndex:3];
        GYHSCardInfoVC* cardInfoVc = [[GYHSCardInfoVC alloc] init];
        cardInfoVc.cardNumber = scranString;
        [weakSelf.navigationController pushViewController:cardInfoVc animated:YES];
    }
    //pos机订单支付(旧)
    else if (scranString.length == 192) {
        if (globalData.loginModel.cardHolder) {
            [GYGIFHUD show];
            GYNetRequest* requset = [[GYNetRequest alloc] initWithBlock:[HSReconsitutionUrl stringByAppendingString:@"/common/qrCodePay"]
                                                             parameters:@{ @"str" : scranString }
                                                          requestMethod:GYNetRequestMethodPOST
                                                      requestSerializer:GYNetRequestSerializerJSON
                                                           respondBlock:^(NSDictionary* responseObject, NSError* error) {
                    [GYGIFHUD dismiss];
                    if (error) {
                        NSInteger  errorRetCode = [error code];
                        if ( errorRetCode == 220)
                        {
                            [GYUtils showToast:kLocalized(@"GYHS_Main_POS_This_Deal_Paid")];
                        } else {
                            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", requset.URLString, (long)[error code], [error localizedDescription]);
                            [GYUtils parseNetWork:error resultBlock:nil];
                        }
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                        [self.scanCodeVC startScanning];
                        return;
                    }
                    GYHSQRPayModel* model = [GYHSQRPayModel mj_objectWithKeyValues:responseObject[@"data"]];

                    GYHSScanCodePaymentViewController* scanVc = [[GYHSScanCodePaymentViewController alloc] init];
                    scanVc.payModel = model;
                    scanVc.delegate = self;
                    scanVc.paymentState = GYHSOldPaymentWay;
                    scanVc.codeType = [scranString substringToIndex:2];
                    [weakSelf addSonViewController:scanVc];
                    self.toMainBtn.hidden = YES;
                                                           }];
            [requset commonParams:[GYUtils netWorkCommonParams]];
            [requset start];
        }
        else {

            [GYUtils showToast:kLocalized(@"GYHS_Main_Please_Again_After_Logging_Using_Alternate_Number")];
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [self.scanCodeVC startScanning];
        }
    }
    //pos机订单支付(新)
    else if (scranString.length > 192 && [scranString hasPrefix:@"B1"]) {
        if (globalData.loginModel.cardHolder) {
            [GYGIFHUD show];
            GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:[HSReconsitutionUrl stringByAppendingString:@"/custCard/qrCodePay"] parameters:@{ @"str" : scranString } requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
                    [GYGIFHUD dismiss];
                    if (error) {
                        NSInteger  errorRetCode = [error code];
                        if ( errorRetCode == 220)
                        {
                            [GYUtils showToast:kLocalized(@"GYHS_Main_POS_This_Deal_Paid")];
                            
                        } else {
                            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
                            [GYUtils parseNetWork:error resultBlock:nil];
                        }
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                        [self.scanCodeVC startScanning];
                        return;
                    }
                    GYHSQRPayModel* model = [GYHSQRPayModel mj_objectWithKeyValues:responseObject[@"data"]];
                    BOOL isValid = [weakSelf calculateTimeDiff:model];
                    if (isValid) {
                        NSString* codeType = [scranString substringToIndex:2];
                        [weakSelf checkCustCouponDataFromNet:model WithPayStatus:GYHSNewPaymentWay WithCodeType:codeType];
                    } else {
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                        [self.scanCodeVC startScanning];
                    }
            }];
            [request commonParams:[GYUtils netWorkCommonParams]];
            [request start];
        }
        else {

            [GYUtils showToast:kLocalized(@"GYHS_Main_Please_Again_After_Logging_Using_Alternate_Number")];
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [self.scanCodeVC startScanning];
        }
    }
    //手机旧
    else if ([scranString containsString:@"MH&"] && [scranString componentsSeparatedByString:@"&"].count <= 12) {

        if (globalData.loginModel.cardHolder) {
            [GYGIFHUD show];

            GYNetRequest* requset = [[GYNetRequest alloc] initWithBlock:[HSReconsitutionUrl stringByAppendingString:@"/common/processEbCodePay"]
                                                             parameters:@{ @"str" : scranString }
                                                          requestMethod:GYNetRequestMethodPOST
                                                      requestSerializer:GYNetRequestSerializerJSON
                                                           respondBlock:^(NSDictionary* responseObject, NSError* error) {
                    [GYGIFHUD dismiss];
                    if (error) {
                        NSInteger  errorRetCode = [error code];
                        if ( errorRetCode == 220)
                        {
                            [GYUtils showToast:kLocalized(@"GYHS_Main_POS_This_Deal_Paid")];
                        } else {
                            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", requset.URLString, (long)[error code], [error localizedDescription]);
                            [GYUtils parseNetWork:error resultBlock:nil];
                        }
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                        [self.scanCodeVC startScanning];
                        return;
                    }
                    GYHSQRPayModel* model = [GYHSQRPayModel mj_objectWithKeyValues:responseObject[@"data"]];

                    GYHSScanCodePaymentViewController* scanVc = [[GYHSScanCodePaymentViewController alloc] init];
                    scanVc.payModel = model;
                    scanVc.delegate = self;
                    scanVc.paymentState = GYHSOldPaymentWay;
                    scanVc.codeType = [scranString substringToIndex:2];
                    [weakSelf addSonViewController:scanVc];
                    self.toMainBtn.hidden = YES;
                                                           }];
            [requset commonParams:[GYUtils netWorkCommonParams]];
            [requset start];
        }
        else {

            [GYUtils showToast:kLocalized(@"GYHS_Main_Please_Again_After_Logging_Using_Alternate_Number")];
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [self.scanCodeVC startScanning];
        }
    }
    //手机新版
    else if ([scranString containsString:@"M1&"] && [scranString componentsSeparatedByString:@"&"].count <= 12) {

        if (globalData.loginModel.cardHolder) {
            [GYGIFHUD show];
            GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:[HSReconsitutionUrl stringByAppendingString:@"/custCard/processEbCodePay"] parameters:@{ @"str" : scranString } requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
                    [GYGIFHUD dismiss];
                    if (error) {
                        NSInteger  errorRetCode = [error code];
                        if ( errorRetCode == 220)
                        {
                            [GYUtils showToast:kLocalized(@"GYHS_Main_POS_This_Deal_Paid")];
                        } else {
                            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
                            [GYUtils parseNetWork:error resultBlock:nil];
                        }
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                        [self.scanCodeVC startScanning];
                        return;
                    }
                    GYHSQRPayModel* model = [GYHSQRPayModel mj_objectWithKeyValues:responseObject[@"data"]];
                    BOOL isValid = [weakSelf calculateTimeDiff:model];
                    if (isValid) {
                        NSString* codeType = [scranString substringToIndex:2];
                        [weakSelf checkCustCouponDataFromNet:model WithPayStatus:GYHSNewPaymentWay WithCodeType:codeType];
                    } else {
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                        [self.scanCodeVC startScanning];
                    }
            }];
            [request commonParams:[GYUtils netWorkCommonParams]];
            [request start];
        }
        else {
            [GYUtils showToast:kLocalized(@"GYHS_Main_Please_Again_After_Logging_Using_Alternate_Number")];
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [self.scanCodeVC startScanning];
        }
    }
    // 第一版二维码生成规则
    else if ([scranString containsString:@"MH&"] && [scranString componentsSeparatedByString:@"&"].count >= 13) {

        if (globalData.loginModel.cardHolder) { // bill qrcode
            GYHSQRPayModel* model = [[GYHSQRPayModel alloc] init];
            NSArray<NSString*>* modelArr = [scranString componentsSeparatedByString:@"&"];

            model.entResNo = modelArr[1];
            model.entCustId = modelArr[2];
            model.voucherNo = modelArr[3];
            model.batchNo = modelArr[4];
            model.posDeviceNo = modelArr[5];
            model.date = modelArr[6];
            model.currencyCode = modelArr[7];
            model.tradeAmount = [@(modelArr[8].doubleValue / 100) stringValue];
            model.pointRate = [@(modelArr[9].doubleValue / 10000) stringValue];
            model.acceptScore = [@(modelArr[10].doubleValue / 100) stringValue];
            model.hsbAmount = [@(modelArr[11].doubleValue / 100) stringValue];
            model.transNo = modelArr[12];
            model.entName = modelArr[13];

            //            GYHSOrderPayConfirmVC* orderInfoVc = [[GYHSOrderPayConfirmVC alloc] init];
            //            orderInfoVc.model = model;
            //            orderInfoVc.paymentStatu = GYOldPaymentWay;
            //            [weakSelf.navigationController pushViewController:orderInfoVc animated:YES];
            GYHSScanCodePaymentViewController* scanVc = [[GYHSScanCodePaymentViewController alloc] init];
            scanVc.delegate = self;
            scanVc.payModel = model;
            scanVc.paymentState = GYHSOldPaymentWay;
            scanVc.codeType = [scranString substringToIndex:2];
            [weakSelf addSonViewController:scanVc];
            self.toMainBtn.hidden = YES;
        }
        else {
            [GYUtils showToast:kLocalized(@"GYHS_Main_Please_Again_After_Logging_Using_Alternate_Number")];
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [self.scanCodeVC startScanning];
        }
    }
    else if (scranString.length >= 32 && ([scranString hasPrefix:@"31&"] || [scranString hasPrefix:@"32&"])) { //扫企业收款码 包含固定额度和非固定额度

        [GYGIFHUD show];
        GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:[HSReconsitutionUrl stringByAppendingString:@"/custCard/getEntInfoByRqCode"]
                                                         parameters:@{ @"rqCodeNo" : scranString,
                                                             @"custId" : globalData.loginModel.custId }
                                                      requestMethod:GYNetRequestMethodPOST
                                                  requestSerializer:GYNetRequestSerializerJSON
                                                       respondBlock:^(NSDictionary* responseObject, NSError* error) {
                [GYGIFHUD dismiss];
                if (error) {
                    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
                    [GYUtils parseNetWork:error resultBlock:nil];
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    [self.scanCodeVC startScanning];
                    return;
                }
                if (!responseObject[@"data"] || [responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    [self.scanCodeVC startScanning];
                    return;
                }
                GYHSCollectionCodeModel* model = [[GYHSCollectionCodeModel alloc] initWithDictionary:responseObject[@"data"] error:nil];
                if (model.isExpired) {
                    [GYUtils showToast:kLocalized(@"二维码已失效")];
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    [self.scanCodeVC startScanning];
                    return;
                }
                GYHSScanCodePaymentViewController* scanVc = [[GYHSScanCodePaymentViewController alloc] init];
                scanVc.paymentState = GYHSNearPaymentWay;
                scanVc.codeModel = model;
                scanVc.delegate = self;
                [self addSonViewController:scanVc];
                self.toMainBtn.hidden = YES;
                                                       }];
        [request commonParams:[GYUtils netWorkCommonParams]];
        [request start];
    }
    else {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self.scanCodeVC startScanning];
        //[GYUtils showToast:kLocalized(@"GYHS_Main_HS_Pos_Deal_Failure")];
        //[self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)checkCustCouponDataFromNet:(GYHSQRPayModel*)model WithPayStatus:(GYHSPaymentStatus)PaymentWay WithCodeType:(NSString*)codeType
{
    WS(weakSelf)
    if (kSaftToNSInteger(model.couponNum) <= 0) {
        //        GYHSOrderPayConfirmVC* orderInfoVc = [[GYHSOrderPayConfirmVC alloc] init];
        //        orderInfoVc.model = model;
        //        orderInfoVc.paymentStatu = PaymentWay;
        //        [weakSelf.navigationController pushViewController:orderInfoVc animated:YES];
        GYHSScanCodePaymentViewController* scanVc = [[GYHSScanCodePaymentViewController alloc] init];
        scanVc.payModel = model;
        scanVc.delegate = self;
        scanVc.paymentState = PaymentWay;
        scanVc.codeType = codeType;
        [weakSelf addSonViewController:scanVc];
        self.toMainBtn.hidden = YES;
    }
    else {
        NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
        [params setValue:kSaftToNSString(globalData.loginModel.resNo) forKey:@"resNo"];
        [params setValue:kSaftToNSString(model.couponNum) forKey:@"couponNum"];

        [GYGIFHUD show];

        GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kHSCheckCustCouponData
                                                         parameters:params
                                                      requestMethod:GYNetRequestMethodGET
                                                  requestSerializer:GYNetRequestSerializerJSON
                                                       respondBlock:^(NSDictionary* responseObject, NSError* error) {
                                                           [GYGIFHUD dismiss];
                                                           if (error) {
                                                               NSInteger errorRetCode = [error code];
                                                               if (errorRetCode == 600201) {
                                                                   [GYUtils showToast:kSaftToNSString(responseObject[@"msg"])]; //抵扣券金额不足,请重试!
                                                                   [self.navigationController popToRootViewControllerAnimated:YES];
                                                                   return;
                                                               }
                                                               DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
                                                               [GYUtils parseNetWork:error resultBlock:nil];
                                                               return;
                                                           }
                                                           GYHSScanCodePaymentViewController* scanVc = [[GYHSScanCodePaymentViewController alloc] init];
                                                           scanVc.payModel = model;
                                                           scanVc.delegate = self;
                                                           scanVc.paymentState = PaymentWay;
                                                           scanVc.codeType = codeType;
                                                           [weakSelf addSonViewController:scanVc];
                                                           self.toMainBtn.hidden = YES;
                                                       }];
        [request commonParams:[GYUtils netWorkCommonParams]];
        [request start];
    }
}

#pragma mark - GYHSScanCodePaymentDelegate
//跳转到兑换互生币
- (void)jumpToExchangeHSB
{
    if (!globalData.isLogined) {
        [self showLoginView];
    }
    else {
        [self.mainHeaderView resetSelectFlag:4];
        [self addSonViewController:self.exchangeHSVC];
        [self.exchangeHSVC.view mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.bottom.left.right.equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView).offset(-35);
        }];
    }
}

//加载主界面
- (void)loadMainInterface
{
    [self.mainHeaderView resetSelectFlag:0];
    [self addSonViewController:self.accountMainVC];
}

//加载扫码付界面
- (void)loadScanCodeInterface
{
    //[self.mainHeaderView resetSelectFlag:1];
    [self addSonViewController:self.scanCodeVC];
    [self.scanCodeVC.view mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView).offset(-35);
    }];
}

//跳转到交易凭证页
- (void)jumpToTradeVoucher:(GYHSVoucherModel*)model
{
    GYHSScanCodeTradeVoucherViewController* vc = [[GYHSScanCodeTradeVoucherViewController alloc] init];
    vc.model = model;
    //vc.qrCodeState = GYHSScanCodeVoucher;
    vc.codeClass = @"01029"; //扫码付交易凭证
    [self addSonViewController:vc];
    self.codeType = 1000;
}

#pragma mark - GYHDMessageCenterDelegate
//推送代理
- (void)receiveCompanyQRWithDict:(NSDictionary*)dict
{
    NSString* codeStr = kSaftToNSString(dict[@"code"]);
    if ([codeStr isEqualToString:@"01030"] || [codeStr isEqualToString:@"01031"]) {
        if (self.currentVC != self.integralCodeVC) {
            DDLogDebug(@"The current vc:%@", self.currentVC);
            return;
        }
        self.codeType = 1002;
    }
    else {
        if (self.currentVC != self.paymentCodeVC) {
            DDLogDebug(@"The current vc:%@", self.currentVC);
            return;
        }
        self.codeType = 1001;
    }

    GYHSVoucherModel* model = [[GYHSVoucherModel alloc] init];
    NSDictionary* dataDict2 = [GYUtils stringToDictionary:dict[@"content"]];
    NSDictionary* dataDict1 = [GYUtils stringToDictionary:dataDict2[@"content"]];
    NSDictionary* dataDict = [GYUtils stringToDictionary:dataDict1[@"msg_content"]];
    model.date = kSaftToNSString(dataDict[@"tradingTime"]);
    model.hsbAmount = kSaftToNSString(dataDict[@"HSB"]);
    model.pvNum = kSaftToNSString(dataDict[@"points"]);
    model.shopName = kSaftToNSString(dataDict[@"enterpriseName"]);
    model.AmountNum = kSaftToNSString(dataDict[@"monetary"]);
    model.orderNum = kSaftToNSString(dataDict[@"orderNumber"]);
    GYHSScanCodeTradeVoucherViewController* vc = [[GYHSScanCodeTradeVoucherViewController alloc] init];
    vc.codeClass = kSaftToNSString(dict[@"code"]);
    vc.model = model;

    [self addSonViewController:vc];
    if ([codeStr isEqualToString:@"01030"] || [codeStr isEqualToString:@"01031"]) {
        self.codeType = 1002;
    }
    else {
        self.codeType = 1001;
    }
}

//计算时间差，看二维码是否失效
- (BOOL)calculateTimeDiff:(GYHSQRPayModel*)model
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"]; //设定时间格式,这里可以设置成自己需要的格式
    NSDate* date = [dateFormat dateFromString:model.date];
    long eeee = globalData.loginModel.timeDifference;
    UInt64 serveTime = ([[NSDate date] timeIntervalSince1970] * 1000 + eeee) / 1000;
    UInt64 createTime = ([date timeIntervalSince1970] * 1000 + eeee)/1000;
    if (serveTime - createTime > 86400) {
        [GYUtils showToast:kLocalized(@"二维码已失效")];
        return NO;
    }
    return YES;
}

@end
