//
//  GYEPSaleAfterApplyForViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.

#import "GYEPSaleAfterApplyForViewController.h"
#import "ViewCellStyle.h"
#import "GYEPSaleAfterApplyForOnlyReturnMoneyViewController.h"
#import "GYEPSaleAfterApplyForOnlyReturnGoodsMoneyViewController.h"
#import "GYEPSaleAfterApplyForChangeGoodsViewController1.h"
#import "Masonry.h"

@interface GYEPSaleAfterApplyForViewController ()

@property (weak, nonatomic) IBOutlet ViewCellStyle* onlyReturnMoneyView;
@property (weak, nonatomic) IBOutlet ViewCellStyle* backMoneyGoodsView;
@property (weak, nonatomic) IBOutlet ViewCellStyle* changeGoodsView;
@property (weak, nonatomic) IBOutlet UILabel* returnPvLab1;
@property (weak, nonatomic) IBOutlet UILabel* returnPvLab2;

@end

@implementation GYEPSaleAfterApplyForViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createIconAndFunction];
    [self ifHiddenView];
}

- (void)createIconAndFunction
{
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];

    _onlyReturnMoneyView.ivTitle.image = nil; //仅退款
    _onlyReturnMoneyView.lbActionName.text = kLocalized(@"GYHE_MyHE_OnlyRefuseReturnMoney");
    _onlyReturnMoneyView.nextVcName = NSStringFromClass([GYEPSaleAfterApplyForOnlyReturnMoneyViewController class]);
    [_returnPvLab1 setTextColor:kCellItemTextColor];
    _returnPvLab1.text = kLocalized(@"GYHE_MyHE_WillReturnSomeConsumerPv");
    [_onlyReturnMoneyView addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];

    _backMoneyGoodsView.ivTitle.image = nil; //退货退款
    _backMoneyGoodsView.lbActionName.text = kLocalized(@"GYHE_MyHE_ReturnShopAndMoney");
    _backMoneyGoodsView.nextVcName = NSStringFromClass([GYEPSaleAfterApplyForOnlyReturnGoodsMoneyViewController class]);
    [_returnPvLab2 setTextColor:kCellItemTextColor];
    _returnPvLab2.text = kLocalized(@"GYHE_MyHE_WillReturnSomeConsumerPv");
    [_backMoneyGoodsView addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];

    _changeGoodsView.ivTitle.image = nil; //换货
    _changeGoodsView.lbActionName.text = kLocalized(@"GYHE_MyHE_ChangeGoods");
    _changeGoodsView.nextVcName = NSStringFromClass([GYEPSaleAfterApplyForChangeGoodsViewController1 class]);
    [_changeGoodsView addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)ifHiddenView
{
    if (kSaftToNSInteger(self.dicDataSource[@"isRefund"]) == 1) {
        _onlyReturnMoneyView.hidden = YES;
        _backMoneyGoodsView.hidden = YES;
        [_changeGoodsView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(self.view).with.offset(16);
            make.left.equalTo(self.view).with.offset(0);
            make.right.equalTo(self.view).with.offset(0);
            make.height.mas_equalTo(@50);
        }];
    }
}

- (void)pushNextVC:(id)sender
{
    if (!sender)
        return;
    ViewCellStyle* viewSender = sender;
    UIViewController* vc = nil;
    if (_onlyReturnMoneyView == viewSender) {
        GYEPSaleAfterApplyForOnlyReturnMoneyViewController* onlyReturnMoneyVC = kLoadVcFromClassStringName(viewSender.nextVcName);
        onlyReturnMoneyVC.dicDataSource = self.dicDataSource;
        vc = onlyReturnMoneyVC;
    }
    else if (_backMoneyGoodsView == viewSender) {
        GYEPSaleAfterApplyForOnlyReturnGoodsMoneyViewController* backAllVC = kLoadVcFromClassStringName(viewSender.nextVcName);
        backAllVC.dicDataSource = self.dicDataSource;
        vc = backAllVC;
    }
    else if (_changeGoodsView == viewSender) {
        GYEPSaleAfterApplyForChangeGoodsViewController1* changeGoodsVC = kLoadVcFromClassStringName(viewSender.nextVcName);
        changeGoodsVC.dicDataSource = self.dicDataSource;
        vc = changeGoodsVC;
    }
    vc.navigationItem.title = viewSender.lbActionName.text;
    if (!vc)
        return;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
