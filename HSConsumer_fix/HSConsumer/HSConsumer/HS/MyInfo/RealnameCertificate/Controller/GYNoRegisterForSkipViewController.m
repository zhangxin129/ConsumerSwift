
//  HSConsumer
//
//  Created by apple on 15-3-13.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYNoRegisterForSkipViewController.h"
#import "GYRealNameRegistrationViewController.h"

@interface GYNoRegisterForSkipViewController ()

@end

@implementation GYNoRegisterForSkipViewController {

    __weak IBOutlet UIImageView* imgvLight;

    __weak IBOutlet UIButton* btnSkip;

    IBOutlet UILabel* lbContent;

    __weak IBOutlet UILabel* lbContentNext;

    GlobalData* data;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [btnSkip setTitle:kLocalized(@"GYHS_RealName_Register") forState:UIControlStateNormal];

    btnSkip.layer.borderWidth = 1;
    btnSkip.layer.borderColor = [UIColor grayColor].CGColor;
    [btnSkip addTarget:self action:@selector(btnSkipToRealnameBankding) forControlEvents:UIControlEventTouchUpInside];

    [lbContent setText:self.strContent];
    [lbContentNext setText:self.strContentNext];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    data = globalData;
}

- (void)btnSkipToRealnameBankding
{

    GYRealNameRegistrationViewController* vcNameBanding = [[GYRealNameRegistrationViewController alloc] init];
    [self.navigationController pushViewController:vcNameBanding animated:YES];
}

@end
