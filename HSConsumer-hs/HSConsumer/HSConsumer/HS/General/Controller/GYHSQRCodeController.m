//
//  GYHSQRCodeController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/4/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSQRCodeController.h"

@interface GYHSQRCodeController ()

@end

@implementation GYHSQRCodeController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = kLocalized(@"GYHS_General_MyQrCode");
    self.view.backgroundColor = UIColorFromRGB(0x464646);

    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(45, kScreenHeight * 0.16, kScreenWidth - 2 * 45, kScreenWidth - 2 * 45)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];

    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 2 * 55, kScreenWidth - 2 * 55)];
    [view addSubview:imageView];

    UIImage* qrImage = [GYUtils createQRImageWithString:[@"ID&" stringByAppendingString:globalData.loginModel.resNo] size:CGSizeMake(kScreenWidth - 2 * 55, kScreenWidth - 2 * 55)];
    imageView.image = qrImage;
}

@end
