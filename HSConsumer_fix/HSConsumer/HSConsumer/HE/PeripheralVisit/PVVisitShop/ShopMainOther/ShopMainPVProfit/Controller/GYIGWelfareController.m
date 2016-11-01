//
//  GYIGWelfareController.m
//  HSConsumer
//
//  Created by apple on 15/11/13.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYIGWelfareController.h"
#import "UILabel+LineSpace.h"

@interface GYIGWelfareController ()

@property (nonatomic, strong) UIScrollView* scr;
@property (nonatomic, strong) UILabel* labelOne;
@property (nonatomic, strong) UILabel* labelTwo;
@property (nonatomic, strong) UILabel* labelThr;
@property (nonatomic, strong) UILabel* labelFour;
@property (nonatomic, strong) UILabel* labelFive;
@property (nonatomic, strong) UILabel* labelSix;
@property (nonatomic, strong) UILabel* labelSv;
@property (nonatomic, strong) UILabel* labelEi;
@property (nonatomic, strong) UILabel* labelNine;
@property (nonatomic, strong) UILabel* labelTen;
@property (nonatomic, copy) NSString* strFive;

@end

@implementation GYIGWelfareController

#pragma mark 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kLocalized(@"GYHE_SurroundVisit_AlternateIntegralWelfare");
    self.view.backgroundColor = [UIColor whiteColor];
    [self createScrollView];
    [self createIntegralToCash];
    [self createPfofit];
    [self createHospitaiPlan];
    [self createHurtAccient];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark 自定义方法
- (CGSize)getHeightWithString:(NSString*)text width:(CGFloat)width
{
    /**
       Size 文字显示的最大区域
       options 通过什么方式来计算文字
       NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
       attributes 文字的字体，颜色
       context NULL
     */
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:16] } context:NULL].size;
    return size;
}

- (void)createScrollView
{
    _scr = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scr.showsHorizontalScrollIndicator = NO;
    _scr.showsVerticalScrollIndicator = NO;
    _scr.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:250 / 255.0 blue:220 / 255.0 alpha:1];
    _scr.contentSize = CGSizeMake(0, self.view.bounds.size.height + self.view.bounds.size.height * 2 / 3);
    _scr.userInteractionEnabled = YES;
    [self.view addSubview:_scr];
}

- (void)createIntegralToCash
{
    _labelOne = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, _scr.frame.size.width - 60, 20)];
    _labelOne.text = kLocalized(@"GYHE_SurroundVisit_IntegralToCash");
    _labelOne.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    _labelOne.textColor = kNavigationBarColor;
    [_scr addSubview:_labelOne];
    NSString* strTwo = kLocalized(@"GYHE_SurroundVisit_AlternateIntegralWelfareOne");
    CGSize sizeTwo = [self getHeightWithString:strTwo width:_labelOne.frame.size.width];
    _labelTwo = [[UILabel alloc] initWithFrame:CGRectMake(_labelOne.frame.origin.x, CGRectGetMaxY(_labelOne.frame) + 5, _labelOne.frame.size.width, sizeTwo.height)];
    _labelTwo.font = [UIFont systemFontOfSize:12];
    _labelTwo.numberOfLines = 0;
    _labelTwo.text = strTwo;
    _labelTwo.textColor = [UIColor colorWithRed:90 / 255.0 green:90 / 255.0 blue:90 / 255.0 alpha:1];
    [_labelTwo setLineSpace:2 WithLabel:_labelTwo WithText:strTwo];
    [_scr addSubview:_labelTwo];
}

- (void)createPfofit
{
    _labelThr = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_labelTwo.frame) + 5, _scr.frame.size.width - 60, 20)];
    _labelThr.text = kLocalized(@"GYHE_SurroundVisit_AnnualIncomeConsumersIntegralInvestment");
    _labelThr.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    _labelThr.textColor = kNavigationBarColor;
    [_scr addSubview:_labelThr];
    NSString* strFour = kLocalized(@"GYHE_SurroundVisit_AlternateIntegralWelfareTwo");
    CGSize sizeFour = [self getHeightWithString:strFour width:_labelOne.frame.size.width];
    _labelFour = [[UILabel alloc] initWithFrame:CGRectMake(_labelOne.frame.origin.x, CGRectGetMaxY(_labelThr.frame) + 5, _labelOne.frame.size.width, sizeFour.height)];
    _labelFour.font = [UIFont systemFontOfSize:12];
    _labelFour.numberOfLines = 0;
    _labelFour.text = strFour;
    _labelFour.textColor = [UIColor colorWithRed:90 / 255.0 green:90 / 255.0 blue:90 / 255.0 alpha:1];
    [_labelFour setLineSpace:2 WithLabel:_labelFour WithText:strFour];
    [_scr addSubview:_labelFour];
    _strFive = kLocalized(@"GYHE_SurroundVisit_AlternateIntegralWelfareThr");
    CGSize sizeFive = [self getHeightWithString:_strFive width:_labelOne.frame.size.width];
    _labelFive = [[UILabel alloc] initWithFrame:CGRectMake(_labelOne.frame.origin.x, CGRectGetMaxY(_labelFour.frame) + 5, _labelOne.frame.size.width, sizeFive.height)];
    _labelFive.font = [UIFont systemFontOfSize:12];
    _labelFive.numberOfLines = 0;
    _labelFive.text = _strFive;
    _labelFive.textColor = [UIColor colorWithRed:90 / 255.0 green:90 / 255.0 blue:90 / 255.0 alpha:1];
    [_labelFive setLineSpace:2 WithLabel:_labelFive WithText:_strFive];
    [_scr addSubview:_labelFive];
}

