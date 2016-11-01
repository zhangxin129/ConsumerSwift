//
//  GYAccidentInfoController.m
//  HSConsumer
//
//  Created by Apple03 on 15/9/28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAccidentInfoController.h"
#import "GYHSAccidentHarmViewController.h"

#define kTitleFont [UIFont systemFontOfSize:15]
#define kDetialFont [UIFont systemFontOfSize:13]

@interface GYAccidentInfoController ()

@end

@implementation GYAccidentInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self settings];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   // 只有返回首页才隐藏NavigationBarHidden
        if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) { //返回
            if ([self.navigationController.topViewController isKindOfClass:[GYHSAccidentHarmViewController class]]) {
                [self.navigationController setNavigationBarHidden:YES animated:YES];
            }
        }
}

- (void)settings
{
    self.title = kLocalized(@"GYHS_BP_Accident_Harm_Safeguard_Clause");
    CGFloat svBackH = kScreenHeight - self.navigationController.navigationBar.frame.size.height;
    CGRect frame = self.view.bounds;
    frame.size.height = svBackH;
    UIScrollView* svBack = [[UIScrollView alloc] initWithFrame:frame];
    svBack.backgroundColor = kDefaultVCBackgroundColor;
    svBack.scrollEnabled = YES;
    [self.view addSubview:svBack];

    CGFloat margin = 20;
    CGFloat border = 16;
    NSArray* arrTitle = @[
        kLocalized(@"GYHS_BP_One_Scope_Protection"),
        kLocalized(@"GYHS_BP_Two_During_Protection_Renewal"),
        kLocalized(@"GYHS_BP_Three_Guarantee_Responsibility"),
        kLocalized(@"GYHS_BP_Four_Liability_Exemption"),
        kLocalized(@"GYHS_BP_Five_Guarantee_Amount"),
        kLocalized(@"GYHS_BP_Six_Certificates_And_Information_Security"),
        kLocalized(@"GYHS_BP_Seven_Security_Application"),
        kLocalized(@"GYHS_BP_EightParaphrase")
    ];

    NSArray* arrDetial = @[
        kLocalized(@"GYHS_BP_Scope_Protection"),
        kLocalized(@"GYHS_BP_During_Protection_And_Renewal"),
        kLocalized(@"GYHS_BP_Guarantee_Responsibility"),
        kLocalized(@"GYHS_BP_Liability_Exemption"),
        kLocalized(@"GYHS_BP_Guarantee_Amount"),
        kLocalized(@"GYHS_BP_Certificates_And_Information_Security"),
        kLocalized(@"GYHS_BP_Security_Application"),
        kLocalized(@"GYHS_BP_Paraphrase")
    ];

    CGFloat lbTitleW = 200;
    CGFloat lbTitleH = 20;
    CGFloat lbTitleY = 20;
    CGFloat lbTitleX = (kScreenWidth - lbTitleW) * 0.5;
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(lbTitleX, lbTitleY, lbTitleW, lbTitleH)];
    lbTitle.textColor = kNavigationBarColor;
    lbTitle.font = [UIFont systemFontOfSize:16];
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.textAlignment = NSTextAlignmentCenter;
    lbTitle.text = kLocalized(@"GYHS_BP_Accident_Harm_Safeguard_Clause");
    [svBack addSubview:lbTitle];

    CGFloat titleY = CGRectGetMaxY(lbTitle.frame) + margin;
    CGFloat titleW = kScreenWidth - border * 2;
    CGFloat titleH = 20;

    CGFloat lbDetailX = border;
    CGFloat lbDetailW = kScreenWidth - lbDetailX * 2;

    for (int i = 0; i < arrTitle.count; i++) {
        NSString* strTitle = arrTitle[i];
        NSString* strDetail = arrDetial[i];
        UILabel* lbDetailTitle = [[UILabel alloc] initWithFrame:CGRectMake(border, titleY, titleW, titleH)];
        lbDetailTitle.textColor = kCellItemTitleColor;
        lbDetailTitle.font = kTitleFont;
        lbDetailTitle.backgroundColor = [UIColor clearColor];
        lbDetailTitle.textAlignment = NSTextAlignmentLeft;
        lbDetailTitle.text = strTitle;

        CGFloat lbDetailY = CGRectGetMaxY(lbDetailTitle.frame) + margin;
        CGSize detailSize = [GYUtils sizeForString:strDetail font:kDetialFont width:lbDetailW];
        CGFloat lbDetalH = detailSize.height;
        UILabel* lbDetailInfo = [[UILabel alloc] initWithFrame:CGRectMake(lbDetailX, lbDetailY, lbDetailW, lbDetalH)];
        lbDetailInfo.numberOfLines = 0;
        lbDetailInfo.textColor = kCellItemTextColor;
        lbDetailInfo.font = kDetialFont;
        lbDetailInfo.backgroundColor = [UIColor clearColor];
        lbDetailInfo.textAlignment = NSTextAlignmentLeft;
        lbDetailInfo.text = strDetail;

        CGFloat updateH = CGRectGetMaxY(lbDetailInfo.frame);
        titleY = (updateH + margin);
        [svBack addSubview:lbDetailTitle];
        [svBack addSubview:lbDetailInfo];
        if (i == arrTitle.count - 1) {
            [svBack setContentSize:CGSizeMake(0, titleY)];
        }
    }
}

@end
