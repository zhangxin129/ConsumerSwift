//
//  GYHSDetailCheckListView.m
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/2.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSDetailCheckListView.h"
#import <GYKit/UIView+Extension.h>

#define kBtnHeight kDeviceProportion(35)
#define kLabelTitleFont kFont24
#define kFiveCommonWide kDeviceProportion(150)
#define kFourCommonWide kDeviceProportion(200)
@interface GYHSDetailCheckListView ()

@end

@implementation GYHSDetailCheckListView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = NO;
    }
    return self;
}

#pragma mark-----自定义五个字标题
/**
 *  自定义五个栏目的标题框
 */
- (void)setFiveCommonTitle
{
    //1
    UIView *firstView = [[UIView alloc] init];
    firstView.backgroundColor = [UIColor clearColor];
    [self addSubview:firstView];
    @weakify(self);
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(@(kFiveCommonWide));
    }];



    UILabel *firstLabel = [[UILabel alloc] init];
    firstLabel.textAlignment   = NSTextAlignmentCenter;
    firstLabel.backgroundColor = [UIColor clearColor];
    firstLabel.text            = kLocalized(@"GYHS_Account_Trading_Time");
    firstLabel.textColor       = kGray777777;
    firstLabel.font            = kLabelTitleFont;
    CGSize firstSize = [self giveLabelWith:firstLabel.font
                                  nsstring:firstLabel.text];
    [firstView addSubview:firstLabel];
    [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(firstSize.width + 1));
        make.height.equalTo(@(firstSize.height + 1));
        make.centerX.equalTo(firstView.mas_centerX);
        make.centerY.equalTo(firstView.mas_centerY).offset(kDeviceProportion(-2));
    }];




    //2
    UIView *secondView = [[UIView alloc] init];
    secondView.backgroundColor = [UIColor clearColor];
    [self addSubview:secondView];

    [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.bottom.equalTo(self);
        make.left.equalTo(firstView.mas_right);
        make.width.equalTo(@(kFiveCommonWide));
    }];
    secondView.layer.borderWidth = 1;
    secondView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel *secondLabel = [[UILabel alloc] init];
    [secondView addSubview:secondLabel];
    secondLabel.textAlignment   = NSTextAlignmentCenter;
    secondLabel.backgroundColor = [UIColor clearColor];
    secondLabel.text            = kLocalized(@"GYHS_Account_Type");
    secondLabel.textColor       = kGray777777;
    secondLabel.font            = kLabelTitleFont;
    CGSize secondSize = [self giveLabelWith:secondLabel.font
                                   nsstring:secondLabel.text];

    [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(secondSize.width + 1));
        make.height.equalTo(@(secondSize.height + 1));
        make.centerX.equalTo(secondView.mas_centerX);
        make.centerY.equalTo(secondView.mas_centerY).offset(kDeviceProportion(-2));
    }];


    //3
    UIView *thirdView = [[UIView alloc] init];
    thirdView.backgroundColor = [UIColor clearColor];
    [self addSubview:thirdView];

    [thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.bottom.equalTo(self);
        make.left.equalTo(secondView.mas_right);
        make.width.equalTo(@(kFiveCommonWide));
    }];
    thirdView.layer.borderWidth = 1;
    thirdView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel *thirdLabel = [[UILabel alloc] init];
    [thirdView addSubview:thirdLabel];
    thirdLabel.textAlignment   = NSTextAlignmentCenter;
    thirdLabel.backgroundColor = [UIColor clearColor];
    thirdLabel.text            = kLocalized(@"GYHS_Account_Occurrence_Amount");
    thirdLabel.textColor       = kGray777777;
    thirdLabel.font            = kLabelTitleFont;
    CGSize thirdSize = [self giveLabelWith:thirdLabel.font
                                  nsstring:thirdLabel.text];

    [thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(thirdSize.width + 1));
        make.height.equalTo(@(thirdSize.height + 1));
        make.centerX.mas_equalTo(thirdView.centerX);
        make.centerY.equalTo(thirdView.mas_centerY).offset(kDeviceProportion(-2));
    }];




    //4
    UIView *fourthView = [[UIView alloc] init];
    fourthView.backgroundColor = [UIColor clearColor];
    [self addSubview:fourthView];

    [fourthView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.bottom.equalTo(self);
        make.left.equalTo(thirdView.mas_right);
        make.width.equalTo(@(kFiveCommonWide));
    }];
    fourthView.layer.borderWidth = 1;
    fourthView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel *fourthLabel = [[UILabel alloc] init];
    [fourthView addSubview:fourthLabel];
    fourthLabel.textAlignment   = NSTextAlignmentCenter;
    fourthLabel.backgroundColor = [UIColor clearColor];
    fourthLabel.text            = kLocalized(@"GYHS_Account_Accounts_After_Transaction");
    fourthLabel.textColor       = kGray777777;
    fourthLabel.font            = kLabelTitleFont;
    CGSize fourthSize = [self giveLabelWith:fourthLabel.font
                                   nsstring:fourthLabel.text];

    [fourthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(fourthSize.width + 1));
        make.height.equalTo(@(fourthSize.height + 1));
        make.centerX.mas_equalTo(fourthView.centerX);
        make.centerY.equalTo(fourthView.mas_centerY).offset(kDeviceProportion(-2));
    }];


    //5
    UIView *fifthView = [[UIView alloc] init];
    fifthView.backgroundColor = [UIColor clearColor];
    [self addSubview:fifthView];

    [fifthView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.bottom.equalTo(self);
        make.left.equalTo(fourthView.mas_right);
        make.width.equalTo(@(kDeviceProportion(404)));
    }];

    UILabel *fifthLabel = [[UILabel alloc] init];
    [fifthView addSubview:fifthLabel];
    fifthLabel.textAlignment   = NSTextAlignmentCenter;
    fifthLabel.backgroundColor = [UIColor clearColor];
    fifthLabel.text            = kLocalized(@"GYHS_Account_Transaction_Type");
    fifthLabel.textColor       = kGray777777;
    fifthLabel.font            = kLabelTitleFont;
    CGSize fifthSize = [self giveLabelWith:fifthLabel.font
                                  nsstring:fifthLabel.text];

    [fifthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(fifthSize.width + 1));
        make.height.equalTo(@(fifthSize.height + 1));
        make.centerX.equalTo(fifthView.mas_centerX);
        make.centerY.equalTo(fifthView.mas_centerY).offset(kDeviceProportion(-2));
    }];
}

