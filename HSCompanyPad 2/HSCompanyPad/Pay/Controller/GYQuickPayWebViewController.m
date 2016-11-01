//
//  GYQuickPayWebViewController.m
//  HSCompanyPad
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//
/**
 *  绑定快捷支付卡
 *
 */
#import "GYQuickPayWebViewController.h"
#import "NSURLRequest+NSURLRequestWithIgnoreSSL.h"
#import "GYQuickPayViewController.h"
#import "GYPaySuccessVC.h"
#import "UIViewController+GYExtension.h"
#import "GYGIFHUD.h"

@interface GYQuickPayWebViewController ()<UIWebViewDelegate, NSURLSessionDelegate>

@property (nonatomic, strong) UIWebView* quickWebView;

@end

@implementation GYQuickPayWebViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setUp];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
/**
 *  创建视图
 */
- (void)setUp
{
    self.quickWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.quickWebView.scalesPageToFit = YES;
    self.quickWebView.delegate = self;
    NSURL* url = [NSURL URLWithString:self.urlStr];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [NSURLRequest allowsAnyHTTPSCertificateForHost:url.host];
    [self.quickWebView loadRequest:request];
    [self.view addSubview:self.quickWebView];
}
/**
 *  UIWebViewDelegate
 */
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    DDLogInfo(@"request===%@", [request URL]);
    
    if ([[[request URL] absoluteString] containsString:self.returnUrlStr]) {
        [kDefaultNotificationCenter postNotificationName:GYHSCardSubMitOrderSuccessNotification object:nil];
        [self performSelector:@selector(pop) withObject:nil afterDelay:10.0f];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView*)webView
{
    
    //创建UIActivityIndicatorView背底半透明View
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.1];
    [self.view addSubview:view];
    
    [GYGIFHUD show];
    
    DDLogInfo(@"DidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    [GYGIFHUD dismiss];
    UIView* view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    DDLogInfo(@"DidFinishLoad");
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error
{
//    [GYUtils showToast:kLocalized(@"GYHS_Main_FailedToLoad")];
    [GYGIFHUD dismiss];
    UIView* view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    DDLogInfo(@"didFailLoadWithError==%@", error);
}

- (void)pop{
    
    [self popToViewControllerWithClassName:NSStringFromClass([GYQuickPayViewController class]) animated:YES];
}


@end
