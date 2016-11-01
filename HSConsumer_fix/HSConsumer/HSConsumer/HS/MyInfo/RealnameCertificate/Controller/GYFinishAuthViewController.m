//
//  GYFinishAuthViewController.m
//  HSConsumer
//
//  Created by apple on 15-3-11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  完成认证

#import "GYFinishAuthViewController.h"

@interface GYFinishAuthViewController ()

@end

@implementation GYFinishAuthViewController {

    __weak IBOutlet UIImageView* imgvSmile;

    __weak IBOutlet UILabel* lbTips;
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    lbTips.text = kLocalized(@"GYHS_RealName_Tip_You_Have_Been_Through_Real_Name_Authentication");
    lbTips.textColor = kCellItemTitleColor;

}

@end
