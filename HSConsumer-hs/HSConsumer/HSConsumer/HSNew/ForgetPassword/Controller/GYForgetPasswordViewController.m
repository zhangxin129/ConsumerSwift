//
//  GYForgetPasswordViewController.m
//
//  Created by lizp on 16/9/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYForgetPasswordViewController.h"
#import "GYForgetPasswordView.h"

@interface GYForgetPasswordViewController ()<GYForgetPasswordViewDelegate>

@property (nonatomic,strong) GYForgetPasswordView *forgetView;

@end

@implementation GYForgetPasswordViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Show Controller: %@", [self class]);

}

- (void)dealloc {
    NSLog(@"Dealloc Controller: %@", [self class]);
}

// #pragma mark - SystemDelegate   
// #pragma mark TableView Delegate    
#pragma mark - CustomDelegate  

#pragma mark - GYForgetPasswordViewDelegate
-(void)dismiss {

    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
// #pragma mark - event response

#pragma mark - private methods 
- (void)initView
{
    self.title = kLocalized(@"");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    NSLog(@"Load Controller: %@", [self class]);
    
    [self setUp];
}

-(void)setUp {
    
    self.forgetView = [[GYForgetPasswordView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.forgetView.delegate = self;
    [self.view addSubview:self.forgetView];
}

#pragma mark - getters and setters


@end
