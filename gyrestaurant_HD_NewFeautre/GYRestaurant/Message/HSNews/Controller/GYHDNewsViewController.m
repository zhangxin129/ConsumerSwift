//
//  GYHDNewsViewController.m
//  HSEnterprise
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import "GYHDNewsViewController.h"
#import "GYHDNewsView.h"
@interface GYHDNewsViewController ()

@end

@implementation GYHDNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
}

- (void)initUI {
    
    GYHDNewsView *newsView = [[GYHDNewsView alloc]initWithFrame:CGRectMake(0 , 0, kScreenWidth , kScreenHeight - 64)];
    [self.view addSubview:newsView];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

@end