/**
 *  自定义四个栏目的标题框
 */
- (void)setFourCommonTitle
{
    //1
    UIView *firstView = [[UIView alloc] init];
    firstView.backgroundColor = [UIColor clearColor];
    [self addSubview:firstView];
    @weakify(self);
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(@(kFourCommonWide));
    }];


    UILabel *firstLabel = [[UILabel alloc] init];
    firstLabel.textAlignment   = NSTextAlignmentCenter;
    firstLabel.backgroundColor = [UIColor clearColor];
    firstLabel.text            = kLocalized(@"GYHS_Account_Trading_Time");
    firstLabel.textColor       = kGray777777;
    firstLabel.font            = kLabelTitleFont;
    CGSize firstSize = [self giveLabelWith:firstLabel.font
                                  nsstring:firstLabel.text];
    [firstView addSubview:firstLabel];
    [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(firstSize.width + 1));
        make.height.equalTo(@(firstSize.height + 1));
        make.centerX.equalTo(firstView.mas_centerX);
        make.centerY.equalTo(firstView.mas_centerY).offset(kDeviceProportion(-2));
    }];




    //2
    UIView *secondView = [[UIView alloc] init];
    secondView.backgroundColor = [UIColor clearColor];
    [self addSubview:secondView];

    [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.bottom.equalTo(self);
        make.left.equalTo(firstView.mas_right);
        make.width.equalTo(@(kFourCommonWide));
    }];
    secondView.layer.borderWidth = 1;
    secondView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel *secondLabel = [[UILabel alloc] init];
    [secondView addSubview:secondLabel];
    secondLabel.textAlignment   = NSTextAlignmentCenter;
    secondLabel.backgroundColor = [UIColor clearColor];
    secondLabel.text            = kLocalized(@"GYHS_Account_Integral_Point_Number");
    secondLabel.textColor       = kGray777777;
    secondLabel.font            = kLabelTitleFont;
    CGSize secondSize = [self giveLabelWith:secondLabel.font
                                   nsstring:secondLabel.text];

    [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(secondSize.width + 1));
        make.height.equalTo(@(secondSize.height + 1));
        make.centerX.equalTo(secondView.mas_centerX);
        make.centerY.equalTo(secondView.mas_centerY).offset(kDeviceProportion(-2));
    }];


    //3
    UIView *thirdView = [[UIView alloc] init];
    thirdView.backgroundColor = [UIColor clearColor];
    [self addSubview:thirdView];

    [thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.bottom.equalTo(self);
        make.left.equalTo(secondView.mas_right);
        make.width.equalTo(@(kFourCommonWide));
    }];
    thirdView.layer.borderWidth = 1;
    thirdView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel *thirdLabel = [[UILabel alloc] init];
    [thirdView addSubview:thirdLabel];
    thirdLabel.textAlignment   = NSTextAlignmentCenter;
    thirdLabel.backgroundColor = [UIColor clearColor];
    thirdLabel.text            = kLocalized(@"GYHS_Account_Total_Investment_After_The_Transaction");
    thirdLabel.textColor       = kGray777777;
    thirdLabel.font            = kLabelTitleFont;
    CGSize thirdSize = [self giveLabelWith:thirdLabel.font
                                  nsstring:thirdLabel.text];

    [thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(thirdSize.width + 1));
        make.height.equalTo(@(thirdSize.height + 1));
        make.centerX.mas_equalTo(thirdView.centerX);
        make.centerY.equalTo(thirdView.mas_centerY).offset(kDeviceProportion(-2));
    }];




    //4
    UIView *fourthView = [[UIView alloc] init];
    fourthView.backgroundColor = [UIColor clearColor];
    [self addSubview:fourthView];

    [fourthView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.bottom.equalTo(self);
        make.left.equalTo(thirdView.mas_right);
        make.width.equalTo(@(kDeviceProportion(404)));
    }];

    UILabel *fourthLabel = [[UILabel alloc] init];
    [fourthView addSubview:fourthLabel];
    fourthLabel.textAlignment   = NSTextAlignmentCenter;
    fourthLabel.backgroundColor = [UIColor clearColor];
    fourthLabel.text            = kLocalized(@"GYHS_Account_Transaction_Type");
    fourthLabel.textColor       = kGray777777;
    fourthLabel.font            = kLabelTitleFont;
    CGSize fourthSize = [self giveLabelWith:fourthLabel.font
                                   nsstring:fourthLabel.text];

    [fourthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(fourthSize.width + 1));
        make.height.equalTo(@(fourthSize.height + 1));
        make.centerX.mas_equalTo(fourthView.centerX);
        make.centerY.equalTo(fourthView.mas_centerY).offset(kDeviceProportion(-2));
    }];
}

/**
 *  给自定义的label设定字体和尺寸
 *
 *  @param fnt    字体大小
 *  @param string 文字内容
 *
 *  @return 返回label尺寸
 */
- (CGSize)giveLabelWith:(UIFont *)fnt nsstring:(NSString *)string
{
    UILabel *label = [[UILabel alloc] init];

    label.text = string;


    return [label.text
            sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil]];
}

@end

