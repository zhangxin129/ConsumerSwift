//
//  GYHSMsgBindHSCardVC.m
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYShowWebInfoViewController.h"
#import "GYGIFHUD.h"

@interface GYShowWebInfoViewController () <UIWebViewDelegate> {
    IBOutlet UIWebView* wbBrowser;
}

@end

@implementation GYShowWebInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];

    if (self.strUrl && ([[self.strUrl lowercaseString] hasPrefix:@"http://"] || [[self.strUrl lowercaseString] hasPrefix:@"https://"])) {
        wbBrowser.backgroundColor = self.view.backgroundColor;
        wbBrowser.delegate = self;
        self.strUrl = [NSString stringWithFormat:@"%s", self.strUrl.UTF8String];
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.strUrl]];
        [wbBrowser loadRequest:request];

        [GYGIFHUD show];
    }
    else {
        WS(weakSelf)
            [GYUtils showMessage:kLocalized(@"GYHE_MyHE_NetWrong") confirm:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    DDLogDebug(@"webURL:%@", request.URL.absoluteString);
    if ([request.URL.absoluteString rangeOfString:@"/gyorderDetail"].location != NSNotFound) {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    [GYGIFHUD dismiss];
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error
{

    [GYGIFHUD dismiss];

}

@end
