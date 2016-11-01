//
//  GYHSGeneralDetailCheckCell.m
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/2.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSGeneralDetailCheckCell.h"

#define kCommonRemoveTag 665
static NSString *const GYTableViewCellID = @"GYHSGeneralDetailCheckCell";

@implementation GYHSGeneralDetailCheckCell

/**
 *  通用的创建方法
 *
 *  @param tableView 表视图
 *
 *  @return 返回自身对象
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    GYHSGeneralDetailCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:GYTableViewCellID];
    if (!cell)
    {
        cell = [[GYHSGeneralDetailCheckCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier :GYTableViewCellID];
    }
    return cell;
}

//生成五个细节子标题
#pragma mark-----生成五个细节单元的表
- (instancetype)createNeedCustomWithFiveLabels:(NSString *)stringOne string:(NSString *)stringTwo string:(NSString *)stringThree string:(NSString *)stringFour string:(NSString *)stringFive
{
    for (int i = 0; i < 5; i++)
    {
        UIView *view = [self.contentView
                        viewWithTag:kCommonRemoveTag];
        if (view)
        {
            [view removeFromSuperview];
        }
    }

    UIView *view1 = [[UIView alloc] init];
    view1.tag             = kCommonRemoveTag;
    view1.backgroundColor = kDefaultVCBackgroundColor; //自定义下颜色然后再设置
    [self.contentView
     addSubview:view1];

    @weakify(self);

    [view1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.bottom.equalTo(self.contentView).mas_equalTo(0);
        make.width.mas_equalTo(kDeviceProportion(140));
    }];

    UILabel *uplabel1 = [[UILabel alloc] init];
    [view1 addSubview:uplabel1];
    uplabel1.text      = stringOne;
    uplabel1.textColor = kGray333333;
    uplabel1.font      = kFont24;
    CGSize sizelabel1 = [self giveLabelWith:uplabel1.font
                                   nsstring:uplabel1.text];

    CGFloat nameH1 = sizelabel1.height;


    [uplabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view1.mas_left);
        make.centerY.equalTo(view1.mas_centerY);
        make.width.equalTo(view1.mas_width);
        make.height.equalTo(@(nameH1));
    }];
    uplabel1.textAlignment   = NSTextAlignmentCenter;
    uplabel1.backgroundColor = [UIColor clearColor];



    UIView *view2 = [[UIView alloc] init];
    view2.tag             = kCommonRemoveTag;
    view2.backgroundColor = kDefaultVCBackgroundColor; //自定义下颜色然后再设置
    [self.contentView
     addSubview:view2];

    // @weakify(self);

    [view2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(view1.mas_right);
        make.top.bottom.equalTo(self.contentView).mas_equalTo(0);

        make.width.mas_equalTo(kDeviceProportion(150));
    }];

    UILabel *uplabel2 = [[UILabel alloc] init];
    [view2 addSubview:uplabel2];
    uplabel2.text      = stringTwo;
    uplabel2.textColor = kGray333333;
    uplabel2.font      = kFont24;
    CGSize sizelabel2 = [self giveLabelWith:uplabel2.font
                                   nsstring:uplabel2.text];

    CGFloat nameH2 = sizelabel2.height;
    

    [uplabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view2.mas_left);
        make.centerY.equalTo(view2.mas_centerY);
        make.width.equalTo(view2.mas_width);
        make.height.equalTo(@(nameH2));
    }];
    uplabel2.textAlignment   = NSTextAlignmentCenter;
    uplabel2.backgroundColor = [UIColor clearColor];

    //

    UIView *view3 = [[UIView alloc] init];
    view3.tag             = kCommonRemoveTag;
    view3.backgroundColor = kDefaultVCBackgroundColor; //自定义下颜色然后再设置
    [self.contentView
     addSubview:view3];

    // @weakify(self);

    [view3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(view2.mas_right);
        make.top.bottom.equalTo(self.contentView).mas_equalTo(0);

        make.width.mas_equalTo(kDeviceProportion(150));
    }];

    UILabel *uplabel3 = [[UILabel alloc] init];
    [view3 addSubview:uplabel3];
    uplabel3.text      = stringThree;
    uplabel3.textColor = kGray333333;
    uplabel3.font      = kFont24;
    CGSize sizelabel3 = [self giveLabelWith:uplabel3.font
                                   nsstring:uplabel3.text];

    CGFloat nameH3 = sizelabel3.height;
    //CGFloat nameW1 = sizelabel.width;

    [uplabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view3.mas_left);
        make.centerY.equalTo(view3.mas_centerY);
        make.width.equalTo(view3.mas_width);
        make.height.equalTo(@(nameH3));
    }];
    uplabel3.textAlignment   = NSTextAlignmentCenter;
    uplabel3.backgroundColor = [UIColor clearColor];

    //

    UIView *view4 = [[UIView alloc] init];
    view4.tag             = kCommonRemoveTag;
    view4.backgroundColor = kDefaultVCBackgroundColor; //自定义下颜色然后再设置
    [self.contentView
     addSubview:view4];

    // @weakify(self);

    [view4 mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(view3.mas_right);
        make.top.bottom.equalTo(self.contentView).mas_equalTo(0);

        make.width.mas_equalTo(kDeviceProportion(150));
    }];

    UILabel *uplabel4 = [[UILabel alloc] init];
    [view4 addSubview:uplabel4];
    uplabel4.text      = stringFour;
    uplabel4.textColor = kGray333333;
    uplabel4.font      = kFont24;
    CGSize sizelabel4 = [self giveLabelWith:uplabel4.font
                                   nsstring:uplabel4.text];

    CGFloat nameH4 = sizelabel4.height;
    //CGFloat nameW1 = sizelabel.width;

    [uplabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view4.mas_left);
        make.centerY.equalTo(view4.mas_centerY);
        make.width.equalTo(view4.mas_width);
        make.height.equalTo(@(nameH4));
    }];
    uplabel4.textAlignment   = NSTextAlignmentCenter;
    uplabel4.backgroundColor = [UIColor clearColor];

    //5

    UIView *view5 = [[UIView alloc] init];
    view5.tag             = kCommonRemoveTag;
    view5.backgroundColor = kDefaultVCBackgroundColor; //自定义下颜色然后再设置
    [self.contentView
     addSubview:view5];

    // @weakify(self);

    [view5 mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(view4.mas_right);
        make.top.bottom.right.equalTo(self.contentView).mas_equalTo(0);
    }];

    UILabel *uplabel5 = [[UILabel alloc] init];
    [view5 addSubview:uplabel5];
    uplabel5.text      = stringFive;
    uplabel5.textColor = kGray333333;
    uplabel5.font      = kFont24;
    CGSize sizelabel5 = [self giveLabelWith:uplabel5.font
                                   nsstring:uplabel5.text];

    CGFloat nameH5 = sizelabel5.height;


    [uplabel5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view5.mas_left);
        make.centerY.equalTo(view5.mas_centerY);
        make.width.equalTo(view5.mas_width);
        make.height.equalTo(@(nameH5));
    }];
    uplabel5.textAlignment   = NSTextAlignmentCenter;
    uplabel5.backgroundColor = [UIColor clearColor];

    return self;
}

#pragma mark-----生成四个细节单元的表
- (instancetype)createNeedCustomWithFourLabels:(NSString *)stringOne string:(NSString *)stringTwo string:(NSString *)stringThree string:(NSString *)stringFour
{
    for (int i = 0; i < 4; i++)
    {
        UIView *view = [self.contentView
                        viewWithTag:kCommonRemoveTag];
        if (view)
        {
            [view removeFromSuperview];
        }
    }
    UIView *view1 = [[UIView alloc] init];
    view1.tag             = kCommonRemoveTag;
    view1.backgroundColor = kDefaultVCBackgroundColor; //自定义下颜色然后再设置
    [self.contentView
     addSubview:view1];

    @weakify(self);

    [view1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.bottom.equalTo(self.contentView).mas_equalTo(0);
        make.width.mas_equalTo(kDeviceProportion(190));
    }];

    UILabel *uplabel1 = [[UILabel alloc] init];
    [view1 addSubview:uplabel1];
    uplabel1.text      = stringOne;
    uplabel1.textColor = kGray333333;
    uplabel1.font      = kFont24;
    CGSize sizelabel1 = [self giveLabelWith:uplabel1.font
                                   nsstring:uplabel1.text];

    CGFloat nameH1 = sizelabel1.height;
    //CGFloat nameW1 = sizelabel.width;

    [uplabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view1.mas_left);
        make.centerY.equalTo(view1.mas_centerY);
        make.width.equalTo(view1.mas_width);
        make.height.equalTo(@(nameH1));
    }];
    uplabel1.textAlignment   = NSTextAlignmentCenter;
    uplabel1.backgroundColor = [UIColor clearColor];



    UIView *view2 = [[UIView alloc] init];
    view2.tag             = kCommonRemoveTag;
    view2.backgroundColor = kDefaultVCBackgroundColor; //自定义下颜色然后再设置
    [self.contentView
     addSubview:view2];



    [view2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(view1.mas_right);
        make.top.bottom.equalTo(self.contentView).mas_equalTo(0);

        make.width.mas_equalTo(kDeviceProportion(200));
    }];

    UILabel *uplabel2 = [[UILabel alloc] init];
    [view2 addSubview:uplabel2];
    uplabel2.text      = stringTwo;
    uplabel2.textColor = kGray333333;
    uplabel2.font      = kFont24;
    CGSize sizelabel2 = [self giveLabelWith:uplabel2.font
                                   nsstring:uplabel2.text];

    CGFloat nameH2 = sizelabel2.height;


    [uplabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view2.mas_left);
        make.centerY.equalTo(view2.mas_centerY);
        make.width.equalTo(view2.mas_width);
        make.height.equalTo(@(nameH2));
    }];
    uplabel2.textAlignment   = NSTextAlignmentCenter;
    uplabel2.backgroundColor = [UIColor clearColor];

    //

    UIView *view3 = [[UIView alloc] init];
    view3.tag             = kCommonRemoveTag;
    view3.backgroundColor = kDefaultVCBackgroundColor; //自定义下颜色然后再设置
    [self.contentView
     addSubview:view3];

    [view3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(view2.mas_right);
        make.top.bottom.equalTo(self.contentView).mas_equalTo(0);

        make.width.mas_equalTo(kDeviceProportion(200));
    }];

    UILabel *uplabel3 = [[UILabel alloc] init];
    [view3 addSubview:uplabel3];
    uplabel3.text      = stringThree;
    uplabel3.textColor = kGray333333;
    uplabel3.font      = kFont24;
    CGSize sizelabel3 = [self giveLabelWith:uplabel3.font
                                   nsstring:uplabel3.text];

    CGFloat nameH3 = sizelabel3.height;


    [uplabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view3.mas_left);
        make.centerY.equalTo(view3.mas_centerY);
        make.width.equalTo(view3.mas_width);
        make.height.equalTo(@(nameH3));
    }];
    uplabel3.textAlignment   = NSTextAlignmentCenter;
    uplabel3.backgroundColor = [UIColor clearColor];

    //

    UIView *view4 = [[UIView alloc] init];
    view4.tag             = kCommonRemoveTag;
    view4.backgroundColor = kDefaultVCBackgroundColor; //自定义下颜色然后再设置
    [self.contentView
     addSubview:view4];

    [view4 mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(view3.mas_right);
        make.top.bottom.right.equalTo(self.contentView).mas_equalTo(0);
    }];

    UILabel *uplabel4 = [[UILabel alloc] init];
    [view4 addSubview:uplabel4];
    uplabel4.text      = stringFour;
    uplabel4.textColor = kGray333333;
    uplabel4.font      = kFont24;
    CGSize sizelabel4 = [self giveLabelWith:uplabel4.font
                                   nsstring:uplabel4.text];

    CGFloat nameH4 = sizelabel4.height;

    [uplabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view4.mas_left);
        make.centerY.equalTo(view4.mas_centerY);
        make.width.equalTo(view4.mas_width);
        make.height.equalTo(@(nameH4));
    }];
    uplabel4.textAlignment   = NSTextAlignmentCenter;
    uplabel4.backgroundColor = [UIColor clearColor];

    return self;
}

#pragma mark-----生成六个细节单元的表
- (instancetype)createNeedCustomWithSixLabels:(NSString *)stringOne string:(NSString *)stringTwo string:(NSString *)stringThree string:(NSString *)stringFour string:(NSString *)stringFive string:(NSString *)stringSix
{
    for (int i = 0; i < 6; i++)
    {
        UIView *view = [self.contentView
                        viewWithTag:kCommonRemoveTag];
        if (view)
        {
            [view removeFromSuperview];
        }
    }
    UIView *view1 = [[UIView alloc] init];
    view1.tag             = kCommonRemoveTag;
    view1.backgroundColor = kDefaultVCBackgroundColor; //自定义下颜色然后再设置
    [self.contentView
     addSubview:view1];

    @weakify(self);

    [view1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.bottom.equalTo(self.contentView).mas_equalTo(0);
        make.width.mas_equalTo(kDeviceProportion(140));
    }];

    UILabel *uplabel1 = [[UILabel alloc] init];
    [view1 addSubview:uplabel1];
    uplabel1.text      = stringOne;
    uplabel1.textColor = kGray333333;
    uplabel1.font      = kFont24;
    CGSize sizelabel1 = [self giveLabelWith:uplabel1.font
                                   nsstring:uplabel1.text];

    CGFloat nameH1 = sizelabel1.height;
    

    [uplabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view1.mas_left);
        make.centerY.equalTo(view1.mas_centerY);
        make.width.equalTo(view1.mas_width);
        make.height.equalTo(@(nameH1));
    }];
    uplabel1.textAlignment   = NSTextAlignmentCenter;
    uplabel1.backgroundColor = [UIColor clearColor];

    UIView *view2 = [[UIView alloc] init];
    view2.tag             = kCommonRemoveTag;
    view2.backgroundColor = kDefaultVCBackgroundColor; //自定义下颜色然后再设置
    [self.contentView
     addSubview:view2];

    // @weakify(self);

    [view2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(view1.mas_right);
        make.top.bottom.equalTo(self.contentView).mas_equalTo(0);

        make.width.mas_equalTo(kDeviceProportion(150));
    }];

    UILabel *uplabel2 = [[UILabel alloc] init];
    [view2 addSubview:uplabel2];
    uplabel2.text      = stringTwo;
    uplabel2.textColor = kGray333333;
    uplabel2.font      = kFont24;
    CGSize sizelabel2 = [self giveLabelWith:uplabel2.font
                                   nsstring:uplabel2.text];

    CGFloat nameH2 = sizelabel2.height;
    

    [uplabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view2.mas_left);
        make.centerY.equalTo(view2.mas_centerY);
        make.width.equalTo(view2.mas_width);
        make.height.equalTo(@(nameH2));
    }];
    uplabel2.textAlignment   = NSTextAlignmentCenter;
    uplabel2.backgroundColor = [UIColor clearColor];

    //

    UIView *view3 = [[UIView alloc] init];
    view3.tag             = kCommonRemoveTag;
    view3.backgroundColor = kDefaultVCBackgroundColor; //自定义下颜色然后再设置
    [self.contentView
     addSubview:view3];

    // @weakify(self);

    [view3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(view2.mas_right);
        make.top.bottom.equalTo(self.contentView).mas_equalTo(0);

        make.width.mas_equalTo(kDeviceProportion(150));
    }];

    UILabel *uplabel3 = [[UILabel alloc] init];
    [view3 addSubview:uplabel3];
    uplabel3.text      = stringThree;
    uplabel3.textColor = kGray333333;
    uplabel3.font      = kFont24;
    CGSize sizelabel3 = [self giveLabelWith:uplabel3.font
                                   nsstring:uplabel3.text];

    CGFloat nameH3 = sizelabel3.height;
    //CGFloat nameW1 = sizelabel.width;

    [uplabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view3.mas_left);
        make.centerY.equalTo(view3.mas_centerY);
        make.width.equalTo(view3.mas_width);
        make.height.equalTo(@(nameH3));
    }];
    uplabel3.textAlignment   = NSTextAlignmentCenter;
    uplabel3.backgroundColor = [UIColor clearColor];

    //

    UIView *view4 = [[UIView alloc] init];
    view4.tag             = kCommonRemoveTag;
    view4.backgroundColor = kDefaultVCBackgroundColor; //自定义下颜色然后再设置
    [self.contentView
     addSubview:view4];

    // @weakify(self);

    [view4 mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(view3.mas_right);
        make.top.bottom.equalTo(self.contentView).mas_equalTo(0);

        make.width.mas_equalTo(kDeviceProportion(184.5));
    }];

    UILabel *uplabel4 = [[UILabel alloc] init];
    [view4 addSubview:uplabel4];
    uplabel4.text      = stringFour;
    uplabel4.textColor = kGray333333;
    uplabel4.font      = kFont24;
    CGSize sizelabel4 = [self giveLabelWith:uplabel4.font
                                   nsstring:uplabel4.text];

    CGFloat nameH4 = sizelabel4.height;
    //CGFloat nameW1 = sizelabel.width;

    [uplabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view4.mas_left);
        make.centerY.equalTo(view4.mas_centerY);
        make.width.equalTo(view4.mas_width);
        make.height.equalTo(@(nameH4));
    }];
    uplabel4.textAlignment   = NSTextAlignmentCenter;
    uplabel4.backgroundColor = [UIColor clearColor];


    //5

    UIView *view5 = [[UIView alloc] init];
    view5.tag             = kCommonRemoveTag;
    view5.backgroundColor = kDefaultVCBackgroundColor; //自定义下颜色然后再设置
    [self.contentView
     addSubview:view5];

    // @weakify(self);

    [view5 mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(view4.mas_right);
        make.top.bottom.equalTo(self.contentView).mas_equalTo(0);

        make.width.mas_equalTo(kDeviceProportion(184.5));
    }];

    UILabel *uplabel5 = [[UILabel alloc] init];
    [view5 addSubview:uplabel5];
    uplabel5.text      = stringFive;
    uplabel5.textColor = kGray333333;
    uplabel5.font      = kFont24;
    CGSize sizelabel5 = [self giveLabelWith:uplabel5.font
                                   nsstring:uplabel5.text];

    CGFloat nameH5 = sizelabel5.height;


    [uplabel5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view5.mas_left);
        make.centerY.equalTo(view5.mas_centerY);
        make.width.equalTo(view5.mas_width);
        make.height.equalTo(@(nameH5));
    }];
    uplabel5.textAlignment   = NSTextAlignmentCenter;
    uplabel5.backgroundColor = [UIColor clearColor];


    //6

    UIView *view55 = [[UIView alloc] init];
    view55.tag             = kCommonRemoveTag;
    view55.backgroundColor = kDefaultVCBackgroundColor; //自定义下颜色然后再设置
    [self.contentView
     addSubview:view55];


    [view55 mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(view5.mas_right);
        make.top.bottom.right.equalTo(self.contentView).mas_equalTo(0);
    }];

    UILabel *uplabel55 = [[UILabel alloc] init];
    [view55 addSubview:uplabel55];
    uplabel55.text      = stringSix;
    uplabel55.textColor = kGray333333;
    uplabel55.font      = kFont24;
    CGSize sizelabel55 = [self giveLabelWith:uplabel55.font
                                    nsstring:uplabel55.text];

    CGFloat nameH55 = sizelabel55.height;

    [uplabel55 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view55.mas_left);
        make.centerY.equalTo(view55.mas_centerY);
        make.width.equalTo(view55.mas_width);
        make.height.equalTo(@(nameH55));
    }];
    uplabel55.textAlignment   = NSTextAlignmentCenter;
    uplabel55.backgroundColor = [UIColor clearColor];

    return self;
}

//得到label尺寸(根据内容字体)
- (CGSize)giveLabelWith:(UIFont *)fnt nsstring:(NSString *)string
{
    UILabel *label = [[UILabel alloc] init];

    label.text = string;


    return [label.text
            sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil]];
}

@end
