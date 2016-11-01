//
//  GYWebViewController.m
//
//  Created by User on 16/8/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYWebViewController.h"

@interface GYWebViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;

@end

@implementation GYWebViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDLogInfo(@"Show Controller: %@", [self class]);
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
}

// #pragma mark - SystemDelegate
// #pragma mark TableView Delegate
// #pragma mark - CustomDelegate
// #pragma mark - event response
//#pragma mark - request

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    DDLogInfo(@"Load Controller: %@", [self class]);
  
    self.webView =[[UIWebView alloc]initWithFrame:self.view.bounds];
    self.fileUrl = _fileUrl;
    self.webView.delegate = self;
    
    [self.view addSubview:self.webView];
    
}

-(void)setFileUrl:(NSURL *)fileUrl{

    _fileUrl = fileUrl;
    
    if (fileUrl) {
        
     [self.webView loadRequest:[NSURLRequest requestWithURL:fileUrl]];
  
    }

}
#pragma mark - lazy load

#pragma mark - UIWebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{


}



@end
