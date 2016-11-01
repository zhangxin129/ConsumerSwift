//
//  GYHSCardInfoVC.m
//  HSConsumer
//
//  Created by sqm on 16/4/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSCardInfoVC.h"
#import "UIColor+HEX.h"

@interface GYHSCardInfoVC ()

@end

@implementation GYHSCardInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = kDefaultVCBackgroundColor;

    self.title = kLocalized(@"GYHS_QR_cardInfo");
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 16, kScreenWidth, 40)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.borderColor = kDefaultViewBorderColor.CGColor;
    contentView.layer.borderWidth = .5f;
    [self.view addSubview:contentView];

    UILabel* titltLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth * 0.3 - 10, 40)];
    titltLabel.textColor = kCellItemTitleColor;
    titltLabel.font = kCellTitleFont;
    titltLabel.text = kLocalized(@"GYHS_QR_cardNumber");
    titltLabel.textAlignment = NSTextAlignmentLeft;
    [contentView addSubview:titltLabel];

    UILabel* cardNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth * 0.3, 0, kScreenWidth * 0.7 - 10, 40)];
    cardNumberLabel.font = kCellTitleFont;
    cardNumberLabel.textAlignment = NSTextAlignmentRight;
    [contentView addSubview:cardNumberLabel];
    cardNumberLabel.text = self.cardNumber;
    cardNumberLabel.textColor = [UIColor colorWithHexString:@"#FA3C28"];
}

@end
