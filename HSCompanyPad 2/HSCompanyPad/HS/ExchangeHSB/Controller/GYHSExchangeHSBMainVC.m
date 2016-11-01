//
//  GYHSExchangeHSBMainVC.m
//
//  Created by apple on 16/8/23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSExchangeHSBMainVC.h"
#import "GYHSExchangeButton.h"
#import "GYHSExchageHSBViewController.h"
#import "GYHSGenerationsExchangeHSBVC.h"

@interface GYHSExchangeHSBMainVC ()

@property (nonatomic, strong) GYHSExchangeButton* generationBtn;
@property (nonatomic, strong) GYHSExchangeButton* exchageBtn;

@end

@implementation GYHSExchangeHSBMainVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kLocalized(@"GYHS_ExchageHSB_Exchage_HSB");
    @weakify(self);
    [self loadInitViewType:GYStopTypeLogout :^{
        @strongify(self);
        [self initView];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDLogInfo(@"Show Controller: %@", [self class]);
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
}

#pragma mark - event response
- (void)generationBtnAction
{
    //代兑互生币
    GYHSGenerationsExchangeHSBVC* vc = [[GYHSGenerationsExchangeHSBVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)exchageBtnAction
{
    //兑换互生币
    GYHSExchageHSBViewController* vc = [[GYHSExchageHSBViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - private methods
- (void)initView
{
    self.view.backgroundColor = kWhiteFFFFFF;
    DDLogInfo(@"Load Controller: %@", [self class]);
    
    [self.view addSubview:self.exchageBtn];
    [self.exchageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(44 + kDeviceProportion(89));
        make.width.height.equalTo(@(kDeviceProportion(135)));
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(0.5);
    }];
    
    [self.view addSubview:self.generationBtn];
    [self.generationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(44 + kDeviceProportion(89));
        make.width.height.equalTo(@(kDeviceProportion(135)));
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.5);
    }];
}

#pragma mark - lazy load
- (GYHSExchangeButton*)generationBtn
{
    if (!_generationBtn) {
        _generationBtn = [GYHSExchangeButton buttonWithType:UIButtonTypeCustom];
        [_generationBtn setTitle:kLocalized(@"GYHS_ExchageHSB_Generations_HSB") forState:UIControlStateNormal];
        [_generationBtn setTitleColor:kGray333333 forState:UIControlStateNormal];
        _generationBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _generationBtn.titleLabel.font = kFont40;
        [_generationBtn setImage:[UIImage imageNamed:@"gyhs_generationExchangeHSB"] forState:UIControlStateNormal];
        [_generationBtn setImage:[UIImage imageNamed:@"gyhs_generationExchangeHSB"] forState:UIControlStateHighlighted];
        [_generationBtn addTarget:self action:@selector(generationBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _generationBtn;
}

- (GYHSExchangeButton*)exchageBtn
{
    if (!_exchageBtn) {
        _exchageBtn = [GYHSExchangeButton buttonWithType:UIButtonTypeCustom];
        [_exchageBtn setTitle:kLocalized(@"GYHS_ExchageHSB_Exchage_HSB") forState:UIControlStateNormal];
        [_exchageBtn setTitleColor:kGray333333 forState:UIControlStateNormal];
        _exchageBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _exchageBtn.titleLabel.font = kFont40;
        [_exchageBtn setImage:[UIImage imageNamed:@"gyhs_exchageHSB"] forState:UIControlStateNormal];
        [_exchageBtn setImage:[UIImage imageNamed:@"gyhs_exchageHSB"] forState:UIControlStateHighlighted];
        [_exchageBtn addTarget:self action:@selector(exchageBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exchageBtn;
}

@end
