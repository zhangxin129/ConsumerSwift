//
//  ViewController.m
//  GYCompany
//
//  Created by cook on 15/9/13.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "GYGIFHUD.h"
#import "GYMainResViewController.h"
#import "GYLoginViewController.h"
#import "UIView+Toast.h"

@interface ViewController ()<UINavigationControllerDelegate>

@end
@implementation ViewController{
    
    UIImageView *noConnectImage;
    UILabel *noConnectLabel;
    UILabel *subNoConectLabel;
    UILabel *netLabel;
    UIAlertView *customAlertView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    [self setExclusiveTouchForButtons:self.view];
    DDLogCInfo(@"self is %@",self);
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
   

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    if (self.navigationController.viewControllers.count >1) {
        self.navigationController.navigationBar.translucent = NO;

    }else {
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"image_icon.png"] forBarMetrics:UIBarMetricsCompact];
        if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
            NSArray *list = self.navigationController.navigationBar.subviews;
            for (id obj in list) {
                if ([obj isKindOfClass:[UIImageView class]]) {
                    UIImageView *imageView = (UIImageView *)obj;
                    imageView.alpha = 0.2f;
                }
            }
        }
    
    }
  
 
}


#pragma mark设置一次只能点击一个按钮
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    
    [self setExclusiveTouchForButtons:self.view];
    
    
}

-(void)keyboardHide{
    [self.view endEditing:YES];
}


#pragma mark重新加载数据
- (void)loadAndTapReloadNetData{
    
}

#pragma mark无网络页面
- (void)customNoNetWorkView{
    netLabel = [[UILabel alloc]initWithFrame:self.view.bounds];
    netLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *reloadTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadAndTapReloadNetData)];
    [netLabel addGestureRecognizer:reloadTap];
    [self.view addSubview:netLabel];
    
    CGFloat height = 154.5 * (kScreenHeight / 568 > 1 ? : 1);
    noConnectImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 111 * kScreenWidth / 320, height)];
    UIImage *image = [UIImage imageNamed:@"no_internet"];
    noConnectImage.image = image;
    [netLabel addSubview:noConnectImage];
    
    noConnectLabel = [[UILabel alloc]initWithFrame:CGRectMake(noConnectImage.frame.origin.x - 30, noConnectImage.frame.origin.y + noConnectImage.frame.size.height, noConnectImage.frame.size.width + 60, 15)];
    noConnectLabel.text = kLocalized(@"Yournetworkhaslefttheearth");
    noConnectLabel.textAlignment = NSTextAlignmentCenter;
    noConnectLabel.textColor = [UIColor colorWithHexString:@"#a7a7a7"];
    noConnectLabel.numberOfLines = 0;
    noConnectLabel.font = [UIFont systemFontOfSize:15];
    [netLabel addSubview:noConnectLabel];
    
    subNoConectLabel = [[UILabel alloc]initWithFrame:CGRectMake(noConnectImage.frame.origin.x, noConnectLabel.frame.origin.y + noConnectLabel.frame.size.height + 9, noConnectImage.frame.size.width, 12)];
    subNoConectLabel.text = kLocalized(@"Pleasecheckthenetworkclickretry");
    subNoConectLabel.textAlignment = NSTextAlignmentCenter;
    subNoConectLabel.textColor = [UIColor colorWithHexString:@"#a7a7a7"];
    subNoConectLabel.font = [UIFont systemFontOfSize:12];
    [netLabel addSubview:subNoConectLabel];
    
    
    noConnectImage.hidden = NO;
    noConnectLabel.hidden = NO;
    subNoConectLabel.hidden = NO;
    
    netLabel.frame = CGRectMake((kScreenWidth - 111 * kScreenWidth / 320) / 2,kScreenHeight / 2 - height / 2, 111 * kScreenWidth / 320, CGRectGetMaxY(subNoConectLabel.frame));
    netLabel.center = CGPointMake(self.view.center.x, self.view.center.y);
    [self.view bringSubviewToFront:netLabel];
    
}

#pragma mark请求数据
- (void)modelRequestNetwork : (ViewModel *)model : (void (^)
                                                    (id resultDic))success isIndicator : (BOOL)isIndicator{
    
    
    if (isIndicator) {
        [GYGIFHUD show];;
    }
  
    [netLabel removeFromSuperview];
    
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        
        [GYGIFHUD dismiss];
        
    }
    
    [model setBlockWithReturnBlock:^(id returnValue) {
        
        netLabel.hidden = YES;
        [GYGIFHUD dismiss];
        success(returnValue);
    } failureBlock:^(NSError *error) {
        [self notifyWithText:[self getNetFailureTipWithError:error] ];
        [GYGIFHUD dismiss];
    }];
    
    
    
}



#pragma mark警告框
- (void)customAlertView : (NSString *)title{
    
    [customAlertView dismissWithClickedButtonIndex:0 animated:YES];
    customAlertView = [[UIAlertView alloc]initWithTitle:title message:nil delegate:nil cancelButtonTitle:kLocalized(@"Determine") otherButtonTitles:nil, nil];
    [customAlertView show];
    
}


- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}


#pragma mark键盘消失
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    [self.view  endEditing:YES];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}




#pragma mark设置按钮只能同时点击一个
-(void)setExclusiveTouchForButtons:(UIView *)myView{
    for (UIView * v in [myView subviews]) {
        if([v isKindOfClass:[UIButton class]]){
            [((UIButton *)v) setExclusiveTouch:YES];
   
        }
        else if ([v isKindOfClass:[UIView class]]){
            [self setExclusiveTouchForButtons:v];
        }
    }
}

