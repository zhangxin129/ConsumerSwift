//
//  GYLinkQuickPayCardViewController.m
//  HSConsumer
//
//  Created by admin on 16/7/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYLinkQuickPayCardViewController.h"
#import "NSURLRequest+NSURLRequestWithIgnoreSSL.h"
#import "UIButton+GYExtension.h"

@interface GYLinkQuickPayCardViewController () <UIWebViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, strong) NSURLRequest* request;
@property (nonatomic, strong) NSURLConnection* connection;
@property (nonatomic, assign) BOOL authenticated;

@property (nonatomic, strong) UIView* activityBGView;
@property (nonatomic, strong) UIActivityIndicatorView* activityIndicator;
@end

@implementation GYLinkQuickPayCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL* urlStr = [NSURL URLWithString:self.bindBankUrl];
    self.request = [NSURLRequest requestWithURL:urlStr];

    // 解决https证书信任
    [NSURLRequest allowsAnyHTTPSCertificateForHost:urlStr.host];
    self.authenticated = NO;
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView loadRequest:self.request];
    
    UIImage* image = kLoadPng(@"gyhe_myhe_nav_back");
    CGRect backframe = CGRectMake(15, 32, image.size.width * 0.5, image.size.height * 0.5);
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = backframe;
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
//    [backButton setEnlargEdgeWithTop:20 right:20 bottom:20 left:25];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.webView addSubview:backButton];
}

- (void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    DDLogDebug(@"Did start loading: %@ auth:%d", [[request URL] absoluteString], self.authenticated);

    if (!self.authenticated) {
        self.authenticated = NO;
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [self.connection start];
        return NO;
    }

    if ([[[request URL] absoluteString] containsString:self.returnUrl]) {
        [GYGIFHUD show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [GYGIFHUD dismiss];
                [self.navigationController popViewControllerAnimated:YES];
                if ([self.delegate respondsToSelector:@selector(refreshDataWhenback)]) {
                    [self.delegate refreshDataWhenback];
                }
        });
    }

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView*)webView
{
//    [self.view addSubview:self.activityBGView];
//    [self.activityBGView addSubview:self.activityIndicator];
//    [self.activityIndicator setCenter:self.activityBGView.center];
//    [self.activityIndicator startAnimating];
    
    [GYGIFHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
//    [self.activityIndicator stopAnimating];
//    [self.activityBGView removeFromSuperview];
//    self.activityBGView = nil;
    
    [GYGIFHUD dismiss];
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error
{
//    [self.activityIndicator stopAnimating];
//    [self.activityBGView removeFromSuperview];
//    self.activityBGView = nil;
    
    [GYGIFHUD dismiss];
//    [GYUtils showToast:@"加载失败"];
}

#pragma mark - NURLConnection delegate
- (void)connection:(NSURLConnection*)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge
{
    DDLogDebug(@"WebController Got auth challange via NSURLConnection");

    if ([challenge previousFailureCount] == 0) {
        self.authenticated = YES;
        NSURLCredential* credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
    }
    else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    DDLogDebug(@"WebController received response via NSURLConnection");
    self.authenticated = YES;
    [self.webView loadRequest:self.request];
    [self.connection cancel];
}

#pragma mark - private methods
- (UIView*)activityBGView
{
    if (_activityBGView == nil) {
        _activityBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
        [_activityBGView setBackgroundColor:[UIColor blackColor]];
        [_activityBGView setAlpha:0.3];
    }

    return _activityBGView;
}

- (UIActivityIndicatorView*)activityIndicator
{
    if (_activityIndicator == nil) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
        [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    }

    return _activityIndicator;
}

@end
