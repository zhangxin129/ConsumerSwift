//
//  GYHDMsgShowPageController.m
//  GYRestaurant
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDMsgShowPageController.h"

@interface GYHDMsgShowPageController ()

@end

@implementation GYHDMsgShowPageController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    UIWebView*showView=[[UIWebView alloc]init];
     [self.view addSubview:showView];
    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.left.right.mas_equalTo(0);
        
    }];
    
    showView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
//    showView.detectsPhoneNumbers = YES;//自动检测网页上的电话号码，单击可以拨打
   
    
    NSURL* url = [NSURL URLWithString:self.pageUrl];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [showView loadRequest:request];//加载
}
@end