#pragma mark页面销毁移除通知
- (void)dealloc {
    DDLogCInfo(@"%@从内存移除了",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController setDelegate:nil];
}

#pragma mark内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)enableView : (UIView *)view{
    
    view.userInteractionEnabled = YES;
}

- (void)pushViewController : (UIViewController *)viewController animated : (BOOL)animated;{
    
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:animated];
    
}

//吐司
- (void)notifyWithText : (NSString *)text{
    
    [[UIApplication sharedApplication].delegate.window  makeToast:text duration:1.f position:CSToastPositionBottom ];
    
 
}



/**
 *  @brief  返回指定的viewcontroler
 *
 *  @param className 指定viewcontroler类名
 *  @param animated  是否动画
 *
 *  @return pop之后的viewcontrolers
 */
- (NSArray *)popToViewControllerWithClassName:(NSString*)className animated:(BOOL)animated;
{
    return [self.navigationController popToViewController:[self findViewController:className] animated:YES];
}


#pragma mark - 拓展
/**
 *  @brief  寻找Navigation中的某个viewcontroler对象
 *
 *  @param className viewcontroler名称
 *
 *  @return viewcontroler对象
 */
- (id)findViewController:(NSString*)className
{
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:NSClassFromString(className)]) {
            return viewController;
        }
    }
    
    return nil;
}

- (NSString *)getNetFailureTipWithError:(NSError *)error
{
//    NSURLErrorUnknown = 			-1,
//    NSURLErrorCancelled = 			-999,
//    NSURLErrorBadURL = 				-1000,
//    NSURLErrorTimedOut = 			-1001,
//    NSURLErrorUnsupportedURL = 			-1002,
//    NSURLErrorCannotFindHost = 			-1003,
//    NSURLErrorCannotConnectToHost = 		-1004,
//    NSURLErrorNetworkConnectionLost = 		-1005,
//    NSURLErrorDNSLookupFailed = 		-1006,
//    NSURLErrorHTTPTooManyRedirects = 		-1007,
//    NSURLErrorResourceUnavailable = 		-1008,
//    NSURLErrorNotConnectedToInternet = 		-1009,
//    NSURLErrorRedirectToNonExistentLocation = 	-1010,
//    NSURLErrorBadServerResponse = 		-1011,
//    NSURLErrorUserCancelledAuthentication = 	-1012,
//    NSURLErrorUserAuthenticationRequired = 	-1013,
//    NSURLErrorZeroByteResource = 		-1014,
//    NSURLErrorCannotDecodeRawData =             -1015,
//    NSURLErrorCannotDecodeContentData =         -1016,
//    NSURLErrorCannotParseResponse =             -1017,
//    NSURLErrorAppTransportSecurityRequiresSecureConnection NS_ENUM_AVAILABLE(10_11, 9_0) = -1022,
//    NSURLErrorFileDoesNotExist = 		-1100,
//    NSURLErrorFileIsDirectory = 		-1101,
//    NSURLErrorNoPermissionsToReadFile = 	-1102,
//    NSURLErrorDataLengthExceedsMaximum NS_ENUM_AVAILABLE(10_5, 2_0) =	-1103,
//    
//    // SSL errors
//    NSURLErrorSecureConnectionFailed = 		-1200,
//    NSURLErrorServerCertificateHasBadDate = 	-1201,
//    NSURLErrorServerCertificateUntrusted = 	-1202,
//    NSURLErrorServerCertificateHasUnknownRoot = -1203,
//    NSURLErrorServerCertificateNotYetValid = 	-1204,
//    NSURLErrorClientCertificateRejected = 	-1205,
//    NSURLErrorClientCertificateRequired =	-1206,
//    NSURLErrorCannotLoadFromNetwork = 		-2000,
//    
//    // Download and file I/O errors
//    NSURLErrorCannotCreateFile = 		-3000,
//    NSURLErrorCannotOpenFile = 			-3001,
//    NSURLErrorCannotCloseFile = 		-3002,
//    NSURLErrorCannotWriteToFile = 		-3003,
//    NSURLErrorCannotRemoveFile = 		-3004,
//    NSURLErrorCannotMoveFile = 			-3005,
//    NSURLErrorDownloadDecodingFailedMidStream = -3006,
//    NSURLErrorDownloadDecodingFailedToComplete =-3007,
//    
//    NSURLErrorInternationalRoamingOff NS_ENUM_AVAILABLE(10_7, 3_0) =         -1018,
//    NSURLErrorCallIsActive NS_ENUM_AVAILABLE(10_7, 3_0) =                    -1019,
//    NSURLErrorDataNotAllowed NS_ENUM_AVAILABLE(10_7, 3_0) =                  -1020,
//    NSURLErrorRequestBodyStreamExhausted NS_ENUM_AVAILABLE(10_7, 3_0) =      -1021,
//    
//    NSURLErrorBackgroundSessionRequiresSharedContainer NS_ENUM_AVAILABLE(10_10, 8_0) = -995,
//    NSURLErrorBackgroundSessionInUseByAnotherProcess NS_ENUM_AVAILABLE(10_10, 8_0) = -996,
//    NSURLErrorBackgroundSessionWasDisconnected NS_ENUM_AVAILABLE(10_10, 8_0)= -997,
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        switch (error.code) {
            case NSURLErrorTimedOut:
                return kLocalized(@"NetworkTimeout,PleaseTryAgainLater!");
                break;
              case NSURLErrorNotConnectedToInternet:
                return kLocalized(@"NoNetworkConnection,CheckTheNetwork!");
                break;
            default:
                return kLocalized(@"ServerIsBusy,PleaseTryAgainLater!");
                break;
        }
    }
         return kLocalized(@"UnknownMistake");

}
@end