- (void)createHospitaiPlan
{
    _labelSix = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_labelFive.frame) + 5, _scr.frame.size.width - 60, 20)];
    _labelSix.text = kLocalized(@"GYHE_SurroundVisit_IntegralInvestmentAchieveFreeMedicalBenefitsConsumersPlan");
    _labelSix.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    _labelSix.textColor = kNavigationBarColor;
    [_scr addSubview:_labelSix];
    NSString* strSv = kLocalized(@"GYHE_SurroundVisit_AlternateIntegralWelfareFour");
    CGSize sizeSv = [self getHeightWithString:strSv width:_labelOne.frame.size.width];
    _labelSv = [[UILabel alloc] initWithFrame:CGRectMake(_labelOne.frame.origin.x, CGRectGetMaxY(_labelSix.frame) + 5, _labelOne.frame.size.width, sizeSv.height)];
    _labelSv.font = [UIFont systemFontOfSize:12];
    _labelSv.numberOfLines = 0;
    _labelSv.text = _strFive;
    _labelSv.textColor = [UIColor colorWithRed:90 / 255.0 green:90 / 255.0 blue:90 / 255.0 alpha:1];
    [_labelSv setLineSpace:2 WithLabel:_labelSv WithText:strSv];
    [_scr addSubview:_labelSv];
    NSString* strEi = kLocalized(@"GYHE_SurroundVisit_AlternateIntegralWelfareTips");
    CGSize sizeEi = [self getHeightWithString:strSv width:_labelOne.frame.size.width];
    _labelEi = [[UILabel alloc] initWithFrame:CGRectMake(_labelOne.frame.origin.x, CGRectGetMaxY(_labelSv.frame) + 5, _labelOne.frame.size.width, sizeEi.height)];
    _labelEi.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    _labelEi.textColor = [UIColor blackColor];
    _labelEi.numberOfLines = 0;
    _labelEi.text = strEi;
    [_labelEi setLineSpace:2 WithLabel:_labelEi WithText:strEi];
    [_scr addSubview:_labelEi];
}

- (void)createHurtAccient
{
    _labelNine = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_labelEi.frame) + 5, _scr.frame.size.width - 60, 20)];
    _labelNine.text = kLocalized(@"GYHE_SurroundVisit_ReceiveAccidentProtection");
    _labelNine.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    _labelNine.textColor = kNavigationBarColor;
    [_scr addSubview:_labelNine];
    NSString* strTen = kLocalized(@"GYHE_SurroundVisit_AlternateIntegralWelfareFive");
    CGSize sizeTen = [self getHeightWithString:strTen width:_labelOne.frame.size.width];
    _labelTen = [[UILabel alloc] initWithFrame:CGRectMake(_labelOne.frame.origin.x, CGRectGetMaxY(_labelNine.frame) + 5, _labelOne.frame.size.width, sizeTen.height)];
    _labelTen.font = [UIFont systemFontOfSize:12];
    _labelTen.numberOfLines = 0;
    _labelTen.text = strTen;
    _labelTen.textColor = [UIColor colorWithRed:90 / 255.0 green:90 / 255.0 blue:90 / 255.0 alpha:1];
    [_labelTen setLineSpace:2 WithLabel:_labelTen WithText:strTen];
    [_scr addSubview:_labelTen];
    NSString* strLast = kLocalized(@"GYHE_SurroundVisit_AlternateIntegralWelfareSix");
    CGSize sizeLast = [self getHeightWithString:strLast width:_labelOne.frame.size.width];
    UILabel* labelLast = [[UILabel alloc] initWithFrame:CGRectMake(_labelOne.frame.origin.x, CGRectGetMaxY(_labelTen.frame) + 7, _labelOne.frame.size.width, sizeLast.height)];
    labelLast.font = [UIFont systemFontOfSize:11];
    labelLast.numberOfLines = 0;
    labelLast.text = strLast;
    labelLast.textColor = [UIColor colorWithRed:129 / 255.0 green:126 / 255.0 blue:115 / 255.0 alpha:1];
    [labelLast setLineSpace:2 WithLabel:labelLast WithText:strLast];
    [_scr addSubview:labelLast];
    _scr.contentSize = CGSizeMake(0, CGRectGetMaxY(labelLast.frame) + 80);
}


@end
