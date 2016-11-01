//
//  GYPaySuccessVC.m
//  HSCompanyPad
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYPaySuccessVC.h"
#import <YYKit/YYLabel.h>
#import <YYKit/NSAttributedString+YYText.h>
#import "GYHSStoreMainVC.h"
#import "UIViewController+GYExtension.h"
#import "GYHSPersonalityCardListVC.h"
#import "GYHSExchageHSBViewController.h"
#import "GYHSMainViewController.h"
#import "GYHSToolsQueryVC.h"
#import "GYHSMainViewController.h"

@interface GYPaySuccessVC ()

@end

@implementation GYPaySuccessVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] init];
    barBtn.title = @"";
    self.navigationItem.leftBarButtonItem = barBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(pop)];
    
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"支付成功");
    self.view.backgroundColor = kWhiteFFFFFF;
    DDLogInfo(@"Load Controller: %@", [self class]);
    [self createRetailView];
    
}

- (void)createRetailView
{
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:@"gypay_tick"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(44 + 100);
        make.left.equalTo(self.view.mas_left).offset(326);
        make.width.equalTo(@(kDeviceProportion(39)));
        make.height.equalTo(@(kDeviceProportion(39)));
    }];
    
    UILabel *tipLable = [[UILabel alloc] init];
    [self.view addSubview:tipLable];
    [tipLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(44 + 100);
        make.left.equalTo(imageView.mas_left).offset(39 + 5);
        make.width.equalTo(@(kDeviceProportion(kScreenWidth - 326 - 39 - 5)));
        make.height.equalTo(@(kDeviceProportion(40)));
    }];
    
    NSMutableAttributedString* tipMsg = [[NSMutableAttributedString alloc] init];
    [tipMsg appendAttributedString:[[NSAttributedString alloc] initWithString:@"您已成功支付" attributes:@{ NSFontAttributeName : kFont48, NSForegroundColorAttributeName : kGray333333 }]];
    
    [tipMsg appendAttributedString:[[NSAttributedString alloc] initWithString:[GYUtils formatCurrencyStyle:[_payStr doubleValue]] attributes:@{ NSFontAttributeName : kFont48, NSForegroundColorAttributeName : kRedE50012 }]];
    
    [tipMsg appendAttributedString:[[NSAttributedString alloc] initWithString:@"元！" attributes:@{ NSFontAttributeName : kFont48, NSForegroundColorAttributeName : kGray333333 }]];
    
    tipLable.attributedText = tipMsg;
    
    
    UILabel *tipsLable = [[UILabel alloc] init];
    tipsLable.text = @"安全提醒：互生不会以卡单、系统升级为由要求您退款，谨防诈骗！提及批发商账户、中奖、索要验证码的都是骗子！";
    tipsLable.numberOfLines = 0;
    tipsLable.font = kFont32;
    tipsLable.textColor = kGray333333;
    tipsLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipsLable];
    [tipsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLable.mas_top).offset(40 + 20);
        make.left.equalTo(self.view.mas_left).offset((kScreenWidth - 600) / 2);
        make.width.equalTo(@(kDeviceProportion(600)));
        make.height.equalTo(@(kDeviceProportion(50)));
    }];

}
- (void)pop{
    if (self.isQueryDetailVC == YES) {
        [self popToViewControllerWithClassName:NSStringFromClass([GYHSToolsQueryVC class]) animated:YES];
    }else{
        if (self.type == GYPaymentTypeToolPurchase || self.type == GYPaymentTypeResourcePurchase) {
            [self popToViewControllerWithClassName:NSStringFromClass([GYHSStoreMainVC class]) animated:YES];
        }else if (self.type == GYPaymentTypePersonalCard){
        [self popToViewControllerWithClassName:NSStringFromClass([GYHSPersonalityCardListVC class]) animated:YES];
        }else if (self.type == GYPaymentTypePayAnnualFee){
            [self popToViewControllerWithClassName:NSStringFromClass([GYHSMainViewController class]) animated:YES];
        }else if (self.type == GYPaymentTypeExchangeHSCurrency){
        [self popToViewControllerWithClassName:NSStringFromClass([GYHSExchageHSBViewController class]) animated:YES];
        }else if (self.type == GYPaymentTypePayAnnualFee){
            [self popToViewControllerWithClassName:NSStringFromClass([GYHSMainViewController class]) animated:YES];
        }
    }
}

@end
