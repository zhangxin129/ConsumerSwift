//
//  GYHSCardExplainController.m
//  HSConsumer
//
//  Created by apple on 15/11/13.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSCardExplainController.h"
#import "YYKit.h"

@interface GYHSCardExplainController ()

@property (nonatomic, strong) UIScrollView* scr;
@property (nonatomic, strong) UILabel* labelOne;
@property (nonatomic, strong) UILabel* labelTwo;
@property (nonatomic, strong) UILabel* labelThr;
@property (nonatomic, strong) YYLabel* labelFour;
@property (nonatomic, strong) UILabel* labelFive;
@property (nonatomic, strong) YYLabel* labelSix;

@end

@implementation GYHSCardExplainController

#pragma mark 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = kLocalized(@"GYHE_SurroundVisit_HSCard");
    [self createScrollView];
    //互生卡说明
    [self createHSKExplain];
    //用卡需知
    [self createHSKNotice];
}

#pragma mark 自定义方法
- (void)createScrollView
{
    self.view.backgroundColor = [UIColor whiteColor];
    _scr = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scr.bounces = NO;
    _scr.showsVerticalScrollIndicator = NO;
    _scr.showsHorizontalScrollIndicator = NO;
    _scr.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:250 / 255.0 blue:220 / 255.0 alpha:1];
    _scr.contentSize = CGSizeMake(0, self.view.bounds.size.height + self.view.bounds.size.height * 2 / 3);
    _scr.userInteractionEnabled = YES;
    [self.view addSubview:_scr];
}

- (void)createHSKExplain
{

    _labelOne = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, _scr.frame.size.width - 60, 20)];
    _labelOne.text = kLocalized(@"GYHE_SurroundVisit_HSCardExplain");
    _labelOne.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    _labelOne.textColor = kNavigationBarColor;
    [_scr addSubview:_labelOne];

    _labelTwo = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_labelOne.frame) + 20, 110, 20)];
    _labelTwo.text = kLocalized(@"GYHE_SurroundVisit_HSCardUseLogo");
    _labelTwo.font = [UIFont systemFontOfSize:12];
    _labelTwo.textColor = [UIColor colorWithRed:90 / 255.0 green:90 / 255.0 blue:90 / 255.0 alpha:1];
    [_scr addSubview:_labelTwo];

    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_labelTwo.frame), CGRectGetMaxY(_labelOne.frame), 37, 42)];
    imgView.image = [UIImage imageNamed:@"gycommon_logo"];
    [_scr addSubview:imgView];
    _labelThr = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame), _labelTwo.frame.origin.y, 10, 20)];
    _labelThr.textColor = [UIColor colorWithRed:90 / 255.0 green:90 / 255.0 blue:90 / 255.0 alpha:1];
    _labelThr.text = @"。";
    [_scr addSubview:_labelThr];

    _labelFour = [[YYLabel alloc] init];
    _labelFour.frame = CGRectMake(_labelOne.frame.origin.x, CGRectGetMaxY(_labelThr.frame) + 5, _labelOne.frame.size.width, 200);
    [_scr addSubview:_labelFour];
    _labelFour.textColor = [UIColor colorWithRed:90 / 255.0 green:90 / 255.0 blue:90 / 255.0 alpha:1];

    _labelFour.font = [UIFont systemFontOfSize:12];
    _labelFour.backgroundColor = [UIColor clearColor];
    _labelFour.numberOfLines = 0;

    NSMutableAttributedString* text1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", kLocalized(@"GYHE_SurroundVisit_HSCardTipOne"), kLocalized(@"GYHE_SurroundVisit_HSCardTipTwo"), kLocalized(@"GYHE_SurroundVisit_HSCardTipThr")]];
    text1.lineSpacing = 5;
    text1.color = [UIColor colorWithRed:90 / 255.0 green:90 / 255.0 blue:90 / 255.0 alpha:1];
    _labelFour.attributedText = text1;
    // 自适应高度
    [_labelFour sizeToFit];
    
}

- (void)createHSKNotice
{

    _labelFive = [[UILabel alloc] initWithFrame:CGRectMake(_labelOne.frame.origin.x, CGRectGetMaxY(_labelFour.frame) + 20, _scr.frame.size.width - 60, 20)];
    _labelFive.text = kLocalized(@"GYHE_SurroundVisit_CardNotice");
    _labelFive.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    _labelFive.textColor = kNavigationBarColor;
    [_scr addSubview:_labelFive];

    _labelSix = [[YYLabel alloc] init];
    _labelSix.frame = CGRectMake(_labelOne.frame.origin.x, CGRectGetMaxY(_labelFive.frame) + 20, _scr.frame.size.width - 60, 200);
    [_scr addSubview:_labelSix];

    _labelSix.textColor = [UIColor colorWithRed:90 / 255.0 green:90 / 255.0 blue:90 / 255.0 alpha:1];
    _labelSix.font = [UIFont systemFontOfSize:12];
    _labelSix.backgroundColor = [UIColor clearColor];
    _labelSix.numberOfLines = 0;
    NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", kLocalized(@"GYHE_SurroundVisit_CardNoticenOne"), kLocalized(@"GYHE_SurroundVisit_CardNoticenTwo"), kLocalized(@"GYHE_SurroundVisit_CardNoticenThr"), kLocalized(@"GYHE_SurroundVisit_CardNoticenFour"), kLocalized(@"GYHE_SurroundVisit_CardNoticenFive"), kLocalized(@"GYHE_SurroundVisit_CardNoticenSix"), kLocalized(@"GYHE_SurroundVisit_CardNoticenSeven"), kLocalized(@"HGYHE_SurroundVisit_CardNoticenEight"), kLocalized(@"GYHE_SurroundVisit_CardNoticenNine")]];
    text.lineSpacing = 2;
    text.color = [UIColor colorWithRed:90 / 255.0 green:90 / 255.0 blue:90 / 255.0 alpha:1];
    _labelSix.attributedText = text;
    // 自适应高度
    [_labelSix sizeToFit];
    
    _scr.contentSize = CGSizeMake(0, _labelSix.frame.origin.y + _labelSix.frame.size.height + 80);
    
}


@end
