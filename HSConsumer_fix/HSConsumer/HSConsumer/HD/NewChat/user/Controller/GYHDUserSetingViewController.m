//
//  GYUserSetingViewController.m
//  HSConsumer
//
//  Created by shiang on 16/1/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDUserSetingViewController.h"
#import "GYHDTitleBottomButton.h"
#import "GYHDMessageCenter.h"
#import "GYSlideMenuController.h"
#import "GYHDSearchFriendViewController.h"
#import "GYHDAttentionCompanyViewController.h"
//#import "GYHDAddFriendViewController.h"

@interface GYHDUserSetingViewController ()

@end

@implementation GYHDUserSetingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];
    //1. 头部
    UIView* topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(120);
    }];

    UIImageView* iconImageView = [[UIImageView alloc] init];
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.cornerRadius = 3;
    iconImageView.image = kLoadPng(@"gyhd_defaultheadimg");
    [topView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(12);
        make.bottom.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];

    UILabel* nikeNameLabel = [[UILabel alloc] init];
    nikeNameLabel.text = @"安吉丽娜 * 朱莉";
    nikeNameLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    nikeNameLabel.backgroundColor = [UIColor randomColor];
    nikeNameLabel.textColor = [UIColor colorWithRed:26 / 255.0f green:26 / 255.0f blue:26 / 255.0f alpha:1];
    [topView addSubview:nikeNameLabel];
    [nikeNameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(iconImageView.mas_right).offset(10);
        make.top.equalTo(iconImageView);
        make.height.equalTo(iconImageView).multipliedBy(0.5);
    }];

    UILabel* hushengLabel = [[UILabel alloc] init];
    hushengLabel.text = @"互生卡：06112110088";
    hushengLabel.font = [UIFont systemFontOfSize:KFontSizePX(22)];
    hushengLabel.backgroundColor = [UIColor randomColor];
    hushengLabel.textColor = [UIColor colorWithWholeRed:102 / 255.0f green:102 / 255.0f blue:102 / 255.0f alpha:1];
    [topView addSubview:hushengLabel];
    [hushengLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(nikeNameLabel);
        make.bottom.equalTo(iconImageView);
        make.height.equalTo(nikeNameLabel);
    }];

    UIImageView* arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = [UIImage imageNamed:@"gyhd_more_gd"];
    [topView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(iconImageView);
        make.right.equalTo(topView).multipliedBy(0.75);
    }];

    //2. 中间
    UIView* centerView = [[UIView alloc] init];
    centerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(topView.mas_bottom).offset(20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(130);
    }];
    CGFloat pad = (kScreenWidth - (kScreenWidth * 0.2)) / 3;
    // 扫一扫

    GYHDTitleBottomButton* sweepButton = [[GYHDTitleBottomButton alloc] init];
    [sweepButton setImage:[UIImage imageNamed:@"gyhd_btn_sys"] forState:UIControlStateNormal];
    [sweepButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_user_sweep"] forState:UIControlStateNormal];
    [centerView addSubview:sweepButton];
    [sweepButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(15);
    }];

    // 添加好友
    GYHDTitleBottomButton* addFriendButton = [[GYHDTitleBottomButton alloc] init];
    [addFriendButton setImage:[UIImage imageNamed:@"gyhd_btn_jhy"] forState:UIControlStateNormal];
    [addFriendButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_user_addFriden"] forState:UIControlStateNormal];
    [addFriendButton addTarget:self action:@selector(addFriendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:addFriendButton];
    [addFriendButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(sweepButton);
        make.left.mas_equalTo(pad*1);
    }];

    // 关注企业
    GYHDTitleBottomButton* attentionCompany = [[GYHDTitleBottomButton alloc] init];
    [attentionCompany setImage:[UIImage imageNamed:@"gyhd_btn_gzqy"] forState:UIControlStateNormal];
    [attentionCompany setTitle:[GYUtils localizedStringWithKey:@"GYHD_user_attentionCompany"] forState:UIControlStateNormal];
    [attentionCompany addTarget:self action:@selector(attentionCompanyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:attentionCompany];
    [attentionCompany mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(addFriendButton);
        make.left.mas_equalTo(pad*2);
    }];
    // 分割线
    UIView* segmentationView = [[UIView alloc] init];
    segmentationView.backgroundColor = [UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];

    [centerView addSubview:segmentationView];
    [segmentationView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-44);
        make.height.mas_equalTo(1);
    }];

    UIButton* searchButton = [[UIButton alloc] init];
    searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [searchButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_user_searchName"] forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor colorWithRed:102 / 255.0f green:102 / 255.0f blue:102 / 255.0f alpha:1] forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [searchButton setImage:[UIImage imageNamed:@"gyhd_search_icon"] forState:UIControlStateNormal];
    [centerView addSubview:searchButton];
    [searchButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(12);
        make.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
}

- (void)addFriendButtonClick:(UIButton*)button
{
    GYHDSearchFriendViewController* searchFriendViewController = [[GYHDSearchFriendViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:searchFriendViewController];
    [nav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)attentionCompanyButtonClick
{
    GYHDAttentionCompanyViewController* searchFriendViewController = [[GYHDAttentionCompanyViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:searchFriendViewController];
    [nav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
