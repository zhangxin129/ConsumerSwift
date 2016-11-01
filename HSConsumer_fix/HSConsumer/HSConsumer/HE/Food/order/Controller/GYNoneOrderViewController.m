//
//  GYNoneOrderViewController.m
//  HSConsumer
//
//  Created by appleliss on 15/10/26.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYNoneOrderViewController.h"

@interface GYNoneOrderViewController ()

@end

@implementation GYNoneOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = kLocalized(@"GYHE_Food_InOrder");
    if ([self.strtitle isEqualToString:@"2"]) {
        self.title = kLocalized(@"GYHE_Food_OutOrder");
    }

    self.lbdetile.text = kLocalized(@"GYHE_Food_NotHaveOrder");
    if ([self.strtitle isEqualToString:@"1"]) {
        self.lbdetile.text = kLocalized(@"GYHE_Food_NotHaveEatingOrder");
    }

}

@end
