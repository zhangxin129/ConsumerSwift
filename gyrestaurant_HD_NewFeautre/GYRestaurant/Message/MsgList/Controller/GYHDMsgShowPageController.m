//
//  GYHDMsgShowPageController.m
//  GYRestaurant
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDMsgShowPageController.h"
#import "GYHDNavView.h"
@interface GYHDMsgShowPageController ()<GYHDNavViewDelegate>

@end

@implementation GYHDMsgShowPageController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden=YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
     [self setupNav];
    UIWebView*showView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    
    showView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
//    showView.detectsPhoneNumbers = YES;//自动检测网页上的电话号码，单击可以拨打
    [self.view addSubview:showView];
    
    NSURL* url = [NSURL URLWithString:self.pageUrl];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [showView loadRequest:request];//加载
}
-(void)setupNav{

    GYHDNavView *navView = [[GYHDNavView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth , 64)];
    navView.delegate = self;
    [self.view addSubview:navView];
    
}

- (void)GYHDNavViewGoBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
