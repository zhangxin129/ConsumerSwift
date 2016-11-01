//
// GYHSInfoTipViewController.m
//  HSConsumer
//
//  Created by apple on 15-3-27.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSInfoTipViewController.h"
#import "UIButton+GYExtension.h"
#import "GYRealNameRegistrationViewController.h"

@interface GYHSInfoTipViewController ()

@property (weak, nonatomic) IBOutlet UILabel* tipsLable;
@property (weak, nonatomic) IBOutlet UIButton* realNameBtn;

@end

@implementation GYHSInfoTipViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tipsLable.textColor = kCellItemTitleColor;
    self.tipsLable.text = self.strSource;

    [self.realNameBtn setTitle:kLocalized(@"GYHS_MyInfo_Real_Name_Register") forState:UIControlStateNormal];
    [self.realNameBtn setBorderWithWidth:1.0 andRadius:2 andColor:kDefaultViewBorderColor];
    [self.realNameBtn setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)realNameBtnAction:(id)sender
{
    GYRealNameRegistrationViewController* vc = [[GYRealNameRegistrationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
