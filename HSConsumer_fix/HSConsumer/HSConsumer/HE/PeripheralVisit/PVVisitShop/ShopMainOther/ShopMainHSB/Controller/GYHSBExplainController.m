//
//  GYHSBExplainController.m
//  HSConsumer
//
//  Created by apple on 15/11/13.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSBExplainController.h"

@interface GYHSBExplainController ()

@property (nonatomic, strong) UIView* bgView;
@property (nonatomic, strong) UIView* lineView;
@property (nonatomic, strong) UILabel* labelOne;
@property (nonatomic, strong) UILabel* labelTwo;
@property (nonatomic, strong) UILabel* labelThr;

@end

@implementation GYHSBExplainController

#pragma mark 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kLocalized(@"GYHE_SurroundVisit_Money");
    //视图背景
    [self createBGColor];
    [self getHSBandLine];
    //互生币图标 + 比例
    [self getHSBIconAndValue];
    //互生币使用
    [self HSBToUse];
    //如何得到互生币
    [self howToGetHSB];
}

#pragma mark 自定义方法
- (void)createBGColor
{

    self.view.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:250 / 255.0 blue:220 / 255.0 alpha:1];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
    _bgView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:250 / 255.0 blue:220 / 255.0 alpha:1];
    [self.view addSubview:_bgView];
}

- (void)getHSBandLine
{

    _labelOne = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, _bgView.frame.size.width - 20, 20)];
    _labelOne.font = [UIFont systemFontOfSize:13];
    _labelOne.textColor = kNavigationBarColor;
    _labelOne.text = kLocalized(@"GYHE_SurroundVisit_HowToGetHSMoney");
    [_bgView addSubview:_labelOne];
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(_labelOne.frame.origin.x, CGRectGetMaxY(_labelOne.frame) + 2, _labelOne.frame.size.width, 1)];
    lineView.backgroundColor = kNavigationBarColor;
    [_bgView addSubview:lineView];
}

- (void)getHSBIconAndValue
{

    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(_bgView.frame.size.width / 2 - 37, CGRectGetMaxY(_lineView.frame) + 20, 74, 62)];
    imgView.image = [UIImage imageNamed:@"gyhs_big_hscoin"];
    [_bgView addSubview:imgView];
    _labelTwo = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 70, CGRectGetMaxY(imgView.frame), 150, 20)];
    _labelTwo.text = kLocalized(@"GYHE_SurroundVisit_OneHSBEqualOneRMB");
    _labelTwo.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    _labelTwo.textColor = kNavigationBarColor;
    [_bgView addSubview:_labelTwo];
}

- (void)HSBToUse
{

    _labelThr = [[UILabel alloc] initWithFrame:CGRectMake(_labelOne.frame.origin.x + 20, CGRectGetMaxY(_labelTwo.frame) + 10, _bgView.frame.size.width - 40, 20)];
    _labelThr.text = kLocalized(@"GYHE_SurroundVisit_HSBToUse");
    _labelThr.font = [UIFont systemFontOfSize:13];
    _labelThr.textColor = kNavigationBarColor;
    [_bgView addSubview:_labelThr];
}

- (void)howToGetHSB
{

    NSArray* titleArr = @[ kLocalized(@"GYHE_SurroundVisit_IntegralInvestmentTip"), kLocalized(@"GYHE_SurroundVisit_HowToExchangeHSB"), kLocalized(@"GYHE_SurroundVisit_ExchangeHSBByCompany") ];
    for (NSInteger i = 0; i < 3; i++) {
        UIView* tipView = [[UIView alloc] initWithFrame:CGRectMake(_labelThr.frame.origin.x, i * 20 + CGRectGetMaxY(_labelThr.frame) + 10, 5, 5)];
        tipView.backgroundColor = kNavigationBarColor;
        tipView.layer.cornerRadius = 2.5;
        tipView.clipsToBounds = YES;
        [_bgView addSubview:tipView];
        UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tipView.frame) + 5, tipView.frame.origin.y - 8, _labelThr.frame.size.width - 10, 20)];
        if(titleArr.count > i)
            lab.text = titleArr[i];
        lab.font = [UIFont systemFontOfSize:12];
        lab.textColor = [UIColor colorWithRed:90 / 255.0 green:90 / 255.0 blue:90 / 255.0 alpha:1];
        [_bgView addSubview:lab];
    }
}

@end
