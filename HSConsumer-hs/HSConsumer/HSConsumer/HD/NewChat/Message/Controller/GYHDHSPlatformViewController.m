//
//  GYHDHSPlatformViewController.m
//  HSConsumer
//
//  Created by shiang on 16/1/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDHSPlatformViewController.h"

@interface GYHDHSPlatformViewController () <UIWebViewDelegate>

@end

@implementation GYHDHSPlatformViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [GYUtils localizedStringWithKey:@"GYHD_company_husheng_Open_Letter"];
    UIWebView* webView = [[UIWebView alloc] init];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    webView.detectsPhoneNumbers = NO;
    self.view = webView;
    NSURL* url = [NSURL URLWithString:self.urlString];

    NSURLRequest* requesturl = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requesturl];
}

//- (void)webViewDidStartLoad:(UIWebView *)webView {
//    NSLog(@"开始查询");
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSLog(@"结束查询");
//}
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
//    NSLog(@"%@", error);
//}

@end
